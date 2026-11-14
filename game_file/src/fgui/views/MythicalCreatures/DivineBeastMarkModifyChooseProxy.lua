local baseProxy = require("fgui.base.baseProxy")
local divineBeastMarkCtrl = SoraDGetCtrl("divineBeastMarkCtrl")
local DivineBeastMarkModifyChooseProxy = class("DivineBeastMarkModifyChooseProxy", baseProxy)
function DivineBeastMarkModifyChooseProxy:onRegisterEvent()
	print("=======DivineBeastMarkModifyChooseProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UPDATE_DIVINEBEAST_MARK", handler(self, self.onMarkUpdate))
end
function DivineBeastMarkModifyChooseProxy:onMarkUpdate(target, data)
	dump(data, "DivineBeastMarkModifyChooseProxy:onMarkUpdate")
	if data.type == "upgrade" or data.type == "element" or data.type == "lock" or data.type == "star" or data.type == "modify" or data.type == "refine" then
		local mark = divineBeastMarkCtrl:getMarkByBagMarkId(data.bagMarkId)
		self.view:initData(mark)
	end
end
return DivineBeastMarkModifyChooseProxy
