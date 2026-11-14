local activity_9001702_Read = include("activity_9001702_Read")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_drawRecord = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001702/Com_drawRecord", Com_drawRecord)
function Com_drawRecord:onInit()
	self.isClose = false
	self.baseH = self:getHeight() - 64
	self.bgH = self.fields.bg:getHeight()
	self.offsetH = self:getHeight() - self.bgH
	self.colseH = self.fields.bg_line:getHeight()
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001702
	self.fields.Text_1th:setString(activity_9001702_Read.getLevelStr(1))
	self.fields.List_1th:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_value1:setString(i18n("god_beast_text_16"))
	self.fields.Text_2nd:setString(activity_9001702_Read.getLevelStr(2))
	self.fields.Text_3rd:setString(activity_9001702_Read.getLevelStr(3))
	self.fields.Button_arrow:addClickEventListener(handler(self, self.onClickArrow))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function Com_drawRecord:onShow()
end
function Com_drawRecord:onItemRenderer(index, obj)
	local number = self.numbers[index + 1]
	obj:setString(tostring(number))
	local isLuckNumber = self.luckNumberMap[number]
	local c1 = obj:getController("c1")
	c1:setSelectedIndex(isLuckNumber and 1 or 0)
end
function Com_drawRecord:initData(day, drawRecord, luckNumberMap)
	self.luckNumberMap = luckNumberMap
	local beginTime = activityShowCtrl:getBeginTimeSecond(self.activityID)
	local date = os.date("!%m-%d", beginTime + (day - 1) * 24 * 3600)
	self.fields.Text_date:setString(date)
	if not drawRecord["1"] then
		local activityShowCtrl, record1 = drawRecord["1"], drawRecord["1"]
	end
	if not record1.numbers then
		activityShowCtrl = record1.numbers
	end
	self.numbers = record1.numbers
	local count1 = #self.numbers
	self.fields.List_1th:setNumItems(count1)
	self.fields.List_1th:resizeToFit(count1)
	self.fields.Text_value1:setVisible(count1 <= 0)
	local value2Str = i18n("god_beast_text_16")
	if not drawRecord["2"] then
		local activityShowCtrl, record2 = drawRecord["2"], drawRecord["2"]
	end
	local count2 = record2.count or 0
	if 0 < count2 then
		activityShowCtrl = nil
		;(nil).num = count2
		value2Str = i18n("Eidal_celebration_text_29", nil)
	end
	self.fields.Text_value2:setString(value2Str)
	local value3Str = i18n("god_beast_text_16")
	if not drawRecord["3"] then
		local activityShowCtrl, record3 = drawRecord["3"], drawRecord["3"]
	end
	local count3 = record3.count or 0
	if 0 < count3 then
		activityShowCtrl = nil
		;(nil).num = count3
		value3Str = i18n("Eidal_celebration_text_29", nil)
	end
	self.fields.Text_value3:setString(value3Str)
	self.bgH = self.fields.List_1th:getHeight() + self.baseH - self.offsetH
	self.fields.bg:setHeight(self.bgH)
	if not self.isClose then
		self:setHeight(self.bgH + self.offsetH)
	end
end
function Com_drawRecord:onClickArrow()
	SoraDPlaySound()
	self.isClose = self.fields.Button_arrow:isSelected()
	if self.isClose then
		self:setHeight(self.colseH)
	else
		self:setHeight(self.bgH + self.offsetH)
	end
end
return Com_drawRecord
