local allianceTreasureltCtrl = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	allianceTreasureltCtrl = nil
	;(nil)[1] = "treasure_config"
	allianceTreasureltCtrl:defineValue("treasure_config", nil)
	allianceTreasureltCtrl:defineValue("treasureInfoList", function()
		local _ENV, treasureInfoList
		for k, v in pairs(allianceTreasureltCtrl.treasure_config) do
			treasureInfoList[v.teasureID .. "_" .. v.quality] = v
		end
		return treasureInfoList
	end)
end
init()
function allianceTreasureltCtrl.getTreasureName(id, quality)
	local id = math.min(id or 1, 5)
	local quality = math.min(quality or 1, 5)
	local key = id .. "_" .. quality
	return allianceTreasureltCtrl.treasureInfoList[key] and i18n(allianceTreasureltCtrl.treasureInfoList[key].describe) or ""
end
function allianceTreasureltCtrl.getTreasureBox(id, quality)
	local id = math.min(id or 1, 5)
	local quality = math.min(quality or 1, 5)
	local key = id .. "_" .. quality
	return allianceTreasureltCtrl.treasureInfoList[key] and allianceTreasureltCtrl.treasureInfoList[key].image or "allitreas_box_01.png"
end
return allianceTreasureltCtrl
