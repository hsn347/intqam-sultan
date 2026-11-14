local activityTimeRead = include("activityTimeRead")
local rechargePresentUtil = include("rechargePresentUtil")
local resDesRead = include("resDesRead")
local rechargePresentNodeTime = class("rechargePresentNodeTime", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("rechargePresentNodeTime")
end)
local colorRechrge = cc.c3b(235, 229, 59)
function rechargePresentNodeTime:ctor(properties)
	self.activityID = gActivityTimeActivityID.SULTAN_EX_RECAHRGE_PRESENT
	self.activitybg = SoraDGetChildByName(self, "frame_cz_activitybg_01")
	self.imgTimeBg = SoraDGetChildByName(self, "Image_30")
	self.textTip = SoraDGetChildByName(self, "Text_Tips")
	self.btnShowAward = SoraDGetChildByName(self, "Button_ShowAward")
	self.btnShowAward:addTouchEventListener(handler(self, self.btnShowAwardClick))
	self.nodeTimer = SoraDGetChildByName(self, "Node_Timer")
	self.textActivityTime = SoraDGetChildByName(self.nodeTimer, "Text_ActivityTime")
	self.textActivityTime = SoraDCreateTimerLabel(self, self.textActivityTime)
	self.spriteBox = SoraDGetChildByName(self, "Sprite_10")
	self.Node_effect = SoraDGetChildByName(self, "Node_effect")
	SoraDCreatAnimation(self.__cname, self)
end
function rechargePresentNodeTime:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.msgCallBack))
end
function rechargePresentNodeTime:initData(rechargeIDList, viewType)
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
		self.imgTimeBg:setVisible(false)
		self.textActivityTime:setColor(colorRechrge)
		local isLeft = self.viewType == 2
		self.nodeTimer:setPosition(isLeft and -120 or 120, -26)
		self.textTip:setPositionX(isLeft and -120 or 120)
		self.activitybg:setFlippedX(isLeft)
		self.btnShowAward:setContentSize(cc.size(284, 50))
		self.btnShowAward:setPosition(isLeft and -104 or 114, 12)
		self.spriteBox:setPosition(isLeft and -3 or 13, 0)
		self.Node_effect:setPosition(isLeft and -283 or -265, -11)
	end
end
function rechargePresentNodeTime:initActivityTime()
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
function rechargePresentNodeTime:adjustView(open, pos, scale, posX)
	local isLeft = self.viewType == 2
	if open then
		local offsetX = 0
		local offsetXBg = 104
		local offsetY = 0
		if self.viewType == 1 then
			offsetX = SoraDFIsRA() and 160 or -160
			if posX then
				posX = SoraDFIsRA() and posX or -posX
				offsetX = offsetX + posX
			end
		elseif self.viewType ~= 4 then
			offsetX = isLeft and -260 or 260
			offsetXBg = isLeft and -80 or 80
		elseif self.viewType == 4 then
			offsetY = 130
		end
		if scale then
			offsetX = offsetX * scale
		end
		self:setPositionX(pos.x + offsetX)
		self:setPositionY(pos.y + offsetY)
		self.activitybg:setPositionX(offsetXBg)
		self.activitybg:setContentSize(cc.size(324, 50))
	else
		self:setPosition(pos)
		self.activitybg:setPositionX(isLeft and -104 or 104)
		self.activitybg:setContentSize(cc.size(284, 50))
	end
end
function rechargePresentNodeTime:btnShowAwardClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		rechargePresentUtil.openActivityView(self.activityID)
	end
end
function rechargePresentNodeTime:msgCallBack(target, data)
	if not rechargePresentUtil.checkActivityFirstStage(self.activityID) then
		self:removeFromParent()
	end
end
function rechargePresentNodeTime:setActivityID(activityID)
	self.activityID = activityID
	self:initActivityTime()
	local resId = rechargePresentUtil.getResIdByActivityID(self.activityID)
	local iconName = resDesRead.getIcon(resId)
	self.spriteBox:setSpriteFrame(iconName)
	local activityName = activityTimeRead.getActivityNameByID(self.activityID)
	self.textTip:setString(i18n(activityName))
end
return rechargePresentNodeTime
