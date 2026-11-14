local newLotteryRead = include("aAReadClass").new()
function newLotteryRead.init()
	newLotteryRead:defineValue("new_lottery_reward", function()
		local _ENV, new
		local config = require_once("app." .. LocalTblPath .. ".config_server.new_lottery_reward")
		for i, v in ipairs(config) do
			if not new[v.id] then
				new[v.id], _ENV = nil, nil
			end
			if not new[v.id][v.classtype] then
				new[v.id][v.classtype], _ENV = nil, nil
			end
			_ENV = v.classtype
			v.classtype.stage = v.stage
			v.classtype.num = v.num
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.classtype.reward = serviceFunctions.tableFormat(v.reward, nil)
			table.insert(new[v.id][v.classtype], v.classtype)
		end
		return new
	end)
	newLotteryRead:defineValue("new_lottery", function()
		local _ENV, new
		local config = require_once("app." .. LocalTblPath .. ".config_server.new_lottery")
		for i, v in ipairs(config) do
			new[v.id] = v
		end
		return new
	end)
	newLotteryRead:defineValue("new_lottery_view", function()
		local _ENV, new
		local config = require_once("app." .. LocalTblPath .. ".config_client.new_lottery_view")
		for i, v in ipairs(config) do
			if not new[v.id] then
				new[v.id], _ENV = nil, nil
			end
			if not new[v.id][v.classType] then
				new[v.id][v.classType], _ENV = nil, nil
			end
			_ENV = v.classType
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.classType.reward = serviceFunctions.tableFormat(v.rewardView, nil)
			v.classType.prize = v.prize
			table.insert(new[v.id][v.classType], v.classType)
		end
		return new
	end)
	newLotteryRead:defineValue("new_lottery_pool_1", function()
		local _ENV, new
		local config = require_once("app." .. LocalTblPath .. ".config_server.new_lottery_pool_1")
		for i, v in ipairs(config) do
			if not new[v.id] then
				new[v.id], _ENV = nil, nil
			end
			if not new[v.id][v.classType] then
				new[v.id][v.classType], _ENV = nil, nil
			end
			if not new[v.id][v.classType][v.group] then
				new[v.id][v.classType][v.group], _ENV = nil, nil
			end
			_ENV = v.group
			v.group.index = v.ItemOrder
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.group.reward = serviceFunctions.tableFormat(v.reward, nil)
			table.insert(new[v.id][v.classType][v.group], v.group)
		end
		return new
	end)
	newLotteryRead:defineValue("new_lottery_pool_3", function()
		local _ENV, ret
		local config = require_data("new_lottery_pool_3", true, true).data
		for i, v in ipairs(config) do
			if not ret[v.id] then
				_ENV = ret[v.id]
			end
			ret[v.id] = ret[v.id]
			if not ret[v.id][v.classType] then
				_ENV = ret[v.id][v.classType]
			end
			ret[v.id][v.classType] = ret[v.id][v.classType]
			_ENV = v.classType
			v.classType.ItemOrder = v.ItemOrder
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.classType.reward = serviceFunctions.tableFormat(v.reward, nil)
			table.insert(ret[v.id][v.classType], v.classType)
		end
		return ret
	end)
	newLotteryRead:defineValue("new_lottery_pool_4", function()
		local _ENV, ret
		local config = require_data("new_lottery_pool_4", true, true).data
		for i, v in ipairs(config) do
			if not ret[v.id] then
				_ENV = ret[v.id]
			end
			ret[v.id] = ret[v.id]
			if not ret[v.id][v.classType] then
				_ENV = ret[v.id][v.classType]
			end
			ret[v.id][v.classType] = ret[v.id][v.classType]
			_ENV = v.classType
			v.classType.ItemOrder = v.ItemOrder
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.classType.reward = serviceFunctions.tableFormat(v.reward, nil)
			table.insert(ret[v.id][v.classType], v.classType)
		end
		return ret
	end)
	newLotteryRead:defineValue("chooseConfig", function()
		_ENV, _ENV = nil, nil
		;(nil).title = "happyegg_04"
		;(nil).maxNum = 3
		;(nil).eggIcon = "img_happyegg_green.png"
		;(nil).eggEffect = "hlcd_green.usm"
		_ENV, (nil)[1], (nil).pos = nil, nil, cc.p(39.5, 7.5)
		;(nil).title = "happyegg_03"
		;(nil).maxNum = 3
		;(nil).eggIcon = "img_happyegg_blue.png"
		;(nil).eggEffect = "hlcd_blue.usm"
		_ENV, (nil)[2], (nil).pos = nil, nil, cc.p(33.5, 10.5)
		;(nil).title = "happyegg_02"
		;(nil).maxNum = 2
		;(nil).eggIcon = "img_happyegg_red.png"
		;(nil).eggEffect = "hlcd_red.usm"
		;(nil)[3], (nil).pos = nil, cc.p(49.5, 8.5)
		return nil
	end)
	function _UPVALUE2_()
		_ENV, _ENV = nil, nil
		;(nil).title = "happyegg_04"
		;(nil).maxNum = 3
		;(nil).eggIcon = "img_happyegg_green.png"
		;(nil).eggEffect = "hlcd_green.usm"
		_ENV, (nil)[1], (nil).pos = nil, nil, cc.p(39.5, 7.5)
		;(nil).title = "happyegg_03"
		;(nil).maxNum = 3
		;(nil).eggIcon = "img_happyegg_blue.png"
		;(nil).eggEffect = "hlcd_blue.usm"
		_ENV, (nil)[2], (nil).pos = nil, nil, cc.p(33.5, 10.5)
		;(nil).title = "happyegg_02"
		;(nil).maxNum = 2
		;(nil).eggIcon = "img_happyegg_red.png"
		;(nil).eggEffect = "hlcd_red.usm"
		;(nil)[3], (nil).pos = nil, cc.p(49.5, 8.5)
		return nil
	end
	;(function()
		_ENV, _ENV = nil, nil
		;(nil).title = "happyegg_04"
		;(nil).maxNum = 3
		;(nil).eggIcon = "img_happyegg_green.png"
		;(nil).eggEffect = "hlcd_green.usm"
		_ENV, (nil)[1], (nil).pos = nil, nil, cc.p(39.5, 7.5)
		;(nil).title = "happyegg_03"
		;(nil).maxNum = 3
		;(nil).eggIcon = "img_happyegg_blue.png"
		;(nil).eggEffect = "hlcd_blue.usm"
		_ENV, (nil)[2], (nil).pos = nil, nil, cc.p(33.5, 10.5)
		;(nil).title = "happyegg_02"
		;(nil).maxNum = 2
		;(nil).eggIcon = "img_happyegg_red.png"
		;(nil).eggEffect = "hlcd_red.usm"
		;(nil)[3], (nil).pos = nil, cc.p(49.5, 8.5)
		return nil
	end)[1] = "nebulaeroaming_price_name"
	;(function()
		_ENV, _ENV = nil, nil
		;(nil).title = "happyegg_04"
		;(nil).maxNum = 3
		;(nil).eggIcon = "img_happyegg_green.png"
		;(nil).eggEffect = "hlcd_green.usm"
		_ENV, (nil)[1], (nil).pos = nil, nil, cc.p(39.5, 7.5)
		;(nil).title = "happyegg_03"
		;(nil).maxNum = 3
		;(nil).eggIcon = "img_happyegg_blue.png"
		;(nil).eggEffect = "hlcd_blue.usm"
		_ENV, (nil)[2], (nil).pos = nil, nil, cc.p(33.5, 10.5)
		;(nil).title = "happyegg_02"
		;(nil).maxNum = 2
		;(nil).eggIcon = "img_happyegg_red.png"
		;(nil).eggEffect = "hlcd_red.usm"
		;(nil)[3], (nil).pos = nil, cc.p(49.5, 8.5)
		return nil
	end)[2] = true
	newLotteryRead:defineValue("nebulaeroaming_price_name", function()
		_ENV, _ENV = nil, nil
		;(nil).title = "happyegg_04"
		;(nil).maxNum = 3
		;(nil).eggIcon = "img_happyegg_green.png"
		;(nil).eggEffect = "hlcd_green.usm"
		_ENV, (nil)[1], (nil).pos = nil, nil, cc.p(39.5, 7.5)
		;(nil).title = "happyegg_03"
		;(nil).maxNum = 3
		;(nil).eggIcon = "img_happyegg_blue.png"
		;(nil).eggEffect = "hlcd_blue.usm"
		_ENV, (nil)[2], (nil).pos = nil, nil, cc.p(33.5, 10.5)
		;(nil).title = "happyegg_02"
		;(nil).maxNum = 2
		;(nil).eggIcon = "img_happyegg_red.png"
		;(nil).eggEffect = "hlcd_red.usm"
		;(nil)[3], (nil).pos = nil, cc.p(49.5, 8.5)
		return nil
	end)
end
function newLotteryRead.getStageConfig(activityID, classtype)
	return newLotteryRead.new_lottery_reward[activityID][classtype]
end
function newLotteryRead.getCostItemIDByActivityID(activityID)
	return newLotteryRead.new_lottery[activityID].expend[1]
end
function newLotteryRead.getCostNum(activityID, index)
	local cost = newLotteryRead.new_lottery[activityID].cost
	return cost[index + 1] or cost[#cost]
end
function newLotteryRead.getPreAwardByActivityID(activityID, classtype)
	return newLotteryRead.new_lottery_view[activityID][classtype]
end
function newLotteryRead.getGroupChooseAward(activityID, classtype)
	return newLotteryRead.new_lottery_pool_1[activityID][classtype]
end
function newLotteryRead.getChooseConfig(groupType)
	return newLotteryRead.chooseConfig[groupType]
end
function newLotteryRead.isBestAward(activityID, classtype, itemOrder)
	dump(newLotteryRead.new_lottery_pool_1, "newLotteryRead.new_lottery_pool_1")
	print("activityID,classtype", activityID, classtype)
	for i, v in ipairs(newLotteryRead.new_lottery_pool_1[activityID][classtype][3]) do
		if v.index == ItemOrder then
			return true
		end
	end
	return false
end
function newLotteryRead.getRewardByItemOrder(activityID, classtype, itemOrder)
	for _, gropList in ipairs(newLotteryRead.new_lottery_pool_1[activityID][classtype]) do
		for _, v in ipairs(gropList) do
			if v.index == itemOrder then
				return v.reward
			end
		end
	end
end
function newLotteryRead.getEggIcon(activityID, classtype, itemOrder)
	local group = 1
	for groupType, gropList in ipairs(newLotteryRead.new_lottery_pool_1[activityID][classtype]) do
		for _, v in ipairs(gropList) do
			if v.index == itemOrder then
				group = groupType
				break
			end
		end
	end
	return newLotteryRead.chooseConfig[group].eggIcon
end
function newLotteryRead.getEggEffect(activityID, classtype, itemOrder)
	local group = 1
	for groupType, gropList in ipairs(newLotteryRead.new_lottery_pool_1[activityID][classtype]) do
		for _, v in ipairs(gropList) do
			if v.index == itemOrder then
				group = groupType
				break
			end
		end
	end
	return newLotteryRead.chooseConfig[group].eggEffect, newLotteryRead.chooseConfig[group].pos
end
function newLotteryRead.getConfig(activityID)
	local pool = newLotteryRead.new_lottery[activityID].pool
	local new_lottery_pool = newLotteryRead["new_lottery_pool_" .. pool]
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local classType = activityShowCtrl:getParamClassType(activityID)
	return new_lottery_pool[activityID][classType]
end
function newLotteryRead.getTextByPrize(Index)
	return newLotteryRead.nebulaeroaming_price_name[Index].Text
end
newLotteryRead.init()
return newLotteryRead
