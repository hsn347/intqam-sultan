local baseComponent = require("fgui.base.baseComponent")
local Com_Box = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BulletGame/Com_Box", Com_Box)
function Com_Box:onInit()
	print("Com_Box_init")
	self.tag = 6
	self.contactTestBitmask = 1024
	self.collisionBitmask = 2048
	self.categoryBitmask = 2334
	self.damping = 1
	self.friction = 0.5
	self.restitution = 0.5
	self.density = 0.08
end
function Com_Box:registerEvent()
	SoraDAddMessage(self, "MESSAGE_BULLET_GAME_EFFECT_UPDATE", handler(self, self.msgEventBack))
end
function Com_Box:onShow()
	local parentProxy = uiManager:getProxy("bulletGame")
	if parentProxy then
		local data = parentProxy:getCheatData(6)
		print("Com_Box-getCheatData", data)
		if data then
			self.damping = data.damping
			self.friction = data.friction
			self.restitution = data.restitution
			self.density = data.density
		end
	end
	self:displayObject():setPhysicsBody(cc.PhysicsBody:createBox(self:getContentSize(), cc.PhysicsMaterial(self.density, self.restitution, self.friction)))
	self:displayObject():getPhysicsBody():setLinearDamping(self.damping)
	self:displayObject():getPhysicsBody():getShape(0):setContactTestBitmask(self.contactTestBitmask)
	self:displayObject():getPhysicsBody():getShape(0):setCollisionBitmask(self.collisionBitmask)
	self:displayObject():getPhysicsBody():getShape(0):setCategoryBitmask(self.categoryBitmask)
	self:displayObject():getPhysicsBody():getShape(0):setTag(self.tag)
end
function Com_Box:msgEventBack(target, data)
	dump(data, "msgEventBack")
	if data.effectType == 1 then
		local bombDistance = 200
		local baseV = cc.p(500, 500)
		local parentProxy = uiManager:getProxy("bulletGame")
		if parentProxy then
			local data_ = parentProxy:getCheatData(9)
			if data_ then
				if data_.density > 0 then
					baseV.x = data_.density
				end
				if 0 < data_.restitution then
					baseV.y = data_.restitution
				end
				if 0 < data_.friction then
					bombDistance = data_.friction
				end
			end
		end
		local pos = cc.p(self:displayObject():getPosition())
		local posBomb = data.pos
		local distance = cc.pGetDistance(posBomb, pos)
		print("bomb 位置", posBomb.x, posBomb.y, pos.x, pos.y, distance, bombDistance)
		if bombDistance >= distance then
			local velocity1 = cc.pSub(pos, posBomb)
			velocity1 = cc.pNormalize(velocity1)
			velocity1 = cc.p(velocity1.x * baseV.x, velocity1.y * baseV.y)
			for i, v in ipairs(self:displayObject():getPhysicsBody():getJoints()) do
				cc.Director:getInstance():getRunningScene():getPhysicsWorld():removeJoint(v, true)
			end
			self:displayObject():getPhysicsBody():setVelocity(velocity1)
		end
	end
end
return Com_Box
