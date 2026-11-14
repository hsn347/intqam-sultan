local Shader = _G.CS.UnityEngine.Shader
local ShaderManager = _G.CS.Sultan.Middleware.ShaderManager.getInstance()
local GLProgram = Shader
local _ENV, propertyToID
local getLocation = function(attributeName)
	local id = propertyToID[attributeName]
	if id then
		return id
	end
	id = Shader.PropertyToID(attributeName)
	propertyToID[attributeName] = id
	return id
end
local getAttribLocation = getLocation
local getUniformLocation = getLocation
function GLProgram:getAttribLocation(attributeName)
	return getAttribLocation(attributeName)
end
function GLProgram:getUniform(attributeName)
	local getUniformLocation, uniform
	uniform.name = attributeName
	uniform.location = getUniformLocation(attributeName)
	return uniform
end
local strippath = function(filename)
	return string.match(filename, ".+/([^/]*)%.%w+$")
end
local getCocosShaderName = function(vs, fs)
	local vsname = vs and strippath(vs)
	local fsname = fs and strippath(fs)
	if vs and fs then
		if vsname == fsname then
			return vsname
		end
		return string.format("%s_%s", vsname, fsname)
	end
	return "default"
end
local getShaderByName = function(vs, fs)
	local shaderName = getCocosShaderName(vs, fs)
	local cocosShader = string.format("CocosShader/%s", shaderName)
	local shader = ShaderManager:GetShader(cocosShader)
	if shader then
		return shader
	end
	return ShaderManager:GetShader("CocosShader/default")
end
local getShaderWithByteArrays = function(vShaderByteArray, fShaderByteArray)
	local cocosShader = string.format("CocosShader/%s", vShaderByteArray)
	print(cocosShader, "getShaderWithByteArrays")
	local shader = ShaderManager:GetShader(cocosShader)
	if shader then
		print("shader find", cocosShader)
		return shader
	end
	print("shader not find", cocosShader)
	return ShaderManager:GetShader("CocosShader/default")
end
function GLProgram:createWithByteArrays(vShaderByteArray, fShaderByteArray)
	return getShaderWithByteArrays(vShaderByteArray)
end
function GLProgram:createWithFilenames(vShaderFilename, fShaderFilename, keyword)
	local program = getShaderByName(vShaderFilename, fShaderFilename)
	if keyword and program then
		Shader.EnableKeyword(keyword)
	end
	return program
end
function GLProgram:getFragmentShaderLog()
end
function GLProgram:getVertexShaderLog()
end
function GLProgram:initWithByteArrays(vShaderByteArray, fShaderByteArray)
end
function GLProgram:initWithFilenames(vShaderFilename, fShaderFilename)
end
function GLProgram:use()
end
function GLProgram:reset()
end
function GLProgram:link()
end
function GLProgram:setUniformsForBuiltin(modelView)
end
function GLProgram:updateUniforms()
end
function GLProgram:setUniformLocationWith1i(location, i1)
end
function GLProgram:bindAttribLocation(attributeName, index)
end
return GLProgram
