local baseComponent = require("fgui.base.baseComponent")
local Com_Special = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BulletGame/Com_Special", Com_Special)
function Com_Special:onInit()
	self.tag = 5
	self.effectType = 1
	self.contactTestBitmask = 256
	self.collisionBitmask = 512
	self.categoryBitmask = 1046
	self.damping = 0.0
	self.friction = 1.0
	self.restitution = 0.0
	self.density = 1.0
end
function Com_Special:registerEvent()
	SoraDAddMessage(self, "MESSAGE_BULLET_GAME_EFFECT_UPDATE", handler(self, self.msgEventBack))
end
function Com_Special:onShow()
	self.customData = self:getMyCustomData()
	if self.customData then
		self.effectType = self.customData.effectType
		print("self.effectType", self.effectType)
	end
	local parentProxy = uiManager:getProxy("bulletGame")
	if parentProxy then
		local data = parentProxy:getCheatData(7)
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
function Com_Special:getMyCustomData()
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
function Com_Special:getEffectType()
	return self.effectType
end
function Com_Special:msgEventBack()
end
return Com_Special
