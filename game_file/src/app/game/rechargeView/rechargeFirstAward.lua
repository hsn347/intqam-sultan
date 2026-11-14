local gametop = gModuleMgr.getObject("gametop")
local rechargeActivityCtrl = gametop.playertop_:getModule("rechargeActivityCtrl")
local rechargeFirstAward = class("rechargeFirstAward", function(target)
	if target == nil then
		target = "rechargeFirstAward"
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(getCCSPath(target))
	end
	return target
end)
function rechargeFirstAward:ctor()
	self.btn_box = SoraDGetChildByName(self, "btn_box")
	self.img_box = SoraDGetChildByName(self, "img_box")
	self.nodeAll = SoraDGetChildByName(self, "Node_all")
	self.iconBg = SoraDGetChildByName(self, "icon_bg")
	self.btn_box:addTouchEventListener(handler(self, self.OnBtnClick))
	self.btn_box:setPressedActionEnabled(true)
	self.road = gRechargeActiveFromEnum.ROAD03
	self:updateData(true)
end
function rechargeFirstAward:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_CLIENT_RECHARGECENTER_DAYFIRST", handler(self, self.updateData))
end
function rechargeFirstAward:updateData(bShow)
	local isRechargeAccout = rechargeActivityCtrl:getIsAccountFirstRecharge()
	local isRecharge = rechargeActivityCtrl:getIsDayFirstRecharge()
	if bShow and isRecharge then
		self:setVisible(true)
		self.nodeAll:setVisible(true)
		self:setParticle(true)
		self:initJump(self.img_box)
	else
		self:setVisible(false)
		self.nodeAll:setVisible(false)
		self:setParticle(false)
		self.img_box:stopAllActions()
	end
end
function rechargeFirstAward:OnBtnClick(target, event)
	if event == ccui.TouchEventType.began then
		self.img_box:setScale(1)
	elseif event == ccui.TouchEventType.ended then
		self.img_box:setScale(0.8)
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local panel = SoraDCreatePanel("rechargeFirstAwardDetail")
		panel:show()
		if self.road then
			print("userSDKManager.logEvent", self.road)
			_ENV = self.road
			self.road.entrance = self.road
			userSDKManager.logEvent(gSDKDef.TDonEvent.click_first_award_view, self.road)
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
		self.img_box:setScale(0.8)
	end
end
function rechargeFirstAward:initJump(img)
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
function rechargeFirstAward:setRoad(from)
	self.road = from
end
function rechargeFirstAward:setActivity(activityID)
	self.activityID = activityID
end
function rechargeFirstAward:setState(bShow)
	self:updateData(bShow)
end
function rechargeFirstAward:setParticle(start)
	for i = 1, 4 do
		local particle = SoraDGetChildByName(self, "Particle_" .. i)
		if particle then
			if start then
				particle:resetSystem()
			else
				particle:stopSystem()
			end
		end
	end
end
return rechargeFirstAward
