local gametop = gModuleMgr.getObject("gametop")
local KWKingdomCtrl = gametop.playertop_:getModule("KWKingdomCtrl")
local palaceInfoRead = include("palaceInfoRead")
local allianceDesRead = include("allianceDesRead")
local wrathBeastCtrl = SoraDGetCtrl("wrathBeastCtrl", gametop)
local AllianceWarCitySingle = class("allianceWarCitySingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceWarCitySingle")
	end
	return target
end)
function AllianceWarCitySingle:ctor()
	self.scroll = nil
	self.tableSingleData, _ENV, self.singleIsMoved = nil, nil, false
	self.imgCity = nil
	self.btnJump = SoraDGetChildByName(self, "Button_jump")
	self.btnJump:setSwallowTouches(false)
	self.nodeTarget = SoraDGetChildByName(self, "Node_target")
	self.imgSearch = SoraDGetChildByName(self, "Image_search")
	self.layerCut = SoraDGetChildByName(self, "Panel_cut")
	self.layerCut:setSwallowTouches(false)
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.labelTitle = SoraDGetChildByName(self, "Text_title")
	self.labelPos = SoraDGetChildByName(self, "Text_pos")
	if self.btnJump then
		self.btnJump:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
end
function AllianceWarCitySingle:initData(cityData, mainData)
	self.tableSingleData = cityData
	self.tableMainData = mainData
	if self.imgCity then
		self.imgCity:removeFromParent()
		self.imgCity = nil
	end
	local scale = 1.0
	local pos = cc.p(0, 0)
	local objType = self.tableSingleData.objType
	if objType and objType ~= gMapObjTypeDef.mapObjTypePlayer then
		local headImg
		local name = ""
		local sprite
		if objType == gMapObjTypeDef.mapObjTypeCastale then
			local bigCastale = KWKingdomCtrl:getKingdomCastaleModel()
			headImg = palaceInfoRead.getIcon(bigCastale, true)
			name = i18n("common_text_839")
			scale = 0.8
		elseif objType == gMapObjTypeDef.mapObjTypeBattery then
			local objId = self.tableSingleData.objId
			if objId then
				name = palaceInfoRead.getBatteryName(objId)
				headImg = "#" .. palaceInfoRead.getBatteryIcon(objId)
			else
				name = i18n("common_text_840")
				headImg = "#paotai_dj_w_01.png"
			end
			local gKWBattery = _G.gKWBattery
			if objId == gKWBattery.NORTH then
				pos = cc.p(0, -16)
			elseif objId == gKWBattery.EAST then
				pos = cc.p(0, -10)
			elseif objId == gKWBattery.SOUTH then
				pos = cc.p(-2, -20)
			elseif objId == gKWBattery.WEST then
				pos = cc.p(24, -24)
			else
				pos = cc.p(10, 0)
			end
			scale = 0.8
		elseif objType == gMapObjTypeDef.mapTypeATBuilding then
			headImg = "#Map_build_sgmk.png"
			name = i18n("AncienTreasure_buildname_01")
			scale = 0.6
		elseif objType == gMapObjTypeDef.mapObjTypeFortress then
			headImg = "#Map_build_fort.png"
			name = i18n("common_text_2859")
			scale = 0.7
		elseif objType == gMapObjTypeDef.mapObjTypeLegendLord then
			local objId = self.tableSingleData.objId
			if objId then
				local hegemonRead = include("hegemonRead")
				headImg = "#" .. hegemonRead.getIcon(objId)
				name = hegemonRead.getName(objId)
				scale = 1.0
			else
				headImg = "#icon_world_legendaryking.png"
				scale = 1.5
				if worldMapDefine.isKingStarMapId(self.tableMainData:getMapID()) then
					name = i18n("kingstarbattle_text_64")
				else
					name = i18n("common_text_4242")
				end
			end
		elseif objType == gMapObjTypeDef.mapObjTypeRemainsWar then
			local objId = self.tableSingleData.objId
			if objId then
				local remainsWarRead = include("remainsWarRead")
				headImg = remainsWarRead.getBuildImage(objId)
				name = remainsWarRead.getBuildName(objId)
				pos = cc.p(-20, 0)
				scale = 0.8
			end
		elseif objType == gMapObjTypeDef.mapObjTypeBoss or objType == gMapObjTypeDef.mapTypeWerewolf or objType == gMapObjTypeDef.mapTypeWrathBeast or objType == gMapObjTypeDef.wastelandBoss or objType == gMapObjTypeDef.fireDragon2 or objType == gMapObjTypeDef.sweetMeatRobber then
			local bossType = self.tableSingleData.bossType
			local lv = self.tableSingleData.lv
			if objType == gMapObjTypeDef.mapTypeWrathBeast then
				local beastData = wrathBeastCtrl:getWrathBeastData(bossType)
				bossType = beastData.bossType
				lv = beastData.level
			end
			local bossData = worldMapDefine.getWorldBossShow(bossType, lv)
			local hasHD = worldMapDefine.hasBossHdRes(bossType, lv)
			if hasHD then
				headImg = "#" .. bossData.effects .. "_sw_ws_01.png"
			else
				headImg = "#" .. bossData.effects .. "_sw_ws.png"
			end
			_ENV = "_sw_ws.png"
			;("_sw_ws.png").lv = lv
			;("_sw_ws.png").name = i18n(bossData.name)
			name = i18n("common_text_134", "_sw_ws.png")
			if gBossType.manuPlaceBoss == bossType then
				scale = 1.4
				pos = cc.p(0, 10)
			elseif gBossType.manuPlaceSheep == bossType then
				scale = 1.1
				pos = cc.p(5, 25)
			elseif gBossType.remainsWarBossMy == bossType then
				scale = 1.4
				pos = cc.p(-5, 5)
			elseif gBossType.remainsWarBossZjssg == bossType then
				scale = 1.5
				pos = cc.p(15, 5)
			elseif gBossType.werewolf == bossType then
				scale = 1.5
				pos = cc.p(5, -15)
			end
		elseif objType == gMapObjTypeDef.mapTypeHeroBattleBoss1 then
			local bossType = self.tableSingleData.bossType
			local bossData = worldMapDefine.getWorldBossShow(bossType)
			local hasHD = worldMapDefine.hasBossHdRes()
			if hasHD then
				headImg = "#" .. bossData.effects .. "_sw_ws_01.png"
			else
				headImg = "#" .. bossData.effects .. "_sw_ws.png"
			end
			_ENV = "_sw_ws.png"
			;("_sw_ws.png").lv = self.tableSingleData.lv
			;("_sw_ws.png").name = i18n(bossData.name)
			name = i18n("common_text_134", "_sw_ws.png")
			if gBossType.heroBattleBoss1 == bossType then
				scale = 1.3
			end
		elseif objType == gMapObjTypeDef.mapTypeHeroBattleBoss2 then
			local bossType = self.tableSingleData.bossType
			local bossData = worldMapDefine.getWorldBossShow(bossType)
			local hasHD = worldMapDefine.hasBossHdRes()
			if hasHD then
				headImg = "#" .. bossData.effects .. "_sw_ws_01.png"
			else
				headImg = "#" .. bossData.effects .. "_sw_ws.png"
			end
			_ENV = "_sw_ws.png"
			;("_sw_ws.png").lv = self.tableSingleData.lv
			;("_sw_ws.png").name = i18n(bossData.name)
			name = i18n("common_text_134", "_sw_ws.png")
			if gBossType.heroBattleBoss2 == bossType then
				scale = 1.5
			end
		elseif objType == gMapObjTypeDef.mapObjTypeBattlefieldSite then
			local buildType = self.tableSingleData.subMapType
			name = worldMapDefine.getPyramidbuildingName(buildType, self.tableSingleData.objId)
			headImg = "#" .. worldMapDefine.getPyramidbuildingImage(buildType)
			scale = 0.5
			if buildType == gMapBattlefieldSiteTypeDef.subMapTypeAWBellTower then
				pos = cc.p(-20, 0)
			end
		elseif objType == gMapObjTypeDef.mapObjTypeAllianceBuild then
			headImg = allianceDesRead.getBuildIcon(self.tableSingleData.objId, true)
			_ENV = true
			;(true).abbr = self.tableSingleData.allianceAbb
			;(true).name = allianceDesRead.getBuildName(self.tableSingleData.objId)
			name = i18n("common_text_186", true)
			if self.tableSingleData.allianceFlag and self.tableSingleData.objId == gAllianceBuilding.FLAG then
				sprite = SoraDGetAllianceFlagByFid(self.tableSingleData.allianceFlag)
				sprite:setScale(0.5)
				sprite:setPosition(cc.p(63, 45))
			else
				scale = 0.6
			end
		elseif objType == gMapObjTypeDef.stronghold then
			local allianceStrongholdMineRead = include("allianceStrongholdMineRead")
			local info = allianceStrongholdMineRead.getGateClientCfg(self.tableSingleData.objId)
			headImg = "#" .. info.image
			name = i18n(info.name)
			scale = 0.7
			pos = cc.p(-20, -10)
		elseif objType == gMapObjTypeDef.mapObjNewTrialCity then
			if self.tableSingleData.subMapType == 1 then
				headImg = "map_devilValley_wall_01.png"
				name = i18n("devilvalley_text_48")
				scale = 0.6
			else
				name = i18n("common_text_840")
				headImg = "#paotai_dj_w_01.png"
				scale = 0.8
			end
		elseif objType == gMapObjTypeDef.mapTypeRadianceWarPalace or objType == gMapObjTypeDef.mapTypeRadianceWarGate or objType == gMapObjTypeDef.mapTypeRadianceWarBeacon then
			local radianceWarRead = include("radianceWarRead")
			local objId = self.tableSingleData.objId
			headImg = "#" .. radianceWarRead.getBuildImage(objType, objId)
			name = radianceWarRead.getBuildName(objType, objId)
			local x, y = radianceWarRead.getBuildPos(objId)
			if objType == gMapObjTypeDef.mapTypeRadianceWarBeacon then
				x, y = -45, -10
			end
			scale = 0.8
			pos = cc.p(x * scale, y * scale)
		elseif objType == gMapObjTypeDef.mapTypeAtlantisWarBuilding then
			local objId = self.tableSingleData.objId
			local AMBC = require_data("atlantiswar_map_build_config").data
			headImg = "#" .. AMBC[objId].image
			name = i18n(AMBC[objId].name)
			scale = 0.5
		elseif objType == gMapObjTypeDef.mapTypeAtlantisWarBoss then
			local bossType = self.tableSingleData.subMapType
			local bossData = worldMapDefine.getWorldBossShow(bossType)
			local hasHD = worldMapDefine.hasBossHdRes(bossType)
			if hasHD then
				headImg = "#" .. bossData.effects .. "_sw_ws_01.png"
			else
				headImg = "#" .. bossData.effects .. "_sw_ws.png"
			end
			name = i18n(bossData.name)
		elseif objType == gMapObjTypeDef.nebulaWarBuilding then
			local nebulaWarRead = include("nebulaWarRead")
			local build = nebulaWarRead.getBuildConfig(self.tableSingleData.subMapType)
			headImg = "#" .. build.image
			name = i18n(build.name)
			scale = 0.5
		elseif objType == gMapObjTypeDef.nebulaEmperorWarBuilding then
			local buildID = self.tableSingleData.objId
			local nebulaEmperorRead = include("nebulaEmperorRead")
			local image = nebulaEmperorRead.getBuildImage(buildID)
			headImg = "#" .. image
			name = nebulaEmperorRead.getBuildName(buildID)
			scale = 0.7
			if buildType == gMapBattlefieldSiteTypeDef.subTypeNebulaEmperorWarTower then
				pos = cc.p(-30, 0)
			end
		end
		self.imgCity = display.newSprite(headImg)
		self.labelName:setString(name)
		if sprite then
			sprite:addTo(self.imgCity)
		end
	elseif self.tableSingleData.isKing and self.tableSingleData.objId == self.tableSingleData.uid then
		self.imgCity = display.newSprite("#Castle_King.png")
		self.labelName:setString(self.tableSingleData.name)
		pos = cc.p(-22.5, 0)
		scale = 0.6
	elseif self.tableSingleData.castleLv then
		local castleLv = self.tableSingleData.castleLv
		self.imgCity = worldMapDefine.createCityImageWithLevel(castleLv)
		self.imgCity:setCascadeColorEnabled(true)
		self.labelName:setString(self.tableSingleData.name)
		local isShowWarLv = SoraDGetBuildWarLv(castleLv)
		if isShowWarLv then
			pos = cc.p(-17.5, -10)
			scale = 1.5
		else
			pos = cc.p(0, -30)
			scale = 1.0
		end
	end
	if self.imgCity then
		self.imgCity:setScale(scale * math.min(1, 200 / self.imgCity:getContentSize().height))
		self.imgCity:setAnchorPoint(cc.p(0.5, 0.5))
		self.imgCity:setPosition(pos)
		self.imgCity:addTo(self.nodeTarget)
	end
	self.labelTitle:setString(i18n("common_text_294"))
	self.labelPos:setString(tostring(self.tableSingleData.x) .. "," .. tostring(self.tableSingleData.y))
end
function AllianceWarCitySingle:setScroll(scroll)
	self.scroll = scroll
end
function AllianceWarCitySingle:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		self.labelPos:setScale(1.0)
		if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if self.scroll then
			self.btnJump:setSwallowTouches(true)
		end
		if SoraDGotoWorldMapPoint(cc.p(self.tableSingleData.x, self.tableSingleData.y), true, self.tableMainData:getMapID()) then
			SoraDRemoveAllPanelFromManager()
		end
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
		self.labelPos:setScale(1.0)
	elseif type == ccui.TouchEventType.began then
		self.labelPos:setScale(1.1)
		if self.scroll then
			self.btnJump:setSwallowTouches(false)
		end
	end
end
return AllianceWarCitySingle
