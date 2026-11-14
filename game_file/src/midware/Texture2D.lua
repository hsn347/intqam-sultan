local Texture2D = CS.Sultan.Middleware.Texture2D
function Texture2D:getContentSize()
	local nativeTex = self:getNativeTexture2D()
	if nativeTex then
		return cc.size(nativeTex.width, nativeTex.height)
	end
end
function Texture2D:setTexParameters()
end
return Texture2D
