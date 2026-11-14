local baseProxy = require("fgui.base.baseProxy")
local lordEquipViewProxy = class("lordEquipViewProxy", baseProxy)
function lordEquipViewProxy:onRegisterEvent()
	print("=======lordEquipViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UI_LORD_EQUIP_DETAIL", handler(self, self.updateEquipPop))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPDATE_BASE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_WEAR_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_SET_WEAR_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_UI_EQUIP_GET_SUCCESS", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_DISASSEMBLE_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_FORGE_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_LIMIT_TIMEOUT", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_SET_RESET_BACK", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_SET_ACTIVE_BACK", handler(self, self.sMsgEquipSetActiveBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_SET_RENAME_BACK", handler(self, self.sMsgEquipRenameBack))
	SoraDAddMessage(self, "MESSAGE_VIP_UPDATE", handler(self, self.sMsgUpdateVip))
end
function lordEquipViewProxy:updateEquipPop(target, data)
	self.view:updateEquipPop(target, data)
end
function lordEquipViewProxy:initData(target, data)
	self.view:initData(target, data)
end
function lordEquipViewProxy:updateView(target, data)
	self.view:updateView(target, data)
end
function lordEquipViewProxy:sMsgEquipSetActiveBack(target, data)
	self.view:sMsgEquipSetActiveBack(target, data)
end
function lordEquipViewProxy:sMsgEquipRenameBack(target, data)
	self.view:sMsgEquipRenameBack(target, data)
end
function lordEquipViewProxy:sMsgUpdateVip(target, data)
	self.view:sMsgUpdateVip(target, data)
end
return lordEquipViewProxy
