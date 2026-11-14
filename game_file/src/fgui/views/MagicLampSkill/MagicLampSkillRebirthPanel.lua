local magicLampSkillCtrl = SoraDGetCtrl("magicLampSkillCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local magicLampSkillRead = include("magicLampSkillRead")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MagicLampSkillRebirthPanel = class("MagicLampSkillRebirthPanel", baseFguiPanel)
function MagicLampSkillRebirthPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MagicLampSkillRebirthPanel:ctor", self.viewName)
	self.rewardList, _ENV = print, print
	self.isHidePrePanel = true
end
function MagicLampSkillRebirthPanel:onInit()
	print("=======MagicLampSkillRebirthPanel:onInit")
	self.fields.Com_title:setString(i18n("jinn_skill_43"))
	self.fields.Text_reward:setString(i18n("jinn_skill_44"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onRewardItemRenderer))
	self.fields.Button_ok:setString(i18n("Weapon_Rune_tips_078"))
	self.fields.Button_ok:addClickListener(handler(self, self.onClickBtnOk))
	self.fields.Text_des:setString(i18n("jinn_skill_81"))
end
function MagicLampSkillRebirthPanel:onShow()
	print("=======MagicLampSkillRebirthPanel:onShow")
	self.data = self.proxy.param.data
	self.fields.Com_skill:initData(self.data)
	local stageGroup = magicLampSkillRead.getSkillStageGroup(self.data.skillType)
	local needItems = magicLampSkillRead.getRebirthNeed(stageGroup, self.data.classLv)
	self.needItem = needItems[1]
	self.fields.Com_need:initNeedData(self.needItem, "MagicLampSkillRebirth")
	local costSkillList, needSkillCount = magicLampSkillRead.getJinnSkillClassCostSkill(stageGroup, self.data.classLv, self.data.skillType)
	self.needSkillCount = needSkillCount
	magicLampSkillRead.sortRebirthCostList(costSkillList)
	local _ENV, skillList = magicLampSkillRead.sortRebirthCostList, magicLampSkillRead.sortRebirthCostList
	for __, v in ipairs(costSkillList) do
		for i = 1, v.count do
			_ENV = nil
			;(nil).skillType = v.id
			table.insert(skillList, nil)
		end
	end
	local lvGroup = magicLampSkillRead.getSkillLvGroup(self.data.skillType)
	local itemList = magicLampSkillRead.getJinnSkillLvCostItem(lvGroup, self.data.lv, 1)
	_ENV = self.data.lv
	self.data.lv.skillData = self.data
	self.data.lv.skillList = skillList
	self.data.lv.rewards = itemList
	self.rewardList = magicLampSkillRead.getRebirthRewardList(self.data.lv)
	dump(self.rewardList, "==self.rewardList==")
	self.fields.List_reward:setNumItems(#self.rewardList)
end
function MagicLampSkillRebirthPanel:onRewardItemRenderer(index, obj)
	local _index = index + 1
	local data = self.rewardList[_index]
	magicLampSkillRead.initRebirthRewardSingle(obj, data)
end
function MagicLampSkillRebirthPanel:onClickBtnOk(...)
	SoraDPlaySound()
	if not self:checkCondition() then
		return
	end
	local itemName = publicRead.getName(self.needItem.id)
	local skillName = magicLampSkillRead.getSkillName(self.data.skillType)
	_ENV = nil
	;(nil).num = self.needItem.count
	;(nil).item = itemName
	;(nil).name = skillName
	local msgStr = i18n("jinn_skill_82", nil)
	SoraDShowMsgBox(msgStr, i18n("common_text_204"), i18n("common_text_185"), function(exitType)
		if exitType == MSGBOX_CALLBACK_YES then
			if not self:checkCondition() then
				return
			end
			magicLampSkillCtrl:reqRebirth(self.data.id)
			SoraDShowLoading(self:displayObject())
		end
	end)
end
function MagicLampSkillRebirthPanel:checkCondition(...)
	local storageSpace = magicLampSkillCtrl:getSkillStorageSpace()
	if storageSpace < self.needSkillCount then
		SoraDShowMsgTip(i18n("jinn_skill_59"))
		return false
	end
	if self.needItem then
		local itemID = self.needItem.id
		if backpackCtrl:getItemCount(itemID) < self.needItem.count then
			local itemName = publicRead.getName(itemID)
			magicLampSkillCtrl = i18n("jinn_skill_59")
			i18n("jinn_skill_59").item = itemName
			SoraDShowMsgTip(i18n("jinn_skill_23", i18n("jinn_skill_59")))
			return false
		end
	end
	return true
end
return MagicLampSkillRebirthPanel
