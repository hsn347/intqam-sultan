local treasureCrystalRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "treasure_crystal_config"
	;(nil)[2] = true
	treasureCrystalRead:defineValue("crystalConfig", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "treasure_crystal_task"
	;(nil)[2] = true
	treasureCrystalRead:defineValue("crystalTask", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "treasure_crystal_magicbox"
	;(nil)[2] = true
	treasureCrystalRead:defineValue("crystalMagicbox", nil)
end
function treasureCrystalRead.getCrystalConfig(itemID)
	for i, v in ipairs(treasureCrystalRead.crystalConfig) do
		if v.itemID == itemID then
			return v
		end
	end
end
function treasureCrystalRead.getCrystalMagicbox(lv, taskType)
	for i, v in ipairs(treasureCrystalRead.crystalTask) do
		if v.lv == lv and v.taskType == taskType then
			return v.limiteTime
		end
	end
end
function treasureCrystalRead.getMagicboxAward(itemID)
	for i, v in ipairs(treasureCrystalRead.crystalMagicbox) do
		if v.itemID == itemID then
			return v.reward
		end
	end
end
init()
return treasureCrystalRead
