local publicRead = include("publicRead")
local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local sheepRunCtrl = gametop.playertop_:getModule("sheepRunCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl", gametop)
local constantRead = include("constantRead")
local sheepRunMainView = class("sheepRunMainView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("sheepRunMainView")
	end
	return target
end)
function sheepRunMainView:ctor()
	self.isHideCurrentSceneView = true
	self.needNum = constantRead.getConstValue("RUNNINGSHEEP_ITEM_NEED", 10)
	self.roundTime = constantRead.getConstValue("RUNNINGSHEEP_ROUND_TIME", 15)
	self.friendHelpCount = constantRead.getConstValue("RUNNINGSHEEP_INVITED_EACH", 3)
	self.helpOtherCount = constantRead.getConstValue("RUNNINGSHEEP_BEINVITED_DAILY", 3)
	self:initView()
	self:initEffects()
	self:refreshItem()
	sheepRunCtrl:reqInit()
	self:initTime()
end
function sheepRunMainView:initEffects()
end
function sheepRunMainView:initView()
	self.activityID = gActivityTimeActivityID.SHEEP_RUN_ACTIVITY
	self.itemID = 839901
	self.txt_time = SoraDGetChildByName(self, "Text_time")
	self.txt_time_desc = SoraDGetChildByName(self, "Text_time_desc")
	self.txt_have = SoraDGetChildByName(self, "txt_have")
	self.txt_name = SoraDGetChildByName(self, "txt_name")
	self.txt_top_item = SoraDGetChildByName(self, "Text_top_item")
	self.btn_add = SoraDGetChildByName(self, "button_add")
	self.btn_fire = SoraDGetChildByName(self, "btn_fire")
	self.btn_reward_pool = SoraDGetChildByName(self, "btn_reward_pool")
	self.btn_reward = SoraDGetChildByName(self, "btn_reward")
	self.txt_reward_pool = SoraDGetChildByName(self, "txt_reward_pool")
	self.txt_reward = SoraDGetChildByName(self, "txt_reward")
	self.btn_FAQ = SoraDGetChildByName(self, "btn_FAQ")
	self.Bottom_Node = SoraDGetChildByName(self, "Bottom_Node")
	self.node_bottom_item = SoraDGetChildByName(self, "Node_bottom_item")
	self.node_activity_time = SoraDGetChildByName(self, "Node_after_start")
	self.node_time_bg = SoraDGetChildByName(self, "Image_16")
	self.center_node = SoraDGetChildByName(self, "Center_Node")
	SoraDGetChildByName(self, "Image_start_time_bg"):setVisible(false)
	self.text_start_time = SoraDGetChildByName(self, "Text_start_time")
	self.node_catch_time = SoraDGetChildByName(self, "Node_catch_time")
	self.text_catch_time = SoraDGetChildByName(self, "Text_catch_time")
	self.Panel_catch_sheep = SoraDGetChildByName(self, "Center_Panel_catch_sheep")
	self.Panel_catch_sheep:setTouchEnabled(false)
	self.center_node:setVisible(false)
	self.node_top_item = SoraDGetChildByName(self, "Node_top_item")
	self.txt_name:setString(i18n("runningSheep_text_22"))
	self.closeButton = SoraDGetChildByName(self, "Button_close")
	self.node_choosed_reward = SoraDGetChildByName(self, "Node_choosed_reward")
	self.txt_choosed_reward = SoraDGetChildByName(self, "txt_choosed_reward")
	self.txt_choosed_reward:setString(i18n("runningSheep_text_28"))
	self.node_item = SoraDGetChildByName(self, "Node_item")
	self.choosed_item = include("commonItemAward").new(self.node_item)
	self.choosed_item:setOwnView(self)
	self.center_tips = SoraDGetChildByName(self, "Top_Tips")
	self.text_reward_tip = SoraDGetChildByName(self, "Text_reward_tip")
	self.title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_target")
	self.title:setTitle(i18n("activity_name_9001353"))
	self.txt_time = SoraDCreateTimerLabel(self, self.txt_time)
	self.txt_time:setTimeLast(function(time)
		SoraDToCenter(self.node_activity_time, 5, SoraDFIsRA())
		return time
	end)
	self.txt_time_desc:setString(i18n("common_text_2669"))
	self.btn_fire:setTitleText(i18n("runningSheep_text_27"))
	self.txt_reward:setString(i18n("decrypt_text_03"))
	self.txt_reward_pool:setString(i18n("runningSheep_text_05"))
	self.btn_fire:addTouchEventListener(handler(self, self.onFire))
	self.btn_FAQ:addTouchEventListener(handler(self, self.onHelp))
	self.btn_add:addTouchEventListener(handler(self, self.onGetMore))
	self.btn_reward:addTouchEventListener(handler(self, self.onShowReward))
	self.btn_reward_pool:addTouchEventListener(handler(self, self.onRewardPoolUp))
	local btnEf = cc.criSprite.createCriSprite("sp_xykp_002.usm", false, true)
	btnEf:setPosition(self.btn_reward_pool:getContentSize().width / 2, self.btn_reward_pool:getContentSize().height / 2 + 30)
	btnEf:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	btnEf:addTo(self.btn_reward_pool)
	self.closeButton:addTouchEventListener(handler(self, self.onCloseClick))
	self.bgSp = cc.criSprite.createCriSprite("caodi.usm", false, true, true)
	self.bgSp:setPosition(320, 480)
	self.bgSp:addTo(self.Panel_catch_sheep)
	self.bgSp:setPreviewImage("#caodiditu.png", cc.size(640, 1386), true, true)
	self.unTouchablePanel = SoraDGetChildByName(self, "Center_Panel_untouch")
	self.unTouchablePanel:setContentSize(cc.size(display.width, display.height))
	local sheepsPanel = SoraDGetChildByName(self, "Center_Panel_sheeps")
	self.sheepsPanel = include("sheepRunCatchPanel").new(sheepsPanel)
	self.sheepsPanel:initData(self)
	self:setShowNode()
end
function sheepRunMainView:onExitPanel()
	local catchLastTime = sheepRunCtrl:getLastCatchTime()
	if 0 < catchLastTime then
		self.timeCount = 0
		sheepRunCtrl:reqCatch(true)
	end
	sheepRunCtrl:setChooseID(nil)
	sheepRunCtrl:reqDeleteFriend()
end
function sheepRunMainView:refreshItem()
	local itemNum = backpackCtrl:getItemCount(self.itemID) or 0
	self.txt_have:setString(itemNum .. "/" .. self.needNum)
	local color = itemNum >= self.needNum and cc.c3b(233, 210, 164) or cc.c3b(255, 10, 10)
	self.txt_have:setColor(color)
	self.txt_top_item:setString(itemNum)
	SoraDToCenter(self.node_bottom_item, 5, SoraDFIsRA())
end
function sheepRunMainView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SHEEP_RUN_CHOOSE_REWARD", handler(self, self.readyToStart))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.refreshItem))
	SoraDAddMessage(self, "MESSAGE_ITEM_CHANGE_TYPE", handler(self, self.refreshItem))
	SoraDAddMessage(self, "MESSAGE_SHEEP_RUN_CATCH", handler(self, self.updateCatchView))
	SoraDAddMessage(self, "MESSAGE_SHEEP_RUN_INIT", handler(self, self.updateCatchView))
	SoraDAddMessage(self, "MESSAGE_SHEEP_RUN_NOTIFY", handler(self, self.onNotify))
	SoraDAddMessage(self, "MESSAGE_SERVER_FRIEND_DELETE", handler(self, self.onFriendDeleted))
	SoraDAddMessage(self, "MESSAGE_SHEEP_RUN_CATCH_REWARD", handler(self, self.showCatchReward))
end
function sheepRunMainView:initTime()
	local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	if eventTime then
		local leftTime = eventTime.timerNode.timer:getRemainTime()
		self.txt_time:setString(SoraDConvertSecondToString(leftTime))
		self.txt_time:beginTime(leftTime)
	else
		SoraDRemoveAllAfterPanelFromManager(self)
		return
	end
	SoradCreateTimer(self, handler(self, function()
		local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
		if not eventTime then
			SoraDRemoveAllAfterPanelFromManager(self)
			return
		end
	end))
	SoraDToCenter(self.node_activity_time, 5, SoraDFIsRA())
end
function sheepRunMainView:setShowNode()
	self.Bottom_Node:setVisible(not self.isInCatch)
	self.node_activity_time:setVisible(not self.isInCatch)
	self.node_time_bg:setVisible(not self.isInCatch)
	self.btn_reward:setVisible(not self.isInCatch)
	self.node_top_item:setVisible(self.isInCatch)
	self.node_catch_time:setVisible(self.isInCatch)
	local chooseItem = sheepRunCtrl:getChooseItem()
	self.node_choosed_reward:setVisible(self.isInCatch and chooseItem ~= nil)
	if chooseItem then
		self.choosed_item:initData(chooseItem.item, chooseItem.num)
	end
	if not self.isInCatch then
		self.unTouchablePanel:setVisible(true)
		self.sheepsPanel:reset()
	end
	self.btn_reward_pool:setVisible(sheepRunCtrl:getGiftData() ~= nil and not self.isInCatch)
end
function sheepRunMainView:updateCatchView()
	local catchLastTime = sheepRunCtrl:getLastCatchTime()
	local oldIsInCatch = self.isInCatch
	self.isInCatch = 0 < catchLastTime
	if (not oldIsInCatch or oldIsInCatch ~= self.isInCatch) and not self.isShowingCatch then
		self:setShowNode()
	end
	if self.isInCatch then
		local timeCount = math.floor(catchLastTime + 0.999999)
		if oldIsInCatch ~= self.isInCatch or self.isStart then
			self.timeCount = timeCount
			self.unTouchablePanel:setVisible(false)
			self.timeEndCallback = handler(self, self.timeEnd)
			function self.timeCallback()
				if self.timeCount < 0 then
					self.timeCount = 0
				end
				self.text_catch_time:setString(self.timeCount .. "s")
			end
			self:onTimeSec()
		elseif math.abs(self.timeCount - timeCount) > 1 then
			self.timeCount = timeCount
			self.text_catch_time:setString(timeCount .. "s")
		end
	end
	self.isStart = false
	self:refreshItem()
end
function sheepRunMainView:readyToStart()
	self.center_node:setVisible(true)
	self.timeCount = 3
	self.timeEndCallback = handler(self, self.start)
	self:updateStartTime()
	function self.timeCallback()
		self:updateStartTime()
	end
	self.unTouchablePanel:setVisible(true)
	self.text_catch_time:setString(self.roundTime .. "s")
	self.isInCatch = true
	self:setShowNode()
	self:onTimeSec()
end
function sheepRunMainView:updateStartTime()
	self.text_start_time:setOpacity(255)
	self.text_start_time:setString(self.timeCount)
	self.text_start_time:setScale(2.5)
	_ENV = nil
	;(nil)[1] = cca.scaleTo(0.3, 1.2)
	;(nil)[2] = cca.scaleTo(0.3, 1.2)
	;(nil)[3] = cca.scaleTo(0.3, 1.2)
	self.text_start_time:runAction(cca.seq(nil))
end
function sheepRunMainView:start()
	self.isStart = true
	self.center_node:setVisible(false)
	sheepRunCtrl:reqCatch(false)
	local guideCtrl = gametop.playertop_:getModule("guideCtrl")
	guideCtrl:updateGuideModule(gGuideModule.SHEEP_RUN_ACTIVITY_2)
end
function sheepRunMainView:timeEnd()
end
function sheepRunMainView:onTimeSec()
	self:stopActionByTag(99)
	_UPVALUE1_ = self
	self[1] = cca.delay(1)
	self[2] = cca.callFunc(function()
		self.timeCount = self.timeCount - 1
		if self.timeCallback then
			self.timeCallback()
		end
		if self.timeCount <= 0 then
			if self.timeEndCallback then
				self.timeEndCallback()
				self.timeEndCallback = nil
			end
			return
		end
		self:onTimeSec()
	end)
	self[3] = cca.callFunc(function()
		self.timeCount = self.timeCount - 1
		if self.timeCallback then
			self.timeCallback()
		end
		if self.timeCount <= 0 then
			if self.timeEndCallback then
				self.timeEndCallback()
				self.timeEndCallback = nil
			end
			return
		end
		self:onTimeSec()
	end)
	local action = cca.seq(self)
	action:setTag(99)
	self:runAction(action)
end
function sheepRunMainView:onGetMore(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("sheepRunItemGet"):show()
	end
end
function sheepRunMainView:onFire(button, eventType)
	if eventType == ccui.TouchEventType.ended and not self.isShowing then
		SoraDPlaySound()
		if backpackCtrl:getItemCount(self.itemID) < self.needNum then
			local tip = i18n("runningSheep_text_09")
			SoraDShowMsgBoxNew(tip, i18n("common_text_477"), nil, function(exitType, other)
				if exitType ~= MSGBOX_CALLBACK_YES then
					return
				end
				SoraDCreatePanel("sheepRunItemGet"):show()
			end)
		else
			SoraDCreatePanel("sheepRunRewardChoose"):show()
		end
	end
end
function sheepRunMainView:onHelp(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).var1 = self.friendHelpCount
		;(nil).var2 = self.helpOtherCount
		;(nil).time = self.roundTime
		_ENV = "runningSheep_text_20"
		;("runningSheep_text_20").align = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("runningSheep_text_20", nil), "runningSheep_text_20")
	end
end
function sheepRunMainView:onShowReward(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("sheepRunRewardPool"):show()
	end
end
function sheepRunMainView:onRewardPoolUp(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("sheepRunRewardPoolUp"):show()
	end
end
function sheepRunMainView:onCloseClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isInCatch then
			local tip = i18n("runningSheep_text_21")
			SoraDShowMsgBoxNew(tip, nil, nil, function(exitType, other)
				if exitType ~= MSGBOX_CALLBACK_YES then
					return
				end
				local catchLastTime = sheepRunCtrl:getLastCatchTime()
				if 0 < catchLastTime then
					self:stopActionByTag(99)
					sheepRunCtrl:reqCatch(true)
				elseif self.isInCatch then
					self:stopActionByTag(99)
					self.isInCatch = false
					self.center_node:setVisible(false)
					self:setShowNode()
				end
			end)
		else
			self:removeFromParent()
		end
	end
end
function sheepRunMainView:onFriendDeleted(target, data)
	sheepRunCtrl:reqDeleteFriend()
end
function sheepRunMainView:onNotify(target, data)
end
function sheepRunMainView:showCatchReward(target, data)
	self.sheepsPanel:showCatchReward(target, data)
end
function sheepRunMainView:gameGuide_getTarget(itemName, parameters)
	if itemName == "sheep1" then
		return self.sheepsPanel.sheeps[15]
	elseif itemName == "sheep2" then
		return self.sheepsPanel.sheeps[16]
	elseif itemName == "sheep3" then
		return self.sheepsPanel.sheeps[17]
	end
	return SoraDGetChildByName(self, itemName)
end
return sheepRunMainView
