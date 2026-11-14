local baseProxy = require("fgui.base.baseProxy")
local lordViewProxy = class("lordViewProxy", baseProxy)
function lordViewProxy:onRegisterEvent()
	print("=======lordViewProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_UI_LORD_EQUIP_DETAIL", handler(self, self.updateEquipPop))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPDATE_BASE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_RESET_SKILL", handler(self, self.updateSkillPoint))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPDATE_SKILL", handler(self, self.updateSkillPoint))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPGRADE_SKILL", handler(self, self.updateSkillPoint))
	SoraDAddMessage(self, "MESSAGE_SERVER_SKILL_SET_ACTIVE_BACK", handler(self, self.updateSkillPoint))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_HONOUR_ACHIEVEMENT", handler(self, self.updateHonourReward))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_WEAR_BACK", handler(self, self.updateEquip))
	SoraDAddMessage(self, "MESSAGE_UI_EQUIP_GET_SUCCESS", handler(self, self.updateEquip))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_DISASSEMBLE_BACK", handler(self, self.updateEquip))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_FORGE_BACK", handler(self, self.updateEquip))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_LIMIT_TIMEOUT", handler(self, self.updateEquip))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_INTENSIFY_BACK", handler(self, self.updateEquip))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_RECAST_BACK", handler(self, self.updateEquip))
	SoraDAddMessage(self, "MESSAGE_SERVER_KINGDOMWAR_OFFICIAL_SUB", handler(self, self.updateOffcial))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_DISMISS_TITLE_BACK", handler(self, self.updateOffcial))
	SoraDAddMessage(self, "MESSAGE_LORDMILITARY_GET_REWARD", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_LORDMILITARY_UPDATE", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_SERVER_FRIEND_DATA_BACK", handler(self, self.updateFriendBtn))
	SoraDAddMessage(self, "MESSAGE_SERVER_FRIEND_STATUS_UPDATE", handler(self, self.updateFriendBtn))
	SoraDAddMessage(self, "MESSAGE_GUARDIAN_REFRESH", handler(self, self.showGuardian))
	SoraDAddMessage(self, "MESSAGE_EXCLUSIVE_VIP_REFRESH_DATA", handler(self, self.checkOperateBtns))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_RECHARGEVIP_REFRESH", handler(self, self.checkOperateBtns))
	SoraDAddMessage(self, "MESSAGE_EXCLUSIVE_VIP_CLEAN_NEW_FLAG", handler(self, self.updateVipFlag))
	SoraDAddMessage(self, "MESSAGE_EXCLUSIVE_VIP_REFRESH_DATA", handler(self, self.updateVipFlag))
	SoraDAddMessage(self, "MESSAGE_EXCLUSIVE_VIP_WELFARE_REFRESH", handler(self, self.updateVipFlag))
	SoraDAddMessage(self, "MESSAGE_EXCLUSIVE_VIP_BIRTHDAY_SET_BACK", handler(self, self.updateVipFlag))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_COMMON_ICON_TIP", handler(self, self.updateCommonIconTip))
end
function lordViewProxy:updateEquipPop(target, data)
	self.view:updateEquipPop(target, data)
end
function lordViewProxy:initData(target, data)
	self.view:initData(target, data)
end
function lordViewProxy:updateSkillPoint(target, data)
	self.view:updateSkillPoint(target, data)
end
function lordViewProxy:updateHonourReward(target, data)
	self.view:updateHonourReward(target, data)
end
function lordViewProxy:updateEquip(target, data)
	self.view:updateEquip(target, data)
end
function lordViewProxy:updateOffcial(target, data)
	self.view:updateOffcial(target, data)
end
function lordViewProxy:updateRedPoint(target, data)
	self.view:updateRedPoint(target, data)
end
function lordViewProxy:updateFriendBtn(target, data)
	self.view:updateFriendBtn(target, data)
end
function lordViewProxy:showGuardian(target, data)
	self.view:showGuardian(target, data)
end
function lordViewProxy:checkOperateBtns(target, data)
	self.view:checkOperateBtns(target, data)
end
function lordViewProxy:updateVipFlag(target, data)
	self.view:updateVipFlag(target, data)
end
function lordViewProxy:updateCommonIconTip(target, data)
	self.view:hideFirstKingdom()
end
return lordViewProxy
