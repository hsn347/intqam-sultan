local warOrderRead = include("warOrderRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local BraqueTestSkillfulBuffPanel = class("BraqueTestSkillfulBuffPanel", baseFguiPanel)
function BraqueTestSkillfulBuffPanel:ctor(...)
	self.super.ctor(self, ...)
	print("BraqueTestSkillfulBuffPanel:ctor", self.viewName)
end
function BraqueTestSkillfulBuffPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function BraqueTestSkillfulBuffPanel:onInit()
	print("=======BraqueTestSkillfulBuffPanel:onInit")
	self.activityID = self.param and self.param.activityID or gActivityTimeActivityID.WAR_ORDER_ACTIVITY
	self:fixChildrenPos()
	self.fields.Panel_bg:setString(i18n("Battle_Towers_23"))
	_UPVALUE9_ = self.fields.Panel_bg
	self.fields.Panel_bg[1] = "Text_1"
	self.fields.Panel_bg[2] = "Text_2"
	self.fields.Panel_bg[3] = "Text_3"
	self.fields.Panel_bg[4] = "Text_4"
	self.fields.Panel_bg[5] = "Text_5"
	self.fields.Panel_bg[6] = "line1"
	self.fields.Panel_bg[7] = "line2"
	self.fields.Panel_bg[8] = "line3"
	self.fields.Panel_bg[9] = "line4"
	for index, value in ipairs(self.fields.Panel_bg) do
		if self.fields[value] then
			self.fields[value]:fixPos()
		end
	end
	self.fields.Text_4:setString(i18n("common_text_1961"))
	self.fields.Text_5:setString(i18n("common_text_748"))
	if self.activityID == gActivityTimeActivityID.MAGIC_LAMP_ORDER_ACTIVITY then
		self.fields.Text_1:setString(i18n("MagiclampDecree_06"))
	elseif self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001601 then
		self.fields.Text_1:setString(i18n("Braque_text_10"))
		self.fields.Text_2:setString(i18n("MagiclampDecree_06"))
		self.fields.Text_3:setString(i18n("Braque_text_12"))
		_ENV = i18n("Braque_text_12")
		i18n("Braque_text_12").lv = include("constantRead").getConstValue("RAMADAN_BLESS_BUFF_UNLOCK_LV")
		self.fields.Text_Tips:setString(i18n("ramadan_bless_text_02", i18n("Braque_text_12")))
	elseif self.activityID == gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY then
		self.fields.Text_1:setString(i18n("MagiclampDecree_06"))
		self.fields.Text_Tips:setString(i18n("HatchDecree_text_04"))
	else
		self.fields.Text_1:setString(i18n("Braque_text_10"))
		self.fields.Text_2:setString(i18n("Braque_text_11"))
		self.fields.Text_3:setString(i18n("Braque_text_12"))
		self.fields.Text_Tips:setString(i18n("Braque_text_27"))
		if self.activityID == gActivityTimeActivityID.WAR_ORDER_ACTIVITY_9001581 then
			_ENV = i18n("Braque_text_27")
			i18n("Braque_text_27").lv = include("constantRead").getConstValue("WARDRUM_BUFF_UNLOCK_LV")
			self.fields.Text_Tips:setString(i18n("wardrum_text_17", i18n("Braque_text_27")))
		end
	end
	self.fields.Scroll_Buff:setItemRenderer(handler(self, self.onItemRenderer))
end
function BraqueTestSkillfulBuffPanel:onShow()
	print("=======BraqueTestSkillfulBuffPanel:onShow")
	if self.activityID == gActivityTimeActivityID.MAGIC_LAMP_ORDER_ACTIVITY then
		local effectCount = warOrderRead.getEffectCount(self.activityID, BUILD_ENUM.MAGIC_LAMP)
		self.fields.Scroll_Buff:setNumItems(effectCount)
	elseif self.activityID == gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY then
		local effectCount = warOrderRead.getEffectCount(self.activityID, BUILD_ENUM.MAGIC_LAMP_HATCH)
		self.fields.Scroll_Buff:setNumItems(effectCount)
	else
		_UPVALUE3_ = warOrderRead.getEffectCount(self.activityID, BUILD_ENUM.MAGIC_LAMP_HATCH)
		self.buffTypeList, warOrderRead.getEffectCount(self.activityID, BUILD_ENUM.MAGIC_LAMP_HATCH)[1] = warOrderRead.getEffectCount(self.activityID, BUILD_ENUM.MAGIC_LAMP_HATCH), BUILD_ENUM.CASTLE_STAR
		self.buffTypeList, warOrderRead.getEffectCount(self.activityID, BUILD_ENUM.MAGIC_LAMP_HATCH)[2] = warOrderRead.getEffectCount(self.activityID, BUILD_ENUM.MAGIC_LAMP_HATCH), BUILD_ENUM.GLORIOUS_STATUE
		self.buffTypeList, warOrderRead.getEffectCount(self.activityID, BUILD_ENUM.MAGIC_LAMP_HATCH)[3] = warOrderRead.getEffectCount(self.activityID, BUILD_ENUM.MAGIC_LAMP_HATCH), BUILD_ENUM.MAGIC_LAMP
		self.fields.Scroll_Buff:setNumItems(#self.buffTypeList)
	end
end
function BraqueTestSkillfulBuffPanel:onItemRenderer(index, target)
	if self.activityID == gActivityTimeActivityID.MAGIC_LAMP_ORDER_ACTIVITY then
		target:initIndex(BUILD_ENUM.MAGIC_LAMP, self.activityID, index + 1)
	elseif self.activityID == gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY then
		target:initIndex(BUILD_ENUM.MAGIC_LAMP_HATCH, self.activityID, index + 1)
	else
		target:initData(self.buffTypeList[index + 1], self.activityID)
	end
end
return BraqueTestSkillfulBuffPanel
