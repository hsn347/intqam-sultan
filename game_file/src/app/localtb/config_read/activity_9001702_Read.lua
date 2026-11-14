local activity_9001702_Read = include("aAReadClass").new()
_UPVALUE2_ = nil
_UPVALUE2_ = nil
_UPVALUE2_, _ENV, (nil).keyMap, (nil)[1] = "classType", nil, nil, "classType"
_UPVALUE2_, _ENV, (nil).keyMap, (nil)[2] = "classType", nil, nil, "drawType"
;(nil).tableFormat, (nil).drawReward, ("classType")[1] = nil, "classType", "id"
;(nil).tableFormat, (nil).drawReward, ("classType")[2] = nil, "classType", "count"
;(nil)[1] = "eidal_celebration_draw"
;(nil)[2] = true
activity_9001702_Read:defineValue("eidal_celebration_draw", nil)
function activity_9001702_Read.getDrawCfg(drawType)
	local classType = SoraDGetActivityClassType(gActivityTimeActivityID.NORMAL_ACTIVITY_9001702)
	return activity_9001702_Read.eidal_celebration_draw[classType][drawType]
end
function activity_9001702_Read.getDrawCfgWeight(drawType)
	local cfg = activity_9001702_Read.getDrawCfg(drawType)
	return cfg.drawWeight or 0
end
function activity_9001702_Read.getDrawCfgReward(drawType)
	local cfg = activity_9001702_Read.getDrawCfg(drawType)
	if not cfg.drawReward then
		activity_9001702_Read = cfg.drawReward
	end
	return cfg.drawReward
end
function activity_9001702_Read.getLevelStr(level)
	_ENV = nil
	;(nil)[0] = i18n("Eidal_celebration_text_20")
	;(nil)[1] = i18n("Desertmining_07")
	;(nil)[2] = i18n("Desertmining_08")
	local (nil)[3], config = i18n("Desertmining_09"), nil
	return config[level] or ""
end
local constantRead = include("constantRead")
function activity_9001702_Read.getConstValueArray(key)
	_UPVALUE2_ = nil
	;(nil)[1] = 313201
	;(nil)[2] = 5
	local valueArray = constantRead.getConstValueArray(key, nil)
	_UPVALUE2_ = 313201
	;(313201)[1] = "id"
	;(313201)[2] = "count"
	return serviceFunctions.tableFormat(valueArray, 313201)
end
function activity_9001702_Read.getGiftItemID()
	return constantRead.getConstValue("EIDAL_2025_ITEM_GIFTID", 876601)
end
function activity_9001702_Read.getItemMerge()
	return activity_9001702_Read.getConstValueArray("EIDAL_2025_ITEM_MERGE")[1]
end
function activity_9001702_Read.getReceiveGift()
	return activity_9001702_Read.getConstValueArray("EIDAL_2025_RECEIVE_GIFT")[1]
end
function activity_9001702_Read.getSendGift()
	return activity_9001702_Read.getConstValueArray("EIDAL_2025_SEND_GIFT")[1]
end
function activity_9001702_Read.getDrawReward()
	return activity_9001702_Read.getConstValueArray("EIDAL_2025_DRAW_REWARD")
end
function activity_9001702_Read.getAllianceDrawReward()
	return activity_9001702_Read.getConstValueArray("EIDAL_2025_ALLIANCE_DRAW_REWARD")
end
function activity_9001702_Read.getCostItemID()
	local item = activity_9001702_Read.getItemMerge()
	return item.id
end
function activity_9001702_Read.getDrawItemID()
	local item = activity_9001702_Read.getReceiveGift()
	return item.id
end
function activity_9001702_Read.getReceiveGiftLimit()
	return constantRead.getConstValue("EIDAL_2025_RECEIVE_GIFT_LIMIT", 30)
end
return activity_9001702_Read
