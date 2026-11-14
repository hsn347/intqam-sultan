local baseComponent = require("fgui.base.baseComponent")
local Com_frameTitle = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://CommonNew/Com_frameTitle", Com_frameTitle)
fgui.register_extension("ui://CommonNew/Com_frameTitle_activity", Com_frameTitle)
fgui.register_extension("ui://EventCenterView/Com_ramadanTitle", Com_frameTitle)
fgui.register_extension("ui://CommonNew/Com_frameTitle_tabTime", Com_frameTitle)
function Com_frameTitle:onInit()
	print("Com_frameTitle:onInit")
	self.fields.Button_help:setVisible(false)
	if self.fields.Button_helpSmall then
		self.fields.Button_helpSmall:fixPos()
	end
end
function Com_frameTitle:onShow()
	self:initStyle()
	if self.activityID then
		self:updateActivityTime()
	end
end
function Com_frameTitle:initData(title, closeCallback, helpCallback)
	self:setTitle(title)
	self:setCloseCallback(closeCallback)
	self:setHelpCallBack(helpCallback)
end
function Com_frameTitle:updateTitle(title)
	self:setTitle(title)
end
function Com_frameTitle:setString(...)
	self:setTitle(...)
end
function Com_frameTitle:setTitle(...)
	self:setText(...)
	self:addTextEffect()
end
function Com_frameTitle:initStyle(style)
end
function Com_frameTitle:initTab(param)
	if self.fields.com_Tab then
		self.fields.com_Tab:initView(param)
	end
end
function Com_frameTitle:setBtnRedDot(index, visible, num)
	if self.fields.com_Tab then
		self.fields.com_Tab:setBtnRedDot(index, visible, num)
	end
end
function Com_frameTitle:setTabIndex(...)
	if self.fields.com_Tab then
		self.fields.com_Tab:setTabIndex(...)
	end
end
function Com_frameTitle:setTabShow(visible)
	if self.fields.com_Tab then
		self.fields.com_Tab:setVisible(visible)
	end
	if self.fields.Label_time then
		self.fields.Label_time:setVisible(visible)
	end
	if self.controllers.c1 then
		self.controllers.c1:setSelectedIndex(visible and 1 or 0)
	end
end
function Com_frameTitle:setCloseCallback(callback)
	if callback then
		self.fields.Button_close:addClickListener(callback)
	end
end
function Com_frameTitle:setHelpCallBack(callback)
	if callback then
		self.fields.Button_help:setVisible(true)
		self.fields.Button_help:addClickListener(callback)
	else
		self.fields.Button_help:setVisible(false)
	end
end
function Com_frameTitle:setBtnHelpVisible(ret)
	if self.fields.Button_help then
		self.fields.Button_help:setVisible(ret)
	end
end
function Com_frameTitle:setSmallHelpCallBack(callback)
	if callback then
		if self.fields.Button_helpSmall then
			self.fields.Button_helpSmall:setVisible(true)
			self.fields.Button_helpSmall:addClickListener(callback)
		end
	elseif self.fields.Button_helpSmall then
		self.fields.Button_helpSmall:setVisible(false)
	end
end
function Com_frameTitle:setSmallHelpIcon(icon, isForceRight)
	if self.fields.Button_helpSmall then
		self.fields.Button_helpSmall:setVisible(true)
		self.fields.Button_helpSmall:setIcon(icon)
		if isForceRight then
			self.fields.Button_helpSmall:setPositionX(self.fields.title:getPositionX() + self.fields.title:getWidth() / 2 + 15)
		end
	end
end
function Com_frameTitle:setTitleWidthHeight(width, height)
	self.fields.title:setAutoSize(fgui.AutoSizeType.SHRINK)
	self.fields.title:setSize(width, height)
end
function Com_frameTitle:getTitleWidth()
	return self.fields.title:getWidth()
end
function Com_frameTitle:initCommonActivityTime(activityID, handle)
	if self.fields.Label_time then
		self.activityID = activityID
		self.activityTimeHandle = handle
		self.fields.Label_time:initCommonActivityTime(activityID, handle)
	end
end
function Com_frameTitle:initActivityData(activityID, closeCallback, helpCallback)
	local activityTimeRead = include("activityTimeRead")
	local activityName = activityTimeRead.getActivityShowName(activityID)
	self:initData(activityName, closeCallback, helpCallback)
	self.activityID = activityID
	self:updateActivityTime()
end
function Com_frameTitle:updateActivityTime()
	if not self.fields.Label_time then
		return
	end
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	if activityShowCtrl:isStageActivity(self.activityID) then
		local key = activityShowCtrl:getStageTimeStr(self.activityID)
		_ENV = nil
		;(nil).time = ""
		local leftStr = i18n(key, nil)
		self:initSpecialActivityTimeNew(self.activityID, leftStr)
	else
		self:initCommonActivityTime(self.activityID, self.activityTimeHandle)
	end
end
function Com_frameTitle:initSpecialActivityTime(leftTime, leftStr)
	if self.fields.Label_time then
		self.fields.Label_time:initSpecialActivityTime(leftTime, leftStr)
	end
end
function Com_frameTitle:initSpecialTime(leftTime, leftStr)
	if self.fields.Label_time then
		self.fields.Label_time:initSpecialTime(leftTime, leftStr)
	end
end
function Com_frameTitle:initSpecialActivityTimeNew(activityID, leftStr)
	if self.fields.Label_time then
		self.fields.Label_time:initSpecialActivityTimeNew(activityID, leftStr)
	end
end
function Com_frameTitle:setTimeShow(ret)
	if self.controllers.c2 then
		self.controllers.c2:setSelectedIndex(ret and 0 or 1)
	end
end
function Com_frameTitle:setTimeShowIndex(idx)
	if self.controllers.c2 then
		self.controllers.c2:setSelectedIndex(idx)
	end
end
function Com_frameTitle:setBlackShowIndex(idx)
	if self.controllers.c1 then
		self.controllers.c1:setSelectedIndex(idx)
	end
end
function Com_frameTitle:getLabelTime(...)
	return self.fields.Label_time
end
function Com_frameTitle:addTextEffect(fromColor, toColor)
	self.fields.title:enableGradient(fromColor or cc.c3b(230, 219, 197), toColor or cc.c3b(178, 140, 68))
	self.fields.title:enableShadow(cc.c3b(15, 6, 2), cc.size(2, -2))
end
function Com_frameTitle:fixChildrenPos()
	print("忽略fixChildrenPos")
end
function Com_frameTitle:gameGuide_getTarget(itemName, parameters)
	return self.fields[itemName]
end
return Com_frameTitle
