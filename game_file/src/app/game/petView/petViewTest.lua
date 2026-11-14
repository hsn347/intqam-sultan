local gametop = gModuleMgr.getObject("gametop")
local lightMap3d = include("lightMap3d")
local lightMapNormal3d = include("lightMapNormal3d")
local petViewTest = class("petViewTest", function(target)
	if target == nil then
		return SoraDCreateBasePanel("petViewTest")
	end
	return target
end)
function petViewTest:ctor()
	self.isHideCurrentSceneView = true
	self:bindBtnClose()
	self.btnTestOri = SoraDGetChildByName(self, "Button_test")
	self.node_pet = SoraDGetChildByName(self, "Top_node_pet")
	self.panel_pet = SoraDGetChildByName(self, "Top_panel_pet")
	self.panel_petL = SoraDGetChildByName(self, "Top_panel_pet")
	self.panel_petL:setBackGroundColorOpacity(0)
	self.touchL = SoraDGetChildByName(self, "Size_TouchL")
	self.touchR = SoraDGetChildByName(self, "Size_TouchR")
	self.btnTestOri = SoraDGetChildByName(self, "Button_test")
	self.btnToggle = SoraDGetChildByName(self, "Button_toggle")
	self.btnToggleBody = SoraDGetChildByName(self, "Button_toggle_body")
	self.btnToggleHD = SoraDGetChildByName(self, "Button_toggle_HD")
	self.btnTestOri:setTitleText("隐藏slider")
	self.btnToggle:setTitleText("参数2")
	self.btnToggle3 = self.btnToggle:clone()
	self.btnToggle3:addTo(self.btnTestOri:getParent())
	self.btnToggle3:setPosition(cc.p(self.btnToggle:getPositionX(), self.btnToggle:getPositionY() + 80))
	self.btnToggle3:setTitleText("参数3")
	self.btnToggleBody:setTitleText("参数1")
	self.btnToggleHD:setTitleText("超高清切换")
	self.imgBg = SoraDGetChildByName(self, "Top_Size_Image_bg")
	self.imgBg:setFillType(1)
	self.btnLeft = SoraDGetChildByName(self, "Top_Btn_Left")
	self.btnRight = SoraDGetChildByName(self, "Top_Btn_Right")
	self.viewPosNode = SoraDGetChildByName(self, "color_p")
	self.viewPosNode:setLocalZOrder(10)
	self.viewPosNode:setVisible(false)
	self.curYAngle = 0
	self.node_pet:setLocalZOrder(0)
	self.panel_pet:setLocalZOrder(1)
	self.panel_pet:setTouchEnabled(true)
	self.panel_pet:addTouchEventListener(handler(self, self.onLayoutItem))
	self.btnLeft:addTouchEventListener(handler(self, self.onBtnLeft))
	self.btnRight:addTouchEventListener(handler(self, self.onBtnRight))
	self.btnTestOri:setTouchEnabled(true)
	self.btnTestOri:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended then
			if self.nodeSlider then
				self.nodeSlider:removeFromParent()
			end
			self.nodeSlider = nil
		end
	end)
	_ENV, _UPVALUE14_ = self.btnTestOri, self.btnTestOri.addTouchEventListener
	_ENV, self.btnTestOri.func = function(target, event)
		if event == ccui.TouchEventType.ended then
			if self.nodeSlider then
				self.nodeSlider:removeFromParent()
			end
			self.nodeSlider = nil
		end
	end, "test3DNoLight"
	_ENV, (function(target, event)
		if event == ccui.TouchEventType.ended then
			if self.nodeSlider then
				self.nodeSlider:removeFromParent()
			end
			self.nodeSlider = nil
		end
	end).func = handler(self, self.onBtnRight)
	_ENV, handler(self, self.onBtnRight).func = handler(self, self.onBtnRight)
	_ENV, handler(self, self.onBtnRight).func = handler(self, self.onBtnRight)
	_ENV, handler(self, self.onBtnRight).func = handler(self, self.onBtnRight)
	_ENV, handler(self, self.onBtnRight).func = handler(self, self.onBtnRight)
	_ENV, handler(self, self.onBtnRight).func = handler(self, self.onBtnRight)
	_ENV, handler(self, self.onBtnRight).func = handler(self, self.onBtnRight)
	_ENV, handler(self, self.onBtnRight).func = handler(self, self.onBtnRight)
	_ENV, handler(self, self.onBtnRight).func = handler(self, self.onBtnRight)
	_ENV, handler(self, self.onBtnRight).func = handler(self, self.onBtnRight)
	_ENV, handler(self, self.onBtnRight).func = handler(self, self.onBtnRight)
	_ENV, handler(self, self.onBtnRight).func = handler(self, self.onBtnRight)
	handler(self, self.onBtnRight).func = "test3DSpecLight_Beauty01_BOE2"
	self.testMap, self.btnTestOri.addTouchEventListener[1] = self.btnTestOri.addTouchEventListener, self.btnTestOri
	self.testMap, self.btnTestOri.addTouchEventListener[2] = self.btnTestOri.addTouchEventListener, function(target, event)
		if event == ccui.TouchEventType.ended then
			if self.nodeSlider then
				self.nodeSlider:removeFromParent()
			end
			self.nodeSlider = nil
		end
	end
	self.testMap, self.btnTestOri.addTouchEventListener[3] = self.btnTestOri.addTouchEventListener, handler(self, self.onBtnRight)
	self.testMap, self.btnTestOri.addTouchEventListener[4] = self.btnTestOri.addTouchEventListener, handler(self, self.onBtnRight)
	self.testMap, self.btnTestOri.addTouchEventListener[5] = self.btnTestOri.addTouchEventListener, handler(self, self.onBtnRight)
	self.testMap, self.btnTestOri.addTouchEventListener[6] = self.btnTestOri.addTouchEventListener, handler(self, self.onBtnRight)
	self.testMap, self.btnTestOri.addTouchEventListener[7] = self.btnTestOri.addTouchEventListener, handler(self, self.onBtnRight)
	self.testMap, self.btnTestOri.addTouchEventListener[8] = self.btnTestOri.addTouchEventListener, handler(self, self.onBtnRight)
	self.testMap, self.btnTestOri.addTouchEventListener[9] = self.btnTestOri.addTouchEventListener, handler(self, self.onBtnRight)
	self.testMap, self.btnTestOri.addTouchEventListener[10] = self.btnTestOri.addTouchEventListener, handler(self, self.onBtnRight)
	self.testMap, self.btnTestOri.addTouchEventListener[11] = self.btnTestOri.addTouchEventListener, handler(self, self.onBtnRight)
	self.testMap, self.btnTestOri.addTouchEventListener[12] = self.btnTestOri.addTouchEventListener, handler(self, self.onBtnRight)
	self.testMap, self.btnTestOri.addTouchEventListener[13] = self.btnTestOri.addTouchEventListener, handler(self, self.onBtnRight)
	self.testMap, self.btnTestOri.addTouchEventListener[14] = self.btnTestOri.addTouchEventListener, handler(self, self.onBtnRight)
	self.testIndex = #self.testMap
	self:loadTestByIndex(self.testIndex)
	self.btnToggle:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended and self.cfg then
			if not self.cfg.meshes then
				self:loadSliderParam(self.program, self.programState, self.cfg)
			else
				local index = 2
				local name = self.cfg.meshes[index].name
				self:loadSliderParam(self.programs[name], self.programStates[name], self.cfg, index)
			end
		end
	end)
	self.btnToggleBody:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended and self.cfg then
			if not self.cfg.meshes then
				self:loadSliderParam(self.program, self.programState, self.cfg)
			else
				local index = 1
				local name = self.cfg.meshes[index].name
				self:loadSliderParam(self.programs[name], self.programStates[name], self.cfg, index)
			end
		end
	end)
	self.btnToggle3:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended and self.cfg then
			if not self.cfg.meshes then
				self:loadSliderParam(self.program, self.programState, self.cfg)
			else
				local index = 3
				local name = self.cfg.meshes[index].name
				self:loadSliderParam(self.programs[name], self.programStates[name], self.cfg, index)
			end
		end
	end)
	do return end
	self.panel_pet:setVisible(false)
	self.touchL:setTouchEnabled(true)
	self.touchL:addTouchEventListener(handler(self, self.onTouchL))
	self.touchR:addTouchEventListener(handler(self, self.onTouchR))
	self:testNew3dSkinedLightSpcularMap()
	self.panel_pet:setLocalZOrder(0)
	self.node_pet:setLocalZOrder(2)
	self:testNew3dSkinedLightSpcularNormalMap()
	local city = SoraDSearchPanelFromManagerByName("loginView")
	if city then
		city:setVisible(false)
	end
	self.modeType = 1
	self.btnTestOri:setTouchEnabled(true)
	self.btnTestOri:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended then
			if self.modeType == 1 then
				self:testNew3dSkinedLightSpcularNormalMap3()
				self.modeType = 2
			else
				self:testNew3dSkinedLightSpcularNormalMap()
				self.modeType = 1
			end
		end
	end)
	self:loadSliders()
	self.bodySlider:setVisible(false)
	self.bodySlider:setLocalZOrder(10)
	self.equipSlider:setVisible(false)
	self.equipSlider:setLocalZOrder(10)
	self.prevSlider = nil
	self.btnToggle:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended then
			if self.prevSlider and self.prevSlider ~= self.equipSlider then
				self.prevSlider:setPositionX(-640)
				self.prevSlider:setVisible(false)
				self.prevSlider = nil
			end
			local isVisible = not self.equipSlider:isVisible()
			self.equipSlider:setVisible(isVisible)
			if isVisible then
				self.prevSlider = self.equipSlider
				self.equipSlider:setPositionX(0)
				self.program = self.equipProgram
			else
				self.equipSlider:setPositionX(-640)
			end
		end
	end)
	self.btnToggleBody:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended then
			if self.prevSlider and self.prevSlider ~= self.bodySlider then
				self.prevSlider:setPositionX(-640)
				self.prevSlider:setVisible(false)
				self.prevSlider = nil
			end
			local isVisible = not self.bodySlider:isVisible()
			self.bodySlider:setVisible(isVisible)
			if isVisible then
				self.prevSlider = self.bodySlider
				self.bodySlider:setPositionX(0)
				self.program = self.bodyProgram
			else
				self.bodySlider:setPositionX(-640)
			end
		end
	end)
	self.isHD = false
	self.btnToggleHD:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended then
			self.isHD = not self.isHD
			if self.isHD then
				local diffFile = "3d/normal/munaiyi_d.png"
				local speFile = "3d/normal/munaiyi_s.png"
				local normalFile = "3d/normal/munaiyi_n.png"
				local speTexture = util.addTextureCache(speFile)
				local normalTexture = util.addTextureCache(normalFile)
				self.sprite:setTexture(diffFile)
				self.bodyState:setUniformTexture("specularMap", speTexture)
				self.bodyState:setUniformTexture("normalMap", normalTexture)
				self.equipState:setUniformTexture("specularMap", speTexture)
				self.equipState:setUniformTexture("normalMap", normalTexture)
			else
				local diffFile = "3d/normal/munaiyi_d_1024.png"
				local speFile = "3d/normal/munaiyi_s_1024.png"
				local normalFile = "3d/normal/munaiyi_n_1024.png"
				local speTexture = util.addTextureCache(speFile)
				local normalTexture = util.addTextureCache(normalFile)
				self.sprite:setTexture(diffFile)
				self.bodyState:setUniformTexture("specularMap", speTexture)
				self.bodyState:setUniformTexture("normalMap", normalTexture)
				self.equipState:setUniformTexture("specularMap", speTexture)
				self.equipState:setUniformTexture("normalMap", normalTexture)
			end
		end
	end)
end
function petViewTest:onBtnLeft(target, event)
	if event == ccui.TouchEventType.ended then
		self.testIndex = self.testIndex - 1
		if self.testIndex <= 0 then
			self.testIndex = #self.testMap
		end
		self:loadTestByIndex(self.testIndex)
	end
end
function petViewTest:onBtnRight(target, event)
	if event == ccui.TouchEventType.ended and event == ccui.TouchEventType.ended then
		self.testIndex = self.testIndex + 1
		if self.testIndex > #self.testMap then
			self.testIndex = 1
		end
		self:loadTestByIndex(self.testIndex)
	end
end
function petViewTest:richEventCallBack(target, event)
	if event == ccui.RichEventType.BEFORE then
		print("petViewTest:richEventCallBack(target, event)  BEFORE  ---callback")
	elseif event == ccui.RichEventType.AFTER then
		print("petViewTest:richEventCallBack(target, event)  AFTER  ---callback")
	end
end
function petViewTest:onTextEvent(target, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local metaInfo = self.textChat:getTouchMetaInfo(target:getTouchEndPosition())
		dump(metaInfo, "metaInfo")
		if metaInfo then
			if metaInfo.param and string.len(metaInfo.param) > 0 then
				SoraDShowMsgTip("点击了Replace----" .. metaInfo.name)
			else
				SoraDShowMsgTip("点击了超链接---" .. metaInfo.name)
			end
		end
		local labelRender = self.textChat:getVirtualRenderer()
		local allMetaInfos = labelRender:getMetaInfos()
		dump(allMetaInfos, "allMetaInfos", 10)
		local subMetaInfos = labelRender:getSubMetaInfos(1)
		dump(subMetaInfos, "subMetaInfos", 10)
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function petViewTest:createLabel(text)
	local fontColor = cc.c3b(96, 73, 44)
	local labelDes = ccui.Text:create()
	labelDes:setFontSize(20)
	labelDes:setColor(fontColor)
	labelDes:setString(text)
	return labelDes
end
function petViewTest:loadSliders()
	self.bodySlider = self:loadSliderSingle(self.bodyState, self.bodyParam)
	self.equipSlider = self:loadSliderSingle(self.equipState, self.equipParam)
	self.bodySlider:setPositionX(-640)
	self.equipSlider:setPositionX(-640)
end
function petViewTest:loadSliderSingle(state, param)
	local nodeSlider = display.newNode()
	self:addChild(nodeSlider)
	nodeSlider:setLocalZOrder(10)
	local sliderOffsetX = 100
	local sliderOffsetY = 100
	local posLabelX = -50
	local posLabelY = 10
	local stepY = 40
	local programState = state
	local initParam = param
	local sliderX = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
	local commonSlider = include("commonSlider")
	_ENV, sliderX = commonSlider.new(sliderX), commonSlider.new(sliderX)
	commonSlider.new(sliderX).maxValue = 255
	commonSlider.new(sliderX).minValue = 1
	commonSlider.new(sliderX).curValue = initParam.lightColor.x * 255
	local commonSlider.new(sliderX).openEditBox, sliderData = true, commonSlider.new(sliderX)
	sliderX:initData(sliderData)
	sliderX:addTo(nodeSlider)
	sliderX:setPosition(cc.p(sliderOffsetX, sliderOffsetY))
	sliderX:setLocalZOrder(10)
	sliderX:setSliderCallBack(function(valuechange)
		initParam.lightColor.x = valuechange / 255
		dump(initParam.lightPos, "set x initParam.lightColor")
		programState:setUniformVec3(self.program:getUniform("lightColor").location, initParam.lightColor)
	end)
	local labelX = self:createLabel("光线R")
	labelX:addTo(sliderX)
	labelX:setPositionX(posLabelX)
	labelX:setPositionY(posLabelY)
	sliderOffsetY = sliderOffsetY + stepY
	local sliderY = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
	local commonSlider = include("commonSlider")
	_ENV, sliderY = commonSlider.new(sliderY), commonSlider.new(sliderY)
	commonSlider.new(sliderY).maxValue = 255
	commonSlider.new(sliderY).minValue = 1
	commonSlider.new(sliderY).curValue = initParam.lightColor.y * 255
	local commonSlider.new(sliderY).openEditBox, sliderData = true, commonSlider.new(sliderY)
	sliderY:initData(sliderData)
	sliderY:addTo(nodeSlider)
	sliderY:setPosition(cc.p(sliderOffsetX, sliderOffsetY))
	sliderY:setLocalZOrder(10)
	sliderY:setSliderCallBack(function(valuechange)
		initParam.lightColor.y = valuechange / 255
		dump(initParam.lightColor, "set y initParam.lightColor")
		programState:setUniformVec3(self.program:getUniform("lightColor").location, initParam.lightColor)
	end)
	local labelX = self:createLabel("光线绿")
	labelX:addTo(sliderY)
	labelX:setPositionX(posLabelX)
	labelX:setPositionY(posLabelY)
	sliderOffsetY = sliderOffsetY + stepY
	local sliderZ = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
	local commonSlider = include("commonSlider")
	_ENV, sliderZ = commonSlider.new(sliderZ), commonSlider.new(sliderZ)
	commonSlider.new(sliderZ).maxValue = 255
	commonSlider.new(sliderZ).minValue = 1
	commonSlider.new(sliderZ).curValue = initParam.lightColor.z * 255
	local commonSlider.new(sliderZ).openEditBox, sliderData = true, commonSlider.new(sliderZ)
	sliderZ:initData(sliderData)
	sliderZ:addTo(nodeSlider)
	sliderZ:setPosition(cc.p(sliderOffsetX, sliderOffsetY))
	sliderZ:setLocalZOrder(10)
	sliderZ:setSliderCallBack(function(valuechange)
		initParam.lightColor.z = valuechange / 255
		dump(initParam.lightPos, "set x initParam.lightColor")
		programState:setUniformVec3(self.program:getUniform("lightColor").location, initParam.lightColor)
	end)
	local labelX = self:createLabel("光线蓝")
	labelX:addTo(sliderZ)
	labelX:setPositionX(posLabelX)
	labelX:setPositionY(posLabelY)
	sliderOffsetY = sliderOffsetY + stepY
	local sliderX = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
	local commonSlider = include("commonSlider")
	_ENV, sliderX = commonSlider.new(sliderX), commonSlider.new(sliderX)
	commonSlider.new(sliderX).maxValue = 10000
	commonSlider.new(sliderX).minValue = 1
	commonSlider.new(sliderX).curValue = initParam.lightPos.x + 2000
	local commonSlider.new(sliderX).openEditBox, sliderData = true, commonSlider.new(sliderX)
	sliderX:initData(sliderData)
	sliderX:addTo(nodeSlider)
	sliderX:setPosition(cc.p(sliderOffsetX, sliderOffsetY))
	sliderX:setLocalZOrder(10)
	sliderX:setSliderCallBack(function(valuechange)
		initParam.lightPos.x = valuechange - 2000
		dump(initParam.lightPos, "set x initParam.lightPos")
		programState:setUniformVec3(self.program:getUniform("lightPos").location, initParam.lightPos)
		if self.lightLabel then
			self.lightLabel:setString(string.format("灯光(%d,%d,%d)", initParam.lightPos.x, initParam.lightPos.y, initParam.lightPos.z))
		end
	end)
	local labelX = self:createLabel("光坐标X")
	labelX:addTo(sliderX)
	labelX:setPositionX(posLabelX)
	labelX:setPositionY(posLabelY)
	sliderOffsetY = sliderOffsetY + stepY
	local sliderY = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
	local commonSlider = include("commonSlider")
	_ENV, sliderY = commonSlider.new(sliderY), commonSlider.new(sliderY)
	commonSlider.new(sliderY).maxValue = 10000
	commonSlider.new(sliderY).minValue = 1
	commonSlider.new(sliderY).curValue = initParam.lightPos.y + 2000
	local commonSlider.new(sliderY).openEditBox, sliderData = true, commonSlider.new(sliderY)
	sliderY:initData(sliderData)
	sliderY:addTo(nodeSlider)
	sliderY:setPosition(cc.p(sliderOffsetX, sliderOffsetY))
	sliderY:setLocalZOrder(10)
	sliderY:setSliderCallBack(function(valuechange)
		initParam.lightPos.y = valuechange - 2000
		dump(initParam.lightPos, "set y initParam.lightPos")
		programState:setUniformVec3(self.program:getUniform("lightPos").location, initParam.lightPos)
		if self.lightLabel then
			self.lightLabel:setString(string.format("灯光(%d,%d,%d)", initParam.lightPos.x, initParam.lightPos.y, initParam.lightPos.z))
		end
	end)
	local labelY = self:createLabel("光坐标Y")
	labelY:addTo(sliderY)
	labelY:setPositionX(posLabelX)
	sliderOffsetY = sliderOffsetY + stepY
	local sliderZ = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
	local commonSlider = include("commonSlider")
	_ENV, sliderZ = commonSlider.new(sliderZ), commonSlider.new(sliderZ)
	commonSlider.new(sliderZ).maxValue = 10000
	commonSlider.new(sliderZ).minValue = 1
	commonSlider.new(sliderZ).curValue = initParam.lightPos.z + 2000
	local commonSlider.new(sliderZ).openEditBox, sliderData = true, commonSlider.new(sliderZ)
	sliderZ:initData(sliderData)
	sliderZ:addTo(nodeSlider)
	sliderZ:setPosition(cc.p(sliderOffsetX, sliderOffsetY))
	sliderZ:setLocalZOrder(10)
	sliderZ:setSliderCallBack(function(valuechange)
		initParam.lightPos.z = valuechange - 2000
		dump(initParam.lightPos, "set z initParam.lightPos")
		programState:setUniformVec3(self.program:getUniform("lightPos").location, initParam.lightPos)
		if self.lightLabel then
			self.lightLabel:setString(string.format("灯光(%d,%d,%d)", initParam.lightPos.x, initParam.lightPos.y, initParam.lightPos.z))
		end
	end)
	local labelZ = self:createLabel("光坐标Z")
	labelZ:addTo(sliderZ)
	labelZ:setPositionX(posLabelX)
	self.lightLabel = self:createLabel("光坐标")
	self.lightLabel:addTo(nodeSlider)
	self.lightLabel:setPosition(cc.p(220, display.height - 150))
	self.lightLabel:setColor(cc.c3b(255, 0, 0))
	sliderOffsetY = sliderOffsetY + stepY
	local sliderBright = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
	local commonSlider = include("commonSlider")
	_ENV, sliderBright = commonSlider.new(sliderBright), commonSlider.new(sliderBright)
	commonSlider.new(sliderBright).maxValue = 100
	commonSlider.new(sliderBright).minValue = 1
	commonSlider.new(sliderBright).curValue = initParam.brightness
	local commonSlider.new(sliderBright).openEditBox, sliderData = true, commonSlider.new(sliderBright)
	sliderBright:initData(sliderData)
	sliderBright:addTo(nodeSlider)
	sliderBright:setPosition(cc.p(sliderOffsetX, sliderOffsetY))
	sliderBright:setLocalZOrder(10)
	sliderBright:setSliderCallBack(function(valuechange)
		initParam.brightness = valuechange
		dump(initParam.brightness, "initParam.brightness")
		programState:setUniformFloat(self.program:getUniform("brightness").location, initParam.brightness)
	end)
	local labelBright = self:createLabel("高光亮度")
	labelBright:addTo(sliderBright)
	labelBright:setPositionX(posLabelX)
	sliderOffsetY = sliderOffsetY + stepY
	local sliderAmbient = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
	local commonSlider = include("commonSlider")
	_ENV, sliderAmbient = commonSlider.new(sliderAmbient), commonSlider.new(sliderAmbient)
	commonSlider.new(sliderAmbient).maxValue = 100
	commonSlider.new(sliderAmbient).minValue = 1
	commonSlider.new(sliderAmbient).curValue = initParam.lightAmbient.x * 100
	local commonSlider.new(sliderAmbient).openEditBox, sliderData = true, commonSlider.new(sliderAmbient)
	sliderAmbient:initData(sliderData)
	sliderAmbient:addTo(nodeSlider)
	sliderAmbient:setPosition(cc.p(sliderOffsetX, sliderOffsetY))
	sliderAmbient:setLocalZOrder(10)
	sliderAmbient:setSliderCallBack(function(valuechange)
		initParam.lightAmbient.x = valuechange / 100.0
		initParam.lightAmbient.y = initParam.lightAmbient.x
		initParam.lightAmbient.z = initParam.lightAmbient.x
		dump(initParam.lightAmbient, "initParam.lightAmbient")
		programState:setUniformVec3(self.program:getUniform("lightAmbient").location, initParam.lightAmbient)
	end)
	local labelX = self:createLabel("环境光")
	labelX:addTo(sliderAmbient)
	labelX:setPositionX(posLabelX)
	labelX:setPositionY(posLabelY)
	sliderOffsetY = sliderOffsetY + stepY
	local sliderDiffuse = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
	local commonSlider = include("commonSlider")
	_ENV, sliderDiffuse = commonSlider.new(sliderDiffuse), commonSlider.new(sliderDiffuse)
	commonSlider.new(sliderDiffuse).maxValue = 100
	commonSlider.new(sliderDiffuse).minValue = 1
	commonSlider.new(sliderDiffuse).curValue = initParam.lightDiffuse.x * 100
	local commonSlider.new(sliderDiffuse).openEditBox, sliderData = true, commonSlider.new(sliderDiffuse)
	sliderDiffuse:initData(sliderData)
	sliderDiffuse:addTo(nodeSlider)
	sliderDiffuse:setPosition(cc.p(sliderOffsetX, sliderOffsetY))
	sliderDiffuse:setLocalZOrder(10)
	sliderDiffuse:setSliderCallBack(function(valuechange)
		initParam.lightDiffuse.x = valuechange / 100
		initParam.lightDiffuse.y = initParam.lightDiffuse.x
		initParam.lightDiffuse.z = initParam.lightDiffuse.x
		dump(initParam.lightDiffuse, "initParam.lightDiffuse")
		programState:setUniformVec3(self.program:getUniform("lightDiffuse").location, initParam.lightDiffuse)
	end)
	local labelX = self:createLabel("漫反射")
	labelX:addTo(sliderDiffuse)
	labelX:setPositionX(posLabelX)
	labelX:setPositionY(posLabelY)
	sliderOffsetY = sliderOffsetY + stepY
	local sliderSpecular = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
	local commonSlider = include("commonSlider")
	_ENV, sliderSpecular = commonSlider.new(sliderSpecular), commonSlider.new(sliderSpecular)
	commonSlider.new(sliderSpecular).maxValue = 500
	commonSlider.new(sliderSpecular).minValue = 1
	commonSlider.new(sliderSpecular).curValue = initParam.lightSpecular.x * 100
	local commonSlider.new(sliderSpecular).openEditBox, sliderData = true, commonSlider.new(sliderSpecular)
	sliderSpecular:initData(sliderData)
	sliderSpecular:addTo(nodeSlider)
	sliderSpecular:setPosition(cc.p(sliderOffsetX, sliderOffsetY))
	sliderSpecular:setLocalZOrder(10)
	sliderSpecular:setSliderCallBack(function(valuechange)
		initParam.lightSpecular.x = valuechange / 100
		initParam.lightSpecular.y = initParam.lightSpecular.x
		initParam.lightSpecular.z = initParam.lightSpecular.x
		dump(initParam.lightSpecular, "initParam.lightSpecular")
		programState:setUniformVec3(self.program:getUniform("lightSpecular").location, initParam.lightSpecular)
	end)
	local labelX = self:createLabel("高光")
	labelX:addTo(sliderSpecular)
	labelX:setPositionX(posLabelX)
	labelX:setPositionY(posLabelY)
	sliderOffsetY = sliderOffsetY + stepY
	local sliderSpecular = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
	local commonSlider = include("commonSlider")
	_ENV, sliderSpecular = commonSlider.new(sliderSpecular), commonSlider.new(sliderSpecular)
	commonSlider.new(sliderSpecular).maxValue = 50
	commonSlider.new(sliderSpecular).minValue = 1
	commonSlider.new(sliderSpecular).curValue = initParam.scale * 10
	local commonSlider.new(sliderSpecular).openEditBox, sliderData = true, commonSlider.new(sliderSpecular)
	sliderSpecular:initData(sliderData)
	sliderSpecular:addTo(nodeSlider)
	sliderSpecular:setPosition(cc.p(sliderOffsetX, sliderOffsetY))
	sliderSpecular:setLocalZOrder(10)
	sliderSpecular:setSliderCallBack(function(valuechange)
		initParam.lightSpecular.scale = valuechange / 10
		self.sprite_animal_R:setScale(initParam.lightSpecular.scale)
	end)
	local labelX = self:createLabel("缩放")
	labelX:addTo(sliderSpecular)
	labelX:setPositionX(posLabelX)
	labelX:setPositionY(posLabelY)
	sliderOffsetY = sliderOffsetY + stepY
	local sliderX = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
	local commonSlider = include("commonSlider")
	_ENV, sliderX = commonSlider.new(sliderX), commonSlider.new(sliderX)
	commonSlider.new(sliderX).maxValue = 4000
	commonSlider.new(sliderX).minValue = 1
	commonSlider.new(sliderX).curValue = initParam.viewPos.x + 2000
	local commonSlider.new(sliderX).openEditBox, sliderData = true, commonSlider.new(sliderX)
	sliderX:initData(sliderData)
	sliderX:addTo(nodeSlider)
	sliderX:setPosition(cc.p(sliderOffsetX, sliderOffsetY))
	sliderX:setLocalZOrder(10)
	sliderX:setSliderCallBack(function(valuechange)
		initParam.viewPos.x = valuechange - 2000
		programState:setUniformVec3(self.program:getUniform("viewPos").location, initParam.viewPos)
		if self.viewPosLabel then
			self.viewPosLabel:setString(string.format("视点(%d,%d,%d)", initParam.viewPos.x, initParam.viewPos.y, initParam.viewPos.z))
		end
		local nodePos = self.node_pet:convertToNodeSpace(initParam.viewPos)
		self.viewPosNode:setPositionX(nodePos.x)
	end)
	local labelX = self:createLabel("视点坐标X")
	labelX:addTo(sliderX)
	labelX:setPositionX(posLabelX)
	labelX:setPositionY(posLabelY)
	sliderOffsetY = sliderOffsetY + stepY
	local sliderY = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
	local commonSlider = include("commonSlider")
	_ENV, sliderY = commonSlider.new(sliderY), commonSlider.new(sliderY)
	commonSlider.new(sliderY).maxValue = 4000
	commonSlider.new(sliderY).minValue = 1
	commonSlider.new(sliderY).curValue = initParam.viewPos.y + 2000
	local commonSlider.new(sliderY).openEditBox, sliderData = true, commonSlider.new(sliderY)
	sliderY:initData(sliderData)
	sliderY:addTo(nodeSlider)
	sliderY:setPosition(cc.p(sliderOffsetX, sliderOffsetY))
	sliderY:setLocalZOrder(10)
	sliderY:setSliderCallBack(function(valuechange)
		initParam.viewPos.y = valuechange - 2000
		dump(initParam.viewPos, "set y initParam.viewPos")
		programState:setUniformVec3(self.program:getUniform("viewPos").location, initParam.viewPos)
		if self.viewPosLabel then
			self.viewPosLabel:setString(string.format("视点(%d,%d,%d)", initParam.viewPos.x, initParam.viewPos.y, initParam.viewPos.z))
		end
		local nodePos = self.node_pet:convertToNodeSpace(initParam.viewPos)
		self.viewPosNode:setPositionY(nodePos.y)
	end)
	local labelY = self:createLabel("视点坐标Y")
	labelY:addTo(sliderY)
	labelY:setPositionX(posLabelX)
	sliderOffsetY = sliderOffsetY + stepY
	local sliderZ = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
	local commonSlider = include("commonSlider")
	_ENV, sliderZ = commonSlider.new(sliderZ), commonSlider.new(sliderZ)
	commonSlider.new(sliderZ).maxValue = 4000
	commonSlider.new(sliderZ).minValue = 1
	commonSlider.new(sliderZ).curValue = initParam.viewPos.z + 2000
	local commonSlider.new(sliderZ).openEditBox, sliderData = true, commonSlider.new(sliderZ)
	sliderZ:initData(sliderData)
	sliderZ:addTo(nodeSlider)
	sliderZ:setPosition(cc.p(sliderOffsetX, sliderOffsetY))
	sliderZ:setLocalZOrder(10)
	sliderZ:setSliderCallBack(function(valuechange)
		initParam.viewPos.z = valuechange - 2000
		dump(initParam.viewPos, "set z initParam.viewPos")
		programState:setUniformVec3(self.program:getUniform("viewPos").location, initParam.viewPos)
		if self.viewPosLabel then
			self.viewPosLabel:setString(string.format("视点(%d,%d,%d)", initParam.viewPos.x, initParam.viewPos.y, initParam.viewPos.z))
		end
		self.viewPosNode:setPositionZ(initParam.viewPos.z)
	end)
	local labelZ = self:createLabel("视点坐标Z")
	labelZ:addTo(sliderZ)
	labelZ:setPositionX(posLabelX)
	self.viewPosLabel = self:createLabel("视点坐标")
	self.viewPosLabel:addTo(nodeSlider)
	self.viewPosLabel:setPosition(cc.p(420, display.height - 150))
	self.viewPosLabel:setColor(cc.c3b(255, 0, 0))
	return nodeSlider
end
function petViewTest:testNew3dSkinedLightSpcularMap()
	self.panel_pet:setVisible(false)
	self.node_pet:setLocalZOrder(0)
	self.panel_pet:setLocalZOrder(1)
	self.panel_pet:setTouchEnabled(true)
	self.panel_pet:addTouchEventListener(handler(self, self.onLayoutItem))
	self.curYAngle = 0
	local filePath = "3d/normal/et_shizitest_04.c3b"
	local sprite3dBumped = cc.Sprite3D:create(filePath)
	sprite3dBumped:setScale(6)
	_ENV = 6
	;(6).x = -50
	;(6).y = -70
	;(6).z = 0
	sprite3dBumped:setPosition3D(6)
	sprite3dBumped:setRotation3D(cc.vec3(0.0, 0.0, 0.0))
	sprite3dBumped:setTexture("3d/normal/babalishi_04.png")
	self.node_pet:addChild(sprite3dBumped)
	local sprite = sprite3dBumped
	local program = cc.GLProgramCache:getInstance():getGLProgram("3dSkinedLightMap")
	if not program then
		program = cc.GLProgram:createWithByteArrays(lightMap3d.vertBytes, lightMap3d.noSpecularMapfragBytes)
		cc.GLProgramCache:getInstance():addGLProgram(program, "3dSkinedLightMap")
	end
	local state = cc.GLProgramState:create(program)
	sprite:setGLProgramState(state)
	_ENV = program
	program.x = 0
	program.y = 480
	program.z = cc.Director:getInstance():getZEye()
	state:setUniformVec3(program:getUniform("viewPos").location, program)
	_ENV = program
	program.x = 170
	program.y = 480
	program.z = 400
	state:setUniformVec3(program:getUniform("lightPos").location, program)
	_ENV = program
	program.x = 1
	program.y = 1
	program.z = 1
	state:setUniformVec3(program:getUniform("lightColor").location, program)
	state:setUniformInt(program:getUniform("blinn").location, 1)
	state:setUniformFloat(program:getUniform("u_alpha").location, 0.2)
	_ENV = program
	program.x = 0.8
	program.y = 0.8
	program.z = 0.8
	state:setUniformVec3(program:getUniform("lightDiffuse").location, program)
	_ENV = program
	program.x = 0.1
	program.y = 0.1
	program.z = 0.1
	state:setUniformVec3(program:getUniform("lightSpecular").location, program)
	_ENV = program
	program.x = 0.26
	program.y = 0.26
	program.z = 0.26
	state:setUniformVec3(program:getUniform("lightAmbient").location, program)
	state:setUniformFloat(program:getUniform("brightness").location, 55.0)
	local sharedTextureCache = cc.Director:getInstance():getTextureCache()
	local animation = cc.Animation3D:create(filePath)
	if nil ~= animation then
		print("动画时长: = ", animation:getDuration())
		local animate = cc.Animate3D:create(animation)
		animate:setSpeed(0.8)
		sprite:runAction(cc.RepeatForever:create(animate))
	end
	sprite3dBumped:setCullFaceEnabled(false)
	self.sprite_animal_L = sprite3dBumped
	print("执行到这里了----")
end
function petViewTest:testNew3dSkinedLightSpcularMap2()
	self.panel_pet:setVisible(false)
	self.node_pet:setLocalZOrder(0)
	self.panel_pet:setLocalZOrder(1)
	self.panel_pet:setTouchEnabled(true)
	self.panel_pet:addTouchEventListener(handler(self, self.onLayoutItem))
	self.curYAngle = 0
	local filePath = "3d/normal/010.c3b"
	local sprite3dBumped = cc.Sprite3D:create(filePath)
	sprite3dBumped:setScale(3.5)
	_ENV = 3.5
	;(3.5).x = -150
	;(3.5).y = -470
	;(3.5).z = 0
	sprite3dBumped:setPosition3D(3.5)
	sprite3dBumped:setRotation3D(cc.vec3(0.0, 0.0, 0.0))
	sprite3dBumped:setTexture("3d/normal/gongzheng_AlbedoTransparency.png")
	self.node_pet:addChild(sprite3dBumped)
	local sprite = sprite3dBumped
	local program = cc.GLProgramCache:getInstance():getGLProgram("3dSkinedLightMap")
	if not program then
		program = cc.GLProgram:createWithByteArrays(lightMap3d.vertBytes, lightMap3d.fragBytes)
		cc.GLProgramCache:getInstance():addGLProgram(program, "3dSkinedLightMap")
	end
	local state = cc.GLProgramState:create(program)
	sprite:setGLProgramState(state)
	_ENV = program
	program.x = 130
	program.y = 480
	program.z = cc.Director:getInstance():getZEye()
	state:setUniformVec3(program:getUniform("viewPos").location, program)
	_ENV = program
	program.x = 170
	program.y = 480
	program.z = 400
	state:setUniformVec3(program:getUniform("lightPos").location, program)
	state:setUniformInt(program:getUniform("blinn").location, 1)
	state:setUniformFloat(program:getUniform("u_alpha").location, 0.2)
	local sharedTextureCache = cc.Director:getInstance():getTextureCache()
	local imgFile = "3d/normal/gongzheng_SpecularSmoothness.png"
	local imgTexture = util.addTextureCache(imgFile)
	state:setUniformTexture("specularMap", imgTexture)
	local normalFile = "3d/normal/gongzheng_Normal.png"
	local normalTexture = util.addTextureCache(normalFile)
	local animation = cc.Animation3D:create(filePath)
	if nil ~= animation then
		print("动画时长: = ", animation:getDuration())
		local animate = cc.Animate3D:createWithFrames(animation, 0, 85)
		animate:setSpeed(0.8)
		sprite:runAction(cc.RepeatForever:create(animate))
	end
	sprite:setCullFaceEnabled(false)
	self.sprite_animal_L = sprite
end
function petViewTest:testNew3dLightSpcularMap()
	self.node_pet:setLocalZOrder(0)
	self.panel_pet:setLocalZOrder(1)
	self.panel_pet:setTouchEnabled(true)
	self.panel_pet:addTouchEventListener(handler(self, self.onLayoutItem))
	self.curYAngle = 0
	local filePath = "3d/normal/009.c3b"
	local sprite3dBumped = cc.Sprite3D:create(filePath)
	sprite3dBumped:setScale(4)
	_ENV = 4
	;(4).x = -150
	;(4).y = -470
	;(4).z = 0
	sprite3dBumped:setPosition3D(4)
	sprite3dBumped:setRotation3D(cc.vec3(0.0, 0.0, 0.0))
	sprite3dBumped:setTexture("3d/normal/aa2_1001_AlbedoTransparency.png")
	self.node_pet:addChild(sprite3dBumped)
	local sprite = sprite3dBumped
	local program = cc.GLProgramCache:getInstance():getGLProgram("3dLightMap")
	if not program then
		program = cc.GLProgram:createWithFilenames("Shaders/3dLightMap.vsh", "Shaders/3dLightMap.fsh")
		cc.GLProgramCache:getInstance():addGLProgram(program, "3dLightMap")
	end
	local state = cc.GLProgramState:create(program)
	sprite:setGLProgramState(state)
	_ENV = program
	program.x = 0
	program.y = 480
	program.z = cc.Director:getInstance():getZEye()
	state:setUniformVec3(program:getUniform("viewPos").location, program)
	_ENV = program
	program.x = 320
	program.y = 480
	program.z = 400
	state:setUniformVec3(program:getUniform("lightPos").location, program)
	state:setUniformInt(program:getUniform("blinn").location, 1)
	state:setUniformFloat(program:getUniform("u_alpha").location, 0.2)
	local sharedTextureCache = cc.Director:getInstance():getTextureCache()
	local imgFile = "3d/normal/aa2_1001_MetallicSmoothness.png"
	local imgTexture = util.addTextureCache(imgFile)
	state:setUniformTexture("specularMap", imgTexture)
	local normalFile = "3d/normal/aa2_1001_Normal.png"
	local normalTexture = util.addTextureCache(normalFile)
	state:setUniformTexture("normalMap", normalTexture)
	local animation = cc.Animation3D:create(filePath)
	if nil ~= animation then
		print("动画时长: = ", animation:getDuration())
		local animate = cc.Animate3D:createWithFrames(animation, 0, 85)
		animate:setSpeed(0.8)
		sprite:runAction(cc.RepeatForever:create(animate))
	end
	sprite:setCullFaceEnabled(false)
	self.sprite_animal_L = sprite
end
function petViewTest:testNew3dSkinedLightSpcularNormalMap()
	print("加载木乃伊---------")
	if self.sprite_animal_R then
		self.sprite_animal_R:removeFromParent()
		self.sprite_animal_R = nil
	end
	self.panel_pet:setLocalZOrder(-2)
	self.panel_pet:setTouchEnabled(true)
	self.panel_pet:addTouchEventListener(handler(self, self.onLayoutItem))
	self.curYAngle = 0
	local filePath = "3d/normal/lion.c3b"
	local sprite3dBumped = cc.Sprite3D:create(filePath)
	sprite3dBumped:setScale(3.0)
	_ENV = 3.0
	;(3.0).x = -50
	;(3.0).y = -380
	;(3.0).z = 0
	sprite3dBumped:setPosition3D(3.0)
	sprite3dBumped:setRotation3D(cc.vec3(0.0, 0.0, 0.0))
	self.node_pet:addChild(sprite3dBumped)
	local sprite = sprite3dBumped
	self.sprite = sprite3dBumped
	print("------------------------------------开始设置shader----------------------------------")
	local spprogram = cc.GLProgramCache:getInstance():getGLProgram("lightSKinedNormalMap")
	if not spprogram then
		spprogram = cc.GLProgram:createWithByteArrays(lightMapNormal3d.vertBytes, lightMapNormal3d.fragBytes)
		cc.GLProgramCache:getInstance():addGLProgram(spprogram, "lightSKinedNormalMap")
	end
	self.equipProgram = spprogram
	local noSpecularProgram = cc.GLProgramCache:getInstance():getGLProgram("noSpecularProgram")
	if not noSpecularProgram then
		noSpecularProgram = cc.GLProgram:createWithByteArrays(lightMapNormal3d.vertBytes, lightMapNormal3d.noSpecularFragBytes)
		cc.GLProgramCache:getInstance():addGLProgram(noSpecularProgram, "noSpecularProgram")
	end
	self.bodyProgram = noSpecularProgram
	local speFile = "3d/normal/gaoguang.png"
	local speTexture = util.addTextureCache(speFile)
	local normalFile = "3d/normal/shenti_n.png"
	local normalTexture = util.addTextureCache(normalFile)
	local speFile_equip = "3d/normal/gaoguang.png"
	local speTexture_equip = util.addTextureCache(speFile_equip)
	local normalFile_equip = "3d/normal/kuijia_n.png"
	local normalTexture_equip = util.addTextureCache(normalFile_equip)
	_ENV = normalFile_equip
	normalFile_equip.x = 0
	local normalFile_equip.y, posPetOffset = 0, normalFile_equip
	local viewPos = self.node_pet:convertToWorldSpace(posPetOffset)
	self.viewPos = viewPos
	_ENV, _ENV, self.viewPos.z = cc.Director:getInstance():getZEye(), self.viewPos, cc.Director:getInstance():getZEye()
	cc.Director:getInstance():getZEye().x = 10000
	cc.Director:getInstance():getZEye().y = 10000
	self.viewPos.lightPos, cc.Director:getInstance():getZEye().z = cc.Director:getInstance():getZEye(), 6000
	_ENV, self.viewPos.brightness = cc.Director:getInstance():getZEye(), 55.0
	cc.Director:getInstance():getZEye().x = 0.26
	cc.Director:getInstance():getZEye().y = 0.26
	_ENV, self.viewPos.lightAmbient, cc.Director:getInstance():getZEye().z = cc.Director:getInstance():getZEye(), cc.Director:getInstance():getZEye(), 0.26
	cc.Director:getInstance():getZEye().x = 0.8
	cc.Director:getInstance():getZEye().y = 0.8
	_ENV, self.viewPos.lightDiffuse, cc.Director:getInstance():getZEye().z = cc.Director:getInstance():getZEye(), cc.Director:getInstance():getZEye(), 0.8
	cc.Director:getInstance():getZEye().x = 0.1
	cc.Director:getInstance():getZEye().y = 0.1
	_ENV, self.viewPos.lightSpecular, cc.Director:getInstance():getZEye().z = cc.Director:getInstance():getZEye(), cc.Director:getInstance():getZEye(), 0.1
	cc.Director:getInstance():getZEye().x = 1.0
	cc.Director:getInstance():getZEye().y = 0.557
	self.viewPos.lightColor, cc.Director:getInstance():getZEye().z = cc.Director:getInstance():getZEye(), 0.32157
	self.viewPos.scale = 3
	self.viewPos.viewPos = self.viewPos
	_ENV, _ENV, self.bodyParam, self.viewPos.normalTexture = self.viewPos, self.viewPos, self.viewPos, normalTexture
	self.viewPos.x = 10000
	self.viewPos.y = 10000
	self.viewPos.lightPos, self.viewPos.z = self.viewPos, 6000
	_ENV, self.viewPos.brightness = self.viewPos, 55.0
	self.viewPos.x = 0.26
	self.viewPos.y = 0.26
	_ENV, self.viewPos.lightAmbient, self.viewPos.z = self.viewPos, self.viewPos, 0.26
	self.viewPos.x = 0.8
	self.viewPos.y = 0.8
	_ENV, self.viewPos.lightDiffuse, self.viewPos.z = self.viewPos, self.viewPos, 0.8
	self.viewPos.x = 1.5
	self.viewPos.y = 1.5
	_ENV, self.viewPos.lightSpecular, self.viewPos.z = self.viewPos, self.viewPos, 1.5
	self.viewPos.x = 1.0
	self.viewPos.y = 0.557
	self.viewPos.lightColor, self.viewPos.z = self.viewPos, 0.32157
	self.viewPos.scale = 3
	self.viewPos.viewPos = self.viewPos
	self.viewPos.speTexture = speTexture_equip
	self.equipParam, self.viewPos.normalTexture = self.viewPos, normalTexture_equip
	local setLightParam = function(program, state, param)
		state:setUniformVec3(program:getUniform("viewPos").location, param.viewPos)
		state:setUniformVec3(program:getUniform("lightPos").location, param.lightPos)
		state:setUniformVec3(program:getUniform("lightColor").location, param.lightColor)
		print("-------program:getUniform(lightAmbient).location", program:getUniform("lightAmbient").location)
		state:setUniformVec3(program:getUniform("lightAmbient").location, param.lightAmbient)
		state:setUniformVec3(program:getUniform("lightDiffuse").location, param.lightDiffuse)
		state:setUniformVec3(program:getUniform("lightSpecular").location, param.lightSpecular)
		state:setUniformFloat(program:getUniform("brightness").location, param.brightness)
		state:setUniformInt(program:getUniform("blinn").location, 1)
		state:setUniformFloat(program:getUniform("u_alpha").location, 0.01)
		if param.speTexture then
			state:setUniformTexture("specularMap", param.speTexture)
		end
		state:setUniformTexture("normalMap", param.normalTexture)
	end
	local bodyState = cc.GLProgramState:create(noSpecularProgram)
	sprite:setGLProgramStateForMesh(bodyState, "d_sttt_polySurface1133")
	setLightParam(noSpecularProgram, bodyState, self.bodyParam)
	local equipState = cc.GLProgramState:create(spprogram)
	sprite:setGLProgramStateForMesh(equipState, "kj_d_polySurface1167")
	setLightParam(spprogram, equipState, self.equipParam)
	self.bodyState = bodyState
	self.equipState = equipState
	local animation = cc.Animation3D:create(filePath)
	if nil ~= animation then
		print("动画时长: = ", animation:getDuration())
		local animate = cc.Animate3D:create(animation)
		animate:setSpeed(0.8)
		sprite:runAction(cc.RepeatForever:create(animate))
	end
	sprite:setCullFaceEnabled(false)
	sprite:setScale(7.5)
	self.sprite_animal_R = sprite
end
function petViewTest:testNew3dSkinedLightSpcularNormalMap_backup()
	print("加载第一种士兵---------")
	if self.sprite_animal_R then
		self.sprite_animal_R:removeFromParent()
		self.sprite_animal_R = nil
	end
	self.node_pet:setLocalZOrder(0)
	self.panel_pet:setLocalZOrder(1)
	self.panel_pet:setTouchEnabled(true)
	self.panel_pet:addTouchEventListener(handler(self, self.onLayoutItem))
	self.curYAngle = 0
	local filePath = "3d/normal/009.c3b"
	local sprite3dBumped = cc.Sprite3D:create(filePath)
	sprite3dBumped:setScale(4.5)
	_ENV = 4.5
	;(4.5).x = 0
	;(4.5).y = -470
	;(4.5).z = 0
	sprite3dBumped:setPosition3D(4.5)
	sprite3dBumped:setRotation3D(cc.vec3(0.0, 0.0, 0.0))
	sprite3dBumped:setTexture("3d/normal/aa2_1001_AlbedoTransparency.png")
	self.node_pet:addChild(sprite3dBumped)
	local sprite = sprite3dBumped
	local program = cc.GLProgramCache:getInstance():getGLProgram("3dSkinedLightMapNormal_noSpecular")
	if not program then
		program = cc.GLProgram:createWithByteArrays(lightMapNormal3d.vertBytes, lightMapNormal3d.fragBytes)
		cc.GLProgramCache:getInstance():addGLProgram(program, "3dSkinedLightMapNormal_noSpecular")
	end
	local state = cc.GLProgramState:create(program)
	sprite:setGLProgramState(state)
	_ENV = program
	program.x = 480
	program.y = 480
	program.z = cc.Director:getInstance():getZEye()
	state:setUniformVec3(program:getUniform("viewPos").location, program)
	_ENV = program
	program.x = 520
	program.y = 480
	program.z = 400
	state:setUniformVec3(program:getUniform("lightPos").location, program)
	_ENV = program
	program.x = 1
	program.y = 1
	program.z = 1
	state:setUniformVec3(program:getUniform("lightColor").location, program)
	state:setUniformInt(program:getUniform("blinn").location, 1)
	state:setUniformFloat(program:getUniform("u_alpha").location, 0.2)
	local sharedTextureCache = cc.Director:getInstance():getTextureCache()
	local imgFile = "3d/normal/aa2_1001_MetallicSmoothness.png"
	local imgTexture = util.addTextureCache(imgFile)
	local normalFile = "3d/normal/aa2_1001_Normal.png"
	local normalTexture = util.addTextureCache(normalFile)
	state:setUniformTexture("normalMap", normalTexture)
	state:setUniformFloat(program:getUniform("brightness").location, 32.0)
	_ENV = program
	program.x = 0.3
	program.y = 0.3
	program.z = 0.3
	state:setUniformVec3(program:getUniform("lightAmbient").location, program)
	_ENV = program
	program.x = 0.8
	program.y = 0.8
	program.z = 0.8
	state:setUniformVec3(program:getUniform("lightDiffuse").location, program)
	_ENV = program
	program.x = 0.3
	program.y = 0.3
	program.z = 0.3
	state:setUniformVec3(program:getUniform("lightSpecular").location, program)
	self.program = program
	self.programState = state
	local animation = cc.Animation3D:create(filePath)
	if nil ~= animation then
		print("动画时长: = ", animation:getDuration())
		local animate = cc.Animate3D:createWithFrames(animation, 0, 85)
		animate:setSpeed(0.8)
		sprite:runAction(cc.RepeatForever:create(animate))
	end
	sprite:setCullFaceEnabled(false)
	self.sprite_animal_R = sprite
end
function petViewTest:testNew3dSkinedLightSpcularNormalMap2()
	if self.sprite_animal_R then
		self.sprite_animal_R:removeFromParent()
		self.sprite_animal_R = nil
	end
	self.node_pet:setLocalZOrder(0)
	self.panel_pet:setLocalZOrder(1)
	self.panel_pet:setTouchEnabled(true)
	self.panel_pet:addTouchEventListener(handler(self, self.onLayoutItem))
	self.curYAngle = 0
	local filePath = "3d/normal/010.c3b"
	local sprite3dBumped = cc.Sprite3D:create(filePath)
	sprite3dBumped:setScale(3.5)
	_ENV = 3.5
	;(3.5).x = 200
	;(3.5).y = -470
	;(3.5).z = 0
	sprite3dBumped:setPosition3D(3.5)
	sprite3dBumped:setRotation3D(cc.vec3(0.0, 0.0, 0.0))
	sprite3dBumped:setTexture("3d/normal/gongzheng_AlbedoTransparency.png")
	self.node_pet:addChild(sprite3dBumped)
	local sprite = sprite3dBumped
	local program = cc.GLProgramCache:getInstance():getGLProgram("3dSkinedLightMapNormal")
	if not program then
		program = cc.GLProgram:createWithByteArrays(lightMapNormal3d.vertBytes, lightMapNormal3d.fragBytes)
		cc.GLProgramCache:getInstance():addGLProgram(program, "3dSkinedLightMapNormal")
	end
	local state = cc.GLProgramState:create(program)
	sprite:setGLProgramState(state)
	_ENV = program
	program.x = 480
	program.y = 480
	program.z = cc.Director:getInstance():getZEye()
	state:setUniformVec3(program:getUniform("viewPos").location, program)
	_ENV = program
	program.x = 520
	program.y = 480
	program.z = 400
	state:setUniformVec3(program:getUniform("lightPos").location, program)
	state:setUniformInt(program:getUniform("blinn").location, 1)
	state:setUniformFloat(program:getUniform("u_alpha").location, 0.2)
	local sharedTextureCache = cc.Director:getInstance():getTextureCache()
	local imgFile = "3d/normal/gongzheng_SpecularSmoothness.png"
	local imgTexture = util.addTextureCache(imgFile)
	state:setUniformTexture("specularMap", imgTexture)
	local normalFile = "3d/normal/gongzheng_Normal.png"
	local normalTexture = util.addTextureCache(normalFile)
	state:setUniformTexture("normalMap", normalTexture)
	local animation = cc.Animation3D:create(filePath)
	if nil ~= animation then
		print("动画时长: = ", animation:getDuration())
		local animate = cc.Animate3D:createWithFrames(animation, 0, 85)
		animate:setSpeed(0.8)
		sprite:runAction(cc.RepeatForever:create(animate))
	end
	sprite:setCullFaceEnabled(false)
	self.sprite_animal_R = sprite
end
function petViewTest:testNew3dSkinedLightSpcularNormalMap3()
	if self.sprite_animal_R then
		self.sprite_animal_R:removeFromParent()
		self.sprite_animal_R = nil
	end
	self.node_pet:setLocalZOrder(0)
	self.panel_pet:setLocalZOrder(1)
	self.panel_pet:setTouchEnabled(true)
	self.panel_pet:addTouchEventListener(handler(self, self.onLayoutItem))
	self.curYAngle = 0
	local filePath = "3d/normal/cyborg/test05.c3b"
	local sprite3dBumped = cc.Sprite3D:create(filePath)
	sprite3dBumped:setScale(4)
	_ENV = 4
	;(4).x = 0
	;(4).y = -470
	;(4).z = 0
	sprite3dBumped:setPosition3D(4)
	sprite3dBumped:setRotation3D(cc.vec3(0.0, 0.0, 0.0))
	sprite3dBumped:setTexture("3d/normal/cyborg/cyborg_diffuse.png")
	self.node_pet:addChild(sprite3dBumped)
	local sprite = sprite3dBumped
	local program = cc.GLProgramCache:getInstance():getGLProgram("3dSkinedLightMapNormal")
	if not program then
		program = cc.GLProgram:createWithByteArrays(lightMapNormal3d.vertBytes, lightMapNormal3d.fragBytes)
		cc.GLProgramCache:getInstance():addGLProgram(program, "3dSkinedLightMapNormal")
	end
	local state = cc.GLProgramState:create(program)
	self.program = program
	self.programState = state
	sprite:setGLProgramState(state)
	_ENV = program
	program.x = 320
	program.y = 480
	program.z = cc.Director:getInstance():getZEye()
	state:setUniformVec3(program:getUniform("viewPos").location, program)
	_ENV = program
	program.x = 520
	program.y = 480
	program.z = 2400
	state:setUniformVec3(program:getUniform("lightPos").location, program)
	_ENV = program
	program.x = 1
	program.y = 1
	program.z = 1
	state:setUniformVec3(program:getUniform("lightColor").location, program)
	state:setUniformInt(program:getUniform("blinn").location, 1)
	state:setUniformFloat(program:getUniform("u_alpha").location, 0.2)
	local sharedTextureCache = cc.Director:getInstance():getTextureCache()
	local imgFile = "3d/normal/cyborg/cyborg_specular.png"
	local imgTexture = util.addTextureCache(imgFile)
	state:setUniformTexture("specularMap", imgTexture)
	local normalFile = "3d/normal/cyborg/cyborg_normal.png"
	local normalTexture = util.addTextureCache(normalFile)
	state:setUniformTexture("normalMap", normalTexture)
	state:setUniformFloat(program:getUniform("brightness").location, 32.0)
	_ENV = program
	program.x = 0.3
	program.y = 0.3
	program.z = 0.3
	state:setUniformVec3(program:getUniform("lightAmbient").location, program)
	_ENV = program
	program.x = 0.8
	program.y = 0.8
	program.z = 0.8
	state:setUniformVec3(program:getUniform("lightDiffuse").location, program)
	_ENV = program
	program.x = 0.3
	program.y = 0.3
	program.z = 0.3
	state:setUniformVec3(program:getUniform("lightSpecular").location, program)
	local animation = cc.Animation3D:create(filePath)
	if nil ~= animation then
		print("动画时长: = ", animation:getDuration())
		local animate = cc.Animate3D:createWithFrames(animation, 0, 85)
		animate:setSpeed(0.8)
		sprite:runAction(cc.RepeatForever:create(animate))
	end
	sprite:setCullFaceEnabled(false)
	self.sprite_animal_R = sprite
end
function petViewTest:testNew3dLightSpcularNormalMap()
	self.node_pet:setLocalZOrder(0)
	self.panel_pet:setLocalZOrder(1)
	self.panel_pet:setTouchEnabled(true)
	self.panel_pet:addTouchEventListener(handler(self, self.onLayoutItem))
	self.curYAngle = 0
	local filePath = "3d/normal/007.c3b"
	local sprite3dBumped = cc.Sprite3D:create(filePath)
	sprite3dBumped:setScale(4)
	_ENV = 4
	;(4).x = 0
	;(4).y = -70
	;(4).z = 0
	sprite3dBumped:setPosition3D(4)
	sprite3dBumped:setRotation3D(cc.vec3(0.0, 0.0, 0.0))
	sprite3dBumped:setTexture("3d/normal/aa2_1001_AlbedoTransparency.png")
	self.node_pet:addChild(sprite3dBumped)
	local sprite = sprite3dBumped
	local program = cc.GLProgramCache:getInstance():getGLProgram("3dLightMapNormal")
	if not program then
		program = cc.GLProgram:createWithFilenames("Shaders/3dLightMapNormal.vsh", "Shaders/3dLightMapNormal.fsh")
		cc.GLProgramCache:getInstance():addGLProgram(program, "3dLightMapNormal")
	end
	local state = cc.GLProgramState:create(program)
	sprite:setGLProgramState(state)
	_ENV = program
	program.x = 0
	program.y = 480
	program.z = cc.Director:getInstance():getZEye()
	state:setUniformVec3(program:getUniform("viewPos").location, program)
	_ENV = program
	program.x = 320
	program.y = 480
	program.z = 400
	state:setUniformVec3(program:getUniform("lightPos").location, program)
	state:setUniformInt(program:getUniform("blinn").location, 0)
	state:setUniformFloat(program:getUniform("u_alpha").location, 0.2)
	local sharedTextureCache = cc.Director:getInstance():getTextureCache()
	local imgFile = "3d/normal/aa2_1001_MetallicSmoothness.png"
	local imgTexture = util.addTextureCache(imgFile)
	state:setUniformTexture("specularMap", imgTexture)
	local normalFile = "3d/normal/aa2_1001_Normal.png"
	local normalTexture = util.addTextureCache(normalFile)
	state:setUniformTexture("normalMap", normalTexture)
	local animation = cc.Animation3D:create(filePath)
	if nil ~= animation then
		print("动画时长: = ", animation:getDuration())
		local animate = cc.Animate3D:createWithFrames(animation, 0, 85)
		animate:setSpeed(0.8)
		sprite:runAction(cc.RepeatForever:create(animate))
	end
	sprite:setCullFaceEnabled(false)
	self.sprite_animal = sprite
end
function petViewTest:test3dUnlight()
	self.node_pet:setLocalZOrder(0)
	self.panel_pet:setLocalZOrder(0)
	self.panel_pet:setTouchEnabled(true)
	self.panel_pet:addTouchEventListener(handler(self, self.onLayoutItem))
	self.curYAngle = 0
	local filePath = "3d/normal/et_shizitest_04.c3b"
	local sprite3dBumped = cc.Sprite3D:create(filePath)
	sprite3dBumped:setScale(4)
	_ENV = 4
	;(4).x = 800
	;(4).y = -450
	;(4).z = 0
	sprite3dBumped:setPosition3D(4)
	sprite3dBumped:setRotation3D(cc.vec3(0.0, 0.0, 0.0))
	self.node_pet:addChild(sprite3dBumped)
	local sprite = sprite3dBumped
	local program = cc.GLProgramCache:getInstance():getGLProgram("3dunlight")
	if not program then
		program = cc.GLProgram:createWithFilenames("Shaders/normal3D.vsh", "Shaders/3dunlight.fsh")
		cc.GLProgramCache:getInstance():addGLProgram(program, "3dunlight")
	end
	local state = cc.GLProgramState:create(program)
	sprite:setGLProgramState(state)
	state:setUniformFloat("u_alpha", 0.5)
	sprite:setCullFaceEnabled(true)
	local animation = cc.Animation3D:create(filePath)
	if nil ~= animation then
		print("动画时长: = ", animation:getDuration())
		local animate = cc.Animate3D:createWithFrames(animation, 0, 85)
		animate:setSpeed(0.8)
		sprite:runAction(cc.RepeatForever:create(animate))
	end
	sprite:setCullFaceEnabled(false)
	self.sprite_animal = sprite
end
function petViewTest:test3dLightSpcularMap()
	self.node_pet:setLocalZOrder(0)
	self.panel_pet:setLocalZOrder(1)
	self.panel_pet:setTouchEnabled(true)
	self.panel_pet:addTouchEventListener(handler(self, self.onLayoutItem))
	self.curYAngle = 0
	local filePath = "3d/normal/cyborg/cyborg.obj"
	local sprite3dBumped = cc.Sprite3D:create(filePath)
	sprite3dBumped:setScale(180)
	_ENV = 180
	;(180).x = -150
	;(180).y = -450
	;(180).z = 0
	sprite3dBumped:setPosition3D(180)
	sprite3dBumped:setRotation3D(cc.vec3(0.0, 0.0, 0.0))
	self.node_pet:addChild(sprite3dBumped)
	local sprite = sprite3dBumped
	local program = cc.GLProgramCache:getInstance():getGLProgram("3dLightMap")
	if not program then
		program = cc.GLProgram:createWithFilenames("Shaders/3dLightMap.vsh", "Shaders/3dLightMap.fsh")
		cc.GLProgramCache:getInstance():addGLProgram(program, "3dLightMap")
	end
	local state = cc.GLProgramState:create(program)
	sprite:setGLProgramState(state)
	_ENV = program
	program.x = 0
	program.y = 480
	program.z = cc.Director:getInstance():getZEye()
	state:setUniformVec3(program:getUniform("viewPos").location, program)
	_ENV = program
	program.x = 320
	program.y = 480
	program.z = 1000
	state:setUniformVec3(program:getUniform("lightPos").location, program)
	state:setUniformInt(program:getUniform("blinn").location, 1)
	state:setUniformFloat(program:getUniform("u_alpha").location, 0.2)
	local sharedTextureCache = cc.Director:getInstance():getTextureCache()
	local imgFile = "3d/normal/cyborg/cyborg_specular.png"
	local imgTexture = util.addTextureCache(imgFile)
	state:setUniformTexture("specularMap", imgTexture)
	local animation = cc.Animation3D:create(filePath)
	if nil ~= animation then
		print("动画时长: = ", animation:getDuration())
		local animate = cc.Animate3D:createWithFrames(animation, 0, 85)
		animate:setSpeed(0.8)
		sprite:runAction(cc.RepeatForever:create(animate))
	end
	sprite:setCullFaceEnabled(false)
	self.sprite_animal = sprite
end
function petViewTest:test3dLightSpcularNormalMap()
	self.node_pet:setLocalZOrder(0)
	self.panel_pet:setLocalZOrder(1)
	self.panel_pet:setTouchEnabled(true)
	self.panel_pet:addTouchEventListener(handler(self, self.onLayoutItem))
	self.curYAngle = 0
	local filePath = "3d/normal/cyborg/cyborg.obj"
	local sprite3dBumped = cc.Sprite3D:create(filePath)
	sprite3dBumped:setScale(180)
	_ENV = 180
	;(180).x = 150
	;(180).y = -450
	;(180).z = 0
	sprite3dBumped:setPosition3D(180)
	sprite3dBumped:setRotation3D(cc.vec3(0.0, 0.0, 0.0))
	self.node_pet:addChild(sprite3dBumped)
	local sprite = sprite3dBumped
	local program = cc.GLProgramCache:getInstance():getGLProgram("3dLightMapNormal")
	if not program then
		program = cc.GLProgram:createWithFilenames("Shaders/3dLightMapNormal.vsh", "Shaders/3dLightMapNormal.fsh")
		cc.GLProgramCache:getInstance():addGLProgram(program, "3dLightMapNormal")
	end
	local state = cc.GLProgramState:create(program)
	sprite:setGLProgramState(state)
	_ENV = program
	program.x = 0
	program.y = 480
	program.z = cc.Director:getInstance():getZEye()
	state:setUniformVec3(program:getUniform("viewPos").location, program)
	_ENV = program
	program.x = 320
	program.y = 480
	program.z = 1000
	state:setUniformVec3(program:getUniform("lightPos").location, program)
	state:setUniformInt(program:getUniform("blinn").location, 1)
	local sharedTextureCache = cc.Director:getInstance():getTextureCache()
	local imgFile = "3d/normal/cyborg/cyborg_specular.png"
	local imgTexture = util.addTextureCache(imgFile)
	state:setUniformTexture("specularMap", imgTexture)
	local normalFile = "3d/normal/cyborg/cyborg_normal.png"
	local normalTexture = util.addTextureCache(normalFile)
	state:setUniformTexture("normalMap", normalTexture)
	local animation = cc.Animation3D:create(filePath)
	if nil ~= animation then
		print("动画时长: = ", animation:getDuration())
		local animate = cc.Animate3D:createWithFrames(animation, 0, 85)
		animate:setSpeed(0.8)
		sprite:runAction(cc.RepeatForever:create(animate))
	end
	sprite:setCullFaceEnabled(false)
	self.sprite_animal = sprite
end
function petViewTest:test3dLightMap()
	self.node_pet:setLocalZOrder(0)
	self.panel_pet:setLocalZOrder(1)
	self.panel_pet:setTouchEnabled(true)
	self.panel_pet:addTouchEventListener(handler(self, self.onLayoutItem))
	self.curYAngle = 0
	local filePath = "3d/normal/damojiaoyan.c3b"
	local sprite3dBumped = cc.Sprite3D:create(filePath)
	sprite3dBumped:setScale(4)
	_ENV = 4
	;(4).x = 90
	;(4).y = -500
	;(4).z = 0
	sprite3dBumped:setPosition3D(4)
	sprite3dBumped:setRotation3D(cc.vec3(90.0, 0.0, 0.0))
	sprite3dBumped:setTexture("3d/normal/aa2_1001_AlbedoTransparency.png")
	self.node_pet:addChild(sprite3dBumped)
	local sprite = sprite3dBumped
	local program = cc.GLProgramCache:getInstance():getGLProgram("3dLightMap")
	if not program then
		program = cc.GLProgram:createWithFilenames("Shaders/3dLightMap.vsh", "Shaders/3dLightMap.fsh")
		cc.GLProgramCache:getInstance():addGLProgram(program, "3dLightMap")
	end
	local state = cc.GLProgramState:create(program)
	sprite:setGLProgramState(state)
	_ENV = program
	program.x = 0
	program.y = 480
	program.z = cc.Director:getInstance():getZEye()
	state:setUniformVec3(program:getUniform("viewPos").location, program)
	_ENV = program
	program.x = 320
	program.y = 480
	program.z = 100
	state:setUniformVec3(program:getUniform("lightPos").location, program)
	_ENV = program
	program.x = 1
	program.y = 1
	program.z = 1
	state:setUniformVec3(program:getUniform("lightColor").location, program)
	state:setUniformInt(program:getUniform("blinn").location, 1)
	state:setUniformFloat("u_alpha", 0.2)
	sprite:setScaleY(-4)
	local animation = cc.Animation3D:create(filePath)
	if nil ~= animation then
		print("动画时长: = ", animation:getDuration())
		local animate = cc.Animate3D:createWithFrames(animation, 0, 85)
		animate:setSpeed(0.8)
		sprite:runAction(cc.RepeatForever:create(animate))
	end
	sprite:setCullFaceEnabled(false)
	self.sprite_animal = sprite
end
function petViewTest:test3dLightMapWithNormal()
	self.node_pet:setLocalZOrder(0)
	self.panel_pet:setLocalZOrder(1)
	self.panel_pet:setTouchEnabled(true)
	self.panel_pet:addTouchEventListener(handler(self, self.onLayoutItem))
	self.curYAngle = 0
	local filePath = "3d/normal/damojiaoyan.c3b"
	local sprite3dBumped = cc.Sprite3D:create(filePath)
	sprite3dBumped:setScale(4)
	_ENV = 4
	;(4).x = 90
	;(4).y = -500
	;(4).z = 0
	sprite3dBumped:setPosition3D(4)
	sprite3dBumped:setRotation3D(cc.vec3(90.0, 0.0, 0.0))
	sprite3dBumped:setTexture("3d/normal/aa2_1001_AlbedoTransparency.png")
	self.node_pet:addChild(sprite3dBumped)
	local sprite = sprite3dBumped
	local program = cc.GLProgramCache:getInstance():getGLProgram("baoziEquip")
	if not program then
		program = cc.GLProgram:createWithFilenames("Shaders/3dLightMap.vsh", "Shaders/3dLightMap.fsh")
		cc.GLProgramCache:getInstance():addGLProgram(program, "baoziEquip")
	end
	local state = cc.GLProgramState:create(program)
	sprite:setGLProgramState(state)
	_ENV = program
	program.x = 0
	program.y = 480
	program.z = cc.Director:getInstance():getZEye()
	state:setUniformVec3(program:getUniform("viewPos").location, program)
	_ENV = program
	program.x = 320
	program.y = 480
	program.z = 100
	state:setUniformVec3(program:getUniform("lightPos").location, program)
	_ENV = program
	program.x = 1
	program.y = 1
	program.z = 1
	state:setUniformVec3(program:getUniform("lightColor").location, program)
	sprite:setScaleY(-4)
	local animation = cc.Animation3D:create(filePath)
	if nil ~= animation then
		print("动画时长: = ", animation:getDuration())
		local animate = cc.Animate3D:createWithFrames(animation, 0, 85)
		animate:setSpeed(0.8)
		sprite:runAction(cc.RepeatForever:create(animate))
	end
	sprite:setCullFaceEnabled(false)
	self.sprite_animal = sprite
end
function petViewTest:testNormal()
	local sprite3dBumped = cc.Sprite3D:create("3d/sphere_bumped.c3b")
	sprite3dBumped:setScale(80)
	_ENV = 80
	;(80).x = 100
	;(80).y = 0
	;(80).z = 1
	sprite3dBumped:setPosition3D(80)
	sprite3dBumped:setRotation3D(cc.vec3(90.0, 0.0, 0.0))
	sprite3dBumped:setTexture("3d/brickwork-texture.jpg")
	self.node_pet:addChild(sprite3dBumped)
	sprite3dBumped:setLightMask(1)
	local radius = 500.0
	local angle = 0.0
	local reverseDir = false
	local light = cc.PointLight:create(cc.vec3(0.0, 800.0, 0.0), cc.c3b(255, 255, 255), 1000.0)
	local lightUpdate = function()
		light:setPosition3D(cc.vec3(radius * math.cos(angle), 800.0, radius * math.sin(angle)))
		if reverseDir == true then
			if angle < 0.0 then
			end
		elseif 3.14159 < angle then
		end
	end
	local seq = cc.Sequence:create(cc.CallFunc:create(lightUpdate))
	light:runAction(cc.RepeatForever:create(seq))
	light:setLightFlag(1)
	self:addChild(light)
end
function petViewTest:testBtn()
	self.btnTestOri:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended then
			print("点击了原始的测试按钮")
		end
	end)
	self.node_pet:setLocalZOrder(0)
	self.panel_pet:setLocalZOrder(1)
	self.panel_pet:addTouchEventListener(handler(self, self.onLayoutItem))
	self.curYAngle = 0
	self:initWithData()
	local btnTest = ccui.Button:create()
	btnTest:loadTextures("btn_green_normal_01.png", "", "", ccui.TextureResType.plistType)
	btnTest:setButtonType(ccui.ButtonType.TRISTATE)
	btnTest:setPressedColor(cc.c3b(120, 120, 120))
	btnTest:setContentSize(cc.size(216, 272))
	self:addChild(btnTest)
	btnTest:setPosition(cc.p(200, 284))
	btnTest:setLocalZOrder(3)
	self.btnTest = btnTest
	self.btnTest:setTitleFontSize(24)
	self.btnTest:setTitleText("测试")
	self.btnTest:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended then
			print("点击了测试按钮")
		end
	end)
	local btnToggle = ccui.Button:create()
	btnToggle:loadTextures("btn_green_normal_01.png", "", "", ccui.TextureResType.plistType)
	btnToggle:setButtonType(ccui.ButtonType.TRISTATE)
	btnToggle:setContentSize(cc.size(216, 272))
	self:addChild(btnToggle)
	btnToggle:setPosition(cc.p(500, 284))
	btnToggle:setLocalZOrder(3)
	self.btnToggle = btnToggle
	self.btnToggle:setTitleFontSize(24)
	self.btnToggle:setTitleText("切换灰态")
	self.btnToggle:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended then
			print("点击了切换按钮-----------")
			self.btnTest:setTouchEnabled(not self.btnTest:isTouchEnabled())
			self.btnTest:setBright(self.btnTest:isTouchEnabled())
			self.btnTestOri:setTouchEnabled(not self.btnTestOri:isTouchEnabled())
		end
	end)
end
function petViewTest:addEffect()
end
function petViewTest:initWithData()
end
function petViewTest:loadEagle()
	local petDesRead = include("petDesRead")
	local petEagleCfg = petDesRead.getPetCfg(1253, 4)
	dump(petEagleCfg, "老鹰配置", 10)
	self.curYAngle = 0
	local filePath = petEagleCfg.file
	filePath = "3d/pet/eagle/et_eagle04.c3b"
	local x = 320
	local y = 650
	local sprite = cc.Sprite3D:create(filePath)
	sprite:setScale(4)
	_ENV = 4
	;(4).x = 0
	;(4).y = 0
	;(4).z = 0
	sprite:setRotation3D(4)
	_ENV = 4
	;(4).x = 0
	;(4).y = -100
	;(4).z = 1
	sprite:setPosition3D(4)
	sprite:addTo(self.node_pet)
	local animation = cc.Animation3D:create(filePath)
	if nil ~= animation then
		print("idle: start = " .. petEagleCfg.idle.startFrame .. ", end = ", petEagleCfg.idle.endFrame)
		print("动画时长: = ", animation:getDuration())
		local animate = cc.Animate3D:createWithFrames(animation, 0, 85)
		animate:setSpeed(0.8)
		sprite:runAction(cc.RepeatForever:create(animate))
	end
	sprite:setCullFaceEnabled(false)
	sprite:setScale(4)
	self.sprite_animal = sprite
	print("bone Bip001 Spine", sprite:getAttachNode("Bip001 Spine"))
	_UPVALUE2_ = sprite:getAttachNode("Bip001 Spine")
	sprite:getAttachNode("Bip001 Spine")[1] = "common"
	sprite:getAttachNode("Bip001 Spine")[2] = "show"
	SoraDCreatePuEffectGroups(sprite, sprite:getAttachNode("Bip001 Spine"))
end
function petViewTest:loadLeopard()
	local petDesRead = include("petDesRead")
	local petEagleCfg = petDesRead.getPetCfg(1253, 4)
	self.curYAngle = 0
	local filePath = petEagleCfg.file
	filePath = "3d/pet/leopard/et_leopard03.c3b"
	local x = 320
	local y = 650
	local sprite = cc.Sprite3D:create(filePath)
	_ENV = nil
	;(nil).x = 0
	;(nil).y = 0
	;(nil).z = 0
	sprite:setRotation3D(nil)
	_ENV = nil
	;(nil).x = 0
	;(nil).y = -100
	;(nil).z = 1
	sprite:setPosition3D(nil)
	sprite:addTo(self.node_pet)
	local animation = cc.Animation3D:create(filePath)
	if nil ~= animation then
		print("idle: start = " .. petEagleCfg.idle.startFrame .. ", end = ", petEagleCfg.idle.endFrame)
		print("动画时长: = ", animation:getDuration())
		local animate = cc.Animate3D:createWithFrames(animation, 0, 58)
		animate:setSpeed(0.8)
		sprite:runAction(cc.RepeatForever:create(animate))
	end
	sprite:setCullFaceEnabled(false)
	sprite:setScale(4)
	self.sprite_animal = sprite
	local noiseTexture = util.addTextureCache("3d/pet/leopard/leoparduv.png")
	local maskTexture = util.addTextureCache("3d/pet/leopard/leopard03_mask.png")
	local program = cc.GLProgramCache:getInstance():getGLProgram("baoziEquip")
	if not program then
		program = cc.GLProgram:createWithFilenames("Shaders/3dPositionTex.vsh", "Shaders/3dColorTexAcnm.fsh")
		cc.GLProgramCache:getInstance():addGLProgram(program, "baoziEquip")
	end
	local state = cc.GLProgramState:create(program)
	sprite:setGLProgramStateForMesh(state, "3-2")
	state:setUniformTexture("noise", noiseTexture)
	state:setUniformTexture("mask", maskTexture)
	state:setUniformFloat(program:getUniform("u_alpha").location, 0.5)
end
function petViewTest:onLayoutItem(target, event)
	if event == ccui.TouchEventType.ended then
		self.curYAngle = self.sprite:getRotation3D().y
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = math.abs(touchmovePoint.x - touchBeganPoint.x)
		local degree = distance / 320 * 270
		if touchmovePoint.x - touchBeganPoint.x < 0 then
			degree = -degree
		end
		if math.abs(degree) > 1 and self.sprite then
			_ENV = nil
			;(nil).x = 0
			;(nil).y = self.curYAngle + degree
			;(nil).z = 0
			self.sprite:setRotation3D(nil)
		end
	elseif event == ccui.TouchEventType.canceled then
		self.curYAngle = self.sprite:getRotation3D().y
	elseif event == ccui.TouchEventType.began then
	end
end
function petViewTest:onTouchL(target, event)
	if not self.sprite_animal_L then
		return
	end
	if event == ccui.TouchEventType.ended then
		self.curYAngle = self.sprite_animal_L:getRotation3D().y
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = math.abs(touchmovePoint.x - touchBeganPoint.x)
		local degree = distance / 320 * 270
		if touchmovePoint.x - touchBeganPoint.x < 0 then
			degree = -degree
		end
		if math.abs(degree) > 1 and self.sprite_animal_L then
			_ENV = nil
			;(nil).x = 0
			;(nil).y = self.curYAngle + degree
			;(nil).z = 0
			self.sprite_animal_L:setRotation3D(nil)
		end
	elseif event == ccui.TouchEventType.canceled then
		self.curYAngle = self.sprite_animal_L:getRotation3D().y
	elseif event == ccui.TouchEventType.began then
	end
end
_ENV, petViewTest.onTouchR = function(self, target, event)
	if event == ccui.TouchEventType.ended then
		self.curYAngle = self.sprite_animal_R:getRotation3D().y
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = math.abs(touchmovePoint.x - touchBeganPoint.x)
		local degree = distance / 320 * 270
		if touchmovePoint.x - touchBeganPoint.x < 0 then
			degree = -degree
		end
		if math.abs(degree) > 1 and self.sprite_animal_R then
			_ENV = nil
			;(nil).x = 0
			;(nil).y = self.curYAngle + degree
			;(nil).z = 0
			self.sprite_animal_R:setRotation3D(nil)
		end
	elseif event == ccui.TouchEventType.canceled then
		self.curYAngle = self.sprite_animal_R:getRotation3D().y
	elseif event == ccui.TouchEventType.began then
	end
end, function(self, target, event)
	if event == ccui.TouchEventType.ended then
		self.curYAngle = self.sprite_animal_R:getRotation3D().y
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = math.abs(touchmovePoint.x - touchBeganPoint.x)
		local degree = distance / 320 * 270
		if touchmovePoint.x - touchBeganPoint.x < 0 then
			degree = -degree
		end
		if math.abs(degree) > 1 and self.sprite_animal_R then
			_ENV = nil
			;(nil).x = 0
			;(nil).y = self.curYAngle + degree
			;(nil).z = 0
			self.sprite_animal_R:setRotation3D(nil)
		end
	elseif event == ccui.TouchEventType.canceled then
		self.curYAngle = self.sprite_animal_R:getRotation3D().y
	elseif event == ccui.TouchEventType.began then
	end
end
;(function(self, target, event)
	if event == ccui.TouchEventType.ended then
		self.curYAngle = self.sprite_animal_R:getRotation3D().y
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = math.abs(touchmovePoint.x - touchBeganPoint.x)
		local degree = distance / 320 * 270
		if touchmovePoint.x - touchBeganPoint.x < 0 then
			degree = -degree
		end
		if math.abs(degree) > 1 and self.sprite_animal_R then
			_ENV = nil
			;(nil).x = 0
			;(nil).y = self.curYAngle + degree
			;(nil).z = 0
			self.sprite_animal_R:setRotation3D(nil)
		end
	elseif event == ccui.TouchEventType.canceled then
		self.curYAngle = self.sprite_animal_R:getRotation3D().y
	elseif event == ccui.TouchEventType.began then
	end
end).NO_LIGHT = 1
;(function(self, target, event)
	if event == ccui.TouchEventType.ended then
		self.curYAngle = self.sprite_animal_R:getRotation3D().y
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = math.abs(touchmovePoint.x - touchBeganPoint.x)
		local degree = distance / 320 * 270
		if touchmovePoint.x - touchBeganPoint.x < 0 then
			degree = -degree
		end
		if math.abs(degree) > 1 and self.sprite_animal_R then
			_ENV = nil
			;(nil).x = 0
			;(nil).y = self.curYAngle + degree
			;(nil).z = 0
			self.sprite_animal_R:setRotation3D(nil)
		end
	elseif event == ccui.TouchEventType.canceled then
		self.curYAngle = self.sprite_animal_R:getRotation3D().y
	elseif event == ccui.TouchEventType.began then
	end
end).LIGHT = 2
;(function(self, target, event)
	if event == ccui.TouchEventType.ended then
		self.curYAngle = self.sprite_animal_R:getRotation3D().y
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = math.abs(touchmovePoint.x - touchBeganPoint.x)
		local degree = distance / 320 * 270
		if touchmovePoint.x - touchBeganPoint.x < 0 then
			degree = -degree
		end
		if math.abs(degree) > 1 and self.sprite_animal_R then
			_ENV = nil
			;(nil).x = 0
			;(nil).y = self.curYAngle + degree
			;(nil).z = 0
			self.sprite_animal_R:setRotation3D(nil)
		end
	elseif event == ccui.TouchEventType.canceled then
		self.curYAngle = self.sprite_animal_R:getRotation3D().y
	elseif event == ccui.TouchEventType.began then
	end
end).SPEC_LIGHT = 3
;(function(self, target, event)
	if event == ccui.TouchEventType.ended then
		self.curYAngle = self.sprite_animal_R:getRotation3D().y
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = math.abs(touchmovePoint.x - touchBeganPoint.x)
		local degree = distance / 320 * 270
		if touchmovePoint.x - touchBeganPoint.x < 0 then
			degree = -degree
		end
		if math.abs(degree) > 1 and self.sprite_animal_R then
			_ENV = nil
			;(nil).x = 0
			;(nil).y = self.curYAngle + degree
			;(nil).z = 0
			self.sprite_animal_R:setRotation3D(nil)
		end
	elseif event == ccui.TouchEventType.canceled then
		self.curYAngle = self.sprite_animal_R:getRotation3D().y
	elseif event == ccui.TouchEventType.began then
	end
end).SPECMAP_LIGHT = 4
;(function(self, target, event)
	if event == ccui.TouchEventType.ended then
		self.curYAngle = self.sprite_animal_R:getRotation3D().y
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = math.abs(touchmovePoint.x - touchBeganPoint.x)
		local degree = distance / 320 * 270
		if touchmovePoint.x - touchBeganPoint.x < 0 then
			degree = -degree
		end
		if math.abs(degree) > 1 and self.sprite_animal_R then
			_ENV = nil
			;(nil).x = 0
			;(nil).y = self.curYAngle + degree
			;(nil).z = 0
			self.sprite_animal_R:setRotation3D(nil)
		end
	elseif event == ccui.TouchEventType.canceled then
		self.curYAngle = self.sprite_animal_R:getRotation3D().y
	elseif event == ccui.TouchEventType.began then
	end
end).LIGHT_NORMAL = 5
;(function(self, target, event)
	if event == ccui.TouchEventType.ended then
		self.curYAngle = self.sprite_animal_R:getRotation3D().y
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = math.abs(touchmovePoint.x - touchBeganPoint.x)
		local degree = distance / 320 * 270
		if touchmovePoint.x - touchBeganPoint.x < 0 then
			degree = -degree
		end
		if math.abs(degree) > 1 and self.sprite_animal_R then
			_ENV = nil
			;(nil).x = 0
			;(nil).y = self.curYAngle + degree
			;(nil).z = 0
			self.sprite_animal_R:setRotation3D(nil)
		end
	elseif event == ccui.TouchEventType.canceled then
		self.curYAngle = self.sprite_animal_R:getRotation3D().y
	elseif event == ccui.TouchEventType.began then
	end
end).SPEC_LIGHT_NORMAL = 6
;(function(self, target, event)
	if event == ccui.TouchEventType.ended then
		self.curYAngle = self.sprite_animal_R:getRotation3D().y
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = math.abs(touchmovePoint.x - touchBeganPoint.x)
		local degree = distance / 320 * 270
		if touchmovePoint.x - touchBeganPoint.x < 0 then
			degree = -degree
		end
		if math.abs(degree) > 1 and self.sprite_animal_R then
			_ENV = nil
			;(nil).x = 0
			;(nil).y = self.curYAngle + degree
			;(nil).z = 0
			self.sprite_animal_R:setRotation3D(nil)
		end
	elseif event == ccui.TouchEventType.canceled then
		self.curYAngle = self.sprite_animal_R:getRotation3D().y
	elseif event == ccui.TouchEventType.began then
	end
end).SPECMAP_NORMAL = 7
local _ENV, (function(self, target, event)
	if event == ccui.TouchEventType.ended then
		self.curYAngle = self.sprite_animal_R:getRotation3D().y
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = math.abs(touchmovePoint.x - touchBeganPoint.x)
		local degree = distance / 320 * 270
		if touchmovePoint.x - touchBeganPoint.x < 0 then
			degree = -degree
		end
		if math.abs(degree) > 1 and self.sprite_animal_R then
			_ENV = nil
			;(nil).x = 0
			;(nil).y = self.curYAngle + degree
			;(nil).z = 0
			self.sprite_animal_R:setRotation3D(nil)
		end
	elseif event == ccui.TouchEventType.canceled then
		self.curYAngle = self.sprite_animal_R:getRotation3D().y
	elseif event == ccui.TouchEventType.began then
	end
end).NO_SKIN_NO_LIGHT, SHADER_TYPE = function(target)
	if target == nil then
		return SoraDCreateBasePanel("petViewTest")
	end
	return target
end, 8, function(self, target, event)
	if event == ccui.TouchEventType.ended then
		self.curYAngle = self.sprite_animal_R:getRotation3D().y
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = math.abs(touchmovePoint.x - touchBeganPoint.x)
		local degree = distance / 320 * 270
		if touchmovePoint.x - touchBeganPoint.x < 0 then
			degree = -degree
		end
		if math.abs(degree) > 1 and self.sprite_animal_R then
			_ENV = nil
			;(nil).x = 0
			;(nil).y = self.curYAngle + degree
			;(nil).z = 0
			self.sprite_animal_R:setRotation3D(nil)
		end
	elseif event == ccui.TouchEventType.canceled then
		self.curYAngle = self.sprite_animal_R:getRotation3D().y
	elseif event == ccui.TouchEventType.began then
	end
end
_ENV = nil
;(nil).title = "无光照"
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("petViewTest")
	end
	return target
end)[SHADER_TYPE.NO_LIGHT], (nil).func = nil, "getOrCreateNoLight"
_ENV = nil
;(nil).title = "普通光照"
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("petViewTest")
	end
	return target
end)[SHADER_TYPE.LIGHT], (nil).func = nil, "getOrCreateLight"
_ENV = nil
;(nil).title = "高光"
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("petViewTest")
	end
	return target
end)[SHADER_TYPE.SPEC_LIGHT], (nil).func = nil, "getOrCreateSpecLight"
_ENV = nil
;(nil).title = "高光图"
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("petViewTest")
	end
	return target
end)[SHADER_TYPE.SPECMAP_LIGHT], (nil).func = nil, "getOrCreateSpecMapLight"
_ENV = nil
;(nil).title = "普通光照+法线贴图"
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("petViewTest")
	end
	return target
end)[SHADER_TYPE.LIGHT_NORMAL], (nil).func = nil, "getOrCreateLightNormal"
_ENV = nil
;(nil).title = "高光+法线贴图"
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("petViewTest")
	end
	return target
end)[SHADER_TYPE.SPEC_LIGHT_NORMAL], (nil).func = nil, "getOrCreateSpecLightNormal"
_ENV = nil
;(nil).title = "高光图+法线图"
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("petViewTest")
	end
	return target
end)[SHADER_TYPE.SPECMAP_NORMAL], (nil).func = nil, "getOrCreateSpecMapNormal"
_ENV = nil
;(nil).title = "无骨骼+无光照"
;(function(target)
	if target == nil then
		return SoraDCreateBasePanel("petViewTest")
	end
	return target
end)[SHADER_TYPE.NO_SKIN_NO_LIGHT], (nil).func = nil, "getOrCreateNoSkinNoLight"
local function LShaderTypeCfg(target)
	if target == nil then
		return SoraDCreateBasePanel("petViewTest")
	end
	return target
end
function petViewTest:getOrCreateNoLight()
	local shaderName = "SHADER_TYPE_NO_LIGHT"
	local program = cc.GLProgramCache:getInstance():getGLProgram(shaderName)
	if not program then
		program = cc.GLProgram:createWithFilenames("Shaders/3dPositionTex.vsh", "Shaders/3dColorTexAlphaCutout.fsh")
		cc.GLProgramCache:getInstance():addGLProgram(program, "shaderName")
	end
	return program
end
function petViewTest:getOrCreateNoSkinNoLight()
	local shaderName = "NO_SKIN_NO_LIGHT"
	local program = cc.GLProgramCache:getInstance():getGLProgram(shaderName)
	if not program then
		program = cc.GLProgram:createWithByteArrays(lightMap3d.noSkinNoLightvsh, lightMap3d.nlAplphaCutOut)
		cc.GLProgramCache:getInstance():addGLProgram(program, "shaderName")
	end
	return program
end
function petViewTest:getOrCreateLight()
	local shaderName = "SHADER_TYPE_LIGHT"
	local program = cc.GLProgramCache:getInstance():getGLProgram(shaderName)
	if not program then
		program = cc.GLProgram:createWithByteArrays(lightMap3d.vertBytes, lightMap3d.noSpecularFragBytes)
		cc.GLProgramCache:getInstance():addGLProgram(program, shaderName)
	end
	return program
end
function petViewTest:getOrCreateSpecLight()
	local shaderName = "SHADER_TYPE_SPEC_LIGHT"
	local program = cc.GLProgramCache:getInstance():getGLProgram(shaderName)
	if not program then
		program = cc.GLProgram:createWithByteArrays(lightMap3d.vertBytes, lightMap3d.specularFragBytes)
		cc.GLProgramCache:getInstance():addGLProgram(program, shaderName)
	end
	return program
end
function petViewTest:getOrCreateSpecMapLight()
	local shaderName = "SHADER_TYPE_SPECMAP_LIGHT"
	local program = cc.GLProgramCache:getInstance():getGLProgram(shaderName)
	if not program then
		program = cc.GLProgram:createWithByteArrays(lightMap3d.vertBytes, lightMap3d.specularMapFragBytes)
		cc.GLProgramCache:getInstance():addGLProgram(program, shaderName)
	end
	return program
end
function petViewTest:getOrCreateLightNormal()
	local shaderName = "SHADER_TYPE_SPECMAP_LIGHT_NORMAL"
	local program = cc.GLProgramCache:getInstance():getGLProgram(shaderName)
	if not program then
		program = cc.GLProgram:createWithByteArrays(lightMapNormal3d.vertBytes, lightMapNormal3d.noSpecularFragBytes)
		cc.GLProgramCache:getInstance():addGLProgram(program, shaderName)
	end
	return program
end
function petViewTest:getOrCreateSpecLightNormal()
	local shaderName = "SHADER_TYPE_SPECMAP_SPEC_LIGHT_NORMAL"
	local program = cc.GLProgramCache:getInstance():getGLProgram(shaderName)
	if not program then
		program = cc.GLProgram:createWithByteArrays(lightMapNormal3d.vertBytes, lightMapNormal3d.noSpecularMapFragBytes)
		cc.GLProgramCache:getInstance():addGLProgram(program, shaderName)
	end
	return program
end
function petViewTest:getOrCreateSpecMapNormal()
	local shaderName = "SHADER_TYPE_SPECMAP_SPECMAP_NORMAL"
	local program = cc.GLProgramCache:getInstance():getGLProgram(shaderName)
	if not program then
		program = cc.GLProgram:createWithByteArrays(lightMapNormal3d.vertBytes, lightMapNormal3d.fragBytes)
		cc.GLProgramCache:getInstance():addGLProgram(program, shaderName)
	end
	return program
end
function petViewTest:getOrCreateByShaderType(shaderType)
	local shaderTypeCfg = LShaderTypeCfg[shaderType]
	local funcName = shaderTypeCfg.func
	local func = self[funcName]
	if func then
		return func(self)
	end
end
function petViewTest:createSprite3DByCfg(cfg)
	if self.sprite then
		self.sprite:removeFromParent()
	end
	local filePath = cfg.filePath
	local sprite = cc.Sprite3D:create(filePath)
	sprite:setScale(cfg.scale or 1)
	if not cfg.pos3D then
		_ENV = cfg.pos3D
		cfg.pos3D.x = 0
		cfg.pos3D.y = -100
		cfg.pos3D.z = 0
	end
	sprite:setPosition3D(cfg.pos3D)
	sprite:setRotation3D(cfg.rotation3D or cc.vec3(0.0, self.curYAngle, 0.0))
	local animation = cc.Animation3D:create(filePath)
	if nil ~= animation then
		print("动画时长: = ", animation:getDuration())
		local animate = cc.Animate3D:create(animation)
		animate:setSpeed(0.8)
		sprite:runAction(cc.RepeatForever:create(animate))
	end
	sprite:setCullFaceEnabled(false)
	self.node_pet:addChild(sprite)
	self.sprite = sprite
	if cfg.meshes then
		for _, v in ipairs(cfg.meshes) do
			local shaderType = v.shaderType
			local shaderParam = v.shaderParam
			local shader = self:getOrCreateByShaderType(shaderType)
			local state = cc.GLProgramState:create(shader)
			sprite:setGLProgramStateForMesh(state, v.name)
			SoraDSetProgramStateParam(shader, state, shaderParam)
			if not self.programStates then
				self.programStates, _ENV = self.programStates, self.programStates
			end
			self.programStates[v.name] = state
			if not self.programs then
				self.programs, _ENV = self.programs, self.programs
			end
			self.programs[v.name] = shader
			if v.zOrder then
				print("v.name = ", v.name)
				print("mesh = ", sprite:getMeshByName(v.name))
				local mesh = sprite:getMeshByName(v.name)
				mesh:setLocalZOrder(v.zOrder)
			end
		end
	else
		local shaderType = cfg.shaderType
		local shaderParam = cfg.shaderParam
		local shader = self:getOrCreateByShaderType(shaderType)
		local state = cc.GLProgramState:create(shader)
		sprite:setGLProgramState(state)
		SoraDSetProgramStateParam(shader, state, shaderParam)
		self.programState = state
		self.program = shader
	end
	self.cfg = cfg
	return self.sprite
end
function petViewTest:getCommonLightParam()
	if self.commonLightParam then
		return self.commonLightParam
	end
	_ENV = self.commonLightParam
	self.commonLightParam.x = 0
	local self.commonLightParam.y, posPetOffset = 0, self.commonLightParam
	local viewPos = self.node_pet:convertToWorldSpace(posPetOffset)
	self.viewPos = viewPos
	_ENV, _UPVALUE8_, self.viewPos.z = cc.Director:getInstance():getZEye(), self.viewPos, cc.Director:getInstance():getZEye()
	cc.Director:getInstance():getZEye().name = "viewPos"
	cc.Director:getInstance():getZEye().value = viewPos
	_ENV, cc.Director:getInstance():getZEye().attr = cc.Director:getInstance(), "vec3"
	_ENV, cc.Director:getInstance().name = nil, "lightPos"
	;(nil).x = 10000
	;(nil).y = 10000
	cc.Director:getInstance().value, (nil).z = nil, 6000
	_ENV, cc.Director:getInstance().attr = nil, "vec3"
	_ENV, (nil).name = nil, "lightAmbient"
	;(nil).x = 0.76
	;(nil).y = 0.76
	;(nil).value, (nil).z = nil, 0.76
	_ENV, (nil).attr = nil, "vec3"
	_ENV, (nil).name = nil, "lightDiffuse"
	;(nil).x = 0.8
	;(nil).y = 0.8
	;(nil).value, (nil).z = nil, 0.8
	_ENV, (nil).attr = nil, "vec3"
	_ENV, (nil).name = nil, "lightSpecular"
	;(nil).x = 1.0
	;(nil).y = 1.0
	;(nil).value, (nil).z = nil, 1.0
	_ENV, (nil).attr = nil, "vec3"
	_ENV, (nil).name = nil, "lightColor"
	;(nil).x = 0.8
	;(nil).y = 0.8
	;(nil).value, (nil).z = nil, 0.8
	_ENV, (nil).attr = nil, "vec3"
	;(nil).name = "brightness"
	;(nil).value = 55.0
	_ENV, (nil).attr = nil, "float"
	;(nil).name = "u_alpha"
	;(nil).value = 0.05
	;(nil).attr = "float"
	self.commonLightParam, self.viewPos[1] = self.viewPos, cc.Director:getInstance():getZEye()
	self.commonLightParam, self.viewPos[2] = self.viewPos, cc.Director:getInstance()
	self.commonLightParam, self.viewPos[3] = self.viewPos
	self.commonLightParam, self.viewPos[4] = self.viewPos
	self.commonLightParam, self.viewPos[5] = self.viewPos
	self.commonLightParam, self.viewPos[6] = self.viewPos
	self.commonLightParam, self.viewPos[7] = self.viewPos
	self.commonLightParam, self.viewPos[8] = self.viewPos
	return self.commonLightParam
end
function petViewTest:test3DNoLight()
	SHADER_TYPE = nil
	;(nil).shaderType = SHADER_TYPE.NO_LIGHT
	;(nil).filePath = "3d/normal/et_shizitest_04.c3b"
	SHADER_TYPE, _UPVALUE1_, (nil).scale = nil, SHADER_TYPE.NO_LIGHT, 5.0
	;(nil).name = "u_alpha"
	;(nil).value = 0.5
	;(nil).attr = "float"
	;(nil).shaderParam, SHADER_TYPE.NO_LIGHT[1] = SHADER_TYPE.NO_LIGHT
	local cfg
	self:createSprite3DByCfg(cfg)
end
function petViewTest:test3DNoSpecLight()
	local _ENV, shaderParam
	local commonParam = self:getCommonLightParam()
	for i, v in ipairs(commonParam) do
		shaderParam[i] = v
	end
	_ENV = (for generator)
	ipairs(commonParam).shaderType = SHADER_TYPE.LIGHT
	ipairs(commonParam).filePath = "3d/normal/et_shizitest_04.c3b"
	ipairs(commonParam).scale = 5.0
	local ipairs(commonParam).shaderParam, cfg = shaderParam, ipairs(commonParam)
	self:createSprite3DByCfg(cfg)
end
function petViewTest:test3DSpecLight()
	local _ENV, shaderParam
	local commonParam = self:getCommonLightParam()
	for i, v in ipairs(commonParam) do
		shaderParam[i] = v
	end
	_ENV = (for generator)
	ipairs(commonParam).shaderType = SHADER_TYPE.SPEC_LIGHT
	ipairs(commonParam).filePath = "3d/normal/et_shizitest_04.c3b"
	ipairs(commonParam).scale = 5.0
	local ipairs(commonParam).shaderParam, cfg = shaderParam, ipairs(commonParam)
	self:createSprite3DByCfg(cfg)
end
function petViewTest:test3DSpecLightMap()
	local _ENV, shaderParam
	local commonParam = self:getCommonLightParam()
	for i, v in ipairs(commonParam) do
		shaderParam[i] = v
	end
	_ENV = ipairs(commonParam)
	ipairs(commonParam).name = "specularMap"
	ipairs(commonParam).value = "3d/normal/babalishi_04_sp.png"
	ipairs(commonParam).attr = "texture"
	table.insert(shaderParam, ipairs(commonParam))
	_ENV = table.insert
	table.insert.shaderType = SHADER_TYPE.SPECMAP_LIGHT
	table.insert.filePath = "3d/normal/et_shizitest_04.c3b"
	table.insert.scale = 5.0
	local table.insert.shaderParam, cfg = shaderParam, table.insert
	self:createSprite3DByCfg(cfg)
end
function petViewTest:testNGNoLight()
	SHADER_TYPE = nil
	;(nil).shaderType = SHADER_TYPE.NO_LIGHT
	;(nil).filePath = "3d/normal/lion.c3b"
	SHADER_TYPE, _UPVALUE1_, (nil).scale = nil, SHADER_TYPE.NO_LIGHT, 6.2
	;(nil).name = "u_alpha"
	;(nil).value = 0.5
	;(nil).attr = "float"
	;(nil).shaderParam, SHADER_TYPE.NO_LIGHT[1] = SHADER_TYPE.NO_LIGHT
	local cfg
	self:createSprite3DByCfg(cfg)
end
function petViewTest:testNGNoSpecLight()
	local _ENV, shaderParam
	local commonParam = self:getCommonLightParam()
	for i, v in ipairs(commonParam) do
		shaderParam[i] = v
	end
	_ENV = (for generator)
	ipairs(commonParam).shaderType = SHADER_TYPE.LIGHT
	ipairs(commonParam).filePath = "3d/normal/lion.c3b"
	ipairs(commonParam).scale = 6.2
	local ipairs(commonParam).shaderParam, cfg = shaderParam, ipairs(commonParam)
	self:createSprite3DByCfg(cfg)
end
function petViewTest:testNGSpecLight()
	local _ENV, shaderParam
	local commonParam = self:getCommonLightParam()
	for i, v in ipairs(commonParam) do
		shaderParam[i] = v
	end
	_ENV = (for generator)
	ipairs(commonParam).shaderType = SHADER_TYPE.SPEC_LIGHT
	ipairs(commonParam).filePath = "3d/normal/lion.c3b"
	ipairs(commonParam).scale = 6.2
	local ipairs(commonParam).shaderParam, cfg = shaderParam, ipairs(commonParam)
	self:createSprite3DByCfg(cfg)
end
function petViewTest:testNGSpecLight2()
	local _ENV, shaderParam
	local commonParam = self:getCommonLightParam()
	for i, v in ipairs(commonParam) do
		shaderParam[i] = v
	end
	_ENV = (for generator)
	_ENV, _UPVALUE2_, ipairs(commonParam).filePath = ipairs(commonParam)
	ipairs(commonParam).name = "d_sttt_polySurface1133"
	ipairs(commonParam).shaderType = SHADER_TYPE.LIGHT
	_ENV, ipairs(commonParam).shaderParam = SHADER_TYPE.LIGHT, shaderParam
	SHADER_TYPE.LIGHT.name = "kj_d_polySurface1167"
	SHADER_TYPE.LIGHT.shaderType = SHADER_TYPE.SPEC_LIGHT
	SHADER_TYPE.LIGHT.shaderParam = shaderParam
	ipairs(commonParam).meshes, ipairs(commonParam)[1] = ipairs(commonParam)
	ipairs(commonParam).meshes, ipairs(commonParam)[2] = ipairs(commonParam)
	local ipairs(commonParam).scale, cfg = 6.2, ipairs(commonParam)
	self:createSprite3DByCfg(cfg)
end
function petViewTest:testNGSpecMapNormalLight()
	_ENV = nil
	;(nil).x = 0
	local (nil).y, posPetOffset = 0, nil
	local viewPos = self.node_pet:convertToWorldSpace(posPetOffset)
	self.viewPos = viewPos
	self.viewPos.z = cc.Director:getInstance():getZEye()
	local _ENV, bodyParam = self.viewPos, self.viewPos
	local _ENV, equipParam = cc.Director:getInstance():getZEye(), cc.Director:getInstance():getZEye()
	local commonParam = self:getCommonLightParam()
	for i, v in ipairs(commonParam) do
		bodyParam[i] = v
		equipParam[i] = v
	end
	_ENV = ipairs(commonParam)
	ipairs(commonParam).name = "normalMap"
	ipairs(commonParam).value = "3d/normal/shenti_n.png"
	ipairs(commonParam).attr = "texture"
	table.insert(bodyParam, ipairs(commonParam))
	_ENV = ipairs(commonParam)
	ipairs(commonParam).name = "normalMap"
	ipairs(commonParam).value = "3d/normal/kuijia_n.png"
	ipairs(commonParam).attr = "texture"
	table.insert(equipParam, ipairs(commonParam))
	_ENV = ipairs(commonParam)
	ipairs(commonParam).name = "specularMap"
	ipairs(commonParam).value = "3d/normal/gaoguang.png"
	ipairs(commonParam).attr = "texture"
	table.insert(equipParam, ipairs(commonParam))
	_ENV = table.insert
	_ENV, _UPVALUE2_, table.insert.filePath = ipairs(commonParam)
	ipairs(commonParam).name = "d_sttt_polySurface1133"
	ipairs(commonParam).shaderType = SHADER_TYPE.LIGHT_NORMAL
	_ENV, ipairs(commonParam).shaderParam = SHADER_TYPE.LIGHT_NORMAL, bodyParam
	SHADER_TYPE.LIGHT_NORMAL.name = "kj_d_polySurface1167"
	SHADER_TYPE.LIGHT_NORMAL.shaderType = SHADER_TYPE.SPECMAP_NORMAL
	SHADER_TYPE.LIGHT_NORMAL.shaderParam = equipParam
	table.insert.meshes, equipParam[1] = equipParam, ipairs(commonParam)
	table.insert.meshes, equipParam[2] = equipParam, SHADER_TYPE.LIGHT_NORMAL
	local table.insert.scale, cfg = 6.2, table.insert
	self:createSprite3DByCfg(cfg)
end
function petViewTest:test3DNoLight_Beauty01()
	SHADER_TYPE = nil
	;(nil).shaderType = SHADER_TYPE.NO_LIGHT
	;(nil).filePath = "3d/normal/meinv002.c3b"
	SHADER_TYPE, (nil).scale = SHADER_TYPE.NO_LIGHT, 7
	SHADER_TYPE.NO_LIGHT.x = 0
	SHADER_TYPE.NO_LIGHT.y = -450
	SHADER_TYPE, _UPVALUE1_, (nil).pos3D, SHADER_TYPE.NO_LIGHT.z = nil, SHADER_TYPE.NO_LIGHT, SHADER_TYPE.NO_LIGHT, 0
	;(nil).name = "u_alpha"
	;(nil).value = 0.001
	;(nil).attr = "float"
	;(nil).shaderParam, SHADER_TYPE.NO_LIGHT[1] = SHADER_TYPE.NO_LIGHT
	local cfg
	local node = self:createSprite3DByCfg(cfg)
	node:setUsingLocalTransparentLayer(true)
end
function petViewTest:test3DNoSpecLight_Beauty01()
	local _ENV, shaderParam
	local commonParam = self:getCommonLightParam()
	for i, v in ipairs(commonParam) do
		shaderParam[i] = v
	end
	_ENV = (for generator)
	ipairs(commonParam).shaderType = SHADER_TYPE.LIGHT
	ipairs(commonParam).filePath = "3d/normal/meinvtest02.c3b"
	_ENV, ipairs(commonParam).scale = SHADER_TYPE.LIGHT, 7.0
	SHADER_TYPE.LIGHT.x = 0
	SHADER_TYPE.LIGHT.y = -450
	ipairs(commonParam).pos3D, SHADER_TYPE.LIGHT.z = SHADER_TYPE.LIGHT, 0
	local ipairs(commonParam).shaderParam, cfg = shaderParam, ipairs(commonParam)
	self:createSprite3DByCfg(cfg)
end
function petViewTest:test3DSpecLight_Beauty01()
	local _ENV, shaderParam
	local commonParam = self:getCommonLightParam()
	for i, v in ipairs(commonParam) do
		shaderParam[i] = v
	end
	_ENV = (for generator)
	ipairs(commonParam).shaderType = SHADER_TYPE.SPEC_LIGHT
	ipairs(commonParam).filePath = "3d/normal/meinv002.c3b"
	_ENV, ipairs(commonParam).scale = SHADER_TYPE.SPEC_LIGHT, 7.0
	SHADER_TYPE.SPEC_LIGHT.x = 0
	SHADER_TYPE.SPEC_LIGHT.y = -450
	ipairs(commonParam).pos3D, SHADER_TYPE.SPEC_LIGHT.z = SHADER_TYPE.SPEC_LIGHT, 0
	local ipairs(commonParam).shaderParam, cfg = shaderParam, ipairs(commonParam)
	self:createSprite3DByCfg(cfg)
end
function petViewTest:test3DSpecLightMap_Beauty01()
	local _ENV, bodyParam
	local _ENV, clothParam
	local _ENV, equipParam
	local commonParam = self:getCommonLightParam()
	for i, v in ipairs(commonParam) do
		bodyParam[i] = v
		equipParam[i] = v
		clothParam[i] = v
	end
	_ENV = ipairs(commonParam)
	ipairs(commonParam).name = "specularMap"
	ipairs(commonParam).value = "3d/normal/shalaguanna_pifu_s.png"
	ipairs(commonParam).attr = "texture"
	table.insert(bodyParam, ipairs(commonParam))
	_ENV = ipairs(commonParam)
	ipairs(commonParam).name = "CC_Texture0"
	ipairs(commonParam).value = "3d/normal/shalaguanna_pifu.png"
	ipairs(commonParam).attr = "texture"
	table.insert(bodyParam, ipairs(commonParam))
	_ENV = ipairs(commonParam)
	ipairs(commonParam).name = "specularMap"
	ipairs(commonParam).value = "3d/normal/shalaguanna_01_s.png"
	ipairs(commonParam).attr = "texture"
	table.insert(clothParam, ipairs(commonParam))
	_ENV = ipairs(commonParam)
	ipairs(commonParam).name = "CC_Texture0"
	ipairs(commonParam).value = "3d/normal/shalaguanna_01.png"
	ipairs(commonParam).attr = "texture"
	table.insert(clothParam, ipairs(commonParam))
	_ENV = ipairs(commonParam)
	ipairs(commonParam).name = "specularMap"
	ipairs(commonParam).value = "3d/normal/shalaguanna_01_s.png"
	ipairs(commonParam).attr = "texture"
	table.insert(equipParam, ipairs(commonParam))
	_ENV = ipairs(commonParam)
	ipairs(commonParam).name = "CC_Texture0"
	ipairs(commonParam).value = "3d/normal/shalaguanna_01.png"
	ipairs(commonParam).attr = "texture"
	table.insert(equipParam, ipairs(commonParam))
	_ENV = table.insert
	_ENV, _UPVALUE3_, table.insert.filePath = ipairs(commonParam)
	ipairs(commonParam).name = "shalaguanna_01"
	ipairs(commonParam).shaderType = SHADER_TYPE.SPECMAP_LIGHT
	ipairs(commonParam).shaderParam = clothParam
	_ENV, ipairs(commonParam).zOrder = SHADER_TYPE.SPECMAP_LIGHT, 1
	SHADER_TYPE.SPECMAP_LIGHT.name = "shalaguanna_pifu"
	SHADER_TYPE.SPECMAP_LIGHT.shaderType = SHADER_TYPE.SPECMAP_LIGHT
	SHADER_TYPE.SPECMAP_LIGHT.shaderParam = bodyParam
	_ENV, SHADER_TYPE.SPECMAP_LIGHT.zOrder = SHADER_TYPE.SPECMAP_LIGHT, 2
	SHADER_TYPE.SPECMAP_LIGHT.name = "shalaguanna_yixiu"
	SHADER_TYPE.SPECMAP_LIGHT.shaderType = SHADER_TYPE.SPECMAP_LIGHT
	SHADER_TYPE.SPECMAP_LIGHT.shaderParam = equipParam
	SHADER_TYPE.SPECMAP_LIGHT.zOrder = 3
	table.insert.meshes, equipParam[1] = equipParam, ipairs(commonParam)
	table.insert.meshes, equipParam[2] = equipParam, SHADER_TYPE.SPECMAP_LIGHT
	table.insert.meshes, equipParam[3] = equipParam, SHADER_TYPE.SPECMAP_LIGHT
	_ENV, table.insert.scale = equipParam, 7.0
	equipParam.x = 0
	equipParam.y = -450
	table.insert.pos3D, equipParam.z = equipParam, 0
	local cfg = table.insert
	local node = self:createSprite3DByCfg(cfg)
	node:setUsingLocalTransparentLayer(true)
end
function petViewTest:test3DSpecLight_Beauty01_BOE()
	local _ENV, shaderParam
	local commonParam = self:getCommonLightParam()
	for i, v in ipairs(commonParam) do
		shaderParam[i] = v
	end
	_ENV = (for generator)
	ipairs(commonParam).shaderType = SHADER_TYPE.SPEC_LIGHT
	ipairs(commonParam).filePath = "3d/normal/Beifeiwangfei_002.c3b"
	_ENV, ipairs(commonParam).scale = SHADER_TYPE.SPEC_LIGHT, 4.0
	SHADER_TYPE.SPEC_LIGHT.x = 0
	SHADER_TYPE.SPEC_LIGHT.y = -400
	ipairs(commonParam).pos3D, SHADER_TYPE.SPEC_LIGHT.z = SHADER_TYPE.SPEC_LIGHT, 0
	local ipairs(commonParam).shaderParam, cfg = shaderParam, ipairs(commonParam)
	local node = self:createSprite3DByCfg(cfg)
	local meshes = node:getMeshes()
	for _, mesh in ipairs(meshes) do
		if mesh:getName():find("cloth") ~= nil then
			mesh:setLocalZOrder(10)
		end
	end
	node:getMeshByName("beifeiwangfei_cloth_001"):setVisible(false)
	node:setUsingLocalTransparentLayer(true)
	self:printMeshes(node)
end
function petViewTest:test3DSpecLight_Beauty01_BOE2()
	local _ENV, bodyParam
	local _ENV, clothParam
	local _ENV, equipParam
	local commonParam = self:getCommonLightParam()
	for i, v in ipairs(commonParam) do
		bodyParam[i] = v
		equipParam[i] = v
		clothParam[i] = v
	end
	_ENV = (for generator)
	_ENV, _UPVALUE3_, ipairs(commonParam).filePath = ipairs(commonParam)
	ipairs(commonParam).name = "beifeiwangfei_head_001"
	ipairs(commonParam).shaderType = SHADER_TYPE.SPEC_LIGHT
	ipairs(commonParam).shaderParam = clothParam
	_ENV, ipairs(commonParam).zOrder = SHADER_TYPE.SPEC_LIGHT, 1
	SHADER_TYPE.SPEC_LIGHT.name = "beifeiwangfei_hair_001"
	SHADER_TYPE.SPEC_LIGHT.shaderType = SHADER_TYPE.SPEC_LIGHT
	SHADER_TYPE.SPEC_LIGHT.shaderParam = bodyParam
	_ENV, SHADER_TYPE.SPEC_LIGHT.zOrder = SHADER_TYPE.SPEC_LIGHT, 2
	SHADER_TYPE.SPEC_LIGHT.name = "beifeiwangfei_cloth_001"
	SHADER_TYPE.SPEC_LIGHT.shaderType = SHADER_TYPE.SPEC_LIGHT
	SHADER_TYPE.SPEC_LIGHT.shaderParam = equipParam
	SHADER_TYPE.SPEC_LIGHT.zOrder = 3
	ipairs(commonParam).meshes, ipairs(commonParam)[1] = ipairs(commonParam)
	ipairs(commonParam).meshes, ipairs(commonParam)[2] = ipairs(commonParam)
	ipairs(commonParam).meshes, ipairs(commonParam)[3] = ipairs(commonParam)
	_ENV, ipairs(commonParam).scale = ipairs(commonParam)
	ipairs(commonParam).x = 0
	ipairs(commonParam).y = -400
	ipairs(commonParam).pos3D, ipairs(commonParam).z = ipairs(commonParam)
	local cfg = ipairs(commonParam)
	local node = self:createSprite3DByCfg(cfg)
	node:setUsingLocalTransparentLayer(true)
	self:printMeshes(node)
end
function petViewTest:loadTestByIndex(index)
	local testCfg = self.testMap[index]
	if testCfg and testCfg.func then
		print("index = ", index, ", func = ", testCfg.func)
		self[testCfg.func](self)
	end
end
function petViewTest:getParamItem(param, name)
	for _, v in ipairs(param) do
		if v.name == name then
			return v
		end
	end
end
function petViewTest:loadSliderParam(program, state, cfg, index)
	self.program = program
	if self.nodeSlider then
		self.nodeSlider:removeFromParent()
	end
	local param
	if not index then
		param = cfg.shaderParam
	else
		param = cfg.meshes[index].shaderParam
	end
	local nodeSlider = display.newNode()
	self:addChild(nodeSlider)
	nodeSlider:setLocalZOrder(10)
	self.nodeSlider = nodeSlider
	local sliderOffsetX = 100
	local sliderOffsetY = 100
	local posLabelX = -50
	local posLabelY = 10
	local stepY = 40
	local programState = state
	local lightColorPI = self:getParamItem(param, "lightColor")
	local sliderX = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
	local commonSlider = include("commonSlider")
	_ENV, sliderX = commonSlider.new(sliderX), commonSlider.new(sliderX)
	commonSlider.new(sliderX).maxValue = 255
	commonSlider.new(sliderX).minValue = 1
	commonSlider.new(sliderX).curValue = lightColorPI.value.x * 255
	local commonSlider.new(sliderX).openEditBox, sliderData = true, commonSlider.new(sliderX)
	sliderX:initData(sliderData)
	sliderX:addTo(nodeSlider)
	sliderX:setPosition(cc.p(sliderOffsetX, sliderOffsetY))
	sliderX:setLocalZOrder(10)
	sliderX:setSliderCallBack(function(valuechange)
		lightColorPI.value.x = valuechange / 255
		dump(lightColorPI.value, "set x lightColorPI.value")
		programState:setUniformVec3(self.program:getUniform("lightColor").location, lightColorPI.value)
	end)
	local labelX = self:createLabel("光线R")
	labelX:addTo(sliderX)
	labelX:setPositionX(posLabelX)
	labelX:setPositionY(posLabelY)
	sliderOffsetY = sliderOffsetY + stepY
	local sliderY = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
	local commonSlider = include("commonSlider")
	_ENV, sliderY = commonSlider.new(sliderY), commonSlider.new(sliderY)
	commonSlider.new(sliderY).maxValue = 255
	commonSlider.new(sliderY).minValue = 1
	commonSlider.new(sliderY).curValue = lightColorPI.value.y * 255
	local commonSlider.new(sliderY).openEditBox, sliderData = true, commonSlider.new(sliderY)
	sliderY:initData(sliderData)
	sliderY:addTo(nodeSlider)
	sliderY:setPosition(cc.p(sliderOffsetX, sliderOffsetY))
	sliderY:setLocalZOrder(10)
	sliderY:setSliderCallBack(function(valuechange)
		lightColorPI.value.y = valuechange / 255
		dump(lightColorPI.value, "set y lightColorPI.value")
		programState:setUniformVec3(self.program:getUniform("lightColor").location, lightColorPI.value)
	end)
	local labelX = self:createLabel("光线绿")
	labelX:addTo(sliderY)
	labelX:setPositionX(posLabelX)
	labelX:setPositionY(posLabelY)
	sliderOffsetY = sliderOffsetY + stepY
	local sliderZ = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
	local commonSlider = include("commonSlider")
	_ENV, sliderZ = commonSlider.new(sliderZ), commonSlider.new(sliderZ)
	commonSlider.new(sliderZ).maxValue = 255
	commonSlider.new(sliderZ).minValue = 1
	commonSlider.new(sliderZ).curValue = lightColorPI.value.z * 255
	local commonSlider.new(sliderZ).openEditBox, sliderData = true, commonSlider.new(sliderZ)
	sliderZ:initData(sliderData)
	sliderZ:addTo(nodeSlider)
	sliderZ:setPosition(cc.p(sliderOffsetX, sliderOffsetY))
	sliderZ:setLocalZOrder(10)
	sliderZ:setSliderCallBack(function(valuechange)
		lightColorPI.value.z = valuechange / 255
		programState:setUniformVec3(self.program:getUniform("lightColor").location, lightColorPI.value)
	end)
	local labelX = self:createLabel("光线蓝")
	labelX:addTo(sliderZ)
	labelX:setPositionX(posLabelX)
	labelX:setPositionY(posLabelY)
	sliderOffsetY = sliderOffsetY + stepY
	local lightPosPI = self:getParamItem(param, "lightPos")
	local sliderX = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
	local commonSlider = include("commonSlider")
	_ENV, sliderX = commonSlider.new(sliderX), commonSlider.new(sliderX)
	commonSlider.new(sliderX).maxValue = 10000
	commonSlider.new(sliderX).minValue = 1
	commonSlider.new(sliderX).curValue = lightPosPI.value.x + 2000
	local commonSlider.new(sliderX).openEditBox, sliderData = true, commonSlider.new(sliderX)
	sliderX:initData(sliderData)
	sliderX:addTo(nodeSlider)
	sliderX:setPosition(cc.p(sliderOffsetX, sliderOffsetY))
	sliderX:setLocalZOrder(10)
	sliderX:setSliderCallBack(function(valuechange)
		lightPosPI.value.x = valuechange - 2000
		dump(lightPosPI.value, "set x lightPosPI.value")
		programState:setUniformVec3(self.program:getUniform("lightPos").location, lightPosPI.value)
		if self.lightLabel then
			self.lightLabel:setString(string.format("灯光(%d,%d,%d)", lightPosPI.value.x, lightPosPI.value.y, lightPosPI.value.z))
		end
	end)
	local labelX = self:createLabel("光坐标X")
	labelX:addTo(sliderX)
	labelX:setPositionX(posLabelX)
	labelX:setPositionY(posLabelY)
	sliderOffsetY = sliderOffsetY + stepY
	local sliderY = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
	local commonSlider = include("commonSlider")
	_ENV, sliderY = commonSlider.new(sliderY), commonSlider.new(sliderY)
	commonSlider.new(sliderY).maxValue = 10000
	commonSlider.new(sliderY).minValue = 1
	commonSlider.new(sliderY).curValue = lightPosPI.value.y + 2000
	local commonSlider.new(sliderY).openEditBox, sliderData = true, commonSlider.new(sliderY)
	sliderY:initData(sliderData)
	sliderY:addTo(nodeSlider)
	sliderY:setPosition(cc.p(sliderOffsetX, sliderOffsetY))
	sliderY:setLocalZOrder(10)
	sliderY:setSliderCallBack(function(valuechange)
		lightPosPI.value.y = valuechange - 2000
		dump(lightPosPI.value, "set y lightPosPI.value")
		programState:setUniformVec3(self.program:getUniform("lightPos").location, lightPosPI.value)
		if self.lightLabel then
			self.lightLabel:setString(string.format("灯光(%d,%d,%d)", lightPosPI.value.x, lightPosPI.value.y, lightPosPI.value.z))
		end
	end)
	local labelY = self:createLabel("光坐标Y")
	labelY:addTo(sliderY)
	labelY:setPositionX(posLabelX)
	sliderOffsetY = sliderOffsetY + stepY
	local sliderZ = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
	local commonSlider = include("commonSlider")
	_ENV, sliderZ = commonSlider.new(sliderZ), commonSlider.new(sliderZ)
	commonSlider.new(sliderZ).maxValue = 10000
	commonSlider.new(sliderZ).minValue = 1
	commonSlider.new(sliderZ).curValue = lightPosPI.value.z + 2000
	local commonSlider.new(sliderZ).openEditBox, sliderData = true, commonSlider.new(sliderZ)
	sliderZ:initData(sliderData)
	sliderZ:addTo(nodeSlider)
	sliderZ:setPosition(cc.p(sliderOffsetX, sliderOffsetY))
	sliderZ:setLocalZOrder(10)
	sliderZ:setSliderCallBack(function(valuechange)
		lightPosPI.value.z = valuechange - 2000
		dump(lightPosPI.value, "set z lightPosPI.value")
		programState:setUniformVec3(self.program:getUniform("lightPos").location, lightPosPI.value)
		if self.lightLabel then
			self.lightLabel:setString(string.format("灯光(%d,%d,%d)", lightPosPI.value.x, lightPosPI.value.y, lightPosPI.value.z))
		end
	end)
	local labelZ = self:createLabel("光坐标Z")
	labelZ:addTo(sliderZ)
	labelZ:setPositionX(posLabelX)
	self.lightLabel = self:createLabel("光坐标")
	self.lightLabel:addTo(nodeSlider)
	self.lightLabel:setPosition(cc.p(220, display.height - 150))
	self.lightLabel:setColor(cc.c3b(255, 0, 0))
	local brightnessPI = self:getParamItem(param, "brightness")
	sliderOffsetY = sliderOffsetY + stepY
	local sliderBright = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
	local commonSlider = include("commonSlider")
	_ENV, sliderBright = commonSlider.new(sliderBright), commonSlider.new(sliderBright)
	commonSlider.new(sliderBright).maxValue = 100
	commonSlider.new(sliderBright).minValue = 1
	commonSlider.new(sliderBright).curValue = brightnessPI.value
	local commonSlider.new(sliderBright).openEditBox, sliderData = true, commonSlider.new(sliderBright)
	sliderBright:initData(sliderData)
	sliderBright:addTo(nodeSlider)
	sliderBright:setPosition(cc.p(sliderOffsetX, sliderOffsetY))
	sliderBright:setLocalZOrder(10)
	sliderBright:setSliderCallBack(function(valuechange)
		brightnessPI.value = valuechange
		dump(brightnessPI.value, "brightnessPI.value")
		programState:setUniformFloat(self.program:getUniform("brightness").location, brightnessPI.value)
	end)
	local labelBright = self:createLabel("高光亮度")
	labelBright:addTo(sliderBright)
	labelBright:setPositionX(posLabelX)
	local lightAmbientPI = self:getParamItem(param, "lightAmbient")
	sliderOffsetY = sliderOffsetY + stepY
	local sliderAmbient = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
	local commonSlider = include("commonSlider")
	_ENV, sliderAmbient = commonSlider.new(sliderAmbient), commonSlider.new(sliderAmbient)
	commonSlider.new(sliderAmbient).maxValue = 100
	commonSlider.new(sliderAmbient).minValue = 1
	commonSlider.new(sliderAmbient).curValue = lightAmbientPI.value.x * 100
	local commonSlider.new(sliderAmbient).openEditBox, sliderData = true, commonSlider.new(sliderAmbient)
	sliderAmbient:initData(sliderData)
	sliderAmbient:addTo(nodeSlider)
	sliderAmbient:setPosition(cc.p(sliderOffsetX, sliderOffsetY))
	sliderAmbient:setLocalZOrder(10)
	sliderAmbient:setSliderCallBack(function(valuechange)
		lightAmbientPI.value.x = valuechange / 100.0
		lightAmbientPI.value.y = lightAmbientPI.value.x
		lightAmbientPI.value.z = lightAmbientPI.value.x
		dump(lightAmbientPI.value, "lightAmbientPI.value")
		programState:setUniformVec3(self.program:getUniform("lightAmbient").location, lightAmbientPI.value)
	end)
	local labelX = self:createLabel("环境光")
	labelX:addTo(sliderAmbient)
	labelX:setPositionX(posLabelX)
	labelX:setPositionY(posLabelY)
	local lightDiffusePI = self:getParamItem(param, "lightDiffuse")
	sliderOffsetY = sliderOffsetY + stepY
	local sliderDiffuse = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
	local commonSlider = include("commonSlider")
	_ENV, sliderDiffuse = commonSlider.new(sliderDiffuse), commonSlider.new(sliderDiffuse)
	commonSlider.new(sliderDiffuse).maxValue = 100
	commonSlider.new(sliderDiffuse).minValue = 1
	commonSlider.new(sliderDiffuse).curValue = lightDiffusePI.value.x * 100
	local commonSlider.new(sliderDiffuse).openEditBox, sliderData = true, commonSlider.new(sliderDiffuse)
	sliderDiffuse:initData(sliderData)
	sliderDiffuse:addTo(nodeSlider)
	sliderDiffuse:setPosition(cc.p(sliderOffsetX, sliderOffsetY))
	sliderDiffuse:setLocalZOrder(10)
	sliderDiffuse:setSliderCallBack(function(valuechange)
		lightDiffusePI.value.x = valuechange / 100
		lightDiffusePI.value.y = lightDiffusePI.value.x
		lightDiffusePI.value.z = lightDiffusePI.value.x
		dump(lightDiffusePI.value, "lightDiffusePI.value")
		programState:setUniformVec3(self.program:getUniform("lightDiffuse").location, lightDiffusePI.value)
	end)
	local lightSpecularPI = self:getParamItem(param, "lightSpecular")
	local labelX = self:createLabel("漫反射")
	labelX:addTo(sliderDiffuse)
	labelX:setPositionX(posLabelX)
	labelX:setPositionY(posLabelY)
	sliderOffsetY = sliderOffsetY + stepY
	local sliderSpecular = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
	local commonSlider = include("commonSlider")
	_ENV, sliderSpecular = commonSlider.new(sliderSpecular), commonSlider.new(sliderSpecular)
	commonSlider.new(sliderSpecular).maxValue = 500
	commonSlider.new(sliderSpecular).minValue = 1
	commonSlider.new(sliderSpecular).curValue = lightSpecularPI.value.x * 100
	local commonSlider.new(sliderSpecular).openEditBox, sliderData = true, commonSlider.new(sliderSpecular)
	sliderSpecular:initData(sliderData)
	sliderSpecular:addTo(nodeSlider)
	sliderSpecular:setPosition(cc.p(sliderOffsetX, sliderOffsetY))
	sliderSpecular:setLocalZOrder(10)
	sliderSpecular:setSliderCallBack(function(valuechange)
		lightSpecularPI.value.x = valuechange / 100
		lightSpecularPI.value.y = lightSpecularPI.value.x
		lightSpecularPI.value.z = lightSpecularPI.value.x
		dump(lightSpecularPI.value, "lightSpecularPI.value")
		programState:setUniformVec3(self.program:getUniform("lightSpecular").location, lightSpecularPI.value)
	end)
	local labelX = self:createLabel("高光")
	labelX:addTo(sliderSpecular)
	labelX:setPositionX(posLabelX)
	labelX:setPositionY(posLabelY)
	sliderOffsetY = sliderOffsetY + stepY
	local sliderSpecular = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
	local commonSlider = include("commonSlider")
	_ENV, sliderSpecular = commonSlider.new(sliderSpecular), commonSlider.new(sliderSpecular)
	commonSlider.new(sliderSpecular).maxValue = 100
	commonSlider.new(sliderSpecular).minValue = 1
	commonSlider.new(sliderSpecular).curValue = cfg.scale * 10
	local commonSlider.new(sliderSpecular).openEditBox, sliderData = true, commonSlider.new(sliderSpecular)
	sliderSpecular:initData(sliderData)
	sliderSpecular:addTo(nodeSlider)
	sliderSpecular:setPosition(cc.p(sliderOffsetX, sliderOffsetY))
	sliderSpecular:setLocalZOrder(10)
	sliderSpecular:setSliderCallBack(function(valuechange)
		cfg.scale = valuechange / 10
		self.sprite:setScale(cfg.scale)
	end)
	local labelX = self:createLabel("缩放")
	labelX:addTo(sliderSpecular)
	labelX:setPositionX(posLabelX)
	labelX:setPositionY(posLabelY)
	local viewPosPI = self:getParamItem(param, "viewPos")
	sliderOffsetY = sliderOffsetY + stepY
	local sliderX = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
	local commonSlider = include("commonSlider")
	_ENV, sliderX = commonSlider.new(sliderX), commonSlider.new(sliderX)
	commonSlider.new(sliderX).maxValue = 4000
	commonSlider.new(sliderX).minValue = 1
	commonSlider.new(sliderX).curValue = viewPosPI.value.x + 2000
	local commonSlider.new(sliderX).openEditBox, sliderData = true, commonSlider.new(sliderX)
	sliderX:initData(sliderData)
	sliderX:addTo(nodeSlider)
	sliderX:setPosition(cc.p(sliderOffsetX, sliderOffsetY))
	sliderX:setLocalZOrder(10)
	sliderX:setSliderCallBack(function(valuechange)
		viewPosPI.value.x = valuechange - 2000
		programState:setUniformVec3(self.program:getUniform("viewPos").location, viewPosPI.value)
		if self.viewPosLabel then
			self.viewPosLabel:setString(string.format("视点(%d,%d,%d)", viewPosPI.value.x, viewPosPI.value.y, viewPosPI.value.z))
		end
		local nodePos = self.node_pet:convertToNodeSpace(viewPosPI.value)
		self.viewPosNode:setPositionX(nodePos.x)
	end)
	local labelX = self:createLabel("视点坐标X")
	labelX:addTo(sliderX)
	labelX:setPositionX(posLabelX)
	labelX:setPositionY(posLabelY)
	sliderOffsetY = sliderOffsetY + stepY
	local sliderY = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
	local commonSlider = include("commonSlider")
	_ENV, sliderY = commonSlider.new(sliderY), commonSlider.new(sliderY)
	commonSlider.new(sliderY).maxValue = 4000
	commonSlider.new(sliderY).minValue = 1
	commonSlider.new(sliderY).curValue = viewPosPI.value.y + 2000
	local commonSlider.new(sliderY).openEditBox, sliderData = true, commonSlider.new(sliderY)
	sliderY:initData(sliderData)
	sliderY:addTo(nodeSlider)
	sliderY:setPosition(cc.p(sliderOffsetX, sliderOffsetY))
	sliderY:setLocalZOrder(10)
	sliderY:setSliderCallBack(function(valuechange)
		viewPosPI.value.y = valuechange - 2000
		dump(viewPosPI.value, "set y viewPosPI.value")
		programState:setUniformVec3(self.program:getUniform("viewPos").location, viewPosPI.value)
		if self.viewPosLabel then
			self.viewPosLabel:setString(string.format("视点(%d,%d,%d)", viewPosPI.value.x, viewPosPI.value.y, viewPosPI.value.z))
		end
		local nodePos = self.node_pet:convertToNodeSpace(viewPosPI.value)
		self.viewPosNode:setPositionY(nodePos.y)
	end)
	local labelY = self:createLabel("视点坐标Y")
	labelY:addTo(sliderY)
	labelY:setPositionX(posLabelX)
	sliderOffsetY = sliderOffsetY + stepY
	local sliderZ = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
	local commonSlider = include("commonSlider")
	_ENV, sliderZ = commonSlider.new(sliderZ), commonSlider.new(sliderZ)
	commonSlider.new(sliderZ).maxValue = 4000
	commonSlider.new(sliderZ).minValue = 1
	commonSlider.new(sliderZ).curValue = viewPosPI.value.z + 2000
	local commonSlider.new(sliderZ).openEditBox, sliderData = true, commonSlider.new(sliderZ)
	sliderZ:initData(sliderData)
	sliderZ:addTo(nodeSlider)
	sliderZ:setPosition(cc.p(sliderOffsetX, sliderOffsetY))
	sliderZ:setLocalZOrder(10)
	sliderZ:setSliderCallBack(function(valuechange)
		viewPosPI.value.z = valuechange - 2000
		dump(viewPosPI.value, "set z viewPosPI.value")
		programState:setUniformVec3(self.program:getUniform("viewPos").location, viewPosPI.value)
		if self.viewPosLabel then
			self.viewPosLabel:setString(string.format("视点(%d,%d,%d)", viewPosPI.value.x, viewPosPI.value.y, viewPosPI.value.z))
		end
		self.viewPosNode:setPositionZ(viewPosPI.value.z)
	end)
	local labelZ = self:createLabel("视点坐标Z")
	labelZ:addTo(sliderZ)
	labelZ:setPositionX(posLabelX)
	self.viewPosLabel = self:createLabel("视点坐标")
	self.viewPosLabel:addTo(nodeSlider)
	self.viewPosLabel:setPosition(cc.p(420, display.height - 150))
	self.viewPosLabel:setColor(cc.c3b(255, 0, 0))
	return nodeSlider
end
function petViewTest:printMeshes(sprite3d)
	local meshes = sprite3d:getMeshes()
	for _, mesh in ipairs(meshes) do
		local str = string.format("name:%s", mesh:getName())
		print(str)
		if mesh:getName():find("cloth") ~= nil then
		end
	end
end
return petViewTest
