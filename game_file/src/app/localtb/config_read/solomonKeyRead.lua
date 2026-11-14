local solomonKeyRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	solomonKeyRead.silverKey = 814301
	solomonKeyRead.goldKey = 814201
	solomonKeyRead.silverGift = 13217
	solomonKeyRead.goldGift = 13218
	solomonKeyRead.wesSilverKey = 715601
	solomonKeyRead.wesGoldKey = 715501
	solomonKeyRead.wesSilverGift = 13232
	solomonKeyRead.wesGoldGift = 13233
	solomonKeyRead.gift = 714201
	local createData = function(name)
		solomonKeyRead.tableRewardPool, solomonKeyRead, solomonKeyRead.rewardPool = require_data("solomon_config", true, true).data, require_data("solomon_config", true, true).data, require_data("solomon_config", true, true).data
		for k, v in ipairs(solomonKeyRead.rewardPool) do
			temp = v
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			temp.ITEMID = serviceFunctions.tableFormat(v.ITEMID, nil)
			table.insert(solomonKeyRead.tableRewardPool, temp)
		end
		return solomonKeyRead[name]
	end
	solomonKeyRead:defineValue("rewardPool", createData)
	solomonKeyRead:defineValue("tableRewardPool", createData)
end
init()
function solomonKeyRead.getRewardsByKeyID(keyID)
	local _ENV, temp
	local _ENV, randomTemp
	for k, v in ipairs(solomonKeyRead.tableRewardPool) do
		if v.USERKEYID == keyID then
			table.insert(temp, v)
		end
	end
	local index = 1
	while next(temp) do
		local n = math.random(0, #temp)
		if temp[n] ~= nil then
			randomTemp[index] = temp[n]
			table.remove(temp, n)
			index = index + 1
		end
	end
	return randomTemp
end
function solomonKeyRead.getRewardsByTypeAward(awardType)
	local _ENV, temp
	for k, v in ipairs(solomonKeyRead.tableRewardPool) do
		if v.TypeAward == awardType then
			table.insert(temp, v)
		end
	end
	return temp
end
return solomonKeyRead
