local buffltCtrl = include("buffltCtrl")
local buffDesRead = include("buffDesRead")
local activity_9001496_Read = include("activity_9001496_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001496_BuffPanel = class("Activity_9001496_BuffPanel", baseFguiPanel)
function Activity_9001496_BuffPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001496_BuffPanel:ctor", self.viewName)
	self.curStarLv = SoraDGetBuildStarLv()
end
function Activity_9001496_BuffPanel:onInit()
	print("=======Activity_9001496_BuffPanel:onInit")
	self.fields.Panel_bg:setString(i18n("Battle_Towers_23"))
	self.fields.Text_des:setString(i18n("build_thriving_7"))
	self.fields.Text_tip:setString(i18n("build_thriving_9"))
	local _fields = fguiHelper.get_fields(self.fields.Com_title)
	_fields.title1:setString(i18n("build_thriving_8"))
	self.buildthrivingbuff = activity_9001496_Read.getBuffConfig()
	local buff = activity_9001496_Read.getFirstBuff()
	buffltCtrl = i18n("build_thriving_8")
	i18n("build_thriving_8")[1] = _fields.title2
	i18n("build_thriving_8")[2] = _fields.title3
	for i, widget in ipairs(i18n("build_thriving_8")) do
		local eType = buffltCtrl:getEffectType(buff[i])
		widget:setString(buffDesRead.getTitleBase(eType))
	end
	self.fields.List:setItemRenderer(handler(self, self.onNormalItemRederer))
	self.fields.List:setNumItems(#self.buildthrivingbuff)
	if self.curStarLv > activity_9001496_Read.getBuffLvMax() then
		self.controllers.c_showTip:setSelectedIndex(1)
	else
		self.controllers.c_showTip:setSelectedIndex(0)
	end
end
function Activity_9001496_BuffPanel:onShow()
	print("=======Activity_9001496_BuffPanel:onShow")
end
function Activity_9001496_BuffPanel:onNormalItemRederer(index, obj)
	local data = self.buildthrivingbuff[index + 1]
	local _fields = fguiHelper.get_fields(obj)
	local lvBegin = data.lv[1]
	local lvEnd = data.lv[2]
	_ENV = nil
	;(nil).lv = lvBegin
	_ENV = nil
	;(nil).lv = lvEnd
	local title1Str = string.format("%s ~ %s", i18n("Glory_text_26", nil), i18n("Glory_text_26", nil))
	_fields.title1:setString(title1Str)
	buffDesRead = _fields.title1
	_fields.title1[1] = _fields.title2
	_fields.title1[2] = _fields.title3
	for i, widget in ipairs(_fields.title1) do
		local buffID = data.buff[i]
		local value = buffltCtrl:getEffect(buffID)
		local titleStr = buffDesRead.getTitleValueWithValue(buffID, value)
		widget:setString(titleStr)
	end
	local c_lineType = obj:getController("c_lineType")
	if lvBegin <= self.curStarLv and lvEnd >= self.curStarLv then
		c_lineType:setSelectedIndex(2)
	else
		local showLine = index % 2 == 1
		if showLine then
			c_lineType:setSelectedIndex(1)
		else
			c_lineType:setSelectedIndex(0)
		end
	end
end
return Activity_9001496_BuffPanel
