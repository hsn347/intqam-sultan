local sultansBackRead = include("sultansBackRead")
local sultansBackCtrl = SoraDGetCtrl("sultansBackCtrl")
local sultansBackLoginTaskNode = class("sultansBackLoginTaskNode", function(target)
	local target = SoraDCreateBasePanel("sultansBackLoginTaskNode")
	SoraDDeviceFitOffset(target)
	return target
end)
function sultansBackLoginTaskNode:ctor()
	self.boxArray, _ENV, self.loginArray, _ENV, self.activityID = gActivityTimeActivityID.SULTAN_BACK_LOGIN_ACTIVITY, gActivityTimeActivityID.SULTAN_BACK_LOGIN_ACTIVITY, gActivityTimeActivityID.SULTAN_BACK_LOGIN_ACTIVITY, gActivityTimeActivityID.SULTAN_BACK_LOGIN_ACTIVITY, gActivityTimeActivityID.SULTAN_BACK_LOGIN_ACTIVITY
	self.Node_time = SoraDGetChildByName(self, "Node_time")
	self.Text_time = SoraDGetChildByName(self, "Text_time")
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Button_Question = SoraDGetChildByName(self, "Button_Question")
	self.Button_Question:addTouchEventListener(handler(self, self.btnQuestionClick))
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("common_text_518"))
	self.Top_Node_border = SoraDGetChildByName(self, "Top_Node_border")
	self.Image_activity = SoraDGetChildByName(self, "Image_activity")
	self.Image_sbg = SoraDGetChildByName(self, "Image_sbg")
	self.Node_hh = SoraDGetChildByName(self, "Node_hh")
	self.Size_Tile_Image_l = SoraDGetChildByName(self, "Size_Tile_Image_l")
	self.Size_Tile_Image_r = SoraDGetChildByName(self, "Size_Tile_Image_r")
	self.Node_bb = SoraDGetChildByName(self, "Node_bb")
	self.Node_pBoxs = SoraDGetChildByName(self, "Node_pBoxs")
	self.Panel_progress = SoraDGetChildByName(self, "Panel_progress")
	self.icon_progress = SoraDGetChildByName(self, "icon_progress")
	self.Button_box = SoraDGetChildByName(self, "Button_box")
	self.boxArray[1] = self.Button_box
	self.Node_content = SoraDGetChildByName(self, "Node_content")
	self.Node_SingleSign = SoraDGetChildByName(self, "Node_SingleSign")
	self.loginArray[1] = self.Node_SingleSign
	self.Node_etBg = SoraDGetChildByName(self, "Node_etBg")
	SoraDCreatAnimation("animationSDGLDLBG"):addTo(self.Node_etBg)
	self.Node_etP1 = SoraDGetChildByName(self, "Node_etP1")
	SoraDCreatAnimation("animationSDGLDLJDT1"):addTo(self.Node_etP1)
	self.Node_etP2 = SoraDGetChildByName(self, "Node_etP2")
	SoraDCreatAnimation("animationSDGLDLJDT2"):addTo(self.Node_etP2)
	self.Node_etP3 = SoraDGetChildByName(self, "Node_etP3")
	SoraDCreatAnimation("animationSDGLDLJDT3"):addTo(self.Node_etP3)
	self:suitView()
end
function sultansBackLoginTaskNode:onEnterPanel()
	SoraDGetCtrl("activityCenterUICtrl"):sendClearNewMsg(self.activityID)
end
function sultansBackLoginTaskNode:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SULTANSBACK_LOGINTASK_REFRESH", handler(self, self.msgCallBack))
end
function sultansBackLoginTaskNode:suitView()
	self.Image_activity:setPositionY(math.max(-1160, -display.height + 80))
	self.Top_Node_border:setPositionY(display.height - 200)
	if display.height > 1136 then
		self.Top_Node_border:setPositionY(display.height - 250)
	end
	self.Image_sbg:setContentSize(cc.size(540, 620))
	self.Node_etBg:setPositionY(347)
	self.Node_etBg:setScaleY(1.0316139767054908)
	self.Node_content:setPositionY(-self.Image_sbg:getContentSize().height / 2 + self.Image_sbg:getPositionY())
	self.Node_bb:setPositionY(-self.Image_sbg:getContentSize().height + 460)
	self.Node_pBoxs:setPositionY(self.Node_bb:getPositionY() - 465)
	self.Size_Tile_Image_l:setContentSize(cc.size(43, self.Image_sbg:getContentSize().height - 128))
	self.Size_Tile_Image_r:setContentSize(cc.size(43, self.Image_sbg:getContentSize().height - 128))
	if display.height < 1136 then
		self.Top_Node_border:setPositionY(display.height - 220)
		self.Image_activity:setPositionY(-display.height - 60)
		local scale = display.height / 1100 - 0.07272727272727272
		self.Top_Node_border:setScale(scale)
	end
end
function sultansBackLoginTaskNode:initActivityTime()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	self.Text_time:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_607", nil)
	end)
	if eventTime then
		self.Text_time:beginTime(eventTime.timerNode.timer:getRemainTime())
	end
	SoraDToCenter(self.Node_time, 10)
end
function sultansBackLoginTaskNode:initProgressBar()
	local stage_reward = sultansBackRead.getLoginCunsum()
	local curNum = sultansBackCtrl:getCurrentLoginDay()
	_UPVALUE5_ = sultansBackCtrl
	sultansBackCtrl[1] = 2
	sultansBackCtrl[2] = 3
	sultansBackCtrl[3] = 4
	sultansBackCtrl[4] = 5
	local sultansBackCtrl[5], boxImgs = 6, sultansBackCtrl
	for k, v in ipairs(stage_reward) do
		if not self.boxArray[k] then
			local box = self.Button_box:clone()
			box:addTo(self.Node_pBoxs, 9)
			self.boxArray[k] = box
		end
		local isGot = sultansBackCtrl:isLoginCumuRewardGot(v.num)
		local Sprite_box = SoraDGetChildByName(self.boxArray[k], "Sprite_box")
		local status = gBtnTargetStatusDef.GO
		if isGot then
			SoraDGetCommonBox(boxImgs[k], 3, Sprite_box)
			status = gBtnTargetStatusDef.GOT
		elseif curNum >= v.num then
			SoraDGetCommonBox(boxImgs[k], 1, Sprite_box)
			status = gBtnTargetStatusDef.GET
		else
			SoraDGetCommonBox(boxImgs[k], 2, Sprite_box)
			status = gBtnTargetStatusDef.GO
		end
		SoraDGetChildByName(self.boxArray[k], "Text_price"):setString(v.num)
		self.boxArray[k]:addTouchEventListener(handler(self, self.btnBoxClick))
		self.boxArray[k].status = status
		sultansBackRead = self.boxArray[k]
		self.boxArray[k].status = status
		self.boxArray[k].data, self.boxArray[k].index = self.boxArray[k], v.index
		self.boxArray[k]:setPosition(SoraDFPosX((#stage_reward - k) * 90 - 220, 0), 22)
	end
end
function sultansBackLoginTaskNode:initData(target, data)
	self:initActivityTime()
	self:initProgressBar()
	self:refreshData()
	self:refreshProgressData()
end
function sultansBackLoginTaskNode:btnQuestionClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		SoraDShowHelpMsgTip(i18n("friend_return_text_01"))
	end
end
function sultansBackLoginTaskNode:btnBoxClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local status = target.data.status
		local index = target.data.index
		if status == gBtnTargetStatusDef.GET then
			_ENV = nil
			;(nil).index = sultansBackRead.getLoginCunsumByIndex(index).num
			sultansBackCtrl:reqBackLoginCumuReceive(nil)
		else
			local panel = SoraDCreatePanel("sultansBackLoginTaskAwardPop")
			panel:initData(index, status)
			panel:show()
		end
	end
end
function sultansBackLoginTaskNode:btnGetAwardClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local status = target.status
		local index = target:getTag()
		if status == gBtnTargetStatusDef.GET then
			local Node_etDJ = SoraDGetChildByName(target, "Node_etDJ")
			local et_dj = Node_etDJ:getChildByName("et_dj")
			if et_dj then
				et_dj.action:gotoFrameAndPlay(0, false)
			else
				local et_dj = SoraDCreatAnimationEx("animationSDGLDLDJ", nil, false)
				et_dj:setName("et_dj")
				et_dj:addTo(Node_etDJ)
			end
			_ENV = et_dj
			et_dj.index = index
			sultansBackCtrl:reqBackLoginDayReceive(et_dj)
		else
			local panel = SoraDCreatePanel("sultansBackLoginTaskAwardPop")
			panel:initData(target:getTag(), status, true)
			panel:show()
		end
	end
end
function sultansBackLoginTaskNode:msgCallBack(target, data)
	if data.subMsg == "refreshProgress" then
		self:refreshProgressData()
	elseif data.subMsg == "refreshScroll" then
		self:refreshData()
		self:refreshProgressData()
	else
		self:refreshProgressData()
		self:refreshData()
	end
	self:initProgressBar()
end
function sultansBackLoginTaskNode:refreshData()
	local itemInfoList = sultansBackRead.getLoginReward()
	for k, v in ipairs(itemInfoList) do
		if not self.loginArray[k] then
			local dayItem = self.Node_SingleSign:clone()
			dayItem:addTo(self.Node_content)
			self.loginArray[k] = dayItem
		end
		local status = sultansBackCtrl:getLoginDayStatus(v.day)
		SoraDGetChildByName(self.loginArray[k], "Text_day"):setString(v.day)
		local Node_etLJ = SoraDGetChildByName(self.loginArray[k], "Node_etLJ")
		Node_etLJ:removeAllChildren()
		SoraDCreatAnimation("animationSDGLDLLJ"):addTo(Node_etLJ)
		Node_etLJ:setVisible(status == gBtnTargetStatusDef.GET)
		local btn = SoraDGetChildByName(self.loginArray[k], "Button_GetAward")
		btn.status = status
		btn:setTag(v.day)
		btn:addTouchEventListener(handler(self, self.btnGetAwardClick))
		SoraDGetChildByName(self.loginArray[k], "icon_done"):setVisible(status == gBtnTargetStatusDef.GOT)
		SoraDGetChildByName(self.loginArray[k], "Image_done"):setVisible(status == gBtnTargetStatusDef.GOT)
	end
	SoraDautoSortPos(self.Node_content, 5, SoraDFIsRA() and 2 or 0, cc.size(100, 100))
end
function sultansBackLoginTaskNode:getStagePercent(score, stageList)
	local percent = 0
	local minVar = stageList[1]
	local maxVar = stageList[#stageList]
	local per = 100 / ((#stageList - 1) * 2 + 1)
	local index = 1
	for k, v in ipairs(stageList) do
		if score < v then
			index = k
			break
		end
	end
	if score <= minVar then
		percent = score / minVar * per
	elseif score >= maxVar then
		percent = 100
	elseif index < 3 then
		percent = per + (score - stageList[index - 1]) * per * 2 / (stageList[index] - stageList[index - 1])
	else
		percent = per + 2 * per * (index - 2) + (score - stageList[index - 1]) * per * 2 / (stageList[index] - stageList[index - 1])
	end
	return percent
end
function sultansBackLoginTaskNode:refreshProgressData()
	local stage_reward = sultansBackRead.getLoginCunsum()
	local curNum = sultansBackCtrl:getCurrentLoginDay()
	local finalNum = stage_reward[#stage_reward].num
	local sultansBackRead, stageList
	for k, v in ipairs(stage_reward) do
		stageList[k] = v.num
	end
	local percent = self:getStagePercent(curNum, stageList)
	self.Panel_progress:setContentSize(cc.size(450 * percent / 100, 12))
	local posX = SoraDFPosX(220 - 450 * percent / 100, 0)
	self.icon_progress:setPositionX(posX)
end
function sultansBackLoginTaskNode:getReceivedCunsumReward()
	local _ENV, ret
	for i, v in ipairs(self.stage_reward) do
		ret[tostring(i)] = sultansBackCtrl:isLoginCumuRewardGot(v.num)
	end
	return ret
end
function sultansBackLoginTaskNode:setParentView(parent)
	self.parentView = parent
end
return sultansBackLoginTaskNode
