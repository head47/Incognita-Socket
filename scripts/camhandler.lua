local camhandler = include("gameplay/camhandler")

local _isManualCam = camhandler.isManualCam

function camhandler:isManualCam()
    if multiMod:isCounterintel() then
        return true
    end
    return _isManualCam(self)
end
