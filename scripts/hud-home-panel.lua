local homePanel = include("hud/home_panel")
local mui_tooltip = include( "mui/mui_tooltip")
local util = include( "client_util" )

local panel = homePanel.panel

local refreshAgentOld = panel.refreshAgent
local refreshOld = panel.refresh

local function controllingPlayersTxt(multiMod, agentName)
    local playerAgentBindings = multiMod.playerAgentBindings
    local controllingPlayers = {}
    for player,agent in pairs(playerAgentBindings) do
        if multiMod:isControlled(agent, agentName) then
            controllingPlayers[#controllingPlayers+1] = "<c:F0FF78>"..player.."</c>"
        end
    end
    if #controllingPlayers > 0 then
        local controllingPlayersStr = table.concat(controllingPlayers, ", ")
        return STRINGS.MULTI_MOD.PLAYED_BY_TOOLTIP_SUFFIX .. controllingPlayersStr
    else
        return ""
    end
end

function panel:refreshAgent( unit )
    refreshAgentOld(self, unit)
    local widget = self:findAgentWidget( unit:getID() )
	if widget == nil then
		return
	end
    if self._hud and self._hud._game and self._hud._game._multiMod then
        local multiMod = self._hud._game._multiMod
        widget:setTooltip(mui_tooltip(
            util.toupper(unit:getName()),
            unit:getUnitData().toolTip .. controllingPlayersTxt(multiMod, unit:getName()),
            "cycleSelection"
        ))
    end
end

function panel:refresh()
    refreshOld(self)
    local item = self._panel_top.binder.incognitaBtn
    if self._hud and self._hud._game and self._hud._game._multiMod then
        local multiMod = self._hud._game._multiMod
        item:setTooltip(mui_tooltip(
            STRINGS.UI.INCOGNITA_NAME,
            STRINGS.UI.INCOGNITA_TT .. controllingPlayersTxt(multiMod, "Incognita"),
            "mainframeMode"
        ))
    end
end
