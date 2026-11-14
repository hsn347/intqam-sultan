local Com_particle = fgui.extension_class(fgui.GComponent)
fgui.register_extension("ui://Common/CommonParticle", Com_particle)
fgui.register_extension("ui://LegendaryKing/CommonParticle", Com_particle)
function Com_particle:ctor()
end
function Com_particle:onInit()
end
function Com_particle:onEnter()
	self:onShow()
end
function Com_particle:onShow()
	print("Com_particle:onShow===", self:getName(), self.effectPath, type(self.effectPath), self.particle_blendModel)
	self:updateParticle()
end
function Com_particle:setVisible(value)
	fgui.GObject.setVisible(self, value)
	self:updateParticle()
end
function Com_particle:setParticlePath(path)
	if self.effectPath == path then
		return
	end
	self._loadedEffect = false
	self.effectPath = path
	self:updateParticle()
end
function Com_particle:updateParticle()
	if self._loadedEffect then
		return
	end
	if not self:isVisible() then
		return
	end
	if self.effectPath == nil then
		local effectPath = self:getCustomData()
		local posbegin, posend = string.find(effectPath, "%,%w+$")
		if posbegin and 0 <= posbegin then
			self.particle_blendModel = string.sub(effectPath, posbegin + 1, posend)
		end
		self.effectPath = string.gsub(effectPath, "%,%w+$", "")
	end
	if self.particle ~= nil then
		self.particle:removeFromParent()
		self.particle = nil
	end
	if type(self.effectPath) ~= "string" or string.len(self.effectPath) == 0 then
		print("self.effectPath is empty", self.effectPath, self:getName())
		return
	end
	self._loadedEffect = true
	local particle = cc.ParticleSystemQuad:create(self.effectPath)
	self.particle = particle
	if self.isAutoCull ~= nil then
		self.particle:setAutoCull(self.isAutoCull)
	end
	self.particle:setPosition(0, 0)
	if self.particle.resetSystem then
		particle:resetSystem()
	end
	if self.particle_blendModel and particle.setBlendMode and not tolua.isnull(particle) and self.particle_blendModel ~= "None" then
		particle:setBlendMode(self.particle_blendModel)
	end
	particle:setPositionType(cc.POSITION_TYPE_GROUPED)
	self:addChild(particle)
end
function Com_particle:setBlendFunc(...)
	if self.particle then
		self.particle:setBlendFunc(...)
	end
end
function Com_particle:resetSystem()
	if self.particle then
		self.particle:resetSystem()
	end
end
function Com_particle:stopSystem()
	if self.particle then
		self.particle:stopSystem()
	end
end
function Com_particle:setAutoCull(isCull)
	self.isAutoCull = isCull
	if self.particle then
		self.particle:setAutoCull(isCull)
	end
end
