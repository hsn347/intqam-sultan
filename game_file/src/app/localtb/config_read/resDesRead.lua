local resDesRead = include("aAReadClass").new()
_UPVALUE1_ = nil
;(nil)[1] = "resinfo"
resDesRead:defineValue("Resinfo", nil)
function resDesRead.getIcon(rid, fromMemory)
	rid = tonumber(rid)
	local fileName = resDesRead.Resinfo[rid] and resDesRead.Resinfo[rid].sIcon or ""
	if rid == gIDDef.GOLD then
		return "icon_main_gold.png"
	end
	if fromMemory then
		return "#" .. fileName
	end
	return fileName
end
function resDesRead.getMIcon(rid)
	rid = tonumber(rid)
	return resDesRead.Resinfo[rid] and resDesRead.Resinfo[rid].mIcon or "icon_middle_food.png"
end
function resDesRead.getBIcon(rid, fromMemory)
	rid = tonumber(rid)
	local fileName = resDesRead.checkIsSummonItem(rid, "bIcon") or resDesRead.Resinfo[rid] and resDesRead.Resinfo[rid].bIcon or "icon_big_food.png"
	if fromMemory then
		fileName = "#" .. fileName
	end
	return fileName
end
function resDesRead.checkIsSummonItem(rid, key)
	_ENV, _UPVALUE2_, _ENV = nil, nil, nil
	;(nil).name = "summoned_text_38"
	;(nil).des = "summoned_text_38"
	;(nil).sIcon = "1033.png"
	;(nil).mIcon = "1033.png"
	_ENV, (nil).bIcon = nil, "1033.png"
	;(nil).name = "summoned_text_64"
	;(nil).des = "summoned_text_64"
	;(nil).sIcon = "1033.png"
	;(nil).mIcon = "1033.png"
	;(nil).bIcon = "1033.png"
	_ENV, _UPVALUE2_, (nil)[1033], (nil)[1] = nil, nil, nil, nil
	_ENV, _UPVALUE2_, (nil)[1033], (nil)[2] = nil, nil, nil, nil
	;(nil).name = "summoned_text_34"
	;(nil).des = "summoned_text_35"
	;(nil).sIcon = "1034.png"
	;(nil).mIcon = "1034.png"
	_ENV, (nil).bIcon = nil, "1034.png"
	;(nil).name = "summoned_text_53"
	;(nil).des = "summoned_text_60"
	;(nil).sIcon = "icon_csyx_jsjm.png"
	;(nil).mIcon = "icon_csyx_jsjm.png"
	;(nil).bIcon = "icon_csyx_jsjm.png"
	_ENV, _UPVALUE2_, (nil)[1034], (nil)[1] = nil, nil, nil, nil
	_ENV, _UPVALUE2_, (nil)[1034], (nil)[2] = nil, nil, nil, nil
	;(nil).name = "summoned_text_36"
	;(nil).des = "summoned_text_37"
	;(nil).sIcon = "1035.png"
	;(nil).mIcon = "1035.png"
	_ENV, (nil).bIcon = nil, "1035.png"
	;(nil).name = "summoned_text_63"
	;(nil).des = "summoned_text_65"
	;(nil).sIcon = "1035_2.png"
	;(nil).mIcon = "1035_2.png"
	;(nil).bIcon = "1035_2.png"
	_ENV, _UPVALUE2_, _ENV, (nil)[1035], (nil)[1] = nil, nil, nil, nil, nil
	_ENV, _UPVALUE2_, _ENV, (nil)[1035], (nil)[2] = nil, nil, nil, nil, nil
	local tbl
	;(nil).name = "summoned_text_38"
	;(nil).des = "summoned_text_38"
	;(nil).sIcon = "1033.png"
	;(nil).mIcon = "1033.png"
	_ENV, (nil).bIcon = nil, "1033.png"
	;(nil).name = "summoned_text_64"
	;(nil).des = "summoned_text_64"
	;(nil).sIcon = "1033.png"
	;(nil).mIcon = "1033.png"
	;(nil).bIcon = "1033.png"
	_ENV, _UPVALUE2_, (nil)[1035], (nil)[1] = nil, nil, nil, nil
	_ENV, _UPVALUE2_, (nil)[1035], (nil)[2] = nil, nil, nil, nil
	;(nil).name = "summoned_text_34"
	;(nil).des = "summoned_text_35"
	;(nil).sIcon = "1034.png"
	;(nil).mIcon = "1034.png"
	_ENV, (nil).bIcon = nil, "1034.png"
	;(nil).name = "summoned_text_53"
	;(nil).des = "summoned_text_60"
	;(nil).sIcon = "icon_csyx_jsjm.png"
	;(nil).mIcon = "icon_csyx_jsjm.png"
	;(nil).bIcon = "icon_csyx_jsjm.png"
	_ENV, _UPVALUE2_, (nil)[1036], (nil)[1] = nil, nil, nil, nil
	_ENV, _UPVALUE2_, (nil)[1036], (nil)[2] = nil, nil, nil, nil
	;(nil).name = "summoned_text_36"
	;(nil).des = "summoned_text_37"
	;(nil).sIcon = "1035.png"
	;(nil).mIcon = "1035.png"
	_ENV, (nil).bIcon = nil, "1035.png"
	;(nil).name = "summoned_text_63"
	;(nil).des = "summoned_text_65"
	;(nil).sIcon = "1035_2.png"
	;(nil).mIcon = "1035_2.png"
	;(nil).bIcon = "1035_2.png"
	;(nil)[1037], (nil)[1] = nil, nil
	;(nil)[1037], (nil)[2] = nil, nil
	local tbl_ros
	if IsArClient and tbl[rid] or not IsArClient and tbl_ros[rid] then
		local royalSummonsCtrl = SoraDGetCtrl("royalSummonsCtrl")
		local activityType = royalSummonsCtrl:getClassType()
		return IsArClient and tbl[rid][activityType][key] or tbl_ros[rid][activityType][key]
	end
	return false
end
function resDesRead.checkResID(rid)
	return resDesRead.Resinfo[rid] ~= nil
end
function resDesRead.getUnLockLevel(rid)
	rid = tonumber(rid)
	local info = resDesRead.Resinfo[rid]
	if info then
		return info.lockLevel
	else
		return 1
	end
end
function resDesRead.isStarBuildUnLock(rid)
	rid = tonumber(rid)
	local info = resDesRead.Resinfo[rid]
	if info then
		if info.lv and next(info.lv) then
			if rid == gIDDef.METEOR_CRYSTAL or rid == gIDDef.METEOR_CRYSTAL_SAFE then
				return SoraDGetBuildStarLv() >= include("constantRead").getConstValue("CRYSTAL_SHOW_STAR_LEVEL", 54)
			else
				return SoraDGetBuildStarLv(info.lv[1]) >= info.lv[2]
			end
		else
			return true
		end
	else
		return false
	end
end
function resDesRead.checkCastleLevelCond(rid)
	if not rid then
		return
	end
	local gametop = gModuleMgr.getObject("gametop")
	local level = resDesRead.getUnLockLevel(rid)
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local curLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
	if level > curLevel then
		return false, gErrDef.Err_CASTLE_LEVEL_IS_NOT_REACHED, level
	end
	return true
end
function resDesRead.getItemList(rid, isIncludeSafe)
	rid = tonumber(rid)
	local _ENV, rList = tonumber(rid), tonumber(rid)
	local gametop = gModuleMgr.getObject("gametop")
	local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
	_ENV, _ENV = nil, "backpackltCtrl"
	;(nil).list = backpackltCtrl:getItemArray(gItemType.MITHRIL)
	_ENV, ("backpackltCtrl")[1005], (nil).safe = nil, nil, gItemType.SAFE_SECRET
	;(nil).list = backpackltCtrl:getItemArray(gItemType.IRON)
	_ENV, ("backpackltCtrl")[1004], (nil).safe = nil, nil, gItemType.SAFE_IRON
	;(nil).list = backpackltCtrl:getItemArray(gItemType.FOOD)
	_ENV, ("backpackltCtrl")[1002], (nil).safe = nil, nil, gItemType.SAFE_FOOD
	;(nil).list = backpackltCtrl:getItemArray(gItemType.WOOD)
	_ENV, ("backpackltCtrl")[1003], (nil).safe = nil, nil, gItemType.SAFE_WOOD
	;(nil).list = backpackltCtrl:getItemArray(gItemType.CRYSTAL)
	_ENV, ("backpackltCtrl")[1027], (nil).safe = nil, nil, gItemType.SAFE_CRYSTAL
	;(nil).list = backpackltCtrl:getItemArray(gItemType.METEOR_CRYSTAL)
	_ENV, ("backpackltCtrl")[1620], (nil).safe = nil, nil, gItemType.SAFE_METEOR_CRYSTAL
	_ENV, ("backpackltCtrl")[1707], (nil).list = nil, nil, backpackltCtrl:getItemArray(gItemType.GILDED_CRYSTAL)
	;("backpackltCtrl")[1723], (nil).list = nil, backpackltCtrl:getItemArray(gItemType.GILDED_CURE_ESSENCE)
	local resItemList = "backpackltCtrl"
	if resItemList[rid] == nil then
		_ENV = resItemList[rid]
		return resItemList[rid]
	end
	table.insertto(rList, resItemList[rid].list)
	if isIncludeSafe then
		if not backpackltCtrl:getItemArray(resItemList[rid].safe) then
			local _ENV, safeList = backpackltCtrl:getItemArray(resItemList[rid].safe), backpackltCtrl:getItemArray(resItemList[rid].safe)
		end
		for k, v in ipairs(safeList) do
			if not SoraDisInList(v, rList) then
				table.insert(rList, v)
			end
		end
	end
	return rList
end
function resDesRead.getTreasureIcon(rid)
	_ENV, rid = tonumber(rid), tonumber(rid)
	tonumber(rid)[1006] = "icon_treasure_steel.png"
	tonumber(rid)[1005] = "icon_treasure_silver.png"
	tonumber(rid)[1004] = "icon_treasure_iron.png"
	tonumber(rid)[1002] = "icon_treasure_food.png"
	tonumber(rid)[1003] = "icon_treasure_wood.png"
	tonumber(rid)[1027] = "icon_big_crystal.png"
	tonumber(rid)[1620] = "1620.png"
	tonumber(rid)[1707] = "1707.png"
	local tonumber(rid)[1723], resItemList = "1723.png", tonumber(rid)
	return resItemList[rid]
end
function resDesRead.getBg(rid)
	local quality = resDesRead.getQuality(rid)
	return string.format("frame_item_base_0%d.png", quality)
end
function resDesRead.getQuality(rid)
	local defaultQuality = 1
	_ENV = nil
	;(nil)[gIDDef.GOLD] = 5
	;(nil)[gIDType.ALLIANCE_SCORE] = 4
	;(nil)[gIDType.ALLIANCE_HONOR] = 4
	;(nil)[gIDDef.DECORATE_POINT] = 5
	local (nil)[gIDDef.PET_POINT], resItemList = 5, nil
	if resItemList[rid] then
		defaultQuality = resItemList[rid]
	elseif resDesRead.Resinfo[rid] then
		local cfg = resDesRead.Resinfo[rid]
		if cfg.itemQuality then
			defaultQuality = cfg.itemQuality + 1
		end
	end
	return defaultQuality
end
function resDesRead.getName(rid)
	rid = tonumber(rid)
	if resDesRead.Resinfo[rid] and #resDesRead.Resinfo[rid].name > 0 then
		if resDesRead.checkIsSummonItem(rid, "name") then
			return i18n(resDesRead.checkIsSummonItem(rid, "name"))
		elseif #resDesRead.Resinfo[rid].name > 0 then
			return i18n(resDesRead.Resinfo[rid].name)
		end
		return "???"
	else
		return "???"
	end
end
function resDesRead.getDes(rid)
	rid = tonumber(rid)
	local des = ""
	if resDesRead.Resinfo[rid] then
		des = i18n(resDesRead.checkIsSummonItem(rid, "des") or resDesRead.Resinfo[rid].des or resDesRead.Resinfo[rid].name)
	else
		_ENV = rid
		rid.des = "??????"
		des = i18n("common_text_1437", rid)
	end
	return des
end
return resDesRead
