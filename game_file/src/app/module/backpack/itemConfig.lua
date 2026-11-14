local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local _ENV, itemConfig = "backpackltCtrl", "backpackltCtrl"
local _ENV, effects
function effects.none(itemID, count, ...)
	print("effects.none:itemID=", itemID, ",count=", count, ",...=", ...)
	return true
end
function effects.getBuff(itemID, count, ...)
	print("effects.getBuff:itemID=", itemID, ",count=", count, ",...=", ...)
	return true
end
function effects.getItem(itemID, count, ...)
	print("effects.getItem:itemID=", itemID, ",count=", count, ",...=", ...)
	return true
end
function effects.luaScript(itemID, count, ...)
	print("effects.luaScript:itemID=", itemID, ",count=", count, ",...=", ...)
	return true
end
function effects.randomMoveCity(itemID, count, ...)
	print("effects.randomMoveCity:itemID=", itemID, ",count=", count, ",...=", ...)
	return true
end
function effects.changeName(itemID, count, ...)
	print("effects.changeName:itemID=", itemID, ",count=", count, ",...=", ...)
	return true
end
function effects.changeIcon(itemID, count, ...)
	print("effects.changeIcon:itemID=", itemID, ",count=", count, ",...=", ...)
	return true
end
function effects.moveBuild(itemID, count, ...)
	print("effects.moveBuild:itemID=", itemID, ",count=", count, ",...=", ...)
	return true
end
function effects.giveItem(itemID, count, ...)
	print("effects.giveItem:itemID=", itemID, ",count=", count, ",...=", ...)
	return true
end
function effects.marchSpeedUp(itemID, count, ...)
	print("effects.marchSpeedUp:itemID=", itemID, ",count=", count, ",...=", ...)
	return true
end
function effects.abbrSpeedUp(itemID, count, ...)
	print("effects.abbrSpeedUp:itemID=", itemID, ",count=", count, ",...=", ...)
	return true
end
function effects.addChargeBuildQueue(itemID, count, ...)
	print("effects.addChargeBuildQueue:itemID=", itemID, ",count=", count, ",...=", ...)
	return true
end
function effects.activateVIP(itemID, count, ...)
	print("effects.activateVIP:itemID=", itemID, ",count=", count, ",...=", ...)
	return true
end
function effects.marchBack(itemID, count, ...)
	print("effects.activateVIP:itemID=", itemID, ",count=", count, ",...=", ...)
	return true
end
function effects.moveCity(itemID, count, ...)
	return true
end
function effects.goldGift(itemID, count, ...)
	return true
end
_ENV, effects.repairWall = function(itemID, count, ...)
	return true
end, function(itemID, count, ...)
	return true
end
;(function(itemID, count, ...)
	return true
end)[gItemEffectDef.NONE] = effects.none
;(function(itemID, count, ...)
	return true
end)[gItemEffectDef.BUFF] = effects.getBuff
;(function(itemID, count, ...)
	return true
end)[gItemEffectDef.ITEM] = effects.getItem
;(function(itemID, count, ...)
	return true
end)[gItemEffectDef.LUA] = effects.luaScript
;(function(itemID, count, ...)
	return true
end)[gItemEffectDef.RANDOM_MOVE_CITY] = effects.randomMoveCity
;(function(itemID, count, ...)
	return true
end)[gItemEffectDef.CHANGE_NAME] = effects.changeName
;(function(itemID, count, ...)
	return true
end)[gItemEffectDef.CHANGE_ICON] = effects.changeIcon
;(function(itemID, count, ...)
	return true
end)[gItemEffectDef.MOVE_BUILD] = effects.moveBuild
;(function(itemID, count, ...)
	return true
end)[gItemEffectDef.GIVE_ITEM] = effects.giveItem
;(function(itemID, count, ...)
	return true
end)[gItemEffectDef.MARCH_SPEED_UP] = effects.marchSpeedUp
;(function(itemID, count, ...)
	return true
end)[gItemEffectDef.ABBR_SPEED_UP] = effects.abbrSpeedUp
;(function(itemID, count, ...)
	return true
end)[gItemEffectDef.ADD_BUILD_QUEUE] = effects.addChargeBuildQueue
;(function(itemID, count, ...)
	return true
end)[gItemEffectDef.ACTIVATE_VIP] = effects.activateVIP
;(function(itemID, count, ...)
	return true
end)[gItemEffectDef.MARCH_BACK] = effects.marchBack
;(function(itemID, count, ...)
	return true
end)[gItemEffectDef.HIGH_MOVE_CITY] = effects.moveCity
;(function(itemID, count, ...)
	return true
end)[gItemEffectDef.GOLD_GIFT] = effects.goldGift
local (function(itemID, count, ...)
	return true
end)[gItemEffectDef.REPAIR_WALL], result = effects.repairWall, function(itemID, count, ...)
	return true
end
function itemConfig.getEffect(itemID)
	local resultType = backpackltCtrl:getResultType(itemID)
	return result[resultType]
end
return itemConfig
