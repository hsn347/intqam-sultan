local rechargeGiftNode = class("rechargeGiftNode", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("rechargeGiftNode")
end)
local colorRechrge = cc.c3b(235, 229, 59)
function rechargeGiftNode:ctor(properties)
	self.activityID = gActivityTimeActivityID.RECHARGE_ACTIVITY_GIFT_ACTIVITY
	self.activitybg = SoraDGetChildByName(self, "frame_cz_activitybg_01")
	self.imgTimeBg = SoraDGetChildByName(self, "Image_30")
	self.textTip = SoraDGetChildByName(self, "Text_Tips")
	self.btnShowAward = SoraDGetChildByName(self, "Button_ShowAward")
	self.btnShowAward:addTouchEventListener(handler(self, self.btnShowAwardClick))
	self.spriteBox = SoraDGetChildByName(self, "Sprite_10")
	self.nodeTimer = SoraDGetChildByName(self, "Node_Timer")
	self.textActivityTime = SoraDGetChildByName(self.nodeTimer, "Text_ActivityTime")
	self.textActivityTime = SoraDCreateTimerLabel(self, self.textActivityTime)
	self:initActivityTime()
	self:initJump(self.spriteBox)
end
function rechargeGiftNode:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.msgCallBack))
end
function rechargeGiftNode:initData(rechargeIDList, viewType)
	self.rechargeIDList = rechargeIDList
	self.viewType = viewType
	if self.viewType == 1 or self.viewType == 4 then
		self.activitybg:setVisible(false)
		self.textTip:setVisible(false)
		self.imgTimeBg:setVisible(true)
		self.textActivityTime:setColor(cc.c3b(255, 255, 255))
		self.nodeTimer:setPosition(0, -34)
		self.btnShowAward:setContentSize(cc.size(80, 100))
		self.btnShowAward:setPosition(0, 50)
	else
		self.activitybg:setVisible(true)
		self.textTip:setVisible(true)
		self.textTip:setString(i18n("activity_name_9001266"))
		self.imgTimeBg:setVisible(false)
		self.textActivityTime:setColor(colorRechrge)
		local isLeft = self.viewType == 2
		self.nodeTimer:setPosition(isLeft and -120 or 120, -26)
		self.textTip:setPositionX(isLeft and -120 or 120)
		self.activitybg:setPositionX(isLeft and -104 or 104)
		self.activitybg:setFlippedX(isLeft)
		self.btnShowAward:setContentSize(cc.size(284, 50))
		self.btnShowAward:setPosition(isLeft and -104 or 104, 12)
	end
end
function rechargeGiftNode:initActivityTime()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	self.eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	self.textActivityTime:setTimeLast(function(ticket)
		return ticket
	end)
	if self.eventTime then
		self.textActivityTime:beginTime(self.eventTime.timerNode.timer:getRemainTime())
	end
	SoraDToCenter(self.nodeTimer, 0, not SoraDFIsRA())
end
function rechargeGiftNode:initJump(img)
	self.moveUp = cca.moveTo(0.5, img:getPositionX(), img:getPositionY() + 8)
	self.moveDown = cca.moveTo(0.2, img:getPositionX(), img:getPositionY() - 5)
	self.move = cca.moveTo(0.1, img:getPositionX(), img:getPositionY())
	_UPVALUE7_ = 0.1
	;(0.1)[1] = self.moveUp
	;(0.1)[2] = self.moveDown
	;(0.1)[3] = self.moveUp
	;(0.1)[4] = self.moveDown
	;(0.1)[5] = self.moveUp
	;(0.1)[6] = self.moveDown
	;(0.1)[7] = self.move
	;(0.1)[8] = cca.delay(2)
	;(0.1)[9] = cca.delay(2)
	self.moveAct = cca.seq(0.1)
	img:runAction(cca.repeatForever(self.moveAct))
end
function rechargeGiftNode:btnShowAwardClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		local panel = SoraDCreatePanel("rechargeGiftRewardPopView")
		panel:initData(self.rechargeIDList)
		panel:show()
	end
end
function rechargeGiftNode:msgCallBack(target, data)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		self:removeFromParent()
	end
end
return rechargeGiftNode
