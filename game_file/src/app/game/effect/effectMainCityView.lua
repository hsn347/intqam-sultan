local buildLogic = include("buildLogic")
local gametop = gModuleMgr.getObject("gametop")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local cityBuildFunction = include("cityBuildFunction")
local cityBuildConstDef = include("cityBuildConstDef")
local cityBuildCreator = include("cityBuildCreator")
local cityBuildViewDef = include("cityBuildViewDef")
local wallsCtrl = gametop.playertop_:getModule("wallsCtrl")
local loginRewardCtrl = gametop.playertop_:getModule("loginRewardCtrl")
local everydayTaskCtrl = gametop.playertop_:getModule("everydayTaskCtrl")
local mainCityFunctions = include("mainCityFunctions")
local dressltCtrl = include("dressltCtrl")
local cityBuildCastleSkinConfig = include("cityBuildCastleSkinConfig")
local cityBuildWallDef = include("cityBuildWallDef")
local cityNightSkinDef = include("cityNightSkinDef")
local mainCityDefine = include("mainCityDefine")
local funUnlockRead = include("funUnlockRead")
_ENV = "funUnlockRead"
local ("funUnlockRead").GLOBAL_MAINCITY_SHIP, effectMainCityView = nil, "funUnlockRead"
function effectMainCityView.showPyramidHonourBuildEffect(mainCity, isRemove)
	local self = mainCity
	if not mainCity then
		return
	end
	if self.containerView:getChildByName("et_node_pyramid_lion") then
		self.containerView:removeChildByName("et_node_pyramid_lion", true)
	end
	if isRemove then
		return
	end
	_ENV, _ENV = self.containerView, self.containerView.removeChildByName
	self.containerView.plist = "et_diaoxiang_03.plist"
	self.containerView.scale = 0.8
	_ENV, self.containerView.removeChildByName[1], self.containerView.rotate = self.containerView, self.containerView, 21.21
	_ENV, self.containerView.plist = "et_node_pyramid_lion", "et_diaoxiang_02.plist"
	;("et_node_pyramid_lion").x = -16
	_ENV, self.containerView.pos, ("et_node_pyramid_lion").y = "et_node_pyramid_lion", "et_node_pyramid_lion", -33
	;("et_node_pyramid_lion").x = 0.514
	self.containerView.scale, ("et_node_pyramid_lion").y = "et_node_pyramid_lion", 1
	_ENV, self.containerView.removeChildByName[2], self.containerView.rotate = self.containerView, self.containerView, 27.25
	_ENV, self.containerView.plist = "et_node_pyramid_lion", "et_diaoxiang_01.plist"
	;("et_node_pyramid_lion").x = -15
	self.containerView.removeChildByName[3], self.containerView.pos, ("et_node_pyramid_lion").y = self.containerView, "et_node_pyramid_lion", -37
	local param = self.containerView.removeChildByName
	local et_node = SoraDCreateEffectNode(param)
	et_node:setName("et_node_pyramid_lion")
	et_node:setPosition(cc.p(7001.0, 3851.0))
	et_node:addTo(self.containerView, 1500)
end
function effectMainCityView.showPyramidBattleEffect(mainCity, isRemove)
	local self = mainCity
	if not mainCity then
		return
	end
	if self.containerView:getChildByName("et_node_pyramid_battle") then
		self.containerView:removeChildByName("et_node_pyramid_battle", true)
	end
	if isRemove then
		return
	end
	_ENV, _ENV = self.containerView, self.containerView.removeChildByName
	_ENV, self.containerView.plist = "et_node_pyramid_battle", "et_zhaishengjiecb_02.plist"
	;("et_node_pyramid_battle").x = 1.5
	self.containerView.scale, ("et_node_pyramid_battle").y = "et_node_pyramid_battle", 2.08
	self.containerView.pos = cc.p(7554.5, 3892.5)
	_ENV, self.containerView.removeChildByName[1], self.containerView.rotate = self.containerView, self.containerView, 234.38
	self.containerView.plist = "et_jinzita_01.plist"
	self.containerView.pos = cc.p(7554.5, 3882.0)
	self.containerView.removeChildByName[2], self.containerView.rotate = self.containerView, 236.64
	local param = self.containerView.removeChildByName
	local et_node = SoraDCreateEffectNode(param)
	et_node:setName("et_node_pyramid_battle")
	et_node:addTo(self.containerView, 1500)
end
function effectMainCityView.fireWork(target)
	local frames = 60
	local parent = display.getRunningScene()
	local dh_firework1 = display.newSprite("#dh_gift_fire_03.png")
	dh_firework1:setOpacity(100)
	dh_firework1:setPosition(cc.p(display.cx - 78.78 - 30, -38))
	dh_firework1:addTo(parent, 9)
	local dh_firework2 = display.newSprite("#dh_gift_fire_01.png")
	dh_firework2:setOpacity(100)
	dh_firework2:setPosition(cc.p(display.cx + 0.07, 0))
	dh_firework2:addTo(parent, 9)
	local dh_firework3 = display.newSprite("#dh_gift_fire_02.png")
	dh_firework3:setOpacity(100)
	dh_firework3:setPosition(cc.p(display.cx + 66.29 + 30, -62))
	dh_firework3:addTo(parent, 9)
	local firework1 = function()
		frames, frames = nil, nil
		frames, (nil).plist = nil, "et_gift_fire_07.plist"
		;(nil).x = 0.2
		;(nil).pos, (nil).y = nil, -1.87
		frames, (nil)[1], (nil).delay = nil, nil, 25 / frames
		frames, (nil).plist = 25 / frames, "et_gift_fire_08.plist"
		;(25 / frames).x = 0.2
		;(nil).pos, (25 / frames).y = 25 / frames, -1.87
		;(nil).scale = 2
		frames, (nil)[2], (nil).delay = nil, nil, 25 / frames
		frames, (nil).plist = 25 / frames, "et_gift_fire_09.plist"
		;(25 / frames).x = 0.2
		;(nil).pos, (25 / frames).y = 25 / frames, -1.87
		;(nil).scale = 3
		;(nil)[3], (nil).delay = nil, 20 / frames
		local param
		local et_node = SoraDCreateEffectNode(param)
		et_node:addTo(dh_firework1, 2)
	end
	_UPVALUE2_ = parent
	parent[1] = cca.moveBy(20 / frames, 0, display.cy + 220)
	parent[2] = cca.fadeOut(21 / frames)
	parent[3] = cca.callFunc(firework1)
	parent[4] = cca.callFunc(firework1)
	parent[5] = cca.callFunc(firework1)
	parent[6] = cca.callFunc(firework1)
	parent[7] = cca.callFunc(firework1)
	parent[8] = cca.callFunc(firework1)
	parent[9] = cca.callFunc(firework1)
	parent[10] = cca.callFunc(firework1)
	parent[11] = cca.callFunc(firework1)
	parent[12] = cca.callFunc(firework1)
	local action1 = cca.spawn(parent)
	_UPVALUE3_ = cca.callFunc(firework1)
	cca.callFunc(firework1)[1] = cca.delay(0.1)
	cca.callFunc(firework1)[2] = action1
	cca.callFunc(firework1)[3] = cca.delay(0.5)
	cca.callFunc(firework1)[4] = cca.callFunc(function()
		dh_firework1:removeFromParent()
	end)
	cca.callFunc(firework1)[5] = cca.callFunc(function()
		dh_firework1:removeFromParent()
	end)
	cca.callFunc(firework1)[6] = cca.callFunc(function()
		dh_firework1:removeFromParent()
	end)
	cca.callFunc(firework1)[7] = cca.callFunc(function()
		dh_firework1:removeFromParent()
	end)
	cca.callFunc(firework1)[8] = cca.callFunc(function()
		dh_firework1:removeFromParent()
	end)
	cca.callFunc(firework1)[9] = cca.callFunc(function()
		dh_firework1:removeFromParent()
	end)
	dh_firework1:runAction(cca.seq(cca.callFunc(firework1)))
	local firework2 = function()
		frames, frames = nil, nil
		frames, (nil).plist = nil, "et_gift_fire_01.plist"
		;(nil).x = 0.2
		;(nil).pos, (nil).y = nil, -1.87
		frames, (nil)[1], (nil).delay = nil, nil, 25 / frames
		frames, (nil).plist = 25 / frames, "et_gift_fire_02.plist"
		;(25 / frames).x = 0.2
		;(nil).pos, (25 / frames).y = 25 / frames, -1.87
		;(nil).scale = 2
		frames, (nil)[2], (nil).delay = nil, nil, 25 / frames
		frames, (nil).plist = 25 / frames, "et_gift_fire_03.plist"
		;(25 / frames).x = 0.2
		;(nil).pos, (25 / frames).y = 25 / frames, -1.87
		;(nil).scale = 5
		;(nil)[3], (nil).delay = nil, 20 / frames
		local param
		local et_node = SoraDCreateEffectNode(param, folder)
		et_node:setScale(1.5)
		et_node:addTo(dh_firework2, 2)
	end
	_UPVALUE2_ = cca.seq(cca.callFunc(firework1))
	cca.seq(cca.callFunc(firework1))[1] = cca.moveBy(20 / frames, 0, display.cy + 220)
	cca.seq(cca.callFunc(firework1))[2] = cca.fadeOut(21 / frames)
	cca.seq(cca.callFunc(firework1))[3] = cca.callFunc(firework2)
	cca.seq(cca.callFunc(firework1))[4] = cca.callFunc(firework2)
	cca.seq(cca.callFunc(firework1))[5] = cca.callFunc(firework2)
	cca.seq(cca.callFunc(firework1))[6] = cca.callFunc(firework2)
	cca.seq(cca.callFunc(firework1))[7] = cca.callFunc(firework2)
	cca.seq(cca.callFunc(firework1))[8] = cca.callFunc(firework2)
	cca.seq(cca.callFunc(firework1))[9] = cca.callFunc(firework2)
	cca.seq(cca.callFunc(firework1))[10] = cca.callFunc(firework2)
	local action2 = cca.spawn(cca.seq(cca.callFunc(firework1)))
	_UPVALUE2_ = cca.callFunc(firework2)
	cca.callFunc(firework2)[1] = action2
	cca.callFunc(firework2)[2] = cca.delay(0.5)
	cca.callFunc(firework2)[3] = cca.callFunc(function()
		dh_firework2:removeFromParent()
	end)
	cca.callFunc(firework2)[4] = cca.callFunc(function()
		dh_firework2:removeFromParent()
	end)
	cca.callFunc(firework2)[5] = cca.callFunc(function()
		dh_firework2:removeFromParent()
	end)
	cca.callFunc(firework2)[6] = cca.callFunc(function()
		dh_firework2:removeFromParent()
	end)
	cca.callFunc(firework2)[7] = cca.callFunc(function()
		dh_firework2:removeFromParent()
	end)
	dh_firework2:runAction(cca.seq(cca.callFunc(firework2)))
	local firework3 = function()
		frames, frames = nil, nil
		frames, (nil).plist = nil, "et_gift_fire_04.plist"
		;(nil).x = 0.2
		;(nil).pos, (nil).y = nil, -1.87
		frames, (nil)[1], (nil).delay = nil, nil, 25 / frames
		frames, (nil).plist = 25 / frames, "et_gift_fire_05.plist"
		;(25 / frames).x = 0.2
		;(nil).pos, (25 / frames).y = 25 / frames, -1.87
		;(nil).scale = 2
		frames, (nil)[2], (nil).delay = nil, nil, 25 / frames
		frames, (nil).plist = 25 / frames, "et_gift_fire_06.plist"
		;(25 / frames).x = 0.2
		;(nil).pos, (25 / frames).y = 25 / frames, -1.87
		;(nil).scale = 3
		;(nil)[3], (nil).delay = nil, 20 / frames
		local param
		local et_node = SoraDCreateEffectNode(param, folder)
		et_node:addTo(dh_firework3, 2)
	end
	_UPVALUE3_ = cca.seq(cca.callFunc(firework2))
	cca.seq(cca.callFunc(firework2))[1] = cca.delay(20)
	cca.seq(cca.callFunc(firework2))[2] = cca.moveBy(20 / frames, 0, display.cy + 220)
	cca.seq(cca.callFunc(firework2))[3] = cca.fadeOut(21 / frames)
	cca.seq(cca.callFunc(firework2))[4] = cca.callFunc(firework3)
	cca.seq(cca.callFunc(firework2))[5] = cca.callFunc(firework3)
	cca.seq(cca.callFunc(firework2))[6] = cca.callFunc(firework3)
	cca.seq(cca.callFunc(firework2))[7] = cca.callFunc(firework3)
	cca.seq(cca.callFunc(firework2))[8] = cca.callFunc(firework3)
	local action3 = cca.spawn(cca.seq(cca.callFunc(firework2)))
	_UPVALUE3_ = cca.fadeOut(21 / frames)
	cca.fadeOut(21 / frames)[1] = cca.delay(0.2)
	cca.fadeOut(21 / frames)[2] = action3
	cca.fadeOut(21 / frames)[3] = cca.delay(0.5)
	cca.fadeOut(21 / frames)[4] = cca.callFunc(function()
		dh_firework3:removeFromParent()
	end)
	cca.fadeOut(21 / frames)[5] = cca.callFunc(function()
		dh_firework3:removeFromParent()
	end)
	dh_firework3:runAction(cca.seq((cca.fadeOut(21 / frames))))
end
function effectMainCityView.waterfall(mainCity)
	local self = mainCity
	if not mainCity then
		return
	end
	local cityWaterNode = display.newNode()
	cityWaterNode:setPosition(cc.p(0, 0))
	cityWaterNode:addTo(self.containerView, mainCityDefine.CITY_TARGET_ZORDER.bg)
	self.cityWaterNode = cityWaterNode
	print("创建内城水特效-----------------------begin")
	effectMainCityView.addWaterEffectByFaction(mainCity, SoraDGetFactionType())
	print("创建内城水特效-----------------------end")
	local imgQualityKey = "Game:GameOptionsView:showImgQuality~bool"
	local channel = userSDKManager.getChannel()
	if channel == "fa" then
		imgQualityKey = "Game:GameOptionsView:showImgQuality_iran~bool"
	end
	_ENV = SoraDGetFactionType()
	SoraDGetFactionType().byUID = true
	gIsGameHeighQuality = SoraDConfigGet(imgQualityKey, SoraDGetFactionType())
	if gIsGameHeighQuality then
		self.cityWaterNode:setVisible(true)
	else
		self.cityWaterNode:setVisible(false)
	end
end
function effectMainCityView.updateWaterEffect(mainCity)
	local self = mainCity
	if not mainCity then
		return
	end
	print("effectMainCityView.updateWaterEffect")
	local isHightQuality = SoraDIsGrapicsQualityHeigh()
	if self.waterShaderNodes == nil and isHightQuality then
		effectMainCityView.addWaterEffectByFaction(mainCity, SoraDGetFactionType())
	else
		if not self.waterShaderNodes then
			_ENV = self.waterShaderNodes
		end
		for i, v in ipairs(self.waterShaderNodes) do
			if not tolua.isnull(v) then
				v:setVisible(isHightQuality)
			end
		end
	end
end
function effectMainCityView.addWaterEffectByFaction(mainCity, factionType)
	print("factionType===", factionType)
	if not SoraDIsGrapicsQualityHeigh() then
		return
	end
	local self = mainCity
	if not mainCity then
		return
	end
	self.waterShaderNodes, _ENV = "factionType===", "factionType==="
	if factionType == FACTION_TYPE.FACTION_NORMAL then
		if not mainCityDefine.waterCfg then
			_ENV = mainCityDefine.waterCfg
		end
		for k, v in pairs(mainCityDefine.waterCfg) do
			local node = effectMainCityView.createShaderEffect(mainCity, v)
			table.insert(self.waterShaderNodes, node)
		end
	elseif factionType == FACTION_TYPE.FACTION_BYZANTINE then
		if not mainCityDefine.effectCfg then
			_ENV = mainCityDefine.effectCfg
		end
		for k, v in pairs(mainCityDefine.effectCfg) do
			effectMainCityView.createShaderEffect(mainCity, v)
			table.insert(self.waterShaderNodes, node)
		end
	end
end
function effectMainCityView.createShaderEffect(mainCity, cfg)
	local _shader = require(cfg.shader)
	local _meshData = require(cfg.meshData)
	local _param = require(cfg.param)
	local effectNode = SoraDCreateMeshNode(_meshData, cc.size(1, 1), _shader, _param.param)
	effectNode:setName(cfg.name)
	effectNode:setPosition(cc.p(unpack(cfg.position)))
	effectNode:setScale(unpack(cfg.scale))
	effectNode:setVisible(true)
	effectNode:addTo(mainCity.cityWaterNode, 1)
	if cfg.opacity then
		effectNode:setOpacity(cfg.opacity)
	end
	if cfg.blend then
		effectNode:setBlendFunc(cfg.blend[1], cfg.blend[2])
	else
		effectNode:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	end
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
		drawNode:setLocalZOrder(999999)
		drawNode:setName("effectNodeSize")
	end
	if not cfg.sliderPos then
		return effectNode
	end
	local handlerNode = effectNode
	local sliderOffsetX = 200
	local sliderOffsetY = 500
	local sliderX = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
	local commonSlider = include("commonSlider")
	_ENV, sliderX = commonSlider.new(sliderX), commonSlider.new(sliderX)
	commonSlider.new(sliderX).maxValue = 5000
	commonSlider.new(sliderX).minValue = 1
	commonSlider.new(sliderX).curValue = cfg.position[1]
	local commonSlider.new(sliderX).openEditBox, sliderData = true, commonSlider.new(sliderX)
	sliderX:initData(sliderData)
	sliderX:addTo(mainCity.containerView)
	sliderX:setPosition(cc.p(cfg.sliderPos[1] + sliderOffsetX, cfg.sliderPos[2] + 120 + sliderOffsetY))
	sliderX:setLocalZOrder(10000)
	sliderX:setSliderCallBack(function(valuechange)
		handlerNode:setPositionX(valuechange)
	end)
	local sliderY = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
	local commonSlider = include("commonSlider")
	_ENV, sliderY = commonSlider.new(sliderY), commonSlider.new(sliderY)
	commonSlider.new(sliderY).maxValue = 3600
	commonSlider.new(sliderY).minValue = 1
	commonSlider.new(sliderY).curValue = cfg.position[2]
	local commonSlider.new(sliderY).openEditBox, sliderData = true, commonSlider.new(sliderY)
	sliderY:initData(sliderData)
	sliderY:addTo(mainCity.containerView)
	sliderY:setPosition(cc.p(cfg.sliderPos[1] + sliderOffsetX, cfg.sliderPos[2] + 60 + sliderOffsetY))
	sliderY:setLocalZOrder(10000)
	sliderY:setSliderCallBack(function(valuechange)
		handlerNode:setPositionY(valuechange)
	end)
	local scale = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
	local commonSlider = include("commonSlider")
	_ENV, scale = commonSlider.new(scale), commonSlider.new(scale)
	commonSlider.new(scale).maxValue = 300
	commonSlider.new(scale).minValue = 1
	commonSlider.new(scale).curValue = cfg.scale[1] * 100
	local commonSlider.new(scale).openEditBox, sliderData = true, commonSlider.new(scale)
	scale:initData(sliderData)
	scale:addTo(mainCity.containerView)
	scale:setPosition(cc.p(cfg.sliderPos[1] + sliderOffsetX, cfg.sliderPos[2] + sliderOffsetY))
	scale:setLocalZOrder(10000)
	scale:setSliderCallBack(function(valuechange)
		handlerNode:setScale(valuechange / 100)
	end)
	return effectNode
end
function effectMainCityView.finishEffect(target, pos, isCollege, isToBag)
	if SoraDCurrentTopPanelFromManager() then
		return
	end
	local myPos = target:convertToWorldSpace(pos)
	local mutiple = 0.5
	local parent = display.getRunningScene()
	local powerPos = cc.p(display.cx, display.height - 105)
	if isToBag then
		powerPos = cc.p(SoraDFPosX(440, 640), 100)
	end
	local spriteName = "#et_yellow_xlwctx_display_01.png"
	local plistPath = "Particle/et_yellow_xlwctx_display.plist"
	local frameFormat = "et_yellow_xlwctx_display_%.2d.png"
	if isCollege then
		spriteName = "#et_orange_zhandouli_display_01.png"
		plistPath = "Particle/et_orange_zhandouli_display.plist"
		frameFormat = "et_orange_zhandouli_display_%.2d.png"
	end
	local powerNode = display.newNode()
	powerNode:setPosition(cc.p(myPos.x, myPos.y))
	powerNode:addTo(parent, 9)
	local powerSprite = display.newSprite(spriteName)
	local rotation = math.deg(math.atan((powerPos.y - myPos.y) / math.abs(powerPos.x - myPos.x))) - 180
	if myPos.x < display.cx then
		rotation = -180 - rotation
	end
	powerSprite:setRotation(rotation)
	powerSprite:addTo(powerNode)
	local particle_power = cc.ParticleSystemQuad:create(plistPath)
	particle_power:setPosition(cc.p(110, 38))
	particle_power:setRotation(180)
	particle_power:setPositionType(cc.POSITION_TYPE_RELATIVE)
	particle_power:addTo(powerSprite)
	local frames = display.newFrames(frameFormat, 1, 9)
	local animation = display.newAnimation(frames, mutiple * 1.0 / 9)
	powerSprite:playAnimationOnce(animation)
	_UPVALUE1_ = powerSprite
	powerSprite[1] = cca.moveTo(1 * mutiple, powerPos.x, powerPos.y)
	powerSprite[2] = cca.callFunc(function()
		powerNode:removeFromParent()
	end)
	powerSprite[3] = cca.callFunc(function()
		powerNode:removeFromParent()
	end)
	powerSprite[4] = cca.callFunc(function()
		powerNode:removeFromParent()
	end)
	local seq = transition.sequence(powerSprite)
	powerNode:runAction(seq)
end
function effectMainCityView.addXiyiAnimation(mainCity)
	local self = mainCity
	_ENV, _ENV = nil, nil
	;(nil).basePos = cc.p(5935, 1419)
	;(nil).targetPos = cc.p(6637, 1698)
	;(nil).rotation = 0
	_ENV, (nil)[1], (nil).isFlippedX = nil, nil, false
	;(nil).basePos = cc.p(4904, 1300)
	;(nil).targetPos = cc.p(4927, 710)
	;(nil).rotation = 90
	_ENV, (nil)[2], (nil).isFlippedX = nil, nil, false
	;(nil).basePos = cc.p(5853, 1528)
	;(nil).targetPos = cc.p(6280, 816)
	;(nil).rotation = 90
	;(nil)[3], (nil).isFlippedX = nil, false
	local xiyiAnimData
	local xiyiSpeed = 50
	local runXiyiAnimation = function(sprite, xiyiData)
		local distance = cc.pGetDistance(xiyiData.basePos, xiyiData.targetPos)
		local dt = distance / xiyiSpeed
		local callFunc1 = cca.callFunc(function()
			local frames = display.newFrames("xiyi_0%d.png", 1, 8)
			local animation = display.newAnimation(frames, 0.05)
			local animate = cc.Animate:create(animation)
			sprite:setFlippedX(xiyiData.isFlippedX)
			local repeatForever = cca.repeatForever(animate)
			repeatForever:setTag(10)
			sprite:runAction(repeatForever)
		end)
		local moveBy1 = cca.moveBy(dt, xiyiData.targetPos.x - xiyiData.basePos.x, xiyiData.targetPos.y - xiyiData.basePos.y)
		local callFunc2 = cca.callFunc(function()
			local fadeTo = cca.fadeTo(0.3, 0)
			sprite:runAction(fadeTo)
		end)
		local delay = cca.delay(0.4)
		local callFuncReset = cca.callFunc(function()
			sprite:setPosition(xiyiData.basePos)
			sprite:setOpacity(255)
			sprite:setVisible(true)
			sprite:stopActionByTag(10)
		end)
		local delay = cca.delay(math.random(3, 5))
		_UPVALUE5_ = math.random(3, 5)
		math.random(3, 5)[1] = callFunc1
		math.random(3, 5)[2] = moveBy1
		math.random(3, 5)[3] = callFunc2
		math.random(3, 5)[4] = delay
		math.random(3, 5)[5] = callFuncReset
		sprite:runAction(cca.repeatForever(cca.seq(math.random(3, 5))))
	end
	for i = 1, 3 do
		local sprite = display.newSprite("#" .. "xiyi_01.png")
		self.batchNodeXiyiNpc:addChild(sprite)
		sprite:setLocalZOrder(i)
		sprite:setRotation(xiyiAnimData[i].rotation)
		sprite:setPosition(xiyiAnimData[i].basePos)
		runXiyiAnimation(sprite, xiyiAnimData[i])
	end
end
function effectMainCityView.addActivityCentetNpc(mainCity)
	local self = mainCity
	local sprite = display.newSprite("#" .. "funvxiaohai_01.png")
	self.containerView:addChild(sprite, mainCityDefine.CITY_TARGET_ZORDER.npc)
	sprite:setPosition(cc.p(2336, 3241))
	local callFunc1 = cca.callFunc(function()
		local frames = display.newFrames("funvxiaohai_0%d.png", 1, 8)
		local animation = display.newAnimation(frames, 0.175)
		local animate = cc.Animate:create(animation)
		sprite:setFlippedX(false)
		local repeatForever = cca.repeatForever(animate)
		repeatForever:setTag(20)
		sprite:runAction(repeatForever)
	end)
	local callFunc2 = cca.callFunc(function()
		sprite:stopAllActionsByTag(20)
		local frame = display.newSpriteFrame("funvxiaohai_01.png")
		sprite:setSpriteFrame(frame)
	end)
	_UPVALUE3_ = cc.p(2336, 3241)
	cc.p(2336, 3241)[1] = callFunc1
	cc.p(2336, 3241)[2] = cca.delay(2.8)
	cc.p(2336, 3241)[3] = callFunc2
	cc.p(2336, 3241)[4] = cca.delay(math.random(2, 4))
	cc.p(2336, 3241)[5] = cca.delay(math.random(2, 4))
	cc.p(2336, 3241)[6] = cca.delay(math.random(2, 4))
	cc.p(2336, 3241)[7] = cca.delay(math.random(2, 4))
	local actSeq = cca.seq(cc.p(2336, 3241))
	sprite:runAction(cca.repeatForever(actSeq))
end
function effectMainCityView.addCastleGateNpc(mainCity)
	local self = mainCity
	local sprite = display.newSprite("#shiming_01.png")
	sprite:setScale(0.5)
	sprite:setLocalZOrder(mainCityDefine.CITY_TARGET_ZORDER.npc)
	self.containerView:addChild(sprite)
	sprite:setPosition(cc.p(2790, 3300))
	local frames = display.newFrames("shiming_%02d.png", 1, 16)
	local animation = display.newAnimation(frames, 0.125)
	sprite:playAnimationForever(animation)
	self.npcCastlePeople = sprite
end
function effectMainCityView.addHarborWorker(mainCity)
	local self = mainCity
	local basePos = cc.p(5850, 3110)
	local guardSpeed = 20
	local baseTarget = cc.p(5650, 3210)
	local distance = cc.pGetDistance(basePos, baseTarget)
	local runHarborAnimation = function(sprite, reverse)
		local dt = distance / guardSpeed
		local callFunc1 = cca.callFunc(function()
			local frames = display.newFrames("banyungong_wn_0%d.png", 1, 8)
			local animation = display.newAnimation(frames, 0.125)
			local animate = cc.Animate:create(animation)
			sprite:setFlippedX(false)
			local repeatForever = cca.repeatForever(animate)
			repeatForever:setTag(10)
			sprite:runAction(repeatForever)
			sprite:stopActionByTag(20)
		end)
		local moveBy1 = cca.moveBy(dt, baseTarget.x - basePos.x, baseTarget.y - basePos.y)
		local callFunc2 = cca.callFunc(function()
			local frames = display.newFrames("banyungong_es_0%d.png", 1, 8)
			local animation = display.newAnimation(frames, 0.125)
			local animate = cc.Animate:create(animation)
			sprite:setFlippedX(false)
			local repeatForever = cca.repeatForever(animate)
			repeatForever:setTag(20)
			sprite:runAction(repeatForever)
			sprite:stopAllActionsByTag(10)
		end)
		local moveBy2 = moveBy1:reverse()
		if not reverse then
			basePos = nil
			;(nil)[1] = callFunc1
			;(nil)[2] = moveBy1
			;(nil)[3] = callFunc2
			;(nil)[4] = moveBy2
			sprite:runAction(cca.repeatForever(cca.seq(nil)))
		else
			basePos = cca.repeatForever(cca.seq(nil))
			cca.repeatForever(cca.seq(nil))[1] = callFunc2
			cca.repeatForever(cca.seq(nil))[2] = moveBy2
			cca.repeatForever(cca.seq(nil))[3] = callFunc1
			cca.repeatForever(cca.seq(nil))[4] = moveBy1
			sprite:runAction(cca.repeatForever(cca.seq(cca.repeatForever(cca.seq(nil)))))
		end
	end
	for i = 1, 2 do
		local sprite = display.newSprite("#" .. "banyungong_wn_01.png")
		self.batchNodeNpc:addChild(sprite)
		sprite:setLocalZOrder(i)
		if i == 1 then
			sprite:setPosition(basePos)
			runHarborAnimation(sprite)
		else
			runHarborAnimation(sprite, true)
			sprite:setPosition(cc.pAdd(baseTarget, cc.p(-15, -10)))
		end
	end
end
function effectMainCityView.addConquerGateAnimation(mainCity)
	local self = mainCity
	if not self.buttonConquer then
		return
	end
	_ENV, _ENV = nil, self.buttonConquer
	_ENV, (nil).png = nil, "shibing1_02.png"
	;(nil).x = 45
	;(nil).pos, (nil).y = nil, 75
	_ENV, self.buttonConquer[1], (nil).isAct = nil, nil, false
	_ENV, (nil).png = nil, "shibing1_02.png"
	;(nil).x = -45
	;(nil).pos, (nil).y = nil, 60
	_ENV, self.buttonConquer[2], (nil).isAct = nil, nil, false
	_ENV, (nil).png = nil, "shibing1_02.png"
	;(nil).x = -10
	;(nil).pos, (nil).y = nil, 45
	_ENV, self.buttonConquer[3], (nil).isAct = nil, nil, false
	_ENV, (nil).png = nil, "shibing1_02.png"
	;(nil).x = 75
	;(nil).pos, (nil).y = nil, 60
	_ENV, self.buttonConquer[4], (nil).isAct = nil, nil, false
	_ENV, (nil).png = nil, "shibing1_02.png"
	;(nil).x = 15
	;(nil).pos, (nil).y = nil, 90
	_ENV, self.buttonConquer[5], (nil).isAct = nil, nil, false
	_ENV, (nil).png = nil, "shibing1_02.png"
	;(nil).x = 25
	;(nil).pos, (nil).y = nil, 30
	_ENV, self.buttonConquer[6], (nil).isAct = nil, nil, false
	_ENV, (nil).png = nil, "qibingqizhi_01.png"
	;(nil).x = 90
	;(nil).pos, (nil).y = nil, 79
	;(nil).format = "qibingqizhi_%.2d.png"
	;(nil).first = 1
	;(nil).last = 4
	_ENV, self.buttonConquer[7], (nil).isAct = nil, nil, true
	_ENV, (nil).png = nil, "qibingqizhi_01.png"
	;(nil).x = 45
	;(nil).pos, (nil).y = nil, 51
	;(nil).format = "qibingqizhi_%.2d.png"
	;(nil).first = 1
	;(nil).last = 4
	_ENV, self.buttonConquer[8], (nil).isAct = nil, nil, true
	_ENV, (nil).png = nil, "shibing2_01.png"
	;(nil).x = 105
	;(nil).pos, (nil).y = nil, 46
	_ENV, self.buttonConquer[9], (nil).isAct = nil, nil, false
	_ENV, (nil).png = nil, "shibing2_01.png"
	;(nil).x = 60
	;(nil).pos, (nil).y = nil, 18
	self.buttonConquer[10], (nil).isAct = nil, false
	local animationTab = self.buttonConquer
	for k, v in pairs(animationTab) do
		local shibing = display.newSprite("#" .. v.png)
		shibing:setPosition(cc.p(v.pos.x, v.pos.y))
		shibing:addTo(self.buttonConquer, k)
		if v.isAct then
			local frames = display.newFrames(v.format, v.first, v.last)
			local animation = display.newAnimation(frames, 0.8 / #frames)
			shibing:playAnimationForever(animation)
		end
	end
end
function effectMainCityView.addBuildTipBoxConquerGate(mainCity)
	local self = mainCity
	local tipBoxName = "ConquerGateTipBox"
	if self.tipBoxConquerGate == nil then
		local textContent = i18n("common_text_2112")
		local cityBuildTipBox = include("cityBuildTipBox")
		local cityBuildTipBoxNode = cityBuildTipBox.new()
		_ENV = nil
		;(nil).boxType = cityBuildConstDef.TipBoxType.TEXT_TYPE_1
		;(nil).content = textContent
		;(nil).handler = handler(self, self.onTipBoxCall)
		;(nil).tag = cityBuildConstDef.OtherBuildDef.ConquerGate
		local (nil).autoDelete, data = true, nil
		cityBuildTipBoxNode:initWithData(data)
		cityBuildTipBoxNode:setName(tipBoxName)
		cityBuildTipBoxNode:setPosition(cc.p(3168, 3239))
		self.containerView:addChild(cityBuildTipBoxNode, mainCityDefine.CITY_TARGET_ZORDER.tips)
		self.tipBoxConquerGate = cityBuildTipBoxNode
	else
		self.tipBoxConquerGate:setVisible(true)
		local textContent = i18n("common_text_2112")
		_ENV = "common_text_2112"
		;("common_text_2112").boxType = cityBuildConstDef.TipBoxType.TEXT_TYPE_1
		;("common_text_2112").content = textContent
		;("common_text_2112").handler = handler(self, self.onTipBoxCall)
		;("common_text_2112").tag = cityBuildConstDef.OtherBuildDef.ConquerGate
		local ("common_text_2112").autoDelete, data = true, "common_text_2112"
		self.tipBoxConquerGate:initWithData(data)
	end
end
function effectMainCityView.addWaveEffect(mainCity)
	do return end
	local self = mainCity
	local uint = 30
	local runEffectWave = function(imageName, beginPos, endPos, delayTime, zOrder, scaleX, scaleY)
		if nil == imageName then
			return
		end
		local spriteWave = display.newSprite(imageName)
		self.batchNodeCityEffect:addChild(spriteWave, zOrder or 1)
		local callFuncWave = cca.callFunc(function()
			local callFuncReset = cca.callFunc(function()
				spriteWave:setScaleX(scaleX)
				spriteWave:setScaleY(scaleY)
				spriteWave:setPosition(beginPos)
				spriteWave:setOpacity(0)
			end)
			local fadeIn = cca.fadeIn(30 / uint)
			local moveTo = cca.moveTo(80 / uint, endPos.x, endPos.y)
			local delay = cca.delay(60 / uint)
			local fadeOut = cca.fadeOut(30 / uint)
			scaleX = nil
			;(nil)[1] = delay
			;(nil)[2] = fadeOut
			local seq1 = cca.seq(nil)
			local scalTo = cca.scaleTo(80 / uint, 1.0, 1.0)
			beginPos = 1.0
			;(1.0)[1] = fadeIn
			;(1.0)[2] = scalTo
			;(1.0)[3] = moveTo
			;(1.0)[4] = seq1
			local spawn = cca.spawn(1.0)
			local delaySep = cca.delay(6)
			scaleY = scalTo
			scalTo[1] = callFuncReset
			scalTo[2] = spawn
			scalTo[3] = delaySep
			local seq2 = cca.seq(scalTo)
			spriteWave:runAction(cca.repeatForever(seq2))
		end)
		local delayWave = cca.delay(delayTime)
		uint = nil
		;(nil)[1] = delayWave
		;(nil)[2] = callFuncWave
		spriteWave:runAction(cca.seq(nil))
	end
	for i = 1, 3 do
		runEffectWave("#et_hailang_01.png", cc.p(4333.42, 1429.92), cc.p(4347.5, 1423.14), i * (40 / uint), i, 0.5, 0.5)
	end
	for i = 1, 3 do
		runEffectWave("#et_hailang_02.png", cc.p(4320.88, 1273.45), cc.p(4334.44, 1284.4), i * (40 / uint), i, 0.5, 0.5)
	end
end
function effectMainCityView.addSoldierGuard(mainCity)
	local self = mainCity
	local basePos = cc.p(5187, 1850)
	local guardSpeed = 16
	local baseTarget = cc.p(4887, 2010)
	local distance = cc.pGetDistance(basePos, baseTarget)
	local runGuardAnimation = function(sprite)
		local dt = distance / guardSpeed
		local callFunc1 = cca.callFunc(function()
			local frames = display.newFrames("xunluo_wn_0%d.png", 1, 8)
			local animation = display.newAnimation(frames, 0.125)
			local animate = cc.Animate:create(animation)
			sprite:setFlippedX(false)
			local repeatForever = cca.repeatForever(animate)
			repeatForever:setTag(10)
			sprite:runAction(repeatForever)
			sprite:stopActionByTag(20)
		end)
		local moveBy1 = cca.moveBy(dt, baseTarget.x - basePos.x, baseTarget.y - basePos.y)
		local callFunc2 = cca.callFunc(function()
			local frames = display.newFrames("xunluo_ws_0%d.png", 1, 8)
			local animation = display.newAnimation(frames, 0.125)
			local animate = cc.Animate:create(animation)
			sprite:setFlippedX(true)
			local repeatForever = cca.repeatForever(animate)
			repeatForever:setTag(20)
			sprite:runAction(repeatForever)
			sprite:stopAllActionsByTag(10)
		end)
		local moveBy2 = moveBy1:reverse()
		basePos = nil
		;(nil)[1] = callFunc1
		;(nil)[2] = moveBy1
		;(nil)[3] = callFunc2
		;(nil)[4] = moveBy2
		sprite:runAction(cca.repeatForever(cca.seq(nil)))
	end
	for i = 1, 4 do
		local sprite = display.newSprite("#" .. "xunluo_wn_01.png")
		self.batchNodeSoldierGuards:addChild(sprite)
		sprite:setName("soldier_guard_" .. i)
		self:addToBufferNodeArrayByName("soldier_guard_" .. i, sprite)
		sprite:setPosition(cc.pAdd(basePos, cc.p(i * 20, -i * 10)))
		sprite:setLocalZOrder(i)
		runGuardAnimation(sprite)
	end
	_ENV = 4
	;(4).msg = "MESSAGE_MAINCITYVIEW_UPDATE_GUARD_SOLDIER_BOX"
	SoraDSendMessage(4)
	local commandHallCtrl = SoraDGetCtrl("commandHallCtrl")
	if commandHallCtrl:getIsShowFighting() then
		local commandHallUtil = include("commandHallUtil")
		commandHallUtil.jumpToShowFighting()
	end
	self:msgShowCommandHallBox()
end
function effectMainCityView.showEagle(mainCity)
	local self = mainCity
	if self.eagle == nil and self.eagleShadow == nil then
		self.eagleEffect = display.newNode()
		local spriteName = string.format("juying_%02d.png", 1)
		spriteName = "#" .. spriteName
		self.eagle = display.newSprite(spriteName)
		self.eagle:setPosition(cc.p(0, 0))
		self.eagleEffect:addChild(self.eagle, 1)
		local spriteName2 = string.format("juying2_%02d.png", 1)
		spriteName2 = "#" .. spriteName2
		self.eagleShadow = display.newSprite(spriteName2)
		local frames2 = display.newFrames("juying2_%02d.png", 1, 8)
		local animation2 = display.newAnimation(frames2, 0.125)
		self.eagleShadow:playAnimationForever(animation2)
		self.eagleShadow:setPosition(cc.p(-70, -190))
		self.eagleEffect:addChild(self.eagleShadow, 1)
		self.eagleShadow:setScale(0.8)
		self.eagleShadow:setOpacity(102.0)
		self.containerView:addChild(self.eagleEffect, mainCityDefine.CITY_TARGET_ZORDER.juying)
		local spreadWinds, glide
		function glide()
			self.eagle:stopAllActions()
			self.eagleShadow:stopAllActions()
			local frameName = string.format("juying_%02d.png", 1)
			local frameName2 = string.format("juying2_%02d.png", 1)
			local spriteFrame = display.newSpriteFrame(frameName)
			self.eagle:setSpriteFrame(spriteFrame)
			local spriteFrame2 = display.newSpriteFrame(frameName2)
			self.eagleShadow:setSpriteFrame(spriteFrame2)
			local dt = math.random(2, 3)
			local dt2 = math.random(0, 1)
			dt = dt + dt2
			local delay = cca.delay(dt)
			local callFunc = cca.callFunc(function()
				spreadWinds()
			end)
			spreadWinds = nil
			;(nil)[1] = delay
			;(nil)[2] = callFunc
			self.eagle:runAction(cca.seq(nil))
		end
		function spreadWinds()
			self.eagle:stopAllActions()
			local frames = display.newFrames("juying_%02d.png", 1, 8)
			local animation = display.newAnimation(frames, 0.125)
			self.eagle:playAnimationForever(animation)
			self.eagleShadow:stopAllActions()
			local frame2 = display.newFrames("juying2_%02d.png", 1, 8)
			local animation2 = display.newAnimation(frame2, 0.125)
			self.eagleShadow:playAnimationForever(animation2)
			local dt = math.random(2, 3)
			local dt2 = math.random(0, 1)
			dt = dt + dt2
			local delay = cca.delay(dt)
			local callFunc = cca.callFunc(function()
				glide()
			end)
			glide = nil
			;(nil)[1] = delay
			;(nil)[2] = callFunc
			self.eagle:runAction(cca.seq(nil))
		end
		spreadWinds()
		local beginPos = cc.p(190, 4300)
		local endPos = cc.p(6753, -50)
		local speed = 100
		local dis = cc.pGetDistance(beginPos, endPos)
		local dt = dis / speed
		local callFuncResetPos = cca.callFunc(function()
			self.eagleEffect:setPosition(beginPos)
		end)
		local moveTo = cca.moveTo(dt, endPos.x, endPos.y)
		local delay = cca.delay(3)
		_UPVALUE3_ = endPos.y
		endPos.y[1] = callFuncResetPos
		endPos.y[2] = moveTo
		endPos.y[3] = delay
		local seq = cca.seq(endPos.y)
		local repeatAct = cca.repeatForever(seq)
		self.eagleEffect:runAction(repeatAct)
	end
end
function effectMainCityView.addEffectActivityCenter(mainCity)
	local self = mainCity
end
function effectMainCityView.removeEffectActivityCenter(mainCity)
	local self = mainCity
	if self.et_activity_center then
		self.et_activity_center:removeFromParent()
	end
end
function effectMainCityView.addBuildAnimBoostBottom(mainCity, buildIndex)
	local self = mainCity
	local buildBtnName = "build_" .. buildIndex
	local buildBtn = self:getBufferNodeByName(buildBtnName)
	if nil == buildBtn then
		return
	end
	local x, y = buildBtn:getPosition()
	local etBoostBottomName = "et_boost_bottom_" .. buildIndex
	local etBoostNode = self:getBufferNodeByName(etBoostBottomName)
	if etBoostNode ~= nil then
		return
	end
	_ENV, _ENV = etBoostBottomName, self
	_ENV, etBoostBottomName.plist = nil, "et_fanbei_display_04.plist"
	;(nil).x = 3.5
	_ENV, self[1], etBoostBottomName.scale, (nil).y = etBoostBottomName, etBoostBottomName, nil, 1.54
	_ENV, etBoostBottomName.plist = nil, "et_fanbei_display_01.plist"
	;(nil).x = 3.12
	_ENV, etBoostBottomName.scale, (nil).y = nil, nil, 2.4
	;(nil).x = 3
	_ENV, self[2], etBoostBottomName.pos, (nil).y = etBoostBottomName, etBoostBottomName, nil, 21
	etBoostBottomName.plist = "et_fanbei_display_02.plist"
	_ENV, etBoostBottomName.rotate = nil, 20.3
	;(nil).x = 1
	_ENV, self[3], etBoostBottomName.pos, (nil).y = etBoostBottomName, etBoostBottomName, nil, 24
	etBoostBottomName.plist = "et_fanbei_display_03.plist"
	_ENV, etBoostBottomName.scale = nil, 1.7
	;(nil).x = 3
	self[4], etBoostBottomName.pos, (nil).y = etBoostBottomName, nil, 16
	local param = self
	local et_node = SoraDCreateEffectNode(param)
	et_node:setName(etBoostBottomName)
	et_node:setPosition(cc.p(x, y - 12))
	et_node:setLocalZOrder(buildBtn:getLocalZOrder() + 1)
	self.containerView:addChild(et_node)
	self:addToBufferNodeArrayByName(etBoostBottomName, et_node)
end
function effectMainCityView.addHarvestEffect(mainCity)
	local self = mainCity
	local activityShowCtrl = gModuleMgr.getObject("gametop").playertop_:getModule("activityShowCtrl")
	local isInFestival = activityShowCtrl:isActivityOpen(gActivityTimeActivityID.BUMPER_CITY_RES)
	if not isInFestival then
		local resPlaces = self:getAllResBuildBtn()
		for i, v in ipairs(resPlaces) do
			local buildIndex = v[4]
			local etBoostHarvestName = "et_boost_harvest_" .. buildIndex
			if self.containerView:getChildByName(etBoostHarvestName) then
				self.containerView:removeChildByName(etBoostHarvestName, true)
			end
		end
	else
		local resPlaces = self:getAllResBuildBtn()
		for i, v in ipairs(resPlaces) do
			local rType = v[1]
			local place = v[2]
			local entity = v[3]
			local buildIndex = v[4]
			if entity then
				if entity.getIsLockVisible and entity:getIsLockVisible() or entity:getIsLocked() then
				else
					local etBoostHarvestName = "et_boost_harvest_" .. buildIndex
					if not self.containerView:getChildByName(etBoostHarvestName) then
						local x, y = place:getPosition()
						_ENV, _ENV = nil, etBoostHarvestName
						;(nil).plist = "et_fs_01.plist"
						_ENV, etBoostHarvestName[1], (nil).scale = nil, nil, 1.71
						;(nil).plist = "et_fs_02.plist"
						etBoostHarvestName[2], (nil).scale = nil, 1.7
						local param = etBoostHarvestName
						local et_node = SoraDCreateEffectNode(param)
						et_node:setName(etBoostHarvestName)
						et_node:setPosition(cc.p(x, y))
						et_node:setLocalZOrder(place:getLocalZOrder() + 1)
						self.containerView:addChild(et_node)
					end
				end
			else
				local etBoostHarvestName = "et_boost_harvest_" .. buildIndex
				if self.containerView:getChildByName(etBoostHarvestName) then
					self.containerView:removeChildByName(etBoostHarvestName, true)
				end
			end
		end
	end
end
function effectMainCityView.msgRemoveHarvestEffect(mainCity, target, data)
	local self = mainCity
	local buildIndex = data.buildIndex
	if not buildIndex then
		return
	end
	local etBoostHarvestName = "et_boost_harvest_" .. buildIndex
	if self.containerView:getChildByName(etBoostHarvestName) then
		self.containerView:removeChildByName(etBoostHarvestName, true)
	end
end
function effectMainCityView.addBuildTopTipHuochuang(mainCity)
	local self = mainCity
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.CARGO_SHIP)
	if unlockLv > SoraDGetCastleLv() then
		return
	end
	local isCanReceive = loginRewardCtrl:getCanReceive()
	local isSigned = true
	if isCanReceive then
		isSigned = false
	end
	local isDailyAward = everydayTaskCtrl:isHaveNoReceiveReward()
	local hasGift, hasBuy, hasGot = cityBuildFunction:getMonthlyCard()
	funUnlockRead = nil
	;(nil).byUID = true
	local clickTime = SoraDConfigGet("Game:MainCityView:monthlyCardTipTime~integer", nil)
	print("hasGift,hasBuy,hasGot=", hasGift, hasBuy, hasGot)
	local premiumStoreCtrl = gametop.playertop_:getModule("premiumStoreCtrl")
	local hasPremium = premiumStoreCtrl:getShowEnter()
	local exaltedPrivilegeCtrl = SoraDGetCtrl("exaltedPrivilegeCtrl")
	funUnlockRead = nil
	;(nil).byUID = true
	local clickPremiumVipMall = SoraDConfigGet("Game:MainCityView:clickPremiumVipMall~integer", nil)
	local iconName = "btn_dailyreward.png"
	if exaltedPrivilegeCtrl:isNewFlagTotalJudge() then
		iconName = "btn_zxvip_01.png"
		BUILD_HUOCHUAN_TYPE_DEFAULT = BUILD_HUOCHUAN_TYPE.EXCLUSIVE_VIP
	end
	if not isSigned then
		iconName = "btn_dailyreward.png"
		BUILD_HUOCHUAN_TYPE_DEFAULT = BUILD_HUOCHUAN_TYPE.SIGN
	elseif hasBuy and not hasGot then
		iconName = "icon_monthly_boat.png"
		BUILD_HUOCHUAN_TYPE_DEFAULT = BUILD_HUOCHUAN_TYPE.MONTHLY
	elseif isDailyAward then
		iconName = "icon_Daily_reward_sign.png"
		BUILD_HUOCHUAN_TYPE_DEFAULT = BUILD_HUOCHUAN_TYPE.REWARD
	elseif not isDailyAward and hasGift and not hasBuy and (clickTime == 0 or not serviceFunctions.isSameDay(clickTime)) then
		iconName = "icon_monthly_boat.png"
		BUILD_HUOCHUAN_TYPE_DEFAULT = BUILD_HUOCHUAN_TYPE.MONTHLY
	elseif hasPremium and (clickPremiumVipMall == 0 or not serviceFunctions.isSameDay(clickPremiumVipMall)) then
		iconName = "icon_wharf_Extreme_shop.png"
		BUILD_HUOCHUAN_TYPE_DEFAULT = BUILD_HUOCHUAN_TYPE.PREMIUM_VIP_MALL
	else
		effectMainCityView.removeBuildTopTipHuochuang(self)
		BUILD_HUOCHUAN_TYPE_DEFAULT = BUILD_HUOCHUAN_TYPE.NONE
		return
	end
	local nodeName = "build_topTip_" .. cityBuildConstDef.buildIndexDef.index_HuoChuang
	local buildTipNode = self:getBufferNodeByName(nodeName)
	if buildTipNode == nil then
		local buildTopTip = include("cityBuildTop")
		local buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_HUOCHUANG
		local buildTopTipPosition = cc.p(self.btnHuoChuang:getPositionX(), self.btnHuoChuang:getPositionY() + self.buttonMaTou:getContentSize().height / 4)
		buildTipNode = cityBuildCreator:createBuildTop(buildTopTipType, self.tblBatchNodesTopTip, buildTopTipPosition)
		buildTipNode:setName(nodeName)
		buildTipNode:setPosition(buildTopTipPosition)
		buildTipNode:setTag(cityBuildConstDef.buildIndexDef.index_HuoChuang)
		buildTipNode:addTo(self.containerView, 1300)
		self:addToBufferNodeArrayByName(nodeName, buildTipNode)
		local btnTip = SoraDGetChildByName(buildTipNode, "btn")
		btnTip:setTouchEnabled(true)
		btnTip:setTag(cityBuildConstDef.buildIndexDef.index_HuoChuang)
		btnTip.topType = buildTopTipType
		btnTip:addTouchEventListener(function(ref, type)
			self:onOtherTopTipCallBack(btnTip, ref, type)
		end)
	end
	buildTipNode:setIcon(iconName, cc.size(90, 90))
end
function effectMainCityView.removeBuildTopTipHuochuang(mainCity)
	local self = mainCity
	local buildTopTipName = "build_topTip_" .. cityBuildConstDef.buildIndexDef.index_HuoChuang
	local buildTopTipNode = self:getBufferNodeByName(buildTopTipName)
	if nil == buildTopTipNode then
		return
	end
	self:delBufferNodeByName(buildTopTipName)
	buildTopTipNode:removeNodeRelyOn()
	buildTopTipNode:recycleNode()
	buildTopTipNode:removeFromParent()
end
function effectMainCityView.addBuildTopTipGangkou(mainCity)
	local self = mainCity
	local nodeName = "build_topTip_" .. cityBuildConstDef.OtherBuildDef.Gangkou
	local buildTipNode = self:getBufferNodeByName(nodeName)
	if buildTipNode then
		return
	end
	local buildTopTip = include("cityBuildTop")
	local buildTopTipType = cityBuildConstDef.topType.TOP_TYPE_COLLECT_GANGKOU
	local buildTopTipPosition = cc.p(self.buttonMaTou:getPositionX(), self.buttonMaTou:getPositionY() + self.buttonMaTou:getContentSize().height / 4 + 30)
	local buildTipNode = cityBuildCreator:createBuildTop(buildTopTipType, self.tblBatchNodesTopTip, buildTopTipPosition)
	buildTipNode:setName("build_topTip_" .. cityBuildConstDef.OtherBuildDef.Gangkou)
	buildTipNode:setPosition(buildTopTipPosition)
	buildTipNode:setTag(cityBuildConstDef.OtherBuildDef.Gangkou)
	buildTipNode:addTo(self.containerView, 1300)
	self:addToBufferNodeArrayByName(nodeName, buildTipNode)
	local btnTip = SoraDGetChildByName(buildTipNode, "btn")
	btnTip:setTouchEnabled(true)
	btnTip:setTag(cityBuildConstDef.OtherBuildDef.Gangkou)
	btnTip.topType = buildTopTipType
	btnTip:addTouchEventListener(function(ref, type)
		self:onOtherTopTipCallBack(btnTip, ref, type)
	end)
end
function effectMainCityView.removeBuildTopTipGangkou(mainCity)
	local self = mainCity
	local buildTopTipName = "build_topTip_" .. cityBuildConstDef.OtherBuildDef.Gangkou
	local buildTopTipNode = self:getBufferNodeByName(buildTopTipName)
	if nil == buildTopTipNode then
		return
	end
	self:delBufferNodeByName(buildTopTipName)
	buildTopTipNode:removeNodeRelyOn()
	buildTopTipNode:recycleNode()
	buildTopTipNode:removeFromParent()
end
function effectMainCityView.addHuoChuanEffect(mainCity)
	local self = mainCity
	if self.et_chuang then
		self.et_chuang:setVisible(true)
	else
	end
	if self.et_particle_chuang_1 then
	else
	end
	if self.et_particle_chuang_2 then
	else
	end
end
function effectMainCityView.removeHuoChuanEffect(mainCity)
	local self = mainCity
	if self.et_chuang then
		self.et_chuang:removeFromParent()
		self.et_chuang = nil
	end
	if self.et_particle_chuang_1 then
		self.et_particle_chuang_1:removeFromParent()
		self.et_particle_chuang_1 = nil
	end
	if self.et_particle_chuang_2 then
		self.et_particle_chuang_2:removeFromParent()
		self.et_particle_chuang_2 = nil
	end
end
function effectMainCityView.addMatouEffect(mainCity)
	local self = mainCity
	if not self.et_node_matou then
		_ENV, _ENV = nil, self.et_node_matou
		_ENV, self.et_node_matou[1], (nil).plist = nil, nil, "et_lqlbjz_01.plist"
		;(nil).plist = "et_lqlbjz_02.plist"
		self.et_node_matou[2], (nil).scale = nil, 1.165
		local param = self.et_node_matou
		self.et_node_matou = SoraDCreateEffectNode(param)
		local factionCtrl = SoraDGetCtrl("factionCtrl")
		local factionId = factionCtrl:getFactionId()
		self.et_node_matou:setPosition(cc.p(5920, 3257))
		self.et_node_matou:setName("et_node_matou")
		self.et_node_matou:addTo(self.containerView, 1001)
	end
end
function effectMainCityView.removeMatouEffect(mainCity)
	local self = mainCity
	if self.et_node_matou then
		self.et_node_matou:removeFromParent()
		self.et_node_matou = nil
	end
end
function effectMainCityView.showEffectUpgrade2(mainCity, buildPos, posEtUpgradeOffset, zOrder)
	local self = mainCity
end
function effectMainCityView.addBuildTipBoxWishingWell(mainCity, buildIndex)
	local self = mainCity
	local buildBtn = self:getBuildBtnByIndex(buildIndex)
	if buildBtn == nil then
		return
	end
	local buildEntity = self:getBuildByIndex(buildIndex)
	if buildEntity == nil then
		return
	end
	local endlessTreasureCtrl = SoraDGetCtrl("endlessTreasureCtrl")
	local isHaveDig = endlessTreasureCtrl:isHaveDigTreasure()
	local isHaveReward = endlessTreasureCtrl:isHaveRewardTreasure()
	if not (not (buildEntity.getTimes and buildEntity:getTimes() <= 0) or buildEntity:isShowDig()) or isHaveReward then
		if self.tipBoxWishingWell then
			self.tipBoxWishingWell:removeFromParent()
			self.tipBoxWishingWell = nil
		end
		return
	end
	local x, y = buildBtn:getPosition()
	local tipBoxName = "wishingWellTipBox"
	if self.tipBoxWishingWell == nil then
		local times = buildEntity.getTimes and buildEntity:getTimes() or 0
		local textContent = 0 < times and i18n("common_text_049") or i18n("allitreas_btn_05")
		local cityBuildTipBox = include("cityBuildTipBox")
		local cityBuildTipBoxNode = cityBuildTipBox.new()
		_ENV = nil
		;(nil).boxType = cityBuildConstDef.TipBoxType.TEXT_TYPE_1
		;(nil).content = textContent
		;(nil).handler = handler(self, self.onTipBoxCall)
		;(nil).tag = BUILDID.WISHING_WELL
		;(nil).needCenter = true
		local (nil).autoDelete, data = true, nil
		cityBuildTipBoxNode:initWithData(data)
		cityBuildTipBoxNode:setName(tipBoxName)
		cityBuildTipBoxNode:setPosition(cc.p(x - 20, y + 130))
		self.containerView:addChild(cityBuildTipBoxNode, 1050)
		self.tipBoxWishingWell = cityBuildTipBoxNode
	else
		if tolua.isnull(buildEntity) or buildEntity.getTimes == nil then
			return
		end
		self.tipBoxWishingWell:setVisible(true)
		local _ENV, textContent = "allitreas_btn_05", buildEntity:getTimes() > 0 and i18n("common_text_049") or i18n("allitreas_btn_05")
		;("allitreas_btn_05").boxType = cityBuildConstDef.TipBoxType.TEXT_TYPE_1
		;("allitreas_btn_05").content = textContent
		;("allitreas_btn_05").handler = handler(self, self.onTipBoxCall)
		;("allitreas_btn_05").tag = BUILDID.WISHING_WELL
		;("allitreas_btn_05").needCenter = true
		local ("allitreas_btn_05").autoDelete, data = true, "allitreas_btn_05"
		self.tipBoxWishingWell:initWithData(data)
		self.tipBoxWishingWell:setPosition(cc.p(x - 20, y + 130))
	end
end
function effectMainCityView.addBuildTipBoxLeisureCenter(mainCity)
	local buildIndex = cityBuildConstDef.fixedBuildDef.LeisureCenter
	local buildBtn = mainCity:getBuildBtnByIndex(buildIndex)
	if buildBtn == nil then
		return
	end
	local buildEntity = mainCity:getBuildByIndex(buildIndex)
	if buildEntity == nil then
		return
	end
	print("pyramidCtrl free", SoraDGetCtrl("pyramidCtrl"):getFreeTime())
	local freeTime = SoraDGetCtrl("pyramidCtrl"):getFreeTime() or 0
	if freeTime <= 0 then
		return
	end
	if SoraDGetCtrl("activityShowCtrl"):isActivityOpen(gActivityTimeActivityID.PYRAMIDACTIVITY) then
		return
	end
	local cityBuildMgr = include("cityBuildMgr")
	local buildLeisureCenter = cityBuildMgr:getBuildByIndex(cityBuildConstDef.fixedBuildDef.LeisureCenter)
	if buildLeisureCenter and not buildLeisureCenter:canShowTopTipBox() then
		return false
	end
	cityBuildConstDef = false
	;(false).boxType = cityBuildConstDef.TipBoxType.TEXT_TYPE_1
	;(false).content = i18n("common_text_049")
	;(false).handler = handler(mainCity, mainCity.onTipBoxCall)
	;(false).tag = cityBuildConstDef.fixedBuildDef.LeisureCenter
	;(false).needCenter = true
	local (false).autoDelete, data = true, false
	local x, y = buildBtn:getPosition()
	cityBuildConstDef = mainCity.onTipBoxCall
	mainCity.onTipBoxCall.data = data
	mainCity.onTipBoxCall.order = 2050
	local mainCity.onTipBoxCall.pos, params = cc.p(x, y + 100), mainCity.onTipBoxCall
	effectMainCityView.addBuildTipBoxCommon(mainCity, "LeisureTipsBox", params)
end
function effectMainCityView.addBuildTipBoxCommon(mainCity, tipsName, params)
	local self = mainCity
	local tips = self.containerView:getChildByName(tipsName)
	if not tips then
		local cityBuildTipBox = include("cityBuildTipBox")
		local cityBuildTipBoxNode = cityBuildTipBox.new()
		cityBuildTipBoxNode:setName(tipsName)
		self.containerView:addChild(cityBuildTipBoxNode, params.order)
		tips = cityBuildTipBoxNode
	end
	tips:setVisible(true)
	tips:initWithData(params.data)
	tips:setPosition(params.pos)
end
function effectMainCityView.addBuildTipBoxActivityCenter(mainCity)
	local self = mainCity
	local tipBoxName = "activityCenterTipBox"
	if self.tipBoxActivityCenter == nil then
		local textContent = self:getOneActivityCenterDes()
		local cityBuildTipBox = include("cityBuildTipBox")
		local cityBuildTipBoxNode = cityBuildTipBox.new()
		_ENV = nil
		;(nil).boxType = cityBuildConstDef.TipBoxType.TEXT_TYPE_1
		;(nil).content = textContent
		;(nil).handler = handler(self, self.onTipBoxCall)
		;(nil).tag = cityBuildConstDef.OtherBuildDef.ActivityCenter
		local (nil).autoDelete, data = true, nil
		cityBuildTipBoxNode:initWithData(data)
		cityBuildTipBoxNode:setName(tipBoxName)
		cityBuildTipBoxNode:setPosition(cc.p(440.0, 1572.0))
		self.containerView:addChild(cityBuildTipBoxNode, 1061)
		self.tipBoxActivityCenter = cityBuildTipBoxNode
	else
		self.tipBoxActivityCenter:setVisible(true)
		local textContent = self:getOneActivityCenterDes()
		_ENV = self
		self.boxType = cityBuildConstDef.TipBoxType.TEXT_TYPE_1
		self.content = textContent
		self.handler = handler(self, self.onTipBoxCall)
		self.tag = cityBuildConstDef.OtherBuildDef.ActivityCenter
		local self.autoDelete, data = true, self
		self.tipBoxActivityCenter:initWithData(data)
	end
end
function effectMainCityView.addBuildTipBoxCommunityCenter(mainCity)
	local self = mainCity
	local buttonCommunityCenter = self:getBufferNodeByName("build_30005")
	if not buttonCommunityCenter then
		return
	end
	local btnCommunityPos = cc.p(buttonCommunityCenter:getPosition())
	local castleLV = 1
	local castleBcell = cityCtrl:getBuildCell(BUILDID.CASTLE, 0)
	if castleBcell then
		castleLV = tonumber(castleBcell.info.lv)
	end
	if self.tipBoxCommunity == nil then
		local cityBuildTipBoxNode = include("cityBuildTipBox").new()
		cityBuildTipBoxNode:setName("communityCenterTipBox")
		self.containerView:addChild(cityBuildTipBoxNode)
		self.tipBoxCommunity = cityBuildTipBoxNode
		self.tipBoxCommunity:setLocalZOrder(mainCityDefine.CITY_TARGET_ZORDER.tips)
	end
	self.tipBoxCommunity:setVisible(true)
	local communityPopCtrl = gametop.playertop_:getModule("communityPopCtrl")
	local pushPopMsg = communityPopCtrl:getPopData(GameLanguageCopy)
	table.insert(pushPopMsg, i18n("common_text_2287"))
	table.insert(pushPopMsg, i18n("common_text_2288"))
	math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
	local textContent = pushPopMsg[math.random(1, #pushPopMsg)]
	_ENV = 1
	;(1).boxType = cityBuildConstDef.TipBoxType.TEXT_TYPE_1
	;(1).content = textContent
	;(1).handler = handler(self, self.onTipBoxCall)
	;(1).tag = cityBuildConstDef.OtherBuildDef.CommunityCenter
	;(1).needCenter = true
	;(1).autoDelete = true
	local (1).maxWidth, data = 170, 1
	self.tipBoxCommunity:initWithData(data)
	local deltaOffsetY = castleLV >= CASTLE_LV25_LIMITED and 85 or 115
	local deltaOffsetX = castleLV >= CASTLE_LV25_LIMITED and -4 or -10
	if SoraDGetFactionType() == FACTION_TYPE.FACTION_BYZANTINE then
		deltaOffsetY = castleLV >= CASTLE_LV25_LIMITED and 73 or 125
		deltaOffsetX = castleLV >= CASTLE_LV25_LIMITED and -7 or 40
	end
	self.tipBoxCommunity:setPosition(cc.p(btnCommunityPos.x + deltaOffsetX, btnCommunityPos.y + deltaOffsetY))
end
function effectMainCityView.addEffectWall(mainCity)
	local self = mainCity
	local etWallEffectName = "BG_wall_broken"
	local spriteWallEffect = self:getBufferNodeByName(etWallEffectName)
	if spriteWallEffect ~= nil then
		spriteWallEffect:setVisible(true)
	else
		local brokenImgName = "#" .. "BG_wall_broken.png"
		local spriteWallEffect = display.newSprite(brokenImgName)
		spriteWallEffect:setName(etWallEffectName)
		self.containerView:addChild(spriteWallEffect, mainCityDefine.CITY_TARGET_ZORDER.drill)
		self:addToBufferNodeArrayByName(etWallEffectName, spriteWallEffect)
		spriteWallEffect:setPosition(cc.p(4617.0, 1969.0))
	end
	local tipBoxName = "wallTipBox"
	local tipBoxNode = self:getBufferNodeByName(tipBoxName)
	local isInRecoveryCD = wallsCtrl:isInRecoveryCD()
	if isInRecoveryCD then
		if tipBoxNode ~= nil and tipBoxNode ~= nil then
			self:delBufferNodeByName(tipBoxName)
			tipBoxNode:removeFromParent()
		end
	elseif tipBoxNode ~= nil then
	else
		local cityBuildTipBox = include("cityBuildTipBox")
		local cityBuildTipBoxNode = cityBuildTipBox.new()
		_ENV = tipBoxName
		tipBoxName.boxType = cityBuildConstDef.TipBoxType.IMG
		tipBoxName.content = "icon_building_def.png"
		tipBoxName.needFade = true
		tipBoxName.handler = handler(self, self.onTipBoxCall)
		tipBoxName.tag = cityBuildConstDef.OtherBuildDef.Wall
		local tipBoxName.imgSize, data = cc.size(90, 80), tipBoxName
		cityBuildTipBoxNode:initWithData(data)
		cityBuildTipBoxNode:setName(tipBoxName)
		cityBuildTipBoxNode:setPosition(cc.p(4583.0, 2030.0))
		self.containerView:addChild(cityBuildTipBoxNode, mainCityDefine.CITY_TARGET_ZORDER.drill)
		self:addToBufferNodeArrayByName(tipBoxName, cityBuildTipBoxNode)
	end
end
function effectMainCityView.removeEffectWall(mainCity)
	local self = mainCity
	local etWallEffectName = "BG_wall_broken"
	local spriteWallEffect = self:getBufferNodeByName(etWallEffectName)
	if spriteWallEffect ~= nil then
		self:delBufferNodeByName(etWallEffectName)
		spriteWallEffect:removeFromParent()
	end
	local tipBoxName = "wallTipBox"
	local tipBoxNode = self:getBufferNodeByName(tipBoxName)
	if tipBoxNode ~= nil then
		self:delBufferNodeByName(tipBoxName)
		tipBoxNode:removeFromParent()
	end
end
function effectMainCityView.updateWallViewModel(mainCity)
	local self = mainCity
	local buildIndex = 1053
	local buildCell = cityCtrl:getBuildCellByIndex(buildIndex)
	if buildCell == nil then
		return
	end
	self.Node_cq = self:getBufferNodeByName("Node_cq")
	local buildLv = tonumber(buildCell.info.lv)
	local tblViewModelCfg = cityBuildViewDef.tblViewModelWall
	if SoraDGetFactionType() == FACTION_TYPE.FACTION_BYZANTINE then
		tblViewModelCfg = cityBuildViewDef.tblViewBZTModelWall
	end
	local viewModel = cityBuildViewDef.getViewModelByLv(buildLv, tblViewModelCfg)
	self.viewModelWall = viewModel
	for i = 1, 4 do
		local cqName = "Sprite_Cq_" .. i
		local spriteCqItem = self:getBufferNodeByName(cqName)
		if spriteCqItem then
			local cqImgName
			if SoraDGetFactionType() == FACTION_TYPE.FACTION_NORMAL then
				cqImgName = string.format("chengqiang_lv%d.png", self.viewModelWall)
			end
			spriteCqItem:setSpriteFrame(cqImgName)
		end
		local jtName = "Sprite_Jt_" .. i
		local spriteJtItem = self:getBufferNodeByName(jtName)
		if spriteJtItem then
			local jtImgName = string.format("jianta_lv%d_ex.png", self.viewModelWall)
			if i == 4 then
				jtImgName = string.format("jianta_lv%d_base.png", self.viewModelWall)
			end
			spriteJtItem:setSpriteFrame(jtImgName)
		end
	end
end
function effectMainCityView.addTouchParticle(mainCity, touchPos)
	local self = mainCity
	if self.touch_et_node then
		SoraDResetEffectNode(self.touch_et_node)
		self.touch_et_node:setPosition(touchPos)
		return
	end
	_ENV, _ENV = self.touch_et_node, self.touch_et_node.setPosition
	_ENV, self.touch_et_node.setPosition[1], self.touch_et_node.plist = self.touch_et_node, self.touch_et_node, "et_dianji_button_01.plist"
	self.touch_et_node.setPosition[2], self.touch_et_node.plist = self.touch_et_node, "et_dianji_button_02.plist"
	local param = self.touch_et_node.setPosition
	if not self.touch_et_node then
		self.touch_et_node = SoraDCreateEffectNode(param)
		self.touch_et_node:setPosition(touchPos)
		self.touch_et_node:addTo(self.containerView, 1002)
	end
end
function effectMainCityView.cloudRunEffect(mainCity)
	return
end
function effectMainCityView.removeCloudEffect(mainCity)
	return
end
function effectMainCityView.removeWeatherEffect(mainCity, wType, isAllRemove)
	local self = mainCity
	if isAllRemove then
		for k, v in pairs(cityBuildConstDef.weatherType) do
			if self:getChildByName("particle_node" .. v) then
				self:removeChildByName("particle_node" .. v, true)
			end
		end
	elseif wType and self:getChildByName("particle_node" .. wType) then
		self:removeChildByName("particle_node" .. wType, true)
	end
end
function effectMainCityView.freePlaceEffect(mainCity, target, data)
	local self = mainCity
end
function effectMainCityView.deleteFreePlaceEffect(mainCity, target, data)
	local self = mainCity
end
function effectMainCityView.showSkillEffectBySkillID(mainCity, skillID, trapType)
	local self = mainCity
	_ENV = nil
	_ENV, _ENV = nil, nil
	_ENV, (nil).plist = nil, "et_jn_xj_01.plist"
	;(nil).x = 1.3463
	_ENV, (nil)[1], (nil).scale, (nil).y = nil, nil, nil, 0.9134
	_ENV, (nil).plist = nil, "et_jn_xj_02.plist"
	;(nil).x = 1.05
	;(nil)[lordSkillIDDefine.trapAction], (nil)[2], (nil).scale, (nil).y = nil, nil, nil, 1.05
	_ENV, _ENV = nil, nil
	_ENV, (nil)[1], (nil).plist = nil, nil, "et_fs_01.plist"
	_ENV, (nil).plist = nil, "et_fs_02.plist"
	;(nil).x = -2
	_ENV, (nil)[lordSkillIDDefine.harvest], (nil)[2], (nil).pos, (nil).y = lordSkillIDDefine.harvest, nil, nil, nil, -1.4
	local skillTable
	_ENV = nil
	;(nil).pattern = "et_fs_dc_%.2d.png"
	;(nil).beginp = 1
	;(nil).endp = 8
	lordSkillIDDefine.harvest[BUILDID.FARM], (nil).sprite = nil, "#et_fs_dc_01.png"
	_ENV = nil
	;(nil).pattern = "et_fs_mc_%.2d.png"
	;(nil).beginp = 1
	;(nil).endp = 8
	lordSkillIDDefine.harvest[BUILDID.SAWMILL], (nil).sprite = nil, "#et_fs_mc_01.png"
	_ENV = nil
	;(nil).pattern = "et_fs_tk_%.2d.png"
	;(nil).beginp = 1
	;(nil).endp = 8
	lordSkillIDDefine.harvest[BUILDID.IRON_MINE], (nil).sprite = nil, "#et_fs_tk_01.png"
	_ENV = nil
	;(nil).pattern = "et_fs_my_%.2d.png"
	;(nil).beginp = 1
	;(nil).endp = 8
	lordSkillIDDefine.harvest[BUILDID.STEEL], (nil).sprite = nil, "#et_fs_my_01.png"
	_ENV = nil
	;(nil).pattern = "et_fs_sj_%.2d.png"
	;(nil).beginp = 1
	;(nil).endp = 8
	lordSkillIDDefine.harvest[BUILDID.CRYSTAL_MINE], (nil).sprite = nil, "#et_fs_sj_01.png"
	local resourceAnimation = lordSkillIDDefine.harvest
	if skillID == lordSkillIDDefine.trapAction and skillTable[lordSkillIDDefine.trapAction] then
		local buildIndex = self:getBuildIndexByBid(BUILDID.FORTRESS)
		if buildIndex then
			local place = self:getBuildBtnByIndex(buildIndex)
			if place then
				_ENV = buildIndex
				buildIndex.msg = "MESSAGE_MAINCITYVIEW_GO_TO_BUILD"
				buildIndex.buildID = BUILDID.FORTRESS
				buildIndex.delay = 0
				buildIndex.needRecover = true
				SoraDSendMessage(buildIndex)
				do
					local armyDesRead = include("armyDesRead")
					_UPVALUE5_ = BUILDID.FORTRESS
					BUILDID.FORTRESS[1] = cca.delay(0.5)
					BUILDID.FORTRESS[2] = cca.callFunc(function()
						local parNode = SoraDCreateEffectNode(skillTable[lordSkillIDDefine.trapAction])
						parNode:setPosition(cc.p(place:getContentSize().width / 2, place:getContentSize().height / 2))
						parNode:addTo(place, 5)
					end)
					BUILDID.FORTRESS[3] = cca.delay(0.5)
					BUILDID.FORTRESS[4] = cca.callFunc(function()
						local trapSprite = display.newSprite(armyDesRead.getIcon(trapType, true))
						trapSprite:setAnchorPoint(cc.p(0.5, 0))
						trapSprite:setName("trapSprite")
						trapSprite:setPosition(cc.p(place:getContentSize().width / 2, place:getContentSize().height + 100))
						trapSprite:addTo(place, 5)
						trapSprite:runAction(cca.moveTo(0.3, cc.p(place:getContentSize().width / 2, 0)))
					end)
					BUILDID.FORTRESS[5] = cca.delay(0.3)
					BUILDID.FORTRESS[6] = cca.callFunc(function()
						SoraDShowMsgTip(i18n("notice_0114"))
						place:removeChildByName("trapSprite", true)
					end)
					BUILDID.FORTRESS[7] = cca.callFunc(function()
						SoraDShowMsgTip(i18n("notice_0114"))
						place:removeChildByName("trapSprite", true)
					end)
					BUILDID.FORTRESS[8] = cca.callFunc(function()
						SoraDShowMsgTip(i18n("notice_0114"))
						place:removeChildByName("trapSprite", true)
					end)
					BUILDID.FORTRESS[9] = cca.callFunc(function()
						SoraDShowMsgTip(i18n("notice_0114"))
						place:removeChildByName("trapSprite", true)
					end)
					BUILDID.FORTRESS[10] = cca.callFunc(function()
						SoraDShowMsgTip(i18n("notice_0114"))
						place:removeChildByName("trapSprite", true)
					end)
					BUILDID.FORTRESS[11] = cca.callFunc(function()
						SoraDShowMsgTip(i18n("notice_0114"))
						place:removeChildByName("trapSprite", true)
					end)
					BUILDID.FORTRESS[12] = cca.callFunc(function()
						SoraDShowMsgTip(i18n("notice_0114"))
						place:removeChildByName("trapSprite", true)
					end)
					BUILDID.FORTRESS[13] = cca.callFunc(function()
						SoraDShowMsgTip(i18n("notice_0114"))
						place:removeChildByName("trapSprite", true)
					end)
					BUILDID.FORTRESS[14] = cca.callFunc(function()
						SoraDShowMsgTip(i18n("notice_0114"))
						place:removeChildByName("trapSprite", true)
					end)
					local seq = transition.sequence(BUILDID.FORTRESS)
					place:runAction(seq)
				end
			end
		end
	elseif skillID == lordSkillIDDefine.harvest and skillTable[lordSkillIDDefine.harvest] then
		local resourcePlaces = self:getAllResBuildBtn()
		if 0 < #resourcePlaces then
			self:gotoOuterCity(true)
			for i, v in ipairs(resourcePlaces) do
				local rType = v[1]
				local place = v[2]
				local entity = v[3]
				if entity == nil or entity:getIsLocked() then
				else
					_UPVALUE6_ = entity
					entity[1] = cca.delay(1.5)
					entity[2] = cca.callFunc(function()
						local parNode = SoraDCreateEffectNode(skillTable[lordSkillIDDefine.harvest])
						parNode:setPosition(cc.p(place:getContentSize().width / 2, place:getContentSize().height / 2))
						parNode:addTo(place, 5)
					end)
					entity[3] = cca.delay(0.2)
					entity[4] = cca.callFunc(function()
						local sprite = display.newSprite(resourceAnimation[rType].sprite)
						sprite:setName("getResourceAnimation")
						sprite:setPosition(cc.p(place:getContentSize().width / 2, place:getContentSize().height))
						sprite:addTo(place, 5)
						local frames = display.newFrames(resourceAnimation[rType].pattern, resourceAnimation[rType].beginp, resourceAnimation[rType].endp)
						local animation = display.newAnimation(frames, 0.125)
						sprite:playAnimationOnce(animation)
					end)
					entity[5] = cca.callFunc(function()
						local output = buildLogic.getResOutputHour(rType, entity:getBuildLv(), entity:getIid())
						local totalOutput = output.total or 0
						buildLogic = entity:getIid()
						entity:getIid().text = "+" .. totalOutput
						entity:getIid().color = display.COLOR_GREEN
						entity:getIid().size = 26
						local floatingLabel = display.newTTFLabel(entity:getIid())
						floatingLabel:addTo(self.containerView, 500)
						floatingLabel:setPosition(cc.p(place:getPositionX(), place:getPositionY()))
						local moveBy = cca.moveBy(0.5, 0, 80)
						local delay = cca.delay(0.5)
						local callFunc = cca.callFunc(function()
							floatingLabel:removeFromParent()
						end)
						_ENV = cc.p(place:getPositionX(), place:getPositionY())
						cc.p(place:getPositionX(), place:getPositionY())[1] = moveBy
						cc.p(place:getPositionX(), place:getPositionY())[2] = delay
						cc.p(place:getPositionX(), place:getPositionY())[3] = callFunc
						local seq = cca.seq(cc.p(place:getPositionX(), place:getPositionY()))
						floatingLabel:runAction(seq)
					end)
					entity[6] = cca.delay(1)
					entity[7] = cca.callFunc(function()
						SoraDShowMsgTip(i18n("notice_0113"))
						place:removeChildByName("getResourceAnimation", true)
					end)
					entity[8] = cca.callFunc(function()
						SoraDShowMsgTip(i18n("notice_0113"))
						place:removeChildByName("getResourceAnimation", true)
					end)
					do
						local seq = transition.sequence(entity)
						place:runAction(seq)
					end
				end
			end
		end
	elseif skillID == lordSkillIDDefine.rescue or skillID == lordSkillIDDefine.collectprotect or skillID == lordSkillIDDefine.fastmarch then
		local panel = SoraDCreatePanel("commonUseSkill")
		panel:initData(skillID)
		panel:show()
	end
end
function effectMainCityView.initCelebrateGift(mainCity, target, data)
	local self = mainCity
	local ramadanRewardCtrl = gametop.playertop_:getModule("ramadanRewardCtrl")
	local isOpen = ramadanRewardCtrl:getIsOpen()
	local isReceived = ramadanRewardCtrl:getIsReceive()
	local isCelebrate = isOpen and not isReceived
	local celebrateBtn = self.containerView:getChildByName("celebrateBtn")
	if isCelebrate then
		if not celebrateBtn then
			celebrateBtn = SoraDCreatePanel("cityGiftBox")
			celebrateBtn:setPosition(cc.p(3951.0, 2503.0))
			celebrateBtn:setName("celebrateBtn")
			celebrateBtn:addTo(self.containerView, 5)
		end
		celebrateBtn:initData(1)
	elseif celebrateBtn then
		self.containerView:removeChildByName("celebrateBtn", true)
	end
end
function effectMainCityView.openGenaralEffect(mainCity)
	local self = mainCity
end
function effectMainCityView.openPaidEffect(mainCity, isRamadan)
	local self = mainCity
end
function effectMainCityView.updateCityShow(mainCity)
	local self = mainCity
end
function effectMainCityView.updateCastle(mainCity, period, skinID, isInit, isEnd)
	local self = mainCity
	local defaultModel = BUILD_CASTLE_MODEL.CLASSICAL
	local initSkinID = skinID
	local dressType
	local period = period or SoraDGetDayPeriod()
	local ret = cityCtrl:getBuildCell(BUILDID.MIRACLE, 0)
	self.castleModel = BUILD_CASTLE_MODEL.CLASSICAL
	if ret then
		self.castleModel = BUILD_CASTLE_MODEL.WARLV
	end
	local dressCtrl = gametop.playertop_:getModule("dressCtrl")
	local skinID = skinID or dressCtrl:getDressOfCastle()
	self.selectSkinID = skinID
	local kingCastleID = 9002582
	if skinID and skinID ~= kingCastleID then
		local castleSkinRead = include("castleSkinRead")
		self.castleModel = castleSkinRead.getCastleType(skinID)
		if self.castleModel == BUILD_CASTLE_MODEL.CLASSICAL and ret then
			self.castleModel = BUILD_CASTLE_MODEL.WARLV
			defaultModel = BUILD_CASTLE_MODEL.WARLV
		end
		dressType = dressltCtrl.getDressType(skinID)
	end
	if dressType and dressType ~= gDressType.CASTLE then
		print("非装扮类 不更新!!!!!!", dressType)
		return
	end
	if skinID and dressltCtrl.getDressType(skinID) == gDressType.CASTLE and not isEnd and not isInit then
		_ENV = gDressType.CASTLE
		gDressType.CASTLE.msg = "MESSAGE_UI_CASTLE_CHANGE"
		SoraDSendMessage(gDressType.CASTLE)
	end
	if initSkinID and self.castleModel == BUILD_CASTLE_MODEL_DEFAULT then
		return
	end
	print("skinID,self.castleModel=", skinID, self.castleModel)
	local loadCastle = function()
		local skinInfo = cityBuildCastleSkinConfig.getSkinInfo(self.castleModel)
		local buildBtn = self:getBufferNodeByName("build_1050")
		local buildEntity = buildBtn:getChildByName("buildName")
		if skinInfo then
			buildBtn:setLocalZOrder(mainCityDefine.CITY_TARGET_ZORDER.castle_skin)
			if buildEntity then
				buildEntity.buildImg:setSpriteFrame("bg_transparent.png")
			end
			if self.castleSkin then
				self.castleSkin:removeRelation()
				self.castleSkin:removeFromParent()
				self.castleSkin = nil
			end
			if skinInfo.isFgui then
				local csb = not SoraDFIsRA() and skinInfo.csb_ros and skinInfo.csb_ros or skinInfo.csb
				self.castleSkin = fgui.UIPackage:createObject("CastleSkin", csb)
				self.castleSkin:init(self.castleModel)
			else
				self.castleSkin = include("mainCityCastleSkin").new(cityBuildCastleSkinConfig.getSkinCsb(skinInfo))
				self.castleSkin:initModel(self.castleModel, self.containerView, skinInfo)
			end
			self.castleSkin:setPosition(cityBuildCastleSkinConfig.getSkinOffset(skinInfo))
			self.castleSkin:addTo(buildBtn)
			BUILD_CASTLE_MODEL_DEFAULT = self.castleModel
			if self.npcCastlePeople then
				self.npcCastlePeople:setVisible(not skinInfo.isHideNpc)
			end
			if period == gDay.DAY_TIME then
				self.castleSkin:setDayStyle()
			else
				self.castleSkin:setNightStyle()
			end
		end
		local imgUpgradePos, buildLvBgPos, textLvPos = cityBuildCastleSkinConfig.getCastleLvPos(self.castleModel)
		if buildEntity then
			if buildEntity.imgUpgrade then
				buildEntity.imgUpgrade:setPosition(imgUpgradePos)
			end
			if buildEntity.buildLvBg then
				buildEntity.buildLvBg:setPosition(buildLvBgPos)
			end
			if buildEntity.textLv then
				buildEntity.textLv:setPosition(textLvPos)
			end
			buildEntity:updateStarLvPos()
		end
		effectMainCityView.updateNightScene(self, period)
	end
	loadCastle()
end
function effectMainCityView.updateNightScene(mainCity, period)
	local self = mainCity
	local period = period or SoraDGetDayPeriod()
	local isCfgNightOn = SoraDConfigGet("Game:GameOptionsView:nightSwitch~bool")
	math.randomseed(tostring(os.time()):reverse():sub(1, 7))
	_ENV = tostring(os.time()):reverse():sub(1, 7)
	tostring(os.time()):reverse():sub(1, 7).msg = "MESSAGE_MAINCITYVIEW_UPDATE_WALL_NIGHT_CFG"
	tostring(os.time()):reverse():sub(1, 7).period = period
	SoraDSendMessage(tostring(os.time()):reverse():sub(1, 7))
	local loadCommonNightLight = function()
		if self.commonLampNode then
			self.commonLampNode:removeFromParent()
			self.commonLampNode = nil
		end
		if SoraDGetFactionType() == FACTION_TYPE.FACTION_BYZANTINE then
			self.commonLampNode = include("mainCityNightCommonSkinBzt").new()
			self.commonLampNode:setPosition(0, 0)
		else
			self.commonLampNode = include("mainCityNightCommonSkin").new()
			self.commonLampNode:setCastleModel(self.castleModel)
			self.commonLampNode:setPosition(0, 0)
		end
		self.commonLampNode:setLocalZOrder(mainCityDefine.CITY_TARGET_ZORDER.night_common)
		self.commonLampNode:addTo(self.containerView)
	end
	local loadBuildNightLight = function()
		effectMainCityView.updateInnderBuildingLamp(self, period)
		effectMainCityView.updateOuterBuildingLamp(self, period)
	end
	local loadWallNightLight = function()
		if self.wallLampNode then
			self.wallLampNode:removeFromParent()
			self.wallLampNode = nil
		end
		local buildCell = cityCtrl:getBuildCellByIndex(1053)
		if buildCell then
			local buildLv = tonumber(buildCell.info.lv)
			local tblViewModelCfg = cityBuildViewDef.tblViewModelWall
			if SoraDGetFactionType() == FACTION_TYPE.FACTION_BYZANTINE then
				tblViewModelCfg = cityBuildViewDef.tblViewBZTModelWall
			end
			local viewModel = cityBuildViewDef.getViewModelByLv(buildLv, tblViewModelCfg)
			self.wallLampNode = cityBuildWallDef.getChengqiangLight(viewModel)
			self.wallLampNode:setLocalZOrder(mainCityDefine.CITY_TARGET_ZORDER.night_common)
			self.wallLampNode:addTo(self.containerView)
		end
	end
	local loadCatleNightLight = function()
		if self.castleNightSkin then
			if self.castleNightSkin.model == self.castleModel then
				if self.castleSkin then
					self.castleSkin:setNightStyle()
				end
				return
			end
			self.castleNightSkin:removeFromParent()
			self.castleNightSkin = nil
		end
		local skinInfo = cityBuildCastleSkinConfig.getSkinInfo(self.castleModel)
		if skinInfo then
			local buildBtn = self:getBufferNodeByName("build_1050")
			local offset = cityBuildCastleSkinConfig.getSkinOffset(skinInfo)
			local pos = cc.p(buildBtn:getPositionX() - buildBtn:getContentSize().width / 2 + offset.x, buildBtn:getPositionY() - buildBtn:getContentSize().height / 2 + offset.y)
			if skinInfo.isFgui then
				local night = not SoraDFIsRA() and skinInfo.night_ros and skinInfo.night_ros or skinInfo.night
				self.castleNightSkin = fgui.UIPackage:createObject("CastleSkin", night)
				self.castleNightSkin:init(skinInfo)
				self.castleNightSkin:setPosition(cc.p(pos.x, skinInfo.posNightY or pos.y))
			else
				self.castleNightSkin = include("mainCityCastleNightSkin").new(cityBuildCastleSkinConfig.getSkinNightCsb(skinInfo))
				self.castleNightSkin:initModel(self.castleModel, self.castleSkin, pos)
				self.castleNightSkin:setPosition(pos)
			end
			self.castleNightSkin:setLocalZOrder(mainCityDefine.CITY_TARGET_ZORDER.night_castle)
			self.castleNightSkin:addTo(self.containerView)
		end
	end
	if period == gDay.DAY_TIME or not isCfgNightOn then
		if self.castleSkin then
			self.castleSkin:setDayStyle()
		end
		if self.castleNightSkin then
			self.castleNightSkin:removeFromParent()
			self.castleNightSkin = nil
		end
		if self.commonLampNode then
			self.commonLampNode:removeFromParent()
			self.commonLampNode = nil
		end
		return
	end
	loadCommonNightLight()
	loadBuildNightLight()
	loadCatleNightLight()
	loadWallNightLight()
end
function effectMainCityView.updateInnderBuildingLamp(mainCity, period)
	local self = mainCity
	local period = period or SoraDGetDayPeriod()
	local isCfgNightOn = SoraDConfigGet("Game:GameOptionsView:nightSwitch~bool")
	_UPVALUE17_ = "Game:GameOptionsView:nightSwitch~bool"
	;("Game:GameOptionsView:nightSwitch~bool")[1] = 1051
	;("Game:GameOptionsView:nightSwitch~bool")[2] = 1056
	;("Game:GameOptionsView:nightSwitch~bool")[3] = 1057
	;("Game:GameOptionsView:nightSwitch~bool")[4] = 1058
	;("Game:GameOptionsView:nightSwitch~bool")[5] = 1059
	;("Game:GameOptionsView:nightSwitch~bool")[6] = 1060
	;("Game:GameOptionsView:nightSwitch~bool")[7] = 1061
	;("Game:GameOptionsView:nightSwitch~bool")[8] = 1062
	;("Game:GameOptionsView:nightSwitch~bool")[9] = 1063
	;("Game:GameOptionsView:nightSwitch~bool")[10] = 1064
	;("Game:GameOptionsView:nightSwitch~bool")[11] = 1065
	;("Game:GameOptionsView:nightSwitch~bool")[12] = 1066
	;("Game:GameOptionsView:nightSwitch~bool")[13] = 1067
	;("Game:GameOptionsView:nightSwitch~bool")[14] = 30003
	;("Game:GameOptionsView:nightSwitch~bool")[15] = 1201
	;("Game:GameOptionsView:nightSwitch~bool")[16] = 1203
	;("Game:GameOptionsView:nightSwitch~bool")[17] = 1204
	local ("Game:GameOptionsView:nightSwitch~bool")[18], indexTB = 30006, "Game:GameOptionsView:nightSwitch~bool"
	if commonCheck.NEBULA_AREA then
		table.insert(indexTB, 1206)
	end
	if SoraDGetCtrl("magicLampCtrl"):getIsBuildShow() then
		table.insert(indexTB, 30010)
	end
	if SoraDGetCtrl("divineBeastCtrl"):getIsUnlock() then
		table.insert(indexTB, 30011)
	end
	if SoraDGetCtrl("manorCityCtrl"):getIsUnLock() then
		table.insert(indexTB, BUILDID.GARDEN)
	end
	for k, v in ipairs(indexTB) do
		local buildBtn = self:getBufferNodeByName("build_" .. v)
		if buildBtn then
			local buildEntity = buildBtn:getChildByName("buildName")
			if self.containerView:getChildByName("lampNode" .. v) then
				self.containerView:removeChildByName("lampNode" .. v, true)
			end
			print("buildEntity", buildEntity, v)
			if buildEntity then
				if (period == gDay.DAY_TIME or not isCfgNightOn) and self.containerView:getChildByName("lampNode" .. v) then
					self.containerView:removeChildByName("lampNode" .. v, true)
				elseif period ~= gDay.DAY_TIME and isCfgNightOn then
					if self.containerView:getChildByName("lampNode" .. v) then
						self.containerView:removeChildByName("lampNode" .. v, true)
					end
					local bid = buildEntity:getBuildBid()
					local png, offset = cityNightSkinDef.getInnerLamplightByBid(bid)
					print("getInnerLamplightByBid", png, offset, bid)
					if png then
						png:setName("lampNode" .. v)
						png:setPosition(cc.p(buildBtn:getPositionX() + offset.x, buildBtn:getPositionY() + offset.y))
						png:setGroupID(mainCityDefine.CITY_TARGET_GROUPID.GROUP_NIGHT_BUILD)
						png:addTo(self.containerView)
					end
				end
			end
		end
	end
end
function effectMainCityView.updateOuterBuildingLamp(mainCity, period)
	local self = mainCity
	local period = period or SoraDGetDayPeriod()
	local isCfgNightOn = SoraDConfigGet("Game:GameOptionsView:nightSwitch~bool")
	for k = 1100, 1134 do
		if self.containerView:getChildByName("lampNode_out" .. k) then
			self.containerView:removeChildByName("lampNode_out" .. k, true)
		end
		local buildBtn = self:getBufferNodeByName("build_" .. k)
		local buildEntity = buildBtn:getChildByName("buildName")
		if buildEntity then
			if (period == gDay.DAY_TIME or not isCfgNightOn) and self.containerView:getChildByName("lampNode_out" .. k) then
				self.containerView:removeChildByName("lampNode_out" .. k, true)
			elseif period ~= gDay.DAY_TIME and isCfgNightOn then
				if self.containerView:getChildByName("lampNode_out" .. k) then
					self.containerView:removeChildByName("lampNode_out" .. k, true)
				end
				local bid = buildEntity:getBuildBid()
				local _ENV, modelCfg = buildEntity, buildEntity
				if bid == BUILDID.FARM then
					modelCfg = cityBuildViewDef.tblViewModelFarm
				elseif bid == BUILDID.SAWMILL then
					modelCfg = cityBuildViewDef.tblViewModelSawMill
				end
				local model = buildEntity:getViewModelByLv(buildEntity:getBuildLv(), modelCfg)
				local png, offset = cityNightSkinDef.getOuterLamplightByBid(bid, model)
				if png then
					png:setName("lampNode_out" .. k)
					png:setPosition(cc.p(buildBtn:getPositionX() + offset.x, buildBtn:getPositionY() + offset.y))
					png:setGroupID(mainCityDefine.CITY_TARGET_GROUPID.GROUP_NIGHT_BUILD)
					png:addTo(self.containerView)
				end
			end
		end
	end
end
function effectMainCityView.createDarkLayers(mainCity, dayPeriod)
	local self = mainCity
	local createDarkLayer = function()
		local darkLayer = display.newSprite("#et_zhuchengyekong.png")
		darkLayer:setAnchorPoint(cc.p(0, 0))
		local oriSize = darkLayer:getContentSize()
		local contentSize = self.containerView:getContentSize()
		local topLandHeight = 200
		local bottomLandHeight = 370
		darkLayer:setScaleX((contentSize.width + 260) / oriSize.width)
		darkLayer:setScaleY((contentSize.height + topLandHeight + bottomLandHeight) / oriSize.height)
		local posY = -(topLandHeight + bottomLandHeight)
		darkLayer:setPosition(cc.p(-260, posY))
		darkLayer:setName("darkLayer")
		darkLayer:setOpacityModifyRGB(true)
		return darkLayer
	end
	local opacityLightNight = cityBuildConstDef.opacityType.opacityLightNight
	local opacityDeepNight = cityBuildConstDef.opacityType.opacityDeepNight
	local targetOpacity = opacityLightNight
	if dayPeriod == gDay.DAY_NIGHT then
		targetOpacity = opacityDeepNight
	elseif dayPeriod == gDay.DAY_DAWN then
		targetOpacity = opacityLightNight
	elseif dayPeriod == gDay.DAY_DUSK then
		targetOpacity = opacityLightNight
	elseif dayPeriod == gDay.DAY_TIME then
		targetOpacity = 0
	end
	local darkLayer = self:getBufferNodeByName("darkLayer")
	local darkLayer2 = self:getBufferNodeByName("darkLayer2")
	if darkLayer == nil then
		darkLayer = createDarkLayer()
		self.containerView:addChild(darkLayer)
		darkLayer:setLocalZOrder(mainCityDefine.CITY_TARGET_ZORDER.night_layer)
		self:addToBufferNodeArrayByName("darkLayer", darkLayer)
		darkLayer:setOpacity(targetOpacity)
		darkLayer:setBlendFunc(gl.DST_COLOR, gl.ONE_MINUS_SRC_ALPHA)
	end
end
function effectMainCityView.showDark(mainCity, dayPeriod)
	local self = mainCity
	local animTime = 1.0
	local opacityLightNight = cityBuildConstDef.opacityType.opacityLightNight
	local opacityDeepNight = cityBuildConstDef.opacityType.opacityDeepNight
	local darkLayer = self:getBufferNodeByName("darkLayer")
	local darkLayer2 = self:getBufferNodeByName("darkLayer2")
	local currentColor = cc.c4b(18, 80, 129, 255)
	local currentOpacity = 0
	local targetOpacity = opacityLightNight
	if dayPeriod == gDay.DAY_NIGHT then
		currentOpacity = opacityLightNight
		targetOpacity = opacityDeepNight
	elseif dayPeriod == gDay.DAY_DAWN then
		currentOpacity = opacityDeepNight
		targetOpacity = opacityLightNight
	elseif dayPeriod == gDay.DAY_DUSK then
		currentOpacity = 0
		targetOpacity = opacityLightNight
	end
	if darkLayer == nil then
		effectMainCityView.createDarkLayers(self, dayPeriod)
	else
		darkLayer:setVisible(true)
		darkLayer:stopAllActions()
		darkLayer:setOpacity(currentOpacity)
		local actFadeTo = cca.fadeTo(animTime, targetOpacity / 255.0)
		darkLayer:runAction(actFadeTo)
	end
end
function effectMainCityView.updateDarkOpacity(mainCity)
	local self = mainCity
	local delay, targetOpacity = mainCityFunctions:getNextPeroidDelay()
	local darkLayer = self:getBufferNodeByName("darkLayer")
	local darkLayer2 = self:getBufferNodeByName("darkLayer2")
	local animTime = 0.5
	print("==========targetOpacity = ", targetOpacity)
	if darkLayer then
		local actFadeTo = cca.fadeTo(animTime, targetOpacity / 255.0)
		darkLayer:runAction(actFadeTo)
		if darkLayer2 then
			local actFadeTo2 = cca.fadeTo(animTime, targetOpacity / 255.0)
			darkLayer2:runAction(actFadeTo2)
		end
	end
end
function effectMainCityView.hideDark(mainCity)
	local self = mainCity
	local animTime = 1.0
	local opacityLightNight = cityBuildConstDef.opacityType.opacityLightNight
	local opacityDeepNight = cityBuildConstDef.opacityType.opacityDeepNight
	local currentOpacity = opacityLightNight
	local targetOpacity = 0
	local darkLayer = self:getBufferNodeByName("darkLayer")
	if not darkLayer then
		effectMainCityView.createDarkLayers(self, gDay.DAY_TIME)
	else
		darkLayer:stopAllActions()
		local actFadeTo = cca.fadeTo(animTime, targetOpacity)
		local callFunc = cca.callFunc(function()
			darkLayer:setVisible(false)
		end)
		_ENV = nil
		;(nil)[1] = actFadeTo
		;(nil)[2] = callFunc
		darkLayer:runAction(cca.seq(nil))
		local darkLayer2 = self:getBufferNodeByName("darkLayer2")
		if darkLayer2 then
			darkLayer2:stopAllActions()
			do
				local actFadeTo2 = cca.fadeTo(animTime, targetOpacity)
				local callFunc2 = cca.callFunc(function()
					darkLayer2:setVisible(false)
				end)
				_ENV = cca.seq(nil)
				cca.seq(nil)[1] = actFadeTo2
				cca.seq(nil)[2] = callFunc2
				darkLayer2:runAction(cca.seq(cca.seq(nil)))
			end
		end
	end
end
function effectMainCityView.enterDayPeriod(mainCity, dayPeriod)
	local self = mainCity
	local mainCityCreate = include("mainCityCreate")
	self.currentDayPeriod = dayPeriod
	if dayPeriod == gDay.DAY_TIME then
		effectMainCityView.hideDark(self)
		self.isShowDark = false
		mainCityCreate.initWeather(self)
		effectMainCityView.cloudRunEffect(self)
	elseif dayPeriod == gDay.DAY_DUSK or dayPeriod == gDay.DAY_NIGHT or dayPeriod == gDay.DAY_DAWN then
		effectMainCityView.showDark(self, dayPeriod)
		self.isShowDark = true
		effectMainCityView.removeWeatherEffect(self, nil, true)
		effectMainCityView.removeCloudEffect(self)
	end
	effectMainCityView.updateNightScene(self, self.currentDayPeriod)
end
function effectMainCityView.updateCommunityView(mainCity, target, data)
	local self = mainCity
	local castleLv = 1
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local castleBcell = cityCtrl:getBuildCell(BUILDID.CASTLE, 0)
	if castleBcell then
		castleLv = tonumber(castleBcell.info.lv)
	end
	if data and data.castleLv then
		castleLv = data.castleLv
	end
	gametop = castleBcell.info.lv
	castleBcell.info.lv.msg = "MESSAGE_MAINCITYVIEW_UPDATE_SERVICECENTER"
	SoraDSendMessage(castleBcell.info.lv)
	if castleLv >= CASTLE_LV25_LIMITED then
		local btn_30005 = self:getBufferNodeByName("build_30005")
		if nil ~= btn_30005 then
			btn_30005:setPosition(cc.p(2192, 3048))
		end
		local img_bg_miracle = self:getBufferNodeByName("BG_miracle")
		if img_bg_miracle then
			img_bg_miracle:setVisible(IsArClient)
		end
		local btn_1200 = self:getBufferNodeByName("build_1200")
		if nil ~= btn_1200 then
			btn_1200:setVisible(true)
		end
	else
		local btn_30005 = self:getBufferNodeByName("build_30005")
		if nil ~= btn_30005 then
			btn_30005:setPosition(cc.p(3670, 2969))
		end
		local img_bg_miracle = self:getBufferNodeByName("BG_miracle")
		if img_bg_miracle then
			img_bg_miracle:setVisible(false)
		end
		local btn_1200 = self:getBufferNodeByName("build_1200")
		if nil ~= btn_1200 then
			btn_1200:setVisible(false)
		end
	end
	local buttonCommunityCenter = self:getBufferNodeByName("build_30005")
	if not buttonCommunityCenter then
		return
	end
	local btnCommunityPos = cc.p(buttonCommunityCenter:getPosition())
	if self.tipBoxCommunity ~= nil then
		local deltaOffsetY = castleLv >= CASTLE_LV25_LIMITED and 73 or 83
		local deltaOffsetX = castleLv >= CASTLE_LV25_LIMITED and 43 or 0
		self.tipBoxCommunity:setPosition(cc.p(btnCommunityPos.x + deltaOffsetX, btnCommunityPos.y + deltaOffsetY))
	end
	if self.tipTopCommunity ~= nil then
		local deltaOffsetY = castleLv >= CASTLE_LV25_LIMITED and 76 or 76
		local deltaOffsetX = castleLv >= CASTLE_LV25_LIMITED and 43 or 0
		local buildTopTipPosition = cc.p(btnCommunityPos.x + deltaOffsetX, btnCommunityPos.y + deltaOffsetY)
		self.tipTopCommunity:setPosition(buildTopTipPosition)
		self.tipTopCommunity:setBasePos(buildTopTipPosition)
		self.tipTopCommunity:udpateViewWithBasePos()
	end
end
function effectMainCityView.updateStarBraveStatueView(mainCity, target, data)
	local self = mainCity
	local castleLv = 1
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local castleBcell = cityCtrl:getBuildCell(BUILDID.CASTLE, 0)
	if castleBcell then
		castleLv = tonumber(castleBcell.info.starLv)
	end
	dump(castleBcell.info, "effectMainCityView.updateStarBraveStatueView")
	if data and data.castleLv then
		castleLv = data.castleLv
	end
	if SoraDIsBraveOpen() then
		local dh_yzdxyz = self:getBufferNodeByName("dh_yzdxyz")
		if dh_yzdxyz then
			dh_yzdxyz:setVisible(true)
		end
		local btn_1205 = self:getBufferNodeByName("build_1205")
		if btn_1205 then
			btn_1205:setVisible(true)
		end
	else
		local dh_yzdxyz = self:getBufferNodeByName("dh_yzdxyz")
		if dh_yzdxyz then
			dh_yzdxyz:setVisible(false)
		end
		local btn_1205 = self:getBufferNodeByName("build_1205")
		if btn_1205 then
			btn_1205:setVisible(false)
		end
	end
end
function effectMainCityView.msgUpdatePetShow(mainCity, target, data)
	local self = mainCity
	local petCtrl = gametop.playertop_:getModule("petCtrl")
	local petList = petCtrl:getPetList()
	if petList ~= nil and next(petList) ~= nil then
		if self.groundPet ~= nil then
			self.groundPet:removeFromParent()
			self.groundPetShadow = nil
			self.groundPet = nil
		end
		if self.skyPet ~= nil then
			self.skyPet:removeFromParent()
			self.skyPet = nil
		end
		local gametop, groundPetList = self.skyPet.removeFromParent, self.skyPet.removeFromParent
		local gametop, skyPetList = self.skyPet, self.skyPet
		for i, v in ipairs(petList) do
			if v.petid == 1253 then
				table.insert(skyPetList, #skyPetList + 1, v)
			else
				table.insert(groundPetList, #groundPetList + 1, v)
			end
		end
		if 0 < #groundPetList then
			local petCenterPos = cc.p(2800, 1650)
			local numOfGroundPets = #groundPetList
			local randomIndex = math.random(1, numOfGroundPets)
			gametop = table.insert
			table.insert.byUID = true
			local showPid = SoraDConfigGet("Game:petView:cityPetShow~integer", table.insert)
			local index = 1
			for i, v in ipairs(groundPetList) do
				if showPid == v.petid then
					index = i
					break
				end
			end
			local curPet = groundPetList[index]
			local petDesRead = include("petDesRead")
			local hasPetHDRes = petDesRead.getHasPetHDRes(curPet.petid, curPet.rank)
			local petCfg = petDesRead.getPetCfg(curPet.petid, curPet.rank)
			if not petCfg then
				return
			end
			self.groundPetKey = petCfg.key
			if not hasPetHDRes then
				return
			end
			local groundPetNode = SoraDCreatePanel("petShowSingle")
			local curPetParam = clone(curPet)
			curPetParam.isShowPu = false
			groundPetNode:initData(curPetParam)
			groundPetNode:setPosition(petCenterPos)
			groundPetNode:setScale(0.3)
			groundPetNode:openMoveTouch(false)
			gametop = false
			;(false).x = 20
			;(false).y = 34
			;(false).z = -10
			groundPetNode.petRootNode:setRotation3D(false)
			groundPetNode:setName("groundPetNode")
			groundPetNode.touchPanel:setPositionY(-70)
			groundPetNode:setTouchSize(cc.size(300, 250))
			self.containerView:addChild(groundPetNode, 1100, "groundPetNode")
			self.groundPet = groundPetNode
			if self.groundPetShadow == nil then
				self.groundPetShadow = display.newSprite("#frame_pet_shadow.png")
				self.groundPetShadow:setName("groundPetShadow")
				self.groundPetShadow:addTo(self.groundPet)
				self.groundPetShadow:setPosition(cc.p(-20, -150))
				self.groundPetShadow:setLocalZOrder(-1)
				self.groundPetShadow:setScale(3)
			end
			if false then
				local handlerNode = groundPetNode
				handlerNode.rotateX = 0
				handlerNode.rotateY = 0
				handlerNode.rotateZ = 0
				local sliderX = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
				local commonSlider = include("commonSlider")
				gametop, sliderX = commonSlider.new(sliderX), commonSlider.new(sliderX)
				commonSlider.new(sliderX).maxValue = 180
				commonSlider.new(sliderX).minValue = 0
				commonSlider.new(sliderX).curValue = 90
				local commonSlider.new(sliderX).openEditBox, sliderData = true, commonSlider.new(sliderX)
				sliderX:initData(sliderData)
				sliderX:addTo(self.containerView)
				sliderX:setPosition(cc.p(600, 800))
				sliderX:setLocalZOrder(10000)
				sliderX:setSliderCallBack(function(valuechange)
					handlerNode.rotateX = valuechange - 90
					print("x = " .. handlerNode.rotateX .. ", y = " .. handlerNode.rotateY .. ", z = " .. handlerNode.rotateZ)
					handlerNode = handlerNode.rotateX
					handlerNode.rotateX.x = handlerNode.rotateX
					handlerNode.rotateX.y = handlerNode.rotateY
					handlerNode.rotateX.z = handlerNode.rotateZ
					handlerNode:setRotation3D(handlerNode.rotateX)
				end)
				local sliderY = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
				local commonSlider = include("commonSlider")
				gametop, sliderY = commonSlider.new(sliderY), commonSlider.new(sliderY)
				commonSlider.new(sliderY).maxValue = 180
				commonSlider.new(sliderY).minValue = 0
				commonSlider.new(sliderY).curValue = 90
				local commonSlider.new(sliderY).openEditBox, sliderData = true, commonSlider.new(sliderY)
				sliderY:initData(sliderData)
				sliderY:addTo(self.containerView)
				sliderY:setPosition(cc.p(600, 740))
				sliderY:setLocalZOrder(10000)
				sliderY:setSliderCallBack(function(valuechange)
					handlerNode.rotateY = valuechange - 90
					print("x = " .. handlerNode.rotateX .. ", y = " .. handlerNode.rotateY .. ", z = " .. handlerNode.rotateZ)
					handlerNode = handlerNode.rotateX
					handlerNode.rotateX.x = handlerNode.rotateX
					handlerNode.rotateX.y = handlerNode.rotateY
					handlerNode.rotateX.z = handlerNode.rotateZ
					handlerNode:setRotation3D(handlerNode.rotateX)
				end)
				local sliderZ = cc.CSLoader:createNode(getCCSPath("cityBuildSliderChange"))
				local commonSlider = include("commonSlider")
				gametop, sliderZ = commonSlider.new(sliderZ), commonSlider.new(sliderZ)
				commonSlider.new(sliderZ).maxValue = 180
				commonSlider.new(sliderZ).minValue = 0
				commonSlider.new(sliderZ).curValue = 90
				local commonSlider.new(sliderZ).openEditBox, sliderData = true, commonSlider.new(sliderZ)
				sliderZ:initData(sliderData)
				sliderZ:addTo(self.containerView)
				sliderZ:setPosition(cc.p(600, 680))
				sliderZ:setLocalZOrder(10000)
				sliderZ:setSliderCallBack(function(valuechange)
					handlerNode.rotateZ = valuechange - 90
					print("x = " .. handlerNode.rotateX .. ", y = " .. handlerNode.rotateY .. ", z = " .. handlerNode.rotateZ)
					handlerNode = handlerNode.rotateX
					handlerNode.rotateX.x = handlerNode.rotateX
					handlerNode.rotateX.y = handlerNode.rotateY
					handlerNode.rotateX.z = handlerNode.rotateZ
					handlerNode:setRotation3D(handlerNode.rotateX)
				end)
			end
		end
		if 0 < #skyPetList then
			local petCenterPos = cc.p(700, 750)
			local numOfSkyPets = #skyPetList
			local randomIndex = math.random(1, numOfSkyPets)
			local index = randomIndex
			local curPet = skyPetList[index]
			local petDesRead = include("petDesRead")
			local petCfg = petDesRead.getPetCfg(curPet.petid, curPet.rank)
			if not petCfg then
				return
			end
			self.skyPetKey = petCfg.key
			local hasPetHDRes = petDesRead.getHasPetHDRes(curPet.petid, curPet.rank)
			if not hasPetHDRes then
				return
			end
			local skyPetNode = SoraDCreatePanel("petShowSingle")
			local curPetParam = clone(curPet)
			curPetParam.isShowPu = false
			skyPetNode:initData(curPetParam)
			skyPetNode:setPositionZ(-400)
			skyPetNode:openMoveTouch(false)
			skyPetNode:showEagleAction(self.containerView:getContentSize())
			self.containerView:addChild(skyPetNode, 10000, "skyPetNode")
			skyPetNode:setName("skyPetNode")
			self.skyPet = skyPetNode
		end
	end
end
function effectMainCityView.showWaterfallCastle(mainCity)
	local self = mainCity
	if not mainCity then
		return
	end
	local castleWaterMeshData = require("app.game.mainCity.meshData.castlewater_meshData")
	print("创建 城堡水流-----begin")
	_ENV, _UPVALUE4_ = "创建 城堡水流-----begin", print
	;("创建 城堡水流-----begin").attr = "texture"
	;("创建 城堡水流-----begin").name = "_liushui1"
	;("创建 城堡水流-----begin").value = "SinglePicture/citycastlewater1.png"
	_UPVALUE4_, ("创建 城堡水流-----begin").hasMipmap = nil, true
	_ENV, ("创建 城堡水流-----begin").texParam, (nil)[1] = nil, nil, gl.LINEAR_MIPMAP_NEAREST
	_ENV, ("创建 城堡水流-----begin").texParam, (nil)[2] = nil, nil, gl.LINEAR
	_ENV, ("创建 城堡水流-----begin").texParam, (nil)[3] = nil, nil, gl.REPEAT
	_ENV, ("创建 城堡水流-----begin").texParam, (nil)[4] = nil, nil, gl.REPEAT
	;(nil).attr = "texture"
	;(nil).name = "_liushui2"
	;(nil).value = "SinglePicture/citycastlewater2.png"
	_UPVALUE4_, (nil).hasMipmap = gl.LINEAR_MIPMAP_NEAREST, true
	_ENV, (nil).texParam, gl.LINEAR_MIPMAP_NEAREST[1] = gl.LINEAR_MIPMAP_NEAREST, gl.LINEAR_MIPMAP_NEAREST, gl.LINEAR_MIPMAP_NEAREST
	_ENV, (nil).texParam, gl.LINEAR_MIPMAP_NEAREST[2] = gl.LINEAR_MIPMAP_NEAREST, gl.LINEAR_MIPMAP_NEAREST, gl.LINEAR
	_ENV, (nil).texParam, gl.LINEAR_MIPMAP_NEAREST[3] = gl.LINEAR_MIPMAP_NEAREST, gl.LINEAR_MIPMAP_NEAREST, gl.REPEAT
	_ENV, (nil).texParam, gl.LINEAR_MIPMAP_NEAREST[4] = gl.LINEAR_MIPMAP_NEAREST, gl.LINEAR_MIPMAP_NEAREST, gl.REPEAT
	gl.LINEAR_MIPMAP_NEAREST.attr = "timeuv"
	_ENV, gl.LINEAR_MIPMAP_NEAREST.name = gl.LINEAR_MIPMAP_NEAREST, "time_uv0"
	gl.LINEAR_MIPMAP_NEAREST.kU = 0.0015
	_ENV, gl.LINEAR_MIPMAP_NEAREST.value, gl.LINEAR_MIPMAP_NEAREST.kV = gl.LINEAR_MIPMAP_NEAREST, gl.LINEAR_MIPMAP_NEAREST, 0.22499999999999998
	gl.LINEAR_MIPMAP_NEAREST.attr = "timeuv"
	_ENV, gl.LINEAR_MIPMAP_NEAREST.name = gl.LINEAR, "time_uv1"
	gl.LINEAR.kU = 0.0015
	gl.LINEAR_MIPMAP_NEAREST.value, gl.LINEAR.kV = gl.LINEAR, 0.22499999999999998
	print[1] = "创建 城堡水流-----begin"
	print[2] = nil
	print[3] = gl.LINEAR_MIPMAP_NEAREST
	local print[4], param = gl.LINEAR_MIPMAP_NEAREST, print
	local initPos = cc.p(2097, 1683)
	local initScaleX = 1.58
	local initScaleY = 1.58
	local castleWaterShader = require("app.game.mainCity.shader.castleWater")
	_ENV = "app.game.mainCity.shader.castleWater"
	;("app.game.mainCity.shader.castleWater").meshData = castleWaterMeshData
	_ENV, ("app.game.mainCity.shader.castleWater").size = cc.size(1, 1), cc.size(1, 1)
	cc.size(1, 1).vertBytes = castleWaterShader.vertBytes
	;("app.game.mainCity.shader.castleWater").shader, cc.size(1, 1).fragBytes = cc.size(1, 1), castleWaterShader.fragBytes
	;("app.game.mainCity.shader.castleWater").param = param
	_ENV, ("app.game.mainCity.shader.castleWater").pos = cc.size(1, 1), initPos
	cc.size(1, 1).x = initScaleX
	;("app.game.mainCity.shader.castleWater").scale, cc.size(1, 1).y = cc.size(1, 1), initScaleY
	local castleWaterData = "app.game.mainCity.shader.castleWater"
	local castleWater = SoraDCreateMeshNode(castleWaterData.meshData, castleWaterData.size, castleWaterData.shader, castleWaterData.param)
	castleWater:setName("mesh_castleWater")
	castleWater:setPosition(cc.p(castleWaterData.pos))
	castleWater:setScale(castleWaterData.scale.x, castleWaterData.scale.y)
	castleWater:addTo(self.containerView, 1000)
	print("创建 城堡水流-----end")
	return castleWater
end
function effectMainCityView.removeWaterfallCastle(mainCity)
	local self = mainCity
	if not mainCity then
		return
	end
	if self.containerView and self.containerView:getChildByName("mesh_castleWater") then
		self.containerView:removeChildByName("mesh_castleWater", true)
	end
end
function effectMainCityView.addPetFlyBird(mainCity)
	local self = mainCity
	if not mainCity then
		return
	end
	local showBird = function()
		local petBird = display.newSprite("#cwg_fly_01.png")
		local frames = display.newFrames("cwg_fly_%.2d.png", 1, 47)
		local animation = display.newAnimation(frames, 6.0 / #frames)
		petBird:playAnimationForever(animation)
		petBird:setPosition(cc.p(3200, 2262))
		petBird:addTo(self.containerView, mainCityDefine.CITY_TARGET_ZORDER.juying)
	end
end
function effectMainCityView.addCommandHallBox(mainCity)
	local self = mainCity
	local effect = SoraDCreatAnimation("Node_tsdt_box")
	effect:addTo(self.containerView)
	local commandHallUtil = include("commandHallUtil")
	local pos = commandHallUtil.getShowFightingPos()
	effect:setPosition(cc.p(pos.x, pos.y))
	_UPVALUE2_ = cc.p(pos.x, pos.y)
	cc.p(pos.x, pos.y)[1] = "Node_box"
	cc.p(pos.x, pos.y)[2] = "Button_click"
	local Button_click = SoraDGetChildByFullPath(effect, cc.p(pos.x, pos.y))
	Button_click:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended then
			_ENV = nil
			;(nil).defaultSelect = gCommandHallTaskType.REBEL_ARMY_GROUP_TASK
			uiManager:show("CommandHallMain", nil)
		end
	end)
	return effect
end
return effectMainCityView
