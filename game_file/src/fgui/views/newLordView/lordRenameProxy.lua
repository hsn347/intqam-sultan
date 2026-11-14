local baseProxy = require("fgui.base.baseProxy")
local lordRenameProxy = class("lordRenameProxy", baseProxy)
function lordRenameProxy:onRegisterEvent()
	print("=======lordRenameProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_LORDINFO_NICKNAME_LEGALITY", handler(self, self.nickNameErr))
end
function lordRenameProxy:nickNameErr(target, data)
	self.view:nickNameErr(target, data)
end
return lordRenameProxy
