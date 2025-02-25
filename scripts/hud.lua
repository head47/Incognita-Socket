local hud = include( "hud/hud" )
local cdefs = include( "client_defs" )
local mathutil = include("modules/mathutil")
local mui_defs = include("mui/mui_defs")
local mui_util = include("mui/mui_util")
local util = include("client_util")

local _refreshTimeAttack = hud.refreshTimeAttack
local _refreshHud = hud.refreshHud
local _init = hud.init
local _updateHud = hud.updateHud
local _onInputEvent = hud.onInputEvent
local _showMovementRange = hud.showMovementRange
local _updateIngameCursor

function hud:refreshTimeAttack()
	local chessTimeLeft = self._game.params.difficultyOptions.timeAttack - self._game.chessTimer
	if multiMod:hasYielded() and chessTimeLeft <= 10 * cdefs.SECONDS and chessTimeLeft % 60 == 0 and chessTimeLeft > 0 then
		return
	end
	
	_refreshTimeAttack(self)
end

function hud:refreshHud()
	_refreshHud(self)
	local sim = self._game.simCore
	local showPanels = (sim:getCurrentPlayer() == sim:getPC())
	self._endTurnButton:setVisible(showPanels and self:canShowElement( "endTurnBtn" ))
end

function hud:init(game)
	local _onHudTooltip, onHudTooltipIdx = upvalueUtil.find(_init, "onHudTooltip")
	local onHudTooltip = function( self, screen, wx, wy )
		local tooltip = _onHudTooltip(self, screen, wx, wy)
		wx, wy = screen:uiToWnd( wx, wy )
		local cellx, celly = self._game:wndToCell( wx, wy )
		local cell = cellx and celly and self._game.boardRig:getLastKnownCell( cellx, celly )
		if tooltip == nil then
			return tooltip
		end
		if multiMod:isCounterintel() then
			for sId, section in ipairs(tooltip._sections) do
				for _, child in ipairs(section._children) do
					if child.binder.desc and not child.binder.desc.isnull then
						local text = child.binder.desc:getText()
						if text and (string.find(text, STRINGS.UI.WATCHED, 1, true) or string.find(text, STRINGS.UI.NOTICED, 1, true) or string.find(text, STRINGS.UI.HIDDEN, 1, true)) then
							table.remove(tooltip._sections, sId)
							break
						end
					end
				end
			end
			if cell and cell.units then
				for _, cellUnit in ipairs(cell.units) do
					if
						cellUnit:getUnitData().onWorldTooltip
						and cellUnit:isPC()
						and not self._game.simCore:canPlayerSeeUnit(self._game.simCore:getNPC(), cellUnit)
					then
						for sId, section in ipairs(tooltip._sections) do
							for _, child in ipairs(section._children) do
								if child.binder.line and not child.binder.line.isnull then
									local text = child.binder.line:getText()
									if text and string.find(text, "<ttheader>"..util.toupper(cellUnit:getName()).."</>", 1, true) then
										table.remove(tooltip._sections, sId)
										break
									end
								end
							end
						end
					end
				end
			end
		end
		return tooltip
	end
	debug.setupvalue(_init, onHudTooltipIdx, onHudTooltip)
	_init(self, game)
end

function hud:updateHud()
	local _updateHudTooltip = upvalueUtil.find(_updateHud, "updateHudTooltip")
	local _updateIngameCursor_new, updateIngameCursorIdx = upvalueUtil.find(_updateHudTooltip, "updateIngameCursor")
	_updateIngameCursor = _updateIngameCursor or _updateIngameCursor_new
	local updateIngameCursor = function( self, sim, localPlayer )
		if multiMod:isCounterintel() then	-- basically the original function, sans the watched conditions
			if not self._hideCubeCursor and self._tooltipX then
				if not self._game.fxmgr:containsFx( self.selectFX ) then
					self.selectFX = self._game.fxmgr:addAnimFx({ x = 0, y = 0, kanim = "gui/selectioncubetest", symbol = "character", anim = "anim", loop = true, scale = 1.0 })
				end
				self.selectFX:setLoc( self._game:cellToWorld( self._tooltipX, self._tooltipY ))
				local cursorColor = util.color.GRAY
				if localPlayer then
					if self._revealCells then
						for _, cell in ipairs(self._revealCells) do
							if cell.x == self._tooltipX and cell.y == self._tooltipY then
								cursorColor = cdefs.MOVECLR_SNEAK
								break
							end
						end
					end
				end
				self.selectFX:setSymbolModulate( "Cursor", cursorColor:unpack() )
		
			else
				if self.selectFX then
					self._game.fxmgr:removeFx( self.selectFX )
					self.selectFX = nil
				end			
			end
		else
			_updateIngameCursor(self, sim, localPlayer)
		end
	end
	debug.setupvalue(_updateHudTooltip, updateIngameCursorIdx, updateIngameCursor)
	return _updateHud(self)
end

function hud:onInputEvent(event)
	local sim = self._game.simCore
	if multiMod:isCounterintel() and not self._isMainframe and self._state == 0 then
		if event.eventType == mui_defs.EVENT_MouseUp then
			if
				event.button == mui_defs.MB_Left
				and self._mouseDownX
				and mathutil.distSqr2d( event.wx, event.wy, self._mouseDownX, self._mouseDownY ) < 512
			then
				if not multiMod:hasYielded() then
					local selUnitOld = self._selection.selectedUnit
					_onInputEvent(self, event)
					if self._selection.selectedUnit ~= selUnitOld then
						multiMod:yield(multiMod.focusedPlayerIndex)
					end
				else
					MOAIFmodDesigner.playSound( "SpySociety/HUD/voice/level1/alarmvoice_warning" )
					self:showWarning(
						STRINGS.MULTI_MOD.NOT_YOUR_TURN_TITLE,
						{r=1,g=1,b=1,a=1},
						string.format(STRINGS.MULTI_MOD.NOT_YOUR_TURN_SUBTEXT, sim.currentClientName)
					)
				end
			elseif event.button == mui_defs.MB_Right then
				if sim then
					local selectedUnit = self:getSelectedUnit()
					local selectedUnitID = selectedUnit and selectedUnit:getID()
					if selectedUnitID then	-- yoinked from hud:doMoveUnit, CI can only set interest points within guard's AP
						local x, y = self._game:wndToCell( inputmgr:getMouseXY() )
						if selectedUnit:hasTrait("mp") and selectedUnit:canAct() then
							local startcell = sim:getCell( selectedUnit:getLocation() )
							local endcell = sim:getCell( x, y )
							if endcell then
								local tempImpassOff = {}	-- temporarily disable dynamicImpass to allow setting interest points directly on agents
								if endcell.units then
									for _, cellUnit in ipairs(endcell.units) do
										if cellUnit:getTraits().dynamicImpass then
											tempImpassOff[#tempImpassOff+1] = cellUnit
											cellUnit:getTraits().dynamicImpass = false
										end
									end
								end
								local moveTable, pathCost = sim:getQuery().findPath(sim, selectedUnit, startcell, endcell, math.max(15, selectedUnit:getMP()))
								if #tempImpassOff > 0 then
									for _, cellUnit in ipairs(tempImpassOff) do
										cellUnit:getTraits().dynamicImpass = true
									end
								end
								if moveTable then
									if pathCost <= selectedUnit:getMP() then
										self._game:doAction( "cheatAction", "simCreateInterest", selectedUnitID, x, y )
										if not multiMod:hasYielded() then
											multiMod:yield(multiMod.focusedPlayerIndex)
										end
										MOAIFmodDesigner.playSound( cdefs.SOUND_HUD_GAME_CONFIRM )
									else
										self:showWarning( STRINGS.UI.WARNING_NO_AP, {r=1,g=1,b=1,a=1}, STRINGS.MULTI_MOD.SET_INTEREST_WITHIN_MOVE_SUBTEXT )
										MOAIFmodDesigner.playSound("SpySociety/HUD/voice/level1/alarmvoice_warning")
									end
									return true
								else
									local checkcell = selectedUnit:getPlayerOwner():getCell(x,y)
									if not checkcell or not sim:getQuery().canPath(sim, selectedUnit, nil, checkcell) then
										self:showWarning( util.sformat( STRINGS.UI.WARNING_CANT_MOVE, selectedUnit:getName() ) )
										MOAIFmodDesigner.playSound( "SpySociety/HUD/voice/level1/alarmvoice_warning" )
									else
										self:showWarning( STRINGS.UI.WARNING_NO_PATH, {r=1,g=1,b=1,a=1} )
										MOAIFmodDesigner.playSound( "SpySociety/HUD/voice/level1/alarmvoice_warning" )
									end
									return true
								end
							end
						end
					end
				end
			else
				_onInputEvent(self, event)
			end
		elseif
			event.eventType == mui_defs.EVENT_KeyDown
			and mui_util.isBinding( event, util.getKeyBinding( "cycleSelection" ))
		then
			-- do nothing on Tab to prevent accidental selection of wrong guard
		else
			_onInputEvent(self, event)
		end
	else
		_onInputEvent(self, event)
	end
end

function hud:showMovementRange(unit)
	if unit and multiMod:isCounterintel() then
		local tempImpassOff = {}
		for _, impassUnit in pairs(self._game.simCore:getAllUnits()) do
			if
				impassUnit._x and impassUnit._y
				and mathutil.dist2d(unit._x, unit._y, impassUnit._x, impassUnit._y) < unit:getMP()
				and impassUnit:getTraits().dynamicImpass
			then
				tempImpassOff[#tempImpassOff+1] = impassUnit
				impassUnit:getTraits().dynamicImpass = false
			end
		end
		_showMovementRange(self, unit)
		for _, impassUnit in ipairs(tempImpassOff) do
			impassUnit:getTraits().dynamicImpass = true
		end
	else
		_showMovementRange(self, unit)
	end
end
