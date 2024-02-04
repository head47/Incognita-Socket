local homePanel = include("hud/home_panel")
local mui_tooltip = include( "mui/mui_tooltip")
local util = include( "client_util" )

local panel = homePanel.panel

local refreshAgentOld = panel.refreshAgent
local refreshOld = panel.refresh

local function controllingPlayersTxt(agentName)
    local playerAgentBindings = multiMod.playerAgentBindings
    if not playerAgentBindings then
        return ""
    end
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
    widget._tooltip._bodyTxt = widget._tooltip._bodyTxt .. controllingPlayersTxt(unit:getName())
end

function panel:refresh()
    refreshOld(self)
    local item = self._panel_top.binder.incognitaBtn
    item._tooltip._bodyTxt = item._tooltip._bodyTxt .. controllingPlayersTxt("Incognita")
end
