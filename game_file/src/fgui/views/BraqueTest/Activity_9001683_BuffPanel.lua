local warOrderRead = include("warOrderRead")
local warOrderCtrl = SoraDGetCtrl("warOrderCtrl")
local buffDesRead = include("buffDesRead")
local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001683_BuffPanel = class("Activity_9001683_BuffPanel", baseFguiPanel)
function Activity_9001683_BuffPanel:ctor(...)
	self.isLRU = true
	Activity_9001683_BuffPanel.super.ctor(self, ...)
	print("Activity_9001683_BuffPanel:ctor", self.viewName)
end
function Activity_9001683_BuffPanel:onInit()
	print("=======Activity_9001683_BuffPanel:onInit")
	self.fields.Panel_bg:setString(i18n("Battle_Towers_23"))
	self.fields.Scroll_Buff:setItemRenderer(handler(self, self.onItemRenderer))
	for i = 1, 3 do
		local Button_buff = self.fields["Button_buff" .. i]
		if Button_buff then
			Button_buff:addClickListener(handler(self, self.onClickBtnBuff))
			Button_buff:setTag(i)
			Button_buff:fixPos()
		end
	end
	if not SoraDFIsRA() then
		self.fields.Text_1:fixPos()
		self.controllers.c_buff:fix()
	end
end
function Activity_9001683_BuffPanel:onClickBtnBuff(EventContext)
	SoraDPlaySound()
	local buffIndex = EventContext:getSender():getTag()
	local buffDes = self.buffList[1][buffIndex].buffTitle
	_ENV = nil
	;(nil).des = buffDes
	uiManager:show("RadiantMsgTip", nil)
end
function Activity_9001683_BuffPanel:endShow()
	print("=======Activity_9001683_BuffPanel:endShow")
	self.activityID = self.param.activityID or gActivityTimeActivityID.MAGIC_LAMP_HATCH_ORDER_ACTIVITY
	if self.activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001701 then
		self.buffType = BUILD_ENUM.TWO_MAGIC_LAMP
		self.fields.Text_1:setString(i18n("HatchDecree_text_03"))
		self.fields.Text_Tips:setString(i18n("AnilaDecree_text_03"))
		local activity_9001701_Ctrl = SoraDGetCtrl("activity_9001701_Ctrl")
		self.groupIndex = activity_9001701_Ctrl:getGroupIndex()
	else
		self.buffType = BUILD_ENUM.MAGIC_LAMP_HATCH
		self.fields.Text_1:setString(i18n("HatchDecree_text_08"))
		self.fields.Text_Tips:setString(i18n("HatchDecree_text_04"))
		local activity_9001683_Ctrl = SoraDGetCtrl("activity_9001683_Ctrl")
		self.groupIndex = activity_9001683_Ctrl:getGroupIndex()
	end
	local buffInfo = warOrderRead.getBuffInfo(self.activityID, self.buffType, 1)
	local EffectIcon = buffInfo.EffectIcon
	for i, v in ipairs(EffectIcon) do
		local Button_buff = self.fields["Button_buff" .. i]
		if Button_buff then
			Button_buff:setIcon(v .. ".png")
		end
	end
	if #EffectIcon <= 2 then
		self.controllers.c_buff:setSelectedIndex(0)
	else
		self.controllers.c_buff:setSelectedIndex(1)
	end
	self.buffList, _ENV = self.controllers.c_buff.setSelectedIndex, self.controllers.c_buff.setSelectedIndex
	local effectCount = warOrderRead.getEffectCount(self.activityID, self.buffType)
	for i = 1, effectCount do
		self:updateBuffList(i)
	end
	self.fields.Scroll_Buff:setNumItems(effectCount)
end
function Activity_9001683_BuffPanel:onItemRenderer(index, obj)
	local buffInfo = warOrderRead.getBuffInfo(self.activityID, self.buffType, index + 1)
	local _fields = fguiHelper.get_fields(obj)
	local limitLv = buffInfo.CastleLv
	_fields.title:setString(string.format("%d~%d", limitLv[1], limitLv[2]))
	local c2 = obj:getController("c2")
	if self.groupIndex == index + 1 then
		c2:setSelectedIndex(1)
	else
		c2:setSelectedIndex(0)
	end
	local c1 = obj:getController("c1")
	c1:setSelectedIndex(index % 2)
	local cfg = self.buffList[index + 1]
	for i, v in ipairs(cfg) do
		local Text_value = _fields["Text_value" .. i]
		if Text_value then
			Text_value:setString(v.value)
		end
	end
	local c_buff = obj:getController("c_buff")
	if #cfg <= 2 then
		c_buff:setSelectedIndex(0)
	else
		c_buff:setSelectedIndex(1)
	end
	if not SoraDFIsRA() then
		obj:fixChildrenPos()
		obj:fixChildren()
	end
end
function Activity_9001683_BuffPanel:updateBuffList(index)
	local warOrderRead, buffList
	local buffInfo = warOrderRead.getBuffInfo(self.activityID, self.buffType, index)
	for _index, buffID in ipairs(buffInfo.PrivilegeEffect) do
		local effectType = buffltCtrl:getEffectType(buffID)
		local buffNum = buffltCtrl:getEffect(buffID)
		local buffTitle = buffDesRead.getTitleBase(effectType)
		local value = buffDesRead.getTitleValueWithValue(effectType, buffNum, true)
		warOrderRead = effectType
		effectType.buffTitle = buffTitle
		effectType.buffNum = buffNum
		local effectType.value, cfg = value, effectType
		buffList[_index] = cfg
	end
	self.buffList[index] = buffList
end
return Activity_9001683_BuffPanel
