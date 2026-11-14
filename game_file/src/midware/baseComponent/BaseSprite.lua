local BaseImageView = require("midware.baseComponent.BaseImageView")
local BaseSpriteNoChild = require("midware.baseComponent.BaseSpriteNoChild")
local BaseSprite = class("BaseSprite", function(target)
	return target or fgui.GSprite.CreateSprite(false)
end, BaseImageView)
function BaseSprite:create(file_path, rect, nochild)
	local sprite
	if nochild then
		sprite = BaseSpriteNoChild.new()
		sprite:ignoreContentAdaptWithSize(true)
	else
		sprite = BaseSprite.new()
		sprite:ignoreContentAdaptWithSize(false)
	end
	sprite:setPosition(0, 0)
	if file_path then
		sprite:setTexture(file_path)
	end
	if rect then
		sprite:setRect(rect)
	end
	return sprite
end
function BaseSprite:createWithSpriteFrame(file_path, rect, nochild)
	local sprite
	if nochild then
		sprite = BaseSpriteNoChild.new()
		sprite:ignoreContentAdaptWithSize(true)
	else
		sprite = BaseSprite.new()
		sprite:ignoreContentAdaptWithSize(false)
	end
	sprite:setPosition(0, 0)
	if file_path then
		sprite:setSpriteFrame(file_path)
	end
	if rect then
		sprite:setScale9Enabled(true)
		sprite:setCapInsets(rect)
	end
	return sprite
end
BaseSprite.createWithTexture = BaseSprite.create
function BaseSprite:ctor()
	self.__icon = self:getChild("icon")
	self.IconObject = self.__icon
end
function BaseSprite:getDescription()
	return "Sprite"
end
function BaseSprite:setTexture(...)
	self.IconObject:setTexture(...)
	self:imageViewAutoSize()
end
function BaseSprite:setSpriteFrame(...)
	self.IconObject:setSpriteFrame(...)
	self:imageViewAutoSize()
end
function BaseSprite:setRect(...)
	self:setContentSize(...)
end
function BaseSprite:setTile(tile)
	self.IconObject:setTile(tile)
end
function BaseSprite:isFlippedX()
	return self.IconObject:isFlippedX()
end
function BaseSprite:isFlippedY()
	return self.IconObject:isFlippedY()
end
function BaseSprite:getSprite()
	return self
end
function BaseSprite:setTexture2D(texture2D)
	self.IconObject:setTexture2D(texture2D)
end
function BaseSprite:addTextureRef(tex)
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
function BaseSprite:onExit()
	if self._textures then
		for _, tex in ipairs(self._textures) do
			if tex then
				tex:removeRefenrence()
			end
		end
		self._textures = nil
	end
end
local _clone = fgui.GSprite.clone
function BaseSprite:clone()
	local ret = _clone(self)
	return BaseSprite.new(ret)
end
return BaseSprite
