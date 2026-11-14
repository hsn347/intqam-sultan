local publicRead = include("publicRead")
local sultansBackCtrl = SoraDGetCtrl("sultansBackCtrl")
local sultansBackRead = include("sultansBackRead")
local sultansBackWarTaskNode = class("sultansBackWarTaskNode", function(fileName)
	local target = SoraDCreateBasePanel("sultansBackWarTaskNode")
	SoraDDeviceFitOffset(target)
	return target
end)
function sultansBackWarTaskNode:onEnterPanel()
	sultansBackCtrl:reqBackWarTaskInit()
	SoraDGetCtrl("activityCenterUICtrl"):sendClearNewMsg(self.activityID)
end
local FRAME_OFFSET = 64
function _UPVALUE5_(fileName)
	local target = SoraDCreateBasePanel("sultansBackWarTaskNode")
	SoraDDeviceFitOffset(target)
	return target
end
;(function(fileName)
	local target = SoraDCreateBasePanel("sultansBackWarTaskNode")
	SoraDDeviceFitOffset(target)
	return target
end)[1] = 40
;(function(fileName)
	local target = SoraDCreateBasePanel("sultansBackWarTaskNode")
	SoraDDeviceFitOffset(target)
	return target
end)[2] = 30
;(function(fileName)
	local target = SoraDCreateBasePanel("sultansBackWarTaskNode")
	SoraDDeviceFitOffset(target)
	return target
end)[3] = 20
;(function(fileName)
	local target = SoraDCreateBasePanel("sultansBackWarTaskNode")
	SoraDDeviceFitOffset(target)
	return target
end)[4] = 10
local (function(fileName)
	local target = SoraDCreateBasePanel("sultansBackWarTaskNode")
	SoraDDeviceFitOffset(target)
	return target
end)[5], ZorderConfig = 30, function(fileName)
	local target = SoraDCreateBasePanel("sultansBackWarTaskNode")
	SoraDDeviceFitOffset(target)
	return target
end
function sultansBackWarTaskNode:ctor(properties)
	self.activityID = gActivityTimeActivityID.SULTAN_WAR_QUEST_ACTIVITY
	self.taskType = 1
	self.awardItemList, _ENV, self.nodeItemList, _ENV, self.canSwitch = gActivityTimeActivityID.SULTAN_WAR_QUEST_ACTIVITY, gActivityTimeActivityID.SULTAN_WAR_QUEST_ACTIVITY, gActivityTimeActivityID.SULTAN_WAR_QUEST_ACTIVITY, gActivityTimeActivityID.SULTAN_WAR_QUEST_ACTIVITY, true
	self.taskConfig = sultansBackRead.getBattleTaskConfig()
	self.topNode = SoraDGetChildByName(self, "Top_Node")
	self.btnQuestion = SoraDGetChildByName(self, "Button_Question")
	self.nodeTime = SoraDGetChildByName(self, "Node_time")
	self.textTime = SoraDGetChildByName(self.nodeTime, "Text_time")
	self.textTime = SoraDCreateTimerLabel(self, self.textTime)
	self.nodeScale = SoraDGetChildByName(self, "Node_IpadScale")
	self.btnLeft = SoraDGetChildByName(self, "btn_left")
	self.btnRight = SoraDGetChildByName(self, "btn_right")
	self.btnGetAward = SoraDGetChildByName(self, "Button_GetAward")
	self.textDescribe = SoraDGetChildByName(self, "Text_Describe")
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
	self.textProgress = SoraDGetChildByName(self, "Text_Progress")
	self.btnTask = SoraDGetChildByName(self, "Button_Task")
	self.taskRedPoint = SoraDGetChildByName(self.btnTask, "Sprite_redPoint")
	SoraDGetChildByName(self.btnTask, "Text_ButtonTask"):setString(i18n("common_text_829"))
	local spProgress = SoraDGetChildByName(self, "Sprite_Progress")
	self.progressBar = display.newProgressTimer(spProgress, display.PROGRESS_TIMER_RADIAL)
	self.progressBar:addTo(self.nodeScale, 5)
	self.progressBar:setPosition(spProgress:getPositionX(), spProgress:getPositionY())
	spProgress:removeFromParent()
	self.spPatternRight = self:createPatternSprite()
	self.spPatternLeft = self:createPatternSprite(true)
	self.nodeAnimation = SoraDGetChildByName(self, "Node_WarAnimate")
	self.nodeBgEffect = SoraDGetChildByName(self, "Node_WarEffect")
	self.nodeTask = SoraDGetChildByName(self, "Top_Node_Task")
	self.panelTouch = SoraDGetChildByName(self, "Panel_Touch")
	self.nodeItem = SoraDGetChildByName(self, "Node_TaskItem")
	self.nodeBottom = SoraDGetChildByName(self, "Node_Bottom")
	self:setButtonListener()
	self:initPointNode()
	self:fitView()
end
function sultansBackWarTaskNode:createPatternSprite(isLeft)
	local sprite = display.newSprite("SinglePicture/frame_sdgl_zzyry_jdt_01.png")
	sprite:addTo(self.nodeScale)
	sprite:setPosition(isLeft and -97 or 97, 175)
	sprite:setFlippedX(not isLeft)
	return sprite
end
function sultansBackWarTaskNode:setButtonListener()
	self.btnQuestion:addTouchEventListener(handler(self, self.btnQuestionClick))
	self.btnGetAward:addTouchEventListener(handler(self, self.btnGetAwardClick))
	self.btnLeft:addTouchEventListener(handler(self, self.btnArrowLClick))
	self.btnRight:addTouchEventListener(handler(self, self.btnArrowRClick))
	self.btnTask:addTouchEventListener(handler(self, self.btnDetailClick))
	self.panelTouch:addTouchEventListener(handler(self, self.btnTouchPanelClick))
end
function sultansBackWarTaskNode:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_SULTANSBACK_WARTASK_REFRESH", handler(self, self.updateTotalTaskStatus))
end
function sultansBackWarTaskNode:initData()
	self:initActivityTime()
	self:initEffect()
	self:refreshTaskInfo()
end
function sultansBackWarTaskNode:initEffect()
	SoraDGetChildByName(self, "Particle_1_0"):setAutoCull(false)
	local loop = true
	local cssFileName = "sultansBackWarTaskNode"
	local cssFilePath = getCCSPath(cssFileName)
	local action = cc.CSLoader:createTimeline(cssFilePath)
	action:gotoFrameAndPlay(0, loop)
	self:runAction(action)
	self.nodeAnimation = SoraDCreatAnimationEx("sultansBackWarTaskAnimate", self.nodeAnimation, false)
	self.nodeAnimation.action:gotoFrameAndPause(0)
	self.nodeAnimation.action:setTimeSpeed(2)
	self.curFrameIndex = 0
	self.spBanner = SoraDGetChildByName(self, "frame_sdgl_qz")
	self.spBanner:setLocalZOrder(25)
	self.taskNodeList = SoraDGetChildsArrayByName(self.nodeAnimation, "yuanpan_", 5, 1, true)
	self:setAnimateZorder()
end
function sultansBackWarTaskNode:fitView()
	local height = self:getPanelOffsetHeight()
	local maxOffsetY = self.topNode:getPositionY() - self.nodeScale:getPositionY()
	if 1136 <= height then
		self.nodeScale:setPositionY(self.nodeScale:getPositionY() + maxOffsetY - 627)
	elseif height < 1136 then
		self.nodeScale:setScale(height / 1300)
		self.nodeBottom:setScale(height / 1050)
		local offsetY = math.max(maxOffsetY - height / 1300 * 627, 20 - 260 * (1 - height / 1050))
		print("offsetY", offsetY, maxOffsetY - height / 1300 * 627)
		self.nodeScale:setPositionY(self.nodeScale:getPositionY() + offsetY)
	end
end
function sultansBackWarTaskNode:initPointNode()
	local pointNode = cc.Node:create()
	pointNode:setPosition(320, 15)
	pointNode:addTo(self, 99)
	local imageItemBg = ccui.ImageView:create("frame_lace_09_02.png", ccui.TextureResType.plistType)
	imageItemBg:setName("Image_bg")
	imageItemBg:setPosition(0, 0)
	imageItemBg:addTo(pointNode)
	local imageLight = ccui.ImageView:create("frame_lace_09_01.png", ccui.TextureResType.plistType)
	imageLight:setName("Image_light")
	imageLight:setPosition(0, 0)
	imageLight:addTo(pointNode)
	self.pagePoint = include("commonScrollIndicatorNumber").new(pointNode)
	_ENV = pointNode
	pointNode.count = table.nums(sultansBackRead.getBattleTaskConfig())
	pointNode.intervalWidth = 20
	pointNode.begin = self.taskType
	self.pagePoint:initData(pointNode)
end
function sultansBackWarTaskNode:initActivityTime()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	self.eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	self.textTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_607", nil)
	end)
	if self.eventTime then
		self.textTime:beginTime(self.eventTime.timerNode.timer:getRemainTime())
	end
	SoraDToCenter(self.nodeTime, 10)
end
function sultansBackWarTaskNode:switchTaskNode(isLeft)
	self.canSwitch = false
	local curFrameIndex = self.curFrameIndex
	if isLeft then
		self.taskType = self.taskType == #self.taskConfig and 1 or self.taskType + 1
		if self.curFrameIndex == 320 then
			self.curFrameIndex = 0
		end
		self.curFrameIndex = self.curFrameIndex + FRAME_OFFSET
	else
		self.taskType = self.taskType == 1 and #self.taskConfig or self.taskType - 1
		if self.curFrameIndex == 0 then
			self.curFrameIndex = 320
			curFrameIndex = self.curFrameIndex + 500
		else
			curFrameIndex = self.curFrameIndex + 180 + (5 - self.taskType) * 128
		end
		self.curFrameIndex = self.curFrameIndex - FRAME_OFFSET
	end
	if curFrameIndex == 320 then
		curFrameIndex = 0
	elseif curFrameIndex == 820 then
		curFrameIndex = 500
	end
	self.nodeAnimation.action:gotoFrameAndPlay(curFrameIndex, curFrameIndex + FRAME_OFFSET, false)
	_ENV = curFrameIndex + FRAME_OFFSET
	;(curFrameIndex + FRAME_OFFSET)[1] = cca.delay(FRAME_OFFSET / 120)
	;(curFrameIndex + FRAME_OFFSET)[2] = cca.callFunc(function()
		self.nodeAnimation.action:gotoFrameAndPause(self.curFrameIndex)
		self.canSwitch = true
	end)
	;(curFrameIndex + FRAME_OFFSET)[3] = cca.callFunc(function()
		self.nodeAnimation.action:gotoFrameAndPause(self.curFrameIndex)
		self.canSwitch = true
	end)
	self:runAction(cca.seq(curFrameIndex + FRAME_OFFSET))
	self:setAnimateZorder(isLeft)
	self:refreshTaskInfo()
end
function sultansBackWarTaskNode:setAnimateZorder(isLeft)
	for i, single in ipairs(self.taskNodeList) do
		local index = i - (self.taskType - 1)
		if index <= 0 then
			index = index + #self.taskConfig
		end
		if isLeft and index == 3 then
			index = 4
		elseif isLeft and index == 4 then
			index = 3
		end
		single:setLocalZOrder(ZorderConfig[index])
	end
end
function sultansBackWarTaskNode:refreshTaskInfo()
	local config = sultansBackRead.getBattleTaskConfigByIndex(self.taskType)
	sultansBackRead = nil
	;(nil).name = i18n(config.name)
	self.textDescribe:setString(i18n("friend_return_text_26", nil))
	self:refreshTotalAward()
	self:updateTotalTaskStatus()
	self.pagePoint:setCurLight(self.taskType)
	sultansBackRead = i18n("friend_return_text_26", nil)
	i18n("friend_return_text_26", nil).activityID = self.activityID
	self:updateRedPoint(nil, i18n("friend_return_text_26", nil))
end
function sultansBackWarTaskNode:updateTotalTaskStatus()
	local progress = sultansBackCtrl:getWarTaskProgressByType(self.activityID, self.taskType)
	self.progressBar:setPercentage(progress)
	self.textProgress:setString(string.format("%s%%", progress))
	self:updateSpriteProgress(progress * 0.01)
	local status = sultansBackCtrl:getWarTotalTaskStatus(self.taskType)
	if status == gBtnTargetStatusDef.GOT then
		self.btnGetAward:setTitleText(i18n("common_text_1892"))
		self.btnGetAward:setTouchEnabled(false)
		self.btnGetAward:setBright(false)
	elseif status == gBtnTargetStatusDef.GET then
		self.btnGetAward:setTitleText(i18n("common_text_854"))
		self.btnGetAward:setTouchEnabled(true)
		self.btnGetAward:setBright(true)
	elseif status == gBtnTargetStatusDef.GO then
		self.btnGetAward:setTitleText(i18n("common_text_854"))
		self.btnGetAward:setTouchEnabled(false)
		self.btnGetAward:setBright(false)
	end
end
function sultansBackWarTaskNode:refreshTotalAward()
	local config = sultansBackRead.getBattleTaskConfigByIndex(self.taskType)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local rewardList = serviceFunctions.tableFormat(config.reward, nil)
	for i, v in ipairs(rewardList) do
		local single
		if self.awardItemList[i] then
			single = self.awardItemList[i]
		else
			single = include("commonItemAward").new()
			single:setScale(0.8)
			single:setBaseScale(1.0)
			single:setOwnView(self.parentView)
			single:setPosition(0, 0)
			single:addTo(self.nodeAward)
			self.awardItemList[i] = single
		end
		single:setPosition(0, 0)
		single:initData(v.id, v.count)
	end
	for i = #rewardList + 1, #self.awardItemList do
		self.awardItemList[i]:setVisible(false)
	end
	SoraDToCenter(self.nodeAward, 90)
end
function sultansBackWarTaskNode:updateSpriteProgress(progress)
	if SoraDFIsRA() then
		self:setGraySprite(self.spPatternRight, math.min(1, progress * 2), false)
		self:setGraySprite(self.spPatternLeft, math.max(0, (progress - 0.5) * 2), true)
	else
		self:setGraySprite(self.spPatternLeft, math.min(1, progress * 2), false)
		self:setGraySprite(self.spPatternRight, math.max(0, (progress - 0.5) * 2), true)
	end
end
function sultansBackWarTaskNode:btnQuestionClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		SoraDShowHelpMsgTip(i18n("friend_return_text_09"))
	end
end
function sultansBackWarTaskNode:btnDetailClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.taskType == 3 then
			local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
			if activityShowCtrl:getStateByID(gActivityTimeActivityID.RADIANCE_WAR_ACTIVITY) == gActivityState.CLOSE then
				SoraDShowMsgBox(i18n("skin_text_19"), nil, nil, nil, nil, 1)
				return
			end
		end
		local panel = SoraDCreatePanel("sultansBackWarTaskPop")
		panel:initData(self.taskType)
		panel:show()
	end
end
function sultansBackWarTaskNode:btnGetAwardClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		_ENV = nil
		;(nil).questType = self.taskType
		sultansBackCtrl:reqBackWarTotalTaskReceive(nil)
	end
end
function sultansBackWarTaskNode:btnArrowRClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.canSwitch then
			self:switchTaskNode(false)
		end
	end
end
function sultansBackWarTaskNode:btnArrowLClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.canSwitch then
			self:switchTaskNode(true)
		end
	end
end
function sultansBackWarTaskNode:btnTouchPanelClick(target, eventType)
	if eventType == ccui.TouchEventType.began then
		if self.isMoved then
			return false
		end
	elseif eventType == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if not self.isMoved and tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.isMoved = true
		end
	elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
		if self.isMoved then
			local endPos = target:getTouchEndPosition()
			local beganPos = target:getTouchBeganPosition()
			local isLeft = endPos.x < beganPos.x
			if self.canSwitch then
				self:switchTaskNode(not isLeft)
			end
		end
		self.isMoved = false
		self.touchKey = nil
		self.lastMovePos = nil
	end
end
function sultansBackWarTaskNode:msgCallBack(target, data)
	local index = data.index
	local single = self.nodeList[index]
	local progress = sultansBackCtrl:getWarTaskProgressByType(self.activityID, index)
	single.progressBar:setPercentage(progress)
	sultansBackCtrl = nil
	;(nil).num = progress
	single.textProgress:setString(i18n("key", nil))
end
function sultansBackWarTaskNode:updateRedPoint(target, data)
	local activityID = data.activityID or data.eventID
	if activityID == self.activityID then
		local redNum = sultansBackCtrl:getKingTaskRednumByType(self.activityID, self.taskType)
		self.taskRedPoint:setVisible(0 < redNum)
		self.taskRedPoint:getChildByName("Text_redNum"):setString(redNum)
	end
end
function sultansBackWarTaskNode:setParentView(parent)
	self.parentView = parent
end
function sultansBackWarTaskNode:setGraySprite(sprite, progress, isReverse)
	local program = cc.GLProgramCache:getInstance():getGLProgram(string.format("spriteProgress_%d", isReverse and 1 or 0))
	if not program then
		program = cc.GLProgram:createWithFilenames("Shaders/normal.vsh", "Shaders/spriteProgress.fsh")
		cc.GLProgramCache:getInstance():addGLProgram(program, string.format("spriteProgress_%d", isReverse and 1 or 0))
	end
	local state = cc.GLProgramState:create(program)
	sprite:setGLProgramState(state)
	state:setUniformFloat("progress", progress)
	state:setUniformInt("isReverse", isReverse and 1 or 0)
end
return sultansBackWarTaskNode
