local baseProxy = require("fgui.base.baseProxy")
local mailGivePresentProxy = class("mailGivePresentProxy", baseProxy)
function mailGivePresentProxy:onRegisterEvent()
	print("=======mailGivePresentProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_MAIL_UI_GIVE_PRESENT_ITEM_SELECTED", handler(self, self.msgGivePresentItemSelected))
	SoraDAddMessage(self, "MESSAGE_MAIL_UI_GIVE_PRESENT_PEOPLE_SELECTED", handler(self, self.msgGivePresentPeopleSelected))
	SoraDAddMessage(self, "MESSAGE_SERVER_MAIL_GIVE_PRESENT_SUCCESS", handler(self, self.sMsgGivePresentSuccess))
	SoraDAddMessage(self, "MESSAGE_UI_ITEM_CLICK", handler(self, self.operateGivePanel))
end
function mailGivePresentProxy:sMsgGivePresentSuccess(target, data)
	self.view:sMsgGivePresentSuccess(target, data)
end
function mailGivePresentProxy:operateGivePanel(target, data)
	self.view:operateGivePanel(target, data)
end
function mailGivePresentProxy:msgGivePresentItemSelected(target, data)
	self.view:msgGivePresentItemSelected(target, data)
end
function mailGivePresentProxy:msgGivePresentPeopleSelected(target, data)
	self.view:msgGivePresentPeopleSelected(target, data)
end
return mailGivePresentProxy
