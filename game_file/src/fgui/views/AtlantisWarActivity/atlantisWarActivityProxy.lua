local baseProxy = require("fgui.base.baseProxy")
local atlantisWarActivityProxy = class("atlantisWarActivityProxy", baseProxy)
function atlantisWarActivityProxy:onRegisterEvent()
	print("=======atlantisWarActivityProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", function()
		self.view:updateShopRed()
		self.view:updateSkillRed()
	end)
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_REFRESH", handler(self, self.msgDataReqBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.msgCallBack))
	SoraDAddMessage(self, "MESSAGE_ATLANTISWAR_PRIVILEGE_REFRESH", handler(self, self.onMsgUpdatePrivilege))
end
function atlantisWarActivityProxy:msgDataReqBack(...)
	self.view:msgDataReqBack(...)
end
function atlantisWarActivityProxy:msgCallBack(target, data)
	if not clientEventMgr.judgeIsOpen(self.view.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self.view)
	else
		self.view:updatePrivilegeBtn()
	end
end
function atlantisWarActivityProxy:onMsgUpdatePrivilege(...)
	self.view:onMsgUpdatePrivilege(...)
end
return atlantisWarActivityProxy
