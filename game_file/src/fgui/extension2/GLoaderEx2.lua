local m = fgui.GLoader
function m:getDescription()
	return "GLoader"
end
function m:getOffsetPosition()
	return cc.p(0, 0)
end
function m:getTexture()
	return self.texture
end
function m:getTextureRect()
	return cc.rect(0, 0, self:getWidth(), self:getHeight())
end
function m:init()
	print_error("不知道干嘛GLoader:init")
end
function m:isOpacityModifyRGB()
	return self.__isOpacityModifyRGB
end
function m:setGLProgramState(glProgramState)
	self.material = glProgramState
end
function m:getGLProgramState()
	return self.material
end
function m:setOpacityModifyRGB(modify)
	self.__isOpacityModifyRGB = modify
end
function m:setPositionZ(positionZ)
	child.z = positionZ
end
function m:loadTexture(filename, txtType)
	if txtType == ccui.TextureResType.plistType then
		self:setURL(filename)
	else
		self:setTexture(filename)
	end
end
local setSpriteFrame_old = tolua.getcfunction(m, "setSpriteFrame")
function m:setSpriteFrame(filename, ignoreSize)
	if filename == nil then
		self:setURL(nil)
		return
	end
	setSpriteFrame_old(self, filename)
	if ignoreSize then
	end
end
function m:getTexture()
	_UPVALUE0_ = nil
	;(nil).hasMipmaps = function()
		return false
	end
	;(nil).setTexParameters = function()
	end
	;(nil).getAlphaTexture = function()
	end
	return nil
end
function m:setPreciseTouchEnabled(value)
	print_warn("暂不处理 ImageView:setPreciseTouchEnabled")
end
function m:setFillType(value)
	if value == 1 then
		self:setTile(true)
	else
		error("setFillType except 1, got " .. value)
	end
end
