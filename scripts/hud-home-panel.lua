local homePanel = include("hud/home_panel")
local mui_tooltip = include( "mui/mui_tooltip")
local util = include( "client_util" )

local panel = homePanel.panel

local refreshAgentOld = panel.refreshAgent
local refreshOld = panel.refresh

function panel:refreshAgent( unit )
    refreshAgentOld(self, unit)
    local widget = self:findAgentWidget( unit:getID() )
	if widget == nil then
		return
	end
    local controllingPlayersTxt = multiMod:controllingPlayersTxt(unit:getName(), "F0FF78")
    if controllingPlayersTxt ~= "" then
        widget._tooltip._bodyTxt = widget._tooltip._bodyTxt .. STRINGS.MULTI_MOD.PLAYED_BY_TOOLTIP_SUFFIX .. controllingPlayersTxt
    end
end

function panel:refresh()
    refreshOld(self)
    local item = self._panel_top.binder.incognitaBtn
    local controllingPlayersTxt = multiMod:controllingPlayersTxt("Incognita", "F0FF78")
    if controllingPlayersTxt ~= "" then
        item._tooltip._bodyTxt = item._tooltip._bodyTxt .. STRINGS.MULTI_MOD.PLAYED_BY_TOOLTIP_SUFFIX .. controllingPlayersTxt
    end
end
