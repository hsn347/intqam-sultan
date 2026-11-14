local cityltCtrl = include("aAReadClass").new()
_UPVALUE23_ = "aAReadClass"
;("aAReadClass")[1] = 101
;("aAReadClass")[2] = 102
;("aAReadClass")[3] = 103
;("aAReadClass")[4] = 104
;("aAReadClass")[5] = 105
;("aAReadClass")[6] = 111
;("aAReadClass")[7] = 112
;("aAReadClass")[8] = 113
;("aAReadClass")[9] = 114
;("aAReadClass")[10] = 115
;("aAReadClass")[11] = 116
;("aAReadClass")[12] = 117
;("aAReadClass")[13] = 118
;("aAReadClass")[14] = 119
;("aAReadClass")[15] = 120
;("aAReadClass")[16] = 121
;("aAReadClass")[17] = 122
;("aAReadClass")[18] = 123
;("aAReadClass")[19] = 124
;("aAReadClass")[20] = 125
;("aAReadClass")[21] = 201
;("aAReadClass")[22] = 202
;("aAReadClass")[23] = 203
;("aAReadClass")[24] = 204
;("aAReadClass")[25] = 205
;("aAReadClass")[26] = 206
;("aAReadClass")[27] = 207
;("aAReadClass")[28] = 301
;("aAReadClass")[29] = 302
local ("aAReadClass")[30], buildIdList = 305, "aAReadClass"
function cityltCtrl.init()
	cityltCtrl:defineValue("buildInfo", function()
		cityltCtrl.buildInfo, cityltCtrl = nil, nil
		local binfo = require_once("app." .. LocalTblPath .. ".config_server.buildinfo")
		for i, v in ipairs(binfo) do
			cityltCtrl.buildInfo[v.bid] = v
		end
		return cityltCtrl.buildInfo
	end)
	cityltCtrl:defineValue("buildList", function()
		cityltCtrl.buildList, cityltCtrl = nil, nil
		for i, bid in ipairs(buildIdList) do
			local path = "app." .. LocalTblPath .. ".config_server.build" .. bid
			local buildcell = require_once(path)
			cityltCtrl.buildList[bid], cityltCtrl = bid, bid
			for k, lvinfo in ipairs(buildcell) do
				cityltCtrl.buildList[bid][lvinfo.blv] = lvinfo
			end
		end
		return cityltCtrl.buildList
	end)
	cityltCtrl:defineValue("buildStarList", function()
		cityltCtrl.buildStarList, cityltCtrl = nil, nil
		for bid, v in pairs(cityltCtrl.buildInfo) do
			if v.openstar and v.openstar == 1 then
				local path = "app." .. LocalTblPath .. ".config_server.buildstar" .. bid
				local buildcell = require_once(path)
				cityltCtrl.buildStarList[bid], cityltCtrl = bid, bid
				for k, lvinfo in ipairs(buildcell) do
					cityltCtrl.buildStarList[bid][lvinfo.starlv] = lvinfo
				end
			end
		end
		return cityltCtrl.buildStarList
	end)
	cityltCtrl:defineValue("opengroundinfo", function()
		cityltCtrl.opengroundinfo, cityltCtrl = nil, nil
		local opengroundinfo = require_once("app." .. LocalTblPath .. ".config_server.opengroundinfo")
		for i, v in ipairs(opengroundinfo) do
			cityltCtrl.opengroundinfo[v.areaid] = v
		end
		return cityltCtrl.opengroundinfo
	end)
	cityltCtrl:defineValue("statueBraveInfo", function()
		cityltCtrl.statueBraveInfo, cityltCtrl = nil, nil
		local statueBraveInfo = require_once("app." .. LocalTblPath .. ".config_client.buildstar304_config")
		for i, v in ipairs(statueBraveInfo) do
			cityltCtrl.statueBraveInfo[v.starlv] = v
		end
		return cityltCtrl.statueBraveInfo
	end)
	local createData = function(name)
		cityltCtrl.buildAppointType, cityltCtrl, cityltCtrl.buildAppoint, cityltCtrl = nil, nil, nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.build_appoint")
		for i, v in ipairs(cfg) do
			cityltCtrl.buildAppoint[v.buildID] = v
			if not cityltCtrl.buildAppointType[v.buildType] then
				cityltCtrl.buildAppointType[v.buildType], cityltCtrl = nil, nil
			end
			table.insert(cityltCtrl.buildAppointType[v.buildType], v)
		end
		if name == "buildAppoint" then
			return cityltCtrl.buildAppoint
		elseif name == "buildAppointType" then
			return cityltCtrl.buildAppointType
		end
	end
	cityltCtrl:defineValue("buildAppoint", createData)
	cityltCtrl:defineValue("buildAppointType", createData)
end
function cityltCtrl.getQualityByStarLv(starlv)
	if not cityltCtrl.statueBraveInfo[starlv] then
		cityltCtrl = cityltCtrl.statueBraveInfo[starlv]
	end
	return cityltCtrl.statueBraveInfo[starlv]
end
function cityltCtrl.getStarBraveStatueLvStr(starlv)
	local info = cityltCtrl.getQualityByStarLv(starlv)
	local quality = info.quality or 1
	local lv = info.level or 1
	local qualityName = cityltCtrl.getStatueBraveQualityName(quality)
	cityltCtrl = nil
	;(nil).quality = qualityName
	;(nil).lv = lv
	local nameStr = i18n("Soldiers_armor_text_60", nil)
	return nameStr
end
function cityltCtrl.getStarLvByQualityAndLv(quality, lv)
	for starlv, v in ipairs(cityltCtrl.statueBraveInfo) do
		if v.quality == quality and v.level == lv then
			return starlv
		end
	end
	return cityltCtrl.buildAttr(BUILDID.STAR_BRAVE_STATUE, BUILD_ATTR.MAXSTARLV)
end
function cityltCtrl.getShowMaxLv(bid)
	local retLv = 1
	local quality = SoraDGetBuildQuality()
	for starlv, v in ipairs(cityltCtrl.statueBraveInfo) do
		if quality < v.quality then
			break
		end
		retLv = starlv
	end
	print("getShowMaxLv", quality, retLv)
	return retLv
end
function cityltCtrl.buildAttr(bid, attr)
	local buildcell = cityltCtrl.buildInfo[bid]
	if buildcell then
		local ret = buildcell[attr]
		if ret then
			return ret
		else
		end
	else
	end
end
function cityltCtrl.buildLvInfo(bid, blv, key, isStar)
	if isStar then
		return cityltCtrl.buildStarLvInfo(bid, blv, key)
	end
	local buildcell = cityltCtrl.buildList[bid]
	if buildcell then
		local lvinfo = buildcell[blv]
		if lvinfo then
			local ret = lvinfo[key]
			if ret then
				return ret
			else
			end
		else
		end
	else
	end
end
function cityltCtrl.buildStarLvInfo(bid, blv, key)
	local buildcell = cityltCtrl.buildStarList[bid]
	if buildcell and buildcell[blv] and buildcell[blv][key] then
		return buildcell[blv][key]
	end
end
function cityltCtrl.getMaxbuildStarLv(bid)
	local buildcell = cityltCtrl.buildStarList[bid]
	if buildcell then
		local maxLv = 0
		for lv, _ in pairs(buildcell) do
			if lv > maxLv then
				maxLv = lv
			end
		end
		return maxLv
	end
	return 0
end
function cityltCtrl.getCanBuildIdList(btype)
	local _ENV, ret
	for i, bid in ipairs(buildIdList) do
		local isbuild = cityltCtrl.buildAttr(bid, BUILD_ATTR.ISBUILD)
		local _btype = cityltCtrl.buildAttr(bid, BUILD_ATTR.BTYPE)
		if isbuild ~= 0 and _btype == btype then
			table.insert(ret, bid)
		end
	end
	return ret
end
function cityltCtrl.getPowerReward(bid, blv, isStar)
	local ret = 0
	if 1 < blv then
		local prepower = cityltCtrl.buildLvInfo(bid, blv - 1, BUILD_LVINFO.POWER, isStar)
		local newpower = cityltCtrl.buildLvInfo(bid, blv, BUILD_LVINFO.POWER, isStar)
		if prepower and newpower then
			ret = newpower - prepower
		end
	else
		ret = cityltCtrl.buildLvInfo(bid, blv, BUILD_LVINFO.POWER, isStar)
	end
	return ret
end
function cityltCtrl.getBoostGold(bid, blv, starlv)
	local ret = 0
	if 1 < blv then
		local preNum = cityltCtrl.buildLvInfo(bid, blv, "addOutputCostGold") or 0
		local newNum = cityltCtrl.buildLvInfo(bid, starlv, "addOutputCostGold", true) or 0
		ret = preNum + newNum
	end
	return ret
end
function cityltCtrl.getOpenGoundInfo(areaid, param)
	local areainfo = cityltCtrl.opengroundinfo[areaid]
	if areainfo then
		local ret = areainfo[param]
		if ret then
			return ret
		else
			return areainfo
		end
	else
	end
end
function cityltCtrl.isOpenWL(bid)
	local ret = cityltCtrl.buildAttr(bid, BUILD_ATTR.OPENWL)
	if ret then
		if 0 == ret then
			return false
		elseif 1 == ret then
			return true
		end
	end
end
function cityltCtrl.isOpenStar(bid)
	local ret = cityltCtrl.buildAttr(bid, BUILD_ATTR.OPENSTAR)
	return ret and ret == 1
end
function cityltCtrl.getDailyElitePointLimit(blv)
	local bid = BUILDID.ELITE_PALACE
	local key = "ElitePointLimit"
	local buildLogic = include("buildLogic")
	return buildLogic.getBuildBaseValue(bid, key)
end
function cityltCtrl.getSoldierLimit(blv)
	local bid = BUILDID.ELITE_PALACE
	local key = "maxSoldier"
	local buildLogic = include("buildLogic")
	return buildLogic.getBuildBaseValue(bid, key)
end
function cityltCtrl.getBuildStarImage(starLv)
	local color = cityltCtrl.getBuildStarColor(starLv)
	return cityltCtrl.getBuildStarImageByColor(color)
end
function cityltCtrl.getBuildStarImageByColor(color)
	return string.format("icon_build_star_0%d.png", color)
end
_ENV, cityltCtrl.getBuildStarLight = function(starLv)
	local color = cityltCtrl.getBuildStarColor(starLv)
	local iconName = string.format("icon_buildstar_light_%d.png", color)
	return iconName
end, function(starLv)
	local color = cityltCtrl.getBuildStarColor(starLv)
	local iconName = string.format("icon_buildstar_light_%d.png", color)
	return iconName
end
;(function(starLv)
	local color = cityltCtrl.getBuildStarColor(starLv)
	local iconName = string.format("icon_buildstar_light_%d.png", color)
	return iconName
end)[1] = 0
;(function(starLv)
	local color = cityltCtrl.getBuildStarColor(starLv)
	local iconName = string.format("icon_buildstar_light_%d.png", color)
	return iconName
end)[2] = 6
;(function(starLv)
	local color = cityltCtrl.getBuildStarColor(starLv)
	local iconName = string.format("icon_buildstar_light_%d.png", color)
	return iconName
end)[3] = 16
;(function(starLv)
	local color = cityltCtrl.getBuildStarColor(starLv)
	local iconName = string.format("icon_buildstar_light_%d.png", color)
	return iconName
end)[4] = 30
;(function(starLv)
	local color = cityltCtrl.getBuildStarColor(starLv)
	local iconName = string.format("icon_buildstar_light_%d.png", color)
	return iconName
end)[5] = 48
local _ENV, (function(starLv)
	local color = cityltCtrl.getBuildStarColor(starLv)
	local iconName = string.format("icon_buildstar_light_%d.png", color)
	return iconName
end)[6], color2Starlv = 102, 70, function(starLv)
	local color = cityltCtrl.getBuildStarColor(starLv)
	local iconName = string.format("icon_buildstar_light_%d.png", color)
	return iconName
end
;(102)[1] = 0
;(102)[2] = 3
;(102)[3] = 6
;(102)[4] = 9
;(102)[5] = 12
local (102)[6], color2StarlvStatue = 15, 102
function cityltCtrl.getBuildStarColor(starLv, bid)
	starLv = starLv or 0
	local refList = color2Starlv
	if bid == BUILDID.STAR_BRAVE_STATUE then
		refList = color2StarlvStatue
	end
	for i, v in ipairs(refList) do
		if v > starLv then
			return i - 1
		end
	end
	return #refList
end
function cityltCtrl.getBuildStarLv(color, bid)
	color = color or 1
	if bid == BUILDID.STAR_BRAVE_STATUE then
		return color2StarlvStatue[color]
	end
	return color2Starlv[color]
end
function cityltCtrl.getUnlockedSoldierLv(bid, armyLv)
	local armyLogic = include("armyLogic")
	if not cityltCtrl.buildList[bid] then
		local _ENV, buildcell = cityltCtrl.buildList[bid], cityltCtrl.buildList[bid]
	end
	local needLv = 0
	for blv, lvinfo in ipairs(buildcell) do
		if 0 < lvinfo.unlockedSoldier then
			local lv = armyLogic.getArmyLV(lvinfo.unlockedSoldier)
			if lv == armyLv then
				needLv = blv
				break
			end
		end
	end
	return needLv
end
function cityltCtrl.checkBuildIsLocked(bid)
	local isLocked = false
	local unlocklevel = cityltCtrl.buildAttr(tonumber(bid), BUILD_ATTR.UNLOCKLEVEL)
	if unlocklevel then
		isLocked = unlocklevel > SoraDGetCastleLv()
		return isLocked, unlocklevel
	end
	return isLocked
end
function cityltCtrl.getAllBuildHeroAppointCfg()
	return cityltCtrl.buildAppoint
end
function cityltCtrl.getBuildHeroAppointCfg(bid)
	return cityltCtrl.buildAppoint[bid]
end
function cityltCtrl.getBuildTypeAppointCfg(buildType)
	return cityltCtrl.buildAppointType[buildType]
end
function cityltCtrl.getHeroAttrName(direction)
	_ENV = nil
	;(nil)[1] = i18n("hero_appoint_7")
	;(nil)[2] = i18n("hero_appoint_8")
	;(nil)[3] = i18n("hero_appoint_9")
	local (nil)[4], attrCfg = i18n("hero_appoint_10"), nil
	return attrCfg[direction]
end
cityltCtrl:defineValue("statueBraveQuality2cityEffect", function()
	_ENV, _ENV = nil, nil
	;(nil).name = "dh_dx_fb_%02d.png"
	_ENV, (nil)[11], (nil).isAdd = nil, nil, true
	;(nil).name = "dh_dx_sm_%02d.png"
	_ENV, (nil)[12], (nil).isAdd = nil, nil, true
	;(nil).name = "dh_dx_dd_%02d.png"
	_ENV, (nil)[13], (nil).isAdd = nil, nil, false
	;(nil).name = "dh_dx_ny_%02d.png"
	_ENV, (nil)[14], (nil).isAdd = nil, nil, true
	;(nil).name = "dh_dx_yh_%02d.png"
	_ENV, (nil)[15], (nil).isAdd = nil, nil, true
	;(nil).name = "dh_dx_16_%02d.png"
	;(nil).isAdd = false
	_ENV, (nil)[16], (nil).style = nil, nil, 2
	;(nil).name = "dh_dx_17_%02d.png"
	;(nil).isAdd = false
	_ENV, (nil)[17], (nil).style = nil, nil, 2
	;(nil).name = "dh_dx_18_%02d.png"
	;(nil).isAdd = false
	_ENV, (nil)[18], (nil).style = nil, nil, 2
	;(nil).name = "dh_dx_19_%02d.png"
	;(nil).isAdd = false
	;(nil)[19], (nil).style = nil, 2
	local ret
	for __, v in pairs(ret) do
		if v.style == 2 then
			v.framesNumber = 15
			v.scale = 1
			v.pos = cc.p(67, 152)
			v.showDizuo = true
		end
	end
	return ret
end)
function cityltCtrl.getStatueBraveCityEffect(quality)
	local config = cityltCtrl.statueBraveQuality2cityEffect
	return config[quality]
end
function cityltCtrl.getStatueBraveCityImage(quality)
	quality = math.min(quality, 19)
	return string.format("yongzhediaoxiang_%.2d.png", quality)
end
cityltCtrl:defineValue("statueBraveQuality2armorEffect", function()
	_ENV, _ENV = nil, nil
	;(nil).name = "G_gmshz_bf.usm"
	_ENV, (nil)[11], (nil).pos = nil, nil, cc.p(293, 480)
	;(nil).name = "G_gmshz_sm.usm"
	_ENV, (nil)[12], (nil).pos = nil, nil, cc.p(288, 318)
	;(nil).name = "G_gmshz_dd.usm"
	_ENV, (nil)[13], (nil).pos = nil, nil, cc.p(293, 480)
	;(nil).name = "G_gmshz_hy.usm"
	_ENV, (nil)[14], (nil).pos = nil, nil, cc.p(287, 311)
	;(nil).name = "G_gmshz_yh.usm"
	_ENV, (nil)[15], (nil).pos = nil, nil, cc.p(288, 322)
	;(nil).name = "gmshz_16.usm"
	;(nil).pos = cc.p(288, 437)
	_ENV, (nil)[16], (nil).isAdd = nil, nil, false
	;(nil).isPrefab = true
	;(nil).pos = cc.p(285, 425)
	;(nil).top = "fx_ui_ysdx_l02_top.prefab"
	_ENV, (nil)[17], (nil).btm = nil, nil, "fx_ui_ysdx_l02_btm.prefab"
	;(nil).isPrefab = true
	;(nil).pos = cc.p(285, 425)
	;(nil).top = "fx_ui_ysdx_l03_top.prefab"
	_ENV, (nil)[18], (nil).btm = nil, nil, "fx_ui_ysdx_l03_btm.prefab"
	;(nil).isPrefab = true
	;(nil).pos = cc.p(285, 425)
	;(nil).top = "fx_ui_ysdx_l04_top.prefab"
	;(nil)[19], (nil).btm = nil, "fx_ui_ysdx_l04_btm.prefab"
	local ret
	return ret
end)
function cityltCtrl.getStatueBraveArmorEffect(quality)
	local config = cityltCtrl.statueBraveQuality2armorEffect
	return config[quality]
end
function cityltCtrl.getStatueBraveArmorImage(quality)
	quality = math.min(quality, 19)
	return string.format("bg_armor_build_%.2d.png", quality)
end
function cityltCtrl.getStatueBraveQualityName(quality)
	local nameKey = string.format("Soldiers_armor_qualityName_%.2d", quality)
	return i18n(nameKey)
end
function cityltCtrl.getStatueBraveBuildLvBg(quality)
	quality = math.min(quality, 19)
	return string.format("frame_armor_quality_%.2d.png", quality)
end
cityltCtrl.init()
return cityltCtrl
