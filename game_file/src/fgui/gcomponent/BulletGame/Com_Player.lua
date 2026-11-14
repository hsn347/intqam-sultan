local baseComponent = require("fgui.base.baseComponent")
local Com_Player = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BulletGame/Com_Player", Com_Player)
function Com_Player:onInit()
	print("=======Com_Player:onInit")
	self.tag = 2
	self.contactTestBitmask = 64
	self.collisionBitmask = 128
	self.categoryBitmask = 2
	self.damping = 1
	self.friction = 0.5
	self.restitution = 0
	self.density = 0.001
	self.fields.Spine_1:setEffectPath("spine/zhujue.skel", nil, false)
	self.fields.Spine_1.effect:registerSpineEventHandler(function(data)
		if data.type == "complete" and "qingzhu" == data.animation then
			self.fields.Spine_1.effect:setAnimation(0, "idle", true)
		end
	end, sp.EventType.ANIMATION_COMPLETE)
	self.fields.Spine_1.effect:setAnimation(0, "idle", true)
	self.fields.Spine_1.effect:setAutoCull(false)
	self.fields.player:setVisible(false)
end
function Com_Player:onShow()
	print("=======Com_Player:onShow")
	local parentProxy = uiManager:getProxy("bulletGame")
	if parentProxy then
		local data = parentProxy:getCheatData(4)
		print("getCheatData", data)
		if data then
			self.damping = data.damping
			self.friction = data.friction
			self.restitution = data.restitution
			self.density = data.density
		end
	end
	self:displayObject():setPhysicsBody(cc.PhysicsBody:createBox(self:getContentSize(), cc.PhysicsMaterial(self.density, self.restitution, self.friction)))
	self:displayObject():getPhysicsBody():getShape(0):setContactTestBitmask(self.contactTestBitmask)
	self:displayObject():getPhysicsBody():getShape(0):setCollisionBitmask(self.collisionBitmask)
	self:displayObject():getPhysicsBody():getShape(0):setCategoryBitmask(self.categoryBitmask)
	self:displayObject():getPhysicsBody():setRotationEnable(false)
	self:displayObject():getPhysicsBody():getShape(0):setTag(self.tag)
end
function Com_Player:setBoneRotation(rotation)
	if 90 < rotation then
		self:setScaleX(-1)
		rotation = rotation - 180
	else
		self:setScaleX(1)
		rotation = -rotation
	end
	self.fields.Spine_1.effect:setBoneActive("AAAAA", false)
	self.fields.Spine_1.effect:setBoneRotation("AAAAA", rotation)
end
function Com_Player:runPlayerAnimation(animationName)
	self.fields.Spine_1.effect:setAnimation(0, animationName, false)
end
function Com_Player:getGanPos()
	local pos = cc.p(self:displayObject():getPosition())
	pos.y = -pos.y
	if self:getScaleX() == 1 then
		return cc.pAdd(pos, cc.p(-1, -39))
	else
		return cc.pAdd(pos, cc.p(1, -39))
	end
end
return Com_Player
