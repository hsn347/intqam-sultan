local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local equipmentltCtrl = include("equipmentltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_activity = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SmithyView/Com_activity", Com_activity)
function Com_activity:onInit()
	self.activityID = gActivityTimeActivityID.EQUIPMENT_REMAKE_ACTIVITY
	self.fields.Text_name:setString(i18n("activity_name_30"))
	self.fields.timer:setTimeEndListener(function()
		self:setVisible(false)
	end)
	self.fields.Button_help:addClickListener(handler(self, self.btnClick))
	self:fixChildrenPos()
end
function Com_activity:onShow()
end
function Com_activity:initData()
	local timer = activityShowCtrl:getTimeInfoByID(self.activityID)
	if timer then
		self.fields.timer:beginTime(timer.timerNode.timer:getRemainTime())
	end
end
function Com_activity:btnClick()
	SoraDPlaySound()
	local data = activityShowCtrl:getActivityData(self.activityID)
	if not data.param or not data.param.propertyList then
		_ENV = data.param.propertyList
	end
	self.propertyList = data.param.propertyList
	if not data.param or not data.param.rangeList then
		_ENV = data.param.rangeList
	end
	self.rangeList = data.param.rangeList
	local comStr = ""
	local rangeKey = ""
	local propertyKey = ""
	if next(self.propertyList) then
		propertyKey = i18n(equipmentltCtrl.getPropertyTypeByGroup(tonumber(self.propertyList[1])))
	end
	if next(self.rangeList) then
		rangeKey = i18n(equipmentltCtrl.getRangeByQuality(tonumber(self.rangeList[1])))
	end
	if not next(self.propertyList) and not next(self.rangeList) then
		return
	elseif next(self.propertyList) and next(self.rangeList) then
		_ENV = equipmentltCtrl.getRangeByQuality(tonumber(self.rangeList[1]))
		equipmentltCtrl.getRangeByQuality(tonumber(self.rangeList[1])).type = propertyKey
		equipmentltCtrl.getRangeByQuality(tonumber(self.rangeList[1])).num = rangeKey
		comStr = i18n("slim_text_03", equipmentltCtrl.getRangeByQuality(tonumber(self.rangeList[1])))
	elseif not next(self.propertyList) and next(self.rangeList) then
		_ENV = equipmentltCtrl.getRangeByQuality(tonumber(self.rangeList[1]))
		equipmentltCtrl.getRangeByQuality(tonumber(self.rangeList[1])).num = rangeKey
		comStr = i18n("slim_text_02", equipmentltCtrl.getRangeByQuality(tonumber(self.rangeList[1])))
	elseif next(self.propertyList) and not next(self.rangeList) then
		_ENV = equipmentltCtrl.getRangeByQuality(tonumber(self.rangeList[1]))
		equipmentltCtrl.getRangeByQuality(tonumber(self.rangeList[1])).type = propertyKey
		comStr = i18n("slim_text_01", equipmentltCtrl.getRangeByQuality(tonumber(self.rangeList[1])))
	end
	_ENV = equipmentltCtrl.getRangeByQuality(tonumber(self.rangeList[1]))
	equipmentltCtrl.getRangeByQuality(tonumber(self.rangeList[1])).float = SoraDFLabelR()
	SoraDShowHelpMsgTip(comStr, equipmentltCtrl.getRangeByQuality(tonumber(self.rangeList[1])))
end
return Com_activity
