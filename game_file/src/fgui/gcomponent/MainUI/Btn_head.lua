local baseComponent = require("fgui.base.baseComponent")
local Btn_head = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_head", Btn_head)
function Btn_head:onInit()
	self.fields.Sprite_red:setVisible(false)
end
function Btn_head:onShow()
end
function Btn_head:registerEvent()
	SoraDAddMessage(self, "MESSAGE_LORDINFO_RESET_SKILL", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPDATE_SKILL", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPGRADE_SKILL", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_SERVER_SKILL_SET_ACTIVE_BACK", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_HONOUR_ACHIEVEMENT", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_LORDMILITARY_GET_REWARD", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_LORDMILITARY_UPDATE", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_GUARDIAN_REFRESH", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_EXCLUSIVE_VIP_WELFARE_REFRESH", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_DISASSEMBLE_BACK", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_FORGE_BACK", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_SERVER_EQUIP_LIMIT_TIMEOUT", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_EXCLUSIVE_VIP_CLEAN_NEW_FLAG", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_EXCLUSIVE_VIP_REFRESH_DATA", handler(self, self.updateRedPoint))
end
function Btn_head:initData(data)
	dump(data, "Btn_head:initData")
	self.fields.Com_lv:setString(data.leve)
	SoraDGetHeadFromManager(self.fields.Sprite_head, data.imageId, data.avatar)
	if data.isReachFullExp then
		self.fields.Bar_EXP:setValue(100)
	else
		self.fields.Bar_EXP:setValue(data.exp * 100 / data.expUpper)
	end
	self.fields.Bar_HP:setValue(data.physical * 100 / data.physicalUpper)
	self.fields.Sprite_red:setVisible(self:isRedPoint())
end
function Btn_head:setNotice(ret)
	self.controllers.c1:setSelectedIndex(ret and 1 or 0)
end
function Btn_head:updateRedPoint()
	self.fields.Sprite_red:setVisible(self:isRedPoint())
end
function Btn_head:isRedPoint()
	local guideCtrl = SoraDGetCtrl("guideCtrl")
	if guideCtrl:getCurMainCityGuideStep() ~= nil then
		return false
	end
	local achievementctrl = SoraDGetCtrl("achievementctrl")
	local honourNum = achievementctrl:getTipNum()
	honourNum = honourNum == nil and 0 or honourNum
	if 1 <= honourNum then
		return true
	end
	local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
	local haveReward = not lordInfoCtrl:getLordInfo().militaryRankInfo.gotReward and 0 < lordInfoCtrl:getLordInfo().militaryRankInfo.lastRank
	if haveReward then
		return true
	end
	local guardianCtrl = SoraDGetCtrl("guardianCtrl")
	if guardianCtrl:getIsCanReceive() then
		return true
	end
	local exaltedPrivilegeCtrl = SoraDGetCtrl("exaltedPrivilegeCtrl")
	local welfareInfo = exaltedPrivilegeCtrl:getWelfareInfo()
	if 0 < table.nums(welfareInfo) then
		return true
	end
	local isNewTotal = exaltedPrivilegeCtrl:isNewFlagTotalJudge()
	if isNewTotal then
		return true
	end
	local lordSkillModuleAPI = include("lordSkillModuleAPI")
	local skillPoint = lordSkillModuleAPI:getRemainPoint() or 0
	if 1 <= skillPoint then
		return true
	end
	local equipmentMgr = include("equipmentMgr")
	_UPVALUE6_ = "equipmentMgr"
	;("equipmentMgr")[1] = gEquipmentPart.WEAPON
	;("equipmentMgr")[2] = gEquipmentPart.BODY
	;("equipmentMgr")[3] = gEquipmentPart.HEAD
	;("equipmentMgr")[4] = gEquipmentPart.LEG
	;("equipmentMgr")[5] = gEquipmentPart.FOOT
	local ("equipmentMgr")[6], equipSort = gEquipmentPart.HAND, "equipmentMgr"
	for i, v in ipairs(equipSort) do
		if 0 < #equipmentMgr.getAllEquipmentByPart(v) and equipmentMgr.getPartEquipment(v) == nil then
			return true
		end
	end
	local exaltedPrivilegeCtrl = SoraDGetCtrl("exaltedPrivilegeCtrl")
	if exaltedPrivilegeCtrl:checkExclusiveVip() and not exaltedPrivilegeCtrl:hasBirthdayYearSet() then
		return true
	end
	return false
end
return Btn_head
