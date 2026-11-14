local prefabDef = include("prefabDef")
local baseComponent = require("fgui.base.baseComponent")
local Com_prefabEX = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonNew/Com_prefabEX", Com_prefabEX)
function Com_prefabEX:onInit()
	self._loadedEffect = false
end
function Com_prefabEX:onShow()
	self:setEffectPath(self:getCustomData())
end
function Com_prefabEX:onHide()
	self:clearEffect()
end
function Com_prefabEX:setEffectPath(path)
	print("Com_prefabEX:setEffectPath", path)
	if type(path) ~= "string" or string.len(path) == 0 then
		return
	end
	path = prefabDef.getPrefabPath(path)
	if self.effectPath == path and self.effectPath ~= nil then
		return
	end
	self:clearEffect()
	self.effectPath = path
	self.effect = cc.Prefab:Create()
	self.effect:loadFromFile(self.effectPath)
	self.effect:setPosition(cc.p(self:getWidth() / 2, self:getHeight() / 2))
	self.effect:setZ(-1)
	self:addChild(self.effect)
end
function Com_prefabEX:clearEffect()
	if self.effect then
		self.effect:removeFromParent()
		self.effect = nil
	end
	self.effectPath = nil
	self._loadedEffect = false
end
function Com_prefabEX:setSprite(objectName, spriteName)
	if not self.effect then
		return
	end
	spriteName = string.gsub(spriteName, ".png", "")
	self.effect:setSprite(objectName, spriteName)
end
return Com_prefabEX
