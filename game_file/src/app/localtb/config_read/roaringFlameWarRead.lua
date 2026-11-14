local roaringFlameWarRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "flames_dunes_constant"
;(nil)[2] = true
roaringFlameWarRead:defineValue("constant", nil)
function roaringFlameWarRead.getConstValue(key, defaultValue)
	local info = roaringFlameWarRead.constant[key]
	if info and info.value then
		return info.value[1]
	end
	return defaultValue
end
function roaringFlameWarRead.getConstValueArray(key, defaultValue)
	local info = roaringFlameWarRead.constant[key]
	if info and info.value then
		return info.value
	end
	return defaultValue
end
roaringFlameWarRead:defineValue("flames_dunes_time", function()
	local baseConfig = require_data("flames_dunes_time", true, true).data
	return roaringFlameWarRead.getClassTypeConfig(baseConfig, "time_stage")
end)
function roaringFlameWarRead.getTimeConfig(time_stage)
	return roaringFlameWarRead.flames_dunes_time[time_stage]
end
function roaringFlameWarRead.getTimeConfigStage(time_stage, stage)
	local cfg = roaringFlameWarRead.getTimeConfig(time_stage)
	return cfg[stage]
end
function roaringFlameWarRead.getWarStateDuration(stage)
	local cfg = roaringFlameWarRead.getTimeConfigStage(2, stage)
	return cfg.duration
end
function roaringFlameWarRead.getSeasonTime()
	local cfg = roaringFlameWarRead.flames_dunes_time[1]
	return cfg[4].offset_time - cfg[3].offset_time
end
function _UPVALUE1_()
	local baseConfig = require_data("flames_dunes_time", true, true).data
	return roaringFlameWarRead.getClassTypeConfig(baseConfig, "time_stage")
end
;(function()
	local baseConfig = require_data("flames_dunes_time", true, true).data
	return roaringFlameWarRead.getClassTypeConfig(baseConfig, "time_stage")
end)[1] = "flames_dunes_time_config"
roaringFlameWarRead:defineValue("flames_dunes_time_config", function()
	local baseConfig = require_data("flames_dunes_time", true, true).data
	return roaringFlameWarRead.getClassTypeConfig(baseConfig, "time_stage")
end)
function roaringFlameWarRead.getWarTimeCfg(index)
	if index then
		return roaringFlameWarRead.flames_dunes_time_config[index]
	else
		return roaringFlameWarRead.flames_dunes_time_config
	end
end
function _UPVALUE2_()
	local baseConfig = require_data("flames_dunes_time", true, true).data
	return roaringFlameWarRead.getClassTypeConfig(baseConfig, "time_stage")
end
;(function()
	local baseConfig = require_data("flames_dunes_time", true, true).data
	return roaringFlameWarRead.getClassTypeConfig(baseConfig, "time_stage")
end)[1] = "flames_dunes_city"
;(function()
	local baseConfig = require_data("flames_dunes_time", true, true).data
	return roaringFlameWarRead.getClassTypeConfig(baseConfig, "time_stage")
end)[2] = true
roaringFlameWarRead:defineValue("flames_dunes_city", function()
	local baseConfig = require_data("flames_dunes_time", true, true).data
	return roaringFlameWarRead.getClassTypeConfig(baseConfig, "time_stage")
end)
function roaringFlameWarRead.get_flames_dunes_city(...)
	return roaringFlameWarRead.flames_dunes_city
end
function roaringFlameWarRead.getBuildServerConfig(objId)
	return roaringFlameWarRead.flames_dunes_city[objId]
end
function roaringFlameWarRead.getBuildSubType(objId)
	local cfg = roaringFlameWarRead.getBuildServerConfig(objId)
	return cfg.type
end
function roaringFlameWarRead.getBuildSize(objId)
	local cfg = roaringFlameWarRead.getBuildServerConfig(objId)
	return cfg.city_size
end
function roaringFlameWarRead.getBuildServerCoord(objId)
	local cfg = roaringFlameWarRead.getBuildServerConfig(objId)
	local city_coord = cfg.city_coord
	return cc.p(city_coord[1], city_coord[2])
end
function roaringFlameWarRead.getBuildCoord(objId)
	local cfg = roaringFlameWarRead.getBuildServerConfig(objId)
	if not cfg.clientPos then
		local mapSyncUtilClient = include("mapSyncUtilClient")
		local serverPos = roaringFlameWarRead.getBuildServerCoord(objId)
		cfg.clientPos = mapSyncUtilClient.serverTOClientPos(serverPos)
	end
	return cfg.clientPos
end
function roaringFlameWarRead.getBuildCoordBySubType(subType)
	local buildIDList = roaringFlameWarRead.getBuildIDListByType(subType)
	return roaringFlameWarRead.getBuildCoord(buildIDList[1])
end
function roaringFlameWarRead.getBuildCenterPos(objId)
	local coord = roaringFlameWarRead.getBuildCoord(objId)
	local size = roaringFlameWarRead.getBuildSize(objId)
	return cc.p(coord.x + (size - 1) / 2, coord.y + (size - 1) / 2)
end
function roaringFlameWarRead.getBuildBinding(objId)
	local cfg = roaringFlameWarRead.getBuildServerConfig(objId)
	return cfg.binding
end
function roaringFlameWarRead.getBuildLevel(objId)
	local cfg = roaringFlameWarRead.getBuildServerConfig(objId)
	return cfg.level
end
function roaringFlameWarRead.getBuildScopeSize(objId)
	local cfg = roaringFlameWarRead.getBuildServerConfig(objId)
	return cfg.scope_size
end
function roaringFlameWarRead.getBuildRect(objId)
	local cfg = roaringFlameWarRead.getBuildServerConfig(objId)
	if not cfg.buildRect then
		local scope_size = roaringFlameWarRead.getBuildScopeSize(objId)
		_UPVALUE4_ = nil
		;(nil)[1] = "beginX"
		;(nil)[2] = "beginY"
		;(nil)[3] = "endX"
		;(nil)[4] = "endY"
		local rects = serviceFunctions.tableFormat(scope_size, nil)
		local rect = rects[1]
		if rect then
			local mapSyncUtilClient = include("mapSyncUtilClient")
			local clientPos = mapSyncUtilClient.serverTOClientPos(cc.p(rect.beginX, rect.beginY))
			local width = rect.endX - rect.beginX + 1
			local height = rect.endY - rect.beginY + 1
			cfg.buildRect = cc.rect(clientPos.x, clientPos.y, width - 1, height - 1)
		else
			cfg.buildRect = cc.rect(0, 0, 0, 0)
		end
	end
	return cfg.buildRect
end
function roaringFlameWarRead.getBuildBlackSize(objId)
	local cfg = roaringFlameWarRead.getBuildServerConfig(objId)
	return cfg.black_size
end
function roaringFlameWarRead.getBlackRect(objId)
	local cfg = roaringFlameWarRead.getBuildServerConfig(objId)
	if not cfg.blackRect then
		local black_size = roaringFlameWarRead.getBuildBlackSize(objId)
		local coord = roaringFlameWarRead.getBuildCoord(objId)
		local size = roaringFlameWarRead.getBuildSize(objId)
		local clientPos = cc.p(coord.x - black_size, coord.y - black_size)
		local width = black_size * 2 + size - 1
		cfg.blackRect = cc.rect(clientPos.x, clientPos.y, width, width)
	end
	return cfg.blackRect
end
function roaringFlameWarRead.getBuildCamp(objId)
	local cfg = roaringFlameWarRead.getBuildServerConfig(objId)
	return cfg.camp
end
function roaringFlameWarRead.getBuildCostPoint(objId)
	local cfg = roaringFlameWarRead.getBuildServerConfig(objId)
	return cfg.cost_point
end
function roaringFlameWarRead.getBuildAbandon(objId)
	local cfg = roaringFlameWarRead.getBuildServerConfig(objId)
	return cfg.abandon
end
function roaringFlameWarRead.checkBuildCanAbandon(objId)
	local abandon = roaringFlameWarRead.getBuildAbandon(objId)
	return abandon ~= 1
end
function roaringFlameWarRead.getBuildOpenTime(objId)
	local cfg = roaringFlameWarRead.getBuildServerConfig(objId)
	return cfg.open_time
end
roaringFlameWarRead:defineValue("buildIDList", function()
	local _ENV, ret
	for _, v in ipairs(roaringFlameWarRead.flames_dunes_city) do
		if not ret[v.type] then
			_ENV = ret[v.type]
		end
		ret[v.type] = ret[v.type]
		table.insert(ret[v.type], v.id)
	end
	return ret
end)
function roaringFlameWarRead.getBuildIDListByType(buildType)
	if not roaringFlameWarRead.buildIDList[buildType] then
		roaringFlameWarRead = roaringFlameWarRead.buildIDList[buildType]
	end
	return roaringFlameWarRead.buildIDList[buildType]
end
function roaringFlameWarRead.getHoldInstaceByType(buildId, buildType)
	if buildId then
		return roaringFlameWarRead.getBuildSize(buildId)
	elseif buildType then
		local buildIDList = roaringFlameWarRead.getBuildIDListByType(buildType)
		return roaringFlameWarRead.getHoldInstaceByType(buildIDList[1])
	end
	return 2
end
roaringFlameWarRead:defineValue("gatewayCopy2gateway", function()
	local roaringFlameWarRead, ret
	local buildIDList = roaringFlameWarRead.getBuildIDListByType(gWorldTypeServerDef.subTypeRoaringFlameWarGatewayCopy)
	for __, objId in ipairs(buildIDList) do
		local binding = roaringFlameWarRead.getBuildBinding(objId)
		for __, _objId in ipairs(binding) do
			local _subType = roaringFlameWarRead.getBuildSubType(_objId)
			if _subType == gWorldTypeServerDef.subTypeRoaringFlameWarGateway then
				ret[objId] = _objId
				ret[_objId] = objId
				break
			end
		end
	end
	return ret
end)
function roaringFlameWarRead.getGatewayCopy2gateway(objId)
	return roaringFlameWarRead.gatewayCopy2gateway[objId]
end
function _UPVALUE2_()
	local roaringFlameWarRead, ret
	local buildIDList = roaringFlameWarRead.getBuildIDListByType(gWorldTypeServerDef.subTypeRoaringFlameWarGatewayCopy)
	for __, objId in ipairs(buildIDList) do
		local binding = roaringFlameWarRead.getBuildBinding(objId)
		for __, _objId in ipairs(binding) do
			local _subType = roaringFlameWarRead.getBuildSubType(_objId)
			if _subType == gWorldTypeServerDef.subTypeRoaringFlameWarGateway then
				ret[objId] = _objId
				ret[_objId] = objId
				break
			end
		end
	end
	return ret
end
;(function()
	local roaringFlameWarRead, ret
	local buildIDList = roaringFlameWarRead.getBuildIDListByType(gWorldTypeServerDef.subTypeRoaringFlameWarGatewayCopy)
	for __, objId in ipairs(buildIDList) do
		local binding = roaringFlameWarRead.getBuildBinding(objId)
		for __, _objId in ipairs(binding) do
			local _subType = roaringFlameWarRead.getBuildSubType(_objId)
			if _subType == gWorldTypeServerDef.subTypeRoaringFlameWarGateway then
				ret[objId] = _objId
				ret[_objId] = objId
				break
			end
		end
	end
	return ret
end)[1] = "flames_dunes_resource_config"
;(function()
	local roaringFlameWarRead, ret
	local buildIDList = roaringFlameWarRead.getBuildIDListByType(gWorldTypeServerDef.subTypeRoaringFlameWarGatewayCopy)
	for __, objId in ipairs(buildIDList) do
		local binding = roaringFlameWarRead.getBuildBinding(objId)
		for __, _objId in ipairs(binding) do
			local _subType = roaringFlameWarRead.getBuildSubType(_objId)
			if _subType == gWorldTypeServerDef.subTypeRoaringFlameWarGateway then
				ret[objId] = _objId
				ret[_objId] = objId
				break
			end
		end
	end
	return ret
end)[2] = false
roaringFlameWarRead:defineValue("flames_dunes_resource_config", function()
	local roaringFlameWarRead, ret
	local buildIDList = roaringFlameWarRead.getBuildIDListByType(gWorldTypeServerDef.subTypeRoaringFlameWarGatewayCopy)
	for __, objId in ipairs(buildIDList) do
		local binding = roaringFlameWarRead.getBuildBinding(objId)
		for __, _objId in ipairs(binding) do
			local _subType = roaringFlameWarRead.getBuildSubType(_objId)
			if _subType == gWorldTypeServerDef.subTypeRoaringFlameWarGateway then
				ret[objId] = _objId
				ret[_objId] = objId
				break
			end
		end
	end
	return ret
end)
function roaringFlameWarRead.getBuildClientConfig(subType)
	local config = roaringFlameWarRead.flames_dunes_resource_config
	return config[subType] or config[1]
end
function roaringFlameWarRead.getBuildName(subType)
	local cfg = roaringFlameWarRead.getBuildClientConfig(subType)
	return i18n(cfg.res_name)
end
function roaringFlameWarRead.getBuildNameByBuildId(buildId)
	local subType = roaringFlameWarRead.getBuildSubType(buildId)
	return roaringFlameWarRead.getBuildName(subType)
end
function roaringFlameWarRead.getBuildImage(subType)
	local cfg = roaringFlameWarRead.getBuildClientConfig(subType)
	return cfg.res_model
end
function roaringFlameWarRead.getBuildImage2(subType)
	local cfg = roaringFlameWarRead.getBuildClientConfig(subType)
	return cfg.res_model2
end
function roaringFlameWarRead.getBuildIcon(subType)
	local cfg = roaringFlameWarRead.getBuildClientConfig(subType)
	return cfg.res_icon
end
function roaringFlameWarRead.getBuildDes(subType)
	local cfg = roaringFlameWarRead.getBuildClientConfig(subType)
	return i18n(cfg.res_des)
end
function roaringFlameWarRead.getBuildTypeDes(subType)
	local cfg = roaringFlameWarRead.getBuildClientConfig(subType)
	return i18n(cfg.build_type_des)
end
function roaringFlameWarRead.getBuildTypeIcon(subType)
	local cfg = roaringFlameWarRead.getBuildClientConfig(subType)
	return cfg.build_type_icon
end
function roaringFlameWarRead.getBuildBattleIcon(subType)
	local cfg = roaringFlameWarRead.getBuildClientConfig(subType)
	return cfg.build_battle_icon
end
function _UPVALUE2_()
	local roaringFlameWarRead, ret
	local buildIDList = roaringFlameWarRead.getBuildIDListByType(gWorldTypeServerDef.subTypeRoaringFlameWarGatewayCopy)
	for __, objId in ipairs(buildIDList) do
		local binding = roaringFlameWarRead.getBuildBinding(objId)
		for __, _objId in ipairs(binding) do
			local _subType = roaringFlameWarRead.getBuildSubType(_objId)
			if _subType == gWorldTypeServerDef.subTypeRoaringFlameWarGateway then
				ret[objId] = _objId
				ret[_objId] = objId
				break
			end
		end
	end
	return ret
end
;(function()
	local roaringFlameWarRead, ret
	local buildIDList = roaringFlameWarRead.getBuildIDListByType(gWorldTypeServerDef.subTypeRoaringFlameWarGatewayCopy)
	for __, objId in ipairs(buildIDList) do
		local binding = roaringFlameWarRead.getBuildBinding(objId)
		for __, _objId in ipairs(binding) do
			local _subType = roaringFlameWarRead.getBuildSubType(_objId)
			if _subType == gWorldTypeServerDef.subTypeRoaringFlameWarGateway then
				ret[objId] = _objId
				ret[_objId] = objId
				break
			end
		end
	end
	return ret
end)[1] = "flames_dunes_camp"
;(function()
	local roaringFlameWarRead, ret
	local buildIDList = roaringFlameWarRead.getBuildIDListByType(gWorldTypeServerDef.subTypeRoaringFlameWarGatewayCopy)
	for __, objId in ipairs(buildIDList) do
		local binding = roaringFlameWarRead.getBuildBinding(objId)
		for __, _objId in ipairs(binding) do
			local _subType = roaringFlameWarRead.getBuildSubType(_objId)
			if _subType == gWorldTypeServerDef.subTypeRoaringFlameWarGateway then
				ret[objId] = _objId
				ret[_objId] = objId
				break
			end
		end
	end
	return ret
end)[2] = true
roaringFlameWarRead:defineValue("flames_dunes_camp", function()
	local roaringFlameWarRead, ret
	local buildIDList = roaringFlameWarRead.getBuildIDListByType(gWorldTypeServerDef.subTypeRoaringFlameWarGatewayCopy)
	for __, objId in ipairs(buildIDList) do
		local binding = roaringFlameWarRead.getBuildBinding(objId)
		for __, _objId in ipairs(binding) do
			local _subType = roaringFlameWarRead.getBuildSubType(_objId)
			if _subType == gWorldTypeServerDef.subTypeRoaringFlameWarGateway then
				ret[objId] = _objId
				ret[_objId] = objId
				break
			end
		end
	end
	return ret
end)
function roaringFlameWarRead.getCampCfg(index)
	return roaringFlameWarRead.flames_dunes_camp[index] or roaringFlameWarRead.flames_dunes_camp[1]
end
function roaringFlameWarRead.getCampName(camp)
	local cfg = roaringFlameWarRead.getCampCfg(camp)
	return i18n(cfg.name)
end
function roaringFlameWarRead.getCampHtmlColor(camp)
	local cfg = roaringFlameWarRead.getCampCfg(camp)
	return cfg.color
end
function roaringFlameWarRead.getCampColor(camp)
	local htmlColor = roaringFlameWarRead.getCampHtmlColor(camp)
	return SoraDHtmlColor2RGB(htmlColor)
end
function roaringFlameWarRead.getCampCount()
	return #roaringFlameWarRead.flames_dunes_camp
end
roaringFlameWarRead:defineValue("camp2buildLvImage", function()
	_UPVALUE0_ = nil
	;(nil)[0] = "frame_9001674_dengjidi_zl.png"
	;(nil)[1] = "frame_9001674_dengjidi_danlan.png"
	;(nil)[2] = "frame_9001674_dengjidi_huang.png"
	;(nil)[3] = "frame_9001674_dengjidi_lan.png"
	;(nil)[4] = "frame_9001674_dengjidi_cheng.png"
	local (nil)[5], ret = "frame_9001674_dengjidi_zi.png", nil
	return ret
end)
function roaringFlameWarRead.getCampBuildLvImage(camp)
	return roaringFlameWarRead.camp2buildLvImage[camp]
end
roaringFlameWarRead:defineValue("camp2buildFaceImage", function()
	_UPVALUE0_ = nil
	;(nil)[0] = "frame_9001674_jzfx_zl.png"
	;(nil)[1] = "frame_9001674_jzfx_danlan.png"
	;(nil)[2] = "frame_9001674_jzfx_huang.png"
	;(nil)[3] = "frame_9001674_jzfx_lan.png"
	;(nil)[4] = "frame_9001674_jzfx_cheng.png"
	local (nil)[5], ret = "frame_9001674_jzfx_zi.png", nil
	return ret
end)
function roaringFlameWarRead.getCampBuildFaceImage(camp)
	return roaringFlameWarRead.camp2buildFaceImage[camp]
end
roaringFlameWarRead:defineValue("camp2warInfoBarImage", function()
	_UPVALUE0_ = nil
	;(nil)[1] = "frame_9001674_tk_bar_danlan.png"
	;(nil)[2] = "frame_9001674_tk_bar_huang.png"
	;(nil)[3] = "frame_9001674_tk_bar_lan.png"
	;(nil)[4] = "frame_9001674_tk_bar_cheng.png"
	local (nil)[5], ret = "frame_9001674_tk_bar_zi.png", nil
	return ret
end)
function roaringFlameWarRead.getCampWarInfoBarImage(camp)
	return roaringFlameWarRead.camp2warInfoBarImage[camp]
end
roaringFlameWarRead:defineValue("camp2zhankuangImage", function()
	_UPVALUE0_ = nil
	;(nil)[1] = "frame_9001674_zhankuang_qing.png"
	;(nil)[2] = "frame_9001674_zhankuang_huang.png"
	;(nil)[3] = "frame_9001674_zhankuang_lan.png"
	;(nil)[4] = "frame_9001674_zhankuang_cheng.png"
	local (nil)[5], ret = "frame_9001674_zhankuang_zi.png", nil
	return ret
end)
function roaringFlameWarRead.getCampZhankuangImage(camp)
	return roaringFlameWarRead.camp2zhankuangImage[camp]
end
roaringFlameWarRead:defineValue("camp2buildLineColor", function()
	_ENV = nil
	;(nil)[0] = cc.c3b(216, 216, 216)
	;(nil)[1] = cc.c3b(0, 152, 143)
	;(nil)[2] = cc.c3b(225, 225, 33)
	;(nil)[3] = cc.c3b(52, 110, 185)
	;(nil)[4] = cc.c3b(200, 98, 20)
	local (nil)[5], ret = cc.c3b(169, 50, 173), nil
	return ret
end)
function roaringFlameWarRead.getCampBuildLineColor(camp)
	return roaringFlameWarRead.camp2buildLineColor[camp]
end
function roaringFlameWarRead.getCampResultImage(camp)
	return string.format("frame_9001674_settlement_team%02d.png", camp)
end
roaringFlameWarRead:defineValue("flames_dunes_history", function()
	local config = require_data("flames_dunes_history", true, true).data
	local _ENV, ret = "flames_dunes_history", "flames_dunes_history"
	for k, v in ipairs(config) do
		_UPVALUE3_ = nil
		;(nil)[1] = "type"
		;(nil)[2] = "lv"
		;(nil)[3] = "num"
		v.task_cond = serviceFunctions.tableFormat(v.task_cond, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.task_reward = serviceFunctions.tableFormat(v.task_reward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.time_reward = serviceFunctions.tableFormat(v.time_reward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "res_type"
		;(nil)[2] = "lv"
		v.open_show = serviceFunctions.tableFormat(v.open_show, nil)
		table.insert(ret, v)
	end
	return ret
end)
function roaringFlameWarRead.getDuneHistoryCfg()
	return roaringFlameWarRead.flames_dunes_history
end
function roaringFlameWarRead.getDuneHistoryStatus(index)
	local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
	local battleTime = roaringFlameWarCtrl:getStateBeginTime(ROARING_FLAME_WAR_STATE.BATTLE)
	local status = 0
	local remainTime = 0
	local curSysTime = serviceFunctions.systemTime()
	local preStageEndTime = roaringFlameWarRead.flames_dunes_history[index - 1] and roaringFlameWarRead.flames_dunes_history[index - 1].end_time or 0
	local beginTime = battleTime + preStageEndTime
	local endTime = battleTime + roaringFlameWarRead.flames_dunes_history[index].end_time
	if curSysTime >= beginTime then
		if curSysTime > endTime then
			status = 2
		else
			status = 1
			remainTime = endTime - curSysTime
		end
	else
		status = 0
	end
	return status, remainTime
end
function roaringFlameWarRead.getDuneHistoryLastTime(index)
	local preStageEndTime = roaringFlameWarRead.flames_dunes_history[index - 1] and roaringFlameWarRead.flames_dunes_history[index - 1].end_time or 0
	return roaringFlameWarRead.flames_dunes_history[index].end_time - preStageEndTime
end
function roaringFlameWarRead.getDuneHistoryPrecent()
	local _ENV, stageList
	for k, v in ipairs(roaringFlameWarRead.flames_dunes_history) do
		table.insert(stageList, v.end_time)
	end
	local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
	local battleTime = roaringFlameWarCtrl:getStateBeginTime(ROARING_FLAME_WAR_STATE.BATTLE)
	local curTime = math.max(0, serviceFunctions.systemTime() - battleTime)
	return SoraDGetStageValue(curTime, stageList, true)
end
function _UPVALUE2_()
	local config = require_data("flames_dunes_history", true, true).data
	local _ENV, ret = "flames_dunes_history", "flames_dunes_history"
	for k, v in ipairs(config) do
		_UPVALUE3_ = nil
		;(nil)[1] = "type"
		;(nil)[2] = "lv"
		;(nil)[3] = "num"
		v.task_cond = serviceFunctions.tableFormat(v.task_cond, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.task_reward = serviceFunctions.tableFormat(v.task_reward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.time_reward = serviceFunctions.tableFormat(v.time_reward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "res_type"
		;(nil)[2] = "lv"
		v.open_show = serviceFunctions.tableFormat(v.open_show, nil)
		table.insert(ret, v)
	end
	return ret
end
;(function()
	local config = require_data("flames_dunes_history", true, true).data
	local _ENV, ret = "flames_dunes_history", "flames_dunes_history"
	for k, v in ipairs(config) do
		_UPVALUE3_ = nil
		;(nil)[1] = "type"
		;(nil)[2] = "lv"
		;(nil)[3] = "num"
		v.task_cond = serviceFunctions.tableFormat(v.task_cond, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.task_reward = serviceFunctions.tableFormat(v.task_reward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.time_reward = serviceFunctions.tableFormat(v.time_reward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "res_type"
		;(nil)[2] = "lv"
		v.open_show = serviceFunctions.tableFormat(v.open_show, nil)
		table.insert(ret, v)
	end
	return ret
end)[1] = "flames_dunes_team"
;(function()
	local config = require_data("flames_dunes_history", true, true).data
	local _ENV, ret = "flames_dunes_history", "flames_dunes_history"
	for k, v in ipairs(config) do
		_UPVALUE3_ = nil
		;(nil)[1] = "type"
		;(nil)[2] = "lv"
		;(nil)[3] = "num"
		v.task_cond = serviceFunctions.tableFormat(v.task_cond, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.task_reward = serviceFunctions.tableFormat(v.task_reward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.time_reward = serviceFunctions.tableFormat(v.time_reward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "res_type"
		;(nil)[2] = "lv"
		v.open_show = serviceFunctions.tableFormat(v.open_show, nil)
		table.insert(ret, v)
	end
	return ret
end)[2] = true
roaringFlameWarRead:defineValue("flames_dunes_team", function()
	local config = require_data("flames_dunes_history", true, true).data
	local _ENV, ret = "flames_dunes_history", "flames_dunes_history"
	for k, v in ipairs(config) do
		_UPVALUE3_ = nil
		;(nil)[1] = "type"
		;(nil)[2] = "lv"
		;(nil)[3] = "num"
		v.task_cond = serviceFunctions.tableFormat(v.task_cond, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.task_reward = serviceFunctions.tableFormat(v.task_reward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.time_reward = serviceFunctions.tableFormat(v.time_reward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "res_type"
		;(nil)[2] = "lv"
		v.open_show = serviceFunctions.tableFormat(v.open_show, nil)
		table.insert(ret, v)
	end
	return ret
end)
function roaringFlameWarRead.getPermissionRankConfig()
	return roaringFlameWarRead.flames_dunes_team
end
function roaringFlameWarRead.getPermissionRank(permission)
	local cfg = roaringFlameWarRead.flames_dunes_team[permission]
	if not cfg or not cfg.rank then
		roaringFlameWarRead = cfg.rank
	end
	return cfg.rank
end
function roaringFlameWarRead.checkPermission(permission, rank)
	local rankList = roaringFlameWarRead.getPermissionRank(permission)
	if table.indexof(rankList, rank) then
		return true
	else
		return false
	end
end
function _UPVALUE2_()
	local config = require_data("flames_dunes_history", true, true).data
	local _ENV, ret = "flames_dunes_history", "flames_dunes_history"
	for k, v in ipairs(config) do
		_UPVALUE3_ = nil
		;(nil)[1] = "type"
		;(nil)[2] = "lv"
		;(nil)[3] = "num"
		v.task_cond = serviceFunctions.tableFormat(v.task_cond, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.task_reward = serviceFunctions.tableFormat(v.task_reward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.time_reward = serviceFunctions.tableFormat(v.time_reward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "res_type"
		;(nil)[2] = "lv"
		v.open_show = serviceFunctions.tableFormat(v.open_show, nil)
		table.insert(ret, v)
	end
	return ret
end
;(function()
	local config = require_data("flames_dunes_history", true, true).data
	local _ENV, ret = "flames_dunes_history", "flames_dunes_history"
	for k, v in ipairs(config) do
		_UPVALUE3_ = nil
		;(nil)[1] = "type"
		;(nil)[2] = "lv"
		;(nil)[3] = "num"
		v.task_cond = serviceFunctions.tableFormat(v.task_cond, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.task_reward = serviceFunctions.tableFormat(v.task_reward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.time_reward = serviceFunctions.tableFormat(v.time_reward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "res_type"
		;(nil)[2] = "lv"
		v.open_show = serviceFunctions.tableFormat(v.open_show, nil)
		table.insert(ret, v)
	end
	return ret
end)[1] = "flames_dunes_technology"
;(function()
	local config = require_data("flames_dunes_history", true, true).data
	local _ENV, ret = "flames_dunes_history", "flames_dunes_history"
	for k, v in ipairs(config) do
		_UPVALUE3_ = nil
		;(nil)[1] = "type"
		;(nil)[2] = "lv"
		;(nil)[3] = "num"
		v.task_cond = serviceFunctions.tableFormat(v.task_cond, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.task_reward = serviceFunctions.tableFormat(v.task_reward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.time_reward = serviceFunctions.tableFormat(v.time_reward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "res_type"
		;(nil)[2] = "lv"
		v.open_show = serviceFunctions.tableFormat(v.open_show, nil)
		table.insert(ret, v)
	end
	return ret
end)[2] = true
roaringFlameWarRead:defineValue("flames_dunes_technology", function()
	local config = require_data("flames_dunes_history", true, true).data
	local _ENV, ret = "flames_dunes_history", "flames_dunes_history"
	for k, v in ipairs(config) do
		_UPVALUE3_ = nil
		;(nil)[1] = "type"
		;(nil)[2] = "lv"
		;(nil)[3] = "num"
		v.task_cond = serviceFunctions.tableFormat(v.task_cond, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.task_reward = serviceFunctions.tableFormat(v.task_reward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.time_reward = serviceFunctions.tableFormat(v.time_reward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "res_type"
		;(nil)[2] = "lv"
		v.open_show = serviceFunctions.tableFormat(v.open_show, nil)
		table.insert(ret, v)
	end
	return ret
end)
roaringFlameWarRead:defineValue("flames_dunes_technology_tree", function()
	local _ENV, ret
	for _, v in ipairs(roaringFlameWarRead.flames_dunes_technology) do
		if v.technology_level == 1 then
			table.insert(ret, v.technology_id)
		end
	end
	return ret
end)
function roaringFlameWarRead.getTechnologyTree()
	return roaringFlameWarRead.flames_dunes_technology_tree
end
function roaringFlameWarRead.getTechnologyTreeNext()
	local _ENV, nextMap
	for _, tid in ipairs(roaringFlameWarRead.flames_dunes_technology_tree) do
		nextMap[tid], _ENV = nil, nil
		for _, v in ipairs(roaringFlameWarRead.flames_dunes_technology) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "lv"
			local preFix = serviceFunctions.tableFormat(v.prefix_technology, nil)
			for _, fix in ipairs(preFix) do
				if tid == fix.id then
					table.insert(nextMap[tid], v.technology_id)
				end
			end
		end
	end
	return nextMap
end
roaringFlameWarRead:defineValue("technologyConfig", function()
	local _ENV, ret
	for _, v in ipairs(roaringFlameWarRead.flames_dunes_technology) do
		if not ret[v.technology_id] then
			_ENV = ret[v.technology_id]
		end
		ret[v.technology_id] = ret[v.technology_id]
		ret[v.technology_id][v.technology_level] = v
	end
	return ret
end)
function roaringFlameWarRead.getTechnologyCfg(tid, lv)
	local lv = math.max(lv, 1)
	local cfg = roaringFlameWarRead.technologyConfig[tid]
	return cfg and cfg[lv]
end
function roaringFlameWarRead.getTechnologyMaxLv(tid)
	return roaringFlameWarRead.technologyConfig[tid][#roaringFlameWarRead.technologyConfig[tid]].technology_level
end
function roaringFlameWarRead.isTechnologyRewardBox(tid)
	local cfg = roaringFlameWarRead.technologyConfig[tid]
	return cfg and next(cfg[1].rewrad_box)
end
function _UPVALUE2_()
	local _ENV, ret
	for _, v in ipairs(roaringFlameWarRead.flames_dunes_technology) do
		if not ret[v.technology_id] then
			_ENV = ret[v.technology_id]
		end
		ret[v.technology_id] = ret[v.technology_id]
		ret[v.technology_id][v.technology_level] = v
	end
	return ret
end
;(function()
	local _ENV, ret
	for _, v in ipairs(roaringFlameWarRead.flames_dunes_technology) do
		if not ret[v.technology_id] then
			_ENV = ret[v.technology_id]
		end
		ret[v.technology_id] = ret[v.technology_id]
		ret[v.technology_id][v.technology_level] = v
	end
	return ret
end)[1] = "flames_dunes_npc"
;(function()
	local _ENV, ret
	for _, v in ipairs(roaringFlameWarRead.flames_dunes_technology) do
		if not ret[v.technology_id] then
			_ENV = ret[v.technology_id]
		end
		ret[v.technology_id] = ret[v.technology_id]
		ret[v.technology_id][v.technology_level] = v
	end
	return ret
end)[2] = true
roaringFlameWarRead:defineValue("flames_dunes_npc", function()
	local _ENV, ret
	for _, v in ipairs(roaringFlameWarRead.flames_dunes_technology) do
		if not ret[v.technology_id] then
			_ENV = ret[v.technology_id]
		end
		ret[v.technology_id] = ret[v.technology_id]
		ret[v.technology_id][v.technology_level] = v
	end
	return ret
end)
function _UPVALUE2_()
	local _ENV, ret
	for _, v in ipairs(roaringFlameWarRead.flames_dunes_technology) do
		if not ret[v.technology_id] then
			_ENV = ret[v.technology_id]
		end
		ret[v.technology_id] = ret[v.technology_id]
		ret[v.technology_id][v.technology_level] = v
	end
	return ret
end
;(function()
	local _ENV, ret
	for _, v in ipairs(roaringFlameWarRead.flames_dunes_technology) do
		if not ret[v.technology_id] then
			_ENV = ret[v.technology_id]
		end
		ret[v.technology_id] = ret[v.technology_id]
		ret[v.technology_id][v.technology_level] = v
	end
	return ret
end)[1] = "flames_dunes_recharge"
;(function()
	local _ENV, ret
	for _, v in ipairs(roaringFlameWarRead.flames_dunes_technology) do
		if not ret[v.technology_id] then
			_ENV = ret[v.technology_id]
		end
		ret[v.technology_id] = ret[v.technology_id]
		ret[v.technology_id][v.technology_level] = v
	end
	return ret
end)[2] = true
roaringFlameWarRead:defineValue("flames_dunes_recharge", function()
	local _ENV, ret
	for _, v in ipairs(roaringFlameWarRead.flames_dunes_technology) do
		if not ret[v.technology_id] then
			_ENV = ret[v.technology_id]
		end
		ret[v.technology_id] = ret[v.technology_id]
		ret[v.technology_id][v.technology_level] = v
	end
	return ret
end)
function roaringFlameWarRead.getRechargeConfig(giftType)
	return roaringFlameWarRead.flames_dunes_recharge[giftType]
end
function _UPVALUE2_()
	local _ENV, ret
	for _, v in ipairs(roaringFlameWarRead.flames_dunes_technology) do
		if not ret[v.technology_id] then
			_ENV = ret[v.technology_id]
		end
		ret[v.technology_id] = ret[v.technology_id]
		ret[v.technology_id][v.technology_level] = v
	end
	return ret
end
;(function()
	local _ENV, ret
	for _, v in ipairs(roaringFlameWarRead.flames_dunes_technology) do
		if not ret[v.technology_id] then
			_ENV = ret[v.technology_id]
		end
		ret[v.technology_id] = ret[v.technology_id]
		ret[v.technology_id][v.technology_level] = v
	end
	return ret
end)[1] = "flames_dunes_skill_config"
;(function()
	local _ENV, ret
	for _, v in ipairs(roaringFlameWarRead.flames_dunes_technology) do
		if not ret[v.technology_id] then
			_ENV = ret[v.technology_id]
		end
		ret[v.technology_id] = ret[v.technology_id]
		ret[v.technology_id][v.technology_level] = v
	end
	return ret
end)[2] = true
roaringFlameWarRead:defineValue("flames_dunes_skill_config", function()
	local _ENV, ret
	for _, v in ipairs(roaringFlameWarRead.flames_dunes_technology) do
		if not ret[v.technology_id] then
			_ENV = ret[v.technology_id]
		end
		ret[v.technology_id] = ret[v.technology_id]
		ret[v.technology_id][v.technology_level] = v
	end
	return ret
end)
roaringFlameWarRead:defineValue("skillConfigMap", function()
	local _ENV, ret
	for i, v in ipairs(roaringFlameWarRead.flames_dunes_skill_config) do
		ret[v.skillID] = i
	end
	return ret
end)
function roaringFlameWarRead.getSkillConfig(skillID)
	local index = roaringFlameWarRead.skillConfigMap[skillID]
	return roaringFlameWarRead.flames_dunes_skill_config[index]
end
function roaringFlameWarRead.getSkillBuff(skillID)
	local cfg = roaringFlameWarRead.getSkillConfig(skillID)
	return cfg.buff
end
function roaringFlameWarRead.getIsAddSkill(skillID)
	local cfg = roaringFlameWarRead.getSkillConfig(skillID)
	local add_skill = cfg and cfg.add_skill or 0
	return add_skill == 1
end
roaringFlameWarRead:defineValue("skillTypeMap", function()
	local _ENV, ret
	for i, v in ipairs(roaringFlameWarRead.flames_dunes_skill_config) do
		if v.type ~= ROARING_FLAME_WAR_SKILL_TYPE.BUFF then
			if not ret[v.type] then
				_ENV = ret[v.type]
			end
			ret[v.type] = ret[v.type]
			ret[v.type][v.value] = v.skillID
		end
	end
	return ret
end)
function roaringFlameWarRead.getSkillIdByTypeAndValue(skillType, value)
	local cfg = roaringFlameWarRead.skillTypeMap[skillType]
	return cfg and cfg[value]
end
roaringFlameWarRead:defineValue("effectTypeMap", function()
	local _ENV, ret
	for _, v in ipairs(roaringFlameWarRead.flames_dunes_skill_config) do
		for i = 1, #v.buff, 2 do
			local effect = v.buff[i]
			if not ret[effect] then
				_ENV = ret[effect]
			end
			ret[effect] = ret[effect]
			table.insert(ret[effect], v.skillID)
		end
	end
	return ret
end)
function roaringFlameWarRead.getSkillIDListByEffectType(effectType)
	if not roaringFlameWarRead.effectTypeMap[effectType] then
		roaringFlameWarRead = roaringFlameWarRead.effectTypeMap[effectType]
	end
	return roaringFlameWarRead.effectTypeMap[effectType]
end
roaringFlameWarRead:defineValue("skillTypeToAttrMap", function()
	_ENV = nil
	;(nil)[ROARING_FLAME_WAR_SKILL_TYPE.AREA_TROOP_ATTACK_BOOST] = gAttributeEnum.BATTLE_ATTACK_RATE_RANGE
	;(nil)[ROARING_FLAME_WAR_SKILL_TYPE.AREA_TROOP_DEFENSE_BOOST] = gAttributeEnum.BATTLE_DEFEND_RATE_RANGE
	;(nil)[ROARING_FLAME_WAR_SKILL_TYPE.AREA_TROOP_HP_BOOST] = gAttributeEnum.BATTLE_HP_RATE_RANGE
	;(nil)[ROARING_FLAME_WAR_SKILL_TYPE.AREA_TROOP_DAMAGE_BOOST] = gAttributeEnum.BATTLE_DAMAGE_RATE_RANGE
	;(nil)[ROARING_FLAME_WAR_SKILL_TYPE.AREA_MARCH_SPEED_BOOST] = gAttributeEnum.MARCH_SPEED_BOOST_RAGNE
	;(nil)[ROARING_FLAME_WAR_SKILL_TYPE.AREA_CURE_SOLDIER_SPEED_BOOST] = gAttributeEnum.CURE_SOLDIER_SPEED_BOOST_RANGE
	local (nil)[ROARING_FLAME_WAR_SKILL_TYPE.AREA_HALLOFWAR_ARMY_UP], ret = gAttributeEnum.HALLOFWAR_ARMY_UP_RANGE, nil
	return ret
end)
function roaringFlameWarRead.skillTypeToAttr(skillType)
	return roaringFlameWarRead.skillTypeToAttrMap[skillType]
end
roaringFlameWarRead:defineValue("attrToSkillTypeMap", function()
	local _ENV, ret
	for k, v in pairs(roaringFlameWarRead.skillTypeToAttrMap) do
		ret[v] = k
	end
	return ret
end)
function roaringFlameWarRead.attrToSkillType(attr)
	return roaringFlameWarRead.attrToSkillTypeMap[attr]
end
function _UPVALUE2_()
	local _ENV, ret
	for k, v in pairs(roaringFlameWarRead.skillTypeToAttrMap) do
		ret[v] = k
	end
	return ret
end
;(function()
	local _ENV, ret
	for k, v in pairs(roaringFlameWarRead.skillTypeToAttrMap) do
		ret[v] = k
	end
	return ret
end)[1] = "atlantiswar_scopeskill_des"
;(function()
	local _ENV, ret
	for k, v in pairs(roaringFlameWarRead.skillTypeToAttrMap) do
		ret[v] = k
	end
	return ret
end)[2] = false
roaringFlameWarRead:defineValue("atlantiswar_scopeskill_des", function()
	local _ENV, ret
	for k, v in pairs(roaringFlameWarRead.skillTypeToAttrMap) do
		ret[v] = k
	end
	return ret
end)
function roaringFlameWarRead.getMapBufValueType(buffId)
	return roaringFlameWarRead.atlantiswar_scopeskill_des[buffId].type
end
function roaringFlameWarRead.maxBuffPlus2configValue(buffId, plus)
	local valueType = roaringFlameWarRead.getMapBufValueType(buffId)
	if valueType == 1 then
		return plus / 10
	else
		return plus
	end
end
function roaringFlameWarRead.configValue2maxBuffPlus(buffId, value)
	local valueType = roaringFlameWarRead.getMapBufValueType(buffId)
	if valueType == 1 then
		return value * 10
	else
		return value
	end
end
function _UPVALUE2_()
	local _ENV, ret
	for k, v in pairs(roaringFlameWarRead.skillTypeToAttrMap) do
		ret[v] = k
	end
	return ret
end
;(function()
	local _ENV, ret
	for k, v in pairs(roaringFlameWarRead.skillTypeToAttrMap) do
		ret[v] = k
	end
	return ret
end)[1] = "flames_dunes_skill_display"
;(function()
	local _ENV, ret
	for k, v in pairs(roaringFlameWarRead.skillTypeToAttrMap) do
		ret[v] = k
	end
	return ret
end)[2] = false
roaringFlameWarRead:defineValue("flames_dunes_skill_display", function()
	local _ENV, ret
	for k, v in pairs(roaringFlameWarRead.skillTypeToAttrMap) do
		ret[v] = k
	end
	return ret
end)
function roaringFlameWarRead.getSkillDisplay(...)
	return roaringFlameWarRead.flames_dunes_skill_display
end
function roaringFlameWarRead.getSkillDisplayConfig(skillId)
	return roaringFlameWarRead.flames_dunes_skill_display[skillId]
end
function roaringFlameWarRead.getSkillIconSprite(icon, quality)
	local iconSprite = display.newSprite("#" .. icon)
	local qImage = gAtlantisQualityConfig[quality].qImage
	local qSprite = display.newSprite("#" .. qImage)
	qSprite:addTo(iconSprite)
	local sSize = iconSprite:getContentSize()
	qSprite:setPosition(sSize.width / 2, sSize.height / 2)
	return iconSprite
end
function roaringFlameWarRead.getSkillName(skillId)
	local cfg = roaringFlameWarRead.getSkillDisplayConfig(skillId)
	return i18n(cfg.name)
end
function roaringFlameWarRead.getSkillNameWithColor(skillId)
	local skillName = roaringFlameWarRead.getSkillName(skillId)
	local skillColor = roaringFlameWarRead.getSkillQualityColor(skillId)
	roaringFlameWarRead = nil
	;(nil).color = skillColor
	return SoraDWrapHtmlTagByStyle(skillName, nil)
end
function roaringFlameWarRead.getSkillQuality(skillId)
	local cfg = roaringFlameWarRead.getSkillDisplayConfig(skillId)
	return cfg.quality
end
function roaringFlameWarRead.getSkillQualityColor(skillId)
	local quality = roaringFlameWarRead.getSkillQuality(skillId)
	local qConfig = gAtlantisQualityConfig[quality]
	return qConfig.color
end
function roaringFlameWarRead.getSkillShowData(sortType, config)
	local roaringFlameWarRead, ret
	config = config or roaringFlameWarRead.getSkillDisplay()
	for k, v in pairs(config) do
		if sortType == 1 then
			if not ret[v.quality] then
				ret[v.quality], roaringFlameWarRead = nil, nil
			end
			table.insert(ret[v.quality], v)
		else
			if not ret[v.sort] then
				ret[v.sort], roaringFlameWarRead = ret[v.quality], ret[v.quality]
			end
			table.insert(ret[v.sort], v)
		end
	end
	for k, v in pairs(ret) do
		table.sort(v, function(a, b)
			return a.skillID < b.skillID
		end)
	end
	return ret
end
function _UPVALUE2_()
	local _ENV, ret
	for k, v in pairs(roaringFlameWarRead.skillTypeToAttrMap) do
		ret[v] = k
	end
	return ret
end
;(function()
	local _ENV, ret
	for k, v in pairs(roaringFlameWarRead.skillTypeToAttrMap) do
		ret[v] = k
	end
	return ret
end)[1] = "flames_dunes_battle_pass_num"
;(function()
	local _ENV, ret
	for k, v in pairs(roaringFlameWarRead.skillTypeToAttrMap) do
		ret[v] = k
	end
	return ret
end)[2] = true
roaringFlameWarRead:defineValue("flames_dunes_battle_pass_num", function()
	local _ENV, ret
	for k, v in pairs(roaringFlameWarRead.skillTypeToAttrMap) do
		ret[v] = k
	end
	return ret
end)
function roaringFlameWarRead.getPassNumConfig()
	return roaringFlameWarRead.flames_dunes_battle_pass_num
end
function roaringFlameWarRead.getPassCfgByNum(num)
	local index = 0
	for k, v in ipairs(roaringFlameWarRead.flames_dunes_battle_pass_num) do
		if num >= v.lv then
			index = v.index
		end
	end
	return index
end
roaringFlameWarRead:defineValue("flames_dunes_battle_pass", function()
	local config = require_data("flames_dunes_battle_pass", true, true).data
	local _ENV, ret = "flames_dunes_battle_pass", "flames_dunes_battle_pass"
	for k, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.unlock_reward = serviceFunctions.tableFormat(v.unlock_reward, nil)
		table.insert(ret, v)
	end
	return ret
end)
function roaringFlameWarRead.getDecreeLvEXP(exp)
	local total = 0
	local ret = 0
	local nextExp = 0
	local remainExp = exp
	for lv, v in ipairs(roaringFlameWarRead.flames_dunes_battle_pass) do
		total = total + v.score
		nextExp = v.score
		if exp < total then
			break
		end
		ret = lv
		remainExp = remainExp - v.score
	end
	local maxLv = #roaringFlameWarRead.flames_dunes_battle_pass
	if ret >= maxLv then
		local remainder = exp - total
		local maxLvExp = roaringFlameWarRead.flames_dunes_battle_pass[maxLv].score
		local addLv = math.floor(remainder / maxLvExp)
		ret = ret + addLv
		nextExp = maxLvExp
		remainExp = remainder % maxLvExp
	end
	return ret, remainExp, nextExp
end
function roaringFlameWarRead.getDecreeLvList()
	return roaringFlameWarRead.flames_dunes_battle_pass
end
function roaringFlameWarRead.getDecreeLvAddCfg()
	return roaringFlameWarRead.flames_dunes_battle_pass[#roaringFlameWarRead.flames_dunes_battle_pass]
end
function roaringFlameWarRead.getDecreeAdvRewards()
	local _ENV, itemList
	for _, v in ipairs(roaringFlameWarRead.flames_dunes_battle_pass) do
		for _, data in ipairs(v.unlock_reward) do
			itemList[data.id] = (itemList[data.id] or 0) + data.count
		end
	end
	local _ENV, itemArray = (for generator), ipairs(roaringFlameWarRead.flames_dunes_battle_pass)
	for id, count in pairs(itemList) do
		_ENV = nil
		;(nil).id = id
		;(nil).count = count
		table.insert(itemArray, nil)
	end
	table.sort(itemArray, function(a, b)
		return a.id < b.id
	end)
	return itemArray
end
function _UPVALUE2_()
	local config = require_data("flames_dunes_battle_pass", true, true).data
	local _ENV, ret = "flames_dunes_battle_pass", "flames_dunes_battle_pass"
	for k, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.unlock_reward = serviceFunctions.tableFormat(v.unlock_reward, nil)
		table.insert(ret, v)
	end
	return ret
end
;(function()
	local config = require_data("flames_dunes_battle_pass", true, true).data
	local _ENV, ret = "flames_dunes_battle_pass", "flames_dunes_battle_pass"
	for k, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.unlock_reward = serviceFunctions.tableFormat(v.unlock_reward, nil)
		table.insert(ret, v)
	end
	return ret
end)[1] = "flames_dunes_task"
;(function()
	local config = require_data("flames_dunes_battle_pass", true, true).data
	local _ENV, ret = "flames_dunes_battle_pass", "flames_dunes_battle_pass"
	for k, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.unlock_reward = serviceFunctions.tableFormat(v.unlock_reward, nil)
		table.insert(ret, v)
	end
	return ret
end)[2] = true
roaringFlameWarRead:defineValue("flames_dunes_task_ori", function()
	local config = require_data("flames_dunes_battle_pass", true, true).data
	local _ENV, ret = "flames_dunes_battle_pass", "flames_dunes_battle_pass"
	for k, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.reward = serviceFunctions.tableFormat(v.reward, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.unlock_reward = serviceFunctions.tableFormat(v.unlock_reward, nil)
		table.insert(ret, v)
	end
	return ret
end)
roaringFlameWarRead:defineValue("flames_dunes_task", function()
	local config = require_data("flames_dunes_task", true, true).data
	local _ENV, ret = "flames_dunes_task", "flames_dunes_task"
	for k, v in ipairs(config) do
		if not ret[v.taskType] then
			ret[v.taskType], _ENV = nil, nil
		end
		table.insert(ret[v.taskType], v.taskID)
	end
	return ret
end)
function roaringFlameWarRead.getTaskList(taskType)
	return roaringFlameWarRead.flames_dunes_task[taskType]
end
function roaringFlameWarRead.getTaskTypeByTaskID(taskID)
	for _, v in ipairs(roaringFlameWarRead.flames_dunes_task_ori) do
		if v.taskID == taskID then
			return v.taskType
		end
	end
end
function roaringFlameWarRead.getJumpTypeByTaskID(taskID)
	for _, v in ipairs(roaringFlameWarRead.flames_dunes_task_ori) do
		if v.taskID == taskID then
			return v.jumpType
		end
	end
end
function roaringFlameWarRead.getIndexByTaskID(taskID)
	for _, v in ipairs(roaringFlameWarRead.flames_dunes_task_ori) do
		if v.taskID == taskID then
			return v.index
		end
	end
end
roaringFlameWarRead:defineValue("flames_dunes_rank", function()
	local config = require_data("flames_dunes_rank", true, true).data
	local _ENV, ret = "flames_dunes_rank", "flames_dunes_rank"
	for k, v in ipairs(config) do
		if not ret[v.overall_type] then
			ret[v.overall_type], _ENV = nil, nil
		end
		if not ret[v.overall_type][v.detail_type] then
			ret[v.overall_type][v.detail_type], _ENV = nil, nil
		end
		_ENV = v.detail_type
		v.detail_type.rank = v.rank
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.detail_type.reward = serviceFunctions.tableFormat(v.reward, nil)
		table.insert(ret[v.overall_type][v.detail_type], v.detail_type)
	end
	return ret
end)
function roaringFlameWarRead.getRankList(overall_type, detail_type)
	if overall_type == 1 and detail_type == 1 then
		overall_type = 3
		return roaringFlameWarRead.flames_dunes_rank[overall_type]
	elseif overall_type == 2 and detail_type == 5 then
		overall_type = 4
		return roaringFlameWarRead.flames_dunes_rank[overall_type]
	else
		return roaringFlameWarRead.flames_dunes_rank[overall_type][detail_type]
	end
end
roaringFlameWarRead:defineValue("flames_dunes_collection", function()
	local baseConfig = require_data("flames_dunes_collection", true, true).data
	_UPVALUE2_ = true
	;(true)[1] = "type"
	;(true)[2] = "level"
	return roaringFlameWarRead.getKeyListConfig(baseConfig, true)
end)
_ENV, roaringFlameWarRead.getCollectSpeed = function(objId)
	local subType = roaringFlameWarRead.getBuildSubType(objId)
	local resType = roaringFlameWarRead.getResTypeBySubType(subType)
	local level = roaringFlameWarRead.getBuildLevel(objId)
	local cfg = roaringFlameWarRead.flames_dunes_collection[resType][level]
	return cfg[1].cost_res
end, function(objId)
	local subType = roaringFlameWarRead.getBuildSubType(objId)
	local resType = roaringFlameWarRead.getResTypeBySubType(subType)
	local level = roaringFlameWarRead.getBuildLevel(objId)
	local cfg = roaringFlameWarRead.flames_dunes_collection[resType][level]
	return cfg[1].cost_res
end
;(function(objId)
	local subType = roaringFlameWarRead.getBuildSubType(objId)
	local resType = roaringFlameWarRead.getResTypeBySubType(subType)
	local level = roaringFlameWarRead.getBuildLevel(objId)
	local cfg = roaringFlameWarRead.flames_dunes_collection[resType][level]
	return cfg[1].cost_res
end)[gWorldTypeServerDef.subTypeRoaringFlameWarMithrilMine] = 1
local (function(objId)
	local subType = roaringFlameWarRead.getBuildSubType(objId)
	local resType = roaringFlameWarRead.getResTypeBySubType(subType)
	local level = roaringFlameWarRead.getBuildLevel(objId)
	local cfg = roaringFlameWarRead.flames_dunes_collection[resType][level]
	return cfg[1].cost_res
end)[gWorldTypeServerDef.subTypeRoaringFlameWarGoldMine], subType2resType = 2, function(objId)
	local subType = roaringFlameWarRead.getBuildSubType(objId)
	local resType = roaringFlameWarRead.getResTypeBySubType(subType)
	local level = roaringFlameWarRead.getBuildLevel(objId)
	local cfg = roaringFlameWarRead.flames_dunes_collection[resType][level]
	return cfg[1].cost_res
end
function roaringFlameWarRead.getResTypeBySubType(subType)
	return subType2resType[subType]
end
function roaringFlameWarRead.getResName(resType)
	_ENV = nil
	;(nil)[1] = i18n("common_text_024")
	local (nil)[2], config = i18n("common_text_020"), nil
	return config[resType]
end
_UPVALUE2_ = "flames_dunes_task"
;("flames_dunes_task")[1] = "flames_dunes_city_box"
;("flames_dunes_task")[2] = true
roaringFlameWarRead:defineValue("flames_dunes_city_box", "flames_dunes_task")
function roaringFlameWarRead.getCityBoxConfig(level)
	return roaringFlameWarRead.flames_dunes_city_box[level]
end
function roaringFlameWarRead.getCityBoxMaxLv(...)
	return #roaringFlameWarRead.flames_dunes_city_box
end
function roaringFlameWarRead.getCityBoxReward(level)
	local cfg = roaringFlameWarRead.getCityBoxConfig(level)
	return cfg.box_reward
end
function roaringFlameWarRead.getCityFirstReward(level)
	local cfg = roaringFlameWarRead.getCityBoxConfig(level)
	return cfg.first_reward
end
function roaringFlameWarRead.getCityHonorPoints(level)
	local cfg = roaringFlameWarRead.getCityBoxConfig(level)
	return cfg.honor_points
end
function roaringFlameWarRead.getCityTechnologyPoints(level)
	local cfg = roaringFlameWarRead.getCityBoxConfig(level)
	return cfg.technology_points
end
roaringFlameWarRead:defineValue("flames_dunes_rule", function()
	local baseConfig = require_data("flames_dunes_rule", false, true).data
	return roaringFlameWarRead.getClassTypeConfig(baseConfig, "title_type")
end)
function roaringFlameWarRead.getFAQConfig(...)
	return roaringFlameWarRead.flames_dunes_rule
end
roaringFlameWarRead:defineValue("flames_dunes_rule_point", function()
	local baseConfig = require_data("flames_dunes_rule_point", false, true).data
	return roaringFlameWarRead.getClassTypeConfig(baseConfig, "type")
end)
function roaringFlameWarRead.getFAQPointConfig(pType)
	return roaringFlameWarRead.flames_dunes_rule_point[pType]
end
roaringFlameWarRead:defineValue("flames_dunes_weekly_pack", function()
	local config = require_data("flames_dunes_weekly_pack", true, true).data
	local _ENV, ret = "flames_dunes_weekly_pack", "flames_dunes_weekly_pack"
	for k, v in ipairs(config) do
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.rewrad = serviceFunctions.tableFormat(v.rewrad, nil)
		table.insert(ret, v)
	end
	return ret
end)
function roaringFlameWarRead.getWeeklyPackCfg(day)
	return roaringFlameWarRead.flames_dunes_weekly_pack[day]
end
roaringFlameWarRead:defineValue("flames_dunes_turntable", function()
	local baseConfig = require_data("flames_dunes_turntable", true, true).data
	return roaringFlameWarRead.getClassTypeConfig(baseConfig, "type")
end)
function roaringFlameWarRead.getTurntableAward()
	local _ENV, ret
	for _, v in ipairs(roaringFlameWarRead.flames_dunes_turntable[1]) do
		_ENV = nil
		;(nil).itemid = v.rewards[1]
		;(nil).count = v.rewards[2]
		;(nil).rare = v.rare
		local (nil).index, single = v.position, nil
		ret[v.position] = single
	end
	return ret
end
function roaringFlameWarRead.getTurntableStageCfg()
	return roaringFlameWarRead.flames_dunes_turntable[2]
end
roaringFlameWarRead:defineValue("flames_dunes_phoenix_task", function()
	local config = require_data("flames_dunes_phoenix_task", true, true).data
	local _ENV, ret = "flames_dunes_phoenix_task", "flames_dunes_phoenix_task"
	for k, v in ipairs(config) do
		if not ret[v.type] then
			ret[v.type], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.rewards = serviceFunctions.tableFormat(v.rewards, nil)
		table.insert(ret[v.type], v)
	end
	return ret
end)
function roaringFlameWarRead.getPhoenixTaskCfg(taskType)
	if taskType then
		return roaringFlameWarRead.flames_dunes_phoenix_task[taskType]
	else
		local roaringFlameWarRead, ret = roaringFlameWarRead.flames_dunes_phoenix_task[taskType], roaringFlameWarRead.flames_dunes_phoenix_task[taskType]
		for taskType, v in ipairs(roaringFlameWarRead.flames_dunes_phoenix_task) do
			for _, cfg in ipairs(v) do
				table.insert(ret, cfg)
			end
		end
		return ret
	end
end
roaringFlameWarRead:defineValue("flames_dunes_cave", function()
	local config = require_data("flames_dunes_cave", true, true).data
	local _ENV, ret = "flames_dunes_cave", "flames_dunes_cave"
	for k, v in ipairs(config) do
		if not ret[v.type] then
			ret[v.type], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.rewards = serviceFunctions.tableFormat(v.rewards, nil)
		table.insert(ret[v.type], v)
	end
	return ret
end)
function roaringFlameWarRead.getCaveRewardCfg(type)
	return roaringFlameWarRead.flames_dunes_cave[type]
end
function _UPVALUE2_()
	local config = require_data("flames_dunes_cave", true, true).data
	local _ENV, ret = "flames_dunes_cave", "flames_dunes_cave"
	for k, v in ipairs(config) do
		if not ret[v.type] then
			ret[v.type], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.rewards = serviceFunctions.tableFormat(v.rewards, nil)
		table.insert(ret[v.type], v)
	end
	return ret
end
;(function()
	local config = require_data("flames_dunes_cave", true, true).data
	local _ENV, ret = "flames_dunes_cave", "flames_dunes_cave"
	for k, v in ipairs(config) do
		if not ret[v.type] then
			ret[v.type], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.rewards = serviceFunctions.tableFormat(v.rewards, nil)
		table.insert(ret[v.type], v)
	end
	return ret
end)[1] = "flames_dunes_actiity_show"
;(function()
	local config = require_data("flames_dunes_cave", true, true).data
	local _ENV, ret = "flames_dunes_cave", "flames_dunes_cave"
	for k, v in ipairs(config) do
		if not ret[v.type] then
			ret[v.type], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.rewards = serviceFunctions.tableFormat(v.rewards, nil)
		table.insert(ret[v.type], v)
	end
	return ret
end)[2] = false
roaringFlameWarRead:defineValue("flames_dunes_actiity_show", function()
	local config = require_data("flames_dunes_cave", true, true).data
	local _ENV, ret = "flames_dunes_cave", "flames_dunes_cave"
	for k, v in ipairs(config) do
		if not ret[v.type] then
			ret[v.type], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.rewards = serviceFunctions.tableFormat(v.rewards, nil)
		table.insert(ret[v.type], v)
	end
	return ret
end)
function roaringFlameWarRead.getActivityShowConfig(activityID)
	return roaringFlameWarRead.flames_dunes_actiity_show[activityID]
end
function roaringFlameWarRead.getActivityShowName(activityID)
	local cfg = roaringFlameWarRead.getActivityShowConfig(activityID)
	return i18n(cfg.name)
end
function roaringFlameWarRead.getActivityShowBg(activityID)
	local cfg = roaringFlameWarRead.getActivityShowConfig(activityID)
	return cfg.activity_bg
end
function roaringFlameWarRead.getActivityShowRewards(activityID)
	local cfg = roaringFlameWarRead.getActivityShowConfig(activityID)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	return serviceFunctions.tableFormat(cfg.rewards, nil)
end
function _UPVALUE2_()
	local config = require_data("flames_dunes_cave", true, true).data
	local _ENV, ret = "flames_dunes_cave", "flames_dunes_cave"
	for k, v in ipairs(config) do
		if not ret[v.type] then
			ret[v.type], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.rewards = serviceFunctions.tableFormat(v.rewards, nil)
		table.insert(ret[v.type], v)
	end
	return ret
end
;(function()
	local config = require_data("flames_dunes_cave", true, true).data
	local _ENV, ret = "flames_dunes_cave", "flames_dunes_cave"
	for k, v in ipairs(config) do
		if not ret[v.type] then
			ret[v.type], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.rewards = serviceFunctions.tableFormat(v.rewards, nil)
		table.insert(ret[v.type], v)
	end
	return ret
end)[1] = "flames_dunes_battle_pass_show"
;(function()
	local config = require_data("flames_dunes_cave", true, true).data
	local _ENV, ret = "flames_dunes_cave", "flames_dunes_cave"
	for k, v in ipairs(config) do
		if not ret[v.type] then
			ret[v.type], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.rewards = serviceFunctions.tableFormat(v.rewards, nil)
		table.insert(ret[v.type], v)
	end
	return ret
end)[2] = false
roaringFlameWarRead:defineValue("flames_dunes_battle_pass_show", function()
	local config = require_data("flames_dunes_cave", true, true).data
	local _ENV, ret = "flames_dunes_cave", "flames_dunes_cave"
	for k, v in ipairs(config) do
		if not ret[v.type] then
			ret[v.type], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.rewards = serviceFunctions.tableFormat(v.rewards, nil)
		table.insert(ret[v.type], v)
	end
	return ret
end)
function roaringFlameWarRead.getBattlePassShow()
	return roaringFlameWarRead.flames_dunes_battle_pass_show
end
roaringFlameWarRead:defineValue("showRolygonSubType", function()
	_ENV = nil
	;(nil)[gWorldTypeServerDef.subTypeRoaringFlameWarInitCity] = true
	local (nil)[gWorldTypeServerDef.subTypeRoaringFlameWarFort], ret = true, nil
	return ret
end)
function roaringFlameWarRead.getShowRolygonSubType(...)
	return roaringFlameWarRead.showRolygonSubType
end
function roaringFlameWarRead.checkShowRolygonSubType(subType)
	return roaringFlameWarRead.showRolygonSubType[subType]
end
roaringFlameWarRead:defineValue("manorlineColorArray", function()
	local roaringFlameWarRead, ret
	local campMax = roaringFlameWarRead.getCampCount()
	for camp = 1, campMax do
		local c = roaringFlameWarRead.getCampColor(camp)
		ret[#ret + 1] = c.r / 255
		ret[#ret + 1] = c.g / 255
		ret[#ret + 1] = c.b / 255
	end
	ret[#ret + 1] = 1
	ret[#ret + 1] = 1
	ret[#ret + 1] = 1
	return ret
end)
function roaringFlameWarRead.getManorlineColorArray(...)
	return roaringFlameWarRead.manorlineColorArray
end
function _UPVALUE2_()
	local roaringFlameWarRead, ret
	local campMax = roaringFlameWarRead.getCampCount()
	for camp = 1, campMax do
		local c = roaringFlameWarRead.getCampColor(camp)
		ret[#ret + 1] = c.r / 255
		ret[#ret + 1] = c.g / 255
		ret[#ret + 1] = c.b / 255
	end
	ret[#ret + 1] = 1
	ret[#ret + 1] = 1
	ret[#ret + 1] = 1
	return ret
end
;(function()
	local roaringFlameWarRead, ret
	local campMax = roaringFlameWarRead.getCampCount()
	for camp = 1, campMax do
		local c = roaringFlameWarRead.getCampColor(camp)
		ret[#ret + 1] = c.r / 255
		ret[#ret + 1] = c.g / 255
		ret[#ret + 1] = c.b / 255
	end
	ret[#ret + 1] = 1
	ret[#ret + 1] = 1
	ret[#ret + 1] = 1
	return ret
end)[1] = "flames_dunes_plot"
;(function()
	local roaringFlameWarRead, ret
	local campMax = roaringFlameWarRead.getCampCount()
	for camp = 1, campMax do
		local c = roaringFlameWarRead.getCampColor(camp)
		ret[#ret + 1] = c.r / 255
		ret[#ret + 1] = c.g / 255
		ret[#ret + 1] = c.b / 255
	end
	ret[#ret + 1] = 1
	ret[#ret + 1] = 1
	ret[#ret + 1] = 1
	return ret
end)[2] = false
roaringFlameWarRead:defineValue("flames_dunes_plot", function()
	local roaringFlameWarRead, ret
	local campMax = roaringFlameWarRead.getCampCount()
	for camp = 1, campMax do
		local c = roaringFlameWarRead.getCampColor(camp)
		ret[#ret + 1] = c.r / 255
		ret[#ret + 1] = c.g / 255
		ret[#ret + 1] = c.b / 255
	end
	ret[#ret + 1] = 1
	ret[#ret + 1] = 1
	ret[#ret + 1] = 1
	return ret
end)
function roaringFlameWarRead.get_flames_dunes_plot(...)
	return roaringFlameWarRead.flames_dunes_plot
end
function roaringFlameWarRead.getPlotCount(...)
	return #roaringFlameWarRead.flames_dunes_plot
end
function roaringFlameWarRead.getPlotCfg(index)
	return roaringFlameWarRead.flames_dunes_plot[index]
end
function roaringFlameWarRead.getPlotName(plotType)
	local cfg = roaringFlameWarRead.getPlotCfg(plotType)
	return i18n(cfg.name)
end
function roaringFlameWarRead.getPlotHtmlColor(plotType)
	local cfg = roaringFlameWarRead.getPlotCfg(plotType)
	return cfg.color
end
function roaringFlameWarRead.getPlotColor(plotType)
	local htmlColor = roaringFlameWarRead.getPlotHtmlColor(plotType)
	return SoraDHtmlColor2RGB(htmlColor)
end
function roaringFlameWarRead.getPlotCoord(plotType)
	local cfg = roaringFlameWarRead.getPlotCfg(plotType)
	return cfg.coord
end
function roaringFlameWarRead.getPlotCoordList(plotType)
	local coord = roaringFlameWarRead.getPlotCoord(plotType)
	_UPVALUE2_ = nil
	;(nil)[1] = "x"
	;(nil)[2] = "y"
	return serviceFunctions.tableFormat(coord, nil)
end
return roaringFlameWarRead
