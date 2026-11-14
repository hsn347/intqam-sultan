local baseProxy = require("fgui.base.baseProxy")
local taskRushRewardProxy = class("taskRushRewardProxy", baseProxy)
function taskRushRewardProxy:onRegisterEvent()
	print("=======taskRushRewardProxy:onRegisterEvent")
end
return taskRushRewardProxy
