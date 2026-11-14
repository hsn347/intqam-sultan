local mainCityDefine = include("mainCityDefine")
local cityNightSkinDef = include("cityNightSkinDef")
local mainCityCastleNightSkinBZT = class("mainCityCastleNightSkinBZT", function(ccsFileName)
	local target = cc.CSLoader:createNode(getCCSPath(ccsFileName))
	target.ccsFileName = ccsFileName
	return target
end)
function mainCityCastleNightSkinBZT:ctor()
	self.Node_night_skin_common = SoraDGetChildByName(self, "Node_night_skin_common")
	self.Node_night_skin = SoraDGetChildByName(self, "Node_night_skin")
	self.Node_action = SoraDGetChildByName(self, "Node_action")
	self.Node_bottom_effect = SoraDGetChildByName(self, "Node_bottom_effect")
	self.Node_dh = SoraDGetChildByName(self, "Node_dh")
	self.Node_top_act = SoraDGetChildByName(self, "Node_top_act")
	self.Node_top_effect = SoraDGetChildByName(self, "Node_top_effect")
	self.Node_animation = SoraDGetChildByName(self, "Node_animation")
	self.Node_extra = SoraDGetChildByName(self, "Node_extra")
end
function mainCityCastleNightSkinBZT:initModel(model, view, buildEntity)
	self.model = model
	self.view = view
	self.buildEntity = buildEntity
	self:initGroup()
	self:checkSpecial()
	local cityBuildViewDef = include("cityBuildViewDef")
	self.castleData = cityBuildViewDef.getCastleConfig(self.model, SoraDGetFactionType())
end
function mainCityCastleNightSkinBZT:closeTimer()
	if self.castleTimer then
		SoraDManagerRemoveTimer(self, self.castleTimer)
		self.castleTimer = nil
	end
end
function mainCityCastleNightSkinBZT:openTimeUp()
	if self.buildEntity and self.buildEntity.buildImg and self.castleData then
		self.Node_night_skin:setPosition(cc.p(0, self.castleData.pos.y + self.buildEntity.buildImg:getPositionY() - 575))
		self.Node_top_effect:setPosition(cc.p(0, self.castleData.pos.y + self.buildEntity.buildImg:getPositionY() - 575))
	end
end
function mainCityCastleNightSkinBZT:setTimerHandle()
	self:closeTimer()
	self.castleTimer = SoradCreateTimer(self, handler(self, self.openTimeUp), true)
	self:openTimeUp()
end
function mainCityCastleNightSkinBZT:initGroup()
	local setArrayGroup = function(targetArray, groupID)
		for k, v in pairs(targetArray) do
			v:setGroupID(groupID)
		end
	end
	if self.Node_night_skin_common and #self.Node_night_skin_common:getChildren() > 0 then
		setArrayGroup(self.Node_night_skin_common:getChildren(), mainCityDefine.CITY_TARGET_GROUPID.GROUP_NIGHT_BUILD)
		for k, v in pairs(self.Node_night_skin_common:getChildren()) do
			local fadeIn = math.random(100, 150) / 100
			local fadeOut = math.random(80, 160) / 100
			local delay = math.random(30, 80) / 100
			_ENV = self.Node_night_skin_common:getChildren()
			self.Node_night_skin_common:getChildren().fadeIn = fadeIn
			self.Node_night_skin_common:getChildren().fadeOut = fadeOut
			self.Node_night_skin_common:getChildren().delay = delay
			self.Node_night_skin_common:getChildren().beginOpacity = 0.8
			self.Node_night_skin_common:getChildren().endOpacity = 1
			SoraDFadeINOUT(v, self.Node_night_skin_common:getChildren())
		end
	end
	if self.Node_night_skin and 0 < #self.Node_night_skin:getChildren() then
		setArrayGroup(self.Node_night_skin:getChildren(), mainCityDefine.CASTLE_TARGET_GROUPID.GROUP_CASTLE_NIGHT_SKIN)
		for k, v in pairs(self.Node_night_skin:getChildren()) do
			local fadeIn = math.random(100, 150) / 100
			local fadeOut = math.random(80, 160) / 100
			local delay = math.random(50, 100) / 100
			_ENV = self.Node_night_skin:getChildren()
			self.Node_night_skin:getChildren().fadeIn = fadeIn
			self.Node_night_skin:getChildren().fadeOut = fadeOut
			self.Node_night_skin:getChildren().delay = delay
			self.Node_night_skin:getChildren().beginOpacity = 0.5
			self.Node_night_skin:getChildren().endOpacity = 1
			SoraDFadeINOUT(v, self.Node_night_skin:getChildren())
		end
	end
	if self.Node_dh and 0 < #self.Node_dh:getChildren() then
		self.Node_dh:setGroupID(mainCityDefine.CASTLE_TARGET_GROUPID.GROUP_CASTLE_NIGHT_DH)
		self.Node_dh:setGroupAuto(true)
	end
	if self.Node_top_act and 0 < #self.Node_top_act:getChildren() then
		setArrayGroup(self.Node_top_act:getChildren(), mainCityDefine.CASTLE_TARGET_GROUPID.GROUP_CASTLE_NIGHT_ACT)
		local skinInfo = cityNightSkinDef.getCastleNightSkinConfig(self.model)
		for k, v in ipairs(self.Node_top_act:getChildren()) do
			local frames = display.newFrames(skinInfo.act[k].format, skinInfo.act[k].from, skinInfo.act[k].to)
			local animation = display.newAnimation(frames, skinInfo.act[k].time / #frames)
			v:playAnimationForever(animation, skinInfo.act[k].delay or 0)
		end
	end
	if self.Node_top_effect and 0 < #self.Node_top_effect:getChildren() then
		self.Node_top_effect:setGroupID(mainCityDefine.CASTLE_TARGET_GROUPID.GROUP_CASTLE_NIGHT_TOP_EFFECT)
		self.Node_top_effect:setGroupAuto(true)
	end
	if self.Node_animation then
		if 0 < #self.Node_animation:getChildren() then
			setArrayGroup(self.Node_animation:getChildren(), mainCityDefine.CASTLE_TARGET_GROUPID.GROUP_CASTLE_NIGHT_ANIMATION)
			local skinInfo = cityNightSkinDef.getCastleNightSkinConfig(self.model)
			for k, v in ipairs(self.Node_animation:getChildren()) do
				_UPVALUE3_ = self.Node_animation:getChildren()
				self.Node_animation:getChildren()[1] = cca.moveBy(skinInfo.animationConfig[k].time, 0, skinInfo.animationConfig[k].offsetH)
				self.Node_animation:getChildren()[2] = cca.moveBy(skinInfo.animationConfig[k].time, 0, -skinInfo.animationConfig[k].offsetH)
				self.Node_animation:getChildren()[3] = cca.moveBy(skinInfo.animationConfig[k].time, 0, -skinInfo.animationConfig[k].offsetH)
				self.Node_animation:getChildren()[4] = cca.moveBy(skinInfo.animationConfig[k].time, 0, skinInfo.animationConfig[k].offsetH)
				self.Node_animation:getChildren()[5] = cca.moveBy(skinInfo.animationConfig[k].time, 0, skinInfo.animationConfig[k].offsetH)
				self.Node_animation:getChildren()[6] = cca.moveBy(skinInfo.animationConfig[k].time, 0, skinInfo.animationConfig[k].offsetH)
				self.Node_animation:getChildren()[7] = cca.moveBy(skinInfo.animationConfig[k].time, 0, skinInfo.animationConfig[k].offsetH)
				local seq = cca.seq(self.Node_animation:getChildren())
				v:runAction(cc.RepeatForever:create(seq))
			end
		else
			self.Node_animation:setGroupID(mainCityDefine.CASTLE_TARGET_GROUPID.GROUP_CASTLE_NIGHT_ANIMATION)
			self.Node_animation:setGroupAuto(true)
		end
	end
	if self.Node_extra and 0 < #self.Node_extra:getChildren() then
		setArrayGroup(self.Node_extra:getChildren(), mainCityDefine.CASTLE_TARGET_GROUPID.GROUP_CASTLE_NIGHT_EXTRA)
	end
end
function mainCityCastleNightSkinBZT:checkSpecial()
	if self.model == BUILD_CASTLE_MODEL.FORT then
		_ENV, _ENV = BUILD_CASTLE_MODEL.FORT, self.model
		_ENV, BUILD_CASTLE_MODEL.FORT.plist = nil, "et_castle_fort_01.plist"
		;(nil).x = -10
		_ENV, _ENV, self.model[1], BUILD_CASTLE_MODEL.FORT.pos, (nil).y = nil, BUILD_CASTLE_MODEL.FORT, BUILD_CASTLE_MODEL.FORT, nil, 4
		local param1 = self.model
		_ENV, (nil).plist = nil, "et_castle_fort_01.plist"
		;(nil).x = -5
		BUILD_CASTLE_MODEL.FORT[1], (nil).pos, (nil).y = nil, nil, 3
		local param2 = BUILD_CASTLE_MODEL.FORT
		local et_node_1 = SoraDCreateEffectNode(param1)
		local et_node_2 = SoraDCreateEffectNode(param2)
		local et_ellipse_1 = SoraDCreateEllipseRunNode(et_node_1, 50, 20)
		et_ellipse_1:setRotation(-15)
		et_ellipse_1:setPosition(cc.p(-60, 235))
		et_ellipse_1:addTo(self.Node_top_effect)
		local et_ellipse_2 = SoraDCreateEllipseRunNode(et_node_2, 50, 20, true, 0.8)
		et_ellipse_2:setRotation(40)
		et_ellipse_2:setPosition(cc.p(-60, 235))
		et_ellipse_2:addTo(self.Node_top_effect)
	end
	if self.model == BUILD_CASTLE_MODEL.SECOND then
		local second = display.newSprite("#dh_second_castle_world.png")
		second:setPosition(cc.p(105, -50))
		second:addTo(self.Node_animation)
		_ENV, _ENV = second, second.addTo
		_ENV, second.plist = self.Node_animation, "et_zhaishengjiecb_02.plist"
		self.Node_animation.x = 20
		_ENV, second.pos, self.Node_animation.y = self.Node_animation, self.Node_animation, 8
		self.Node_animation.x = 0.731
		second.addTo[1], second.scale, self.Node_animation.y = second, self.Node_animation, 1.269
		local param = second.addTo
		local et_node = SoraDCreateEffectNode(param)
		et_node:addTo(second)
		_UPVALUE3_ = et_node
		et_node[1] = cca.moveBy(0.03333333333333333, 0, 0.1)
		et_node[2] = cca.moveBy(1.4666666666666666, 0, 8.9)
		et_node[3] = cca.moveBy(1.4666666666666666, 0, -8.9)
		et_node[4] = cca.moveBy(0.03333333333333333, 0, -0.1)
		et_node[5] = cca.moveBy(0.03333333333333333, 0, -0.1)
		et_node[6] = cca.moveBy(0.03333333333333333, 0, -0.1)
		et_node[7] = cca.moveBy(0.03333333333333333, 0, -0.1)
		local seq = cca.seq(et_node)
		second:runAction(cc.RepeatForever:create(seq))
	end
	if self.model == BUILD_CASTLE_MODEL.NEWYEAR then
		local fireWork = SoraDCreatAnimation("animationFireWork")
		fireWork:setPosition(cc.p(-200, -750))
		fireWork:setScale(1.2)
		fireWork:addTo(self.Node_top_effect)
	end
	if self.model == BUILD_CASTLE_MODEL.PANTHER then
		local Node_fire_1 = SoraDGetChildByName(self.Node_top_effect, "Node_fire_1")
		local Node_fire_2 = SoraDGetChildByName(self.Node_top_effect, "Node_fire_2")
		local Node_fire_3 = SoraDGetChildByName(self.Node_top_effect, "Node_fire_3")
		local fire1 = SoraDGetCommonJetFireNode()
		local fire2 = SoraDGetCommonJetFireNode()
		local fire3 = SoraDGetCommonJetFireNode()
		fire1:addTo(Node_fire_1)
		fire2:addTo(Node_fire_2)
		fire3:addTo(Node_fire_3)
	end
	if self.model == BUILD_CASTLE_MODEL.KINGCOBRA then
		for k, v in ipairs(self.Node_top_effect:getChildren()) do
			local nameTB = SoraDStringSplit(v:getName(), "_")
			if nameTB[1] and nameTB[1] == "Sprite" then
				SoraDMixtureGLONE(v)
			end
		end
		local action = cc.CSLoader:createTimeline(getCCSPath(self.ccsFileName))
		action:gotoFrameAndPlay(0, true)
		self:runAction(action)
	end
	if self.model == BUILD_CASTLE_MODEL.SCORPION then
		local action = cc.CSLoader:createTimeline(getCCSPath(self.ccsFileName))
		action:gotoFrameAndPlay(0, true)
		self:runAction(action)
	end
	if self.model == BUILD_CASTLE_MODEL.FOURTH then
		SoraDSetNodeArrayAdditive(self.Node_extra:getChildren())
		SoraDMixtureGLONE(SoraDGetChildByName(self.Node_dh, "GL_light"))
		local action = cc.CSLoader:createTimeline(getCCSPath(self.ccsFileName))
		action:gotoFrameAndPlay(0, true)
		self:runAction(action)
		self:setTimerHandle()
	end
	if self.model == 55 then
		local action = cc.CSLoader:createTimeline(getCCSPath(self.ccsFileName))
		action:gotoFrameAndPlay(0, true)
		self:runAction(action)
	end
end
return mainCityCastleNightSkinBZT
