local baseComponent = require("fgui.base.baseComponent")
local Com_Enemy = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BulletGame/Com_Enemy", Com_Enemy)
function Com_Enemy:onInit()
	self.tag = 3
	self.fields.enemy:setVisible(false)
	self.contactTestBitmask = 16
	self.collisionBitmask = 32
	self.categoryBitmask = 1286
	self.damping = 1
	self.friction = 0.5
	self.restitution = 0
	self.density = 0.001
	self.isDead = false
end
function Com_Enemy:spineEventBack(data)
	if data.type == "complete" and "death03_left_01" == data.animation then
		self.fields.Spine_1.effect:setAnimation(0, "death03_left_02", false)
	elseif data.type == "complete" and "death03_up_01" == data.animation then
		self.fields.Spine_1.effect:setAnimation(0, "death03_up_02", false)
	elseif data.type == "complete" and ("death02" == data.animation or "death01" == data.animation or "death03_up_02" == data.animation or "death03_left_02" == data.animation) then
		_UPVALUE1_ = "death03_up_02"
		;("death03_up_02")[1] = cca.fadeTo(0.1, 0)
		;("death03_up_02")[2] = cca.callFunc(function()
		end)
		;("death03_up_02")[3] = cca.callFunc(function()
		end)
		self.fields.Spine_1.effect:runAction(cca.seq("death03_up_02"))
	end
end
function Com_Enemy:updatePhysicsBox()
	local rect = self.fields.Spine_1.effect:getBoundingBox()
	local shape = cc.PhysicsShapeBox:create(cc.size(rect.width * 0.45, rect.height * 0.45), cc.PhysicsMaterial(self.density, self.restitution, self.friction))
	print("self.fields.Spine_1.effect", rect.x, rect.y, rect.width, rect.height)
	self:displayObject():getPhysicsBody():removeAllShapes()
	self:displayObject():getPhysicsBody():addShape(shape)
end
function Com_Enemy:registerEvent()
	SoraDAddMessage(self, "MESSAGE_BULLET_GAME_EFFECT_UPDATE", handler(self, self.msgEventBack))
end
function Com_Enemy:onShow()
	print("Com_Enemy-1", self:getCustomData())
	if self:getCustomData() == "2" then
		self.fields.Spine_1:setEffectPath("spine/fanpai02.skel", nil, false)
	else
		self.fields.Spine_1:setEffectPath("spine/fanpai.skel", nil, false)
	end
	self.fields.Spine_1.effect:registerSpineEventHandler(handler(self, self.spineEventBack), sp.EventType.ANIMATION_COMPLETE)
	self.fields.Spine_1.effect:setAnimation(0, "idle", true)
	self.fields.Spine_1.effect:setAutoCull(false)
	local parentProxy = uiManager:getProxy("bulletGame")
	if parentProxy then
		local data = parentProxy:getCheatData(5)
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
	self:displayObject():getPhysicsBody():setRotationEnable(false)
	self:displayObject():getPhysicsBody():getShape(0):setTag(self.tag)
end
function Com_Enemy:msgEventBack(target, data)
	if not self:isVisible() then
		return
	end
	if self.isDead then
		return
	end
	if data.effectType == 1 then
		local baseV = cc.p(500, 500)
		local bombDistance = 200
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
			print("被炸死")
			local velocity1 = cc.pSub(pos, posBomb)
			velocity1 = cc.pNormalize(velocity1)
			local isUp = false
			local deadType = 3
			if math.abs(velocity1.y) > math.abs(velocity1.x) then
				isUp = true
				if 0 > velocity1.y then
					deadType = 3
				end
			end
			velocity1 = cc.p(velocity1.x * baseV.x, velocity1.y * baseV.y)
			for i, v in ipairs(self:displayObject():getPhysicsBody():getJoints()) do
				cc.Director:getInstance():getRunningScene():getPhysicsWorld():removeJoint(v, true)
			end
			self:displayObject():getPhysicsBody():applyImpulse(velocity1)
			self:playAnimationToDead(deadType, isUp, 0 > velocity1.x)
		end
	end
end
function Com_Enemy:getMyCustomData()
	local data = self:getCustomData()
	if type(data) == "string" then
		print("data", data)
		local dataNew = util.unserialize(data)
		dump(dataNew, "getCustomData")
		return dataNew
	else
		return nil
	end
end
function Com_Enemy:playAnimationToDead(deadType, isUp, isFlip)
	if self.isDead then
		return
	end
	SoraDPlaySound("shoot_game", "shoot_game_injured")
	self:displayObject():getPhysicsBody():setContactTestBitmask(0)
	self.isDead = true
	if isFlip then
		self.fields.Spine_1.effect:setScaleX(-1)
	end
	if deadType == 1 then
		self.fields.Spine_1.effect:setAnimation(0, "death02", false)
	elseif deadType == 2 then
		self.fields.Spine_1.effect:setAnimation(0, "death01", false)
	elseif deadType == 3 then
		if isUp then
			self.fields.Spine_1.effect:setAnimation(0, "death03_up_01", false)
		else
			self.fields.Spine_1.effect:setAnimation(0, "death03_left_01", false)
		end
	end
	print("deadType", deadType)
end
function Com_Enemy:isEnemyDead()
	return self.isDead
end
return Com_Enemy
