local sultanCoinRebateRead = include("aAReadClass").new()
function sultanCoinRebateRead.init()
	sultanCoinRebateRead:defineValue("othenrebate", function()
		local _ENV, ret
		local cfg = require_once("app." .. LocalTblPath .. ".config_server.othenrebate")
		for k, v in ipairs(cfg) do
			if not ret[v.type] then
				ret[v.type], _ENV = nil, nil
			end
			table.insert(ret[v.type], v)
		end
		return ret
	end)
end
function sultanCoinRebateRead.getOthenrebate(classType)
	return sultanCoinRebateRead.othenrebate[tonumber(classType)]
end
function sultanCoinRebateRead.getDetailByIndex(index, classType)
	return sultanCoinRebateRead.othenrebate[tonumber(classType)][index]
end
sultanCoinRebateRead.init()
return sultanCoinRebateRead
