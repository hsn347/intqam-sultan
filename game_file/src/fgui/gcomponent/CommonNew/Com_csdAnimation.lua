local baseComponent = require("fgui.base.baseComponent")
local Com_csdAnimation = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonNew/Com_csdAnimation", Com_csdAnimation)
fgui.register_extension("ui://LoginView/Com_csdAnimation", Com_csdAnimation)
function Com_csdAnimation:onInit()
	self._loadedEffect = false
	self.fields.Loader3D:setCascadeOpacityEnabled(true)
	self.isLoop = true
end
function Com_csdAnimation:onShow()
	self:updateEffect()
end
function Com_csdAnimation:setVisible(value)
	fgui.GObject.setVisible(self, value)
	self:updateEffect()
end
function Com_csdAnimation:setEffectPath(path, loop)
	if self.effectPath == path then
		return
	end
	if loop ~= nil then
		self.isLoop = loop
	end
	self._loadedEffect = false
	self.effectPath = path
	self:updateEffect()
end
function Com_csdAnimation:setIsLoop(ret)
	self.isLoop = ret
end
function Com_csdAnimation:setIsAutoCull(ret)
	self.isAutoCull = ret
	self:setChildrenAutoCull()
end
function Com_csdAnimation:setChildrenAutoCull()
	if self.isAutoCull == nil then
		return
	end
	if self.effect then
		for k, v in ipairs(self.effect:getChildren()) do
			v:setAutoCull(self.isAutoCull)
		end
	end
end
function Com_csdAnimation:updateEffect()
	if self._loadedEffect then
		return
	end
	if not self:isVisible() then
		return
	end
	self._loadedEffect = true
	self.fields.Loader3D:clearContent()
	self.effect = nil
	self.effectPath = self.effectPath or self:getCustomData()
	if type(self.effectPath) ~= "string" or string.len(self.effectPath) == 0 then
		print("self.effectPath is empty")
		return
	end
	print("create effectPath", self.effectPath)
	local effect = SoraDCreatAnimationEx(self.effectPath, nil, self.isLoop)
	self.effect = effect
	self.fields.Loader3D:setContent(effect)
	self:setChildrenAutoCull()
end
function Com_csdAnimation:clearEffect()
	self._loadedEffect = false
	self.effectPath = nil
	self.fields.Loader3D:clearContent()
	self.effect = nil
end
function Com_csdAnimation:getEffect()
	return self.effect
end
function Com_csdAnimation:playOnce()
	if self.effect then
		self.effect.action:gotoFrameAndPlay(0, self.isLoop)
	end
end
return Com_csdAnimation
