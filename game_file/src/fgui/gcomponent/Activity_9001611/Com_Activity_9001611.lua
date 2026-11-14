local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local activity_9001611_Ctrl = SoraDGetCtrl("activity_9001611_Ctrl")
local activity_9001611_Read = include("activity_9001611_Read")
local baseComponent = require("fgui.base.baseComponent")
local Com_Activity_9001611 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001611/Com_Activity_9001611", Com_Activity_9001611)
function Com_Activity_9001611:onInit()
	self.questList, _ENV, self.treasureList, _ENV, self.targetList, _ENV, self.activityID = gActivityTimeActivityID.HONOR_BACK_DAILY_ACTIVITY, gActivityTimeActivityID.HONOR_BACK_DAILY_ACTIVITY, gActivityTimeActivityID.HONOR_BACK_DAILY_ACTIVITY, gActivityTimeActivityID.HONOR_BACK_DAILY_ACTIVITY, gActivityTimeActivityID.HONOR_BACK_DAILY_ACTIVITY, gActivityTimeActivityID.HONOR_BACK_DAILY_ACTIVITY, gActivityTimeActivityID.HONOR_BACK_DAILY_ACTIVITY
	self.fields.Btn_help:addClickListener(handler(self, self.btnHelpClick))
	self.fields.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self.fields.Text_time:setTimeLast(function(strTime)
		_ENV = nil
		;(nil).time = strTime
		return i18n("Player_Return_test04", nil)
	end)
	self.fields.List_box:setItemRenderer(handler(self, self.onBoxRenderer))
	self.fields.List_treasure:setItemRenderer(handler(self, self.onTreasureRenderer))
	self.fields.Text_title:setString(i18n("common_text_4496"))
	self.fields.List_events:setVirtual()
	self.fields.List_events:setItemRenderer(handler(self, self.onListRenderer))
	self.fields.Btn_help:fixPos()
	self.fields.Text_point:fixPos()
	self.fields.Text_time:fixPos()
	self.fields.List_box:fixPos()
	self.fields.bar:setMax(100)
	self.fields.bar:setScaleX(SoraDFIsRA() and 1 or -1)
end
function Com_Activity_9001611:onBoxRenderer(index, obj)
	obj:initData(self.targetList[index + 1])
end
function Com_Activity_9001611:onTreasureRenderer(index, obj)
	obj:initData(self.treasureList[index + 1])
end
function Com_Activity_9001611:onListRenderer(index, obj)
	obj:initData(self.questList[index + 1])
end
function Com_Activity_9001611:onShow()
	self.fields.timer:initCommonActivityTime(self.activityID)
	self:initData()
end
function Com_Activity_9001611:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_9001611_UPDATE", handler(self, self.initData))
end
function Com_Activity_9001611:initData()
	local point = activity_9001611_Ctrl:getPoint()
	local backStarLv = lordInfoCtrl:getBackStarLv()
	local group = activity_9001611_Ctrl:getGroup()
	activity_9001611_Ctrl = nil
	;(nil).num = fguiHelper.getColorString("#70C723", point)
	self.fields.Text_point:setString(i18n("Player_Return_test05", nil))
	self.fields.Text_time:beginTime(serviceFunctions.getTodayRemainTime())
	self.targetList = activity_9001611_Read.getTargetCfg(group, backStarLv)
	self.fields.List_box:setNumItems(#self.targetList)
	local activity_9001611_Ctrl, stageList = self.fields.List_box.setNumItems, self.fields.List_box.setNumItems
	for k, v in ipairs(self.targetList) do
		table.insert(stageList, v.target)
	end
	local percent = SoraDGetStageValue(point, stageList)
	self.fields.bar:setValue(percent)
	self.treasureList = activity_9001611_Read.getCumuCfg(group, backStarLv)
	self.fields.List_treasure:setNumItems(#self.treasureList)
	self.questList = activity_9001611_Read.getTargetList()
	table.sort(self.questList, function(a, b)
		local isDoneA = self:isQuestDone(a)
		local isDoneB = self:isQuestDone(b)
		if isDoneA == isDoneB then
			return a.ID < b.ID
		else
			return not isDoneA
		end
	end)
	self.fields.List_events:setNumItems(#self.questList)
end
function Com_Activity_9001611:isQuestDone(data)
	local times = activity_9001611_Ctrl:getTimes(data.type)
	return times >= data.quest
end
function Com_Activity_9001611:btnHelpClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Player_Return_test06")
	uiManager:show("RuleView", nil)
end
return Com_Activity_9001611
