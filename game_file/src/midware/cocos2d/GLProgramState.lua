local Material = _G.CS.UnityEngine.Material
local GLProgramState = Material
function GLProgramState:setUniformTexture(uniformName, textureId)
	self:SetTexture(uniformName, textureId)
end
function GLProgramState:setUniformMat4(uniformName, value)
	self:SetMatrix(uniformName, value)
end
function GLProgramState:setUniformInt(uniformName, value)
	self:SetInt(uniformName, value)
end
function GLProgramState:setUniformFloat(uniformName, value)
	self:SetFloat(uniformName, value)
end
function GLProgramState:setUniformVec2(uniformName, value)
	self:SetVector(uniformName, value)
end
function GLProgramState:setUniformVec3(uniformName, value)
	self:SetVector(uniformName, value)
end
function GLProgramState:setUniformVec4(uniformName, value)
	self:SetVector(uniformName, value)
end
function GLProgramState:setUniformFloatv(uniformName, size, value)
	self:SetFloatArray(uniformName, value)
end
function GLProgramState:setUniformVec2v(uniformName, value)
	self:SetVectorArray(uniformName, value)
end
function GLProgramState:setUniformVec3v(uniformName, value)
	self:SetVectorArray(uniformName, value)
end
function GLProgramState:setUniformVec4v(uniformName, value)
	self:SetVectorArray(uniformName, value)
end
function GLProgramState:setUniformMat4(uniformName, value)
	self:SetMatrix(uniformName, value)
end
function GLProgramState:getGLProgram()
	return self.shader
end
function GLProgramState:setGLProgram(glprogram)
	self.shader = glprogram
end
function GLProgramState:create(glprogram)
	if glprogram then
		return Material(glprogram)
	end
end
function GLProgramState:getOrCreateWithGLProgramName(glProgramName)
	local glprogram = cc.GLProgram:getGLProgram(glProgramName)
	if glprogram then
		self:getOrCreateWithGLProgram(glprogram)
	end
end
local _ENV, _programStateCache = function(self, glProgramName)
	local glprogram = cc.GLProgram:getGLProgram(glProgramName)
	if glprogram then
		self:getOrCreateWithGLProgram(glprogram)
	end
end, function(self, glProgramName)
	local glprogram = cc.GLProgram:getGLProgram(glProgramName)
	if glprogram then
		self:getOrCreateWithGLProgram(glprogram)
	end
end
function GLProgramState:getOrCreateWithGLProgram(glprogram)
	local state = _programStateCache[glprogram]
	if state then
		return state
	end
	state = self:create(glprogram)
	if state then
		_programStateCache[glprogram] = state
	end
	return state
end
local _ENV, _programStateCacheByKey = function(self, glprogram)
	local state = _programStateCache[glprogram]
	if state then
		return state
	end
	state = self:create(glprogram)
	if state then
		_programStateCache[glprogram] = state
	end
	return state
end, function(self, glprogram)
	local state = _programStateCache[glprogram]
	if state then
		return state
	end
	state = self:create(glprogram)
	if state then
		_programStateCache[glprogram] = state
	end
	return state
end
function GLProgramState:getOrCreateWithGLProgramByKey(glprogram, key)
	if not key then
		return self:getOrCreateWithGLProgram(glprogram)
	end
	local state = _programStateCacheByKey[key]
	if state then
		return state
	end
	state = self:create(glprogram)
	if state then
		_programStateCacheByKey[key] = state
	end
	return state
end
function GLProgramState:getUniformCount()
	return 0
end
function GLProgramState:applyUniforms()
end
function GLProgramState:applyGLProgram(modelView)
end
function GLProgramState:applyAttributes()
end
function GLProgramState:getVertexAttribCount()
end
function GLProgramState:getVertexAttribsFlags()
end
function GLProgramState:apply(modelView)
end
return GLProgramState
