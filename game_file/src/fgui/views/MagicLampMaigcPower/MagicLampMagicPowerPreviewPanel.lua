local baseFguiPanel = require("fgui.base.baseFguiPanel")
local magicLampSkillCtrl = SoraDGetCtrl("magicLampSkillCtrl")
local MagicLampMagicPowerPreviewPanel = class("MagicLampMagicPowerPreviewPanel", baseFguiPanel)
local magicLampSkillLotteryRead = include("magicLampSkillLotteryRead")
local magicLampSkillRead = include("magicLampSkillRead")
local divineProtectionRead = include("divineProtectionRead")
local nebulaMileStoneCtrl = SoraDGetCtrl("nebulaMileStoneCtrl")
local QUALITY_NUM = 4
function MagicLampMagicPowerPreviewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MagicLampMagicPowerPreviewPanel:ctor", self.viewName)
end
function MagicLampMagicPowerPreviewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "MagicLampSkill"
	end
	return self._packageList
end
function MagicLampMagicPowerPreviewPanel:onInit()
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
	end
	print("=======MagicLampMagicPowerPreviewPanel:onInit")
	self.fields.Com_title:initData(i18n("Magic_draw_text_10"), handler(self, self.onClickClose))
	self.fields.list_jinn:setItemRenderer(handler(self, self.onJinnRenderer))
	self.fields.list_rare:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
	self.magicPoolID = self.param.magicPoolID
	self.isPreView = self.param.isPreView or false
	local _ENV, cards = self.param.isPreView or false, self.param.isPreView or false
	if self.isPreView then
		cards = divineProtectionRead.getShowData(self.magicPoolID)
	else
		self.previewCfg = magicLampSkillLotteryRead.getPreviewCfgByID(self.magicPoolID)
		cards, _ENV = self.previewCfg.data, self.previewCfg.data
		cards = self.previewCfg and self.previewCfg.data or divineProtectionRead.getShowData(self.magicPoolID)
	end
	self.qualityCfg, _ENV, self.cardMap, _ENV = self.previewCfg.data, self.previewCfg.data, self.previewCfg.data, self.previewCfg.data
	for i, v in ipairs(cards) do
		if JudgeItemType(v) == gIDType.MAGIC_LAMP_SKILL and self:isUnlockCard(v) then
			local quality = magicLampSkillRead.getSkillQuality(v)
			if not self.cardMap[quality] then
				self.cardMap[quality], _ENV = v, v
				local title = magicLampSkillRead.getQualityConfig(quality).name
				local bg = magicLampSkillRead.getQualityFrameTitle(quality)
				_ENV = handler(self, self.onClickItem)
				handler(self, self.onClickItem).title = title
				self.qualityCfg[quality], handler(self, self.onClickItem).bg = handler(self, self.onClickItem)
			end
			table.insert(self.cardMap[quality], v)
		end
	end
	self.curSelectedRares, _ENV = ipairs(cards)
	for i = 1, QUALITY_NUM do
		self.curSelectedRares[i] = true
		local obj = self.fields.list_rare:getChildAt(i - 1)
		local ctrls = fguiHelper.get_controllers(obj)
		ctrls.c1:setSelectedIndex(1)
	end
end
function MagicLampMagicPowerPreviewPanel:isUnlockCard(skillType)
	local unlockSkillCfg = magicLampSkillLotteryRead.getUnlockSkillCfgByType(self.magicPoolID, skillType)
	if unlockSkillCfg and unlockSkillCfg.milestoneID ~= 0 then
		if unlockSkillCfg.milestoneFunction ~= 0 then
			local value = nebulaMileStoneCtrl:getPlusByUnlockType(unlockSkillCfg.milestoneFunction)
			if value ~= nil then
				return true
			end
		end
		local beginTime = nebulaMileStoneCtrl:getIsTaskBeginTime(unlockSkillCfg.milestoneID)
		if beginTime == 0 or beginTime > serviceFunctions.systemTime() then
			return false
		end
		return true
	end
	return true
end
function MagicLampMagicPowerPreviewPanel:onShow()
	print("=======MagicLampMagicPowerPreviewPanel:onShow")
	self:updateView()
end
function MagicLampMagicPowerPreviewPanel:updateView()
	local skillList = magicLampSkillCtrl:getSkillList()
	local max = magicLampSkillCtrl:getSkillStorageMax()
	magicLampSkillCtrl = nil
	;(nil).num = #skillList
	;(nil).max = max
	self.fields.text_have:setString(i18n("jinn_skill_8", nil))
	self.showCards, magicLampSkillCtrl = self.fields.text_have.setString, self.fields.text_have.setString
	for i = 1, QUALITY_NUM do
		local quality = QUALITY_NUM - i + 1
		if self.curSelectedRares[quality] then
			table.insert(self.showCards, self.qualityCfg[quality])
			local cards = self.cardMap[quality]
			if cards then
				for i2, v2 in ipairs(cards) do
					table.insert(self.showCards, v2)
				end
			end
		end
	end
	self.fields.list_jinn:setNumItems(#self.showCards)
end
function MagicLampMagicPowerPreviewPanel:onJinnRenderer(index, obj)
	print("self.showCards[index + 1]", self.showCards[index + 1])
	obj:initData(self.showCards[index + 1], self.previewCfg)
end
function MagicLampMagicPowerPreviewPanel:onRareRenderer(index, obj)
end
function MagicLampMagicPowerPreviewPanel:onClickItem(context)
	SoraDPlaySound()
	local obj = context:getGObjectData()
	local childIndex = self.fields.list_rare:getChildIndex(obj) + 1
	local ctrls = fguiHelper.get_controllers(obj)
	local isSelected = not self.curSelectedRares[childIndex]
	self.curSelectedRares[childIndex] = isSelected
	ctrls.c1:setSelectedIndex(isSelected and 1 or 0)
	self:updateView()
end
return MagicLampMagicPowerPreviewPanel
