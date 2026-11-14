local MeshNode = fgui.MeshNodeEx
function MeshNode:create()
	local node = MeshNode()
	node:setPosition(0, 0)
	node:autoRelease()
	return node
end
function MeshNode:getDesciption()
	return "MeshNode"
end
function MeshNode:setIs3D(is3D)
	local meshNode = self.meshNode
	if meshNode then
		meshNode:setIs3D(is3D)
	end
end
local createMatrixFromCocos = function(mat)
	local vector4 = _G.CS.UnityEngine.Vector4
	local v1 = vector4(mat[1], mat[2], mat[3], mat[4])
	local v2 = vector4(mat[5], mat[6], mat[7], mat[8])
	local v3 = vector4(mat[9], mat[10], mat[11], mat[12])
	local v4 = vector4(mat[13], mat[14], mat[15], mat[16])
	local matUnity = _G.CS.UnityEngine.Matrix4x4(v1, v2, v3, v4)
	return matUnity
end
function MeshNode:setAdditionalTransform(mat)
	local material = self.meshNode.material
	if material then
		local matUnity = createMatrixFromCocos(mat)
		material:setUniformMat4("_AddMatrix", matUnity)
	end
end
function MeshNode:setDepthTest(isDepthTest)
	local meshNode = self.meshNode
	if meshNode then
		meshNode:setDepthTest(isDepthTest)
	end
end
function MeshNode:setDepthWrite(isDepthWrite)
	local meshNode = self.meshNode
	if meshNode then
		meshNode:setDepthWrite(isDepthWrite)
	end
end
function MeshNode:setMeshData(positions, colors, texs, indices, normals)
	local meshNode = self.meshNode
	if meshNode then
		meshNode:setMeshData(positions, colors, texs, indices, normals)
	end
end
function MeshNode:setBlendFunc(src, dst)
	local meshNode = self.meshNode
	if meshNode then
		meshNode:setBlendFunc(src, dst)
	end
end
function MeshNode:getBlendFunc()
	local meshNode = self.meshNode
	if meshNode then
		return meshNode:getBlendFunc()
	end
end
function MeshNode:setDrawType(drawType)
end
function MeshNode:setTexture(texture2D)
	local meshNode = self.meshNode
	if meshNode then
		meshNode:setTexture(texture2D)
	end
end
function MeshNode:getTexture()
	local meshNode = self.meshNode
	if meshNode then
		return meshNode:getTexture()
	end
end
function MeshNode:setAutoCull(bCull)
end
function MeshNode:setBounds(rect, centerPos)
	local meshNode = self.meshNode
	if meshNode then
		meshNode:setBounds(cc.p(rect.x, rect.y), cc.p(rect.width, rect.height), centerPos)
	end
end
function MeshNode:setDrawDebug(bValue)
	local meshNode = self.meshNode
	if meshNode then
		meshNode:setDrawDebug(bValue)
	end
end
function MeshNode:setGLProgramState(glProgramState)
	self:setGLMaterial(glProgramState)
end
function MeshNode:getGLProgramState()
	local meshNode = self.meshNode
	if meshNode then
		return meshNode.material
	end
end
function MeshNode:addTextureRef(tex)
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
function MeshNode:onExit()
	if self._textures then
		for _, tex in ipairs(self._textures) do
			if tex then
				tex:removeRefenrence()
			end
		end
		self._textures = nil
	end
end
return MeshNode
