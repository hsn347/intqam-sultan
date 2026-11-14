local activity_9001602_Ctrl = SoraDGetCtrl("activity_9001602_Ctrl")
local activity_9001696_Ctrl = SoraDGetCtrl("activity_9001696_Ctrl")
local constantRead = include("constantRead")
local MAX_TASK = constantRead.getConstValue("FIREDRAGON_OF_ANGER_MAX_QUEST_NUM", 15)
local NEED_NUM = constantRead.getConstValue("FIREDRAGON_OF_ANGER_SUMMON_ITEM_NUM", 5)
local snowWolfLostRead = include("snowWolfLostRead")
local eventQuestRead = include("eventQuestRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_9001602_Task = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001602/Com_9001602_Task", Com_9001602_Task)
_ENV = fgui.register_extension
fgui.register_extension[gActivityTimeActivityID.NORMAL_ACTIVITY_9001602] = activity_9001602_Ctrl
local fgui.register_extension[gActivityTimeActivityID.NORMAL_ACTIVITY_9001696], activityCtrl = activity_9001696_Ctrl, fgui.register_extension
function Com_9001602_Task:onInit()
	self.fields.txt_title:setString(i18n("firedragon_of_anger_text5"))
	self.txt_time = SoraDCreateTimerLabel(self, self.fields.txt_time)
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.btn_cancel:addClickListener(handler(self, self.onCancel))
	self.fields.btn_accept:addClickListener(handler(self, self.onAccept))
	self.fields.btn_get:addClickListener(handler(self, self.onGetReward))
end
function Com_9001602_Task:onShow()
end
function Com_9001602_Task:initView(param, parent, activityID)
	self.activityID = activityID
	self.parent = parent
	if param then
		self:setTilePoint(param.titlePoint)
		self:initData(param.instanceID)
	end
	self.param = param
	self:updateView()
end
function Com_9001602_Task:updateView()
	if self.point then
		self.questInfo = activityCtrl[self.activityID]:getQuestInfo(self.point)
	else
		self.questInfo = activityCtrl[self.activityID]:getRunningQuestInfo()
	end
	if self.questInfo == nil then
		activityCtrl = activityCtrl[self.activityID]
		activityCtrl[self.activityID].msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
		SoraDSendMessage(activityCtrl[self.activityID])
		SoraDShowMsgTip(i18n("firedragon_of_anger_text7"))
		return
	end
	dump(self.questInfo, "self.questInfo===")
	local status = self.questInfo.state
	if gLosRuinsStatus.GIVE_UP == status then
		activityCtrl = "self.questInfo==="
		;("self.questInfo===").msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
		SoraDSendMessage("self.questInfo===")
		SoraDShowMsgTip(i18n("firedragon_of_anger_text7"))
		return
	end
	self.controllers.c1:setSelectedIndex(status == gLosRuinsStatus.COMPLETE and 1 or 0)
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
	activityCtrl = i18n("lost_ruins_text_22")
	i18n("lost_ruins_text_22").num = activityCtrl[self.activityID]:getFinishNum()
	i18n("lost_ruins_text_22").limitNum = MAX_TASK
	self.fields.txt_task_num:setString(i18n("lost_ruins_text_38", i18n("lost_ruins_text_22")))
	local isTwoBtnShow = gLosRuinsStatus.COMPLETE ~= status
	local aim = eventQuestRead.getAim(self.questInfo.questId)
	local progress = activityCtrl[self.activityID]:getQuestProgress(self.questInfo.questId)
	activityCtrl = " (%{num}/%{num2})"
	;(" (%{num}/%{num2})").num = progress
	;(" (%{num}/%{num2})").num2 = aim
	self.fields.txt_desc:setString(i18n_html(i18n(eventQuestRead.getDes(self.questInfo.questId)) .. " (%{num}/%{num2})", " (%{num}/%{num2})"))
	local awardConfig = eventQuestRead.getReward(self.questInfo.questId)
	self.awardConfig = awardConfig
	self.fields.scroll:setNumItems(#awardConfig)
end
function Com_9001602_Task:initActivityTime(isRunTime)
	local totalTime = snowWolfLostRead.getActivityTaskTimeByQuestId(self.questInfo.questId, self.activityID)
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
		local leftTime = math.max(0, totalTime - (serviceFunctions.systemTime() - activityCtrl[self.activityID]:getRunningQuestInfo().startTime))
		self.txt_time:beginTime(leftTime)
	else
		self.txt_time:endTime()
		snowWolfLostRead = activityCtrl[self.activityID]
		activityCtrl[self.activityID].time = SoraDConvertSecondToString(totalTime)
		self.txt_time:setString(i18n("lost_ruins_text_15", activityCtrl[self.activityID]))
	end
end
function Com_9001602_Task:setTilePoint(tilePoint)
	self.tilePoint = cc.p(tonumber(tilePoint.x), tonumber(tilePoint.y))
end
function Com_9001602_Task:getTilePoint()
	return self.tilePoint
end
function Com_9001602_Task:initData(instanceID)
	_UPVALUE0_, self.instanceID = nil, instanceID
	;(nil).x = self.tilePoint.x + 1
	self.point, (nil).y = nil, self.tilePoint.y + 1
end
function Com_9001602_Task:onItemRenderer(index, obj)
	obj:initData(self.awardConfig[index + 1].id, self.awardConfig[index + 1].count)
end
function Com_9001602_Task:onCancel()
	SoraDPlaySound()
	if gLosRuinsStatus.NOT_RECIEVE == self.questInfo.state then
		SoraDShowMsgBox(i18n("firedragon_of_anger_text6"), i18n("common_text_204"), i18n("common_text_185"), function(type)
			if MSGBOX_CALLBACK_YES == type then
				activityCtrl[self.activityID]:reqLegendOfPegasusGiveUp(self.point)
				if self.parent then
					self.parent:close()
				end
				_ENV = self.parent
				self.parent.msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
				SoraDSendMessage(self.parent)
			end
		end)
	elseif gLosRuinsStatus.RECIEVED == self.questInfo.state then
		SoraDShowMsgBox(i18n("firedragon_of_anger_text9"), i18n("common_text_204"), i18n("common_text_185"), function(type)
			if MSGBOX_CALLBACK_YES == type then
				activityCtrl[self.activityID]:reqLegendOfPegasusGiveUp(self.point)
				if self.parent then
					self.parent:close()
				end
				_ENV = self.parent
				self.parent.msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
				SoraDSendMessage(self.parent)
			end
		end)
	end
end
function Com_9001602_Task:onAccept()
	SoraDPlaySound()
	if gLosRuinsStatus.NOT_RECIEVE == self.questInfo.state then
		if activityCtrl[self.activityID]:getFinishNum() >= MAX_TASK then
			SoraDShowMsgTip(i18n("lost_ruins_text_18"))
		elseif next(activityCtrl[self.activityID]:getRunningQuestInfo()) then
			SoraDShowMsgTip(i18n("lost_ruins_text_17"))
		else
			activityCtrl[self.activityID]:reqLegendOfPegasusRecieveQuest(self.point)
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
function Com_9001602_Task:onGetReward()
	SoraDPlaySound()
	activityCtrl[self.activityID]:reqLegendOfPegasusRecieveReward()
	_ENV = activityCtrl[self.activityID]
	activityCtrl[self.activityID].msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
	SoraDSendMessage(activityCtrl[self.activityID])
end
return Activity_9001602
