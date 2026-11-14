local iceDragonLostCtrl = SoraDGetCtrl("iceDragonLostCtrl")
local constantRead = include("constantRead")
local MAX_TASK = constantRead.getConstValue("ICEDRAGON_LOST_MAX_QUEST_NUM", 15)
local NEED_NUM = constantRead.getConstValue("ICEDRAGON_LOST_SUMMON_ITEM_NUM", 5)
local snowWolfLostRead = include("snowWolfLostRead")
local eventQuestRead = include("eventQuestRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_IceDragonLost_Task = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://IceDragonLost/Com_IceDragonLost_Task", Com_IceDragonLost_Task)
function Com_IceDragonLost_Task:onInit()
	self.txt_time = SoraDCreateTimerLabel(self, self.fields.txt_time)
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.btn_cancel:addClickListener(handler(self, self.onCancel))
	self.fields.btn_accept:addClickListener(handler(self, self.onAccept))
	self.fields.btn_get:addClickListener(handler(self, self.onGetReward))
	self:fixChildrenPos()
end
function Com_IceDragonLost_Task:onShow()
end
function Com_IceDragonLost_Task:initView(param, parent)
	self.parent = parent
	if param then
		self:setTilePoint(param.titlePoint)
		self:initData(param.instanceID)
	end
	self.param = param
	self:updateView()
end
function Com_IceDragonLost_Task:updateView()
	if self.point then
		self.questInfo = iceDragonLostCtrl:getQuestInfo(self.point)
	else
		self.questInfo = iceDragonLostCtrl:getRunningQuestInfo()
	end
	if self.questInfo == nil then
		iceDragonLostCtrl = iceDragonLostCtrl
		iceDragonLostCtrl.msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
		SoraDSendMessage(iceDragonLostCtrl)
		return
	end
	dump(self.questInfo, "self.questInfo===")
	local status = self.questInfo.state
	if gLosRuinsStatus.GIVE_UP == status then
		iceDragonLostCtrl = "self.questInfo==="
		;("self.questInfo===").msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
		SoraDSendMessage("self.questInfo===")
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
	iceDragonLostCtrl = i18n("lost_ruins_text_22")
	i18n("lost_ruins_text_22").num = iceDragonLostCtrl:getFinishNum()
	i18n("lost_ruins_text_22").limitNum = MAX_TASK
	self.fields.txt_task_num:setString(i18n("lost_ruins_text_38", i18n("lost_ruins_text_22")))
	local isTwoBtnShow = gLosRuinsStatus.COMPLETE ~= status
	self.fields.txt_desc:setString(i18n(eventQuestRead.getDes(self.questInfo.questId)))
	local awardConfig = eventQuestRead.getReward(self.questInfo.questId)
	self.awardConfig = awardConfig
	self.fields.scroll:setNumItems(#awardConfig)
end
function Com_IceDragonLost_Task:initActivityTime(isRunTime)
	local totalTime = snowWolfLostRead.getIceDragonTaskTimeByQuestId(self.questInfo.questId)
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
		local leftTime = math.max(0, totalTime - (serviceFunctions.systemTime() - iceDragonLostCtrl:getRunningQuestInfo().startTime))
		self.txt_time:beginTime(leftTime)
	else
		self.txt_time:endTime()
		snowWolfLostRead = iceDragonLostCtrl
		iceDragonLostCtrl.time = SoraDConvertSecondToString(totalTime)
		self.txt_time:setString(i18n("lost_ruins_text_15", iceDragonLostCtrl))
	end
end
function Com_IceDragonLost_Task:setTilePoint(tilePoint)
	self.tilePoint = cc.p(tonumber(tilePoint.x), tonumber(tilePoint.y))
end
function Com_IceDragonLost_Task:getTilePoint()
	return self.tilePoint
end
function Com_IceDragonLost_Task:initData(instanceID)
	_UPVALUE0_, self.instanceID = nil, instanceID
	;(nil).x = self.tilePoint.x + 1
	self.point, (nil).y = nil, self.tilePoint.y + 1
end
function Com_IceDragonLost_Task:onItemRenderer(index, obj)
	obj:initData(self.awardConfig[index + 1].id, self.awardConfig[index + 1].count)
end
function Com_IceDragonLost_Task:onCancel()
	SoraDPlaySound()
	if gLosRuinsStatus.NOT_RECIEVE == self.questInfo.state then
		SoraDShowMsgBox(i18n("lost_ruins_text_36"), i18n("common_text_204"), i18n("common_text_185"), function(type)
			if MSGBOX_CALLBACK_YES == type then
				iceDragonLostCtrl:reqIceDragonLostGiveUp(self.point)
				if self.parent then
					self.parent:close()
				end
				_ENV = self.parent
				self.parent.msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
				SoraDSendMessage(self.parent)
			end
		end)
	elseif gLosRuinsStatus.RECIEVED == self.questInfo.state then
		SoraDShowMsgBox(i18n("lost_ruins_text_19"), i18n("common_text_204"), i18n("common_text_185"), function(type)
			if MSGBOX_CALLBACK_YES == type then
				iceDragonLostCtrl:reqIceDragonLostGiveUp(self.point)
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
function Com_IceDragonLost_Task:onAccept()
	SoraDPlaySound()
	if gLosRuinsStatus.NOT_RECIEVE == self.questInfo.state then
		if iceDragonLostCtrl:getFinishNum() >= MAX_TASK then
			SoraDShowMsgTip(i18n("lost_ruins_text_18"))
		elseif next(iceDragonLostCtrl:getRunningQuestInfo()) then
			SoraDShowMsgTip(i18n("lost_ruins_text_17"))
		else
			iceDragonLostCtrl:reqIceDragonLostRecieveQuest(self.point)
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
function Com_IceDragonLost_Task:onGetReward()
	SoraDPlaySound()
	iceDragonLostCtrl:reqIceDragonLostRecieveReward()
	_ENV = iceDragonLostCtrl
	iceDragonLostCtrl.msg = "MESSAGE_WORLD_MAP_REMOVE_SELECTSHOWPANEL"
	SoraDSendMessage(iceDragonLostCtrl)
end
return Com_IceDragonLost_Task
