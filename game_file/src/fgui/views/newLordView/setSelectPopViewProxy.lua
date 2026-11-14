local baseProxy = require("fgui.base.baseProxy")
local setSelectPopViewProxy = class("setSelectPopViewProxy", baseProxy)
function setSelectPopViewProxy:onRegisterEvent()
	print("=======setSelectPopViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_SERVER_SKILL_SET_RENAME_BACK", handler(self, self.sMsgRenameBack))
	SoraDAddMessage(self, "MESSAGE_UI_WARGEM_RENAME", handler(self, self.sMsgRenameBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_SET_RENAME_BACK", handler(self, self.sMsgRenameBack))
end
function setSelectPopViewProxy:sMsgRenameBack(target, data)
	self.view:sMsgRenameBack(target, data)
end
return setSelectPopViewProxy
