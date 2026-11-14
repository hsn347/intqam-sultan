local BaseImageView = class("BaseSprite", function()
	return fgui.GSprite.CreateSprite(true)
end)
function BaseImageView:ctor()
	self.__icon = self:getChild("icon")
end
function BaseImageView:create(texFile, texType)
	local imageView = BaseImageView.new()
	imageView.isImageView = true
	imageView:setPosition(0, 0)
	if texFile and texType then
		imageView:loadTexture(texFile, texType)
	end
	return imageView
end
function BaseImageView:setFillType(value)
	if value == 1 then
		self:setTile(true)
	else
		error("setFillType must be 1 (tile)")
	end
end
function BaseImageView:createWithSpriteFrameName(spriteFrameName)
	local imageView = self:create()
	imageView:setSpriteFrame(spriteFrameName)
	return imageView
end
function BaseImageView:createWithSpriteFrame(frame)
	local imageView = self:create()
	imageView:setSpriteFrame(frame.Name)
	return imageView
end
function BaseImageView:createWithTexture(texture, rect, rotated)
	local imageView = self:create()
	imageView:setTexture(texture:getName())
	return imageView
end
function BaseImageView:getDescription()
	return "ImageView"
end
function BaseImageView:getOffsetPosition()
	return self.__icon:getOffsetPosition()
end
function BaseImageView:getSpriteFrame()
	return self.__icon:getSpriteFrame()
end
function BaseImageView:getTexture()
	return self.__icon:getTexture()
end
function BaseImageView:getTextureRect()
	return self.__icon:getTextureRect()
end
function BaseImageView:getVirtualRenderer()
	return self.__icon
end
function BaseImageView:getVirtualRendererSize()
	return self.__icon:getVirtualRendererSize()
end
function BaseImageView:init()
	return self.__icon:init()
end
function BaseImageView:isOpacityModifyRGB()
	return self.__icon:isOpacityModifyRGB()
end
function BaseImageView:setGLProgramState(glProgramState)
	return self.__icon:setGLProgramState(glProgramState)
end
function BaseImageView:setOpacityModifyRGB(modify)
	return self.__icon:setOpacityModifyRGB(modify)
end
function BaseImageView:setPositionZ(positionZ)
	return self.__icon:setPositionZ(positionZ)
end
function BaseImageView:setSpriteFrame(spriteFrameName)
	self:loadTexture(spriteFrameName, ccui.TextureResType.plistType)
end
function BaseImageView:loadTexture(filename, txtType)
	if txtType == ccui.TextureResType.plistType then
		self:setURL(filename)
	else
		self:setTexture(filename)
	end
end
function BaseImageView:setColor(...)
	return self.__icon:setColor(...)
end
function BaseImageView:setPreciseTouchEnabled(...)
	return self.__icon:setPreciseTouchEnabled(...)
end
function BaseImageView:getGLProgramState()
	if self.IconObject then
		return self.IconObject.material
	end
end
function BaseImageView:setAllFrames(...)
	if self.IconObject then
		return self.IconObject:setAllFrames(...)
	end
end
return BaseImageView
