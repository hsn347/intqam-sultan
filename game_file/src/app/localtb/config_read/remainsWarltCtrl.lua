local remainsWarltCtrl = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	local createData = function(name)
		remainsWarltCtrl.posRefRemainsWarBuilding, remainsWarltCtrl, remainsWarltCtrl.remainsWarBuilding, remainsWarltCtrl = nil, nil, nil, nil
		local remainsWarBuilding = require_once("app." .. _G.LocalTblPath .. ".config_server.ruins_building_cost")
		for id, v in pairs(remainsWarBuilding) do
			local build = v
			build.x = build.x - gPointClientPointPlus
			build.y = build.y - gPointClientPointPlus
			remainsWarltCtrl.remainsWarBuilding[id] = build
			v.id = id
			v.objId = id
			local x, y = v.x, v.y
			if not remainsWarltCtrl.posRefRemainsWarBuilding[x] then
				remainsWarltCtrl.posRefRemainsWarBuilding[x], remainsWarltCtrl = nil, nil
			end
			remainsWarltCtrl.posRefRemainsWarBuilding[x][y] = v
		end
		if name == "remainsWarBuilding" then
			return remainsWarltCtrl.remainsWarBuilding
		elseif name == "posRefRemainsWarBuilding" then
			return remainsWarltCtrl.posRefRemainsWarBuilding
		end
	end
	remainsWarltCtrl:defineValue("remainsWarBuilding", createData)
	remainsWarltCtrl:defineValue("posRefRemainsWarBuilding", createData)
	remainsWarltCtrl:defineValue("remainsWarRewards", function()
		remainsWarltCtrl.remainsWarRewards, remainsWarltCtrl = nil, nil
		local remainsWarRewards = require_once("app." .. _G.LocalTblPath .. ".config_server.segment_rewaeds")
		local remainsWarltCtrl, ret = "app." .. _G.LocalTblPath .. ".config_server.segment_rewaeds", "app." .. _G.LocalTblPath .. ".config_server.segment_rewaeds"
		for _, v in ipairs(remainsWarRewards) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local reward = serviceFunctions.tableFormat(v.award, nil)
			if not ret[v.classType] then
				ret[v.classType], remainsWarltCtrl = nil, nil
			end
			if not ret[v.classType][v.dan] then
				ret[v.classType][v.dan], remainsWarltCtrl = "id", "id"
			end
			if not ret[v.classType][v.dan][v.evaluate] then
				ret[v.classType][v.dan][v.evaluate], remainsWarltCtrl = "id", "id"
			end
			ret[v.classType][v.dan][v.evaluate] = reward
		end
		remainsWarltCtrl.remainsWarRewards = ret
		return remainsWarltCtrl.remainsWarRewards
	end)
	remainsWarltCtrl:defineValue("remainsWarRewardsStrenght", function()
		local remainsWarRewardsStrenght = require_once("app." .. _G.LocalTblPath .. ".config_server.ruins_strenght_reward")
		local _ENV, ret = "app." .. _G.LocalTblPath .. ".config_server.ruins_strenght_reward", "app." .. _G.LocalTblPath .. ".config_server.ruins_strenght_reward"
		for k, v in ipairs(remainsWarRewardsStrenght) do
			if not ret[v.classType] then
				ret[v.classType], _ENV = nil, nil
			end
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local reward = serviceFunctions.tableFormat(v.reward, nil)
			table.insert(ret[v.classType], reward)
		end
		remainsWarltCtrl.remainsWarRewardsStrenght = ret
		return remainsWarltCtrl.remainsWarRewardsStrenght
	end)
	remainsWarltCtrl:defineValue("remainsWarRewardsStage", function()
		local remainsWarRewardsStage = require_once("app." .. _G.LocalTblPath .. ".config_server.ruins_stage_reward")
		local _ENV, ret = "app." .. _G.LocalTblPath .. ".config_server.ruins_stage_reward", "app." .. _G.LocalTblPath .. ".config_server.ruins_stage_reward"
		for k, v in ipairs(remainsWarRewardsStage) do
			if not ret[v.classType] then
				ret[v.classType], _ENV = nil, nil
			end
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local reward = serviceFunctions.tableFormat(v.reward, nil)
			_ENV = v.reward
			v.reward.min = v.rank[1]
			v.reward.max = v.rank[2]
			local v.reward.reward, data = reward, v.reward
			table.insert(ret[v.classType], data)
		end
		remainsWarltCtrl.remainsWarRewardsStage = ret
		return remainsWarltCtrl.remainsWarRewardsStage
	end)
	remainsWarltCtrl:defineValue("remainsWarConfig", function()
		local remainsWarConfig = require_once("app." .. _G.LocalTblPath .. ".config_server.segment_config")
		local _ENV, ret = "app." .. _G.LocalTblPath .. ".config_server.segment_config", "app." .. _G.LocalTblPath .. ".config_server.segment_config"
		for _, v in ipairs(remainsWarConfig) do
			if not ret[v.dan] then
				_ENV = ret[v.dan]
			end
			ret[v.dan] = ret[v.dan]
			local _ENV, curSegment = v.dan, v.dan
			ret[v.dan][v.star] = curSegment
			curSegment.min = v.Point[1]
			curSegment.max = v.Point[2]
		end
		remainsWarltCtrl.remainsWarConfig = ret
		return remainsWarltCtrl.remainsWarConfig
	end)
	remainsWarltCtrl:defineValue("ruinsWarGradePoint", function()
		remainsWarltCtrl.ruinsWarGradePoint, remainsWarltCtrl = nil, nil
		local ruinsWarGradePoint = require_once("app." .. _G.LocalTblPath .. ".config_server.segment_score_config")
		remainsWarltCtrl.ruinsWarGradePoint = ruinsWarGradePoint
		return remainsWarltCtrl.ruinsWarGradePoint
	end)
end
init()
function remainsWarltCtrl.getRemainsWarBuilding()
	return remainsWarltCtrl.remainsWarBuilding
end
function remainsWarltCtrl.getRemainsWarBuildingById(id)
	return remainsWarltCtrl.remainsWarBuilding[id]
end
function remainsWarltCtrl.getRemainsWarBuildingByPos(x, y)
	if remainsWarltCtrl.posRefRemainsWarBuilding[x] then
		return remainsWarltCtrl.posRefRemainsWarBuilding[x][y]
	end
end
function remainsWarltCtrl.getRewars()
	local classType = SoraDGetCtrl("remainsTeamCtrl"):getGroup()
	return remainsWarltCtrl.remainsWarRewards[classType]
end
function remainsWarltCtrl.getRewarsStrenght()
	local classType = SoraDGetCtrl("remainsTeamCtrl"):getGroup()
	return remainsWarltCtrl.remainsWarRewardsStrenght[classType]
end
function remainsWarltCtrl.getRewarsStage()
	local classType = SoraDGetCtrl("remainsTeamCtrl"):getGroup()
	return remainsWarltCtrl.remainsWarRewardsStage[classType]
end
function remainsWarltCtrl.getDanPoint(danID, star)
	if not star then
		if danID == _G.RUINS_WAR_SEGMENT.RUINS_WAR_SEGMENT_7 then
			star = 0
		else
			star = 1
		end
	end
	return remainsWarltCtrl.remainsWarConfig[danID][star]
end
function remainsWarltCtrl.getDanIDByNewSeason(danID)
	local segment = danID
	if segment == _G.RUINS_WAR_SEGMENT.RUINS_WAR_SEGMENT_7 or segment == _G.RUINS_WAR_SEGMENT.RUINS_WAR_SEGMENT_8 then
		segment = _G.RUINS_WAR_SEGMENT.RUINS_WAR_SEGMENT_6
	end
	segment = segment - 2
	if segment < _G.RUINS_WAR_SEGMENT.RUINS_WAR_SEGMENT_1 then
		segment = _G.RUINS_WAR_SEGMENT.RUINS_WAR_SEGMENT_1
	end
	return segment
end
function remainsWarltCtrl.getRuinsWarGrade(points)
	if points then
		for _, v in ipairs(remainsWarltCtrl.ruinsWarGradePoint) do
			if points >= v.grade[1] then
				return v.evaluate
			end
		end
	end
end
return remainsWarltCtrl
