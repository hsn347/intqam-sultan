local gametop = gModuleMgr.getObject("gametop")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local eventQuestRead = include("eventQuestRead")
local RLC = require_data("return_login_config", true)
local eventGloryGiftLayer = class("eventGloryGiftLayer", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventGloryGiftLayer")
	end
	return target
end)
function eventGloryGiftLayer:ctor()
	self.isHidePrePanel = false
	self.activityID = gActivityTimeActivityID.FRIEND_HONORBACK
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("return_wzzl_text_015"))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("eventGloryGiftSingle")
	self:initData()
	self.tips = SoraDGetChildByName(self, "act_tips")
	self.tips:setString(i18n("task_text_02"))
end
function eventGloryGiftLayer:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_HONOR_BACK_UPDATE_TASK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function eventGloryGiftLayer:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		self:removeFromParent()
	end
end
function eventGloryGiftLayer:getSortList()
	local _ENV, ret
	local RKT = require_data("return_kinggift_task", true)
	local ctrl = SoraDGetCtrl("honorBackCtrl")
	local taskList = ctrl.gloryTask
	_ENV = nil
	;(nil)[gFriendCallbackTaskStatus.TASK_STATUS_DOING] = gBtnTargetStatusDef.GO
	;(nil)[gFriendCallbackTaskStatus.TASK_STATUS_COMPLETE] = gBtnTargetStatusDef.GET
	local (nil)[gFriendCallbackTaskStatus.TASK_STATUS_COMPLETE_DONE], statusTrans = gBtnTargetStatusDef.GOT, nil
	for i, v in ipairs(RKT.data) do
		local questID = v.taskID
		local count = 0
		local cfgItem = v
		local taskStatus = gBtnTargetStatusDef.GO
		if taskList then
			if not ctrl:getGlotyTaskInfo(questID) then
				local _ENV, sInfo = ctrl:getGlotyTaskInfo(questID), ctrl:getGlotyTaskInfo(questID)
			end
			count = sInfo.curnum or 0
			taskStatus = statusTrans[sInfo.taskstatus]
		end
		_ENV = questID
		questID.activityID = activityID
		questID.taskID = questID
		questID.count = count
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		questID.award = serviceFunctions.tableFormat(cfgItem.Reward, nil)
		questID.total = cfgItem.Quest
		questID.taskStatus = taskStatus
		questID.taskDes = cfgItem.name
		questID.guideId = cfgItem.guildID
		table.insert(ret, questID)
	end
	table.sort(ret, function(a, b)
		if a.taskStatus ~= b.taskStatus then
			return a.taskStatus < b.taskStatus
		end
		return a.taskID < b.taskID
	end)
	return ret
end
function eventGloryGiftLayer:initData(target, data)
	SoraDCloseLoading(self)
	local ctrl = SoraDGetCtrl("honorBackCtrl")
	local taskList = self:getSortList()
	_ENV = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	;(nil).activityID = self.activityID
	self.scroll:updateScrollView(cc.size(640, 170), taskList, 1, nil)
end
return eventGloryGiftLayer
