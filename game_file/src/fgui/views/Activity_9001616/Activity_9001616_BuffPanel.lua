local activity_9001616_Read = include("activity_9001616_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001616_BuffPanel = class("Activity_9001616_BuffPanel", baseFguiPanel)
function Activity_9001616_BuffPanel:ctor(...)
	Activity_9001616_BuffPanel.super.ctor(self, ...)
	print("Activity_9001616_BuffPanel:ctor", self.viewName)
end
function Activity_9001616_BuffPanel:onInit()
	print("=======Activity_9001616_BuffPanel:onInit")
	self.fields.Panel_bg:setString(i18n("atlantiswar_skill_text_052"))
	self.fields.Text_tip:setString(i18n("sunmmon_ghoul_text18"))
end
function Activity_9001616_BuffPanel:onShow()
	print("=======Activity_9001616_BuffPanel:onShow")
	local buffDesRead = include("buffDesRead")
	local buffIndex = self.param and self.param.buffIndex
	local buffIcon = activity_9001616_Read.getBuffIcon(buffIndex)
	if buffIcon then
		self.fields.icon:setURL(buffIcon)
	end
	local buffStr = ""
	local buffList = activity_9001616_Read.getBuffList(buffIndex)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "value"
	local temp = serviceFunctions.tableFormat(buffList, nil)
	for i, v in ipairs(temp) do
		local _buffStr = buffDesRead.getTitleWithValue(v.id, v.value)
		buffStr = buffStr .. _buffStr
		if i ~= #temp then
			buffStr = buffStr .. "\n"
		end
	end
	self.fields.Text_buff:setString(buffStr)
end
return Activity_9001616_BuffPanel
