local cdefs = include("client_defs")
local cell_rig = include("gameplay/cellrig")

local _refresh = cell_rig.refresh

function cell_rig:refresh()
    if multiMod:isCounterintel() then   -- basically the original function, sans the watched conditions
        local isUnknownCell = upvalueUtil.find(_refresh, "isUnknownCell")
        local scell = self._boardRig:getLastKnownCell( self._x, self._y )
        local rawcell = self._game.simCore:getCell( self._x, self._y )
        if rawcell ~= nil then
            local orientation = self._boardRig._game:getCamera():getOrientation()

            local idx = cdefs.BLACKOUT_CELL
            local flags = MOAIGridSpace.TILE_HIDE

            local gfxOptions = self._game:getGfxOptions()
            if gfxOptions.bMainframeMode then
                if scell then
                    idx, flags = cdefs.MAINFRAME_CELL + orientation, 0
                elseif isUnknownCell( self._boardRig, rawcell ) then
                    idx, flags = cdefs.MAINFRAME_UNKNOWN_CELL, 0
                end

            elseif rawcell.tileIndex ~= cdefs.TILE_UNKNOWN and scell == nil then
                if isUnknownCell( self._boardRig, rawcell ) then
                    idx, flags = cdefs.UNKNOWN_CELL, 0
                end

            elseif gfxOptions.bTacticalView then
                idx, flags = cdefs.SAFE_CELL, 0
                            
            else
                local mapTile = cdefs.MAPTILES[ rawcell.tileIndex ]
                idx = mapTile.tileStart + (self._x-1 + self._y-1) % mapTile.patternLen
                flags = 0
            end
            self._boardRig._grid:getGrid():setTile( self._x, self._y, idx )
            self._boardRig._grid:getGrid():setTileFlags( self._x, self._y, flags )
        end
    else
        _refresh(self)
    end
end
