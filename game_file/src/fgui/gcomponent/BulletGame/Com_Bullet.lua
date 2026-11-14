local baseComponent = require("fgui.base.baseComponent")
local Com_Bullet = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BulletGame/Com_Bullet", Com_Bullet)
function Com_Bullet:onInit()
	self.tag = 1
	self.radius = 10
	self.contactTestBitmask = 4
	self.collisionBitmask = 8
	self.categoryBitmask = 7443
	self.damping = 0.0
	self.friction = 0.0
	self.restitution = 1.0
	self.density = 0.15
	self.maxNum = tonumber(include("constantRead").getConstValue("SHOOT_GAME_BULLET_LIFE", 50))
	self.collisionNum = 0
end
function Com_Bullet:onShow()
	local parentProxy = uiManager:getProxy("bulletGame")
	if parentProxy then
		local data = parentProxy:getCheatData(8)
		if data and data.restitution > 0 then
			self.density = data.restitution
		end
	end
	self:displayObject():setPhysicsBody(cc.PhysicsBody:createCircle(self.radius, cc.PhysicsMaterial(self.density, self.restitution, self.friction)))
	self:displayObject():getPhysicsBody():getShape(0):setContactTestBitmask(self.contactTestBitmask)
	self:displayObject():getPhysicsBody():getShape(0):setCollisionBitmask(self.collisionBitmask)
	self:displayObject():getPhysicsBody():getShape(0):setCategoryBitmask(self.categoryBitmask)
	self:displayObject():getPhysicsBody():setAngularDamping(self.damping)
	self:displayObject():getPhysicsBody():setLinearDamping(self.damping)
	self:displayObject():getPhysicsBody():setRotationEnable(false)
	self:displayObject():getPhysicsBody():setGravityEnable(false)
	self:displayObject():getPhysicsBody():getShape(0):setTag(self.tag)
end
function Com_Bullet:addCollisionNum()
	self.collisionNum = self.collisionNum + 1
end
function Com_Bullet:isNeedDestory()
	if self.collisionNum >= self.maxNum then
		return true
	end
end
function Com_Bullet:resetItem()
	self.collisionNum = 0
	self:displayObject():getPhysicsBody():resetForces()
	self:displayObject():getPhysicsBody():setVelocity(cc.p(0, 0))
end
return Com_Bullet
