local activity_9001479_Ctrl = SoraDGetCtrl("activity_9001479_Ctrl")
local activity_9001479_Read = include("activity_9001479_Read")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local nebulaWarRead = include("nebulaWarRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001479_MainPanel = class("Activity_9001479_MainPanel", baseFguiPanel)
local string_fnt = string.formatnumberthousands
function Activity_9001479_MainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001479_MainPanel:ctor", self.viewName)
	self.data = activity_9001479_Ctrl:getActivityData()
	local curRound, curBatch = activity_9001479_Read.getRoundAndBatch(self.data.stage)
	self.curRound = curRound
	self.curBatch = curBatch
	self.activityID = gActivityTimeActivityID.NEBULA_CAMP_INTEGRAL_ACTIVITY
end
function Activity_9001479_MainPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "NebulaCompetition"
	end
	return self._packageList
end
function Activity_9001479_MainPanel:onInit()
	print("=======Activity_9001479_MainPanel:onInit")
	self.fieldsTask = fguiHelper.get_fields(self.fields.Com_task)
	self.fieldsRank = fguiHelper.get_fields(self.fields.Com_rank)
	self.fieldsWin = fguiHelper.get_fields(self.fieldsRank.Com_win)
	self.fieldsLose = fguiHelper.get_fields(self.fieldsRank.Com_lose)
	self.fields.Com_title:initData(i18n("camp_integral_1"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Button_camp:setString(i18n("nebula_war_text_0001"))
	self.fields.Button_reward:setString(i18n("common_text_2078"))
	self.fields.Button_rank:setString(i18n("common_text_2193"))
	_ENV = i18n("common_text_2193")
	i18n("common_text_2193").camp = i18n("nebula_war_text_0076")
	self.fields.Text_nameS:setString(i18n("camp_integral_7", i18n("common_text_2193")))
	_ENV = i18n("camp_integral_7", i18n("common_text_2193"))
	i18n("camp_integral_7", i18n("common_text_2193")).camp = i18n("nebula_war_text_0075")
	self.fields.Text_nameN:setString(i18n("camp_integral_7", i18n("camp_integral_7", i18n("common_text_2193"))))
	self.fields.Com_head:setHeadSprite()
	self.fields.Image_waiting:setVisible(false)
	self.fields.Text_waiting:setVisible(false)
	self.fields.Text_waiting:setString(i18n("camp_integral_26"))
	self.fields.Com_winN:setVisible(false)
	self.fields.Com_winS:setVisible(false)
	_UPVALUE3_ = self.fields.Com_winS.setVisible
	self.fields.Com_winS.setVisible[1] = self.fields.Button_camp
	self.fields.Com_winS.setVisible[2] = self.fields.Button_reward
	local self.fields.Com_winS.setVisible[3], config = self.fields.Button_rank, self.fields.Com_winS.setVisible
	for i, v in ipairs(config) do
		v:addClickListener(handler(self, self.onClickOperateBtn))
	end
	self:updateComStage()
	self.List_task = self.fieldsTask.List_task
	self.List_task:setItemRenderer(handler(self, self.onTaskItemRenderer))
	self.List_task:setVirtual()
	self.fieldsTask.Label_time:initActivityTimeStyle(self.activityID, "common_text_766")
	local defaultClick = math.min(4, self.curRound)
	_ENV = 4
	;(4).defaultClick = defaultClick
	;(4).tabsetArray = activity_9001479_Read.getTabsetArray()
	local (4).callback, param = handler(self, self.onClickTab), 4
	self.fields.com_Tab:initView(param)
	self:updateTabBtn()
	for batch = 1, 4 do
		local Com_stage = self.fields["Com_stage" .. batch]
		if Com_stage then
			Com_stage:fixPos()
		end
	end
	_UPVALUE7_ = (for index)
	;(1)[1] = self.fields.Com_head
	;(1)[2] = self.fields.Load_camp
	;(1)[3] = self.fields.Text_score
	;(1)[4] = self.fields.Text_rank
	;(1)[5] = self.fields.Button_camp
	;(1)[6] = self.fields.Button_reward
	local (1)[7], config = self.fields.Button_rank, 1
	for i, v in ipairs(config) do
		v:fixPos()
	end
	if not SoraDFIsRA() then
		self.fields.Progress_camp:setScaleX(-1)
	end
end
function Activity_9001479_MainPanel:onShow()
	print("=======Activity_9001479_MainPanel:onShow")
	self:runAction(ffa.callFunc(function()
		self:showCampNotice()
	end))
end
function Activity_9001479_MainPanel:onClickHelp()
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("camp_integral_2"))
end
function Activity_9001479_MainPanel:onClickOperateBtn(EventContext)
	SoraDPlaySound()
	local sender = EventContext:getSender()
	if sender == self.fields.Button_camp then
		local nebulaWarUtil = include("nebulaWarUtil")
		nebulaWarUtil.openCampView(self.showRound)
	elseif sender == self.fields.Button_reward then
		_ENV = nil
		;(nil).showRound = self.showRound
		uiManager:show("Activity_9001479_Reward", nil)
	elseif sender == self.fields.Button_rank then
		_ENV = nil
		;(nil).showRound = self.showRound
		uiManager:show("Activity_9001479_Rank", nil)
	end
end
function Activity_9001479_MainPanel:onClickTab(tag)
	if self.showRound == tag then
		return
	end
	if activity_9001479_Ctrl:checkIsSpecial() and tag <= 1 then
		self.fields.com_Tab:setTabIndex(self.showRound)
		SoraDShowMsgTip(i18n("camp_integral_6"))
		return
	end
	if tag > self.curRound then
		self.fields.com_Tab:setTabIndex(self.showRound)
		activity_9001479_Ctrl = i18n("camp_integral_6")
		i18n("camp_integral_6").num = tag
		SoraDShowMsgTip(i18n("camp_integral_5", i18n("camp_integral_6")))
		return
	end
	self.showRound = tag
	self:updateRound()
	if self.List_task:getNumItems() > 0 then
		self.List_task:scrollToView(0)
	end
	self.fields.Com_rank:getScrollPane():setPosY(0)
end
function Activity_9001479_MainPanel:onMsgUpdateCampScore(target, event)
	SoraDCloseLoading(self:displayObject())
	if not event.rspdata then
		local _ENV, rspdata = event.rspdata, event.rspdata
	end
	if not rspdata.campData then
		local _ENV, campData = rspdata.campData, rspdata.campData
	end
	local dataS = campData[tostring(NEBULA_WAR_CAMP.SOUTH)]
	local scoreS = dataS and dataS.score or 0
	self.fields.Text_scoreS:setString(string_fnt(scoreS))
	local dataN = campData[tostring(NEBULA_WAR_CAMP.NORTH)]
	local scoreN = dataN and dataN.score or 0
	self.fields.Text_scoreN:setString(string_fnt(scoreN))
	local percent = 0.5
	if 0 < scoreS + scoreN then
		percent = scoreN / (scoreS + scoreN)
	end
	self.fields.Progress_camp:initData(percent)
	if not rspdata.myInfo then
		local _ENV, myInfo = rspdata.myInfo, rspdata.myInfo
	end
	if myInfo and myInfo.rank then
		_ENV = string_fnt(scoreN)
		string_fnt(scoreN).num = myInfo.rank
		self.fields.Text_rank:setString(i18n("camp_integral_9", string_fnt(scoreN)))
	else
		_ENV = i18n("camp_integral_9", string_fnt(scoreN))
		i18n("camp_integral_9", string_fnt(scoreN)).num = i18n("common_text_480")
		self.fields.Text_rank:setString(i18n("camp_integral_9", i18n("camp_integral_9", string_fnt(scoreN))))
	end
	self:updateTextScore()
	local selfCamp = activity_9001479_Ctrl:getSelfCampByRound(self.showRound)
	local campIcon = nebulaWarRead.getWarCampIcon(selfCamp)
	self.fields.Load_camp:setURL(campIcon)
end
function Activity_9001479_MainPanel:onMsgUpdateResult(target, event)
	self:onMsgUpdateCampScore(target, event)
	if self.showRound < self.curRound then
		if not event.rspdata then
			local _UPVALUE0_, rspdata = event.rspdata, event.rspdata
		end
		if not rspdata.campData then
			local _UPVALUE0_, campData = rspdata.campData, rspdata.campData
		end
		self:updateComRank(campData, rspdata.winCamp)
	end
end
function Activity_9001479_MainPanel:updateProgress(...)
	self.data = activity_9001479_Ctrl:getActivityData()
	local curRound, curBatch = activity_9001479_Read.getRoundAndBatch(self.data.stage)
	self.curRound = curRound
	self.curBatch = curBatch
	if self.curRound == self.showRound then
		self:updateComTask()
	end
end
function Activity_9001479_MainPanel:updateComTask()
	local config = activity_9001479_Read.getTaskConfigByRound(self.curRound, self.curBatch)
	local activity_9001479_Read, ret = self.curRound, self.curRound
	for __, group in pairs(config) do
		local groupNum = #group
		for i, cfg in ipairs(group) do
			local taskType = cfg.type
			local need = cfg.need
			local method = cfg.method
			if not self.data.taskMap[tostring(taskType)] then
				local activity_9001479_Read, task = self.data.taskMap[tostring(taskType)], self.data.taskMap[tostring(taskType)]
			end
			local progress = task.progress or 0
			local gotRewardLv = task.gotRewardLv or 0
			local state
			if method == 1 then
				if progress >= (gotRewardLv + 1) * need then
					state = gBtnTargetStatusDef.GET
				else
					state = gBtnTargetStatusDef.GO
				end
			elseif i <= gotRewardLv then
				if i == groupNum then
					state = gBtnTargetStatusDef.GOT
				end
			elseif need <= progress then
				state = gBtnTargetStatusDef.GET
			else
				state = gBtnTargetStatusDef.GO
			end
			if state then
				activity_9001479_Read = nil
				;(nil).taskType = taskType
				;(nil).state = state
				;(nil).cfg = cfg
				table.insert(ret, nil)
				break
			end
		end
	end
	_UPVALUE2_, _UPVALUE2_ = nil, pairs(config)
	_UPVALUE2_, (nil)[1] = "state", "state"
	_UPVALUE2_, (nil)[2] = "state", "<"
	;("state")[1] = "taskType"
	;("state")[2] = "<"
	pairs(config)[1] = nil
	pairs(config)[2] = "state"
	serviceFunctions.sort(ret, pairs(config))
	self.taskData = ret
	self.List_task:setNumItems(#self.taskData)
end
function Activity_9001479_MainPanel:onTaskItemRenderer(index, obj)
	local data = self.taskData[index + 1]
	if not obj.fields then
		obj.fields = fguiHelper.get_fields(obj)
		obj.fields.Button_go:addClickListener(handler(self, self.onClickBtnGo))
		obj:fixChildrenPos()
		obj.fields.Image_bg:fix()
	end
	local cfg = data.cfg
	local state = data.state
	local taskType = cfg.type
	local need = cfg.need
	local integral = cfg.integral
	local reward = cfg.reward
	local method = cfg.method
	if not self.data.taskMap[tostring(taskType)] then
		local _ENV, task = self.data.taskMap[tostring(taskType)], self.data.taskMap[tostring(taskType)]
	end
	local progress = task.progress or 0
	local gotRewardLv = task.gotRewardLv or 0
	local describe = activity_9001479_Read.getTaskDescribe(taskType)
	_ENV = handler(self, self.onClickBtnGo)
	handler(self, self.onClickBtnGo).num1 = string_fnt(need)
	_ENV, _ENV, handler(self, self.onClickBtnGo).num2 = integral, string_fnt(integral), string_fnt(integral)
	_ENV, string_fnt(integral).num1, integral.color = integral, integral, "#FFD43E"
	string_fnt(integral).num2, integral.color = integral, "#FFD43E"
	local desStr = i18n_html(describe, handler(self, self.onClickBtnGo))
	obj.fields.Text_des:setString(desStr)
	local _ENV, style = obj.fields.Text_des.setString, obj.fields.Text_des.setString
	if method == 1 and progress < (gotRewardLv + 1) * need then
		_ENV, _ENV = desStr, (gotRewardLv + 1) * need
		style, (gotRewardLv + 1) * need.var, desStr.color = (gotRewardLv + 1) * need, desStr, "#BE2828"
	elseif method ~= 1 and need > progress then
		_ENV, _ENV = desStr, (gotRewardLv + 1) * need
		style, (gotRewardLv + 1) * need.var, desStr.color = (gotRewardLv + 1) * need, desStr, "#BE2828"
	end
	local value = 0
	if method == 1 then
		value = progress - gotRewardLv * need
	else
		value = math.min(progress, need)
	end
	_ENV = need
	need.var = string_fnt(value)
	need.var1 = string_fnt(need)
	local valueStr = i18n_html("alliance_stronghold_text_070", need, style)
	obj.fields.Text_value:setString(valueStr)
	obj.fields.List_reward:setItemRenderer(function(_index, _obj)
		local _data = reward[_index + 1]
		_obj:initData(_data.id, _data.count)
	end)
	obj.fields.List_reward:setNumItems(#reward)
	local Button_go = obj.fields.Button_go
	Button_go:setTag(index)
	Button_go:setEnabled(true)
	if state == gBtnTargetStatusDef.GET then
		Button_go:setString(i18n("common_text_1146"))
		Button_go:setBtnColorIndex(0)
	elseif state == gBtnTargetStatusDef.GO then
		Button_go:setString(i18n("common_text_477"))
		Button_go:setBtnColorIndex(2)
	else
		Button_go:setString(i18n("common_text_2601"))
		Button_go:setEnabled(false)
	end
end
function Activity_9001479_MainPanel:onClickBtnGo(EventContext)
	SoraDPlaySound()
	local index = EventContext:getSender():getTag()
	local data = self.taskData[index + 1]
	local taskType = data.taskType
	local state = data.state
	if state == gBtnTargetStatusDef.GET then
		activity_9001479_Ctrl:reqReward(taskType, data.cfg.reward)
	elseif state == gBtnTargetStatusDef.GO then
		local sourceId = activity_9001479_Read.getTaskJump(taskType)
		if sourceId and 0 < sourceId and SoraDJumpBySourceId(sourceId) then
			self:closePanel()
		end
	end
end
function Activity_9001479_MainPanel:updateComRank(campData, winCamp)
	if not winCamp then
		self.fields.Image_waiting:setVisible(true)
		self.fields.Text_waiting:setVisible(true)
		self.fields.Text_scoreS:setString(i18n("camp_integral_25"))
		self.fields.Text_scoreN:setString(i18n("camp_integral_25"))
		return
	end
	if winCamp ~= NEBULA_WAR_CAMP.SOUTH and winCamp ~= NEBULA_WAR_CAMP.NORTH then
		return
	end
	local _ENV, _ENV, loseCamp = i18n("camp_integral_25")
	i18n("camp_integral_25").camp = winCamp
	_ENV, self.fields.Text_scoreN[1], i18n("camp_integral_25").fields = i18n("camp_integral_25")
	i18n("camp_integral_25").camp = loseCamp
	self.fields.Text_scoreN[2], i18n("camp_integral_25").fields = i18n("camp_integral_25")
	local config = self.fields.Text_scoreN
	for __, v in pairs(config) do
		local campType = v.camp
		if not campData[tostring(campType)] then
			local _ENV, data = campData[tostring(campType)], campData[tostring(campType)]
		end
		if not data.rank then
			local _ENV, rankList = data.rank, data.rank
		end
		local campName = nebulaWarRead.getWarCampName(campType)
		v.fields.Text_winCamp:setString(campName)
		for rank = 1, 10 do
			local Com_single = v.fields["Com_single" .. rank]
			if Com_single then
				Com_single:initData(rank, rankList[rank])
			end
		end
	end
	local showWinN = winCamp == NEBULA_WAR_CAMP.NORTH
	self.fields.Com_winN:setVisible(showWinN)
	self.fields.Com_winS:setVisible(not showWinN)
end
function Activity_9001479_MainPanel:updateStage(...)
	self.data = activity_9001479_Ctrl:getActivityData()
	local curRound, curBatch = activity_9001479_Read.getRoundAndBatch(self.data.stage)
	self.curBatch = curBatch
	if curRound ~= self.curRound or curBatch == 1 then
		self.curRound = curRound
		self:updateTabBtn()
		self:updateRound()
		self:showCampNotice()
	end
	if self.showRound == self.curRound then
		self:updateComStage()
	end
end
function Activity_9001479_MainPanel:updateTabBtn(...)
	for i = 1, 4 do
		local bright = i <= self.curRound
		self.fields.com_Tab:getBtn(i):setBright(bright)
	end
end
function Activity_9001479_MainPanel:updateRound(...)
	SoraDShowLoading(self:displayObject())
	self.fields.Com_winN:setVisible(false)
	self.fields.Com_winS:setVisible(false)
	if self.showRound < self.curRound then
		self.controllers.c_state:setSelectedIndex(1)
		activity_9001479_Ctrl:reqRoundResult(self.showRound)
		self:updateComStage(5)
		self:resetComRank()
	elseif self.showRound >= 1 and self.showRound <= 4 and self.curBatch == 0 then
		SoraDCloseLoading(self:displayObject())
		self.controllers.c_state:setSelectedIndex(2)
		self:initComPreview()
	else
		self.controllers.c_state:setSelectedIndex(0)
		activity_9001479_Ctrl:reqRoundCampScore(self.showRound)
		self:updateProgress()
		self:updateComStage(self.curBatch)
	end
end
function Activity_9001479_MainPanel:updateComStage(showBatch)
	if self.showRound == self.curRound then
		local remainTime = activity_9001479_Ctrl:getStageRemainTime()
		self.fieldsTask.Label_time:beginTime(remainTime)
	end
	showBatch = showBatch or self.curBatch
	for batch = 1, 4 do
		local Com_stage = self.fields["Com_stage" .. batch]
		if Com_stage then
			Com_stage:setString(tostring(batch))
			local c1 = Com_stage:getController("c1")
			if batch < showBatch then
				c1:setSelectedIndex(0)
			elseif showBatch == batch then
				c1:setSelectedIndex(1)
			else
				c1:setSelectedIndex(2)
			end
		end
	end
end
function Activity_9001479_MainPanel:resetComRank(...)
	self.fields.Image_waiting:setVisible(false)
	self.fields.Text_waiting:setVisible(false)
	_ENV, _ENV = self.fields.Text_waiting, self.fields.Text_waiting.setVisible
	self.fields.Text_waiting.title = i18n("camp_integral_23")
	_ENV, self.fields.Text_waiting.setVisible[1], self.fields.Text_waiting.fields = self.fields.Text_waiting, self.fields.Text_waiting, self.fieldsWin
	self.fields.Text_waiting.title = i18n("camp_integral_24")
	self.fields.Text_waiting.setVisible[2], self.fields.Text_waiting.fields = self.fields.Text_waiting, self.fieldsLose
	local config = self.fields.Text_waiting.setVisible
	for __, v in pairs(config) do
		v.fields.Text_winCamp:setString(v.title)
		for rank = 1, 10 do
			local Com_single = v.fields["Com_single" .. rank]
			if Com_single then
				Com_single:initData(rank)
			end
		end
	end
end
function Activity_9001479_MainPanel:onMsgUpdateSettle(target, event)
	if event.round ~= self.showRound then
		return
	end
	activity_9001479_Ctrl:reqRoundResult(self.showRound)
	SoraDShowLoading(self:displayObject())
	self.fields.Image_waiting:setVisible(false)
	self.fields.Text_waiting:setVisible(false)
end
function Activity_9001479_MainPanel:showCampNotice(...)
	if activity_9001479_Ctrl:checkShowCampNotice() then
		uiManager:show("Activity_9001479_CampNotice")
	end
end
function Activity_9001479_MainPanel:initComPreview(...)
	local _fields = fguiHelper.get_fields(self.fields.Com_preview)
	_fields.Text_des:setString(i18n("common_text_4808"))
	_fields.Text_begin:setString(i18n("common_text_4807"))
	_fields.Text_time = SoraDCreateTimerLabel(self, _fields.Text_time)
	local remainTime = activity_9001479_Ctrl:getStageRemainTime()
	if activity_9001479_Ctrl:checkIsSpecial() then
		remainTime = activity_9001479_Ctrl:getStageRemainTime(5)
	end
	_fields.Text_time:beginTime(remainTime)
end
function Activity_9001479_MainPanel:updateTextScore(...)
	local roundScore = activity_9001479_Ctrl:getRoundScore()
	activity_9001479_Ctrl = nil
	;(nil).num = roundScore
	self.fields.Text_score:setString(i18n("common_text_1256", nil))
end
return Activity_9001479_MainPanel
