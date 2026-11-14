local magicLampSkillRead = include("magicLampSkillRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local magicLampSkillCtrl = SoraDGetCtrl("magicLampSkillCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MagicLampSkillMergePanel = class("MagicLampSkillMergePanel", baseFguiPanel)
function MagicLampSkillMergePanel:ctor(...)
	self.super.ctor(self, ...)
	print("MagicLampSkillMergePanel:ctor", self.viewName)
end
function MagicLampSkillMergePanel:onInit()
	print("=======MagicLampSkillMergePanel:onInit")
	self.fields.Text_title1:setString(i18n("jinn_skill_73"))
	self.fields.Com_skillSmall:addClickListener(handler(self, self.onClickBtnSkill))
	self.fields.Text_title2:setString(i18n("common_text_1755"))
	self.fields.Button_compound:setTitleText(i18n("common_text_1352"))
	self.fields.Button_compound:addClickListener(handler(self, self.onClickBtnCompound))
	self.fields.Button_all:setTitleText(i18n("common_text_1754"))
	self.fields.Button_all:addClickListener(handler(self, self.onClickBtnCompound))
	self.fields.ScrollView_item:setItemRenderer(handler(self, self.onItemRenderer))
	if not SoraDFIsRA() then
		self.fields.Com_skillSmall:fixPos()
		self.fields.Text_name:fixPos()
		self.fields.Text_des:fixPos()
		self.fields.Button_compound:fixPos()
		self.fields.Button_all:fixPos()
	end
end
function MagicLampSkillMergePanel:onShow()
	print("=======MagicLampSkillMergePanel:onShow")
	local itemID = self.param.itemID
	self.skillType = magicLampSkillRead.getSkillTypeByItemID(itemID)
	_ENV = nil
	;(nil).skillType = self.skillType
	self.fields.Com_skillSmall:initData(nil)
	local skillName = magicLampSkillRead.getSkillName(self.skillType)
	self.fields.Text_name:setString(skillName)
	_ENV = nil
	;(nil).name = skillName
	self.fields.Text_des:setString(i18n("jinn_skill_74", nil))
	self.tableMaterial, _ENV = self.fields.Text_des.setString, self.fields.Text_des.setString
	local needItems = magicLampSkillRead.getSkillCompound(self.skillType)
	for i, v in ipairs(needItems) do
		_ENV = i18n("jinn_skill_74", nil)
		i18n("jinn_skill_74", nil).id = v.id
		i18n("jinn_skill_74", nil).itemCount = backpackCtrl:getItemCount(v.id)
		i18n("jinn_skill_74", nil).needCount = v.count
		table.insert(self.tableMaterial, i18n("jinn_skill_74", nil))
	end
	self.fields.ScrollView_item:setNumItems(#self.tableMaterial)
end
function MagicLampSkillMergePanel:onItemRenderer(index, obj)
	local data = self.tableMaterial[index + 1]
	local fields = fguiHelper.get_fields(obj)
	fields.Com_item:initData(data.id)
	_ENV = data.id
	data.id.member = data.itemCount
	data.id.total = data.needCount
	local countStr = i18n("common_text_155", data.id)
	if data.itemCount < data.needCount then
		_ENV = data.needCount
		data.needCount.color = "#FF0000"
		countStr = SoraDWrapHtmlTagByStyle(countStr, data.needCount)
	end
	fields.Text_needCount:setString(countStr)
end
function MagicLampSkillMergePanel:onClickBtnCompound(EventContext)
	SoraDPlaySound()
	local storageSpace = magicLampSkillCtrl:getSkillStorageSpace()
	if storageSpace <= 0 then
		SoraDShowMsgTip(i18n("jinn_skill_59"))
		return
	end
	local data = self.tableMaterial[1]
	if data.itemCount < data.needCount then
		local itemName = publicRead.getName(data.id)
		_ENV = i18n("jinn_skill_59")
		i18n("jinn_skill_59").item = itemName
		SoraDShowMsgTip(i18n("jinn_skill_23", i18n("jinn_skill_59")))
		return
	end
	local sender = EventContext:getSender()
	local mergeCount = 1
	if sender == self.fields.Button_all then
		mergeCount = math.floor(data.itemCount / data.needCount)
	end
	magicLampSkillCtrl:reqMerge(self.skillType, math.min(storageSpace, mergeCount))
	SoraDShowLoading(self:displayObject())
end
function MagicLampSkillMergePanel:onClickBtnSkill(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).skillType = self.skillType
	uiManager:show("MagicLampSkillDetailsLook", nil)
end
return MagicLampSkillMergePanel
