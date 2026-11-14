local manorFarmRead = include("aAReadClass").new()
manorFarmRead:defineValue("farmland_seed_info", function()
	local _ENV, ret
	local config = require_data("farmland_seed_info", true, true).data
	for k, v in pairs(config) do
		ret[v.seedID] = v
	end
	return ret
end)
manorFarmRead:defineValue("farmland_fruit_info", function()
	local _ENV, ret
	local config = require_data("farmland_fruit_info", true, true).data
	for k, v in pairs(config) do
		ret[v.fruitID] = v
	end
	return ret
end)
manorFarmRead:defineValue("farmland_info", function()
	local _ENV, ret
	local config = require_data("farmland_info", true, true).data
	for k, v in pairs(config) do
		ret[v.farmlandType] = v
	end
	return ret
end)
manorFarmRead:defineValue("farmland_package_info", function()
	local _ENV, ret
	local config = require_data("farmland_package_info", true, true).data
	for k, v in pairs(config) do
		ret[v.packageID] = v
	end
	return ret
end)
manorFarmRead:defineValue("farmland_resonance", function()
	local _ENV, ret
	local config = require_data("farmland_resonance", true, true).data
	for k, v in pairs(config) do
		ret[v.farmlandNum] = v
	end
	return ret
end)
function _UPVALUE3_()
	local _ENV, ret
	local config = require_data("farmland_resonance", true, true).data
	for k, v in pairs(config) do
		ret[v.farmlandNum] = v
	end
	return ret
end
;(function()
	local _ENV, ret
	local config = require_data("farmland_resonance", true, true).data
	for k, v in pairs(config) do
		ret[v.farmlandNum] = v
	end
	return ret
end)[1] = "farmland_resonance"
;(function()
	local _ENV, ret
	local config = require_data("farmland_resonance", true, true).data
	for k, v in pairs(config) do
		ret[v.farmlandNum] = v
	end
	return ret
end)[2] = true
;(function()
	local _ENV, ret
	local config = require_data("farmland_resonance", true, true).data
	for k, v in pairs(config) do
		ret[v.farmlandNum] = v
	end
	return ret
end)[3] = true
manorFarmRead:defineValue("farmland_resonance_list", function()
	local _ENV, ret
	local config = require_data("farmland_resonance", true, true).data
	for k, v in pairs(config) do
		ret[v.farmlandNum] = v
	end
	return ret
end)
manorFarmRead:defineValue("farmland_cultivate_queue", function()
	local _ENV, ret
	local config = require_data("farmland_cultitave_queue", true, true).data
	for k, v in pairs(config) do
		ret[v.queue] = v
	end
	return ret
end)
manorFarmRead:defineValue("farmland_plant_relation", function()
	local _ENV, ret
	local config = require_data("farmland_plant_realtion", true, true).data
	for k, v in pairs(config) do
		ret[v.fitterType] = v
	end
	return ret
end)
manorFarmRead:defineValue("farmland_recycle_store", function()
	local _ENV, ret
	local config = require_data("farmland_recycle_store", true, true).data
	for k, v in pairs(config) do
		_ENV = nil
		;(nil).index = v.index
		_ENV, (nil).shopItem = v.shopItem, v.shopItem
		v.shopItem.id = v.exchangeItem[1]
		ret[v.shopItem], (nil).exchangeItem, v.shopItem.count = nil, v.shopItem, v.exchangeItem[2]
	end
	return ret
end)
manorFarmRead:defineValue("farmland_seedType", function()
	_UPVALUE0_, _UPVALUE0_ = nil, nil
	;(nil).icon = "frame_zynt_shuxing07.png"
	_UPVALUE0_, (nil)[0], (nil).buildAttach = nil, nil, ""
	;(nil).icon = "frame_zynt_shuxing06.png"
	_UPVALUE0_, (nil)[1], (nil).buildAttach = nil, nil, "Manor_Architecture_05_4.png"
	;(nil).icon = "frame_zynt_shuxing04.png"
	_UPVALUE0_, (nil)[2], (nil).buildAttach = nil, nil, "Manor_Architecture_05_3.png"
	;(nil).icon = "frame_zynt_shuxing02.png"
	_UPVALUE0_, (nil)[3], (nil).buildAttach = nil, nil, "Manor_Architecture_05_1.png"
	;(nil).icon = "frame_zynt_shuxing01.png"
	_UPVALUE0_, (nil)[4], (nil).buildAttach = nil, nil, "Manor_Architecture_05_6.png"
	;(nil).icon = "frame_zynt_shuxing05.png"
	_UPVALUE0_, (nil)[5], (nil).buildAttach = nil, nil, "Manor_Architecture_05_5.png"
	;(nil).icon = "frame_zynt_shuxing03.png"
	;(nil)[6], (nil).buildAttach = nil, "Manor_Architecture_05_2.png"
	local ret
	return ret
end)
manorFarmRead:defineValue("farmland_handbook_buff", function()
	local _ENV, ret
	local config = require_data("farmland_handbook_buff", true, true).data
	for k, v in ipairs(config) do
		v.buff[2] = v.buff[2] / 10
		table.insert(ret, v)
	end
	return ret
end)
manorFarmRead:defineValue("farmland_seed_merge", function()
	local _ENV, ret
	local config = require_data("farmland_seed_merge", true, true).data
	for k, v in pairs(config) do
		_ENV = nil
		;(nil)[v.seedMerge[1]] = true
		v.input, (nil)[v.seedMerge[2]] = nil, true
		ret[v.index] = v
	end
	return ret
end)
manorFarmRead:defineValue("farmland_stage", function()
	_UPVALUE0_, _UPVALUE0_ = nil, nil
	;(nil).icon = "Manor_Architecture_04_1.png"
	;(nil).rangeMin = 0
	_UPVALUE0_, (nil)[1], (nil).rangeMax = nil, nil, 25
	;(nil).icon = "Manor_Architecture_04_2.png"
	;(nil).rangeMin = 25
	_UPVALUE0_, (nil)[2], (nil).rangeMax = nil, nil, 50
	;(nil).icon = "Manor_Architecture_04_3.png"
	;(nil).rangeMin = 50
	_UPVALUE0_, (nil)[3], (nil).rangeMax = nil, nil, 75
	;(nil).icon = "Manor_Architecture_04_4.png"
	;(nil).rangeMin = 75
	;(nil)[4], (nil).rangeMax = nil, 100
	local ret
	return ret
end)
function manorFarmRead.getExchangeRId()
	for k, v in pairs(manorFarmRead.farmland_seed_info) do
		return v.buyPrice[1]
	end
end
function manorFarmRead.getSeedInfo(seedID)
	return manorFarmRead.farmland_seed_info[seedID]
end
function manorFarmRead.getAllSeedInfo()
	local _ENV, ret
	for k, v in pairs(manorFarmRead.farmland_seed_info) do
		table.insert(ret, v)
	end
	return ret
end
function manorFarmRead.getSeedInfoByFruitID(fruitID)
	for k, v in pairs(manorFarmRead.farmland_seed_info) do
		if v.fruitID == fruitID then
			return v
		end
	end
	return nil
end
function manorFarmRead.getFruitInfo(fruitID)
	return manorFarmRead.farmland_fruit_info[fruitID]
end
function manorFarmRead.getFruitIDBySeedID(seedID)
	local seedData = manorFarmRead.getSeedInfo(seedID)
	return seedData and tonumber(seedData.fruitID) or nil
end
function manorFarmRead.getBagInfo(bagId)
	return manorFarmRead.farmland_package_info[bagId]
end
function manorFarmRead.getFarmlandInfo(farmlandType)
	return manorFarmRead.farmland_info[farmlandType]
end
function manorFarmRead.getSeedTypeNum()
	return table.nums(manorFarmRead.farmland_seedType)
end
function manorFarmRead.getSeedTypeIcon(type)
	return manorFarmRead.farmland_seedType[type] and manorFarmRead.farmland_seedType[type].icon or ""
end
function manorFarmRead.getSeedTypeBuildAttachIcon(type)
	return manorFarmRead.farmland_seedType[type] and manorFarmRead.farmland_seedType[type].buildAttach or ""
end
function manorFarmRead.getQualityConfig(seedQuality)
	_UPVALUE0_, _UPVALUE0_ = nil, nil
	;(nil).name = "C"
	_UPVALUE0_, (nil)[1], (nil).key = nil, nil, "b"
	;(nil).name = "B"
	_UPVALUE0_, (nil)[2], (nil).key = nil, nil, "a"
	;(nil).name = "A"
	_UPVALUE0_, (nil)[3], (nil).key = nil, nil, "s"
	;(nil).name = "S"
	_UPVALUE0_, (nil)[4], (nil).key = nil, nil, "orange"
	;(nil).name = "SS"
	_UPVALUE0_, (nil)[5], (nil).key = nil, nil, "ss"
	;(nil).name = "SSS"
	;(nil)[6], (nil).key = nil, "sss"
	local config
	return config[seedQuality]
end
function manorFarmRead.getQualityName(seedQuality)
	local cfg = manorFarmRead.getQualityConfig(seedQuality)
	return cfg.name
end
function manorFarmRead.getQualityFrame(quality)
	local config = manorFarmRead.getQualityConfig(quality)
	return string.format("frame_sdsl_btl_%s.png", config.key)
end
function manorFarmRead.getSeedQualityFrame(quality)
	return string.format("frame_item_base_0%s.png", tostring(quality))
end
function manorFarmRead.getQualityItemBg(quality)
	return string.format("frame_zynt_tjpz0%s.png", tostring(quality))
end
function manorFarmRead.getMaxFruitQuality()
	return 6
end
function manorFarmRead.getRelation(relationType)
