local commandHallCtrl = SoraDGetCtrl("commandHallCtrl")
local commandHallRead = include("commandHallRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_MainReward = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommandHall/Com_MainReward", Com_MainReward)
function Com_MainReward:onInit()
	self.fields.Text_time = SoraDCreateTimerLabel(nil, self.fields.Text_time)
	self.fields.Text_condi:setString(i18n("GS_commandhall_guide_18"))
	local _fields = fguiHelper.get_fields(self.fields.Com_condi1)
	_fields.Button_go:setString(i18n("common_text_477"))
	_fields.Button_go:addClickListener(handler(self, self.onClickBtnGo1))
	self.Button_go1 = _fields.Button_go
	self.fields.Com_condi2:setVisible(false)
	self.fields.Button_attack:setString(i18n("commandhall_text_90"))
	self.fields.Button_attack:addClickListener(handler(self, self.onClickBtnAttack))
	self.fields.Button_get:setString(i18n("common_text_1146"))
	self.fields.Button_get:addClickListener(handler(self, self.onClickBtnAttack))
	self.fields.mv_attack:setAllFrameNameOnce("dh_GS_ttdt_hyan_%02d.png", 1)
	self.fields.mv_shandian:setVisible(false)
	self.fields.mv_huoyan:setVisible(false)
	_ENV = self.fields.mv_huoyan.setVisible
	self.fields.mv_huoyan.setVisible.res = "spine/jiemianBOSS.skel"
	local self.fields.mv_huoyan.setVisible.scale, roleCfg = 0.6, self.fields.mv_huoyan.setVisible
	local showRole = self.fields.role_1
	showRole:setEffectPath(roleCfg.res, "idle", true)
	local scale = roleCfg.scale
	showRole:setScaleX(SoraDFIsRA() and scale or -scale)
	showRole:setScaleY(scale)
	showRole:setVisible(true)
	self.spineNpc = showRole:getSpine()
	self.spineNpc:setAutoCull(false)
	self.spineNpc:registerSpineEventHandler(function(data)
		if data.type == "complete" and data.animation ~= "idle" then
			print("==registerSpineEventHandler==", data.type, data.animation)
			self.spineNpc:setAnimation(0, "idle", true)
		end
	end, sp.EventType.ANIMATION_COMPLETE)
	if not SoraDFIsRA() then
		self.fields.bar:getChild("bar"):fixPos()
		self:fixChildrenPos()
		self.fields.Text_time:fixChildrenPos()
		self.fields.Text_time:getChild("Image_bg"):fix()
		self.fields.Com_condi1:fixChildrenPos()
	end
end
function Com_MainReward:onShow()
end
function Com_MainReward:initData(...)
	self:getTaskData()
	self:updateTaskData(self.taskData)
end
function Com_MainReward:getTaskData(...)
	local task = commandHallCtrl:getArmyGroupTaskData()
	if not next(task) then
		task = commandHallCtrl:getTomorrowArmyGroupTaskData()
	end
	self.taskData = task
end
function Com_MainReward:showHpEffect(...)
	self.fields.Usm_hp:play()
	self.fields.Usm_hp:setCompleteCallback(function()
		self.fields.Usm_hp:setVisible(false)
		self:getTaskData()
		self:updateArmyGroupHp(true)
	end)
end
function Com_MainReward:updateArmyGroupHp(tween)
	local task = commandHallCtrl:getArmyGroupTaskData()
	if not next(task) then
		self.controllers.c1:setSelectedIndex(0)
		self.controllers.c2:setSelectedIndex(1)
		return
	end
	self.controllers.c2:setSelectedIndex(0)
	local rabelHp = task.rabelHp
	self.fields.bar:setMax(rabelHp)
	local curHp = math.max(0, rabelHp - task.hurtHp)
	if tween then
		self.fields.bar:tweenValue(curHp, 0.2)
	else
		self.fields.bar:setValue(curHp)
	end
	self:updateConditionSingle(self.fields.Com_condi1, 1)
	if task.statue == gCommandHallTaskStatue.FINISH then
		self.controllers.c1:setSelectedIndex(2)
	elseif self.fields.Com_condi1.isreach then
		self.controllers.c1:setSelectedIndex(1)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
function Com_MainReward:initReward(taskID)
	do
		local _obj = self.fields.Reward_kill
		_ENV = nil
		;(nil).taskID = taskID
		;(nil).taskType = gCommandHallTaskType.REBEL_ARMY_GROUP_TASK
		_obj:initData1(nil)
	end
	do
		local _obj = self.fields.Reward_victory
		_ENV = nil
		;(nil).taskID = taskID
		;(nil).taskType = gCommandHallTaskType.REBEL_ARMY_GROUP_TASK
		_obj:initData2(nil)
		local _obj = self.fields.Reward_victory2
		_ENV = gCommandHallTaskType.REBEL_ARMY_GROUP_TASK
		gCommandHallTaskType.REBEL_ARMY_GROUP_TASK.taskID = taskID
		gCommandHallTaskType.REBEL_ARMY_GROUP_TASK.taskType = gCommandHallTaskType.REBEL_ARMY_GROUP_TASK
		_obj:initData2(gCommandHallTaskType.REBEL_ARMY_GROUP_TASK)
	end
end
function Com_MainReward:updateTaskData(taskData)
	if taskData == nil then
		return
	end
	self.taskData = taskData
	self.fields.Text_title:setString(commandHallRead.getTaskName(self.taskData.taskID))
	self:updateConditionSingle(self.fields.Com_condi2, 2)
	self:updateArmyGroupHp()
	self:updateTaskStatue()
	self:initReward(self.taskData.taskID)
	self:initArmyGroupTime()
end
function Com_MainReward:updateTaskStatue(...)
	local isMoving = self.taskData.armyGroupIsMoving
	if isMoving == nil and not commandHallCtrl:hasArmyGroupTask() then
		isMoving = true
	end
	self.controllers.c_rewardKill:setSelectedIndex(isMoving and 0 or 1)
end
function Com_MainReward:initArmyGroupTime(...)
	local Text_time = self.fields.Text_time
	local task = commandHallCtrl:getArmyGroupTaskData()
	Text_time:setVisible(true)
	if task and next(task) then
		if task.statue == gCommandHallTaskStatue.FINISH then
			Text_time:setVisible(false)
		else
			local remainTime = task.moveEndTime - serviceFunctions.systemTime()
			local totalTime = task.moveEndTime - task.createTime
			local armyGroupID = task.armyGroupID
			if 0 < remainTime and task.armyGroupIsMoving then
				Text_time:setTimeLast(function(timeStr)
					_ENV = nil
					;(nil).time = timeStr
					return i18n("commandhall_text_17", nil)
				end)
				Text_time:beginTime(remainTime)
				Text_time:setTimeEndListener(function()
					Text_time:setString(i18n("commandhall_text_18"))
				end)
			else
				Text_time:setString(i18n("commandhall_text_18"))
			end
		end
	else
		local remainTime = serviceFunctions.getTodayRemainTime()
		Text_time:setTimeLast(nil)
		Text_time:beginTime(remainTime)
	end
end
function Com_MainReward:onClickBtnGo1(...)
	SoraDPlaySound()
	local commandHallUtil = include("commandHallUtil")
	local taskIndex = commandHallUtil.getRandomNotFinishTask()
	if taskIndex then
		_ENV = nil
		;(nil).msg = "MESSAGE_COMMANDHALL_SELECT_TASK"
		;(nil).taskIndex = taskIndex
		SoraDSendMessage(nil)
	else
		local order = commandHallCtrl:getArmyGroupID()
		if commandHallRead.isCommandLvRandom(order) then
			local remainTime = commandHallCtrl:getTaskRefreshRemainTime()
			_ENV = nil
			;(nil).time = SoraDConvertSecondToString(remainTime)
			SoraDShowMsgTip(i18n("ramadan_surprise_05", nil))
		else
			SoraDShowMsgTip(i18n("commandhall_text_68"))
		end
	end
end
function Com_MainReward:updateConditionSingle(Com_condi, ctype)
	local _fields = fguiHelper.get_fields(Com_condi)
	local task = commandHallCtrl:getArmyGroupTaskData()
	if not next(task) then
		return
	end
	local isreach = false
	if ctype == 1 then
		Com_condi:setString(i18n("GS_commandhall_guide_19"))
		local rabelHp = task.rabelHp
		local curHp = math.max(0, rabelHp - task.hurtHp)
		if 0 < curHp then
			isreach = false
		else
			isreach = true
		end
	else
	end
	_fields.Button_go:setVisible(not isreach)
	_fields.icon_yes:setVisible(isreach)
	Com_condi.isreach = isreach
end
function Com_MainReward:onClickBtnAttack(...)
	local dispatch = function()
		commandHallCtrl = nil
		;(nil)[1] = ffa.callFunc(function()
			SoraDShowLoading(self.loadingParent, nil, nil, true)
			self:showHuoyanEffect()
		end)
		;(nil)[2] = ffa.delay(1.0)
		;(nil)[3] = ffa.callFunc(function()
			commandHallCtrl:reqCommitTask(self.taskData.type, self.taskData.index)
		end)
		;(nil)[4] = ffa.callFunc(function()
			commandHallCtrl:reqCommitTask(self.taskData.type, self.taskData.index)
		end)
		self:runAction(ffa.seq(nil))
	end
	SoraDPlaySound()
	if self.taskData.statue == gCommandHallTaskStatue.FINISH then
		if commandHallCtrl:getArmyPioneerTaskCount() > 0 then
			SoraDShowMsgBox(i18n("commandhall_text_15"), i18n("common_text_204"), i18n("common_text_185"), function(exitType)
				if exitType == MSGBOX_CALLBACK_YES then
					dispatch()
				end
			end)
			return
		end
		dispatch()
		return
	else
		commandHallCtrl:reqAttackArmyGroup()
	end
end
function Com_MainReward:showShandianEffect(...)
	self.fields.mv_shandian:setAllFrameNameOnce("dh_tsdt_sd_%02d.png", 1, false)
	self.spineNpc:setAnimation(0, "hit", false)
end
function Com_MainReward:showHuoyanEffect(...)
	self.fields.mv_huoyan:setAllFrameNameOnce("dh_tsdt_hy_%02d.png", 1, false)
	self.spineNpc:setAnimation(0, "die", false)
end
function Com_MainReward:setLoadingParent(loadingParent)
	self.loadingParent = loadingParent
end
function Com_MainReward:gameGuide_getTarget(itemName, parameters)
	if itemName == "Button_go1" then
		return self.Button_go1
	end
	return self.fields[itemName]
end
return Com_MainReward
