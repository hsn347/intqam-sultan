local gametop = gModuleMgr.getObject("gametop")
local eventRushTaskCtrl = gametop.playertop_:getModule("eventRushTaskCtrl")
local eventRushTaskRead = include("eventRushTaskRead")
_ENV = "eventRushTaskRead"
_ENV = nil
;(nil).name = "spice_name_08"
;(nil).bg = "bg_activity_9001115.png"
;("eventRushTaskRead")[gEventRushActivityID.fullStrengthRush], (nil).handler = nil, true
_ENV = nil
;(nil).name = "activity_name_01"
;("eventRushTaskRead")[gEventRushActivityID.buildRush], (nil).bg = nil, "bg_activity_9001116.png"
_ENV = nil
;(nil).name = "activity_name_02"
;("eventRushTaskRead")[gEventRushActivityID.developmentRush], (nil).bg = nil, "bg_activity_9001117.png"
_ENV = nil
;(nil).name = "activity_name_03"
;("eventRushTaskRead")[gEventRushActivityID.trainRush], (nil).bg = nil, "bg_activity_9001118.png"
local gEventRushTaskConfig = "eventRushTaskRead"
local eventFullStrengthRush = class("eventFullStrengthRush", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventFullStrengthRush")
	end
	return target
end)
function eventFullStrengthRush:ctor()
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_target")
	self.Image_event = SoraDGetChildByName(self, "Image_event")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("eventRushTaskSingle")
	self.Node_time = SoraDGetChildByName(self, "Node_time")
	self.Node_time:setVisible(false)
	self.Text_time = SoraDGetChildByName(self.Node_time, "Text_time")
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
end
function eventFullStrengthRush:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_FULL_RUSH_UPDATE_TASK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function eventFullStrengthRush:judgeClose()
	if self.activityID and not clientEventMgr.judgeIsOpen(self.activityID) then
		self:removeFromParent()
	end
end
function eventFullStrengthRush:setTime()
	local remainTime = serviceFunctions.getTodayRemainTime()
	self.Text_time:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_4411", nil)
	end)
	self.Text_time:beginTime(remainTime)
	self.Node_time:setVisible(true)
	SoraDToCenter(self.Node_time)
end
function eventFullStrengthRush:initData(target, data)
	SoraDCloseLoading(self)
	self.taskList = eventRushTaskRead.getActivityTaskByID(self.strActivityID)
	self:sortData()
	_ENV = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	self.scroll:updateScrollView(cc.size(640, 170), self.taskList, 1, nil)
end
function eventFullStrengthRush:initActivity(activityID)
	self.activityID = activityID
	self.strActivityID = tostring(activityID)
	self.ccs_title:setTitle(i18n(gEventRushTaskConfig[self.strActivityID].name))
	self.Image_event:loadTexture(gEventRushTaskConfig[self.strActivityID].bg, ccui.TextureResType.plistType)
	if gEventRushTaskConfig[self.strActivityID].handler then
		self.ccs_title:setBtnHelpClickCallBack(handler(self, self.onBtnHelpClick))
	end
	self:setTime()
	self:initData()
end
function eventFullStrengthRush:sortData()
	local getStatus = function(data)
		local status = gBtnTargetStatusDef.GO
		if data.receive then
			status = gBtnTargetStatusDef.GOT
		elseif data.finishCount >= data.amount then
			status = gBtnTargetStatusDef.GET
		end
		return status
	end
	table.sort(self.taskList, function(a, b)
		local aData = eventRushTaskCtrl:getTaskData(a.amount, self.strActivityID)
		local bData = eventRushTaskCtrl:getTaskData(b.amount, self.strActivityID)
		a.status = getStatus(aData)
		b.status = getStatus(bData)
		if a.status == b.status then
			return a.taskID < b.taskID
		else
			return a.status < b.status
		end
	end)
end
function eventFullStrengthRush:onBtnHelpClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "common_text_4427"
		;("common_text_4427").align = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("common_text_4427"), "common_text_4427")
	end
end
return eventFullStrengthRush
