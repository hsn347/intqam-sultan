local jerseyRead = include("aAReadClass").new()
function jerseyRead.init()
	jerseyRead:defineValue("config", function()
		local tableItemData = require_once("app." .. LocalTblPath .. ".config_server.footballclothes_reward")
		local _ENV, ret = "app." .. LocalTblPath .. ".config_server.footballclothes_reward", "app." .. LocalTblPath .. ".config_server.footballclothes_reward"
		for i, v in ipairs(tableItemData) do
			if not ret[v.group] then
				ret[v.group], _ENV = nil, nil
			end
			if not ret[v.group][v.Type] then
				ret[v.group][v.Type], _ENV = nil, nil
			end
			_ENV = v.Type
			v.Type.type = v.Type
			v.Type.num = v.number
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.Type.reward = serviceFunctions.tableFormat(v.reward, nil)
			table.insert(ret[v.group][v.Type], v.Type)
		end
		return ret
	end)
end
function jerseyRead.getAwardList(group, type)
	return jerseyRead.config[group][type]
end
jerseyRead.init()
return jerseyRead
