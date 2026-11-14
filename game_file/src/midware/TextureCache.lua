local TextureCache = CS.Sultan.Middleware.TextureCache
local addImage_old = tolua.getcfunction(TextureCache, "addImage")
function TextureCache:addImage(filePath)
	local texFilePath = "Textures/" .. filePath
	local tex = addImage_old(self, texFilePath)
	if tex then
		return tex
	end
	return addImage_old(self, filePath)
end
return TextureCache
