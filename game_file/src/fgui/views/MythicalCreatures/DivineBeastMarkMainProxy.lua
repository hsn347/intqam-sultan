local baseProxy = require("fgui.base.baseProxy")
local DivineBeastMarkMainProxy = class("DivineBeastMarkMainProxy", baseProxy)
function DivineBeastMarkMainProxy:onRegisterEvent()
	print("=======DivineBeastMarkMainProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UPDATE_DIVINEBEAST_MARK", handler(self, self.onMarkUpdate))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.onItemUpdate))
end
function DivineBeastMarkMainProxy:onMarkUpdate(target, data)
	dump(data, "DivineBeastMarkBagProxy:onMarkUpdate")
	if data.type == "upgrade" or data.type == "element" or data.type == "lock" or data.type == "star" or data.type == "modify" or data.type == "set" or data.type == "refine" then
		self.view:updateMark(data.bagMarkId, data.type == "set")
		self.view:updateElements()
		self.view:updateExp()
	elseif data.type == "mount" or data.type == "dismount" then
		self.view:updateMark(data.bagMarkId)
		self.view:updateElements()
	elseif data.type == "bag" or data.type == "recycle" or data.type == "change" then
		self.view:updateView()
	elseif data.type == "exp" then
		self.view:updateExp()
	elseif data.type == "rename" then
		self.view:updateGroupName()
	elseif data.type == "reward" then
		self.view:updateBtn()
	end
	if data.type == "upgrade" or data.type == "element" or data.type == "star" or data.type == "modify" or data.type == "mount" or data.type == "dismount" or data.type == "rename" or data.type == "useSetChange" or data.type == "refine" then
		self.view:resetComboBoxTitle()
	end
end
function DivineBeastMarkMainProxy:onItemUpdate(target, data)
	self.view:updateExp()
end
return DivineBeastMarkMainProxy
