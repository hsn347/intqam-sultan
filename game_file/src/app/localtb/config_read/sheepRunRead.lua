local sheepRunRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	sheepRunRead:defineValue("showRewards", function()
		local rewrads = require_once("app." .. LocalTblPath .. ".config_server.runningsheep_reward")
		local _ENV, showRewards = "app." .. LocalTblPath .. ".config_server.runningsheep_reward", "app." .. LocalTblPath .. ".config_server.runningsheep_reward"
		for i, v in ipairs(rewrads) do
			if v.type == 1 then
				local _ENV, heightlights = v.type, v.type
				for i2, v2 in ipairs(v.higntLight) do
					heightlights[v2] = true
				end
				for i2, v2 in pairs(v.reward) do
					if not showRewards[v.pool] then
						showRewards[v.pool], _ENV = nil, nil
					end
					if i2 % 3 == 1 then
						local itemIdx = #showRewards[v.pool]
						_ENV = nil
						;(nil).item = v2
						;(nil).num = v.reward[i2 + 1]
						;(nil).highlight = heightlights[itemIdx + 1] ~= nil
						table.insert(showRewards[v.pool], nil)
					end
				end
			end
		end
		sheepRunRead.showRewards = showRewards
		return sheepRunRead.showRewards
	end)
end
function sheepRunRead.getShowRewards()
	return sheepRunRead.showRewards
end
init()
return sheepRunRead
