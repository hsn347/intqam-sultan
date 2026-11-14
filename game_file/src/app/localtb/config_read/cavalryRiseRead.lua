local cavalryRiseRead = include("aAReadClass").new()
local activityID = gActivityTimeActivityID.CAVALRY_RISE_ACTIVITY
local isInited = false
function cavalryRiseRead:init()
	if isInited then
		return
	end
	local createData = function(name)
		self.levelList, self = nil, nil
		local levelList = require_once("app." .. _G.LocalTblPath .. ".config_server.cavalry_lv_exp")
		for _, v in ipairs(levelList) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local bronzeAward = serviceFunctions.tableFormat(v.bronzeAward, nil)
			v.bronzeAward = bronzeAward
			_UPVALUE2_ = "id"
			;("id")[1] = "id"
			;("id")[2] = "count"
			local goldAward = serviceFunctions.tableFormat(v.goldAward, "id")
			v.goldAward = goldAward
			v.index = v.lv
			if not self.levelList[v.classType] then
				self.levelList[v.classType], self = "id", "id"
			end
			self.levelList[v.classType][v.lv] = v
		end
		self.levelMaxList, self = ipairs(levelList)
		local levelMaxList = require_once("app." .. _G.LocalTblPath .. ".config_server.cavalry_lv_reward")
		for _, v in ipairs(levelMaxList) do
			_UPVALUE2_ = v.lv
			v.lv[1] = "id"
			v.lv[2] = "count"
			local bronzeAward = serviceFunctions.tableFormat(v.bronzeAward, v.lv)
			v.bronzeAward = bronzeAward
			_UPVALUE2_ = "id"
			;("id")[1] = "id"
			;("id")[2] = "count"
			local goldAward = serviceFunctions.tableFormat(v.goldAward, "id")
			v.goldAward = goldAward
			local index = #self.levelList[v.classType] + 1
			v.lv = index
			v.index = index
			self.levelList[v.classType][index] = v
			self.levelMaxList[v.classType] = v
		end
		if name == "levelList" then
			return self.levelList
		elseif name == "levelMaxList" then
			return self.levelMaxList
		end
	end
	cavalryRiseRead:defineValue("levelList", createData)
	cavalryRiseRead:defineValue("levelMaxList", createData)
	cavalryRiseRead:defineValue("awardShowList", function()
		self.awardShowList, self = nil, nil
		local awardShowList = require_once("app." .. _G.LocalTblPath .. ".config_client.cavalry_reward_show")
		for _, v in ipairs(awardShowList) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local award = serviceFunctions.tableFormat(v.award, nil)
			v.award = award
			if not self.awardShowList[v.classType] then
				self.awardShowList[v.classType], self = "id", "id"
			end
			self.awardShowList[v.classType][#self.awardShowList[v.classType] + 1] = v
		end
		return self.awardShowList
	end)
	cavalryRiseRead:defineValue("questShowMap", function()
		self.questShowMap, self = nil, nil
		local questShow = require_once("app." .. _G.LocalTblPath .. ".config_client.cavalry_quest_show")
		for _, v in ipairs(questShow) do
			if not self.questShowMap[v.classType] then
				self.questShowMap[v.classType], self = nil, nil
			end
			self.questShowMap[v.classType][v.questtype] = v.questID
		end
		return self.questShowMap
	end)
end
cavalryRiseRead:init()
function cavalryRiseRead:getTaskCfg(taskId, classType)
	local eventQuestRead = include("eventQuestRead")
	return eventQuestRead.getTaskConfig(taskId)
end
function cavalryRiseRead:getTaskShow(classType)
	return self.questShowMap[classType]
end
function cavalryRiseRead:getRewardByTaskID(taskId, classType)
	return self:getTaskCfg(taskId, classType).reward
end
function cavalryRiseRead:getLevelBronzeAward(lv, classType)
	return self:getLevelCfg(lv, classType).bronzeAward
end
function cavalryRiseRead:getLevelGoldAward(lv, classType)
	return self:getLevelCfg(lv, classType).goldAward
end
function cavalryRiseRead:getLevelCfg(lv, classType)
	local levelList = self:getLevelList(classType)
	if lv > #levelList then
		lv = #levelList
	end
	return levelList[lv]
end
function cavalryRiseRead:getLevelList(classType)
	return self.levelList[classType]
end
function cavalryRiseRead:isLastLevel(classType, lv)
	return lv >= #self:getLevelList(classType)
end
function cavalryRiseRead:getLevelMaxList(classType)
	return self.levelMaxList[classType]
end
function cavalryRiseRead:getAwardShowList(classType)
	return self.awardShowList[classType]
end
function cavalryRiseRead:getMaxExp(classType, lv)
	local levelList = self:getLevelList(classType)
	lv = lv + 1
	if lv >= #levelList then
		lv = #levelList
	end
	print("getMaxExp=====", levelList, #levelList, lv)
	return levelList[lv].exp
end
return cavalryRiseRead
