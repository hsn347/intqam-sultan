local SCM = require("app.shader.shader")
local testShaderView = class("testShaderView", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("commonTestView")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
local DEFAULT_SCALE = 1.0
function testShaderView:ctor()
	self.meshState, _ENV = nil, nil
	self.isHideCurrentSceneView = true
	self:createUI()
	self.Top_Size_Tile_Image_bg = SoraDGetChildByName(self, "Top_Size_Tile_Image_bg")
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	self.commonFramTitle_title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self:init()
end
function testShaderView:createUI()
	self.objRootNode = display.newNode()
	self.objRootNode:setName("objRootNode")
	self.objRootNode:setPosition(cc.p(320, display.height - 460))
	self.objRootNode:addTo(self, 3)
	self.lightRootNode = display.newNode()
	self.lightRootNode:setName("lightRootNode")
	self.lightRootNode:setPosition(cc.p(320, display.height - 460))
	self.lightRootNode:addTo(self, 3)
	self.touchPanel = ccui.Layout:create()
	self.touchPanel:ignoreAnchorPointForPosition(false)
	self.touchPanel:setAnchorPoint(cc.p(0.5, 0.5))
	self.touchPanel:setContentSize(cc.size(640, 960))
	self.touchPanel:setPosition(cc.p(320, display.height / 2))
	self.touchPanel:setTouchEnabled(true)
	self.touchPanel:setSwallowTouches(false)
	self.touchPanel:addTo(self, 5)
	self.touchPanel:addTouchEventListener(handler(self, self.onLayoutTouch))
	self.editRoot = display.newNode()
	self.editRoot:setName("editRoot")
	self.editRoot:setPosition(cc.p(0, 0))
	self.editRoot:addTo(self, 2)
end
function testShaderView:init()
	if not _G.imgui then
		local _ENV, imgui = _G.imgui, _G.imgui
	end
	if imgui.toggleKeepOnTop then
		imgui.toggleKeepOnTop()
	end
	local frag = SCM.simpleVertexAniByTexFrag
	local vert = SCM.simpleVertexAniByTexVerts
	local meshData = require("app.shader.turnPage_meshData")
	_ENV, _UPVALUE3_ = nil, "app.shader.turnPage_meshData"
	;(nil).attr = "float"
	;(nil).name = "_AnimLen"
	_ENV, (nil).value = nil, 3.1333333
	;(nil).attr = "texture"
	;(nil).name = "_aniTex"
	;(nil).value = "3d/turnPage/turnPage.png"
	_UPVALUE4_, (nil).hasMipmap = nil, false
	_ENV, (nil).texParam, (nil)[1] = nil, nil, gl.LINEAR
	_ENV, (nil).texParam, (nil)[2] = nil, nil, gl.LINEAR
	_ENV, (nil).texParam, (nil)[3] = nil, nil, gl.REPEAT
	_ENV, (nil).texParam, (nil)[4] = nil, nil, gl.REPEAT
	;(nil).attr = "texture"
	;(nil).name = "_mainTex"
	;(nil).value = "3d/turnPage/shuye.png"
	_UPVALUE4_, (nil).hasMipmap = gl.LINEAR, false
	;(nil).texParam, gl.LINEAR[1] = gl.LINEAR, gl.LINEAR
	;(nil).texParam, gl.LINEAR[2] = gl.LINEAR, gl.LINEAR
	;(nil).texParam, gl.LINEAR[3] = gl.LINEAR, gl.REPEAT
	;(nil).texParam, gl.LINEAR[4] = gl.LINEAR, gl.REPEAT
	;("app.shader.turnPage_meshData")[1] = nil
	;("app.shader.turnPage_meshData")[2] = nil
	local ("app.shader.turnPage_meshData")[3], shaderParam = nil, "app.shader.turnPage_meshData"
	_ENV = 0
	;(0).vertBytes = vert
	;(0).fragBytes = frag
	local effectNode = SoraDCreateMeshNode(meshData, cc.size(0, 0), 0, shaderParam)
	effectNode:setName("asdf")
	effectNode:setAnchorPoint(0, 0)
	local scale = 80
	effectNode:setScaleY(scale)
	effectNode:setScaleX(-scale)
	effectNode:setPosition(320, 480)
	if effectNode then
		self:addChild(effectNode, 501)
	end
end
function testShaderView:onLayoutTouch(target, event)
	if event == ccui.TouchEventType.ended then
		self.curYAngle = self.objRootNode:getRotation3D().y
		self.curXAngle = self.objRootNode:getRotation3D().x
		if not self.isMoved then
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = math.abs(touchmovePoint.x - touchBeganPoint.x)
		local degreeY = distance / 320 * 270
		local degreeX = math.abs(touchmovePoint.y - touchBeganPoint.y) / 320 * 270
		if touchmovePoint.x - touchBeganPoint.x < 0 then
			degreeY = -degreeY
		end
		if touchmovePoint.y - touchBeganPoint.y < 0 then
			degreeX = -degreeX
		end
		if math.abs(degreeY) > 1 or math.abs(degreeX) > 1 then
			_ENV = nil
			;(nil).x = self.curXAngle + degreeX
			;(nil).y = self.curYAngle + degreeY
			;(nil).z = 0
			self.objRootNode:setRotation3D(nil)
		end
		if self.state then
			local uniform = self.pageShader:getUniform("theta")
			if uniform then
				self.state:setUniformFloat(uniform.location, distance / 320 * 3.1415926)
				print("theta", distance / 320 * 3.1415926)
			end
		end
		if distance > TOUCH_MOVED_ERROR_VALUE then
			self.isMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.curYAngle = self.objRootNode:getRotation3D().y
		self.curXAngle = self.objRootNode:getRotation3D().x
		self.isMoved = false
	elseif event == ccui.TouchEventType.began then
		if not self.curYAngle then
			self.curYAngle = self.objRootNode:getRotation3D().y
		end
		if not self.curXAngle then
			self.curXAngle = self.objRootNode:getRotation3D().x
		end
		self.isMoved = false
	end
end
function testShaderView:loadObj(cfg)
	local sprite3D = cc.Sprite3D:create(cfg.file)
	if not sprite3D then
		print("load sprite3D error", cfg.file)
		return
	end
	self.cfg = cfg
	if self.cfg.scale then
		sprite3D:setScale(cfg.scale)
	else
		sprite3D:setScale(DEFAULT_SCALE)
	end
	_ENV = DEFAULT_SCALE
	DEFAULT_SCALE.x = 0
	DEFAULT_SCALE.y = self.curYAngle
	DEFAULT_SCALE.z = 0
	self.objRootNode:setRotation3D(DEFAULT_SCALE)
	sprite3D:setPosition(cc.p(cfg.x or 0, -sprite3D:getContentSize().height * 2 + (cfg.y or 0)))
	sprite3D:setCullFaceEnabled(false)
	sprite3D:addTo(self.objRootNode)
	sprite3D:setName("sprite3dNode")
	self.sprite3D = sprite3D
	self.meshes = sprite3D:getMeshes()
	print("meshes num", table.nums(self.meshes))
	for _, mesh in ipairs(self.meshes) do
		local mName = mesh:getName()
		self:setupNormalShader(mesh)
	end
end
function testShaderView:setupNormalShader(mesh)
	mesh:setDepthTestEnabled(true)
	mesh:setDepthWriteEnabled(true)
	if self.meshState.normalState then
		mesh:setGLProgramState(self.meshState.normalState)
	else
		local shaderParam = self.cfg.shaderParam
		local shader = self:getOrCreateShader()
		local normalState = cc.GLProgramState:create(shader)
		self.meshState.normalState = normalState
		mesh:setupVertexInfoForGLProgrameState(self.meshState.normalState)
		self.meshState.normalState:retain()
		_ENV, _UPVALUE6_ = self.meshState.normalState, self.meshState.normalState.retain
		self.meshState.normalState.name = "u_alpha"
		self.meshState.normalState.value = 0.5
		_ENV, self.meshState.normalState.attr = self.meshState.normalState, "float"
		self.meshState.normalState.attr = "vec3"
		_ENV, self.meshState.normalState.name = nil, "u_AmbientLightColor"
		;(nil).x = 0.8
		;(nil).y = 0.8
		_ENV, self.meshState.normalState.value, (nil).z = nil, nil, 0.8
		;(nil).attr = "vec3"
		_ENV, (nil).name = nil, "u_DirLightDirection"
		;(nil).x = -1
		;(nil).y = -1
		_ENV, (nil).value, (nil).z = nil, nil, -1.0
		;(nil).attr = "vec3"
		_ENV, (nil).name = nil, "u_DirLightColor"
		;(nil).x = 0.6
		;(nil).y = 0.6
		_ENV, (nil).value, (nil).z = nil, nil, 0.6
		;(nil).attr = "vec3"
		_ENV, (nil).name = nil, "u_eyePos"
		;(nil).x = 0
		;(nil).y = 0
		_ENV, (nil).value, (nil).z = nil, nil, 1000
		;(nil).attr = "texture"
		;(nil).name = "u_specularTex"
		;(nil).value = self:getSpecularTex(mesh:getTexturePath())
		self.meshState.normalState.retain[1] = self.meshState.normalState
		self.meshState.normalState.retain[2] = self.meshState.normalState
		self.meshState.normalState.retain[3] = nil
		self.meshState.normalState.retain[4] = nil
		self.meshState.normalState.retain[5] = nil
		local self.meshState.normalState.retain[6], shaderParam = nil, self.meshState.normalState.retain
		SoraDSetProgramStateParam(shader, normalState, shaderParam)
	end
end
function testShaderView:getSpecularTex(path)
	local texName = string.gsub(path, "_d.png", "_s.png")
	print(texName)
	return texName
end
function testShaderView:getOrCreateShader()
	return self:getOrCreateSpecularLightShader()
end
function testShaderView:getOrCreateNoLight()
	local shaderName = "SHADER_TYPE_NO_LIGHT"
	local program = cc.GLProgramCache:getInstance():getGLProgram(shaderName)
	if not program then
		program = cc.GLProgram:createWithFilenames("Shaders/3dPositionTex.vsh", "Shaders/3dColorTexAlphaCutout.fsh")
		cc.GLProgramCache:getInstance():addGLProgram(program, "SHADER_TYPE_NO_LIGHT")
	end
	return program
end
function testShaderView:getOrCreateSpecularLightShader()
	local shaderName = "SHADER_TYPE_SPECULAR_LIGHT"
	local program = cc.GLProgramCache:getInstance():getGLProgram(shaderName)
	if not program then
		local macco = "#define USE_SPECULAR_LIGHT"
		local frag = macco .. SCM.simpleLightFragBytes
		local vert = macco .. SCM.simpleLightSkinnedVertBytes
		program = cc.GLProgram:createWithByteArrays(vert, frag)
		cc.GLProgramCache:getInstance():addGLProgram(program, "SHADER_TYPE_SPECULAR_LIGHT")
	end
	return program
end
function testShaderView:getOrCreatePBRShader()
	print("getOrCreatePBRShader")
	local shaderName = "SHADER_TYPE_BRDF_FULL_LIGHT"
	local program = cc.GLProgramCache:getInstance():getGLProgram(shaderName)
	if not program then
		local lightMacros = self:getShaderMacrosForLight()
		local frag = lightMacros .. SCM.fullBRDFLightFragBytes
		local vert = lightMacros .. SCM.fullBRDFLightVertBytes
		program = cc.GLProgram:createWithByteArrays(vert, frag)
		cc.GLProgramCache:getInstance():addGLProgram(program, "SHADER_TYPE_BRDF_FULL_LIGHT")
	end
	return program
end
function testShaderView:getOrCreateUnityBRDFShader()
	print("getOrCreateUnityBRDFShader")
	local USC = require("app.shader.unityBRDFshader")
	local shaderName = "SHADER_TYPE_UNITY_BRDF_LIGHT"
	local program = cc.GLProgramCache:getInstance():getGLProgram(shaderName)
	if not program then
		local lightMacros = self:getShaderMacrosForLight()
		local frag = lightMacros .. USC.fullBRDFLightFragBytes
		local vert = lightMacros .. USC.fullBRDFLightVertBytes
		program = cc.GLProgram:createWithByteArrays(vert, frag)
		cc.GLProgramCache:getInstance():addGLProgram(program, "SHADER_TYPE_UNITY_BRDF_LIGHT")
	end
	return program
end
function testShaderView:getOrCreateUnityBRDFSampleShader()
	print("getOrCreateUnityBRDFShader")
	local USC = require("app.shader.unityBRDFshader")
	local shaderName = "SHADER_TYPE_UNITY_BRDF_LIGHT"
	local program = cc.GLProgramCache:getInstance():getGLProgram(shaderName)
	if not program then
		local lightMacros = ""
		local frag = lightMacros .. USC.sampleBRDFLightFragBytes
		local vert = lightMacros .. USC.sampleBRDFLightVertBytes
		program = cc.GLProgram:createWithByteArrays(vert, frag)
		cc.GLProgramCache:getInstance():addGLProgram(program, "SHADER_TYPE_UNITY_BRDF_LIGHT")
	end
	return program
end
function testShaderView:createPageTurn()
	local shaderName = "SHADER_TYPE_VERTS_PAGE_TURN"
	local program = cc.GLProgramCache:getInstance():getGLProgram(shaderName)
	if not program then
		local lightMacros = ""
		local frag = lightMacros .. SCM.simplePageTurnFrag
		local vert = lightMacros .. SCM.simplePageTurnVerts
		program = cc.GLProgram:createWithByteArrays(vert, frag)
		cc.GLProgramCache:getInstance():addGLProgram(program, "SHADER_TYPE_VERTS_PAGE_TURN")
	end
	return program
end
function testShaderView:createPageTurnVertAni()
	local shaderName = "SHADER_TYPE_VERTS_TEXANI_PAGE_TURN"
	local program = cc.GLProgramCache:getInstance():getGLProgram(shaderName)
	if not program then
		local lightMacros = ""
		local frag = lightMacros .. SCM.simpleVertexAniByTexFrag
		local vert = lightMacros .. SCM.simpleVertexAniByTexVerts
		program = cc.GLProgram:createWithByteArrays(vert, frag)
		cc.GLProgramCache:getInstance():addGLProgram(program, "SHADER_TYPE_VERTS_TEXANI_PAGE_TURN")
	end
	return program
end
function testShaderView:getShaderMacrosForLight()
	return string.format([[

#define MAX_DIRECTIONAL_LIGHT_NUM %d 
#define MAX_POINT_LIGHT_NUM %d 
#define MAX_SPOT_LIGHT_NUM %d 
]], 1, 1, 1)
end
return testShaderView
