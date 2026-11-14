local manorCityRead = include("aAReadClass").new()
_UPVALUE2_ = nil
_UPVALUE1_ = nil
_UPVALUE2_, _ENV, (nil).keyMap, (nil)[1] = "buildID", nil, nil, "buildID"
;(nil).tableFormat, (nil).buildUnlock, ("buildID")[1] = nil, "buildID", "bid"
;(nil).tableFormat, (nil).buildUnlock, ("buildID")[2] = nil, "buildID", "blv"
;(nil)[1] = "garden_build_info"
;(nil)[2] = true
manorCityRead:defineValue("garden_build_info", nil)
function manorCityRead.getBuildInfoConfig(buildID)
	return manorCityRead.garden_build_info[buildID]
end
function manorCityRead.getBuildMaxNum(buildID)
	local cfg = manorCityRead.getBuildInfoConfig(buildID)
	return cfg.buildNum
end
function manorCityRead.getBuildUnlock(buildID)
	local cfg = manorCityRead.getBuildInfoConfig(buildID)
	return cfg.buildUnlock
end
function manorCityRead.getBuildSize(buildID)
	local cfg = manorCityRead.getBuildInfoConfig(buildID)
	if cfg then
		return cfg.buildSize
	else
		return manorCityRead.getDressSize(buildID)
	end
end
function manorCityRead.getBuildName(buildID, extra)
	if buildID == MANOR_BUILD_ID.BANQUET and extra and extra.lv then
		local cfg = manorCityRead.getBanquetRewardConfig(extra.lv)
		return i18n(cfg.buildName)
	end
	local cfg = manorCityRead.getBuildInfoConfig(buildID)
	if cfg then
		return i18n(cfg.buildName)
	else
		return manorCityRead.getDressName(buildID)
	end
end
function manorCityRead.getBuildDes(buildID, extra)
	if buildID == MANOR_BUILD_ID.BANQUET and extra and extra.lv then
		local cfg = manorCityRead.getBanquetRewardConfig(extra.lv)
		return i18n(cfg.buildDes)
	end
	local cfg = manorCityRead.getBuildInfoConfig(buildID)
	if cfg then
		return i18n(cfg.buildDes)
	else
		return manorCityRead.getDressDes(buildID)
	end
end
function manorCityRead.getBuildImage(buildID, extra)
	if buildID == MANOR_BUILD_ID.BANQUET and extra and extra.lv then
		local cfg = manorCityRead.getBanquetRewardConfig(extra.lv)
		return cfg.buidIcon
	end
	local cfg = manorCityRead.getBuildInfoConfig(buildID)
	if cfg then
		return cfg.buidIcon
	else
		return manorCityRead.getDressImage(buildID)
	end
end
function manorCityRead.getBuildSmallImage(buildID)
	local cfg = manorCityRead.getBuildInfoConfig(buildID)
	if cfg then
		return cfg.build_small_icon
	else
		return manorCityRead.getDressSmallImage(buildID)
	end
end
function manorCityRead.getBuildType(buildID)
	local cfg = manorCityRead.getBuildInfoConfig(buildID)
	if cfg then
		return cfg.buildType
	else
		return MANOR_BUILD_TYPE.COLLECTION
	end
end
function manorCityRead.getIsShow(buildID)
	local cfg = manorCityRead.getBuildInfoConfig(buildID)
	if cfg then
		return cfg.isShow == 1
	else
		return false
	end
end
_UPVALUE2_ = nil
_UPVALUE1_ = nil
;(nil).keyList, (nil)[1] = nil, "buildType"
;(nil).insertKey = "buildID"
;(nil)[1] = "garden_build_info"
;(nil)[2] = true
manorCityRead:defineValue("buildIDListByType", nil)
function manorCityRead.getBuildIDListByType(buildType)
	local manorCityRead, ret
	if not manorCityRead.buildIDListByType[buildType] then
		local manorCityRead, buildList = manorCityRead.buildIDListByType[buildType], manorCityRead.buildIDListByType[buildType]
	end
	for __, v in pairs(buildList) do
		if manorCityRead.getIsShow(v) then
			table.insert(ret, v)
		end
	end
	return ret
end
manorCityRead:defineValue("buildUnlockMap", function()
	local _ENV, ret
	for buildID, _ in pairs(manorCityRead.garden_build_info) do
		local buildUnlock = manorCityRead.getBuildUnlock(buildID)
		for _, vv in ipairs(buildUnlock) do
			if not ret[vv.bid] then
				_ENV = ret[vv.bid]
			end
			ret[vv.bid] = ret[vv.bid]
			if not ret[vv.bid][vv.blv] then
				_ENV = ret[vv.bid][vv.blv]
			end
			ret[vv.bid][vv.blv] = ret[vv.bid][vv.blv]
			ret[vv.bid][vv.blv][buildID] = true
		end
	end
	return ret
end)
function manorCityRead.getBuildUnlockMap(buildID, buildLv)
	local cfg = manorCityRead.buildUnlockMap[buildID]
	if not cfg or not cfg[buildLv] then
		manorCityRead = cfg[buildLv]
	end
	return cfg[buildLv]
end
function manorCityRead.getBuild3101Config(buildLv)
	local config = manorCityRead.getBuildConfig(MANOR_BUILD_ID.MAIN)
	return config[buildLv]
end
function manorCityRead.getDressActiveMax(quality)
	local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
	local buildLv = manorCityCtrl:getBuildLvByBid(MANOR_BUILD_ID.MAIN)
	local cfg = manorCityRead.getBuild3101Config(buildLv)
	return cfg.decoration[quality] or 0
end
function manorCityRead.getBuildDecoration(buildID, buildLv)
	local cfg = manorCityRead.getBuildLvConfig(buildID, buildLv)
	if not cfg.decoration then
		manorCityRead = cfg.decoration
	end
	return cfg.decoration
end
manorCityRead:defineValue("dressActiveNumInfo", function()
	local manorCityRead, ret
	local dressQualityList = manorCityRead.getDressQualityList()
	local buildID = MANOR_BUILD_ID.MAIN
	local buildMaxLv = manorCityRead.getBuildMaxLv(buildID)
	for buildLv = 1, buildMaxLv do
		local decoration = manorCityRead.getBuildDecoration(buildID, buildLv)
		local isDiff = false
		if #ret == 0 then
			isDiff = true
		else
			local preData = ret[#ret]
			local preDecoration = preData.decoration
			for i, quality in ipairs(dressQualityList) do
				if (decoration[quality] or 0) ~= (preDecoration[quality] or 0) then
					isDiff = true
					break
				end
			end
		end
		if isDiff then
			manorCityRead = ipairs(dressQualityList)
			ipairs(dressQualityList).buildLv = buildLv
			ipairs(dressQualityList).decoration = clone(decoration)
			table.insert(ret, ipairs(dressQualityList))
		end
	end
	return ret
end)
function manorCityRead.getDressActiveNumInfo()
	return manorCityRead.dressActiveNumInfo
end
function manorCityRead.getBuildConfig(buildID)
	local fileName = "garden_build_" .. buildID
	local config = manorCityRead[fileName]
	if config then
		return config
	end
	local config = require_data(fileName, true, true).data
	manorCityRead[fileName] = config
	for k, v in pairs(config) do
		if not v.buff then
			manorCityRead = v.buff
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "value"
		v.buff = serviceFunctions.tableFormat(v.buff, nil)
		for _, vv in ipairs(v.buff) do
			vv.value = vv.value / 10
		end
		if not v.preCond then
			manorCityRead = v.preCond
		end
		_UPVALUE2_ = ipairs(v.buff)
		ipairs(v.buff)[1] = "bid"
		ipairs(v.buff)[2] = "blv"
		v.preCond = serviceFunctions.tableFormat(v.preCond, ipairs(v.buff))
		if not v.costItem then
			manorCityRead = v.costItem
		end
		_UPVALUE2_ = ipairs(v.buff)
		ipairs(v.buff)[1] = "id"
		ipairs(v.buff)[2] = "count"
		v.costItem = serviceFunctions.tableFormat(v.costItem, ipairs(v.buff))
		if not v.costRes then
			manorCityRead = v.costRes
		end
		_UPVALUE2_ = ipairs(v.buff)
		ipairs(v.buff)[1] = "id"
		ipairs(v.buff)[2] = "count"
		v.costRes = serviceFunctions.tableFormat(v.costRes, ipairs(v.buff))
		if not v.decoration then
			manorCityRead = v.decoration
		end
		v.decoration = serviceFunctions.tableFormatToMap(v.decoration)
	end
	return config
end
function manorCityRead.getBuildMaxLv(buildID)
	local config = manorCityRead.getBuildConfig(buildID)
	return #config
end
function manorCityRead.getBuildLvConfig(buildID, buildLv)
	local config = manorCityRead.getBuildConfig(buildID)
	return config[buildLv]
end
function manorCityRead.getBuildCostTime(buildID, buildLv)
	local cfg = manorCityRead.getBuildLvConfig(buildID, buildLv)
	return cfg.costTime or 0
end
function manorCityRead.getBuildPower(buildID, buildLv)
	local cfg = manorCityRead.getBuildLvConfig(buildID, buildLv)
	return cfg.power or 0
end
function manorCityRead.getBuildBuff(buildID, buildLv)
	local cfg = manorCityRead.getBuildLvConfig(buildID, buildLv)
	if not cfg.buff then
		manorCityRead = cfg.buff
	end
	return cfg.buff
end
function manorCityRead.getBuildPreCond(buildID, buildLv)
	local cfg = manorCityRead.getBuildLvConfig(buildID, buildLv)
	if not cfg.preCond then
		manorCityRead = cfg.preCond
	end
	return cfg.preCond
end
function manorCityRead.getBuildCostItem(buildID, buildLv)
	local cfg = manorCityRead.getBuildLvConfig(buildID, buildLv)
	if not cfg.costItem then
		manorCityRead = cfg.costItem
	end
	return cfg.costItem
end
function manorCityRead.getBuildCostRes(buildID, buildLv)
	local cfg = manorCityRead.getBuildLvConfig(buildID, buildLv)
	if not cfg.costRes then
		manorCityRead = cfg.costRes
	end
	return cfg.costRes
end
function _UPVALUE2_()
	local manorCityRead, ret
	local dressQualityList = manorCityRead.getDressQualityList()
	local buildID = MANOR_BUILD_ID.MAIN
	local buildMaxLv = manorCityRead.getBuildMaxLv(buildID)
	for buildLv = 1, buildMaxLv do
		local decoration = manorCityRead.getBuildDecoration(buildID, buildLv)
		local isDiff = false
		if #ret == 0 then
			isDiff = true
		else
			local preData = ret[#ret]
			local preDecoration = preData.decoration
			for i, quality in ipairs(dressQualityList) do
				if (decoration[quality] or 0) ~= (preDecoration[quality] or 0) then
					isDiff = true
					break
				end
			end
		end
		if isDiff then
			manorCityRead = ipairs(dressQualityList)
			ipairs(dressQualityList).buildLv = buildLv
			ipairs(dressQualityList).decoration = clone(decoration)
			table.insert(ret, ipairs(dressQualityList))
		end
	end
	return ret
end
;(function()
	local manorCityRead, ret
	local dressQualityList = manorCityRead.getDressQualityList()
	local buildID = MANOR_BUILD_ID.MAIN
	local buildMaxLv = manorCityRead.getBuildMaxLv(buildID)
	for buildLv = 1, buildMaxLv do
		local decoration = manorCityRead.getBuildDecoration(buildID, buildLv)
		local isDiff = false
		if #ret == 0 then
			isDiff = true
		else
			local preData = ret[#ret]
			local preDecoration = preData.decoration
			for i, quality in ipairs(dressQualityList) do
				if (decoration[quality] or 0) ~= (preDecoration[quality] or 0) then
					isDiff = true
					break
				end
			end
		end
		if isDiff then
			manorCityRead = ipairs(dressQualityList)
			ipairs(dressQualityList).buildLv = buildLv
			ipairs(dressQualityList).decoration = clone(decoration)
			table.insert(ret, ipairs(dressQualityList))
		end
	end
	return ret
end)[1] = "garden_map"
;(function()
	local manorCityRead, ret
	local dressQualityList = manorCityRead.getDressQualityList()
	local buildID = MANOR_BUILD_ID.MAIN
	local buildMaxLv = manorCityRead.getBuildMaxLv(buildID)
	for buildLv = 1, buildMaxLv do
		local decoration = manorCityRead.getBuildDecoration(buildID, buildLv)
		local isDiff = false
		if #ret == 0 then
			isDiff = true
		else
			local preData = ret[#ret]
			local preDecoration = preData.decoration
			for i, quality in ipairs(dressQualityList) do
				if (decoration[quality] or 0) ~= (preDecoration[quality] or 0) then
					isDiff = true
					break
				end
			end
		end
		if isDiff then
			manorCityRead = ipairs(dressQualityList)
			ipairs(dressQualityList).buildLv = buildLv
			ipairs(dressQualityList).decoration = clone(decoration)
			table.insert(ret, ipairs(dressQualityList))
		end
	end
	return ret
end)[2] = true
manorCityRead:defineValue("garden_map", function()
	local manorCityRead, ret
	local dressQualityList = manorCityRead.getDressQualityList()
	local buildID = MANOR_BUILD_ID.MAIN
	local buildMaxLv = manorCityRead.getBuildMaxLv(buildID)
	for buildLv = 1, buildMaxLv do
		local decoration = manorCityRead.getBuildDecoration(buildID, buildLv)
		local isDiff = false
		if #ret == 0 then
			isDiff = true
		else
			local preData = ret[#ret]
			local preDecoration = preData.decoration
			for i, quality in ipairs(dressQualityList) do
				if (decoration[quality] or 0) ~= (preDecoration[quality] or 0) then
					isDiff = true
					break
				end
			end
		end
		if isDiff then
			manorCityRead = ipairs(dressQualityList)
			ipairs(dressQualityList).buildLv = buildLv
			ipairs(dressQualityList).decoration = clone(decoration)
			table.insert(ret, ipairs(dressQualityList))
		end
	end
	return ret
end)
function manorCityRead.getGardenMapRange(buildLv)
	for i = #manorCityRead.garden_map, 1, -1 do
		local cfg = manorCityRead.garden_map[i]
		if buildLv >= cfg.buildLv then
			return cfg.mapRange, cfg.mapLv
		end
	end
	_UPVALUE4_ = (for index)
	;(#manorCityRead.garden_map)[1] = 0
	;(#manorCityRead.garden_map)[2] = 0
	;(#manorCityRead.garden_map)[3] = 0
	;(#manorCityRead.garden_map)[4] = 0
	return #manorCityRead.garden_map, 1
end
function _UPVALUE2_()
	local manorCityRead, ret
	local dressQualityList = manorCityRead.getDressQualityList()
	local buildID = MANOR_BUILD_ID.MAIN
	local buildMaxLv = manorCityRead.getBuildMaxLv(buildID)
	for buildLv = 1, buildMaxLv do
		local decoration = manorCityRead.getBuildDecoration(buildID, buildLv)
		local isDiff = false
		if #ret == 0 then
			isDiff = true
		else
			local preData = ret[#ret]
			local preDecoration = preData.decoration
			for i, quality in ipairs(dressQualityList) do
				if (decoration[quality] or 0) ~= (preDecoration[quality] or 0) then
					isDiff = true
					break
				end
			end
		end
		if isDiff then
			manorCityRead = ipairs(dressQualityList)
			ipairs(dressQualityList).buildLv = buildLv
			ipairs(dressQualityList).decoration = clone(decoration)
			table.insert(ret, ipairs(dressQualityList))
		end
	end
	return ret
end
;(function()
	local manorCityRead, ret
	local dressQualityList = manorCityRead.getDressQualityList()
	local buildID = MANOR_BUILD_ID.MAIN
	local buildMaxLv = manorCityRead.getBuildMaxLv(buildID)
	for buildLv = 1, buildMaxLv do
		local decoration = manorCityRead.getBuildDecoration(buildID, buildLv)
		local isDiff = false
		if #ret == 0 then
			isDiff = true
		else
			local preData = ret[#ret]
			local preDecoration = preData.decoration
			for i, quality in ipairs(dressQualityList) do
				if (decoration[quality] or 0) ~= (preDecoration[quality] or 0) then
					isDiff = true
					break
				end
			end
		end
		if isDiff then
			manorCityRead = ipairs(dressQualityList)
			ipairs(dressQualityList).buildLv = buildLv
			ipairs(dressQualityList).decoration = clone(decoration)
			table.insert(ret, ipairs(dressQualityList))
		end
	end
	return ret
end)[1] = "garden_vip_area"
;(function()
	local manorCityRead, ret
	local dressQualityList = manorCityRead.getDressQualityList()
	local buildID = MANOR_BUILD_ID.MAIN
	local buildMaxLv = manorCityRead.getBuildMaxLv(buildID)
	for buildLv = 1, buildMaxLv do
		local decoration = manorCityRead.getBuildDecoration(buildID, buildLv)
		local isDiff = false
		if #ret == 0 then
			isDiff = true
		else
			local preData = ret[#ret]
			local preDecoration = preData.decoration
			for i, quality in ipairs(dressQualityList) do
				if (decoration[quality] or 0) ~= (preDecoration[quality] or 0) then
					isDiff = true
					break
				end
			end
		end
		if isDiff then
			manorCityRead = ipairs(dressQualityList)
			ipairs(dressQualityList).buildLv = buildLv
			ipairs(dressQualityList).decoration = clone(decoration)
			table.insert(ret, ipairs(dressQualityList))
		end
	end
	return ret
end)[2] = true
manorCityRead:defineValue("garden_vip_area", function()
	local manorCityRead, ret
	local dressQualityList = manorCityRead.getDressQualityList()
	local buildID = MANOR_BUILD_ID.MAIN
	local buildMaxLv = manorCityRead.getBuildMaxLv(buildID)
	for buildLv = 1, buildMaxLv do
		local decoration = manorCityRead.getBuildDecoration(buildID, buildLv)
		local isDiff = false
		if #ret == 0 then
			isDiff = true
		else
			local preData = ret[#ret]
			local preDecoration = preData.decoration
			for i, quality in ipairs(dressQualityList) do
				if (decoration[quality] or 0) ~= (preDecoration[quality] or 0) then
					isDiff = true
					break
				end
			end
		end
		if isDiff then
			manorCityRead = ipairs(dressQualityList)
			ipairs(dressQualityList).buildLv = buildLv
			ipairs(dressQualityList).decoration = clone(decoration)
			table.insert(ret, ipairs(dressQualityList))
		end
	end
	return ret
end)
function manorCityRead.getVipAreaConfig(idx)
	local cfg = manorCityRead.garden_vip_area[idx]
	manorCityRead = nil
	;(nil).beginX = cfg.vertex_pos_X[1]
	;(nil).beginY = cfg.vertex_pos_X[2]
	;(nil).endX = cfg.vertex_pos_Y[1]
	local (nil).endY, ret = cfg.vertex_pos_Y[2], nil
	return ret
end
function manorCityRead.getIsInVipArea(tilePos)
	for idx, v in ipairs(manorCityRead.garden_vip_area) do
		local cfg = manorCityRead.getVipAreaConfig(idx)
		if tilePos.x >= cfg.beginX and tilePos.x <= cfg.endX and tilePos.y >= cfg.beginY and tilePos.y <= cfg.endY then
			return true, idx
		end
	end
	return false
end
function manorCityRead.getVipAreaPosList()
	local _ENV, ret
	for idx, __ in ipairs(manorCityRead.garden_vip_area) do
		local cfg = manorCityRead.getVipAreaConfig(idx)
		_ENV = idx
		idx.x = (cfg.beginX + cfg.endX) / 2
		local idx.y, centerPos = (cfg.beginY + cfg.endY) / 2, idx
		_ENV = nil
		;(nil).beginPos = cc.p(cfg.beginX, cfg.beginY)
		;(nil).centerPos = centerPos
		table.insert(ret, nil)
	end
	return ret
end
function _UPVALUE2_()
	local manorCityRead, ret
	local dressQualityList = manorCityRead.getDressQualityList()
	local buildID = MANOR_BUILD_ID.MAIN
	local buildMaxLv = manorCityRead.getBuildMaxLv(buildID)
	for buildLv = 1, buildMaxLv do
		local decoration = manorCityRead.getBuildDecoration(buildID, buildLv)
		local isDiff = false
		if #ret == 0 then
			isDiff = true
		else
			local preData = ret[#ret]
			local preDecoration = preData.decoration
			for i, quality in ipairs(dressQualityList) do
				if (decoration[quality] or 0) ~= (preDecoration[quality] or 0) then
					isDiff = true
					break
				end
			end
		end
		if isDiff then
			manorCityRead = ipairs(dressQualityList)
			ipairs(dressQualityList).buildLv = buildLv
			ipairs(dressQualityList).decoration = clone(decoration)
			table.insert(ret, ipairs(dressQualityList))
		end
	end
	return ret
end
;(function()
	local manorCityRead, ret
	local dressQualityList = manorCityRead.getDressQualityList()
	local buildID = MANOR_BUILD_ID.MAIN
	local buildMaxLv = manorCityRead.getBuildMaxLv(buildID)
	for buildLv = 1, buildMaxLv do
		local decoration = manorCityRead.getBuildDecoration(buildID, buildLv)
		local isDiff = false
		if #ret == 0 then
			isDiff = true
		else
			local preData = ret[#ret]
			local preDecoration = preData.decoration
			for i, quality in ipairs(dressQualityList) do
				if (decoration[quality] or 0) ~= (preDecoration[quality] or 0) then
					isDiff = true
					break
				end
			end
		end
		if isDiff then
			manorCityRead = ipairs(dressQualityList)
			ipairs(dressQualityList).buildLv = buildLv
			ipairs(dressQualityList).decoration = clone(decoration)
			table.insert(ret, ipairs(dressQualityList))
		end
	end
	return ret
end)[1] = "garden_villas_pos"
;(function()
	local manorCityRead, ret
	local dressQualityList = manorCityRead.getDressQualityList()
	local buildID = MANOR_BUILD_ID.MAIN
	local buildMaxLv = manorCityRead.getBuildMaxLv(buildID)
	for buildLv = 1, buildMaxLv do
		local decoration = manorCityRead.getBuildDecoration(buildID, buildLv)
		local isDiff = false
		if #ret == 0 then
			isDiff = true
		else
			local preData = ret[#ret]
			local preDecoration = preData.decoration
			for i, quality in ipairs(dressQualityList) do
				if (decoration[quality] or 0) ~= (preDecoration[quality] or 0) then
					isDiff = true
					break
				end
			end
		end
		if isDiff then
			manorCityRead = ipairs(dressQualityList)
			ipairs(dressQualityList).buildLv = buildLv
			ipairs(dressQualityList).decoration = clone(decoration)
			table.insert(ret, ipairs(dressQualityList))
		end
	end
	return ret
end)[2] = true
manorCityRead:defineValue("garden_villas_pos", function()
	local manorCityRead, ret
	local dressQualityList = manorCityRead.getDressQualityList()
	local buildID = MANOR_BUILD_ID.MAIN
	local buildMaxLv = manorCityRead.getBuildMaxLv(buildID)
	for buildLv = 1, buildMaxLv do
		local decoration = manorCityRead.getBuildDecoration(buildID, buildLv)
		local isDiff = false
		if #ret == 0 then
			isDiff = true
		else
			local preData = ret[#ret]
			local preDecoration = preData.decoration
			for i, quality in ipairs(dressQualityList) do
				if (decoration[quality] or 0) ~= (preDecoration[quality] or 0) then
					isDiff = true
					break
				end
			end
		end
		if isDiff then
			manorCityRead = ipairs(dressQualityList)
			ipairs(dressQualityList).buildLv = buildLv
			ipairs(dressQualityList).decoration = clone(decoration)
			table.insert(ret, ipairs(dressQualityList))
		end
	end
	return ret
end)
function manorCityRead.getVillasCostItem(idx)
	local cfg = manorCityRead.garden_villas_pos[idx]
	if not cfg.costItem then
		manorCityRead = cfg.costItem
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local costItem = serviceFunctions.tableFormat(cfg.costItem, nil)
	return costItem[1]
end
function manorCityRead.getVillasPos(idx)
	local cfg = manorCityRead.garden_villas_pos[idx]
	return cc.p(cfg.villas_pos_X, cfg.villas_pos_Y)
end
function manorCityRead.getIsInVillas(tilePos)
	for idx, v in ipairs(manorCityRead.garden_villas_pos) do
		local beginX = v.villas_pos_X
		local endX = beginX + 1
		local beginY = v.villas_pos_Y
		local endY = beginY + 1
		if beginX <= tilePos.x and endX >= tilePos.x and beginY <= tilePos.y and endY >= tilePos.y then
			return true, idx
		end
	end
	return false
end
function manorCityRead.getVillasPosList()
	local _ENV, ret
	for idx, v in ipairs(manorCityRead.garden_villas_pos) do
		if v.type == 1 then
			local pos = manorCityRead.getVillasPos(idx)
			table.insert(ret, pos)
		end
	end
	return ret
end
function _UPVALUE2_()
	local manorCityRead, ret
	local dressQualityList = manorCityRead.getDressQualityList()
	local buildID = MANOR_BUILD_ID.MAIN
	local buildMaxLv = manorCityRead.getBuildMaxLv(buildID)
	for buildLv = 1, buildMaxLv do
		local decoration = manorCityRead.getBuildDecoration(buildID, buildLv)
		local isDiff = false
		if #ret == 0 then
			isDiff = true
		else
			local preData = ret[#ret]
			local preDecoration = preData.decoration
			for i, quality in ipairs(dressQualityList) do
				if (decoration[quality] or 0) ~= (preDecoration[quality] or 0) then
					isDiff = true
					break
				end
			end
		end
		if isDiff then
			manorCityRead = ipairs(dressQualityList)
			ipairs(dressQualityList).buildLv = buildLv
			ipairs(dressQualityList).decoration = clone(decoration)
			table.insert(ret, ipairs(dressQualityList))
		end
	end
	return ret
end
_UPVALUE1_ = nil
_UPVALUE2_, _ENV, (function()
	local manorCityRead, ret
	local dressQualityList = manorCityRead.getDressQualityList()
	local buildID = MANOR_BUILD_ID.MAIN
	local buildMaxLv = manorCityRead.getBuildMaxLv(buildID)
	for buildLv = 1, buildMaxLv do
		local decoration = manorCityRead.getBuildDecoration(buildID, buildLv)
		local isDiff = false
		if #ret == 0 then
			isDiff = true
		else
			local preData = ret[#ret]
			local preDecoration = preData.decoration
			for i, quality in ipairs(dressQualityList) do
				if (decoration[quality] or 0) ~= (preDecoration[quality] or 0) then
					isDiff = true
					break
				end
			end
		end
		if isDiff then
			manorCityRead = ipairs(dressQualityList)
			ipairs(dressQualityList).buildLv = buildLv
			ipairs(dressQualityList).decoration = clone(decoration)
			table.insert(ret, ipairs(dressQualityList))
		end
	end
	return ret
end).keyList, (nil)[1] = "buildID", nil, nil, "buildID"
;(function()
	local manorCityRead, ret
	local dressQualityList = manorCityRead.getDressQualityList()
	local buildID = MANOR_BUILD_ID.MAIN
	local buildMaxLv = manorCityRead.getBuildMaxLv(buildID)
	for buildLv = 1, buildMaxLv do
		local decoration = manorCityRead.getBuildDecoration(buildID, buildLv)
		local isDiff = false
		if #ret == 0 then
			isDiff = true
		else
			local preData = ret[#ret]
			local preDecoration = preData.decoration
			for i, quality in ipairs(dressQualityList) do
				if (decoration[quality] or 0) ~= (preDecoration[quality] or 0) then
					isDiff = true
					break
				end
			end
		end
		if isDiff then
			manorCityRead = ipairs(dressQualityList)
			ipairs(dressQualityList).buildLv = buildLv
			ipairs(dressQualityList).decoration = clone(decoration)
			table.insert(ret, ipairs(dressQualityList))
		end
	end
	return ret
end).tableFormat, (nil).buff, ("buildID")[1] = nil, "buildID", "id"
;(function()
	local manorCityRead, ret
	local dressQualityList = manorCityRead.getDressQualityList()
	local buildID = MANOR_BUILD_ID.MAIN
	local buildMaxLv = manorCityRead.getBuildMaxLv(buildID)
	for buildLv = 1, buildMaxLv do
		local decoration = manorCityRead.getBuildDecoration(buildID, buildLv)
		local isDiff = false
		if #ret == 0 then
			isDiff = true
		else
			local preData = ret[#ret]
			local preDecoration = preData.decoration
			for i, quality in ipairs(dressQualityList) do
				if (decoration[quality] or 0) ~= (preDecoration[quality] or 0) then
					isDiff = true
					break
				end
			end
		end
		if isDiff then
			manorCityRead = ipairs(dressQualityList)
			ipairs(dressQualityList).buildLv = buildLv
			ipairs(dressQualityList).decoration = clone(decoration)
			table.insert(ret, ipairs(dressQualityList))
		end
	end
	return ret
end).tableFormat, (nil).buff, ("buildID")[2] = nil, "buildID", "value"
;(function()
	local manorCityRead, ret
	local dressQualityList = manorCityRead.getDressQualityList()
	local buildID = MANOR_BUILD_ID.MAIN
	local buildMaxLv = manorCityRead.getBuildMaxLv(buildID)
	for buildLv = 1, buildMaxLv do
		local decoration = manorCityRead.getBuildDecoration(buildID, buildLv)
		local isDiff = false
		if #ret == 0 then
			isDiff = true
		else
			local preData = ret[#ret]
			local preDecoration = preData.decoration
			for i, quality in ipairs(dressQualityList) do
				if (decoration[quality] or 0) ~= (preDecoration[quality] or 0) then
					isDiff = true
					break
				end
			end
		end
		if isDiff then
			manorCityRead = ipairs(dressQualityList)
			ipairs(dressQualityList).buildLv = buildLv
			ipairs(dressQualityList).decoration = clone(decoration)
			table.insert(ret, ipairs(dressQualityList))
		end
	end
	return ret
end)[1] = "decoration_config"
;(function()
	local manorCityRead, ret
	local dressQualityList = manorCityRead.getDressQualityList()
	local buildID = MANOR_BUILD_ID.MAIN
	local buildMaxLv = manorCityRead.getBuildMaxLv(buildID)
	for buildLv = 1, buildMaxLv do
		local decoration = manorCityRead.getBuildDecoration(buildID, buildLv)
		local isDiff = false
		if #ret == 0 then
			isDiff = true
		else
			local preData = ret[#ret]
			local preDecoration = preData.decoration
			for i, quality in ipairs(dressQualityList) do
				if (decoration[quality] or 0) ~= (preDecoration[quality] or 0) then
					isDiff = true
					break
				end
			end
		end
		if isDiff then
			manorCityRead = ipairs(dressQualityList)
			ipairs(dressQualityList).buildLv = buildLv
			ipairs(dressQualityList).decoration = clone(decoration)
			table.insert(ret, ipairs(dressQualityList))
		end
	end
	return ret
end)[2] = true
manorCityRead:defineValue("decoration_config2", function()
	local manorCityRead, ret
	local dressQualityList = manorCityRead.getDressQualityList()
	local buildID = MANOR_BUILD_ID.MAIN
	local buildMaxLv = manorCityRead.getBuildMaxLv(buildID)
	for buildLv = 1, buildMaxLv do
		local decoration = manorCityRead.getBuildDecoration(buildID, buildLv)
		local isDiff = false
		if #ret == 0 then
			isDiff = true
		else
			local preData = ret[#ret]
			local preDecoration = preData.decoration
			for i, quality in ipairs(dressQualityList) do
				if (decoration[quality] or 0) ~= (preDecoration[quality] or 0) then
					isDiff = true
					break
				end
			end
		end
		if isDiff then
			manorCityRead = ipairs(dressQualityList)
			ipairs(dressQualityList).buildLv = buildLv
			ipairs(dressQualityList).decoration = clone(decoration)
			table.insert(ret, ipairs(dressQualityList))
		end
	end
	return ret
end)
manorCityRead:defineValue("decoration_config", function()
	for __, cfg in pairs(manorCityRead.decoration_config2) do
		for __, v in pairs(cfg) do
			for __, vv in pairs(v.buff) do
				vv.value = vv.value / 10
			end
		end
	end
	return manorCityRead.decoration_config2
end)
function manorCityRead.getDressConfig(buildID, buildLv)
	return manorCityRead.decoration_config[buildID][buildLv]
end
function manorCityRead.getDressLvConfig(buildID)
	return manorCityRead.decoration_config[buildID]
end
function manorCityRead.getDressMaxLv(buildID)
	local config = manorCityRead.getDressLvConfig(buildID)
	return #config
end
function manorCityRead.getDressCostRes(buildID, buildLv)
	local cfg = manorCityRead.getDressConfig(buildID, buildLv)
	return cfg.costRes
end
function manorCityRead.getDressBuff(buildID, buildLv)
	local cfg = manorCityRead.getDressConfig(buildID, buildLv)
	return cfg.buff
end
function manorCityRead.getDressPower(buildID, buildLv)
	local cfg = manorCityRead.getDressConfig(buildID, buildLv)
	return cfg.power
end
function _UPVALUE2_()
	for __, cfg in pairs(manorCityRead.decoration_config2) do
		for __, v in pairs(cfg) do
			for __, vv in pairs(v.buff) do
				vv.value = vv.value / 10
			end
		end
	end
	return manorCityRead.decoration_config2
end
_UPVALUE1_ = nil
;(function()
	for __, cfg in pairs(manorCityRead.decoration_config2) do
		for __, v in pairs(cfg) do
			for __, vv in pairs(v.buff) do
				vv.value = vv.value / 10
			end
		end
	end
	return manorCityRead.decoration_config2
end).keyMap, (nil)[1] = nil, "buildID"
;(function()
	for __, cfg in pairs(manorCityRead.decoration_config2) do
		for __, v in pairs(cfg) do
			for __, vv in pairs(v.buff) do
				vv.value = vv.value / 10
			end
		end
	end
	return manorCityRead.decoration_config2
end)[1] = "decoration_des"
;(function()
	for __, cfg in pairs(manorCityRead.decoration_config2) do
		for __, v in pairs(cfg) do
			for __, vv in pairs(v.buff) do
				vv.value = vv.value / 10
			end
		end
	end
	return manorCityRead.decoration_config2
end)[2] = true
manorCityRead:defineValue("decoration_des", function()
	for __, cfg in pairs(manorCityRead.decoration_config2) do
		for __, v in pairs(cfg) do
			for __, vv in pairs(v.buff) do
				vv.value = vv.value / 10
			end
		end
	end
	return manorCityRead.decoration_config2
end)
function manorCityRead.getDressDesConfig(buildID)
	return manorCityRead.decoration_des[buildID]
end
function manorCityRead.getDressQuality(buildID)
	local cfg = manorCityRead.getDressDesConfig(buildID)
	return cfg.quality
end
_ENV, manorCityRead.getDressBg = function(buildID)
	local quality = manorCityRead.getDressQuality(buildID)
	return "frame_item_base_0" .. quality + 1 .. ".png"
end, function(buildID)
	local quality = manorCityRead.getDressQuality(buildID)
	return "frame_item_base_0" .. quality + 1 .. ".png"
end
;(function(buildID)
	local quality = manorCityRead.getDressQuality(buildID)
	return "frame_item_base_0" .. quality + 1 .. ".png"
end)[2] = "frame_manor_architecture_03.png"
;(function(buildID)
	local quality = manorCityRead.getDressQuality(buildID)
	return "frame_item_base_0" .. quality + 1 .. ".png"
end)[3] = "frame_manor_architecture_04.png"
local (function(buildID)
	local quality = manorCityRead.getDressQuality(buildID)
	return "frame_item_base_0" .. quality + 1 .. ".png"
end)[4], quality2ImageName = "frame_manor_architecture_01.png", function(buildID)
	local quality = manorCityRead.getDressQuality(buildID)
	return "frame_item_base_0" .. quality + 1 .. ".png"
end
function manorCityRead.getDressBg2(buildID)
	local quality = manorCityRead.getDressQuality(buildID)
	return manorCityRead.getDressBg2ByQuality(quality)
end
function manorCityRead.getDressBg2ByQuality(quality)
	return quality2ImageName[quality] or quality2ImageName[4]
end
function manorCityRead.getDressName(buildID)
	local cfg = manorCityRead.getDressDesConfig(buildID)
	return i18n(cfg.name)
end
function manorCityRead.getDressDes(buildID)
	local cfg = manorCityRead.getDressDesConfig(buildID)
	return i18n(cfg.des)
end
function manorCityRead.getDressImage(buildID)
	local cfg = manorCityRead.getDressDesConfig(buildID)
	return cfg.image
end
function manorCityRead.getDressSmallImage(buildID)
	local cfg = manorCityRead.getDressDesConfig(buildID)
	return cfg.small_image
end
function manorCityRead.getDressModel(buildID)
	local cfg = manorCityRead.getDressDesConfig(buildID)
	return cfg.model
end
function manorCityRead.getDressIsShow(buildID)
	local cfg = manorCityRead.getDressDesConfig(buildID)
	if cfg.if_scan == 2 then
		return false
	end
	local if_scan_time = cfg.if_scan_time
	if if_scan_time >= serviceFunctions.systemTime() then
		return false
	end
	return true
end
function manorCityRead.getDressSize(buildID)
	local cfg = manorCityRead.getDressDesConfig(buildID)
	return cfg.size
end
function manorCityRead.getDressGetWay(buildID)
	local cfg = manorCityRead.getDressDesConfig(buildID)
	return i18n(cfg.get_way)
end
function manorCityRead.getDressEffectPath(buildID)
	local cfg = manorCityRead.getDressDesConfig(buildID)
	local effect = cfg.effect
	if effect ~= "" then
		return "Effect/world/prefab/manor/" .. effect
	end
	return nil
end
_UPVALUE2_ = "decoration_des"
_UPVALUE1_ = "buildID"
;("decoration_des").keyMap, ("buildID")[1] = "buildID", "index"
;("decoration_des").insertKey = "buildID"
;("decoration_des")[1] = "decoration_des"
;("decoration_des")[2] = true
manorCityRead:defineValue("dressIDList", "decoration_des")
function manorCityRead.getDressIDList()
	local _ENV, ret
	for __, buildID in ipairs(manorCityRead.dressIDList) do
		if manorCityRead.getDressIsShow(buildID) then
			table.insert(ret, buildID)
		end
	end
	return ret
end
function manorCityRead.getDressIDMap()
	local manorCityRead, ret
	local dressIDList = manorCityRead.getDressIDList()
	for _, dressID in ipairs(dressIDList) do
		local quality = manorCityRead.getDressQuality(dressID)
		if not ret[quality] then
			manorCityRead = ret[quality]
		end
		ret[quality] = ret[quality]
		table.insert(ret[quality], dressID)
	end
	return ret
end
manorCityRead:defineValue("dressQualityList", function()
	local _ENV, map
	for __, v in pairs(manorCityRead.decoration_des) do
		map[v.quality] = true
	end
	local ret = table.keys(map)
	table.sort(ret, function(a, b)
		return b < a
	end)
	return ret
end)
function manorCityRead.getDressQualityList()
	return manorCityRead.dressQualityList
end
function manorCityRead.getDressQualityName(quality)
	_ENV = nil
	;(nil)[4] = i18n("decoration_text_01")
	;(nil)[3] = i18n("atlantiswar_skill_text_018")
	local (nil)[2], config = i18n("atlantiswar_skill_text_020"), nil
	return config[quality] or quality
end
function manorCityRead.getDressQualityBg(quality)
	return "frame_zhuangyuan_pinzhi0" .. quality .. ".png"
end
function manorCityRead.getDressQualityDetailBg(quality)
	return "frame_zhuangyuan_tipspinzhi0" .. quality .. ".png"
end
function _UPVALUE2_()
	local _ENV, map
	for __, v in pairs(manorCityRead.decoration_des) do
		map[v.quality] = true
	end
	local ret = table.keys(map)
	table.sort(ret, function(a, b)
		return b < a
	end)
	return ret
end
_UPVALUE1_ = "buildID"
;(function()
	local _ENV, map
	for __, v in pairs(manorCityRead.decoration_des) do
		map[v.quality] = true
	end
	local ret = table.keys(map)
	table.sort(ret, function(a, b)
		return b < a
	end)
	return ret
end).keyMap, ("buildID")[1] = "buildID", "Item_ID"
;(function()
	local _ENV, map
	for __, v in pairs(manorCityRead.decoration_des) do
		map[v.quality] = true
	end
	local ret = table.keys(map)
	table.sort(ret, function(a, b)
		return b < a
	end)
	return ret
end)[1] = "decoration_item"
;(function()
	local _ENV, map
	for __, v in pairs(manorCityRead.decoration_des) do
		map[v.quality] = true
	end
	local ret = table.keys(map)
	table.sort(ret, function(a, b)
		return b < a
	end)
	return ret
end)[2] = true
manorCityRead:defineValue("decoration_item", function()
	local _ENV, map
	for __, v in pairs(manorCityRead.decoration_des) do
		map[v.quality] = true
	end
	local ret = table.keys(map)
	table.sort(ret, function(a, b)
		return b < a
	end)
	return ret
end)
function manorCityRead.getDressItemConfig(itemId)
	return manorCityRead.decoration_item[itemId]
end
function manorCityRead.getDressItemName(itemId)
	local cfg = manorCityRead.getDressItemConfig(itemId)
	return i18n(cfg.Name)
end
function manorCityRead.getDressItemDes(itemId)
	local cfg = manorCityRead.getDressItemConfig(itemId)
	return i18n(cfg.Describe)
end
function manorCityRead.getDressItemIcon(itemId, fromMemory)
	local cfg = manorCityRead.getDressItemConfig(itemId)
	local icon = cfg.Icon
	if fromMemory then
		return "#" .. icon
	else
		return icon
	end
end
function manorCityRead.getDressItemQuality(itemId)
	local cfg = manorCityRead.getDressItemConfig(itemId)
	return cfg.itemQuality
end
function manorCityRead.getDressItemPieceID(itemId)
	local cfg = manorCityRead.getDressItemConfig(itemId)
	return cfg.Universal_Token
end
function manorCityRead.getDressItemBg(itemId)
	local quality = manorCityRead.getDressItemQuality(itemId)
	return "frame_item_base_0" .. quality + 1 .. ".png"
end
manorCityRead:defineValue("pieceIDList", function()
	local _ENV, temp
	for __, v in pairs(manorCityRead.decoration_item) do
		local pieceID = v.Universal_Token
		temp[pieceID] = true
	end
	local ret = table.keys(temp)
	table.sort(ret)
	return ret
end)
function manorCityRead.getPieceIDList()
	return manorCityRead.pieceIDList
end
function _UPVALUE2_()
	local _ENV, temp
	for __, v in pairs(manorCityRead.decoration_item) do
		local pieceID = v.Universal_Token
		temp[pieceID] = true
	end
	local ret = table.keys(temp)
	table.sort(ret)
	return ret
end
_UPVALUE1_ = "buildID"
;(function()
	local _ENV, temp
	for __, v in pairs(manorCityRead.decoration_item) do
		local pieceID = v.Universal_Token
		temp[pieceID] = true
	end
	local ret = table.keys(temp)
	table.sort(ret)
	return ret
end).keyMap, ("buildID")[1] = "buildID", "banquetType"
;(function()
	local _ENV, temp
	for __, v in pairs(manorCityRead.decoration_item) do
		local pieceID = v.Universal_Token
		temp[pieceID] = true
	end
	local ret = table.keys(temp)
	table.sort(ret)
	return ret
end)[1] = "garden_banquet_reward"
;(function()
	local _ENV, temp
	for __, v in pairs(manorCityRead.decoration_item) do
		local pieceID = v.Universal_Token
		temp[pieceID] = true
	end
	local ret = table.keys(temp)
	table.sort(ret)
	return ret
end)[2] = true
manorCityRead:defineValue("banquet_reward", function()
	local _ENV, temp
	for __, v in pairs(manorCityRead.decoration_item) do
		local pieceID = v.Universal_Token
		temp[pieceID] = true
	end
	local ret = table.keys(temp)
	table.sort(ret)
	return ret
end)
function manorCityRead.getBanquetRewardConfig(banquetType)
	return manorCityRead.banquet_reward[banquetType]
end
function manorCityRead.getBanquetTypeMax()
	local max = 0
	for banquetType, _ in pairs(manorCityRead.banquet_reward) do
		if banquetType > max then
			max = banquetType
		end
	end
	return max
end
return manorCityRead
