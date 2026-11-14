local roaringFlameWarRead = include("roaringFlameWarRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlame_SkillBookPanel = class("RoaringFlame_SkillBookPanel", baseFguiPanel)
function RoaringFlame_SkillBookPanel:ctor(...)
	self.isLRU = true
	RoaringFlame_SkillBookPanel.super.ctor(self, ...)
	print("RoaringFlame_SkillBookPanel:ctor", self.viewName)
end
function RoaringFlame_SkillBookPanel:onInit()
	print("=======RoaringFlame_SkillBookPanel:onInit")
	self.fields.Panel_bg:setString(i18n("atlantiswar_skill_text_003"))
	_UPVALUE1_, self.curSortType = self.fields.Panel_bg.setString, 1
	_UPVALUE2_, self.fields.Panel_bg.setString[1] = i18n("atlantiswar_skill_text_016"), i18n("atlantiswar_skill_text_016")
	_UPVALUE2_, self.fields.Panel_bg.setString[2] = i18n("atlantiswar_skill_text_016"), i18n("atlantiswar_skill_text_017")
	_UPVALUE2_, self.fields.Panel_bg.setString[3] = i18n("atlantiswar_skill_text_016"), i18n("atlantiswar_skill_text_017")
	_UPVALUE2_, self.fields.Panel_bg.setString[4] = i18n("atlantiswar_skill_text_016"), i18n("atlantiswar_skill_text_017")
	_UPVALUE2_, self.fields.Panel_bg.setString[5] = i18n("atlantiswar_skill_text_016"), i18n("atlantiswar_skill_text_017")
	_UPVALUE2_, self.fields.Panel_bg.setString[6] = i18n("atlantiswar_skill_text_016"), i18n("atlantiswar_skill_text_017")
	_UPVALUE2_, self.fields.Panel_bg.setString[7] = i18n("atlantiswar_skill_text_016"), i18n("atlantiswar_skill_text_017")
	local _UPVALUE2_, self.fields.Panel_bg.setString[8], items = i18n("atlantiswar_skill_text_016"), i18n("atlantiswar_skill_text_017")
	i18n("atlantiswar_skill_text_016")[1] = 1
	local i18n("atlantiswar_skill_text_016")[2], values = 2, i18n("atlantiswar_skill_text_016")
	_ENV = i18n("atlantiswar_skill_text_017")
	i18n("atlantiswar_skill_text_017").items = items
	i18n("atlantiswar_skill_text_017").values = values
	i18n("atlantiswar_skill_text_017").changedCallback = handler(self, self.onComboBoxClick)
	self:setComboBox(self.fields.ComboBox, i18n("atlantiswar_skill_text_017"))
	local dropdown = self.fields.ComboBox:getDropdown()
	self.comboBoxList = dropdown:getChildByName("list")
	self.fields.ComboBox:addClickListener(function()
		SoraDPlaySound()
		self.comboBoxList:setSelectedIndex(self.curSortType - 1)
	end)
	self.fields.ComboBox:fixChildrenPos()
	self.fields.List:setItemRenderer(handler(self, self.onGroupRenderer))
end
function RoaringFlame_SkillBookPanel:onComboBoxClick()
	SoraDPlaySound()
	self.curSortType = tonumber(self.fields.ComboBox:getValue())
	self:updateGroupList()
end
function RoaringFlame_SkillBookPanel:onGroupRenderer(index, obj)
	local key = self.groupKeys[index + 1]
	obj:initData(self.groupList[key], key, self.curSortType)
end
function RoaringFlame_SkillBookPanel:getShowData()
	return roaringFlameWarRead.getSkillShowData(self.curSortType)
end
function RoaringFlame_SkillBookPanel:endShow()
	print("=======RoaringFlame_SkillBookPanel:endShow")
	self:updateGroupList()
end
function RoaringFlame_SkillBookPanel:updateGroupList(...)
	self.groupList = self:getShowData()
	self.groupKeys = table.keys(self.groupList)
	table.sort(self.groupKeys)
	self.fields.List:setNumItems(#self.groupKeys)
end
return RoaringFlame_SkillBookPanel
