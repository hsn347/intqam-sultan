local gametop = gModuleMgr.getObject("gametop")
local guideCtrl = SoraDGetCtrl("guideCtrl")
local worldMapComGuide = class("worldMapComGuide", include("worldMapCom"))
function worldMapComGuide:ctor()
	worldMapComGuide.super.ctor(self, "worldMapComGuide")
end
function worldMapComGuide:init()
	self.mapClassType = self.target_.mapClassType
end
function worldMapComGuide:relogin()
	self:checkPopExplain()
end
function worldMapComGuide:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_PYRAMIDBATTLE_GUIDECLOSEPOPEXPLAIN", handler(self, self.checkPopExplain))
	self:checkPopExplain()
end
function worldMapComGuide:checkPopExplain(targer, data)
	if SoraDIsGameGuide() ~= nil then
		return
	end
	if gModuleMgr.sharedMgr("mildGuideManager"):isInMildGuide() then
		return
	end
	if self.mapClassType == gKingdomClassType.pyramid then
		if worldMapDefine.isInPyramid() and self:checkIsInWarAndPopExplain_imp("Game:pyramidBattleExplain:saveTime~integer", 98, i18n("common_text_3695")) then
			return
		end
	elseif self.mapClassType == gKingdomClassType.legendLord then
		if worldMapDefine.isKingStarMapId(worldMapDefine.currentMapKindomID) then
			if worldMapDefine.isInLegendLord() and self:checkIsInWarAndPopExplain_imp("Game:kingStarBattleExplain:saveTime~integer", 107, i18n("legendaryking_text_93")) then
				return
			end
		elseif worldMapDefine.isInLegendLord() and self:checkIsInWarAndPopExplain_imp("Game:legendBattleExplain:saveTime~integer", 100, i18n("legendaryking_text_93")) then
			return
		end
	elseif self.mapClassType == gKingdomClassType.remains then
		if worldMapDefine.isInRemains() and self:checkIsInWarAndPopExplain_imp("Game:remainsBattleExplain:saveTime~integer", 101, i18n("remains_title_03")) then
			return
		end
	elseif self.mapClassType == gKingdomClassType.radiance then
		if worldMapDefine.isInRadiance() then
			if not guideCtrl:updateGuideModule(gGuideModule.RADIANCE_WAR) then
				self:checkIsInWarAndPopExplain_imp("Game:radianceBattleExplain:saveTime~integer", 103, i18n("brightWar_text_139"))
			end
			return
		end
	elseif self.mapClassType == gKingdomClassType.newTrial then
		if worldMapDefine.isInNewTrial() then
			guideCtrl:updateGuideModule(gGuideModule.DEVIL_VALLEY, true)
			return
		end
	elseif self.mapClassType == gKingdomClassType.atlantis then
		if worldMapDefine.isInAtlantis() then
			if guideCtrl:updateGuideModule(gGuideModule.ATLANTIS_WAR_BATTLE) then
				return
			end
			self:checkIsInWarAndPopExplain_imp("Game:atlantisBattleExplain:saveTime~integer", 104, i18n("atlantiswar_text_0233"))
			return
		end
	elseif self.mapClassType == gKingdomClassType.nebula then
		if worldMapDefine.isInNebula() then
			if guideCtrl:updateGuideModule(gGuideModule.NEBULA_WAR_ENTER_ROOM) then
				return
			end
			self:checkIsInWarAndPopExplain_imp("Game:nebulaBattleExplain1:saveTime~integer", 105, i18n("common_text_001"))
			return
		end
	elseif self.mapClassType == gKingdomClassType.nebulaEmperor then
		if worldMapDefine.isInNebulaEmperor() then
			self:checkIsInWarAndPopExplain_imp("Game:nebulaEmperorBattleExplain:saveTime~integer", 108, i18n("nebulaemperor_text_70"))
			return
		end
	elseif self.mapClassType == gKingdomClassType.nebulaAllStar then
		if worldMapDefine.isInNebulaAllStar(true) then
			local guideID
			local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
			if nebulaAllStarCtrl:getIsViewer() then
				guideID = 111
			elseif nebulaAllStarCtrl:getMyTeamInfo():getIsSuperTeam() then
				guideID = 109
			else
				guideID = 110
			end
			self:checkIsInWarAndPopExplain_imp("Game:nebulaAllStarBattleExplain:saveTime~integer", guideID, i18n("NebulaAllstar_rule_msg14"))
			return
		end
	elseif self.mapClassType == gKingdomClassType.roaringFlame then
		if worldMapDefine.isInRoaringFlame() then
			if guideCtrl:updateGuideModule(gGuideModule.ROARING_FLAME_WAR) then
				return
			end
			self:checkIsInWarAndPopExplain_imp("Game:roaringFlameBattleExplain:saveTime~integer", 112, i18n("flames_dunes_guide_tiele01"))
			return
		end
	elseif self.mapClassType == gKingdomClassType.simulatedDrill then
		if worldMapDefine.isInSimulatedDrill() then
			local key = "Game:simulatedDrillBattleExplain:saveTime~integer"
			self:checkIsInWarAndPopExplain_imp(key, 113, i18n("flames_dunes_title_rule01"))
			return
		end
	elseif self:checkIsInNormalAndPopExplain() then
		return
	end
end
function worldMapComGuide:checkIsInNormalAndPopExplain()
	if self.mapClassType == gKingdomClassType.normal and SoraDConfigGet("Game:SwitcherView:showWorldMapExplainView~bool") == false and not SoraDCurrentTopPanelFromManager() then
		_ENV = nil
		;(nil).instanceType = 0
		;(nil).classId = 99
		;(nil).title = i18n("common_text_1108")
		uiManager:show("WorldMapExplain", nil)
		SoraDConfigSet("Game:SwitcherView:showWorldMapExplainView~bool", true)
		return true
	end
end
function worldMapComGuide:checkIsInWarAndPopExplain_imp(key, guideID, title)
	_ENV = nil
	;(nil).byUID = true
	local sDay = SoraDConfigGet(key, nil)
	if sDay ~= tonumber(os.date("%d")) then
		_ENV = os.date("%d")
		os.date("%d").instanceType = 0
		os.date("%d").classId = guideID
		os.date("%d").title = title
		uiManager:show("WorldMapExplain", os.date("%d"))
		_ENV = os.date("%d")
		os.date("%d").byUID = true
		SoraDConfigSet(key, tonumber(os.date("%d")), os.date("%d"))
		return true
	end
end
function worldMapComGuide:guideDoClick(itemName, parameters)
	if itemName == "closestResourceFood" then
		local data = clone(parameters)
		data.justNode = true
		local target = self:gameGuide_getTarget(itemName, data)
		local tilesArray = target:getTilesArray()
		local tilePoint = SoraDStringSplit(tilesArray[1], ",")
		local tilePos = cc.p(tilePoint[1], tilePoint[2])
		self.target_:onClickInstance(tilePos)
	end
end
function worldMapComGuide:gameGuide_getTarget(itemName, parameters)
	_ENV = nil
	;(nil).itemName = itemName
	;(nil).parameters = parameters
	dump(nil, "==worldMapComGuide:gameGuide_getTarget==")
	if itemName == "closestResourceFood" then
		local resourceType
		if parameters.subType ~= nil then
			resourceType = parameters.subType
		else
			resourceType = gMapResourceTypeDef.subMapObjTypeResFood
		end
		_ENV = gMapResourceTypeDef
		local gMapResourceTypeDef.resourceType, params = resourceType, gMapResourceTypeDef
		local closestResourceFood = self.target_:getClosestInstanceFromManager(parameters.objType or gMapObjTypeDef.mapObjTypeResource, parameters.havePlayer, params)
		if closestResourceFood and parameters.delay then
			local showTilePoint = closestResourceFood:getTilePoint()
			self.target_:moveTilePointToCenter(showTilePoint, false, worldMapLayInstanceTypeDef.layInstanceNone, nil, parameters.delay)
			dump(closestResourceFood, "保存的值1")
			_ENV = false
			;(false).target = closestResourceFood
			gModuleMgr.sharedMgr("mildGuideManager"):setVariate("worldMapView", false)
		end
		if closestResourceFood and parameters.objType then
			if parameters.objType == gMapObjTypeDef.mapObjTypeResource then
				if parameters.justNode then
					local oldTarget = gModuleMgr.sharedMgr("mildGuideManager"):getVariate("worldMapView", "target")
					if oldTarget and not tolua.isnull(oldTarget) and oldTarget then
						dump(oldTarget, "用之前保存的值2")
						return oldTarget
					else
						return closestResourceFood
					end
				else
					local oldTarget = gModuleMgr.sharedMgr("mildGuideManager"):getVariate("worldMapView", "target")
					if oldTarget and not tolua.isnull(oldTarget) and oldTarget.resourceImage then
						dump(oldTarget, "用之前保存的值1")
						_ENV = false
						;(false).target = oldTarget
						gModuleMgr.sharedMgr("mildGuideManager"):setVariate("worldMapView", false)
						return oldTarget.resourceImage
					else
						return closestResourceFood.resourceImage
					end
				end
			elseif parameters.objType == gMapObjTypeDef.mapTypeRadianceWarBeacon then
				return closestResourceFood.bgImage
			elseif parameters.objType == gMapObjTypeDef.mapTypeRadianceWarResource then
				return closestResourceFood.resourceImage
			end
		end
		return closestResourceFood
	elseif itemName == "serverLevelBuild" then
		_ENV = gMapObjTypeDef.mapTypeRadianceWarResource
		local serverLevelBuild = self.target_:getClosestInstanceFromManager(gMapObjTypeDef.mapObjTypeKingdomLevelBuild, false, gMapObjTypeDef.mapTypeRadianceWarResource)
		if serverLevelBuild then
			return serverLevelBuild.resourceImage
		end
	elseif itemName == "tipButton_zhanling" then
		return self.target_:getTipButtons(worldMapDefine.worldMapTipButtonType_zhanLing)
	elseif itemName == "tipButton_zhuangtai" then
		local item = self.target_:getTipButtons(worldMapDefine.worldMapTipButtonType_zhuangTai)
		if item then
			return item
		end
		SoraDGotoWorldMapPoint(cc.p(74, 74), true)
		return nil
	elseif itemName == "pyramidBattleMapView" then
		local panel = display.getRunningScene().panelView:getChildByName(itemName)
		if panel then
			return panel:gameGuide_getTarget(parameters.key, parameters)
		else
			return nil
		end
	elseif itemName == "tipButton_yayun" then
		return self.target_:getTipButtons(worldMapDefine.worldMapTipButtonType_yayun)
	elseif itemName == "Button_worldResource" then
		return self.target_:getButtonWorldResouce()
	elseif itemName == "atlantisSkill_scroll" then
		return self.target_:getWorldMapAtlantisSkill().scroll
	elseif itemName == "atlantisSkill_config" then
		return self.target_:getWorldMapAtlantisSkill().Button_skill
	elseif itemName == "nebulaWarBuilding" then
		local nebulaWarRead = include("nebulaWarRead")
		local buildId = parameters.buildId
		if not buildId then
			local subType = parameters.subType or gWorldTypeServerDef.subTypeNebulaWarPalace
			buildId = nebulaWarRead.getBuildIdByType(subType)
		end
		local buildPoint = nebulaWarRead.getBuildPoint(buildId)
		local worldMapView = SoraDCurrentSceneShowView("worldMapView")
		if worldMapView and worldMapView:getComponent("worldMapComLod") then
			_ENV = false
			;(false).needAction = true
			;(false).toTilePos = buildPoint
			worldMapView:gotoTilePointNew(worldMapView, false)
		end
		local component = self.target_:getComponent("worldMapComInstanceNebula4")
		_ENV = worldMapLayInstanceTypeDef.layInstanceNone
		worldMapLayInstanceTypeDef.layInstanceNone.buildId = buildId
		local worldMapNebulaWarLod = component:getClosestInstanceFromManager_lod(gMapObjTypeDef.nebulaWarBuilding, worldMapLayInstanceTypeDef.layInstanceNone)
		if worldMapNebulaWarLod then
			return worldMapNebulaWarLod:getSpriteBuild()
		end
	elseif itemName == "atlantisWarBuilding" then
		return self:gameGuide_atlantisWarBuilding(itemName, parameters)
	elseif itemName == "atlantisWarBuilding_902" or itemName == "atlantisWarBuilding_903" or itemName == "atlantisWarBuilding_904" then
		_ENV = self.gameGuide_atlantisWarBuilding
		self.gameGuide_atlantisWarBuilding.atlantisWarBuilding_902 = 902
		self.gameGuide_atlantisWarBuilding.atlantisWarBuilding_903 = 903
		local self.gameGuide_atlantisWarBuilding.atlantisWarBuilding_904, config = 904, self.gameGuide_atlantisWarBuilding
		_ENV = self.target_:getComponent("worldMapComInstanceNebula4")
		self.target_:getComponent("worldMapComInstanceNebula4").instanceType = gMapObjTypeDef.mapTypeAtlantisWarBuilding
		self.target_:getComponent("worldMapComInstanceNebula4").buildId = config[itemName]
		return self:gameGuide_atlantisWarBuilding(itemName, (self.target_:getComponent("worldMapComInstanceNebula4")))
	elseif itemName == "Button_expand" then
		local warType = parameters.warType or gKingdomClassType.normal
		if warType == gKingdomClassType.roaringFlame then
			local roaringFlameUIBottom = self.target_:getNodeWar():getChild("roaringFlameUIBottom")
			return roaringFlameUIBottom:gameGuide_getTarget(itemName, parameters)
		end
	elseif itemName == "warBuilding" then
		return self:gameGuide_getWarBuilding(parameters)
	elseif itemName == "warBuildingList" then
		return self:gameGuide_getWarBuildingList(parameters)
	elseif itemName == "guideRemainsBuilding" then
		return self.target_:getGuideFakeInstance(itemName)
	elseif itemName == "tipButton_tanxian_guide" then
		return self.target_:getTipButtons(worldMapDefine.worldMapTipButtonType_tanXian)
	end
	return SoraDGetChildByName(self.target_, itemName)
end
function worldMapComGuide:gameGuide_atlantisWarBuilding(itemName, parameters)
	local atlantisWarUtil = include("atlantisWarUtil")
	local buildId = atlantisWarUtil.getBuildIdByParams(parameters)
	local instanceType = parameters.instanceType
	local component = self.target_:getComponent("worldMapComInstanceNebula4")
	_ENV = nil
	;(nil).buildId = buildId
	local worldMapNebulaWarLod = component:getClosestInstanceFromManager_lod(instanceType, nil)
	if worldMapNebulaWarLod then
		return worldMapNebulaWarLod:getSpriteBuild()
	end
end
function worldMapComGuide:gameGuide_getWarBuilding(parameters)
	local warType = parameters.warType or gKingdomClassType.normal
	if warType == gKingdomClassType.roaringFlame then
		local roaringFlameWarUtil = include("roaringFlameWarUtil")
		local subType = parameters.subType
		local buildID = roaringFlameWarUtil.getGuideBuildID(subType)
		_ENV = nil
		;(nil).warType = warType
		;(nil).instanceType = gMapObjTypeDef.roaringFlameWarBuilding
		;(nil).objId = buildID
		return self:gameGuide_warBuilding(nil)
	end
end
function worldMapComGuide:gameGuide_getWarBuildingList(parameters)
	local _ENV, ret
	local warType = parameters.warType or gKingdomClassType.normal
	if warType == gKingdomClassType.roaringFlame then
		local roaringFlameWarUtil = include("roaringFlameWarUtil")
		local roaringFlameWarRead = include("roaringFlameWarRead")
		local buildID = roaringFlameWarUtil.getSelfCampInitCity()
		_ENV = nil
		;(nil).warType = warType
		;(nil).instanceType = gMapObjTypeDef.roaringFlameWarBuilding
		;(nil).objId = buildID
		local target = self:gameGuide_warBuilding(nil)
		table.insert(ret, target)
		local binding = roaringFlameWarRead.getBuildBinding(buildID)
		for __, _objId in ipairs(binding) do
			local _subType = roaringFlameWarRead.getBuildSubType(_objId)
			if _subType == gWorldTypeServerDef.subTypeRoaringFlameWarFort then
				_ENV = nil
				;(nil).warType = warType
				;(nil).instanceType = gMapObjTypeDef.roaringFlameWarBuilding
				;(nil).objId = _objId
				local target = self:gameGuide_warBuilding(nil)
				table.insert(ret, target)
			end
		end
	end
	return ret
end
function worldMapComGuide:gameGuide_warBuilding(params)
	local warType = params.warType
	local instanceType = params.instanceType
	local objId = params.objId
	if warType == gKingdomClassType.roaringFlame then
		local component = self.target_:getComponent("worldMapComInstanceNebula4")
		_ENV = nil
		;(nil).buildId = objId
		local worldMapNebulaWarLod = component:getClosestInstanceFromManager_lod(instanceType, nil)
		if worldMapNebulaWarLod then
			return worldMapNebulaWarLod:getSpriteBuild()
		end
	end
end
function worldMapComGuide:exportMethods()
	_UPVALUE2_ = nil
	;(nil)[1] = "guideDoClick"
	;(nil)[2] = "gameGuide_getTarget"
	self:exportMethods_(nil)
	return self.target_
end
return worldMapComGuide
