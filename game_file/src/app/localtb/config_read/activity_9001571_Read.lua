local activity_9001571_Read = include("aAReadClass").new()
function activity_9001571_Read.init()
	activity_9001571_Read:defineValue("back_battlefield_lv", function(name)
		local _ENV, ret
		local cfg = require_data(name, true, true).data
		for k, v in ipairs(cfg) do
			if not ret[v.classType] then
				ret[v.classType], _ENV = nil, nil
			end
			if not ret[v.classType][v.group] then
				ret[v.classType][v.group], _ENV = nil, nil
			end
			_ENV = v.group
			v.group.NeedExp = v.NeedExp
			v.group.Lv = v.Lv
			v.group.LvReward1 = v.LvReward1
			v.group.LvReward2 = v.LvReward2
			v.group.core = v.core == 1
			table.insert(ret[v.classType][v.group], v.group)
		end
		return ret
	end)
	activity_9001571_Read:defineValue("back_battlefield", function(name)
		local _ENV, ret
		local cfg = require_data(name, false, true).data
		for k, v in ipairs(cfg) do
			if not ret[v.classType] then
				ret[v.classType], _ENV = nil, nil
			end
			_ENV = nil
			;(nil).group = v.group
			;(nil).heroID = v.heroView
			table.insert(ret[v.classType], nil)
		end
		return ret
	end)
	activity_9001571_Read:defineValue("back_battlefield_quest", function(name)
		local _ENV, ret
		local cfg = require_data(name, true, true).data
		for k, v in ipairs(cfg) do
			if not ret[v.classType] then
				ret[v.classType], _ENV = nil, nil
			end
			table.insert(ret[v.classType], v)
		end
		return ret
	end)
	activity_9001571_Read:defineValue("back_battlefield_recharge", function(name)
		local _ENV, ret
		local cfg = require_data(name, false, true).data
		for k, v in ipairs(cfg) do
			if not ret[v.classType] then
				ret[v.classType], _ENV = nil, nil
			end
			if not ret[v.classType][v.group] then
				ret[v.classType][v.group], _ENV = nil, nil
			end
			_ENV = nil
			;(nil).RechargeID = v.RechargeID
			;(nil).Price = v.Price
			;(nil).OriginalPrice = v.OriginalPrice
			;(nil).gold = v.gold
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			;(nil).gift = serviceFunctions.tableFormat(v.gift, nil)
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			ret[v.classType][v.group], (nil).Rewards = nil, serviceFunctions.tableFormat(v.Rewards, nil)
		end
		return ret
	end)
end
function activity_9001571_Read.getLvAwardList(classType, group)
	if not activity_9001571_Read.back_battlefield_lv[classType][group] then
		activity_9001571_Read = activity_9001571_Read.back_battlefield_lv[classType][group]
	end
	return activity_9001571_Read.back_battlefield_lv[classType][group]
end
function activity_9001571_Read.getMaxLv(classType, group)
	local list = activity_9001571_Read.getLvAwardList(classType, group)
	return list[#list].Lv
end
function activity_9001571_Read.getGroupList(classType)
	return activity_9001571_Read.back_battlefield[classType]
end
function activity_9001571_Read.getHeroIDByGroupID(classType, groupID)
	for i, v in ipairs(activity_9001571_Read.back_battlefield[classType]) do
		if v.group == groupID then
			return v.heroID
		end
	end
end
function activity_9001571_Read.getChooseHeroName(classType, group)
	local list = activity_9001571_Read.getGroupList(classType)
	for key, value in ipairs(list) do
		if value.group == group then
			local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
			return i18n(heroltCtrl.getHeroName(value.heroID)), heroltCtrl:getHeroItemID(value.heroID)
		end
	end
	return "", 900019
end
function activity_9001571_Read.getRechargeConfig(classType, group)
	return activity_9001571_Read.back_battlefield_recharge[classType][group]
end
function activity_9001571_Read.getNextExp(classType, group, level)
	local list = activity_9001571_Read.getLvAwardList(classType, group)
	if next(list) then
		for _, info in ipairs(list) do
			if info.Lv == level + 1 then
				return info.NeedExp
			end
		end
		return list[#list].NeedExp
	end
	return 0
end
function activity_9001571_Read.getNextCoreLv(classType, group, level)
	local list = activity_9001571_Read.getLvAwardList(classType, group)
	if next(list) then
		for i = level + 1, #list do
			if list[i].core then
				return list[i].Lv
			end
		end
		return list[#list].Lv
	end
	return 1
end
function activity_9001571_Read.getGiftAwardInfo(classType, group)
	if not activity_9001571_Read.back_battlefield_recharge[classType][group] then
		activity_9001571_Read = activity_9001571_Read.back_battlefield_recharge[classType][group]
	end
	return activity_9001571_Read.back_battlefield_recharge[classType][group]
end
activity_9001571_Read.init()
return activity_9001571_Read
