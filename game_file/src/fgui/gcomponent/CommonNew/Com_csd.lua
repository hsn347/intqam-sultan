local baseComponent = require("fgui.base.baseComponent")
local Com_csd = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonNew/Com_csd", Com_csd)
fgui.register_extension("ui://LoginView/Com_csd", Com_csd)
function Com_csd:onInit()
	self._loadedEffect = false
end
function Com_csd:onShow()
	if self.effectPath then
		return
	end
	self.effectPath = self:getCustomData()
	self:updateEffect()
end
function Com_csd:setVisible(value)
	fgui.GObject.setVisible(self, value)
	self:updateEffect()
end
function Com_csd:setEffectPath(path)
	if self.effectPath == path then
		return
	end
	self._loadedEffect = false
	self.effectPath = path
	self:updateEffect()
end
function Com_csd:updateEffect()
	if self._loadedEffect then
		return
	end
	if not self:isVisible() then
		return
	end
	self._loadedEffect = true
	self.fields.Loader3D:clearContent()
	self.effect = nil
	if type(self.effectPath) ~= "string" or string.len(self.effectPath) == 0 then
		print("self.effectPath is empty")
		return
	end
	print("create effectPath", self.effectPath)
	local cssFilePath = getCCSPath(self.effectPath)
	local effect
	if self.controllers.c1:getSelectedIndex() == 1 then
		effect = SoraDCreatePanel(self.effectPath)
		effect:setAnchorPoint(cc.p(0, 0))
		effect:setPosition(0, 0)
	else
		effect = cc.uiloader:load(cssFilePath)
	end
	self.effect = effect
	self.fields.Loader3D:setContent(effect)
end
function Com_csd:getEffect()
	return self.effect
end
return Com_csd
