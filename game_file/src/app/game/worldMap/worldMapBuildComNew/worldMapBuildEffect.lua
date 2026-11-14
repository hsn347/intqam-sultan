local gametop = gModuleMgr.getObject("gametop")
local instanceCacheMgr = include("instanceCacheMgr")
local castleSkinConfigRead = include("castleSkinConfigRead")
local cityltCtrl = include("cityltCtrl")
local worldMapEffect = include("worldMapEffect")
local devicePerformanceUtil = require("app.devicePerformanceUtil")
local worldMapBuildComNew = include("worldMapBuildComNew")
local worldMapBuildEffect = class("worldMapBuildEffect", worldMapBuildComNew)
local POINT_ZERO = cc.p(0, 0)
local IMG_PROTECT_SCALE_DEF = 0.75
local IMG_PROTECT_SCALE_WAR = 0.95
local IMG_PROTECT_SCALE_WAR_10 = 1.0
local IMG_PROTECT_SCALE_SKIN = 0.9
local IMG_OFFSET_DEF = cc.p(0, 70)
local IMG_OFFSET_WAR = cc.p(-25, 110)
local IMG_OFFSET_WAR_10 = cc.p(0, 70)
local IMG_OFFSET_SKIN = cc.p(-30, 70)
local GROU_ID = worldMapDefine.GROU_ID
local WAR_LV_BEGIN_TYPE = instanceCacheMgr.BEGIN_TYPE.WAR_LV_BEGIN_TYPE
function worldMapBuildEffect:ctor(...)
	worldMapBuildEffect.super.ctor(self, ...)
end
function worldMapBuildEffect:_initData(...)
	self.playerID = 0
	self.cityLevel = 1
	self.hideBattleLev = false
	self.isCityBgSkin = 0
	self.starLv = 0
end
function worldMapBuildEffect:_initUI()
	self.cityImage = display.newSprite("#Castle_lv1_base.png")
	self.target_:addChild(self.cityImage, -1)
	self.citySkin1Image = display.newSprite("#Castle_ramadan.png")
	self.citySkin1Image:setVisible(false)
	self.target_:addChild(self.citySkin1Image, -1)
	self.warLVnode = display.newNode()
	self.target_:addChild(self.warLVnode)
	self.node_warLvNode = nil
	self.image_level = self.target_.image_level
	self.text_Level = self.target_.text_Level
	self.image_name_bg = self.target_.image_name_bg
end
function worldMapBuildEffect:addCacheBefore(...)
	self:clearCastleSkinToCache()
	self.cityImage:setPosition(POINT_ZERO)
	self.cityImage:removeAllChildren()
	self.citySkin1Image:removeAllChildren()
	self:removeSkinEffect()
	self:removeWarLvEffect()
	self:removeCastleEffect(true)
	self:removeCastleFireWorkEffect()
	self:removeEnemyCastleEffect()
	self:removeBuildStarEffect()
end
function worldMapBuildEffect:setBatchNodeGroupID(groupID)
	self.cityImage:setGroupID(groupID)
	self.cityImage:setGroupAuto(true)
end
local tableCastleTable = worldMapDefine.tableCastleTable
function worldMapBuildEffect:setSkinGroupID(model)
	local cityBuildCastleSkinConfig = include("cityBuildCastleSkinConfig")
	local skinType = cityBuildCastleSkinConfig.getOwnTexture(model)
	local groupID = tableCastleTable[skinType]
	if groupID then
		self.citySkin1Image:setGroupID(groupID)
		self.citySkin1Image_groupID = groupID
	end
end
function worldMapBuildEffect:updateData(data)
	self.data = data
	if data.cityLevel then
		self.cityLevel = data.cityLevel
	end
	if data.playerID then
		self.playerID = data.playerID
	end
	if data.factionType then
		self.factionType = data.factionType
	end
	if data.hideBattleLev ~= nil then
		self.hideBattleLev = data.hideBattleLev
	end
	if data.castleSkin then
		self.isCityBgSkin = data.castleSkin
		self:updateBuildingImg()
	end
end
function worldMapBuildEffect:setCitySkinName(node, nodeName)
	node:setCacheName(nodeName)
	if not self.castleSkinNods then
		self.castleSkinNods, _UPVALUE0_ = self.castleSkinNods, self.castleSkinNods
	end
	self.castleSkinNods[nodeName] = node
end
local addToInstanceCache = function(node, nodeName)
	if not node or tolua.isnull(node) then
		return
	end
	instanceCacheMgr.addNormalNodeByType(node, nodeName)
	node:removeFromParent(false)
end
function worldMapBuildEffect:addFromInstanceCache(name, order)
	local child = instanceCacheMgr.getInstance(name)
	if child ~= nil then
		self:setCitySkinName(child, name)
		self.target_:addChild(child, order == nil and 2 or order)
		child:release()
		child:setVisible(true)
	end
	return child
end
function worldMapBuildEffect:clearCastleSkinToCache()
	if self.castleSkinNods then
		for name, node in pairs(self.castleSkinNods) do
			addToInstanceCache(node, name)
			self.castleSkinNods[name] = nil
		end
	end
end
function worldMapBuildEffect:updateBuildingImg()
	self.cityImage:removeAllChildren()
	self.citySkin1Image:removeAllChildren()
	self:removeSkinEffect()
	self:removeWarLvEffect()
	if worldMapDefine.isNebulaAllStarKingdomID(self.kingdomID) then
		self.hideBattleLev = true
		self.cityImage:setSpriteFrame("allstar_player_city.png")
		self.cityImage:setPosition(cc.p(0, 70))
		self.cityImage:setScale(0.9)
		if not self.nebulaAllStarEffect then
			local nebulaAllStarUtil = include("nebulaAllStarUtil")
			_ENV = 0.9
			;(0.9).mapType = gMapObjTypeDef.mapObjTypePlayer
			;(0.9).parent = self.target_
			;(0.9).pos = cc.p(0, 70)
			;(0.9).scale = 0.9
			;(0.9).Sprite_build = self.cityImage
			;(0.9).groupID = GROU_ID.castleBatchNode
			local spriteEffect = nebulaAllStarUtil.getBuildSpriteEffect(0.9)
			self.nebulaAllStarEffect = spriteEffect
		end
		return
	end
	local textShowLV
	self.isShowWarLv, textShowLV = SoraDGetBuildWarLv(self.cityLevel)
	if self.isShowWarLv then
		self:warLvEffect(textShowLV)
	end
	local isWarLV5 = self.isShowWarLv and 5 <= textShowLV
	self.image_name_bg:setVisible(isWarLV5)
	self:clearCastleSkinToCache()
	if self.isCityBgSkin ~= 0 and not self.node_snowMan and self:isShowCastleSkin() then
		local castleSkinRead = include("castleSkinRead")
		local skinImageName = castleSkinRead.getMapImage(self.isCityBgSkin)
		local castleModel = castleSkinRead.getCastleType(self.isCityBgSkin)
		if skinImageName and 0 < string.len(skinImageName) then
			if castleModel == BUILD_CASTLE_MODEL.ELEVEN_YEAR and not SoraDFIsRA() then
				skinImageName = "Map_castle_WaterPark_ros.png"
			end
			self.cityImage:setVisible(false)
			self.citySkin1Image:setVisible(true)
			self.citySkin1Image:setSpriteFrame(skinImageName)
			self.target_:setSkinGroupID(castleModel)
			self.curCityImage = self.citySkin1Image
			local skinOffset = castleSkinConfigRead.getSkinOffset(castleModel)
			if skinOffset then
				self.curCityImage:setPosition(skinOffset)
			end
			self.curCityImage:setScale(1.0)
			self.curCityImage:stopAllActions()
			if castleModel == BUILD_CASTLE_MODEL.KINGCOBRA then
				self.curCityImage:setScale(0.9)
			end
			self.imgScale = IMG_PROTECT_SCALE_SKIN
			self.imgOffset = IMG_OFFSET_SKIN
			self:addSkinEffect(castleModel)
			if self.isShowWarLv then
				self:setSkinConfig(castleModel, textShowLV)
			end
			_ENV = self.setSkinConfig
			self.setSkinConfig[BUILD_CASTLE_MODEL.THUNDERCLOUD] = function()
				self.citySkin1Image:setVisible(false)
				local tmpNode = self:addFromInstanceCache("Node_thunder_1")
				local Node_thunder_1, action = SoraDCreatAnimation("Node_thunder_1", tmpNode, false)
				if tmpNode == nil then
					self:setCitySkinName(Node_thunder_1, "Node_thunder_1")
					Node_thunder_1:addTo(self.target_, 2)
				end
				Node_thunder_1:setPosition(0, 100)
				action:setFrameEventCallFunc(function(frameEventName)
					local frameEvent = frameEventName:getEvent()
					if frameEvent and frameEvent == "toSecond" then
						local tmpNode = self:addFromInstanceCache("Node_thunder_2")
						local Node_thunder_2 = SoraDCreatAnimation("Node_thunder_2", tmpNode)
						if tmpNode == nil then
							self:setCitySkinName(Node_thunder_2, "Node_thunder_2")
							Node_thunder_2:addTo(self.target_, 2)
						end
						Node_thunder_2:setPosition(0, 100)
					end
				end)
			end
			self.setSkinConfig[BUILD_CASTLE_MODEL.SEVENTH] = function()
				self.citySkin1Image:setVisible(false)
				local tmpNode = self:addFromInstanceCache("Node_starfall_1", -2)
				local Node_starfall_1, action = SoraDCreatAnimation("Node_starfall_1", tmpNode, false)
				if tmpNode == nil then
					self:setCitySkinName(Node_starfall_1, "Node_starfall_1")
					Node_starfall_1:addTo(self.target_, -2)
				end
				Node_starfall_1:setPosition(0, 50)
				action:setFrameEventCallFunc(function(frameEventName)
					local frameEvent = frameEventName:getEvent()
					if frameEvent and frameEvent == "toSecond" then
						local tmpNode = self:addFromInstanceCache("Node_starfall_2", -1)
						local Node_starfall_2, action2 = SoraDCreatAnimation("Node_starfall_2", tmpNode, false)
						if tmpNode == nil then
							self:setCitySkinName(Node_starfall_2, "Node_starfall_2")
							Node_starfall_2:addTo(self.target_, -1)
						end
						if self.citySkin1Image_groupID then
							SoraDGetChildByName(Node_starfall_2, "chengbaozhuangban_01"):setGroupID(self.citySkin1Image_groupID)
						end
						Node_starfall_2:setPosition(0, 80)
						action2:setFrameEventCallFunc(function(frameEventName)
							local frameEvent = frameEventName:getEvent()
							if frameEvent and frameEvent == "tothree" then
								local tmpNode = self:addFromInstanceCache("Node_starfall_3", -1)
								local Node_starfall_3, action3 = SoraDCreatAnimation("Node_starfall_3", tmpNode)
								if tmpNode == nil then
									self:setCitySkinName(Node_starfall_3, "Node_starfall_3")
									Node_starfall_3:addTo(self.target_, -1)
								end
								Node_starfall_3:setPosition(0, 80)
								if self.citySkin1Image_groupID then
									SoraDGetChildByName(Node_starfall_3, "chengbaozhuangban_02"):setGroupID(self.citySkin1Image_groupID)
								end
								if not tolua.isnull(Node_starfall_1) then
									Node_starfall_1:setVisible(false)
								end
								if not tolua.isnull(Node_starfall_2) then
									Node_starfall_2:setVisible(false)
								end
							end
						end)
					end
				end)
			end
			self.setSkinConfig[BUILD_CASTLE_MODEL.DEGULA] = function()
				local dglNode = self:addFromInstanceCache("dglNode")
				if dglNode == nil then
					dglNode = SoraDCreatAnimation("degulacbwai")
					self:setCitySkinName(dglNode, "dglNode")
					dglNode:addTo(self.target_, 2)
				else
					SoraDCreatAnimation("degulacbwai", dglNode)
				end
				dglNode:setPosition(40, 40)
			end
			self.setSkinConfig[BUILD_CASTLE_MODEL.KOH2021RAMADAN] = function()
				local xlcbfdNode = self:addFromInstanceCache("xlcbfdNode")
				if xlcbfdNode == nil then
					xlcbfdNode = SoraDCreatAnimation("animationXLCBFD")
					self:setCitySkinName(xlcbfdNode, "xlcbfdNode")
					xlcbfdNode:addTo(self.target_, 1)
				else
					SoraDCreatAnimation("animationXLCBFD", xlcbfdNode)
				end
				xlcbfdNode:setPosition(-70, -20)
			end
			self.setSkinConfig[BUILD_CASTLE_MODEL.STARKING] = function()
				local xczwcbNode = self:addFromInstanceCache("xczwcbNode")
				if xczwcbNode == nil then
					xczwcbNode = SoraDCreatAnimation("animationXCZWCB")
					self:setCitySkinName(xczwcbNode, "xczwcbNode")
					xczwcbNode:addTo(self.target_, 1)
				else
					SoraDCreatAnimation("animationXCZWCB", xczwcbNode)
				end
				xczwcbNode:setPosition(-65, -40)
			end
			local self.setSkinConfig[BUILD_CASTLE_MODEL.HALLOWEEN2018], castleFuncMap = function()
				local sprite = self:addFromInstanceCache("citySkin1Image_down")
				if sprite == nil then
					sprite = display.newSprite("#Map_castle_Hallowmas2018_01.png")
					self.target_:addChild(sprite, -2)
					self:setCitySkinName(sprite, "citySkin1Image_down")
				end
				sprite:setPosition(cc.p(-60, 40))
				_UPVALUE5_ = cc.p(-60, 40)
				cc.p(-60, 40)[1] = cca.moveBy(0.16666666666666666, 0, -1)
				cc.p(-60, 40)[2] = cca.moveBy(1.3333333333333333, 0, -9.0)
				cc.p(-60, 40)[3] = cca.moveBy(0.16666666666666666, 0, -1)
				cc.p(-60, 40)[4] = cca.moveBy(0.16666666666666666, 0, 1)
				cc.p(-60, 40)[5] = cca.moveBy(1.3333333333333333, 0, 9.0)
				cc.p(-60, 40)[6] = cca.moveBy(0.16666666666666666, 0, 1)
				cc.p(-60, 40)[7] = cca.moveBy(0.16666666666666666, 0, 1)
				cc.p(-60, 40)[8] = cca.moveBy(0.16666666666666666, 0, 1)
				cc.p(-60, 40)[9] = cca.moveBy(0.16666666666666666, 0, 1)
				sprite:runAction(cc.RepeatForever:create(cca.seq(cc.p(-60, 40))))
				if self.citySkin1Image_groupID then
					sprite:setGroupID(self.citySkin1Image_groupID)
				end
			end, self.setSkinConfig
			if worldMapDefine.getCastleFrame(castleModel, self, self.target_, self.citySkin1Image) then
			else
				local castleFunc = castleFuncMap[castleModel]
				if castleFunc then
					castleFunc()
				end
			end
			return
		end
	elseif self.isShowWarLv and (textShowLV == 5 or textShowLV == 10) then
		self.imgScale = IMG_PROTECT_SCALE_WAR_10
		self.imgOffset = IMG_OFFSET_WAR_10
	else
		self.imgScale = self.isShowWarLv and IMG_PROTECT_SCALE_WAR or IMG_PROTECT_SCALE_DEF
		self.imgOffset = self.isShowWarLv and IMG_OFFSET_WAR or IMG_OFFSET_DEF
	end
	if not self.node_snowMan then
		self.cityImage:setVisible(true)
		self.citySkin1Image:setVisible(false)
		worldMapDefine.createCityImageWithLevel(self.cityLevel, self.factionType, self.cityImage)
	end
end
function worldMapBuildEffect:addSkinEffect(castleModel)
	if not self.skinBgEffectNode then
		local et_node = worldMapDefine.getCastleSkinEffect(castleModel)
		if et_node then
			et_node:addTo(self.target_, 1)
			self.skinBgEffectNode = et_node
		end
	end
end
function worldMapBuildEffect:removeSkinEffect()
	if self.skinBgEffectNode then
		self.skinBgEffectNode:removeFromParent()
		self.skinBgEffectNode = nil
	end
	if self.nebulaAllStarEffect then
		self.nebulaAllStarEffect:removeFromParent()
		self.nebulaAllStarEffect = nil
	end
end
function worldMapBuildEffect:setSkinConfig(castleModel, warLv)
	local config = castleSkinConfigRead.getSkinWarLvConfig(castleModel, warLv)
	if config then
		self.warLVnode:setScale(config.scale)
		self.warLVnode:setPosition(config.offset)
	else
		self.warLVnode:setScale(1)
		local data = worldMapDefine.getWarLevelData(warLv)
		local offset = data.offset or cc.p(0, 0)
		self.warLVnode:setPosition(offset)
		if self.curCityImage then
			self.curCityImage:setPosition(cc.p(0, 0))
		end
	end
end
function worldMapBuildEffect:warLvEffect2(...)
	self:warLvEffect(self._warLv)
end
local createLvEffectNode = function(warLv, fileName, isWarLod, showMoon)
	local data = worldMapDefine.getWarLevelData(warLv)
	if not data then
		return
	end
	local node_warLvNode = display.newNode()
	local node_bottom = display.newNode()
	node_bottom:addTo(node_warLvNode, 1)
	local bottom = data.bottom
	local bottomImg = bottom.img
	for _, v in pairs(bottomImg.bg) do
		local bg = display.newSpriteNoChild("#" .. v.png)
		bg:setPosition(v.pos)
		bg:setGroupID(GROU_ID.group_warLv_base)
		bg:addTo(node_bottom, 1)
	end
	for _, v in pairs(bottomImg.dh) do
		local dh = display.newSpriteNoChild("#" .. v.png)
		dh:setPosition(v.pos)
		dh:setGroupID(GROU_ID.group_warLv_base)
		if isWarLod then
			_ENV = GROU_ID.group_warLv_base
			GROU_ID.group_warLv_base.beginOpacity = 0.3
			GROU_ID.group_warLv_base.endOpacity = 0.7
			SoraDFadeINOUT(dh, GROU_ID.group_warLv_base)
		end
		dh:addTo(node_bottom, 2)
	end
	if bottom.et and isWarLod then
		local et_bottom = SoraDCreateEffectNode(bottom.et)
		et_bottom:setGroupID(GROU_ID.group_warLv_base_particle)
		et_bottom:setGroupAuto(true)
		et_bottom:addTo(node_bottom, 3)
	end
	if bottom.scale then
		node_bottom:setScale(bottom.scale)
	end
	if bottom.offset then
		node_bottom:setPosition(bottom.offset)
	end
	local top = data.top
	local node_top = display.newNode()
	node_top:addTo(node_warLvNode, 2)
	local topImg = top.img
	for _, v in pairs(topImg.bg) do
		local bg = display.newSpriteNoChild("#" .. v.png)
		bg:setGroupID(GROU_ID.group_warLv_top)
		bg:setPosition(v.pos)
		bg:addTo(node_top, 1)
	end
	for _, v in pairs(topImg.dh) do
		local dh = display.newSpriteNoChild("#" .. v.png)
		dh:setPosition(v.pos)
		dh:setGroupID(GROU_ID.group_warLv_top)
		if isWarLod then
			_ENV = GROU_ID.group_warLv_top
			GROU_ID.group_warLv_top.beginOpacity = 0.3
			GROU_ID.group_warLv_top.endOpacity = 0.7
			SoraDFadeINOUT(dh, GROU_ID.group_warLv_top)
		end
		dh:addTo(node_top, 2)
	end
	if top.et and isWarLod then
		local et_top = SoraDCreateEffectNode(top.et)
		et_top:setGroupID(GROU_ID.group_warLv_top_particle)
		et_top:setGroupAuto(true)
		et_top:addTo(node_top, 3)
	end
	if top.scale then
		node_top:setScale(top.scale)
	end
	if top.offset then
		node_top:setPosition(top.offset)
	end
	if showMoon then
		local top_sword = data.top_sword
		local node_top_sword = display.newNode()
		node_top_sword:addTo(node_top, 2)
		node_top_sword:setName("node_top_sword")
		if top_sword then
			local topImg = top_sword.img
			for _, v in pairs(topImg.bg) do
				local bg = display.newSpriteNoChild("#" .. v.png)
				bg:setGroupID(GROU_ID.group_warLv_top)
				bg:setPosition(v.pos)
				bg:addTo(node_top_sword, 1)
			end
			for _, v in pairs(topImg.dh) do
				local dh = display.newSpriteNoChild("#" .. v.png)
				dh:setPosition(v.pos)
				dh:setGroupID(GROU_ID.group_warLv_top)
				if isWarLod then
					_ENV = GROU_ID.group_warLv_top
					GROU_ID.group_warLv_top.beginOpacity = 0.3
					GROU_ID.group_warLv_top.endOpacity = 0.7
					SoraDFadeINOUT(dh, GROU_ID.group_warLv_top)
				end
				dh:addTo(node_top_sword, 2)
			end
			if top_sword.et and isWarLod then
				local et_top = SoraDCreateEffectNode(top_sword.et)
				et_top:setGroupID(GROU_ID.group_warLv_top_particle)
				et_top:setGroupAuto(true)
				et_top:addTo(node_top_sword, 3)
			end
		end
	end
	if isWarLod then
		GROU_ID = display.newNode()
		display.newNode()[1] = cca.moveBy(1.5, 0, 5)
		display.newNode()[2] = cca.moveBy(1.5, 0, -5)
		display.newNode()[3] = cca.moveBy(1.5, 0, -5)
		display.newNode()[4] = cca.moveBy(1.5, 0, -5)
		display.newNode()[5] = cca.moveBy(1.5, 0, -5)
		display.newNode()[6] = cca.moveBy(1.5, 0, -5)
		display.newNode()[7] = cca.moveBy(1.5, 0, -5)
		display.newNode()[8] = cca.moveBy(1.5, 0, -5)
		display.newNode()[9] = cca.moveBy(1.5, 0, -5)
		display.newNode()[10] = cca.moveBy(1.5, 0, -5)
		display.newNode()[11] = cca.moveBy(1.5, 0, -5)
		local seq = cca.seq((display.newNode()))
		node_top:runAction(cc.RepeatForever:create(seq))
	end
	if showMoon and data.moon then
		local node_moon = display.newNode()
		node_moon:addTo(node_warLvNode, 3)
		node_moon:setName("node_moon")
		for _, v in pairs(data.moon.img.bg) do
			local bg = display.newSpriteNoChild("#" .. v.png)
			bg:setGroupID(GROU_ID.group_warLv_top)
			bg:setPosition(v.pos)
			bg:addTo(node_moon, 1)
		end
		for _, v in pairs(data.moon.img.dh) do
			local dh = display.newSpriteNoChild("#" .. v.png)
			dh:setPosition(v.pos)
			dh:setGroupID(GROU_ID.group_warLv_top)
			if isWarLod then
				_ENV = GROU_ID.group_warLv_top
				GROU_ID.group_warLv_top.beginOpacity = 0.3
				GROU_ID.group_warLv_top.endOpacity = 0.7
				SoraDFadeINOUT(dh, GROU_ID.group_warLv_top)
			end
			dh:addTo(node_moon, 2)
		end
		if data.moon.et and isWarLod then
			local et_top = SoraDCreateEffectNode(data.moon.et)
			et_top:setGroupID(GROU_ID.group_warLv_top_particle)
			et_top:setGroupAuto(true)
			et_top:addTo(node_moon, 3)
		end
		if isWarLod and warLv == CASTLE_NEX_MAX_WARLV then
			_UPVALUE5_ = et_top.addTo
			et_top.addTo[1] = cca.moveBy(0.5833333333333334, 0, -8)
			et_top.addTo[2] = cca.moveBy(0.16666666666666666, 0, 4)
			et_top.addTo[3] = cca.moveBy(0.43333333333333335, 0, 8)
			et_top.addTo[4] = cca.moveBy(0.15, 0, -2)
			et_top.addTo[5] = cca.moveBy(0.5, 0, -8)
			et_top.addTo[6] = cca.moveBy(0.8333333333333334, 0, 6)
			et_top.addTo[7] = cca.moveBy(0.8333333333333334, 0, 6)
			et_top.addTo[8] = cca.moveBy(0.8333333333333334, 0, 6)
			et_top.addTo[9] = cca.moveBy(0.8333333333333334, 0, 6)
			et_top.addTo[10] = cca.moveBy(0.8333333333333334, 0, 6)
			local act = cca.seq(et_top.addTo)
			node_moon:runAction(cc.RepeatForever:create(act))
		end
		if data.moon.scale then
			node_moon:setScale(data.moon.scale)
		end
		if data.moon.offset then
			node_moon:setPosition(data.moon.offset)
		end
	end
	node_warLvNode:setCacheName(fileName)
	return node_warLvNode
end
function worldMapBuildEffect:warLvEffect(warLv)
	self._warLv = warLv
	if warLv == 0 or not self:isShowWarLvEffect() then
		self:removeWarLvEffect()
		return
	end
	local data = worldMapDefine.getWarLevelData(warLv)
	if not data then
		return
	end
	if data.offset then
		self.warLVnode:setPosition(data.offset)
	end
	local showMoon = true
	local starLv = self._starLv
	if starLv and 0 < starLv then
		local level = cityltCtrl.getBuildStarColor(starLv)
		if 1 < level then
			showMoon = false
		end
	end
	local isWarLod = self:isWarLvLod()
	local lod = isWarLod and 1 or 0
	local moon = showMoon and 1 or 0
	local fileName = string.format("WarLv_%d_%d_%d", warLv, lod, moon)
	local node_warLvNode = instanceCacheMgr.getInstance(fileName)
	if node_warLvNode then
		self.node_warLvNode = node_warLvNode
		node_warLvNode:addTo(self.warLVnode)
		node_warLvNode:release()
	else
		node_warLvNode = createLvEffectNode(warLv, fileName, isWarLod, showMoon)
		if node_warLvNode then
			self.node_warLvNode = node_warLvNode
			node_warLvNode:addTo(self.warLVnode)
		else
			print("createLvEffectNode error warLv", warLv)
		end
	end
end
function worldMapBuildEffect:removeWarLvEffect()
	if self.node_warLvNode then
		instanceCacheMgr.addNormalNodeByType(self.node_warLvNode, self.node_warLvNode:getCacheName())
		self.node_warLvNode:removeFromParent(false)
		self.node_warLvNode = nil
	end
	self.warLVnode:setPosition(POINT_ZERO)
end
function worldMapBuildEffect:castleLoveEffect()
	if self.et_node_love then
		return
	end
	_ENV, _ENV = nil, self.et_node_love
	_ENV, (nil).plist = nil, "et_castlelove_02.plist"
	;(nil).x = 7.32
	_ENV, self.et_node_love[1], (nil).pos, (nil).y = nil, nil, nil, 27.46
	_ENV, (nil).plist = nil, "et_castlelove_03.plist"
	;(nil).x = 18.96
	_ENV, self.et_node_love[2], (nil).pos, (nil).y = nil, nil, nil, -59.42
	_ENV, (nil).plist = nil, "et_castlelove_04.plist"
	;(nil).x = 15.15
	;(nil).pos, (nil).y = nil, 10.27
	_ENV, self.et_node_love[3], (nil).scale = nil, nil, 2
	_ENV, (nil).plist = nil, "et_castlelove_01.plist"
	;(nil).x = 9.99
	_ENV, (nil).pos, (nil).y = nil, nil, 53.25
	;(nil).x = 2.5
	self.et_node_love[4], (nil).scale, (nil).y = nil, nil, 4.6
	local param = self.et_node_love
	self.et_node_love = SoraDCreateEffectNode(param)
	self.et_node_love:addTo(self.target_)
end
function worldMapBuildEffect:removeCastleEffect(isRemove)
	if self.et_node_love then
		self.et_node_love:removeFromParent()
		self.et_node_love = nil
	end
	if self.node_snowMan then
		self.node_snowMan:removeFromParent()
		self.node_snowMan = nil
		if not isRemove then
			self:updateBuildingImg()
			self:updateOfficeIcon()
			self:updatePrisoneIn()
		end
	end
	if self.et_node_rainbow then
		self.et_node_rainbow:stopAllActions()
		self.et_node_rainbow:removeFromParent()
		self.et_node_rainbow = nil
	end
	if self.et_node_rainbow_1 then
		self.et_node_rainbow_1:removeFromParent()
		self.et_node_rainbow_1 = nil
	end
	if self.et_node_rainbow_2 then
		self.et_node_rainbow_2:removeFromParent()
		self.et_node_rainbow_2 = nil
	end
	if self.et_node_shining then
		self.et_node_shining:removeFromParent()
		self.et_node_shining = nil
	end
end
function worldMapBuildEffect:castleSnowEffect()
	if self.node_snowEffect then
		return
	end
	self.node_snowEffect = display.newNode()
	self.node_snowEffect:setPosition(-30, 70)
	self.node_snowEffect:addTo(self.target_, 1)
	local snowEffect = SoraDCreatAnimation("animationSnowEffect")
	snowEffect:addTo(self.node_snowEffect)
end
function worldMapBuildEffect:castleSnowIceEffect(isSelf)
	if self.node_snowMan then
		return
	end
	self.node_snowMan = display.newNode()
	self.node_snowMan:setPosition(0, 0)
	self.node_snowMan:addTo(self.target_, 1)
	if isSelf and self.data.castleAppearanceEndTime then
		local leftTime = math.max(0, self.data.castleAppearanceEndTime - serviceFunctions.systemTime())
		local timeNode = worldMapEffect.createFireTimeNode()
		timeNode:setPosition(cc.p(0, -120))
		timeNode:addTo(self.node_snowMan, 5)
		timeNode.init(leftTime)
	end
	self.cityImage:setVisible(false)
	self.citySkin1Image:setVisible(false)
	self:updateOfficeIcon()
	self:updatePrisoneIn()
	local xueren = display.newSprite("#xuerenzhuangban.png")
	xueren:setPosition(cc.p(-45, 60))
	xueren:addTo(self.node_snowMan, 0)
	local yun = display.newSprite("#yunduozhuangban_001.png")
	yun:setPosition(cc.p(-15, 100))
	yun:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_COLOR)
	yun:addTo(self.node_snowMan, 1)
	local frames = display.newFrames("yunduozhuangban_%.3d.png", 1, 20)
	local animation = display.newAnimation(frames, 2.0 / #frames)
	yun:playAnimationForever(animation)
	_ENV, _ENV = yun, yun.playAnimationForever
	yun.plist = "et_xuerenddj_01.plist"
	yun.pos = cc.p(119.09, 53.82)
	_ENV, yun.playAnimationForever[1], yun.scale = yun, yun, 1.35
	yun.plist = "et_xuerenddj_01.plist"
	yun.pos = cc.p(-37.39, 57.54)
	_ENV, yun.playAnimationForever[2], yun.scale = yun, yun, 1.65
	yun.plist = "et_xuerenddj_02.plist"
	_ENV, yun.playAnimationForever[3], yun.pos = yun, yun, cc.p(-70.93, -33.32)
	yun.plist = "et_xuerenddj_02.plist"
	_ENV, yun.playAnimationForever[4], yun.pos = yun, yun, cc.p(-14.11, -89.37)
	yun.plist = "et_xuerenddj_02.plist"
	_ENV, yun.playAnimationForever[5], yun.pos = yun, yun, cc.p(152.46, -19.55)
	yun.plist = "et_xuerenddj_03.plist"
	yun.pos = cc.p(41.9, -46.1)
	_ENV, yun.playAnimationForever[6], yun.scale = yun, yun, 1.4237
	yun.plist = "et_xuerenddj_04.plist"
	yun.pos = cc.p(32.99, -36.95)
	_ENV, yun.playAnimationForever[7], yun.scale = yun, yun, 1.1245
	yun.plist = "et_xuerenddj_05.plist"
	yun.pos = cc.p(117.46, 54.45)
	_ENV, yun.playAnimationForever[8], yun.rotate = yun, yun, 179.07
	yun.plist = "et_xuerenddj_05.plist"
	yun.pos = cc.p(-31.71, 53.92)
	yun.scale = 0.8419
	yun.playAnimationForever[9], yun.rotate = yun, 179.07
	local param = yun.playAnimationForever
	local et_node = SoraDCreateEffectNode(param)
	et_node:setPosition(-45, 45)
	et_node:addTo(self.node_snowMan, 0)
end
function worldMapBuildEffect:castleShiningEffect()
	if self.et_node_shining then
		return
	end
	self.et_node_shining = display.newNode()
	self.et_node_shining:setPosition(0, 0)
	self.et_node_shining:addTo(self.target_)
	for k, v in pairs(worldMapDefine.castleTwinkleCfg) do
		local effectNode = SoraDCreateShaderEffect(v, self.et_node_shining)
	end
	if SoraDGetFactionType() == FACTION_TYPE.FACTION_BYZANTINE then
		self.et_node_shining:setScale(1.2)
	end
end
function worldMapBuildEffect:castleShining2Effect()
	if self.et_node_shining then
		return
	end
	local effect = SoraDCreatAnimation("Node_bxcqcb_effect")
	effect:addTo(self.target_, 999)
	effect:setPosition(cc.p(-60, 120))
	local hideName = SoraDFIsRA() and "Sprite_text_en" or "Sprite_text_ar"
	SoraDGetChildByName(effect, hideName):setVisible(false)
	self.et_node_shining = effect
end
function worldMapBuildEffect:castleShining3Effect()
	if self.et_node_shining then
		return
	end
	local effect = SoraDCreatAnimation("animationXLCBCWTX")
	effect:setName("xlcbtxNode")
	effect:setPosition(-45, 140)
	effect:addTo(self.target_, 2)
	self.et_node_shining = effect
end
function worldMapBuildEffect:castleShining4Effect()
	if self.et_node_shining then
		return
	end
	local effect = SoraDCreatAnimation("animationBYXLCBYHTX")
	effect:setPosition(-45, 140)
	effect:addTo(self.target_, 2)
	self.et_node_shining = effect
end
function worldMapBuildEffect:castleShining5Effect()
	if self.et_node_shining then
		return
	end
	local effect = SoraDCreatAnimation("animationBXFLCBYHTX")
	effect:setPosition(-70, 120)
	effect:addTo(self.target_, 2)
	self.et_node_shining = effect
end
function worldMapBuildEffect:castleRainbowEffect()
	if self.et_node_rainbow then
		return
	end
	local bPercent = 0
	local ePercent = 78
	local actionTime = 2
	local perFrame = ePercent / (actionTime * 60)
	local isEffectShow = false
	self.et_node_rainbow = display.newNode()
	self.et_node_rainbow:setPosition(cc.p(self.centerPoint.x - 20, self.centerPoint.y + 50))
	self.et_node_rainbow:addTo(self.target_, 9)
	local progress_rainbow = display.newProgressTimer("#icon_rainbow.png", display.PROGRESS_TIMER_RADIAL)
	progress_rainbow:setRotation(-140)
	progress_rainbow:addTo(self.et_node_rainbow, 9)
	progress_rainbow:setPercentage(bPercent)
	local freeEffect = function()
		local beginPos = cc.p(self.centerPoint.x - 161, self.centerPoint.y - 128.5)
		local control_1 = cc.p(self.centerPoint.x - 55.44, self.centerPoint.y + 307.77)
		local control_2 = cc.p(self.centerPoint.x + 281, self.centerPoint.y + 393.5)
		local endPos = cc.p(self.centerPoint.x + 315.6, self.centerPoint.y + 147.8)
		_ENV, _ENV = self.centerPoint.y + 147.8, self.centerPoint.x + 315.6
		;(self.centerPoint.y + 147.8).plist = "et_caihong_01.plist"
		;(self.centerPoint.y + 147.8).pos = beginPos
		;(self.centerPoint.y + 147.8).scale = 2.237
		;(self.centerPoint.y + 147.8).rotate = -18.87
		;(self.centerPoint.x + 315.6)[1], (self.centerPoint.y + 147.8).posType = self.centerPoint.y + 147.8, cc.POSITION_TYPE_FREE
		local param = self.centerPoint.x + 315.6
		local et_rainbow = SoraDCreateEffectNode(param)
		et_rainbow:addTo(self.target_, 10)
		self.et_node_rainbow_2 = et_rainbow
		self = et_rainbow
		_UPVALUE3_ = nil
		;(nil)[1] = control_1
		;(nil)[2] = control_2
		;(nil)[3] = endPos
		et_rainbow[1] = cc.EaseSineIn:create(cc.BezierTo:create(1.6, nil))
		et_rainbow[2] = cca.callFunc(function()
			SoraDStopEffectNode(et_rainbow)
		end)
		et_rainbow[3] = cca.callFunc(function()
			SoraDStopEffectNode(et_rainbow)
		end)
		et_rainbow[4] = cca.callFunc(function()
			SoraDStopEffectNode(et_rainbow)
		end)
		et_rainbow[5] = cca.callFunc(function()
			SoraDStopEffectNode(et_rainbow)
		end)
		et_rainbow[6] = cca.callFunc(function()
			SoraDStopEffectNode(et_rainbow)
		end)
		et_rainbow[7] = cca.callFunc(function()
			SoraDStopEffectNode(et_rainbow)
		end)
		et_rainbow[8] = cca.callFunc(function()
			SoraDStopEffectNode(et_rainbow)
		end)
		et_rainbow[9] = cca.callFunc(function()
			SoraDStopEffectNode(et_rainbow)
		end)
		local seq = cca.seq(et_rainbow)
		et_rainbow:runAction(seq)
	end
	_UPVALUE2_ = bPercent
	_UPVALUE1_ = cc.p(self.centerPoint.x - 20, self.centerPoint.y + 50)
	cc.p(self.centerPoint.x - 20, self.centerPoint.y + 50)[1] = cca.callFunc(function()
		progress_rainbow:stopAllActions()
		progress_rainbow:setPercentage(bPercent)
		progress_rainbow = progress_rainbow
		progress_rainbow[1] = cca.callFunc(function()
			if bPercent <= ePercent then
				progress_rainbow:setPercentage(bPercent)
			else
				progress_rainbow:stopAllActions()
			end
		end)
		progress_rainbow[2] = cca.delay(0.016666666666666666)
		progress_rainbow[3] = cca.delay(0.016666666666666666)
		progress_rainbow[4] = cca.delay(0.016666666666666666)
		local seq = cca.seq(progress_rainbow)
		progress_rainbow:runAction(cc.RepeatForever:create(seq))
	end)
	cc.p(self.centerPoint.x - 20, self.centerPoint.y + 50)[2] = cca.callFunc(freeEffect)
	cc.p(self.centerPoint.x - 20, self.centerPoint.y + 50)[3] = cca.callFunc(freeEffect)
	bPercent[1] = cca.spawn(cc.p(self.centerPoint.x - 20, self.centerPoint.y + 50))
	bPercent[2] = cca.delay(2)
	bPercent[3] = cca.callFunc(function()
		if isEffectShow then
			return
		end
		isEffectShow, isEffectShow = nil, isEffectShow
		;(nil).plist = "et_caihong_02.plist"
		;(nil).rotate = -22.21
		isEffectShow, isEffectShow[1], (nil).pos = nil, nil, cc.p(self.centerPoint.x + 19.28, self.centerPoint.y + 24.46)
		isEffectShow, (nil).plist = cc.p(self.centerPoint.x + 19.28, self.centerPoint.y + 24.46), "et_caihong_03.plist"
		cc.p(self.centerPoint.x + 19.28, self.centerPoint.y + 24.46).x = -0.855
		;(nil).scale, cc.p(self.centerPoint.x + 19.28, self.centerPoint.y + 24.46).y = cc.p(self.centerPoint.x + 19.28, self.centerPoint.y + 24.46), 0.876
		;(nil).rotate = 42.65
		isEffectShow, isEffectShow[2], (nil).pos = nil, nil, cc.p(self.centerPoint.x + 29, self.centerPoint.y + 76.06)
		;(nil).plist = "et_caihong_03.plist"
		;(nil).scale = 2.237
		;(nil).rotate = -18.87
		isEffectShow[3], (nil).pos = nil, cc.p(self.centerPoint.x + 61.85, self.centerPoint.y + 147.93)
		local param = isEffectShow
		local et_node = SoraDCreateEffectNode(param)
		et_node:addTo(self.target_, 10)
		self.et_node_rainbow_1 = et_node
	end)
	bPercent[4] = cca.callFunc(function()
		if isEffectShow then
			return
		end
		isEffectShow, isEffectShow = nil, isEffectShow
		;(nil).plist = "et_caihong_02.plist"
		;(nil).rotate = -22.21
		isEffectShow, isEffectShow[1], (nil).pos = nil, nil, cc.p(self.centerPoint.x + 19.28, self.centerPoint.y + 24.46)
		isEffectShow, (nil).plist = cc.p(self.centerPoint.x + 19.28, self.centerPoint.y + 24.46), "et_caihong_03.plist"
		cc.p(self.centerPoint.x + 19.28, self.centerPoint.y + 24.46).x = -0.855
		;(nil).scale, cc.p(self.centerPoint.x + 19.28, self.centerPoint.y + 24.46).y = cc.p(self.centerPoint.x + 19.28, self.centerPoint.y + 24.46), 0.876
		;(nil).rotate = 42.65
		isEffectShow, isEffectShow[2], (nil).pos = nil, nil, cc.p(self.centerPoint.x + 29, self.centerPoint.y + 76.06)
		;(nil).plist = "et_caihong_03.plist"
		;(nil).scale = 2.237
		;(nil).rotate = -18.87
		isEffectShow[3], (nil).pos = nil, cc.p(self.centerPoint.x + 61.85, self.centerPoint.y + 147.93)
		local param = isEffectShow
		local et_node = SoraDCreateEffectNode(param)
		et_node:addTo(self.target_, 10)
		self.et_node_rainbow_1 = et_node
	end)
	bPercent[5] = cca.callFunc(function()
		if isEffectShow then
			return
		end
		isEffectShow, isEffectShow = nil, isEffectShow
		;(nil).plist = "et_caihong_02.plist"
		;(nil).rotate = -22.21
		isEffectShow, isEffectShow[1], (nil).pos = nil, nil, cc.p(self.centerPoint.x + 19.28, self.centerPoint.y + 24.46)
		isEffectShow, (nil).plist = cc.p(self.centerPoint.x + 19.28, self.centerPoint.y + 24.46), "et_caihong_03.plist"
		cc.p(self.centerPoint.x + 19.28, self.centerPoint.y + 24.46).x = -0.855
		;(nil).scale, cc.p(self.centerPoint.x + 19.28, self.centerPoint.y + 24.46).y = cc.p(self.centerPoint.x + 19.28, self.centerPoint.y + 24.46), 0.876
		;(nil).rotate = 42.65
		isEffectShow, isEffectShow[2], (nil).pos = nil, nil, cc.p(self.centerPoint.x + 29, self.centerPoint.y + 76.06)
		;(nil).plist = "et_caihong_03.plist"
		;(nil).scale = 2.237
		;(nil).rotate = -18.87
		isEffectShow[3], (nil).pos = nil, cc.p(self.centerPoint.x + 61.85, self.centerPoint.y + 147.93)
		local param = isEffectShow
		local et_node = SoraDCreateEffectNode(param)
		et_node:addTo(self.target_, 10)
		self.et_node_rainbow_1 = et_node
	end)
	local seqRainbow = cca.seq(bPercent)
	self.et_node_rainbow:runAction(seqRainbow)
end
function worldMapBuildEffect:removeCastleFireWorkEffect()
	if self.fireWork then
		self.fireWork:removeFromParent()
		self.fireWork = nil
		if self.fireWorkTimeNode then
			self.fireWorkTimeNode:stopAllActions()
			self.fireWorkTimeNode:removeFromParent()
			self.fireWorkTimeNode = nil
		end
	end
	if self.node_snowEffect then
		self.node_snowEffect:removeFromParent()
		self.node_snowEffect = nil
	end
end
function worldMapBuildEffect:isShowWarLvEffect()
	local worldMapWarDef = include("worldMapWarDef")
	if worldMapWarDef.isInWarForbidShowWarLvEffect() then
		return false
	end
	local isHideCastleWarLvEffect = SoraDConfigGet("Game:GameOptionsView:hideCastleWarLvEffect~bool")
	return not isHideCastleWarLvEffect and not worldMapDefine.moveLineAutoHideOption.isCastleHideSkin
end
function worldMapBuildEffect:updateBuildStar2(...)
	self:updateBuildStar(self._starLv)
end
function worldMapBuildEffect:updateBuildStar(starLv)
	self._starLv = starLv
	if starLv and 0 < starLv and self:isShowWarLvEffect() then
		self.starLv = starLv
		self.image_level:setSpriteFrame("icon_main_buildstar_lv.png")
		self.image_level:setGroupID(GROU_ID.build_star_normal)
		self.image_level:setPosition(cc.p(self.centerPoint.x + 90, self.centerPoint.y - 43))
		self.text_Level:setPosition(cc.p(self.centerPoint.x + 112, self.centerPoint.y - 49))
		local isShowWarLv, textLv = SoraDGetBuildWarLv(self.cityLevel)
		self.text_Level:setString(string.format("%d-%d", textLv, self.starLv))
		if not self.spStarLight then
			local sprite = display.newSprite()
			sprite:addTo(self.image_level)
			sprite:setPosition(83, 35)
			self.spStarLight = sprite
		end
		local iconName = cityltCtrl.getBuildStarLight(self.starLv)
		self.spStarLight:setSpriteFrame(iconName)
		self:checkAndSetVisible(self.spStarLight, true)
	else
		self:checkAndSetVisible(self.spStarLight, false)
	end
	self:setBuildStarEffect()
end
function worldMapBuildEffect:setBuildStarEffect(...)
	if not (self.starLv and self.starLv > 0) or not self:isShowWarLvEffect() then
		self:checkAndSetVisible(self.buildStar_light, false)
		self:checkAndSetVisible(self.buildStar_level, false)
		return
	end
	local level = cityltCtrl.getBuildStarColor(self.starLv)
	local fileName = string.format("Node_buildStar_light_%d", level)
	local effect = self.buildStar_light
	if effect and effect:getCacheName() ~= fileName then
		instanceCacheMgr.addNormalNodeByType(effect, effect:getCacheName())
		effect:removeFromParent(false)
		self.buildStar_light = nil
	end
	local isWarLod = self:isWarLvLod()
	if not self.buildStar_light and isWarLod then
		local effect = instanceCacheMgr.getInstance(fileName)
		if effect then
			effect:addTo(self.target_)
			local x, y = self.image_level:getPosition()
			effect:setPosition(x + 20, y - 10)
			self.buildStar_light = effect
			effect:release()
		elseif getCCSPath(fileName) then
			local effect = SoraDCreatAnimation(fileName)
			effect:addTo(self.target_)
			local x, y = self.image_level:getPosition()
			effect:setPosition(x + 20, y - 10)
			effect:setCacheName(fileName)
			self:setBuildStarGroupID(effect, isWarLod)
			self.buildStar_light = effect
		end
	else
		self:checkAndSetVisible(self.buildStar_light, true)
	end
	if 1 < level then
		local __, warLv = SoraDGetBuildWarLv(self.cityLevel)
		local warLvColor = 0
		if 6 <= warLv and warLv <= 7 then
			warLvColor = 1
		elseif 8 <= warLv and warLv <= 9 then
			warLvColor = 2
		elseif 10 <= warLv then
			warLvColor = 3
		end
		local fileName
		if isWarLod then
			fileName = string.format("Node_buildStar_all_%d_%d", warLvColor, level - 1)
		else
			fileName = string.format("Node_buildStar_all_%d_%d_0", warLvColor, level - 1)
		end
		local effect = self.buildStar_level
		if effect and effect:getCacheName() ~= fileName then
			instanceCacheMgr.addNormalNodeByType(effect, effect:getCacheName())
			effect:removeFromParent(false)
			self.buildStar_level = nil
		end
		if not self.buildStar_level then
			local effect = instanceCacheMgr.getInstance(fileName)
			if effect then
				effect:addTo(self.warLVnode)
				self.buildStar_level = effect
				effect:release()
			elseif getCCSPath(fileName) then
				local effect = SoraDCreatAnimation(fileName)
				effect:addTo(self.warLVnode)
				effect:setCacheName(fileName)
				self:setBuildStarGroupID(effect, isWarLod)
				self.buildStar_level = effect
			end
		end
		local curEffect = self.buildStar_level
		if curEffect then
			local data = worldMapDefine.getWarLevelData(warLv)
			if data then
				local pos = data.bottom.img.bg[1].pos
				local scale = data.bottom.scale or 1
				local offset = data.bottom.offset or cc.p(0, 0)
				local x = pos.x * scale + offset.x
				local y = pos.y * scale + offset.y
				curEffect:setPosition(cc.p(x, y))
			end
			_UPVALUE3_ = pos
			data.bottom.img.bg[1].pos[1] = cc.p(-100, -70)
			data.bottom.img.bg[1].pos[2] = cc.p(-50, -70)
			data.bottom.img.bg[1].pos[3] = cc.p(170, 0)
			data.bottom.img.bg[1].pos[4] = cc.p(130, 55)
			data.bottom.img.bg[1].pos[5] = cc.p(130, 55)
			data.bottom.img.bg[1].pos[6] = cc.p(130, 55)
			data.bottom.img.bg[1].pos[7] = cc.p(130, 55)
			data.bottom.img.bg[1].pos[8] = cc.p(130, 55)
			local data.bottom.img.bg[1].pos[9], nodePos = cc.p(130, 55)
			for i = 1, 4 do
				local Node_a = SoraDGetChildByName(curEffect, "Node_a" .. i)
				if Node_a then
					Node_a:setPosition(nodePos[i])
				end
			end
		end
		self:checkAndSetVisible(self.buildStar_level, true)
		if self.node_warLvNode then
			local node_moon = SoraDGetChildByName(self.node_warLvNode, "node_moon")
			self:checkAndSetVisible(node_moon, false)
			local node_top_sword = SoraDGetChildByName(self.node_warLvNode, "node_top_sword")
			self:checkAndSetVisible(node_top_sword, false)
		end
	else
		self:checkAndSetVisible(self.buildStar_level, false)
		if self.node_warLvNode then
			local node_moon = SoraDGetChildByName(self.node_warLvNode, "node_moon")
			self:checkAndSetVisible(node_moon, true)
			local node_top_sword = SoraDGetChildByName(self.node_warLvNode, "node_top_sword")
			self:checkAndSetVisible(node_top_sword, true)
		end
	end
end
function worldMapBuildEffect:removeBuildStarEffect(...)
	local effect = self.buildStar_light
	if effect then
		instanceCacheMgr.addNormalNodeByType(effect, effect:getCacheName())
		effect:removeFromParent(false)
		self.buildStar_light = nil
	end
	local effect = self.buildStar_level
	if effect then
		instanceCacheMgr.addNormalNodeByType(effect, effect:getCacheName())
		effect:removeFromParent(false)
		self.buildStar_level = nil
	end
end
function worldMapBuildEffect:checkAndSetVisible(widget, isVisible)
	if widget then
		widget:setVisible(isVisible)
	end
end
function worldMapBuildEffect:setBuildStarGroupID(target, isWarLod)
	if isWarLod then
		local children = target:getChildren()
		for _, v in pairs(children) do
			local nodeType = tolua.type(v)
			if nodeType == "FairyGUI.GComponent" then
				self:setBuildStarGroupID(v, true)
			elseif nodeType == "FairyGUI.GLoader" then
				local childName = v:getName()
				local nameType = string.sub(childName, 1, 2)
				if nameType == "G_" then
					v:setGroupID(GROU_ID.build_star_glone)
				else
					v:setGroupID(GROU_ID.build_star_normal)
				end
			elseif nodeType == "FairyGUI.ParticleEx" then
				v:setGroupID(GROU_ID.build_star_particle)
			end
		end
	else
		target:setGroupAuto(true)
		target:setGroupID(GROU_ID.build_star_normal)
	end
end
function worldMapBuildEffect:updateWarLvEffect(...)
	if self.warLVnode then
		self.warLVnode:setVisible(not self.hideBattleLev)
	end
end
function worldMapBuildEffect:addEnemyCastleEffect()
	if self.target_:getChildByName("et_node_enemy") then
		return
	end
	_ENV, _ENV = self.target_, self.target_:getChildByName("et_node_enemy")
	_ENV, self.target_.plist = "et_node_enemy", "et_heiwu_display_01.plist"
	;("et_node_enemy").x = -8
	self.target_:getChildByName("et_node_enemy")[1], self.target_.pos, ("et_node_enemy").y = self.target_, "et_node_enemy", -10
	local param = self.target_:getChildByName("et_node_enemy")
	local et_node = SoraDCreateEffectNode(param)
	et_node:addTo(self.target_)
	self.et_node_enemy = et_node
end
function worldMapBuildEffect:removeEnemyCastleEffect()
	if self.et_node_enemy then
		self.et_node_enemy:removeFromParent()
		self.et_node_enemy = nil
	end
end
function worldMapBuildEffect:updateCastleEffect(data)
	local castleEffect = data.castleEffect
	local castleEffectStatusEndTime = data.castleEffectStatusEndTime
	local selfCastleEffect = data.selfCastleEffect
	local castleAppearance = data.castleAppearance
	local selfCastleEffectStatusEndTime = data.selfCastleEffectStatusEndTime
	local castleAppearanceEndTime = data.castleAppearanceEndTime
	if castleEffect then
		if 0 < castleEffect and castleEffectStatusEndTime and -1 < castleEffectStatusEndTime then
			self:removeCastleEffect()
			if castleEffect == worldMapCastleEffectID.Crystal_Heart then
				self:castleLoveEffect()
			elseif castleEffect == worldMapCastleEffectID.Rainbow_castle then
				self:castleRainbowEffect()
			elseif castleEffect == worldMapCastleEffectID.Shining_Castle then
				self:castleShiningEffect()
			elseif castleEffect == worldMapCastleEffectID.Shining_Castle_2 then
				self:castleShining2Effect()
			elseif castleEffect == worldMapCastleEffectID.Shining_Castle_3 then
				self:castleShining3Effect()
			elseif castleEffect == worldMapCastleEffectID.IceWolf_Castle then
				self:castleShining4Effect()
			elseif castleEffect == worldMapCastleEffectID.IceGragon_Castle then
				self:castleShining5Effect()
			end
		else
			self:removeCastleEffect()
		end
	end
	local selfPlayerID = gametop.playertop_:getPlayerID() or 0
	if selfCastleEffect then
		if 0 < selfCastleEffect and selfCastleEffectStatusEndTime and -1 < selfCastleEffectStatusEndTime then
			self:removeCastleFireWorkEffect()
			local leftTime = selfCastleEffectStatusEndTime - serviceFunctions.systemTime()
			if selfCastleEffect == worldMapCastleEffectID.Flowery_Firework or selfCastleEffect == worldMapCastleEffectID.Victory_Firework or selfCastleEffect == worldMapCastleEffectID.Festival_Firework or selfCastleEffect == worldMapCastleEffectID.NewYear_FireWork_2020 or selfCastleEffect == worldMapCastleEffectID.NewYear_FireWork_2022 or selfCastleEffect == worldMapCastleEffectID.FirewWork_Ceremony then
				self.fireWork = include("worldMapFireWorkEffect").new(selfCastleEffect)
				self.target_:addChild(self.fireWork)
				self.fireWork:play()
				if self.playerID == selfPlayerID then
					self.fireWorkTimeNode = worldMapEffect.createFireTimeNode()
					self.fireWorkTimeNode:setPosition(cc.p(self.centerPoint.x - 0, self.centerPoint.y - 120))
					self.fireWorkTimeNode:addTo(self.target_, 5)
					self.fireWorkTimeNode.init(leftTime)
				end
			end
			if selfCastleEffect == worldMapCastleEffectID.Snow_Effect and 0 < leftTime then
				self:castleSnowEffect()
			end
		else
			self:removeCastleFireWorkEffect()
		end
	end
	if castleAppearance then
		self:castleSnowIceEffect(self.playerID == selfPlayerID)
	end
end
function worldMapBuildEffect:getImgScale(...)
	return self.imgScale
end
function worldMapBuildEffect:getImgOffset(...)
	return self.imgOffset
end
function worldMapBuildEffect:getNodeSnowMan(...)
	return self.node_snowMan
end
function worldMapBuildEffect:updateOfficeIcon(...)
	local buildOfficer = self.target_:getBuildCom("buildOfficer")
	buildOfficer:updateOfficeIcon()
end
function worldMapBuildEffect:updatePrisoneIn(...)
	local buildPrisone = self.target_:getBuildCom("buildPrisone")
	buildPrisone:updatePrisoneIn()
end
function worldMapBuildEffect:isShowCastleSkin()
	local selfPlayerID = gametop.playertop_:getPlayerID() or 0
	return self.playerID == selfPlayerID or not worldMapDefine.moveLineAutoHideOption.isCastleHideSkin
end
function worldMapBuildEffect:isWarLvLod()
	local selfPlayerID = gametop.playertop_:getPlayerID() or 0
	return self.playerID == selfPlayerID or devicePerformanceUtil.getCurQualityLevel() >= 2
end
return worldMapBuildEffect
