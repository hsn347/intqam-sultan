local Com_particle = fgui.extension_class(fgui.GComponent)
fgui.register_extension("ui://CommonNew/Com_particle", Com_particle)
fgui.register_extension("ui://LoginView/Com_particle", Com_particle)
function Com_particle:ctor()
	self.controllers = fguiHelper.get_controllers(self)
	self:onInit()
end
function Com_particle:onInit()
	self:setIsUsePaintingMode(false)
end
function Com_particle:onEnter()
	self:onShow()
end
function Com_particle:onShow()
	self.effectPath = self:getCustomData()
	self.particle_blendModel = self.blendMode
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
	self:removeAllChildren()
	self.particle = nil
	if type(self.effectPath) ~= "string" or string.len(self.effectPath) == 0 then
		print("self.effectPath is empty", self.effectPath, self:getName())
		return
	end
	self._loadedEffect = true
	print("create particle", self.effectPath)
	local particle = cc.ParticleSystemQuad:create(self.effectPath)
	self.particle = particle
	if self.isAutoCull ~= nil then
		self.particle:setAutoCull(self.isAutoCull)
	end
	self.particle:setPosition(25, 25)
	if self.particle.resetSystem then
		particle:resetSystem()
	end
	if self.controllers.c1 and self.controllers.c1:getSelectedIndex() == 0 then
		particle:setPositionType(cc.POSITION_TYPE_RELATIVE)
	else
		particle:setPositionType(cc.POSITION_TYPE_FREE)
	end
	self:addChild(particle)
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
