local baseComponent = require("fgui.base.baseComponent")
local Com_Surface = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BulletGame/Com_Surface", Com_Surface)
function Com_Surface:onInit()
	self.tag = 4
	self.contactTestBitmask = 1
	self.collisionBitmask = 2
	self.damping = 0.0
	self.friction = 0.0
	self.restitution = 1.0
	self.density = 0
	self.speed = 100
end
function Com_Surface:onShow()
	local rotation = self:getRotation()
	self:setRotation(0)
	local parentProxy = uiManager:getProxy("bulletGame")
	if parentProxy then
		local data = parentProxy:getCheatData(3)
		if data then
			self.damping = data.damping
			self.friction = data.friction
			self.restitution = data.restitution
			self.density = data.density
		end
	end
	self.customData = self:getMyCustomData()
	if self.customData then
		if self.customData.verts then
			local _ENV, points = self.customData.verts, self.customData.verts
			for i, v in ipairs(self.customData.verts) do
				table.insert(points, cc.p(v[1], v[2]))
			end
			self:displayObject():setPhysicsBody(cc.PhysicsBody:createPolygon(points, cc.PhysicsMaterial(self.density, self.restitution, self.friction)))
		else
			self:displayObject():setPhysicsBody(cc.PhysicsBody:createBox(self:getContentSize()))
		end
	else
		self:displayObject():setPhysicsBody(cc.PhysicsBody:createBox(self:getContentSize()))
	end
	self:displayObject():getPhysicsBody():getShape(0):setContactTestBitmask(self.contactTestBitmask)
	self:displayObject():getPhysicsBody():getShape(0):setCollisionBitmask(self.collisionBitmask)
	self:displayObject():getPhysicsBody():setDynamic(false)
	self:displayObject():getPhysicsBody():getShape(0):setTag(self.tag)
	if self.customData then
		local time = self.customData.time or 2
		if self.customData.moveOffset then
			local posOffset = cc.p(self.customData.moveOffset[1], self.customData.moveOffset[2])
			_UPVALUE3_ = cc.PhysicsBody:createBox(self:getContentSize())
			cc.PhysicsBody:createBox(self:getContentSize())[1] = ffa.callFunc(function()
				self:displayObject():getPhysicsBody():setVelocity(posOffset)
			end)
			cc.PhysicsBody:createBox(self:getContentSize())[2] = ffa.delay(time)
			cc.PhysicsBody:createBox(self:getContentSize())[3] = ffa.callFunc(function()
				self:displayObject():getPhysicsBody():setVelocity(cc.pMul(posOffset, -1))
			end)
			cc.PhysicsBody:createBox(self:getContentSize())[4] = ffa.delay(time)
			cc.PhysicsBody:createBox(self:getContentSize())[5] = ffa.delay(time)
			self:runAction(ffa.repeatForever(ffa.seq(cc.PhysicsBody:createBox(self:getContentSize()))))
		elseif self.customData.moveTo then
			local posOffset = cc.p(self.customData.moveTo[1], self.customData.moveTo[2])
			self:runAction(ffa.repeatForever(ffa.seq(ffa.callFunc(function()
				self:displayObject():getPhysicsBody():setVelocity(posOffset)
			end))))
		end
	end
	self:setRotation(rotation)
end
function Com_Surface:getMyCustomData()
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
return Com_Surface
