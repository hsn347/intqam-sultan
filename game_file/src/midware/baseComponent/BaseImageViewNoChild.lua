local BaseImageViewNoChild = class("BaseImageViewNoChild", function()
	return fgui.GLoader.CreateSprite(true)
end)
function BaseImageViewNoChild:ctor()
end
function BaseImageViewNoChild:create(texFile, texType)
	local imageView = BaseImageViewNoChild.new()
	imageView.isImageView = true
	imageView:setPosition(0, 0)
	if texFile and texType then
		imageView:loadTexture(texFile, texType)
	end
	return imageView
end
function BaseImageViewNoChild:setFillType(value)
	if value == 1 then
		self:setTile(true)
	else
		error("setFillType must be 1 (tile)")
	end
end
function BaseImageViewNoChild:createWithSpriteFrameName(spriteFrameName)
	local imageView = self:create()
	imageView:setSpriteFrame(spriteFrameName)
	return imageView
end
function BaseImageViewNoChild:createWithSpriteFrame(frame)
	local imageView = self:create()
	imageView:setSpriteFrame(frame.Name)
	return imageView
end
function BaseImageViewNoChild:createWithTexture(texture, rect, rotated)
	local imageView = self:create()
	imageView:setTexture(texture:getName())
	return imageView
end
function BaseImageViewNoChild:getDescription()
	return "ImageViewNoChild"
end
function BaseImageViewNoChild:getVirtualRenderer()
	return self
end
function BaseImageViewNoChild:setSpriteFrame(spriteFrameName)
	self:loadTexture(spriteFrameName, ccui.TextureResType.plistType)
end
function BaseImageViewNoChild:loadTexture(filename, txtType)
	if txtType == ccui.TextureResType.plistType then
		self:setURL(filename)
	else
		self:setTexture(filename)
	end
end
function BaseImageViewNoChild:getGLProgramState()
	return self.material
end
function BaseImageViewNoChild:removeAllChildren()
end
return BaseImageViewNoChild
