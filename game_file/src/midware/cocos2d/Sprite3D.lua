local Sprite3D = CS.Sultan.Middleware.Sprite3D
function Sprite3D:create(filePath, callback)
	local ret = Sprite3D()
	ret:loadFromFile(filePath, callback)
	ret:autoRelease()
	return ret
end
function Sprite3D:setCullFaceEnabled()
end
return Sprite3D
