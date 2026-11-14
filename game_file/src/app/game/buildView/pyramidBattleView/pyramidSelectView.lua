local gametop = gModuleMgr.getObject("gametop")
local pyramidWarCtrl = gametop.playertop_:getModule("pyramidWarCtrl")
local pyramidClientModule = include("pyramidClientModule")
local PyramidSelectView = class("pyramidSelectView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("pyramidSelectView")
	end
	return target
end)
function PyramidSelectView:ctor()
	self.spNewTitle = SoraDGetChildByName(self, "Sprite_newTitle")
	self.spSeasonTitle = SoraDGetChildByName(self, "Sprite_seasonTitle")
	self.nodeNew = SoraDGetChildByName(self, "Node_new")
	self.nodeSeason = SoraDGetChildByName(self, "Node_season")
	self.btnNew = SoraDGetChildByName(self, "Button_new")
	self.btnSeason = SoraDGetChildByName(self, "Button_season")
	self.btnNew:addTouchEventListener(handler(self, self.btnNewClick))
	self.btnSeason:addTouchEventListener(handler(self, self.btnSeasonClick))
	local _, isDown = SoraDIsFileExistByFileName("bg_JZT_gw01.png")
	if isDown then
		SoraDGetChildByName(self, "Image_newBanner"):loadTexture("bg_JZT_gw01.png", ccui.TextureResType.plistType)
	end
	_, isDown = SoraDIsFileExistByFileName("bg_JZT_gw02.png")
	if isDown then
		SoraDGetChildByName(self, "Image_seasonBanner"):loadTexture("bg_JZT_gw02.png", ccui.TextureResType.plistType)
	end
	SoraDGetChildByName(self, "Text_newCount"):setString(i18n("common_text_3300"))
	SoraDGetChildByName(self, "Text_seasonCount"):setString(i18n("common_text_3301"))
	self.txtLeftState = SoraDGetChildByName(self, "Text_newTip")
	self.txtLeftTime = SoraDGetChildByName(self, "Text_newTime")
	self.txtLeftTime = SoraDCreateTimerLabel(self, self.txtLeftTime)
	self.txtRightState = SoraDGetChildByName(self, "Text_seasonTip")
	self.txtRightState = SoraDCreateTimerLabel(self, self.txtRightState)
	if "ar" == GameLanguageCopy then
	else
		self.spNewTitle:setSpriteFrame("icon_battlefield_pyamid_en_01.png")
		self.spSeasonTitle:setSpriteFrame("icon_battlefield_pyamid_en_02.png")
	end
	self:initData()
	self:ani4LoadView()
	SoraDTestButton(self, function(...)
		local renderTexture = cc.RenderTexture:create(640, 960, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888, 35056)
		renderTexture:setPosition(self.nodeNew:getPositionX(), self.nodeNew:getPositionY())
		renderTexture:beginWithClear(0, 0, 0, 0)
		self.nodeNew:visit()
		renderTexture:endToLua()
		local renderSprite = renderTexture:getSprite():clone()
		renderSprite:retain()
		local bottomWaterShader = require("app.game.remainsView.shader.pyramidselect")
		local bottomMeshData = require("app.game.remainsView.meshData.pyramidselect_meshData")
		_ENV, _UPVALUE10_ = 0, "app.game.remainsView.meshData.pyramidselect_meshData"
		;(0).attr = "#texture"
		;(0).name = "_MainTex"
		;(0).value = renderSprite:getTexture()
		_ENV, (0).hasMipmap = renderSprite:getTexture(), false
		renderSprite:getTexture().attr = "texture"
		renderSprite:getTexture().name = "_Noise"
		renderSprite:getTexture().value = "3DTexture/remainswar/anniu02.png"
		_UPVALUE4_, renderSprite:getTexture().hasMipmap = renderSprite, false
		_ENV, renderSprite:getTexture().texParam, renderSprite[1] = renderSprite, renderSprite, gl.LINEAR
		_ENV, renderSprite:getTexture().texParam, renderSprite[2] = renderSprite, renderSprite, gl.LINEAR
		_ENV, renderSprite:getTexture().texParam, renderSprite[3] = renderSprite, renderSprite, gl.REPEAT
		_ENV, renderSprite:getTexture().texParam, renderSprite[4] = renderSprite, renderSprite, gl.REPEAT
		renderSprite.attr = "vec4"
		_ENV, renderSprite.name = gl.LINEAR, "_MainTex_ST"
		gl.LINEAR.x = 1
		gl.LINEAR.y = 1
		gl.LINEAR.z = 0
		_ENV, renderSprite.value, gl.LINEAR.w = gl.LINEAR, gl.LINEAR, 0
		gl.LINEAR.attr = "vec4"
		_ENV, gl.LINEAR.name = gl.LINEAR, "_Noise_ST"
		gl.LINEAR.x = 1
		gl.LINEAR.y = 1
		gl.LINEAR.z = 0.43
		_ENV, gl.LINEAR.value, gl.LINEAR.w = gl.LINEAR, gl.LINEAR, 0
		gl.LINEAR.attr = "float"
		gl.LINEAR.name = "_RJ_value"
		_ENV, gl.LINEAR.value = gl.REPEAT, -1.0
		gl.REPEAT.attr = "vec4"
		_ENV, gl.REPEAT.name = gl.REPEAT, "_Main_color"
		gl.REPEAT.x = 1
		gl.REPEAT.y = 1
		gl.REPEAT.z = 1
		_ENV, gl.REPEAT.value, gl.REPEAT.w = gl.REPEAT, gl.REPEAT, 1
		gl.REPEAT.attr = "float"
		gl.REPEAT.name = "_BK_value"
		_ENV, gl.REPEAT.value = self.nodeNew:getPositionY()
		self.nodeNew:getPositionY().attr = "float"
		self.nodeNew:getPositionY().name = "_BK_qiangdu"
		_ENV, self.nodeNew:getPositionY().value = self.nodeNew:getPositionY()
		self.nodeNew:getPositionY().attr = "vec4"
		_ENV, self.nodeNew:getPositionY().name = self.nodeNew:getPositionY()
		self.nodeNew:getPositionY().x = 0.125
		self.nodeNew:getPositionY().y = 0.08534484
		self.nodeNew:getPositionY().z = 0
		_ENV, self.nodeNew:getPositionY().value, self.nodeNew:getPositionY().w = self.nodeNew:getPositionY()
		self.nodeNew:getPositionY().attr = "float"
		self.nodeNew:getPositionY().name = "_power"
		self.nodeNew:getPositionY().value = -0.3
		_ENV, ("app.game.remainsView.meshData.pyramidselect_meshData")[1] = 0, 0
		_ENV, ("app.game.remainsView.meshData.pyramidselect_meshData")[2] = 0, renderSprite:getTexture()
		_ENV, ("app.game.remainsView.meshData.pyramidselect_meshData")[3] = 0, renderSprite
		_ENV, ("app.game.remainsView.meshData.pyramidselect_meshData")[4] = 0, gl.LINEAR
		_ENV, ("app.game.remainsView.meshData.pyramidselect_meshData")[5] = 0, gl.LINEAR
		_ENV, ("app.game.remainsView.meshData.pyramidselect_meshData")[6] = 0, gl.REPEAT
		_ENV, ("app.game.remainsView.meshData.pyramidselect_meshData")[7] = 0, gl.REPEAT
		_ENV, ("app.game.remainsView.meshData.pyramidselect_meshData")[8] = 0, self.nodeNew:getPositionY()
		_ENV, ("app.game.remainsView.meshData.pyramidselect_meshData")[9] = 0, self.nodeNew:getPositionY()
		local _ENV, ("app.game.remainsView.meshData.pyramidselect_meshData")[10], bottomParam = 0, self.nodeNew:getPositionY()
		;(0).meshData = bottomMeshData
		_ENV, (0).size = cc.size(1, 1), cc.size(1, 1)
		cc.size(1, 1).vertBytes = bottomWaterShader.vertBytes
		;(0).shader, cc.size(1, 1).fragBytes = cc.size(1, 1), bottomWaterShader.fragBytes
		;(0).param = bottomParam
		_ENV, (0).pos = cc.p(400, 480), cc.p(400, 480)
		cc.p(400, 480).x = 640.0
		;(0).scale, cc.p(400, 480).y = cc.p(400, 480), 960.0
		local bottomWaterData = 0
		local bottomWater = SoraDCreateMeshNode(bottomWaterData.meshData, bottomWaterData.size, bottomWaterData.shader, bottomWaterData.param)
		bottomWater:setPosition(cc.p(bottomWaterData.pos))
		bottomWater:setScale(bottomWaterData.scale.x, bottomWaterData.scale.y)
		bottomWater:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
		bottomWater:addTo(self, 100)
		self.bottomWater = bottomWater
		self.maxAnimate = -1
		if self.updateTimer then
			SoraDManagerRemoveTimer(self, self.updateTimer)
		end
		self.updateTimer = SoradCreateTimer(self, handler(self, self.updateAnimate), true)
	end)
end
function PyramidSelectView:updateAnimate(dt)
	self.maxAnimate = self.maxAnimate + dt
	if self.maxAnimate > 0 and self.updateTimer then
		SoraDManagerRemoveTimer(self, self.updateTimer)
	end
	local valuechange = self.maxAnimate
	local state = self.bottomWater:getGLProgramState()
	state:setUniformFloat("_RJ_value", valuechange)
end
function PyramidSelectView:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_MAINSTATECHANGE", handler(self, self.initData))
end
function PyramidSelectView:initData(...)
	self:initView()
end
function PyramidSelectView:initView(...)
	local _des, _ticket = pyramidClientModule.getDesFromState()
	self.txtLeftTime:removeTime()
	if _ticket then
		self.txtLeftTime:setVisible(true)
		self.txtLeftTime:beginTime(_ticket)
		self.txtLeftState:setContentSize(cc.size(160, 65))
		self.txtLeftState:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_BOTTOM)
		pyramidClientModule = cc.size(160, 65)
		cc.size(160, 65).time = ""
		self.txtLeftState:setString(i18n(_des, cc.size(160, 65)))
		self:openEye(self.nodeNew)
	else
		self.txtLeftTime:setVisible(false)
		self.txtLeftState:setContentSize(cc.size(160, 130))
		self.txtLeftState:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		self.txtLeftState:setString(i18n(_des))
		self:closeEye(self.nodeNew)
	end
	if pyramidWarCtrl:getPyramidWarSeasonType() ~= gSeasonType.REGULAR_SEASON and _ticket == nil then
		self.txtLeftTime:setVisible(false)
		self.txtLeftState:setVisible(false)
	end
	self:initPostSeason()
	self:setEffectShow(pyramidWarCtrl:getPyramidWarSeasonType())
end
function PyramidSelectView:initPostSeason()
	local _state = pyramidClientModule.getPostSeasonShowState()
	local _des, _ades, _ticket = pyramidClientModule.getDesFromPostSeasonState()
	self.txtRightState:removeTime()
	if _des ~= "" then
		self.txtRightState:setString(i18n(_des))
	else
		self.txtRightState:setString("")
	end
	if _state == 1 then
		self.txtRightState:setColor(cc.c3b(175, 175, 175))
		self:closeEye(self.nodeSeason)
	else
		self.txtRightState:setColor(cc.c3b(74, 255, 23))
		self:openEye(self.nodeSeason)
	end
	print("_des ", _des, _ades, _ticket)
	if _ades ~= "" then
		pyramidClientModule = cc.c3b(74, 255, 23)
		cc.c3b(74, 255, 23).time = "\n" .. SoraDConvertSecondToString(_ticket)
		self.txtRightState:setString(i18n(_des) .. "\n" .. i18n(_ades, cc.c3b(74, 255, 23)))
		self.txtRightState:setTimeLast(function(tick)
			_ENV = nil
			;(nil).time = "\n" .. tick
			local reText = i18n(_des) .. "\n" .. i18n(_ades, nil)
			return reText
		end)
		self.txtRightState:beginTime(_ticket)
	elseif _ticket then
		pyramidClientModule = i18n(_ades, cc.c3b(74, 255, 23))
		i18n(_ades, cc.c3b(74, 255, 23)).time = "\n" .. SoraDConvertSecondToString(_ticket)
		self.txtRightState:setString(i18n(_des, (i18n(_ades, cc.c3b(74, 255, 23)))))
		self.txtRightState:setTimeLast(function(tick)
			_ENV = nil
			;(nil).time = "\n" .. tick
			local reText = i18n(_des, nil)
			return reText
		end)
		self.txtRightState:beginTime(_ticket)
	end
end
function PyramidSelectView:ani4LoadView(...)
	self.nodeNew:setScale(0.1)
	self.nodeSeason:setScale(0.1)
	local hh = display.cy
	self.nodeNew:setPosition(cc.p(320, hh + 320))
	self.nodeSeason:setPosition(cc.p(320, hh + 320))
	_UPVALUE2_ = self.nodeSeason.setPosition
	_UPVALUE2_, self.nodeSeason.setPosition[1] = cc.p(35, hh + 220), cc.p(35, hh + 220)
	_UPVALUE2_, self.nodeSeason.setPosition[2] = cc.p(35, hh + 220), cc.p(15, hh + 120)
	_UPVALUE2_, self.nodeSeason.setPosition[3] = cc.p(35, hh + 220), cc.p(170, hh)
	_UPVALUE2_, self.nodeSeason.setPosition[4] = cc.p(35, hh + 220), cc.p(170, hh)
	_UPVALUE2_, self.nodeSeason.setPosition[5] = cc.p(35, hh + 220), cc.p(170, hh)
	_UPVALUE2_, self.nodeSeason.setPosition[6] = cc.p(35, hh + 220), cc.p(170, hh)
	_UPVALUE2_, self.nodeSeason.setPosition[7] = cc.p(35, hh + 220), cc.p(170, hh)
	_UPVALUE2_, self.nodeSeason.setPosition[8] = cc.p(35, hh + 220), cc.p(170, hh)
	_UPVALUE2_, self.nodeSeason.setPosition[9] = cc.p(35, hh + 220), cc.p(170, hh)
	_UPVALUE2_, self.nodeSeason.setPosition[10] = cc.p(35, hh + 220), cc.p(170, hh)
	_UPVALUE2_, self.nodeSeason.setPosition[11] = cc.p(35, hh + 220), cc.p(170, hh)
	_UPVALUE2_, self.nodeSeason.setPosition[12] = cc.p(35, hh + 220), cc.p(170, hh)
	local _UPVALUE2_, self.nodeSeason.setPosition[13], bezier1 = cc.p(35, hh + 220), cc.p(170, hh)
	cc.p(35, hh + 220)[1] = cc.p(605, hh + 220)
	cc.p(35, hh + 220)[2] = cc.p(625, hh + 120)
	cc.p(35, hh + 220)[3] = cc.p(470, hh)
	cc.p(35, hh + 220)[4] = cc.p(470, hh)
	cc.p(35, hh + 220)[5] = cc.p(470, hh)
	cc.p(35, hh + 220)[6] = cc.p(470, hh)
	cc.p(35, hh + 220)[7] = cc.p(470, hh)
	cc.p(35, hh + 220)[8] = cc.p(470, hh)
	cc.p(35, hh + 220)[9] = cc.p(470, hh)
	cc.p(35, hh + 220)[10] = cc.p(470, hh)
	cc.p(35, hh + 220)[11] = cc.p(470, hh)
	local cc.p(35, hh + 220)[12], bezier2 = cc.p(470, hh)
	local moveTo1 = cc.BezierTo:create(0.4, bezier1)
	local moveTo2 = cc.BezierTo:create(0.4, bezier2)
	local endFun1 = cca.callFunc(function(...)
		self:addClickEffect(self.btnNew)
	end)
	local endFun2 = cca.callFunc(function(...)
		self:addClickEffect(self.btnSeason)
	end)
	_UPVALUE2_ = cc.p(470, hh)
	cc.p(470, hh)[1] = cca.scaleTo(0.4, 1)
	cc.p(470, hh)[2] = endFun1
	local scaleTo1 = cca.seq(cc.p(470, hh))
	_UPVALUE2_ = cca.scaleTo(0.4, 1)
	cca.scaleTo(0.4, 1)[1] = cca.scaleTo(0.4, 1)
	cca.scaleTo(0.4, 1)[2] = endFun2
	local scaleTo2 = cca.seq((cca.scaleTo(0.4, 1)))
	_UPVALUE2_ = 1
	;(1)[1] = moveTo1
	;(1)[2] = scaleTo1
	self.nodeNew:runAction(cca.spawn(1))
	_UPVALUE2_ = cca.spawn(1)
	cca.spawn(1)[1] = moveTo2
	cca.spawn(1)[2] = scaleTo2
	self.nodeSeason:runAction(cca.spawn(cca.spawn(1)))
	SoraDPlaySound("pyramidBattle", 3)
end
function PyramidSelectView:closeEye(fNode)
	local nodeEyes = SoraDGetChildByName(fNode, "Node_eyes")
	local spEyeUp, spEyeDown
	if not nodeEyes:getChildByName("eye_cliperNode") then
		local shapNode = display.newCircle(25)
		local cliperNode = cc.ClippingNode:create()
		cliperNode:setName("eye_cliperNode")
		cliperNode:setStencil(shapNode)
		cliperNode:setInverted(false)
		cliperNode:addTo(nodeEyes)
		spEyeUp = nodeEyes:getChildByName("Sprite_eye_up")
		spEyeDown = nodeEyes:getChildByName("Sprite_eye_down")
		spEyeUp:retain()
		spEyeDown:retain()
		spEyeUp:removeFromParent()
		spEyeDown:removeFromParent()
		spEyeUp:addTo(cliperNode)
		spEyeDown:addTo(cliperNode)
		spEyeUp:release()
		spEyeDown:release()
	else
		spEyeUp = nodeEyes:getChildByName("eye_cliperNode"):getChildByName("Sprite_eye_up")
		spEyeDown = nodeEyes:getChildByName("eye_cliperNode"):getChildByName("Sprite_eye_down")
	end
	spEyeUp:stopAllActions()
	spEyeDown:stopAllActions()
	spEyeUp:runAction(cca.moveTo(0.2, 0, 0))
	spEyeDown:runAction(cca.moveTo(0.2, 0, 0))
end
function PyramidSelectView:openEye(fNode)
	local nodeEyes = SoraDGetChildByName(fNode, "Node_eyes")
	local spEye = SoraDGetChildByName(fNode, "Sprite_eye")
	local spEyeUp, spEyeDown
	if not nodeEyes:getChildByName("eye_cliperNode") then
		local shapNode = display.newCircle(25)
		local cliperNode = cc.ClippingNode:create()
		cliperNode:setName("eye_cliperNode")
		cliperNode:setStencil(shapNode)
		cliperNode:setInverted(false)
		cliperNode:addTo(nodeEyes)
		spEyeUp = nodeEyes:getChildByName("Sprite_eye_up")
		spEyeDown = nodeEyes:getChildByName("Sprite_eye_down")
		spEyeUp:retain()
		spEyeDown:retain()
		spEyeUp:removeFromParent()
		spEyeDown:removeFromParent()
		spEyeUp:addTo(cliperNode)
		spEyeDown:addTo(cliperNode)
		spEyeUp:release()
		spEyeDown:release()
	else
		spEyeUp = nodeEyes:getChildByName("eye_cliperNode"):getChildByName("Sprite_eye_up")
		spEyeDown = nodeEyes:getChildByName("eye_cliperNode"):getChildByName("Sprite_eye_down")
	end
	spEyeUp:stopAllActions()
	spEyeDown:stopAllActions()
	local blinkEyes = function(sY, eY)
		_UPVALUE5_ = nil
		;(nil)[1] = cca.moveTo(0.05, 0, sY)
		;(nil)[2] = cca.moveTo(0.05, 0, eY)
		;(nil)[3] = cca.delay(0.4)
		;(nil)[4] = cca.moveTo(0.1, 0, sY)
		;(nil)[5] = cca.moveTo(0.1, 0, eY)
		;(nil)[6] = cca.delay(4)
		;(nil)[7] = cca.delay(4)
		;(nil)[8] = cca.delay(4)
		return cc.RepeatForever:create(cca.seq(nil))
	end
	spEyeUp:runAction(blinkEyes(0, 27))
	spEyeDown:runAction(blinkEyes(0, -27))
	_UPVALUE5_ = blinkEyes(0, -27)
	blinkEyes(0, -27)[1] = cca.moveTo(0.1, -4, 2)
	blinkEyes(0, -27)[2] = cca.delay(0.5)
	blinkEyes(0, -27)[3] = cca.moveTo(0.1, 0, -4)
	blinkEyes(0, -27)[4] = cca.delay(0.5)
	blinkEyes(0, -27)[5] = cca.moveTo(0.1, 2, 2)
	blinkEyes(0, -27)[6] = cca.delay(4)
	blinkEyes(0, -27)[7] = cca.delay(4)
	blinkEyes(0, -27)[8] = cca.delay(4)
	spEye:runAction(cc.RepeatForever:create(cca.seq(blinkEyes(0, -27))))
end
function PyramidSelectView:addClickEffect(parent)
	local pSize = parent:getContentSize()
	_ENV, _ENV = nil, parent
	;(nil).plist = "et_shenglijiemian_04.plist"
	_ENV, parent[1], (nil).scale = nil, nil, 1.3
	;(nil).plist = "et_shenglijiemian_06.plist"
	_ENV, parent[2], (nil).scale = nil, nil, 2
	;(nil).plist = "et_shenglijiemian_03.plist"
	parent[3], (nil).scale = nil, 8.4
	local param = parent
	local et_node = SoraDCreateEffectNode(param, nil, true)
	et_node:setPosition(cc.p(pSize.width / 2, pSize.height / 2))
	et_node:addTo(parent, 2)
end
function PyramidSelectView:btnNewClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		self.nodeNew:setScale(1)
		SoraDPlaySound()
		SoraDCreatePanel("pyramidBattleMainView"):show()
	elseif eventType == ccui.TouchEventType.canceled then
		self.nodeNew:setScale(1)
		SoraDPlaySound()
	elseif eventType == ccui.TouchEventType.began then
		self.nodeNew:setScale(0.9)
		self:addClickEffect(button)
	end
end
function PyramidSelectView:btnSeasonClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.nodeSeason:setScale(1)
		local state = pyramidClientModule.getPostSeasonShowState()
		if state <= 2 then
			SoraDCreatePanel("pyramidPlayoffsStateView"):show()
		elseif state == 3 then
			SoraDCreatePanel("pyramidPlayoffsView"):show()
		elseif state == 4 then
			SoraDCreatePanel("pyramidPlayoffsFinalMatchView"):show()
		elseif state == 5 then
			SoraDCreatePanel("pyramidPlayoffsFinalMatchView"):show()
		elseif state == 6 then
			SoraDCreatePanel("pyramidBattleHonourBoard"):show()
		end
	elseif eventType == ccui.TouchEventType.canceled then
		self.nodeSeason:setScale(1)
		SoraDPlaySound()
	elseif eventType == ccui.TouchEventType.began then
		self:addClickEffect(button)
		self.nodeSeason:setScale(0.9)
	end
end
function PyramidSelectView:setEffectShow(battleType)
	_UPVALUE6_ = nil
	;(nil)[1] = "dh_bg"
	;(nil)[2] = "dh_top"
	;(nil)[3] = "Particle_1"
	;(nil)[4] = "Particle_2"
	;(nil)[5] = "Particle_3"
	local (nil)[6], effectName = "Particle_4", nil
	for k, v in pairs(effectName) do
		if self.nodeSeason:getChildByName(v) then
			self.nodeSeason:getChildByName(v):setVisible(battleType == gSeasonType.PINNACLE_SEASON)
		end
		if self.nodeNew:getChildByName(v) then
			self.nodeNew:getChildByName(v):setVisible(battleType == gSeasonType.REGULAR_SEASON)
		end
	end
end
return PyramidSelectView
