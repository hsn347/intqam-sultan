local mobilizationltCtrl = gModuleMgr.sharedMgr("mobilizationltCtrl")
local gametop = gModuleMgr.getObject("gametop")
local playerMobilizationCtrl = gametop.playertop_:getModule("playerMobilizationCtrl")
local colorGreen = cc.c3b(35, 255, 15)
local allianceTaskItemDetail = class("allianceTaskItemDetail", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("allianceTaskItemDetail")
	end
	if type(target) == "string" then
		return SoraDCreateTouchPanel(target)
	end
	return target
end)
function allianceTaskItemDetail:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	self.img_icon = SoraDGetChildByName(self, "img_icon")
	self.text_tip = SoraDGetChildByName(self, "text_tip")
	self.btn_accept = SoraDGetChildByName(self, "btn_accept")
	self.btn_giveup = SoraDGetChildByName(self, "btn_giveup")
	self.btn_commit = SoraDGetChildByName(self, "btn_commit")
	self.btn_go = SoraDGetChildByName(self, "btn_go")
	self.text_small_title = SoraDGetChildByName(self, "text_small_title")
	self.node_text_info = SoraDGetChildByName(self, "node_text_info")
	self.node_button = SoraDGetChildByName(self, "Node_button")
	self.text_complete_title = SoraDGetChildByName(self, "text_complete_title")
	self.text_complete_value = SoraDGetChildByName(self, "text_complete_value")
	self.text_time = SoraDGetChildByName(self, "text_time")
	self.text_f_score = SoraDGetChildByName(self, "text_f_score")
	self.labelTime = SoraDGetChildByName(self, "Text_timeLabel")
	self.labelScore = SoraDGetChildByName(self, "Text_f_scoreLabel")
	self.text_complete_tip = SoraDGetChildByName(self, "text_complete_tip")
	self.icon_hourglass = SoraDGetChildByName(self, "icon_hourglass")
	self.btn_accept:addTouchEventListener(handler(self, self.onClick_btn_accept))
	self.btn_giveup:addTouchEventListener(handler(self, self.onClick_btn_giveup))
	self.btn_commit:addTouchEventListener(handler(self, self.onClick_btn_commit))
	self.btn_go:addTouchEventListener(handler(self, self.onClick_btn_go))
	self.btn_accept:setVisible(false)
	self.btn_giveup:setVisible(false)
	self.btn_commit:setVisible(false)
	self.btn_go:setVisible(false)
	self.btn_accept:setTitleText(i18n("common_text_3093"))
	self.btn_giveup:setTitleText(i18n("common_text_3626"))
	self.btn_commit:setTitleText(i18n("common_text_3628"))
	self.btn_go:setTitleText(i18n("common_text_477"))
	_ENV = i18n("common_text_477")
	i18n("common_text_477").time = ""
	self.labelTime:setString(i18n("hero_text_80", i18n("common_text_477")))
	self.labelScore:setString(i18n("common_text_623"))
	self.text_tip:setVisible(false)
	self.img_icon:loadTexture(SoraDCheckPNG("bg_activity_show_9000058.png", gDefaultPNG.ACTIVITY_BG), ccui.TextureResType.plistType)
end
function allianceTaskItemDetail:init(data)
	self.btn_accept:setVisible(false)
	self.btn_giveup:setVisible(false)
	self.btn_commit:setVisible(false)
	self.btn_go:setVisible(false)
	self.itemData = data
	local taskType = self.itemData.taskType
	if taskType == gMobilizationTaskType.USER then
		self.btn_accept:setVisible(false)
		print("这是个人任务-----------")
		if self.itemData.mission.taskstatus == gMobilizationTaskStatus.TASK_STATUS_DOING then
			print("进行中----")
			local tasktypeid = self.itemData.mission.tasktypeid
			self.text_f_score:setString("+" .. self.itemData.mission.point)
			self.ccs_bg:setTitleName(i18n(mobilizationltCtrl:getTaskName(tasktypeid)), cc.c3b(240, 230, 210))
			self.text_small_title:setString(i18n(mobilizationltCtrl:getTaskDes(tasktypeid)))
			_ENV = i18n(mobilizationltCtrl:getTaskDes(tasktypeid))
			i18n(mobilizationltCtrl:getTaskDes(tasktypeid)).member = self.itemData.mission.curnum
			i18n(mobilizationltCtrl:getTaskDes(tasktypeid)).total = self.itemData.mission.conditionnum
			self.text_complete_value:setString(i18n("common_text_155", i18n(mobilizationltCtrl:getTaskDes(tasktypeid))))
			self.text_complete_title:setString(i18n("common_text_2601"))
			local timeStr = SoraDConvertSecondToString(self.itemData.mission.endtime.timer:getRemainTime())
			self.text_time:setString(timeStr)
			self.timer = self.itemData.mission.endtime.timer
			self:beginTime()
			self.btn_giveup:setVisible(true)
			self.btn_go:setVisible(true)
			self.btn_giveup:setPositionX(SoraDFIsRA() and 460 or 180)
			self.btn_go:setPositionX(SoraDFIsRA() and 180 or 460)
			SoraDToCenter(self.node_text_info, 5)
			self.node_button:setPositionY(-190)
		elseif self.itemData.mission.taskstatus == gMobilizationTaskStatus.TASK_STATUS_TIME_OUT then
			print("任务超时了----")
			local tasktypeid = self.itemData.mission.tasktypeid
			self.text_f_score:setString("+" .. self.itemData.mission.point)
			self.ccs_bg:setTitleName(i18n(mobilizationltCtrl:getTaskName(tasktypeid)), cc.c3b(240, 230, 210))
			self.text_small_title:setString(i18n(mobilizationltCtrl:getTaskDes(tasktypeid)))
			self.btn_giveup:setVisible(true)
			self.btn_giveup:setPositionX(320)
			self.btn_go:setVisible(false)
			self.text_complete_tip:setString(i18n("common_text_3627"))
			_UPVALUE4_ = self.text_complete_tip.setString
			self.text_complete_tip.setString[1] = self.text_time
			self.text_complete_tip.setString[2] = self.text_complete_title
			self.text_complete_tip.setString[3] = self.text_complete_value
			local self.text_complete_tip.setString[4], hideTb = self.icon_hourglass, self.text_complete_tip.setString
			SoraDSetNodeArrayVisible(hideTb, false)
			self.node_button:setPositionY(-180)
		elseif self.itemData.mission.taskstatus == gMobilizationTaskStatus.TASK_STATUS_COMPLETE then
			print("任务完成----")
			local tasktypeid = self.itemData.mission.tasktypeid
			self.text_f_score:setString("+" .. self.itemData.mission.point)
			self.ccs_bg:setTitleName(i18n(mobilizationltCtrl:getTaskName(tasktypeid)), cc.c3b(240, 230, 210))
			self.text_small_title:setString(i18n(mobilizationltCtrl:getTaskDes(tasktypeid)))
			_ENV = i18n(mobilizationltCtrl:getTaskDes(tasktypeid))
			i18n(mobilizationltCtrl:getTaskDes(tasktypeid)).member = self.itemData.mission.curnum
			i18n(mobilizationltCtrl:getTaskDes(tasktypeid)).total = self.itemData.mission.conditionnum
			self.text_complete_value:setString(i18n("common_text_155", i18n(mobilizationltCtrl:getTaskDes(tasktypeid))))
			self.text_complete_title:setString(i18n("common_text_2601"))
			self.text_complete_value:setColor(colorGreen)
			local timeStr = SoraDConvertSecondToString(self.itemData.mission.endtime.timer:getRemainTime())
			self.text_time:setString(timeStr)
			self.btn_commit:setVisible(true)
			self.timer = self.itemData.mission.endtime.timer
			self.text_time:setVisible(true)
			self:beginTime()
			SoraDToCenter(self.node_text_info, 5)
			self.node_button:setPositionY(-190)
		end
	elseif taskType == gMobilizationTaskType.ALLIANCE then
		local tasktypeid = self.itemData.mission.tasktypeid
		self.text_f_score:setString("+" .. self.itemData.mission.point)
		self.ccs_bg:setTitleName(i18n(mobilizationltCtrl:getTaskName(tasktypeid)), cc.c3b(240, 230, 210))
		self.text_small_title:setString(i18n(mobilizationltCtrl:getTaskDes(tasktypeid)))
		local activityStatus = playerMobilizationCtrl:getActivityStatus()
		dump(self.itemData.mission, "self.itemData.mission == ")
		local remainTime = self.itemData.mission.lasttime
		local timeStr = SoraDConvertSecondToString(remainTime)
		self.text_time:setString(timeStr)
		self.btn_giveup:setVisible(false)
		self.btn_go:setVisible(false)
		local userMissionData = playerMobilizationCtrl:getPersonalMissionData()
		local missiontimes = userMissionData.missiontimes
		local canAcceptTime = userMissionData.missiontimes + userMissionData.buymissiontimes - userMissionData.totalmissiontimes
		if 0 < canAcceptTime then
			if userMissionData.curmission and (userMissionData.curmission.taskstatus == gMobilizationTaskStatus.TASK_STATUS_DOING or userMissionData.curmission.taskstatus == gMobilizationTaskStatus.TASK_STATUS_COMPLETE) then
				self.btn_accept:setVisible(false)
				self.text_tip:setString(i18n("common_text_3589"))
				self.text_tip:setVisible(true)
				SoraDGetAutoHeightLabel(self.text_tip, 550)
			elseif userMissionData.curmission and userMissionData.curmission.taskstatus == gMobilizationTaskStatus.TASK_STATUS_TIME_OUT then
				self.btn_accept:setVisible(true)
				self.text_tip:setVisible(false)
			else
				self.btn_accept:setVisible(true)
				self.text_tip:setVisible(false)
			end
		else
			self.text_tip:setString(i18n("common_text_3588"))
			self.text_tip:setVisible(true)
		end
	end
end
function allianceTaskItemDetail:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_TASK_ACCEPT_BACK", handler(self, self.sMsgTaskAccept))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_TASK_ABORT_BACK", handler(self, self.sMsgTaskAbort))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_TASK_COMMIT_BACK", handler(self, self.sMsgCommitBack))
end
function allianceTaskItemDetail:onClick_btn_accept(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local taskindex = self.itemData.mission.index
		print("请求接受任务-----", taskindex)
		playerMobilizationCtrl:reqMissionAccept(taskindex)
		local loading = SoraDShowLoading(self.btn_accept, self.btn_accept:getContentSize())
		if loading.loadingImg then
			loading.loadingImg:setScale(35 / loading.loadingImg:getContentSize().height)
		end
		loading:setPosition(cc.p(self.btn_accept:getContentSize().width / 2, self.btn_accept:getContentSize().height / 2))
	end
end
function allianceTaskItemDetail:onClick_btn_giveup(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tasktypeid = self.itemData.mission.tasktypeid
		print("请求放弃任务-----", tasktypeid)
		_ENV = nil
		;(nil).num = 1
		SoraDShowMsgBox(i18n("common_text_3591", nil), i18n("common_text_204"), i18n("common_text_185"), function(event)
			if event == MSGBOX_CALLBACK_YES then
				playerMobilizationCtrl:reqMissionAbort(tasktypeid)
				local loading = SoraDShowLoading(self.btn_giveup, self.btn_giveup:getContentSize())
				if loading.loadingImg then
					loading.loadingImg:setScale(35 / loading.loadingImg:getContentSize().height)
				end
				loading:setPosition(cc.p(self.btn_giveup:getContentSize().width / 2, self.btn_giveup:getContentSize().height / 2))
			end
		end)
	end
end
function allianceTaskItemDetail:onClick_btn_commit(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tasktypeid = self.itemData.mission.tasktypeid
		print("请求提交任务-----", tasktypeid)
		playerMobilizationCtrl:reqMissionComplete(tasktypeid)
		local loading = SoraDShowLoading(self.btn_commit, self.btn_commit:getContentSize())
		if loading.loadingImg then
			loading.loadingImg:setScale(35 / loading.loadingImg:getContentSize().height)
		end
		loading:setPosition(cc.p(self.btn_commit:getContentSize().width / 2, self.btn_commit:getContentSize().height / 2))
	end
end
function allianceTaskItemDetail:onClick_btn_go(sender, event)
	if event == ccui.TouchEventType.ended then
		local tasktypeid = self.itemData.mission.tasktypeid
		print("tasktypeid = ", tasktypeid)
		local guideId = mobilizationltCtrl:getGuideId(tasktypeid)
		SoraDPlaySound()
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		print("guideId = ", guideId)
		if guideId then
			local ret = mildGuideManager:starMildByNewPlayerStringParam(guideId)
			if ret ~= false then
				SoraDRemoveAllPanelFromManager()
			end
		end
	end
end
function allianceTaskItemDetail:beginTime()
	if self.timeHandler then
		SoraDManagerRemoveTimer(self, self.timeHandler)
	end
	self.timeHandler = SoradCreateTimer(self, handler(self, self.updateTime))
end
function allianceTaskItemDetail:updateTime()
	local timeStr = SoraDConvertSecondToString(self.timer:getRemainTime())
	self.text_time:setString(timeStr)
end
function allianceTaskItemDetail:endTime()
	SoraDManagerRemoveTimer(self, self.timeHandler)
end
function allianceTaskItemDetail:sMsgTaskAccept(target, data)
	if data.err == gErrDef.Err_None then
		local taskindex = data.index
		self:initUserMission()
	end
end
function allianceTaskItemDetail:initUserMission()
	local userMissionData = playerMobilizationCtrl:getPersonalMissionData()
	playerMobilizationCtrl = playerMobilizationCtrl
	playerMobilizationCtrl.mission = userMissionData.curmission
	local playerMobilizationCtrl.taskType, missionData = gMobilizationTaskType.USER, playerMobilizationCtrl
	self:init(missionData)
end
function allianceTaskItemDetail:sMsgTaskAbort(target, data)
	print("接收到放弃任务的消息 -------")
	self:close(nil, ccui.TouchEventType.ended)
end
function allianceTaskItemDetail:sMsgCommitBack(target, data)
	self:close(nil, ccui.TouchEventType.ended)
end
return allianceTaskItemDetail
