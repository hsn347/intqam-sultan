local BaseView = require("midware.baseComponent.BaseImageViewNoChild")
local BaseSpriteNoChild = class("BaseSpriteNoChild", function(target)
	return target or fgui.GLoader.CreateSprite(false)
end, BaseView)
function BaseSpriteNoChild:ctor()
end
function BaseSpriteNoChild:getDescription()
	return "SpriteNoChild"
end
function BaseSpriteNoChild:setRect(...)
	self:ignoreContentAdaptWithSize(false)
	self:setContentSize(...)
end
function BaseSpriteNoChild:getSprite()
	return self
end
function BaseSpriteNoChild:addTextureRef(tex)
	if not tex then
		return
	end
	if not self._textures then
		self._textures, _UPVALUE0_ = self._textures, self._textures
		self:setNodeEventEnabled(true)
	end
	self._textures[#self._textures + 1] = tex
	tex:addRefenrence()
end
function BaseSpriteNoChild:onExit()
	if self._textures then
		for _, tex in ipairs(self._textures) do
			if tex then
				tex:removeRefenrence()
			end
		end
		self._textures = nil
	end
end
local _clone = fgui.GLoader.clone
function BaseSpriteNoChild:clone()
	local ret = _clone(self)
	return BaseSpriteNoChild.new(ret)
end
return BaseSpriteNoChild
