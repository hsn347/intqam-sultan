local baseProxy = require("fgui.base.baseProxy")
local SnowWolfLostRewardProxy = class("SnowWolfLostRewardProxy", baseProxy)
function SnowWolfLostRewardProxy:onRegisterEvent()
	print("=======SnowWolfLostRewardProxy:onRegisterEvent")
end
return SnowWolfLostRewardProxy
