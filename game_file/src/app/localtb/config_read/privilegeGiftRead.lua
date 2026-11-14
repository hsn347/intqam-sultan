local privilegeGiftRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	local createData = function(name)
		privilegeGiftRead.magicLampPrivilegeGiftData, privilegeGiftRead, privilegeGiftRead.privilegeStarGiftData, privilegeGiftRead, privilegeGiftRead.allPrivilegeGiftData, privilegeGiftRead, privilegeGiftRead.sultansBackGiftData, privilegeGiftRead, privilegeGiftRead.graftPrivilegeGiftData, privilegeGiftRead, privilegeGiftRead.vipPrivilegeGiftData, privilegeGiftRead, privilegeGiftRead.privilegeGiftData, privilegeGiftRead = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
		local privilegeGiftRead, config
		local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
		if userSDKManager.isAR() then
			config = require_once("app." .. LocalTblPath .. ".config_server.privilege_gift_ar")
		else
			config = require_once("app." .. LocalTblPath .. ".config_server.privilege_gift_en")
		end
		for key, value in ipairs(config) do
			privilegeGiftRead.allPrivilegeGiftData[tostring(value.rechargeID)] = value
			if value.privilegeType == 1 or value.privilegeType == 6 then
				local privilegeGiftRead, totalReward = value.privilegeType, value.privilegeType
				for k, v in ipairs(value.rewards) do
					table.insert(totalReward, v)
				end
				if value.gold and value.gold > 0 then
					table.insert(totalReward, 1001)
					table.insert(totalReward, value.gold)
				end
				_UPVALUE2_ = value.gold
				value.gold[1] = "id"
				value.gold[2] = "count"
				local totalReward = serviceFunctions.tableFormat(totalReward, value.gold)
				privilegeGiftRead.privilegeGiftData[tostring(value.rechargeID)] = value
				privilegeGiftRead.privilegeGiftData[tostring(value.rechargeID)].totalReward = totalReward
				local totalSpeed = 0
				local totalResource = 0
				for _, v in pairs(totalReward) do
					local id = v.id
					local count = v.count
					if id ~= 1001 then
						local itemData = backpackltCtrl:getResult(id)
						if type(itemData) == "table" then
							local resultType = backpackltCtrl:getResultType(id)
							if resultType == gItemEffectDef.ABBR_SPEED_UP then
								totalSpeed = totalSpeed + (itemData.value or 0) * count
							elseif backpackltCtrl:getClassifyType(id) == 1 and itemData[1] then
								totalResource = totalResource + (itemData[1].count or 0) * count
							end
						end
					end
				end
				privilegeGiftRead.privilegeGiftData[tostring(value.rechargeID)].totalSpeed = totalSpeed
				privilegeGiftRead.privilegeGiftData[tostring(value.rechargeID)].totalResource = totalResource
			elseif value.privilegeType == 2 then
				table.insert(privilegeGiftRead.vipPrivilegeGiftData, value)
			elseif value.privilegeType == 3 then
				privilegeGiftRead.graftPrivilegeGiftData[tostring(value.rechargeID)] = value
			elseif value.privilegeType == 4 then
				if value.gold and value.gold > 0 then
					table.insert(value.rewards, 1, value.gold)
					table.insert(value.rewards, 1, 1001)
				end
				table.insert(privilegeGiftRead.sultansBackGiftData, value)
			elseif value.privilegeType == 5 then
				local privilegeGiftRead, totalReward = value.privilegeType, value.privilegeType
				for k, v in ipairs(value.rewards) do
					table.insert(totalReward, v)
				end
				if value.gold and value.gold > 0 then
					table.insert(totalReward, 1001)
					table.insert(totalReward, value.gold)
				end
				_UPVALUE2_ = value.gold
				value.gold[1] = "id"
				value.gold[2] = "count"
				local totalReward = serviceFunctions.tableFormat(totalReward, value.gold)
				privilegeGiftRead.privilegeStarGiftData[tostring(value.rechargeID)] = value
				privilegeGiftRead.privilegeStarGiftData[tostring(value.rechargeID)].totalReward = totalReward
				local totalSpeed = 0
				local totalResource = 0
				for _, v in pairs(totalReward) do
					local id = v.id
					local count = v.count
					if id ~= 1001 then
						local itemData = backpackltCtrl:getResult(id)
						if type(itemData) == "table" then
							local resultType = backpackltCtrl:getResultType(id)
							if resultType == gItemEffectDef.ABBR_SPEED_UP then
								totalSpeed = totalSpeed + (itemData.value or 0) * count
							elseif backpackltCtrl:getClassifyType(id) == 1 and itemData[1] then
								totalResource = totalResource + (itemData[1].count or 0) * count
							end
						end
					end
				end
				privilegeGiftRead.privilegeStarGiftData[tostring(value.rechargeID)].totalSpeed = totalSpeed
				privilegeGiftRead.privilegeStarGiftData[tostring(value.rechargeID)].totalResource = totalResource
			elseif value.privilegeType == 7 or value.privilegeType == 8 then
				local privilegeGiftRead, totalReward = value.privilegeType, value.privilegeType
				_UPVALUE2_ = totalResource + (itemData[1].count or 0) * count
				;(totalResource + (itemData[1].count or 0) * count)[1] = "id"
				;(totalResource + (itemData[1].count or 0) * count)[2] = "count"
				local reward = serviceFunctions.tableFormat(value.rewards, totalResource + (itemData[1].count or 0) * count)
				for k, v in ipairs(reward) do
					if v.id ~= 1001 then
						table.insert(totalReward, v)
					end
				end
				privilegeGiftRead.magicLampPrivilegeGiftData[tostring(value.rechargeID)] = value
				privilegeGiftRead.magicLampPrivilegeGiftData[tostring(value.rechargeID)].totalReward = totalReward
				local totalSpeed = 0
				local totalResource = 0
				for _, v in pairs(totalReward) do
					local id = v.id
					local count = v.count
					if id ~= 1001 then
						local itemData = backpackltCtrl:getResult(id)
						if type(itemData) == "table" then
							local resultType = backpackltCtrl:getResultType(id)
							if resultType == gItemEffectDef.ABBR_SPEED_UP then
								totalSpeed = totalSpeed + (itemData.value or 0) * count
							elseif backpackltCtrl:getClassifyType(id) == 1 and itemData[1] then
								totalResource = totalResource + (itemData[1].count or 0) * count
							end
						end
					end
				end
				privilegeGiftRead.magicLampPrivilegeGiftData[tostring(value.rechargeID)].totalSpeed = totalSpeed
				privilegeGiftRead.magicLampPrivilegeGiftData[tostring(value.rechargeID)].totalResource = totalResource
			end
		end
		if name == "privilegeGiftData" then
			return privilegeGiftRead.privilegeGiftData
		elseif name == "vipPrivilegeGiftData" then
			return privilegeGiftRead.vipPrivilegeGiftData
		elseif name == "graftPrivilegeGiftData" then
			return privilegeGiftRead.graftPrivilegeGiftData
		elseif name == "sultansBackGiftData" then
			return privilegeGiftRead.sultansBackGiftData
		elseif name == "allPrivilegeGiftData" then
			return privilegeGiftRead.allPrivilegeGiftData
		elseif name == "privilegeStarGiftData" then
			return privilegeGiftRead.privilegeStarGiftData
		elseif name == "magicLampPrivilegeGiftData" then
			return privilegeGiftRead.magicLampPrivilegeGiftData
		end
	end
	privilegeGiftRead:defineValue("privilegeGiftData", createData)
	privilegeGiftRead:defineValue("vipPrivilegeGiftData", createData)
	privilegeGiftRead:defineValue("graftPrivilegeGiftData", createData)
	privilegeGiftRead:defineValue("sultansBackGiftData", createData)
	privilegeGiftRead:defineValue("allPrivilegeGiftData", createData)
	privilegeGiftRead:defineValue("privilegeStarGiftData", createData)
	privilegeGiftRead:defineValue("magicLampPrivilegeGiftData", createData)
	_ENV = createData
	createData[1] = "privilege_group"
	createData[2] = true
	privilegeGiftRead:defineValue("privilege_group", createData)
end
init()
function privilegeGiftRead.getGroup()
	local nebulaWarUtil = include("nebulaWarUtil")
	local selfReginId = nebulaWarUtil.getRegionId()
	local group = 1
	for _, v in ipairs(privilegeGiftRead.privilege_group) do
		if SoraDisInList(selfReginId, v.id) then
			group = v.group
			break
		end
	end
	return group
end
function privilegeGiftRead.getRechargeIDExist(rechargeID)
	if privilegeGiftRead.privilegeGiftData and privilegeGiftRead.privilegeGiftData[tostring(rechargeID)] then
		return true
	end
	print("privilegeGiftRead:getRechargeIDExist(rechargeID)", rechargeID)
	return false
end
function privilegeGiftRead.getVipRechargeIDExist(rechargeID)
	for i, v in ipairs(privilegeGiftRead.vipPrivilegeGiftData) do
		if v.rechargeID == rechargeID then
			return true
		end
	end
	print("privilegeGiftRead:getVipRechargeIDExist(rechargeID)", rechargeID)
	return false
end
function privilegeGiftRead.getVipLvByRechargeID(rechargeID)
	for i, v in ipairs(privilegeGiftRead.vipPrivilegeGiftData) do
		if v.rechargeID == rechargeID then
			return v.lv
		end
	end
end
function privilegeGiftRead.getStarLvRechargeIDExist(rechargeID)
	if privilegeGiftRead.privilegeStarGiftData and privilegeGiftRead.privilegeStarGiftData[tostring(rechargeID)] then
		return true
	end
	print("privilegeGiftRead:getStarLvRechargeIDExist(rechargeID)", rechargeID)
	return false
end
function privilegeGiftRead.getGraftPrivilegeGiftExist(rechargeID)
	if privilegeGiftRead.graftPrivilegeGiftData and privilegeGiftRead.graftPrivilegeGiftData[tostring(rechargeID)] then
		return true
	end
	print("privilegeGiftRead:getActivityPriRechargeIDExist(rechargeID)", rechargeID)
	return false
end
function privilegeGiftRead.getValueByRechargeID(rechargeID, key)
	local rightValue
	if privilegeGiftRead.allPrivilegeGiftData and privilegeGiftRead.allPrivilegeGiftData[tostring(rechargeID)] then
		rightValue = privilegeGiftRead.allPrivilegeGiftData[tostring(rechargeID)][key]
	end
	return rightValue
end
function privilegeGiftRead.getStarValueByRechargeID(rechargeID, key)
	local rightValue
	if privilegeGiftRead.privilegeStarGiftData and privilegeGiftRead.privilegeStarGiftData[tostring(rechargeID)] then
		rightValue = privilegeGiftRead.privilegeStarGiftData[tostring(rechargeID)][key]
	end
	return rightValue
end
function privilegeGiftRead.getRechargeGiftByID(rechargeID)
	if privilegeGiftRead.privilegeGiftData and privilegeGiftRead.privilegeGiftData[tostring(rechargeID)] then
		return privilegeGiftRead.privilegeGiftData[tostring(rechargeID)]
	end
end
function privilegeGiftRead.getStarRechargeGiftByID(rechargeID)
	if privilegeGiftRead.privilegeStarGiftData and privilegeGiftRead.privilegeStarGiftData[tostring(rechargeID)] then
		return privilegeGiftRead.privilegeStarGiftData[tostring(rechargeID)]
	end
end
function privilegeGiftRead.getPrivilegeGiftData()
	return privilegeGiftRead.privilegeGiftData
end
function privilegeGiftRead.getStarLvPrivilegeGiftData()
	return privilegeGiftRead.privilegeStarGiftData
end
function privilegeGiftRead.getPrivilegeGiftDataByID(rechargeID)
	local privilegeGiftRead, ret
	local data = privilegeGiftRead.allPrivilegeGiftData[tostring(rechargeID)]
	if data then
		local rechargeRead = include("rechargeRead")
		local giftStyle = rechargeRead.getPageViewData(data.rechargeID)
		ret.id = data.rechargeID
		ret.name = i18n(giftStyle.activeName)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "num"
		ret.rewards = serviceFunctions.tableFormat(data.rewards, nil)
		privilegeGiftRead = "id"
		;("id").id = 1001
		;("id").num = data.gold
		table.insert(ret.rewards, 1, "id")
		ret.price = data.price
		ret.extraData = 1
		ret.maxBuy = 1
	end
	return ret
end
function privilegeGiftRead.getVipPrivilegePackageDataByLv(vipLv)
	local index = 1
	for i, v in ipairs(privilegeGiftRead.vipPrivilegeGiftData) do
		if v.lv == vipLv then
			index = i
			break
		end
	end
	return privilegeGiftRead.vipPrivilegeGiftData[index]
end
function privilegeGiftRead.getValueByRechargeIDFromGraft(rechargeID, key)
	local rightValue
	if privilegeGiftRead.graftPrivilegeGiftData and privilegeGiftRead.graftPrivilegeGiftData[tostring(rechargeID)] then
		rightValue = privilegeGiftRead.graftPrivilegeGiftData[tostring(rechargeID)][key]
	end
	return rightValue
end
function privilegeGiftRead.getRechargeSultansBack()
	return privilegeGiftRead.sultansBackGiftData
end
function privilegeGiftRead.getMagicLampGift(jinnList)
	local _ENV, showList
	for k, v in pairs(privilegeGiftRead.magicLampPrivilegeGiftData) do
		for jinnType, jinnLv in pairs(jinnList) do
			if v.targetID == jinnType and jinnLv >= v.lv and (v.group == 0 or v.group ~= 0 and v.group == privilegeGiftRead.getGroup()) then
				table.insert(showList, v)
			end
		end
	end
	return showList
end
function privilegeGiftRead.getMagicLampGiftByID(rechargeID)
	return privilegeGiftRead.magicLampPrivilegeGiftData[tostring(rechargeID)]
end
function privilegeGiftRead.getMagicLampJinnPng(jinnType, isNew)
	_UPVALUE0_ = nil
	;(nil)[1] = isNew and "jinnnew_01.png" or "jinn_01.png"
	local (nil)[2], jinnPng = isNew and "jinnnew_02.png" or "jinn_02.png", nil
	return jinnPng[jinnType] or jinnPng[1]
end
function privilegeGiftRead.getMagicLampJinnName(jinnType)
	_ENV = nil
	;(nil)[1] = i18n("magic_lamp_name_01")
	local (nil)[2], cfg = i18n("magic_lamp_name_02"), nil
	return cfg[jinnType] or cfg[1]
end
return privilegeGiftRead
