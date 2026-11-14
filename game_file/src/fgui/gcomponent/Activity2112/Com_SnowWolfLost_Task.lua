local baseComponent = require("fgui.base.baseComponent")
local snowWolfLostCtrl = SoraDGetCtrl("snowWolfLostCtrl")
local constantRead = include("constantRead")
local MAX_TASK = constantRead.getConstValue("SNOWWOLF_LOST_MAX_QUEST_NUM", 15)
local NEED_NUM = constantRead.getConstValue("SNOWWOLF_LOST_SUMMON_ITEM_NUM", 5)
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local snowWolfLostRead = include("snowWolfLostRead")
local eventQuestRead = include("eventQuestRead")
local Com_SnowWolfLost_Task = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity2112/Com_SnowWolfLost_Task", Com_SnowWolfLost_Task)
function Com_SnowWolfLost_Task:onInit()
	self.txt_time = SoraDCreateTimerLabel(self, self.fields.txt_time)
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.btn_cancel:addClickEventListener(handler(self, self.onCancel))
	self.fields.btn_accept:addClickEventListener(handler(self, self.onAccept))
	self.fields.btn_get:addTouchEventListener(handler(self, self.onGetReward))
end
function Com_SnowWolfLost_Task:onShow()
end
function Com_SnowWolfLost_Task:initView(param)
	if param then
		self:setTilePoint(param.titlePoint)
		self:initData(param.instanceID)
	end
	self.param = param
	self:updateView()
end
function Com_SnowWolfLost_Task:updateView()
	if self.point then
		self.questInfo = snowWolfLostCtrl:getQuestInfo(self.point)
	else
		self.questInfo = snowWolfLostCtrl:getRunningQuestInfo()
	end
	if self.questInfo == nil then
		snowWolfLostCtrl = snowWolfLostCtrl
		snowWolfLostCtrl.msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
		SoraDSendMessage(snowWolfLostCtrl)
		return
	end
	local status = self.questInfo.state
	if gLosRuinsStatus.GIVE_UP == status then
		snowWolfLostCtrl = self.point
		self.point.msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
		SoraDSendMessage(self.point)
		return
	end
	self.controllers.c2:setSelectedIndex(status == gLosRuinsStatus.COMPLETE and 1 or 0)
	if gLosRuinsStatus.NOT_RECIEVE == status then
		self.fields.btn_cancel:setTitle(i18n("common_text_091"))
		self.fields.btn_accept:setTitle(i18n("common_text_3093"))
		self:initActivityTime(false)
	elseif gLosRuinsStatus.RECIEVED == status then
		self.fields.btn_cancel:setTitle(i18n("common_text_3626"))
		self.fields.btn_accept:setTitle(i18n("common_text_477"))
		self:initActivityTime(true)
	elseif gLosRuinsStatus.COMPLETE == status then
		self.fields.btn_get:setTitle(i18n("common_text_1146"))
		self.fields.txt_complete:setString(i18n("lost_ruins_text_22"))
	end
	snowWolfLostCtrl = i18n("lost_ruins_text_22")
	i18n("lost_ruins_text_22").num = snowWolfLostCtrl:getFinishNum()
	i18n("lost_ruins_text_22").limitNum = MAX_TASK
	self.fields.txt_task_num:setString(i18n("lost_ruins_text_38", i18n("lost_ruins_text_22")))
	local isTwoBtnShow = gLosRuinsStatus.COMPLETE ~= status
	self.fields.txt_desc:setString(i18n(eventQuestRead.getDes(self.questInfo.questId)))
	local awardConfig = eventQuestRead.getReward(self.questInfo.questId)
	self.awardConfig = awardConfig
	self.fields.scroll:setNumItems(#awardConfig)
end
function Com_SnowWolfLost_Task:initActivityTime(isRunTime)
	local totalTime = snowWolfLostRead.getTaskTimeByQuestId(self.questInfo.questId)
	if isRunTime then
		self.txt_time:setTimeEndListener(handler(self, function()
			_ENV = nil
			;(nil).msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
			SoraDSendMessage(nil)
		end))
		self.txt_time:setTimeLast(function(ticket)
			_ENV = nil
			;(nil).time = ticket
			return i18n("lost_ruins_text_15", nil)
		end)
		local leftTime = math.max(0, totalTime - (serviceFunctions.systemTime() - snowWolfLostCtrl:getRunningQuestInfo().startTime))
		self.txt_time:beginTime(leftTime)
	else
		self.txt_time:endTime()
		snowWolfLostRead = snowWolfLostCtrl
		snowWolfLostCtrl.time = SoraDConvertSecondToString(totalTime)
		self.txt_time:setString(i18n("lost_ruins_text_15", snowWolfLostCtrl))
	end
end
function Com_SnowWolfLost_Task:setTilePoint(tilePoint)
	self.tilePoint = cc.p(tonumber(tilePoint.x), tonumber(tilePoint.y))
end
function Com_SnowWolfLost_Task:getTilePoint()
	return self.tilePoint
end
function Com_SnowWolfLost_Task:initData(instanceID)
	_UPVALUE0_, self.instanceID = nil, instanceID
	;(nil).x = self.tilePoint.x + 1
	self.point, (nil).y = nil, self.tilePoint.y + 1
end
function Com_SnowWolfLost_Task:onItemRenderer(index, obj)
	fguiHelper.get_fields(obj).item:initData(self.awardConfig[index + 1].id, self.awardConfig[index + 1].count)
end
function Com_SnowWolfLost_Task:onCancel()
	SoraDPlaySound()
	if gLosRuinsStatus.NOT_RECIEVE == self.questInfo.state then
		SoraDShowMsgBox(i18n("lost_ruins_text_36"), i18n("common_text_204"), i18n("common_text_185"), function(type)
			if MSGBOX_CALLBACK_YES == type then
				snowWolfLostCtrl:reqSnowWolfLostGiveUp(self.point)
				_ENV = snowWolfLostCtrl
				snowWolfLostCtrl.msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
				SoraDSendMessage(snowWolfLostCtrl)
			end
		end)
	elseif gLosRuinsStatus.RECIEVED == self.questInfo.state then
		SoraDShowMsgBox(i18n("lost_ruins_text_19"), i18n("common_text_204"), i18n("common_text_185"), function(type)
			if MSGBOX_CALLBACK_YES == type then
				snowWolfLostCtrl:reqSnowWolfLostGiveUp(self.point)
				_ENV = snowWolfLostCtrl
				snowWolfLostCtrl.msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
				SoraDSendMessage(snowWolfLostCtrl)
			end
		end)
	end
end
function Com_SnowWolfLost_Task:onAccept()
	SoraDPlaySound()
	if gLosRuinsStatus.NOT_RECIEVE == self.questInfo.state then
		if snowWolfLostCtrl:getFinishNum() >= MAX_TASK then
			SoraDShowMsgTip(i18n("lost_ruins_text_18"))
		elseif next(snowWolfLostCtrl:getRunningQuestInfo()) then
			SoraDShowMsgTip(i18n("lost_ruins_text_17"))
		else
			snowWolfLostCtrl:reqSnowWolfLostRecieveQuest(self.point)
		end
	elseif gLosRuinsStatus.RECIEVED == self.questInfo.state then
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		local guideId = eventQuestRead.getGuideId(self.questInfo.questId)
		local tbParam = mildGuideManager:splitGuideParam(guideId)
		if tbParam.id == gNewPLayerTaskType.POP_TIP then
			SoraDShowMsgTip(i18n(eventQuestRead.getDes(self.questInfo.questId)))
			return
		end
		if guideId then
			local ret, notNeedClose = mildGuideManager:starMildByNewPlayerStringParam(guideId)
			if not notNeedClose then
				_ENV = i18n(eventQuestRead.getDes(self.questInfo.questId))
				i18n(eventQuestRead.getDes(self.questInfo.questId)).msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
				SoraDSendMessage(i18n(eventQuestRead.getDes(self.questInfo.questId)))
			end
		end
	end
end
function Com_SnowWolfLost_Task:onGetReward()
	SoraDPlaySound()
	snowWolfLostCtrl:reqSnowWolfLostRecieveReward()
	_ENV = snowWolfLostCtrl
	snowWolfLostCtrl.msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
	SoraDSendMessage(snowWolfLostCtrl)
end
return Com_SnowWolfLost_Task
