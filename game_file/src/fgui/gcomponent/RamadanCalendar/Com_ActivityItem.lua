local activityTimeRead = include("activityTimeRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_ActivityItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RamadanCalendar/Com_ActivityItem", Com_ActivityItem)
local singleWidth = 78
function Com_ActivityItem:onInit()
	self.fields.Com_activity:addClickListener(handler(self, self.onClickActivity))
	self.Com_name = self.fields.Com_activity:getChild("Com_name")
	self.Load_color = self.fields.Com_activity:getChild("Load_color")
	self.Load_color:fix()
	self.c1 = self.fields.Com_activity:getController("c1")
end
function Com_ActivityItem:onShow()
	self.Com_name:fixChildrenPos()
end
function Com_ActivityItem:initData(data, beginWeek, endWeek)
	self.data = data
	local comWidth = singleWidth * (endWeek - beginWeek + 1)
	self.fields.Com_activity:setSize(comWidth, self.fields.Com_activity:getHeight())
	local posx = (beginWeek - 1) * singleWidth
	if SoraDFIsRA() then
		posx = (7 - endWeek) * singleWidth
	end
	self.fields.Com_activity:setPositionX(posx)
	if data.endTime < serviceFunctions.systemTime() then
		self.c1:setSelectedIndex(2)
	elseif data.beginTime > serviceFunctions.systemTime() then
		self.c1:setSelectedIndex(0)
	else
		self.c1:setSelectedIndex(1)
	end
	local iconName = activityTimeRead.getActivityIconByID(data.activityID, data.classtype)
	self.Com_name:setIcon(iconName)
	local activityNameStr = i18n(activityTimeRead.getActivityNameByID(data.activityID, data.classtype))
	self.Com_name:setString(activityNameStr)
	local iconWidth = 70
	local needWidth = self.Com_name:getWidth()
	local totalWidth = singleWidth * (math.min(7, endWeek) - beginWeek + 1)
	print("==needWidth, totalWidth==", needWidth, totalWidth)
	if needWidth > totalWidth then
		if 90 < totalWidth then
			local str, _ = SoraDConvertOmissionText(totalWidth - 90, activityNameStr, 16)
			self.Com_name:setString(str)
		else
			self.Com_name:setString("")
		end
	end
	self.Com_name:setPositionX(SoraDFPosX(comWidth - totalWidth / 2, comWidth))
	local proxy = uiManager:getOrCreateProxy("RamadanCalendarMain")
	self.showRed = not proxy:getActivityClicked(data.activityID)
	self.Com_name:setReddot(self.showRed)
end
function Com_ActivityItem:setTodayWeek(todayWeek)
	local posx = (todayWeek - 1) * singleWidth
	if SoraDFIsRA() then
		posx = (7 - todayWeek) * singleWidth
	end
	self.fields.Image_Today:setPositionX(posx)
end
function Com_ActivityItem:onClickActivity(eventContext)
	SoraDPlaySound()
	if self.showRed then
		self.Com_name:setReddot(false)
		local proxy = uiManager:getOrCreateProxy("RamadanCalendarMain")
		if not proxy:getActivityClicked(self.data.activityID) then
			proxy:setActivityClicked(self.data.activityID)
		end
	end
	local clickPos = eventContext:getInput():getPosition()
	_ENV = nil
	;(nil).data = self.data
	;(nil).clickPos = clickPos
	uiManager:show("RamadanCalendarDetail", nil)
end
return Com_ActivityItem
