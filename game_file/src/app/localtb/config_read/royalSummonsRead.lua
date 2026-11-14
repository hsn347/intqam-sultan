local royalSummonsRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	royalSummonsRead:init()
end
function royalSummonsRead:init()
	royalSummonsRead:defineValue("taskCfg", function()
		local cfg = require_once("app." .. _G.LocalTblPath .. ".config_server.summons_task_config")
		self.taskCfg, _ENV = "app." .. _G.LocalTblPath .. ".config_server.summons_task_config", "app." .. _G.LocalTblPath .. ".config_server.summons_task_config"
		for _, v in ipairs(cfg) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local reward = serviceFunctions.tableFormat(v.award, nil)
			v.award = reward
			if not self.taskCfg[v.classType] then
				self.taskCfg[v.classType], _ENV = "id", "id"
			end
			self.taskCfg[v.classType][v.taskID] = v
		end
		return self.taskCfg
	end)
	royalSummonsRead:defineValue("exchangeCfg", function()
		self.exchangeCfg, self = nil, nil
		local exchangeCfg = require_once("app." .. _G.LocalTblPath .. ".config_server.summons_exchange_config")
		for _, v in ipairs(exchangeCfg) do
			local data = v
			local shopitem = v.shopitem
			local exchangeitem = v.exchangeitem
			v.shopitem = shopitem[1]
			v.shopitemnum = shopitem[2] or 1
			v.exchangeitem = exchangeitem[1]
			v.exchangenum = exchangeitem[2] or 1
			if not self.exchangeCfg[v.classType] then
				self.exchangeCfg[v.classType], self = nil, nil
			end
			self.exchangeCfg[v.classType][v.exchangeID] = data
		end
		return self.exchangeCfg
	end)
	royalSummonsRead:defineValue("levelList", function()
		self.levelList, self = nil, nil
		local levelList = require_once("app." .. _G.LocalTblPath .. ".config_server.summons_lv_exp")
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
		return self.levelList
	end)
	royalSummonsRead:defineValue("levelMaxList", function()
		self.levelMaxList, self = nil, nil
		local levelMaxList = require_once("app." .. _G.LocalTblPath .. ".config_server.summons_lv_reward")
		for _, v in ipairs(levelMaxList) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			local award = serviceFunctions.tableFormat(v.award, nil)
			v.award = award
			local index = #self.levelList[v.classType] + 1
			v.index = index
			self.levelList[v.classType][index] = v
			self.levelMaxList[v.classType] = v
		end
		return self.levelMaxList
	end)
	royalSummonsRead:defineValue("awardShowList", function()
		self.awardShowList, self = nil, nil
		local awardShowList = require_once("app." .. _G.LocalTblPath .. ".config_client.summons_reward_show")
		for _, v in ipairs(awardShowList) do
			_UPVALUE3_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			;(nil)[3] = "lv"
			local award = serviceFunctions.tableFormat(v.award, nil)
			v.award = award
			if not self.awardShowList[v.classType] then
				self.awardShowList[v.classType], self = "id", "id"
			end
			self.awardShowList[v.classType][#self.awardShowList[v.classType] + 1] = v
		end
		return self.awardShowList
	end)
	royalSummonsRead:defineValue("expShopList", function()
		self.expShopList, self = nil, nil
		local tmp = require_once("app." .. _G.LocalTblPath .. ".config_server.summons_exp_shop")
		for _, v in ipairs(tmp) do
			if not self.expShopList[v.classType] then
				self.expShopList[v.classType], self = nil, nil
			end
			self.expShopList[v.classType][#self.expShopList[v.classType] + 1] = v
		end
		return self.expShopList
	end)
end
function royalSummonsRead:getTaskCfg(taskId, classType)
	if taskId then
		return self.taskCfg[classType][taskId]
	else
		return self.taskCfg[classType]
	end
end
function royalSummonsRead:getTaskByType(taskType, classType)
	local _ENV, taskInfo
	local classType = SoraDGetCtrl("royalSummonsCtrl"):getClassType()
	for _, taskCfg in pairs(self.taskCfg[classType]) do
		if taskCfg.taskType == taskType then
			table.insert(taskInfo, taskCfg)
		end
	end
	return taskInfo
end
function royalSummonsRead:getRewardByTaskID(taskId, classType)
	return self.taskCfg[classType][taskId].reward
end
function royalSummonsRead:getShopItemList(classType)
	return self.exchangeCfg[classType]
end
function royalSummonsRead:getLevelList(lv, classType)
	if lv then
		return self.levelList[classType][lv]
	end
	return self.levelList[classType]
end
function royalSummonsRead:getLevelMaxList(classType)
	return self.levelMaxList[classType]
end
function royalSummonsRead:getAwardShowList(classType)
	return self.awardShowList[classType]
end
function royalSummonsRead:getExpShopList(classType)
	return self.expShopList[classType]
end
init()
return royalSummonsRead
