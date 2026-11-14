local gametop = gModuleMgr.getObject("gametop")
local rechargeActivityCtrl = gametop.playertop_:getModule("rechargeActivityCtrl")
local dailyDiscountGiftCtrl = gametop.playertop_:getModule("dailyDiscountGiftCtrl")
local rechargeFreeAward = class("rechargeFreeAward", function(target)
	if target == nil then
		target = "rechargeFreeAward"
	end
	if type(target) == "string" then
		local view = include("ccsView")
		return view.new(getCCSPath(target))
	end
	return target
end)
function rechargeFreeAward:ctor()
	self.btn_box = SoraDGetChildByName(self, "btn_box")
	self.img_box = SoraDGetChildByName(self, "img_box")
	self.nodeAll = SoraDGetChildByName(self, "Node_all")
	self.btn_box:setPressedActionEnabled(true)
	self.road = gRechargeActiveFromEnum.ROAD03
end
function rechargeFreeAward:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_DAILYFREEGIFT_REFRESH", handler(self, self.updateData))
end
function rechargeFreeAward:updateData(bShow, noJumpCondition)
	local state = 1
	self.img_box:stopAllActions()
	if bShow and noJumpCondition == true then
		state = 0
		self:setVisible(true)
		self.nodeAll:setVisible(true)
		self:setParticle(true)
		self:initJump(self.img_box)
	else
		self.img_box:setVisible(true)
		self:setParticle(false)
		self.img_box:stopAllActions()
	end
	self.img_box:getVirtualRenderer():setState(state)
end
function rechargeFreeAward:setTouchEventListener(_handle)
	self.btn_box:addTouchEventListener(_handle)
end
function rechargeFreeAward:changeBoxStyle(img)
	self.img_box:loadTexture(img, ccui.TextureResType.plistType)
end
function rechargeFreeAward:initJump(img)
	img:stopAllActions()
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
function rechargeFreeAward:setRoad(from)
	self.road = from
end
function rechargeFreeAward:setState(bShow)
	self:updateData(bShow)
end
function rechargeFreeAward:setParticle(start)
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
return rechargeFreeAward
