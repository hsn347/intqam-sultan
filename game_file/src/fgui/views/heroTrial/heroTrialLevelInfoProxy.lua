local baseProxy = require("fgui.base.baseProxy")
local heroTrialLevelInfoProxy = class("heroTrialLevelInfoProxy", baseProxy)
function heroTrialLevelInfoProxy:onRegisterEvent()
	print("=======heroTrialLevelInfoProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRIAL_RSP", handler(self, self.handleRsp))
	SoraDAddMessage(self, "MESSAGE_LORDVALUE_VIP", handler(self, self.updateAutoVip))
end
function heroTrialLevelInfoProxy:handleRsp(target, data)
	self.view:handleRsp(target, data)
end
function heroTrialLevelInfoProxy:updateAutoVip(target, data)
	self.view:updateAutoVip(target, data)
end
return heroTrialLevelInfoProxy
