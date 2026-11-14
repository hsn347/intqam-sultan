local raidersLostArkRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "snatch_treasure_box"
	;(nil)[2] = true
	raidersLostArkRead:defineValue("stb", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "snatch_treasure_fight"
	;(nil)[2] = true
	raidersLostArkRead:defineValue("stf", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "snatch_treasure_monster"
	;(nil)[2] = true
	raidersLostArkRead:defineValue("stm", nil)
end
init()
function raidersLostArkRead:getTreasureChestInfo(boxType)
	local raidersLostArkRead, chestInfo
	if raidersLostArkRead.stb[boxType] then
		chestInfo = raidersLostArkRead.stb[boxType]
	end
	return chestInfo
end
function raidersLostArkRead:getTreasureKeyTable(boxType)
	local raidersLostArkRead, keyTable
	if raidersLostArkRead.stb[boxType] then
		keyTable = raidersLostArkRead.stb[boxType].key
	end
	return keyTable
end
function raidersLostArkRead:getTotalTreasureOpenCount()
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local totalCount = 0
	for i, v in ipairs(raidersLostArkRead.stb) do
		local keyTable = self:getTreasureKeyTable(i)
		local smallCount = 0
		if keyTable and next(keyTable) then
			for i, v in ipairs(keyTable) do
				local keyCount = backpackCtrl:getItemCount(keyTable[i])
				if i == 1 then
					smallCount = keyCount
				end
				if keyCount < smallCount then
					smallCount = keyCount
				end
			end
		end
		totalCount = totalCount + smallCount
	end
	return totalCount
end
function raidersLostArkRead:getCurChestState(keyTable)
	if not next(keyTable) then
		return
	end
	local backpackCtrl = SoraDGetCtrl("backpackCtrl")
	local chestState = gRaidersLostArkChestStatus.UNSNATCH
	local totalCount = 0
	for i, v in ipairs(keyTable) do
		local keyCount = backpackCtrl:getItemCount(v)
		if 0 < keyCount then
			totalCount = totalCount + 1
		end
	end
	if 0 < totalCount or #keyTable == 1 then
		chestState = gRaidersLostArkChestStatus.SNATCH
	end
	if totalCount >= #keyTable then
		chestState = gRaidersLostArkChestStatus.CANOPEN
	end
	return chestState
end
return raidersLostArkRead
