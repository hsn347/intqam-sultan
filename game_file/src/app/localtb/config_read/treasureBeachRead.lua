local treasureBeachRead = include("aAReadClass").new()
treasureBeachRead.isInited = false
treasureBeachRead.grandPrizesIdx = 50
local init = function()
	if treasureBeachRead.isInited then
		return
	end
	treasureBeachRead.isInited = true
	treasureBeachRead:defineValue("treasure_beach", function()
		treasureBeachRead.treasure_beach, treasureBeachRead = nil, nil
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.treasure_beach")
		for k, v in ipairs(cfg) do
			treasureBeachRead.treasure_beach[v.id] = v
			if v.grandPrizes == 1 then
				treasureBeachRead.grandPrizesIdx = v.id
			end
		end
		return treasureBeachRead.treasure_beach
	end)
end
init()
function treasureBeachRead.getBeachCfg()
	return treasureBeachRead.treasure_beach
end
function treasureBeachRead.getBeachCfgByIdx(idx)
	return treasureBeachRead.treasure_beach[idx]
end
function treasureBeachRead.getGrandPrizesIdx()
	return treasureBeachRead.grandPrizesIdx
end
return treasureBeachRead
