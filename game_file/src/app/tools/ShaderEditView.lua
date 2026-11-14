local ShaderEditView = class("ShaderEditView", function(target)
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
_ENV = "ShaderEditView"
local ("ShaderEditView").texture, attr2Edit = ShaderEditView.textureAttrEdit, "ShaderEditView"
function ShaderEditView:ctor()
	self.isHideCurrentSceneView = true
	self:createUI()
	self.Top_Size_Tile_Image_bg = SoraDGetChildByName(self, "Top_Size_Tile_Image_bg")
	self.Top_Node = SoraDGetChildByName(self, "Top_Node")
	self.commonFramTitle_title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self:init()
end
function ShaderEditView:createUI()
	self.effectRoot = display.newNode()
	self.effectRoot:setName("effectRoot")
	self.effectRoot:setPosition(cc.p(320, display.height - 260))
	self.effectRoot:addTo(self, 3)
	self.editRoot = display.newNode()
	self.editRoot:setName("editRoot")
	self.editRoot:setPosition(cc.p(0, 0))
	self.editRoot:addTo(self, 2)
	self.csNode = SoraDCreateCSBNode("cfgSelectNode")
	self.selectBtn = SoraDGetChildByName(self.csNode, "selectBtn")
	self.selectBtn:setTitleText("选择shader配置")
	self.selectBtn:addTouchEventListener(function(button, eventType)
		if eventType == ccui.TouchEventType.ended then
			local isShow = self.cfgListNode:isVisible()
			self.cfgListNode:setVisible(not isShow)
		end
	end)
	self.cfgListNode = SoraDGetChildByName(self.csNode, "cfgList")
	self.cfgListNode:setVisible(false)
	self.csNode:setPosition(320, display.height - 120)
	self.csNode:addTo(self, 4)
end
function ShaderEditView:init()
	self:loadCfgList()
end
function ShaderEditView:loadCfgFromList(index)
	local cfg = self.cfgList[index]
	if cfg then
		return require(cfg.path)
	end
end
function ShaderEditView:loadCfgList()
	local lfs = require("lfs")
	local dirPath = "app/shader/testShaderCfg.lua"
	local fullPath = cc.FileUtils:getInstance():fullPathForFilename(dirPath)
	local fullDir = string.sub(fullPath, 0, -18)
	local _ENV, cfgList = fullPath, fullPath
	for file in lfs.dir(fullDir) do
		local fPath = string.format("%s%s/%s_shaderCfg.lua", fullDir, file, file)
		print(fPath)
		if cc.FileUtils:getInstance():isFileExist(fPath) then
			_ENV = cc.FileUtils:getInstance():isFileExist(fPath)
			cc.FileUtils:getInstance():isFileExist(fPath).name = file
			local cc.FileUtils:getInstance():isFileExist(fPath).path, tm = string.format("app.shader.%s.%s_shaderCfg.lua", file, file), cc.FileUtils:getInstance():isFileExist(fPath)
			table.insert(cfgList, tm)
		end
	end
	self.cfgList = cfgList
	self.cfgListNode:removeAllChildren()
	local tmpBtn = SoraDGetChildByName(self.csNode, "btnTemplate")
	for k, v in ipairs(self.cfgList) do
		local tmp = tmpBtn:clone()
		tmp:setSwallowTouches(false)
		tmp:setTitleText(v.name)
		tmp:addTouchEventListener(handlerEx(self, self.selectShaderCfg, k))
		tmp:setPosition(150, k * 40 - 20)
		tmp:setVisible(true)
		tmp:addTo(self.cfgListNode)
	end
	tmpBtn:setVisible(false)
	self.cfgListNode:setInnerContainerSize(cc.size(300, #self.cfgList * 40))
end
function ShaderEditView:selectShaderCfg(index, button, eventType)
	if eventType == ccui.TouchEventType.ended then
		local info = self.cfgList[index]
		self.selectBtn:setTitleText(info.name)
		self.cfgListNode:setVisible(false)
		local cfg = require(info.path)
		self:loadEffect(cfg)
	end
end
function ShaderEditView:loadEffect(cfg)
	self.effectRoot:removeAllChildren()
	self.editRoot:removeAllChildren()
	self.cfg = clone(cfg)
	self:loadShader(self.cfg)
	self:createAttrEdit(self.cfg)
end
function ShaderEditView:loadShader(cfg)
	local _shader = require(cfg.shader)
	local _meshData = require(cfg.meshData)
	local _param = require(cfg.param)
	local effectNode, shader, state = SoraDCreateMeshNode(_meshData, cc.size(1, 1), _shader, _param.param)
	self.programState = state
	self.program = shader
	effectNode:setScale(unpack(cfg.scale))
	effectNode:setVisible(true)
	effectNode:addTo(self.effectRoot, 1)
	if cfg.rotation then
		effectNode:setRotation3D(cc.vec3(unpack(cfg.rotation)))
	end
	if cfg.rotation2D then
		effectNode:setRotation(cfg.rotation2D)
	end
	if cfg.scaleZ then
		effectNode:setScaleZ(cfg.scaleZ)
	end
	if cfg.notAutoCull then
		effectNode:setAutoCull(false)
	end
	if cfg.showRect then
		local drawNode = cc.DrawNode:create()
		drawNode:setPosition(0, 0)
		drawNode:drawRect(cc.p(_meshData.bounds.minPos[1], _meshData.bounds.minPos[2]), cc.p(_meshData.bounds.maxPos[1], _meshData.bounds.maxPos[2]), cc.c4f(1, 0, 1, 1))
		drawNode:addTo(effectNode)
		drawNode:setLocalZOrder(4)
		drawNode:setName("effectNodeSize")
	end
	self.effectNode = effectNode
end
function ShaderEditView:createAttrEdit(cfg)
	local _param = require(cfg.param)
	self.editParam = clone(_param.param)
	self.scrollView = ccui.ScrollView:create()
	self.scrollView:setContentSize(cc.size(640, 500))
	self.scrollView:setBounceEnabled(true)
	self.scrollView:setDirection(cc.ui.UIScrollView.DIRECTION_VERTICAL)
	self.scrollView:setPosition(cc.p(0, 0))
	local vTotalHeight = 0
	local vTotalWidth = 588
	for k, v in ipairs(self.editParam) do
		local subNode, subHeight = self:createSubAttrEdit(v)
		if subNode then
			subNode:setPosition(cc.p(vTotalWidth / 2, vTotalHeight))
			subNode:addTo(self.scrollView)
			vTotalHeight = vTotalHeight + subHeight
		end
	end
	local rootEdit = self:createRootEdit(cfg)
	rootEdit:setPosition(cc.p(vTotalWidth / 2, vTotalHeight))
	rootEdit:addTo(self.scrollView)
	vTotalHeight = vTotalHeight + 186
	self.scrollView:setInnerContainerSize(cc.size(vTotalWidth, vTotalHeight))
	self.scrollView:addTo(self.editRoot, 3)
end
function ShaderEditView:createSubAttrEdit(attrInfo)
	if not attrInfo then
		return
	end
	if attrInfo.attr == "texture" then
		return self:textureAttrEdit(attrInfo), 206
	elseif attrInfo.attr == "float" then
		return self:valueAttrEdit(attrInfo), 156
	elseif attrInfo.attr == "vec2" or attrInfo.attr == "vec3" then
		return self:vecAttrEdit(attrInfo), 106
	elseif attrInfo.attr == "vec4" and string.sub(attrInfo.name, -3) ~= "_ST" then
		return self:vecAttrEdit(attrInfo), 106
	elseif attrInfo.attr == "#texture" then
		return self:reTextureAttrEdit(attrInfo), 0
	elseif attrInfo.attr == "timeuv" then
		return self:timeuiAttrEdit(attrInfo), 106
	end
end
function ShaderEditView:updateAttrInfo(v)
	if not self.programState then
		return
	end
	local programState = self.programState
	local program = self.program
	if v.attr == "texture" then
		local sharedTextureCache = cc.Director:getInstance():getTextureCache()
		local texture = sharedTextureCache:addImage(v.value)
		texture:setHold(true)
		if v.hasMipmap and not texture:hasMipmaps() then
			texture:generateMipmap()
		end
		programState:setUniformTexture(v.name, texture)
		if v.texParam then
			local size = texture:getContentSize()
			if size.height == size.width and bit.band(size.height, size.height - 1) == 0 then
				texture:setTexParameters(v.texParam[1], v.texParam[2], v.texParam[3], v.texParam[4])
				print("需要平铺--------", v.name)
			end
		end
	elseif v.attr == "#texture" then
		if v.hasMipmap and not v.value:hasMipmaps() then
			v.value:generateMipmap()
		end
		programState:setUniformTexture(v.name, v.value)
	elseif v.attr == "float" then
		local uniform = program:getUniform(v.name)
		if uniform then
			programState:setUniformFloat(uniform.location, v.value)
		end
	elseif v.attr == "vec2" then
		local uniform = program:getUniform(v.name)
		if uniform then
			programState:setUniformVec2(uniform.location, v.value)
		end
	elseif v.attr == "vec3" then
		local uniform = program:getUniform(v.name)
		if uniform then
			programState:setUniformVec3(uniform.location, v.value)
		end
	elseif v.attr == "vec4" then
		local uniform = program:getUniform(v.name)
		if uniform then
			programState:setUniformVec4(uniform.location, v.value)
		else
			print("Error!  vec4 set failed!", v.name)
		end
	elseif v.attr == "function" then
		if program:getUniform(v.name) then
			programState[v.value.setFun](programState, program:getUniform(v.name).location, v.value.paramFun())
		end
	elseif v.attr == "timeuv" and programState.setUniformTimeAnimation then
		programState:setUniformTimeAnimation(v.name, v.value.kU or va.value.ku, v.value.kV or v.value.kv)
	end
end
function ShaderEditView:getTextureSTInfo(texName)
	local texSTName = texName .. "_ST"
	for _, v in ipairs(self.editParam) do
		if v.name == texSTName then
			return v
		end
	end
end
function ShaderEditView:createRootEdit(cfg)
	local rootNode = SoraDCreateCSBNode("baseAttrNode")
	SoraDGetChildByName(rootNode, "name"):setString("shader节点属性")
	dump(cfg)
	local funcPos = function(k, eventType, target)
		local v = target:getText()
		if v ~= nil then
			cfg.position[k] = tonumber(v) or 0
		end
		self.effectNode:setPosition(cc.p(unpack(cfg.position)))
	end
	SoraDGetChildByName(rootNode, "pos_name"):setString("position")
	local posX = SoraDGetChildByName(rootNode, "posX")
	_ENV = nil
	;(nil).func = handlerEx(1, funcPos)
	;(nil).text = tostring(cfg.position[1] or 0)
	SoraDChangeToEditBox(posX, nil)
	local posY = SoraDGetChildByName(rootNode, "posY")
	_ENV = tostring(cfg.position[1] or 0)
	tostring(cfg.position[1] or 0).func = handlerEx(2, funcPos)
	tostring(cfg.position[1] or 0).text = tostring(cfg.position[2] or 0)
	SoraDChangeToEditBox(posY, (tostring(cfg.position[1] or 0)))
	local funcScale = function(k, eventType, target)
		local v = target:getText()
		local scale = 0
		if v ~= nil then
			scale = tonumber(v) or 0
		end
		if k == "z" then
			cfg.scaleZ = scale
			self.effectNode:setScaleZ(scale)
		else
			cfg.scale[k] = scale
			self.effectNode:setScale(unpack(cfg.scale))
		end
	end
	SoraDGetChildByName(rootNode, "scale_name"):setString("scale")
	local scaleX = SoraDGetChildByName(rootNode, "scaleX")
	_ENV = cfg.position[2] or 0
	;(cfg.position[2] or 0).func = handlerEx(1, funcScale)
	;(cfg.position[2] or 0).text = tostring(cfg.scale[1] or 0)
	SoraDChangeToEditBox(scaleX, cfg.position[2] or 0)
	local scaleY = SoraDGetChildByName(rootNode, "scaleY")
	_ENV = tostring(cfg.scale[1] or 0)
	tostring(cfg.scale[1] or 0).func = handlerEx(2, funcScale)
	tostring(cfg.scale[1] or 0).text = tostring(cfg.scale[2] or 0)
	SoraDChangeToEditBox(scaleY, (tostring(cfg.scale[1] or 0)))
	local scaleZ = SoraDGetChildByName(rootNode, "scaleZ")
	_ENV = tostring(cfg.scale[2] or 0)
	tostring(cfg.scale[2] or 0).func = handlerEx("z", funcScale)
	tostring(cfg.scale[2] or 0).text = tostring(cfg.scale[3] or 0)
	SoraDChangeToEditBox(scaleZ, (tostring(cfg.scale[2] or 0)))
	local funcRotation = function(k, eventType, target)
		local v = target:getText()
		if v ~= nil then
			cfg.rotation[k] = tonumber(v) or 0
		end
		self.effectNode:setRotation3D(cc.vec3(unpack(cfg.rotation)))
	end
	SoraDGetChildByName(rootNode, "rotation_name"):setString("rotation3D")
	local rotationX = SoraDGetChildByName(rootNode, "rotationX")
	_ENV = cfg.scale[3] or 0
	;(cfg.scale[3] or 0).func = handlerEx(1, funcRotation)
	;(cfg.scale[3] or 0).text = tostring(cfg.rotation[1] or 0)
	SoraDChangeToEditBox(rotationX, cfg.scale[3] or 0)
	local rotationY = SoraDGetChildByName(rootNode, "rotationY")
	_ENV = tostring(cfg.rotation[1] or 0)
	tostring(cfg.rotation[1] or 0).func = handlerEx(2, funcRotation)
	tostring(cfg.rotation[1] or 0).text = tostring(cfg.rotation[2] or 0)
	SoraDChangeToEditBox(rotationY, (tostring(cfg.rotation[1] or 0)))
	local rotationZ = SoraDGetChildByName(rootNode, "rotationZ")
	_ENV = tostring(cfg.rotation[2] or 0)
	tostring(cfg.rotation[2] or 0).func = handlerEx(3, funcRotation)
	tostring(cfg.rotation[2] or 0).text = tostring(cfg.rotation[3] or 0)
	SoraDChangeToEditBox(rotationZ, (tostring(cfg.rotation[2] or 0)))
	return rootNode
end
function ShaderEditView:textureAttrEdit(attrInfo)
	dump(attrInfo, "createTextureAttr", 3)
	local rootNode = SoraDCreateCSBNode("textureAttrNode")
	local texName = SoraDGetChildByName(rootNode, "tex_name")
	texName:setString(attrInfo.name)
	SoraDGetChildByName(rootNode, "tex_path"):setString(attrInfo.value)
	local tex = SoraDGetChildByName(rootNode, "texture")
	tex:loadTexture(attrInfo.value, ccui.TextureResType.localType)
	SoraDGetChildByName(rootNode, "tilling_label"):setString("tilling")
	SoraDGetChildByName(rootNode, "offset_label"):setString("offset")
	local stNode = SoraDGetChildByName(rootNode, "stNode")
	local stInfo = self:getTextureSTInfo(attrInfo.name)
	local funST = function(k, eventType, target)
		local v = target:getText()
		if v ~= nil then
			stInfo.value[k] = tonumber(v) or 0
			self:updateAttrInfo(stInfo)
		end
	end
	if stInfo then
		_UPVALUE2_, _UPVALUE4_ = nil, attrInfo.name
		_UPVALUE2_, (nil)[1] = "tilingX", "tilingX"
		_UPVALUE2_, (nil)[2] = "tilingX", "x"
		_UPVALUE2_, ("tilingX")[1] = "tilingY", "tilingY"
		_UPVALUE2_, ("tilingX")[2] = "tilingY", "y"
		_UPVALUE2_, ("tilingY")[1] = "offsetX", "offsetX"
		_UPVALUE2_, ("tilingY")[2] = "offsetX", "z"
		;("offsetX")[1] = "offsetY"
		;("offsetX")[2] = "w"
		attrInfo.name[1] = nil
		attrInfo.name[2] = "tilingX"
		attrInfo.name[3] = "tilingY"
		local attrInfo.name[4], cfg = "offsetX", attrInfo.name
		for _, v in ipairs(cfg) do
			local tmpNode = SoraDGetChildByName(rootNode, v[1])
			tmpNode:setString(tostring(stInfo.value[v[2]]))
			_ENV = tostring(stInfo.value[v[2]])
			tostring(stInfo.value[v[2]]).func = handler(v[2], funST)
			tostring(stInfo.value[v[2]]).text = tostring(stInfo.value[v[2]])
			tmpNode = SoraDChangeToEditBox(tmpNode, tostring(stInfo.value[v[2]]))
		end
	else
		stNode:setVisible(false)
	end
	return rootNode
end
function ShaderEditView:reTextureAttrEdit(attrInfo)
end
function ShaderEditView:valueAttrEdit(attrInfo)
	dump(attrInfo, "createValueAttr", 3)
	local baseNode = SoraDCreateCSBNode("valueAttrNode")
	local slider = SoraDGetChildByName(baseNode, "slider")
	local commonSlider = include("commonSlider")
	_ENV, slider = commonSlider.new(slider), commonSlider.new(slider)
	commonSlider.new(slider).maxValue = attrInfo.value * 2
	commonSlider.new(slider).minValue = 0
	commonSlider.new(slider).curValue = attrInfo.value
	local commonSlider.new(slider).openEditBox, sliderData = true, commonSlider.new(slider)
	slider:initData(sliderData)
	slider:setLocalZOrder(3)
	slider:setFloatMode(true)
	slider:setSliderCallBack(function(valuechange)
		attrInfo.value = valuechange
		self:updateAttrInfo(attrInfo)
	end)
	SoraDGetChildByName(baseNode, "name"):setString(attrInfo.name)
	SoraDGetChildByName(baseNode, "valueType"):setString(attrInfo.attr)
	SoraDGetChildByName(baseNode, "maxTag"):setString("属性上限")
	local labelInput = SoraDGetChildByName(baseNode, "valueInput")
	_ENV = nil
	;(nil).func = function(eventType, target)
		local v = target:getText()
		local maxValue = math.floor(tonumber(v) or 0)
		slider:setMaxValue(maxValue)
	end
	;(nil).text = tostring(attrInfo.value * 2)
	labelInput = SoraDChangeToEditBox(labelInput, nil)
	return baseNode
end
function ShaderEditView:vecAttrEdit(attrInfo)
	dump(attrInfo, "createVecAttr", 3)
	local baseNode = SoraDCreateCSBNode("vecAttrNode")
	SoraDGetChildByName(baseNode, "name"):setString(attrInfo.name)
	SoraDGetChildByName(baseNode, "attrType"):setString(attrInfo.attr)
	local vecFunc = function(k, eventType, target)
		local v = target:getText()
		if v ~= nil then
			attrInfo.value[k] = tonumber(v) or 0
			self:updateAttrInfo(attrInfo)
		end
	end
	_UPVALUE4_ = SoraDGetChildByName(baseNode, "attrType")
	SoraDGetChildByName(baseNode, "attrType")[1] = "X"
	SoraDGetChildByName(baseNode, "attrType")[2] = "Y"
	SoraDGetChildByName(baseNode, "attrType")[3] = "Z"
	local SoraDGetChildByName(baseNode, "attrType")[4], labelCfg = "W", SoraDGetChildByName(baseNode, "attrType")
	for _, v in ipairs(labelCfg) do
		SoraDGetChildByName(baseNode, v):setString(v)
	end
	local vecX = SoraDGetChildByName(baseNode, "vecX")
	vecX:setString(attrInfo.value.x)
	_ENV = attrInfo.value.x
	attrInfo.value.x.func = handlerEx("x", vecFunc)
	attrInfo.value.x.text = attrInfo.value.x
	SoraDChangeToEditBox(vecX, attrInfo.value.x)
	local vecY = SoraDGetChildByName(baseNode, "vecY")
	vecY:setString(attrInfo.value.y)
	_ENV = attrInfo.value.y
	attrInfo.value.y.func = handlerEx("y", vecFunc)
	attrInfo.value.y.text = attrInfo.value.y
	SoraDChangeToEditBox(vecY, attrInfo.value.y)
	local vecZ = SoraDGetChildByName(baseNode, "vecZ")
	if attrInfo.attr ~= "vec2" then
		vecZ:setString(attrInfo.value.z)
		_ENV = attrInfo.value.z
		attrInfo.value.z.func = handlerEx("z", vecFunc)
		attrInfo.value.z.text = attrInfo.value.z
		vecZ = SoraDChangeToEditBox(vecZ, attrInfo.value.z)
	else
		vecZ:setVisible(false)
		SoraDGetChildByName(baseNode, "Z"):setVisible(false)
	end
	local vecW = SoraDGetChildByName(baseNode, "vecW")
	if attrInfo.attr == "vec4" then
		_ENV = attrInfo.value.z
		attrInfo.value.z.func = handlerEx("w", vecFunc)
		attrInfo.value.z.text = attrInfo.value.w
		vecW = SoraDChangeToEditBox(vecW, attrInfo.value.z)
	else
		vecW:setVisible(false)
		SoraDGetChildByName(baseNode, "W"):setVisible(false)
	end
	return baseNode
end
function ShaderEditView:timeuiAttrEdit(attrInfo)
	local baseNode = SoraDCreateCSBNode("vecAttrNode")
	SoraDGetChildByName(baseNode, "name"):setString(attrInfo.name)
	SoraDGetChildByName(baseNode, "attrType"):setString(attrInfo.attr)
	local vecFunc = function(k, eventType, target)
		local v = target:getText()
		if v ~= nil then
			attrInfo.value[k] = tonumber(v) or 0
			self:updateAttrInfo(attrInfo)
		end
	end
	if not attrInfo.value.ku and attrInfo.value.kU then
		attrInfo.value.ku = attrInfo.value.kU
		attrInfo.value.kU = nil
	end
	if not attrInfo.value.kv and attrInfo.value.kV then
		attrInfo.value.kv = attrInfo.value.kV
		attrInfo.value.kV = nil
	end
	SoraDGetChildByName(baseNode, "Y"):setString("ku")
	SoraDGetChildByName(baseNode, "W"):setString("kv")
	SoraDGetChildByName(baseNode, "vecX"):setVisible(false)
	SoraDGetChildByName(baseNode, "vecZ"):setVisible(false)
	local vecY = SoraDGetChildByName(baseNode, "vecY")
	_ENV = nil
	;(nil).func = handlerEx("ku", vecFunc)
	;(nil).text = attrInfo.value.ku
	SoraDChangeToEditBox(vecY, nil)
	local vecW = SoraDGetChildByName(baseNode, "vecW")
	_ENV = attrInfo.value.ku
	attrInfo.value.ku.func = handlerEx("kv", vecFunc)
	attrInfo.value.ku.text = attrInfo.value.kv
	SoraDChangeToEditBox(vecW, attrInfo.value.ku)
end
return ShaderEditView
