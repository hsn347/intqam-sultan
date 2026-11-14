local nebulastoreRead = include("aAReadClass").new()
nebulastoreRead.isInit = false
function nebulastoreRead.init()
	if nebulastoreRead.isInit then
		return
	end
	nebulastoreRead.isInit = true
	_UPVALUE2_ = nil
	;(nil)[1] = "nebulastore_item"
	;(nil)[2] = true
	nebulastoreRead:defineValue("item", nil)
	_ENV = nil
	;(nil)[1] = "nebulastore_label"
	nebulastoreRead:defineValue("label", nil)
	nebulastoreRead:defineValue("gift", function()
		nebulastoreRead.gift, nebulastoreRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.nebulastore_gift")
		for k, v in ipairs(cfg) do
			if not nebulastoreRead.gift[v.type] then
				nebulastoreRead.gift[v.type], nebulastoreRead = nil, nil
			end
			table.insert(nebulastoreRead.gift[v.type], v)
		end
		return nebulastoreRead.gift
	end)
end
nebulastoreRead.init()
function nebulastoreRead.getItemList()
	return nebulastoreRead.item
end
function nebulastoreRead.getItemCfg(index)
	return nebulastoreRead.item[index]
end
function nebulastoreRead.getGiftList(gType)
	local cfg = nebulastoreRead.gift[gType]
	local nebulastoreRead, ret
	local quality, lv, starLv = SoraDGetBuildQuality()
	local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
	local jinn1Lv = magicLampCtrl:getJinnLv(gJinnType.JINN_ONE)
	for k, v in ipairs(cfg) do
		if v.limitStarLevel <= SoraDGetBuildStarLv() and v.limitLevel <= SoraDGetCastleLv() and starLv >= v.limitStatueLevel and SoraDGetCtrl("starlightPavilionCtrl"):getClassType() == v.groupType and (v.limitLamp1Level == 0 or v.limitLamp1Level > 0 and jinn1Lv >= v.limitLamp1Level) then
			table.insert(ret, v)
		end
	end
	return ret
end
function nebulastoreRead.getLabelList()
	local cfg = nebulastoreRead.label
	local nebulastoreRead, ret
	for k, v in ipairs(cfg) do
		local list = nebulastoreRead.getGiftList(k)
		if list and next(list) then
			table.insert(ret, v)
		end
	end
	return ret
end
function nebulastoreRead.getLabelCfg(lType)
	return nebulastoreRead.label[lType]
end
return nebulastoreRead
