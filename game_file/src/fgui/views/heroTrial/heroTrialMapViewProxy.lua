local baseProxy = require("fgui.base.baseProxy")
local heroTrialMapViewProxy = class("heroTrialMapViewProxy", baseProxy)
function heroTrialMapViewProxy:onRegisterEvent()
	print("=======heroTrialMapViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRIAL_POINT_UPDATE", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRIAL_MAPINFO", handler(self, self.updatePraisePanel))
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRIAL_RSP", handler(self, self.handleRsp))
	SoraDAddMessage(self, "MESSAGE_UI_HEROTRIAL_NEED_OPEN", handler(self, self.onNeedOpen))
	SoraDAddMessage(self, "MESSAGE_LORDVALUE_VIP", handler(self, self.setAutoState))
end
function heroTrialMapViewProxy:updateData(target, data)
	self.view:updateData(target, data)
end
function heroTrialMapViewProxy:updatePraisePanel(target, data)
	self.view:updatePraisePanel(target, data)
end
function heroTrialMapViewProxy:handleRsp(target, data)
	self.view:handleRsp(target, data)
end
function heroTrialMapViewProxy:onNeedOpen(target, data)
	self.view:onNeedOpen(target, data)
end
function heroTrialMapViewProxy:setAutoState(target, data)
	self.view:setAutoState()
end
return heroTrialMapViewProxy
