local magicLampSkillCtrl = SoraDGetCtrl("magicLampSkillCtrl")
local magicLampSkillRead = include("magicLampSkillRead")
local buffDesRead = include("buffDesRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MagicLampSkillUpgradePanel = class("MagicLampSkillUpgradePanel", baseFguiPanel)
function MagicLampSkillUpgradePanel:ctor(...)
	self.super.ctor(self, ...)
	print("MagicLampSkillUpgradePanel:ctor", self.viewName)
	self.data = self.proxy.param.data
	self.isHidePrePanel = true
end
function MagicLampSkillUpgradePanel:onInit()
	print("=======MagicLampSkillUpgradePanel:onInit")
	self.fields.Com_title:setString(i18n("jinn_skill_20"))
	self.fields.Text_buff:setString(i18n("jinn_skill_11"))
	self.fields.List_buff:setItemRenderer(handler(self, self.onBuffItemRenderer))
	self.fields.Button_upgrade:setString(i18n("common_text_055"))
	self.fields.Button_upgrade:addClickListener(handler(self, self.onClickBtnUpgrade))
	if not SoraDFIsRA() then
		self.fields.Text_curLv:fixPos()
		self.fields.Text_nextLv:fixPos()
		self.fields.Com_arrow:getController("c2"):setSelectedIndex(SoraDFIsRA() and 0 or 1)
	end
end
function MagicLampSkillUpgradePanel:onShow()
	print("=======MagicLampSkillUpgradePanel:onShow")
	self:updateSkillLv()
end
function MagicLampSkillUpgradePanel:onClickBtnUpgrade(...)
	SoraDPlaySound()
	if not magicLampSkillCtrl:checkCanUpgradeLv(self.data, true) then
		return
	end
	if self.haveItem < self.needItem.count then
		local itemName = publicRead.getName(self.needItem.id)
		_ENV = nil
		;(nil).item = itemName
		SoraDShowMsgTip(i18n("jinn_skill_23", nil))
		return
	end
	magicLampSkillCtrl:reqUpgradeLv(self.data.id)
	SoraDShowLoading(self:displayObject())
end
function MagicLampSkillUpgradePanel:updateSkillLv(...)
	self.fields.Com_skill:initData(self.data)
	local curLv = self.data.lv
	local nextLv = curLv + 1
	_ENV = nil
	;(nil).lv = curLv
	self.fields.Text_curLv:setString(i18n("common_text_100", nil))
	_ENV = i18n("common_text_100", nil)
	i18n("common_text_100", nil).lv = nextLv
	self.fields.Text_nextLv:setString(i18n("common_text_100", i18n("common_text_100", nil)))
	local lvGroup = magicLampSkillRead.getSkillLvGroup(self.data.skillType)
	local buffList = magicLampSkillRead.getSkillLvTotalBuff(lvGroup, curLv)
	local nextMap = magicLampSkillRead.getSkillLvBuffMap(lvGroup, nextLv)
	local showBuffList = magicLampSkillRead.getSkillUpgradeLvBuffList(buffList, nextMap)
	self.showBuffList = showBuffList
	self.fields.List_buff:setNumItems(#self.showBuffList)
	local needItems = magicLampSkillRead.getUpgradeLvNeedItem(lvGroup, self.data.lv + 1)
	self.needItem = needItems[1]
	self.haveItem = magicLampSkillCtrl:getItemCount(self.needItem.id)
	dump(self.needItem.id, "self.needItem.id")
	self.fields.Com_need:initNeedData(self.needItem, "MagicLampSkillUpgrade")
end
function MagicLampSkillUpgradePanel:onBuffItemRenderer(index, obj)
	local fields = fguiHelper.get_fields(obj)
	local data = self.showBuffList[index + 1]
	local buffId = data.id
	local buffBase = buffDesRead.getTitleBase(buffId)
	local buffValue = buffDesRead.getTitleValueWithValue(buffId, data.count)
	_ENV = nil
	;(nil).color = "#FFE78C"
	buffValue = SoraDWrapHtmlTagByStyle(buffValue, nil)
	local buffStr = buffBase .. buffValue
	fields.Text_1:setString(buffStr)
	local addCount = data.addCount
	if addCount then
		local buffAddValue = buffDesRead.getTitleValueWithValue(buffId, addCount)
		fields.Text_2:setString(buffAddValue)
		fields.Text_2:setVisible(true)
	else
		fields.Text_2:setVisible(false)
	end
end
function MagicLampSkillUpgradePanel:onMsgUpgradeLvBack(...)
	SoraDCloseLoading(self:displayObject())
	self.data = magicLampSkillCtrl:getSkillData(self.data.id)
	local ok, err = magicLampSkillCtrl:checkCanUpgradeLv(self.data)
	if err and err == 1 then
		self:closePanel()
		SoraDShowMsgTip(i18n("jinn_skill_25"))
		return
	end
	self:updateSkillLv()
end
return MagicLampSkillUpgradePanel
