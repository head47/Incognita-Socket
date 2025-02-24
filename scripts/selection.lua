local cdefs = include("client_defs")
local selection = include("hud/selection")

local _selectInitialUnit = selection.selectInitialUnit

function selection:selectInitialUnit()
    if multiMod:isCounterintel() then
        local sim = self.game.simCore
        -- Selects the first valid (non-KO) unit of the local player, or nil otherwise.
        local selectUnit = sim:getUnit( self.lastSelectedUnitID )
        if selectUnit and self:canSelect( selectUnit ) and not selectUnit:isKO() then
            return selectUnit -- Last selected unit still OK.
        end

        if self.game:getLocalPlayer() and not sim:getTags().isTutorial then
            multiMod:selectRandomGuard()
            selectUnit = sim:getUnit( self.lastSelectedUnitID )
            if selectUnit then
                MOAIFmodDesigner.playSound( cdefs.SOUND_HUD_GAME_SELECT_UNIT )
                self.game:getCamera():fitOnscreen( self.game:cellToWorld( selectUnit:getLocation() ))
            end

            return selectUnit
        end
    else
        _selectInitialUnit(self)
    end
end
