local _ENV, worldMapViewDef
local gKingdomClassType = _G.gKingdomClassType
worldMapViewDef.MIN_SCALE = 0.75
worldMapViewDef.MIN_SCALE_DEFAULT = 0.75
worldMapViewDef.MIN_SCALE_NO_LIMIT = 0.01
worldMapViewDef.MAX_SCALE = 1.35
worldMapViewDef.NORMAL_SCALE = 1.0
worldMapViewDef.NORMAL_SCALE_DEFAULT = 0.85
worldMapViewDef.TileBG_Offset_X = 200
worldMapViewDef.TileBG_Offset_Y = 200
worldMapViewDef.MIN_TIME_MARCH = 1.5
if device.platform == "android" then
	worldMapViewDef.MIN_TIME_DRAG = 0.4
else
	worldMapViewDef.MIN_TIME_DRAG = 0.2
end
worldMapViewDef.NODEINFO_TYPE_MANORLINE = 1
worldMapViewDef.NODEINFO_TYPE_RESOURCE = 2
worldMapViewDef.NODEINFO_TYPE_ALLIANCE = 3
function worldMapViewDef.getMapImage(mapClassType)
	gKingdomClassType, _UPVALUE3_ = nil, nil
	gKingdomClassType, (nil).name = nil, "newAndRepair/newAndRepair"
	gKingdomClassType, (nil).name = nil, "worldMap/worldMapUI"
	;(nil).name = "Lucency/warLvImage"
	;(nil).format = "png"
	;(nil)[1] = nil
	;(nil)[2] = nil
	local (nil)[3], imgArray
	local bAddLmqb = false
	if mapClassType == gKingdomClassType.pyramid then
		bAddLmqb = true
	elseif mapClassType == gKingdomClassType.legendLord then
	elseif mapClassType == gKingdomClassType.newTrial then
		bAddLmqb = true
		gKingdomClassType = nil
		;(nil).name = "MainCity/mainCity"
		table.insert(imgArray, nil)
	elseif mapClassType == gKingdomClassType.remains then
		bAddLmqb = true
		local needBossIcon = false
		gKingdomClassType = nil
		;(nil).name = "FrameAnimation/worldMapMonsterRemains"
		table.insert(imgArray, nil)
		local ret = _G.SoraDIsFileExistByKey("worldMapBossRemain")
		if ret then
			gKingdomClassType = nil
			;(nil).name = "worldMap/worldMapBossRemain"
			table.insert(imgArray, nil)
		else
			needBossIcon = true
		end
		gKingdomClassType = nil
		;(nil).name = "MainCity/mainCity"
		table.insert(imgArray, nil)
		local ret = _G.SoraDIsFileExistByKey("worldMapBossRemain2")
		if ret then
			gKingdomClassType = nil
			;(nil).name = "worldMap/worldMapBossRemain2"
			table.insert(imgArray, nil)
		else
			needBossIcon = true
		end
		if needBossIcon then
			gKingdomClassType = nil
			;(nil).name = "worldMap/worldMapBossIcon"
			table.insert(imgArray, nil)
		end
	elseif mapClassType == gKingdomClassType.radiance then
		gKingdomClassType = _G.SoraDIsFileExistByKey("worldMapBossRemain2")
		_G.SoraDIsFileExistByKey("worldMapBossRemain2").name = "worldMap/worldMapRadiance"
		table.insert(imgArray, (_G.SoraDIsFileExistByKey("worldMapBossRemain2")))
	elseif mapClassType == gKingdomClassType.atlantis then
		local needBossIcon = false
		_UPVALUE3_ = _G.SoraDIsFileExistByKey("worldMapBossRemain2")
		_G.SoraDIsFileExistByKey("worldMapBossRemain2")[1] = "worldMapBossAtlantis"
		_G.SoraDIsFileExistByKey("worldMapBossRemain2")[2] = "worldMapBossAtlantis2"
		_G.SoraDIsFileExistByKey("worldMapBossRemain2")[3] = "worldMapBossAtlantis3"
		for __, imgName in ipairs((_G.SoraDIsFileExistByKey("worldMapBossRemain2"))) do
			local ret = _G.SoraDIsFileExistByKey(imgName)
			if ret then
				gKingdomClassType = nil
				;(nil).name = "worldMap/" .. imgName
				table.insert(imgArray, nil)
			else
				needBossIcon = true
			end
		end
		if needBossIcon then
			gKingdomClassType = ipairs((_G.SoraDIsFileExistByKey("worldMapBossRemain2")))
			ipairs((_G.SoraDIsFileExistByKey("worldMapBossRemain2"))).name = "worldMap/worldMapBossIcon"
			table.insert(imgArray, ipairs((_G.SoraDIsFileExistByKey("worldMapBossRemain2"))))
		end
	elseif mapClassType == gKingdomClassType.nebula then
	elseif mapClassType == gKingdomClassType.nebulaEmperor then
	elseif mapClassType == gKingdomClassType.nebulaAllStar then
	elseif mapClassType == gKingdomClassType.roaringFlame then
	else
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		local gametop = gModuleMgr.getObject("gametop")
		local romeActivityCtrl = gametop.playertop_:getModule("romeActivityCtrl")
		local isOpened = romeActivityCtrl:isOpenRomeActivity()
		if isOpened then
			bAddLmqb = true
		end
		gKingdomClassType = _G.SoraDIsFileExistByKey(imgName)
		_G.SoraDIsFileExistByKey(imgName).name = "FrameAnimation/worldMapMonster"
		table.insert(imgArray, (_G.SoraDIsFileExistByKey(imgName)))
		local gKingdomClassType, config = table.insert, table.insert
		if nebulaActivityCtrl:getTowerLv() > 0 then
			gKingdomClassType = table.insert
			table.insert.imgName = "worldMapMonsterFalake"
			table.insert.folder = "FrameAnimation"
			table.insert.isLocal = true
			table.insert.checkEffect = true
			table.insert(config, table.insert)
			gKingdomClassType = table.insert
			table.insert.imgName = "worldMapMonsterZZLG"
			table.insert.folder = "FrameAnimation"
			table.insert.isLocal = true
			table.insert.checkEffect = true
			table.insert(config, table.insert)
		end
		gKingdomClassType = table.insert
		table.insert.activityID = gActivityTimeActivityID.WRATH_BEAST_ACTIVITY
		table.insert.imgName = "worldMapWrathBeastDrq"
		table.insert.folder = "worldMap"
		table.insert.checkEffect = true
		table.insert(config, table.insert)
		gKingdomClassType = table.insert
		table.insert.activityID = gActivityTimeActivityID.WRATH_BEAST_ACTIVITY
		table.insert.imgName = "worldMapWrathBeastDrqsc"
		table.insert.folder = "worldMap"
		table.insert.checkEffect = true
		table.insert(config, table.insert)
		gKingdomClassType = table.insert
		table.insert.activityID = gActivityTimeActivityID.ENDLESS_TRIALS_ACTIVITY
		table.insert.imgName = "worldMapEndlessBoss"
		table.insert.folder = "worldMap"
		table.insert(config, table.insert)
		gKingdomClassType = table.insert
		table.insert.activityID = gActivityTimeActivityID.ANCIENT_TREASURE_ACTIVITY
		table.insert.imgName = "worldMapLycan"
		table.insert.folder = "worldMap"
		table.insert(config, table.insert)
		gKingdomClassType = table.insert
		table.insert.activityID = gActivityTimeActivityID.LOST_RUINS_ACTIVITY
		table.insert.imgName = "worldMapBossArsonist"
		table.insert.folder = "worldMap"
		table.insert(config, table.insert)
		gKingdomClassType = table.insert
		table.insert.activityID = gActivityTimeActivityID.SNOWWOLF_LOST_ACTIVITY
		table.insert.imgName = "worldMapBossSnowWolf"
		table.insert.folder = "worldMap"
		table.insert(config, table.insert)
		gKingdomClassType = table.insert
		table.insert.activityID = gActivityTimeActivityID.SNOWWOLF_LOST_ACTIVITY
		table.insert.imgName = "worldMapBossSnowWolf2"
		table.insert.folder = "worldMap"
		table.insert(config, table.insert)
		gKingdomClassType = table.insert
		table.insert.activityID = gActivityTimeActivityID.SNOWWOLF_LOST_ACTIVITY
		table.insert.imgName = "worldMapBossSnowWolf3"
		table.insert.folder = "worldMap"
		table.insert(config, table.insert)
		gKingdomClassType = table.insert
		table.insert.activityID = gActivityTimeActivityID.WASTELAND
		table.insert.imgName = "worldMapBossAtlantis"
		table.insert.folder = "worldMap"
		table.insert(config, table.insert)
		gKingdomClassType = table.insert
		table.insert.activityID = gActivityTimeActivityID.WASTELAND
		table.insert.imgName = "worldMapBossAtlantis2"
		table.insert.folder = "worldMap"
		table.insert(config, table.insert)
		gKingdomClassType = table.insert
		table.insert.activityID = gActivityTimeActivityID.WASTELAND
		table.insert.imgName = "worldMapBossAtlantis3"
		table.insert.folder = "worldMap"
		table.insert(config, table.insert)
		gKingdomClassType = table.insert
		table.insert.activityID = gActivityTimeActivityID.WASTELAND
		table.insert.imgName = "worldMapBossWasteland"
		table.insert.folder = "worldMap"
		table.insert(config, table.insert)
		gKingdomClassType = table.insert
		table.insert.activityID = gActivityTimeActivityID.MONSTER_INVASION_ACTIVITY
		table.insert.imgName = "worldMapBossYsrq"
		table.insert.folder = "worldMap"
		table.insert(config, table.insert)
		gKingdomClassType = table.insert
		table.insert.activityID = gActivityTimeActivityID.SWEET_MEAT_ROBBER_ACTIVITY
		table.insert.imgName = "worldMapDessertThief1"
		table.insert.folder = "worldMap"
		table.insert(config, table.insert)
		gKingdomClassType = table.insert
		table.insert.activityID = gActivityTimeActivityID.SWEET_MEAT_ROBBER_ACTIVITY
		table.insert.imgName = "worldMapDessertThief2"
		table.insert.folder = "worldMap"
		table.insert(config, table.insert)
		gKingdomClassType = table.insert
		table.insert.activityID = gActivityTimeActivityID.SWEET_MEAT_ROBBER_ACTIVITY
		table.insert.imgName = "worldMapDessertThief3"
		table.insert.folder = "worldMap"
		table.insert(config, table.insert)
		gKingdomClassType = table.insert
		table.insert.activityID = gActivityTimeActivityID.LEGEND_OF_PEGASUS_ACTIVITY
		table.insert.imgName = "worldMapLegendOfPegasus"
		table.insert.folder = "worldMap"
		table.insert(config, table.insert)
		gKingdomClassType = table.insert
		table.insert.activityID = gActivityTimeActivityID.LEGEND_OF_PEGASUS_ACTIVITY
		table.insert.imgName = "worldMapLegendOfPegasus2"
		table.insert.folder = "worldMap"
		table.insert(config, table.insert)
		gKingdomClassType = table.insert
		table.insert.activityID = gActivityTimeActivityID.LEGEND_OF_PEGASUS_ACTIVITY
		table.insert.imgName = "worldMapLegendOfPegasus3"
		table.insert.folder = "worldMap"
		table.insert(config, table.insert)
		gKingdomClassType = table.insert
		table.insert.activityID = gActivityTimeActivityID.PHOENIX_CHALLENGE
		table.insert.imgName = "worldMapPhoenix1"
		table.insert.folder = "worldMap"
		table.insert(config, table.insert)
		gKingdomClassType = table.insert
		table.insert.activityID = gActivityTimeActivityID.PHOENIX_CHALLENGE
		table.insert.imgName = "worldMapPhoenix2"
		table.insert.folder = "worldMap"
		table.insert(config, table.insert)
		gKingdomClassType = table.insert
		table.insert.activityID = gActivityTimeActivityID.PHOENIX_CHALLENGE
		table.insert.imgName = "worldMapPhoenix3"
		table.insert.folder = "worldMap"
		table.insert(config, table.insert)
		gKingdomClassType = table.insert
		table.insert.imgName = "worldMapBossNormal"
		table.insert.folder = "worldMap"
		table.insert(config, table.insert)
		gKingdomClassType = table.insert
		table.insert.imgName = "worldMapBossSea"
		table.insert.folder = "worldMap"
		table.insert.checkEffect = true
		table.insert(config, table.insert)
		gKingdomClassType = table.insert
		table.insert.imgName = "worldMapBossSea2"
		table.insert.folder = "worldMap"
		table.insert.checkEffect = true
		table.insert(config, table.insert)
		local needEffectAnimation = false
		local needBossIcon = false
		for i, data in ipairs(config) do
			if not data.activityID or _G.clientEventMgr.judgeIsOpen(data.activityID) then
				if data.isLocal then
					gKingdomClassType = nil
					;(nil).name = string.format("%s/%s", data.folder, data.imgName)
					;(nil).format = "png"
					table.insert(imgArray, nil)
					if data.checkEffect then
						needEffectAnimation = true
					end
				else
					local ret = _G.SoraDIsFileExistByKey(data.imgName)
					_UPVALUE2_ = nil
					;(nil)[1] = ret
					;(nil)[2] = data.imgName
					dump(nil, "worldMapViewDef.getMapImage")
					if ret then
						gKingdomClassType = "worldMapViewDef.getMapImage"
						;("worldMapViewDef.getMapImage").name = string.format("%s/%s", data.folder, data.imgName)
						table.insert(imgArray, "worldMapViewDef.getMapImage")
						if data.checkEffect then
							needEffectAnimation = true
						end
					else
						needBossIcon = true
					end
				end
			end
		end
		if needBossIcon then
			gKingdomClassType = ipairs(config)
			ipairs(config).name = "worldMap/worldMapBossIcon"
			table.insert(imgArray, ipairs(config))
		end
		if needEffectAnimation then
			local ret = _G.SoraDIsFileExistByKey("worldMapEffectAnimation")
			if ret then
				gKingdomClassType = "worldMap/" .. imgName
				;("worldMap/" .. imgName).name = "worldMap/worldMapEffectAnimation"
				table.insert(imgArray, "worldMap/" .. imgName)
			end
		end
		do
			local ret = _G.SoraDIsFileExistByKey("chengwaiying")
			if ret then
				gKingdomClassType = "worldMap/" .. imgName
				;("worldMap/" .. imgName).name = "worldMap/chengwaiying"
				table.insert(imgArray, "worldMap/" .. imgName)
			end
		end
		local ret = _G.SoraDIsFileExistByKey("zyluotuo")
		if ret then
			worldMapDefine._hasCamelHdRes = true
			gKingdomClassType = "worldMap/" .. imgName
			;("worldMap/" .. imgName).name = "worldMap/zyluotuo"
			table.insert(imgArray, "worldMap/" .. imgName)
		end
	end
	if bAddLmqb then
		local ret = _G.SoraDIsFileExistByKey("worldMapLmzh")
		if ret then
			gKingdomClassType = romeActivityCtrl:isOpenRomeActivity()
			romeActivityCtrl:isOpenRomeActivity().name = "worldMap/worldMapLmzh"
			table.insert(imgArray, (romeActivityCtrl:isOpenRomeActivity()))
		else
			gKingdomClassType = romeActivityCtrl:isOpenRomeActivity()
			romeActivityCtrl:isOpenRomeActivity().name = "worldMap/worldMapLmzhIcon"
			table.insert(imgArray, (romeActivityCtrl:isOpenRomeActivity()))
		end
	end
	local ret = _G.SoraDIsFileExistByKey("worldMapTileEffect")
	if ret then
		worldMapDefine._hasTileEffectRes = true
		gKingdomClassType = romeActivityCtrl:isOpenRomeActivity()
		romeActivityCtrl:isOpenRomeActivity().name = "worldMap/worldMapTileEffect"
		table.insert(imgArray, (romeActivityCtrl:isOpenRomeActivity()))
	end
	local retThunder = _G.SoraDIsFileExistByKey("worldMapCastleThunder")
	if retThunder then
		gKingdomClassType = table.insert
		table.insert.name = "worldMap/worldMapCastleThunder"
		table.insert(imgArray, table.insert)
	end
	return imgArray
end
return worldMapViewDef
