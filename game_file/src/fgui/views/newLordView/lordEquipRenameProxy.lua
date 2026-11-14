local baseProxy = require("fgui.base.baseProxy")
local lordEquipRenameProxy = class("lordEquipRenameProxy", baseProxy)
function lordEquipRenameProxy:onRegisterEvent()
	print("=======lordEquipRenameProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_LORDINFO_NICKNAME_LEGALITY", handler(self, self.nickNameErr))
end
function lordEquipRenameProxy:nickNameErr(target, data)
	self.view:nickNameErr(target, data)
end
return lordEquipRenameProxy
