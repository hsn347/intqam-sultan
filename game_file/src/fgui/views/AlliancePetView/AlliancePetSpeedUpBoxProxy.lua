local CommonSpeedUpBoxProxy = include_fgui("CommonSpeedUpBoxProxy")
local AlliancePetSpeedUpBoxProxy = class("AlliancePetSpeedUpBoxProxy", CommonSpeedUpBoxProxy)
function AlliancePetSpeedUpBoxProxy:onRegisterEvent()
	AlliancePetSpeedUpBoxProxy.super.onRegisterEvent(self)
	print("=======AlliancePetSpeedUpBoxProxy:onRegisterEvent")
end
return AlliancePetSpeedUpBoxProxy
