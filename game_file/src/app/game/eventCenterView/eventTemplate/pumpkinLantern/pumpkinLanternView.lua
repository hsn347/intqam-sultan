local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local pumpkinLanternRead = include("pumpkinLanternRead")
local eventQuestRead = include("eventQuestRead")
local activityTaskComponentCtrl = SoraDGetCtrl("activityTaskComponentCtrl")
local pumpkinLanternView = class("pumpkinLanternView", function(target)
	return target or SoraDCreateBasePanel("pumpkinLanternView")
end)
_ENV, _ENV, _UPVALUE3_ = nil, function(target)
	return target or SoraDCreateBasePanel("pumpkinLanternView")
end, "pumpkinLanternView"
;(nil).x = -4
_ENV, (function(target)
	return target or SoraDCreateBasePanel("pumpkinLanternView")
end).LEyePos, (nil).y = nil, nil, -36
;(nil).x = 10
_ENV, _ENV, (function(target)
	return target or SoraDCreateBasePanel("pumpkinLanternView")
end).DEyePos, (nil).y = nil, nil, nil, -34
;(nil).x = -17.0
_ENV, (nil).LEyePos, (nil).y = nil, nil, -98.0
;(nil).x = -7
_ENV, _ENV, (nil).DEyePos, (nil).y = nil, nil, nil, -91
;(nil).x = -4
_ENV, (nil).LEyePos, (nil).y = nil, nil, -91
;(nil).x = -2
;(nil).DEyePos, (nil).y = nil, -87.5
_ENV, _UPVALUE7_, ("pumpkinLanternView")[1] = nil, function(target)
	return target or SoraDCreateBasePanel("pumpkinLanternView")
end, function(target)
	return target or SoraDCreateBasePanel("pumpkinLanternView")
end
_ENV, _UPVALUE7_, ("pumpkinLanternView")[2] = nil, function(target)
	return target or SoraDCreateBasePanel("pumpkinLanternView")
end
local _ENV, _UPVALUE7_, ("pumpkinLanternView")[3], eyePosConfig = nil, function(target)
	return target or SoraDCreateBasePanel("pumpkinLanternView")
end, nil, "pumpkinLanternView"
;(nil).imageIndex = 1
;(nil).lightChoose = 3
;(nil).darkDelayTime = 190
;(nil).lightDelayTime = 0
_ENV, (nil).itemStatus = nil, 2
;(nil).imageIndex = 3
;(nil).lightChoose = 2
;(nil).darkDelayTime = 90
;(nil).lightDelayTime = 60
_ENV, (nil).itemStatus = nil, 2
;(nil).imageIndex = 2
;(nil).lightChoose = 1
;(nil).darkDelayTime = 205
;(nil).lightDelayTime = 120
_ENV, (nil).itemStatus = nil, 2
;(nil).imageIndex = 3
;(nil).lightChoose = 4
;(nil).darkDelayTime = 15
;(nil).lightDelayTime = 0
_ENV, (nil).itemStatus = nil, 2
;(nil).imageIndex = 1
;(nil).lightChoose = 1
;(nil).darkDelayTime = 0
;(nil).lightDelayTime = 0
_ENV, (nil).itemStatus = nil, 2
;(nil).imageIndex = 2
;(nil).lightChoose = 3
;(nil).darkDelayTime = 290
;(nil).lightDelayTime = 90
_ENV, (nil).itemStatus = nil, 2
;(nil).imageIndex = 3
;(nil).lightChoose = 1
;(nil).darkDelayTime = 105
;(nil).lightDelayTime = 120
;(nil).itemStatus = 2
;(function(target)
	return target or SoraDCreateBasePanel("pumpkinLanternView")
end)[1] = nil
;(function(target)
	return target or SoraDCreateBasePanel("pumpkinLanternView")
end)[2] = nil
;(function(target)
	return target or SoraDCreateBasePanel("pumpkinLanternView")
end)[3] = nil
;(function(target)
	return target or SoraDCreateBasePanel("pumpkinLanternView")
end)[4] = nil
;(function(target)
	return target or SoraDCreateBasePanel("pumpkinLanternView")
end)[5] = nil
;(function(target)
	return target or SoraDCreateBasePanel("pumpkinLanternView")
end)[6] = nil
local (function(target)
	return target or SoraDCreateBasePanel("pumpkinLanternView")
end)[7], pumpkinConfig = nil, function(target)
	return target or SoraDCreateBasePanel("pumpkinLanternView")
end
local MAX_PUMPKIN = 7
function pumpkinLanternView:ctor()
	self.awardArray, _ENV = nil, nil
	self.maxDarkDelay = -1
	self.maxDarkDelayIndex = -1
	self.maxLightDelay = -1
	self.lightPumpkinArray, _ENV, self.darkPumpkinArray, _ENV, self.maxLightDelayIndex = nil, nil, nil, nil, -1
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle")
	self.nodeTitle:setTitle(i18n("activity_name_9001196"))
	self.activityTime = SoraDGetChildByName(self, "Text_remainTime")
	self.activityTime = SoraDCreateTimerLabel(self, self.activityTime)
	self.scroll = SoraDGetChildByName(self, "ScrollView")
	self.scroll:setSwallowTouches(false)
	self.nodeTree = SoraDGetChildByName(self, "Node_Tree")
	self.nodePumpkins = SoraDGetChildsArrayByName(self.nodeTree, "pumplin_Node_", 7, 1)
	self.textTips = SoraDGetChildByName(self, "Text_Tips")
	eventQuestRead = 7
	;(7)[1] = "pumlantern_text_03"
	self.textTips:setString(i18n(7))
	self.btnGetReward = SoraDGetChildByName(self, "Button_GetAward")
	self.btnGetReward:setTitleText(i18n("common_text_1146"))
	self.btnGetReward:addTouchEventListener(handler(self, self.btnClickGetAward))
	self.nodeReward = SoraDGetChildByName(self, "Node_Award")
	self.downEffect = SoraDGetChildByName(self, "Top_Effect_Node_Down")
	self.upEffect = SoraDGetChildByName(self, "Top_Effect_Node_Up")
	self.nodeTimer = SoraDGetChildByName(self, "Node_timer")
	self.taskIDList = eventQuestRead.getQuestList(gActivityTimeActivityID.PUMPKIN_ACTIVITY)
	_ENV = handler(self, self.btnClickGetAward)
	handler(self, self.btnClickGetAward).activityID = gActivityTimeActivityID.PUMPKIN_ACTIVITY
	self:initData(self, handler(self, self.btnClickGetAward))
	self:initPumpkinsAnimation()
	self:initAwardData()
	self:initBgEffect()
	self:initTime()
end
function pumpkinLanternView:initData(target, data)
	if data and data.activityID ~= gActivityTimeActivityID.PUMPKIN_ACTIVITY then
		return
	end
	local serverData = activityTaskComponentCtrl:getQuestData(gActivityTimeActivityID.PUMPKIN_ACTIVITY)
	self.allPumpkinLight = table.nums(serverData.claimedQuest) == MAX_PUMPKIN
	self.taskInfoData = eventQuestRead.getSortList(gActivityTimeActivityID.PUMPKIN_ACTIVITY, serverData)
	dump(self.taskInfoData, "self.self.taskInfoData", 10)
	if data.questID and data.isSuccess then
		local index = self:getTaskIndexByTaskID(data.questID)
		self:initItemAnimation(self.nodePumpkins[index].itemEffect, index)
	end
	self:checkFinalAwardCanGet()
end
function pumpkinLanternView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.initData))
end
function pumpkinLanternView:initTime()
	local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.PUMPKIN_ACTIVITY)
	self.activityTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_766", nil)
	end)
	if eventTime then
		self.activityTime:beginTime(eventTime.timerNode.timer:getRemainTime())
	end
	SoraDToCenter(SoraDGetChildByName(self, "Node_timer"), 10, not SoraDFIsRA())
end
function pumpkinLanternView:initAwardData()
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local tmp = serviceFunctions.tableFormat(pumpkinLanternRead.getFinalAward(), nil)
	for k, v in ipairs(tmp) do
		self.awardArray[k] = include("commonItemAward").new()
		self.awardArray[k]:setScale(0.8)
		self.awardArray[k]:setBaseScale(1.0)
		self.awardArray[k]:setOwnView(self)
		self.awardArray[k]:setPosition(0, 0)
		self.awardArray[k]:addTo(self.nodeReward)
		self.awardArray[k]:initData(v.id, v.count)
	end
	SoraDToCenter(self.nodeReward, 100, SoraDFIsRA())
end
function pumpkinLanternView:initPumpkinsAnimation()
	for i, v in ipairs(self.nodePumpkins) do
		local itemEffect = SoraDCreatAnimationEx("pumpkinItemEffect", nil, false)
		itemEffect.action:gotoFrameAndPause(0)
		itemEffect:addTo(v, -1)
		if itemEffect.action and tolua.cast(itemEffect.action, "cc.Action") then
			itemEffect.action:setFrameEventCallFunc(handlerEx(self, self.effectCallBack, i))
		end
		local btnPumpkin = SoraDGetChildByName(v, "Button_Pumpkin", true)
		btnPumpkin:setSwallowTouches(false)
		btnPumpkin:addTouchEventListener(handlerEx(self, self.btnClickPumpkin, i))
		itemEffect:setPosition(0, 0)
		SoraDMixtureGLONEByParent(itemEffect)
		v.itemEffect = itemEffect
		self:initItemAnimation(itemEffect, i)
	end
end
function pumpkinLanternView:initItemAnimation(target, index)
	local taskId = self.taskIDList[index]
	local info = self:getTaskInfoyTaskID(taskId)
	local itemStatus = info.taskStatus
	local imageIndex = pumpkinConfig[index].imageIndex
	local lightChoose = pumpkinConfig[index].lightChoose
	local delayTime = itemStatus == gBtnTargetStatusDef.GOT and pumpkinConfig[index].lightDelayTime or pumpkinConfig[index].darkDelayTime
	pumpkinConfig[index].itemStatus = itemStatus
	if not itemStatus then
		self.allPumpkinLight = fal
	end
	if itemStatus == gBtnTargetStatusDef.GOT then
		if delayTime > self.maxLightDelay then
			self.maxLightDelay = delayTime
			self.maxLightDelayIndex = index
		end
		self.lightPumpkinArray[index] = target
		self.darkPumpkinArray[index] = nil
	else
		if delayTime > self.maxDarkDelay and itemStatus ~= gBtnTargetStatusDef.GO then
			self.maxDarkDelay = delayTime
			self.maxDarkDelayIndex = index
		end
		self.darkPumpkinArray[index] = target
		self.lightPumpkinArray[index] = nil
	end
	local nodeLight = SoraDGetChildByName(target, "Node_Light")
	local nodeUnlight = SoraDGetChildByName(target, "Node_Unlight")
	local eyesTbl = SoraDGetChildsArrayByName(target, "G_Eye_Icon_", 4, 1)
	nodeLight:setVisible(itemStatus == gBtnTargetStatusDef.GOT)
	nodeUnlight:setVisible(itemStatus ~= gBtnTargetStatusDef.GOT)
	for i, v in ipairs(eyesTbl) do
		v:setVisible(lightChoose == i)
	end
	SoraDGetChildByName(nodeLight, "pumpkin_Icon"):setSpriteFrame("farmer_ngdhxq_ng_0" .. imageIndex .. ".png")
	eyesTbl[lightChoose]:setSpriteFrame("dh_nangualight_0" .. imageIndex .. ".png")
	eyesTbl[lightChoose]:setPosition(eyePosConfig[imageIndex].LEyePos.x, eyePosConfig[imageIndex].LEyePos.y)
	SoraDGetChildByName(nodeUnlight, "pumpkin_Icon"):setSpriteFrame("farmer_ngdhxq_ng_0" .. imageIndex .. ".png")
	SoraDGetChildByName(nodeUnlight, "eye_Icon", true):setSpriteFrame("farmer_ngdhxq_ng_an_0" .. imageIndex .. ".png")
	SoraDGetChildByName(nodeUnlight, "eye_Icon", true):setPosition(eyePosConfig[imageIndex].DEyePos.x, eyePosConfig[imageIndex].DEyePos.y)
	target.index = index
	if itemStatus == gBtnTargetStatusDef.GO then
		target.action:gotoFrameAndPause(0)
	else
		_ENV = eyePosConfig[imageIndex].DEyePos.y
		eyePosConfig[imageIndex].DEyePos.y[1] = cca.delay(delayTime / 60)
		eyePosConfig[imageIndex].DEyePos.y[2] = cca.callFunc(function()
			target.action:gotoFrameAndPlay(0, false)
		end)
		eyePosConfig[imageIndex].DEyePos.y[3] = cca.callFunc(function()
			target.action:gotoFrameAndPlay(0, false)
		end)
		eyePosConfig[imageIndex].DEyePos.y[4] = cca.callFunc(function()
			target.action:gotoFrameAndPlay(0, false)
		end)
		target:runAction(cca.seq(eyePosConfig[imageIndex].DEyePos.y))
	end
end
function pumpkinLanternView:playAnimation(animatinType)
	for i, v in pairs(animatinType and self.lightPumpkinArray or self.darkPumpkinArray) do
		local delayTime = animatinType and pumpkinConfig[v.index].lightDelayTime or pumpkinConfig[v.index].darkDelayTime
		if pumpkinConfig[v.index].itemStatus == gBtnTargetStatusDef.GO then
			v.action:gotoFrameAndPause(0)
		else
			pumpkinConfig = nil
			;(nil)[1] = cca.delay(delayTime / 60)
			;(nil)[2] = cca.callFunc(function()
				v.action:gotoFrameAndPlay(0, false)
			end)
			;(nil)[3] = cca.callFunc(function()
				v.action:gotoFrameAndPlay(0, false)
			end)
			v:runAction(cca.seq(nil))
		end
	end
end
function pumpkinLanternView:initBgEffect()
	local downEffect = SoraDCreatAnimationEx("pumpkinBgDownEffect", nil, true)
	SoraDMixtureGLONEByParent(downEffect)
	downEffect:setPosition(0, 0)
	self.downEffect:addChild(downEffect)
	local upEffect = SoraDCreatAnimationEx("pumpkinBgUpEffect", nil, true)
	SoraDMixtureGLONEByParent(upEffect)
	downEffect:setPosition(0, 0)
	self.upEffect:addChild(upEffect)
	self.scroll:setContentSize(640, 600 + (self:getPanelOffsetHeight() - 960))
	local maxHeight = 770
	if 770 < self.scroll:getContentSize().height then
		maxHeight = self.scroll:getContentSize().height
		self.scroll:setTouchEnabled(false)
	end
	self.nodeTree:setPositionY(maxHeight - 540)
	self.scroll:setInnerContainerSize(cc.size(640, maxHeight))
end
function pumpkinLanternView:checkFinalAwardCanGet()
	local isFinalReceive = activityTaskComponentCtrl:isFinalReceivePumpkin()
	print("isFinalReceive", isFinalReceive)
	if isFinalReceive then
		self.btnGetReward:setTitleText(i18n("common_text_1892"))
		self.btnGetReward:setBright(false)
		self.btnGetReward:setTouchEnabled(false)
	else
		self.btnGetReward:setTitleText(i18n("common_text_1146"))
		self.btnGetReward:setTouchEnabled(true)
		if self.allPumpkinLight then
			self.btnGetReward:setBright(true)
		else
			self.btnGetReward:setBright(false)
		end
	end
end
function pumpkinLanternView:btnClickGetAward(button, type)
	if type == ccui.TouchEventType.ended then
		if self.allPumpkinLight then
			activityTaskComponentCtrl:sendReqGetReward()
		else
			SoraDShowMsgTip(i18n("pumlantern_text_02"))
		end
	end
end
function pumpkinLanternView:btnClickPumpkin(index, button, type)
	if type == ccui.TouchEventType.ended then
		print("index", index)
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		local taskId = self.taskIDList[index]
		local taskInfo = self:getTaskInfoyTaskID(taskId)
		if taskInfo.taskStatus == gBtnTargetStatusDef.GOT then
			SoraDShowMsgTip(i18n("pumlantern_text_01"))
		elseif taskInfo.taskStatus == gBtnTargetStatusDef.GO then
			local panel = SoraDCreatePanel("pumpkinLanternPopView")
			panel:initData(taskInfo, self)
			panel:show()
		elseif taskInfo.taskStatus == gBtnTargetStatusDef.GET then
			activityTaskComponentCtrl:reqRuestClaimReward(taskId, gActivityTimeActivityID.PUMPKIN_ACTIVITY)
		end
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function pumpkinLanternView:effectCallBack(index, frameEventName)
	local frameEvent = frameEventName:getEvent()
	if frameEvent then
		if frameEvent == "UnlightEnd" then
			if index == self.maxDarkDelayIndex then
				self:playAnimation(false)
			end
		elseif frameEvent == "LightEnd" and index == self.maxLightDelayIndex then
			self:playAnimation(true)
		end
	end
end
function pumpkinLanternView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.PUMPKIN_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function pumpkinLanternView:getTaskInfoyTaskID(taskID)
	for i, v in pairs(self.taskInfoData) do
		if v.taskID == taskID then
			return v
		end
	end
end
function pumpkinLanternView:getTaskIndexByTaskID(taskID)
	for i, v in ipairs(self.taskIDList) do
		if v == taskID then
			return i
		end
	end
end
return pumpkinLanternView
