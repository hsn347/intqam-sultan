local exchangeltCtrl = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	local createData = function(name)
		local config = require_once("app." .. LocalTblPath .. ".config_server.exchange_config")
		local _ENV, exchangeList = "app." .. LocalTblPath .. ".config_server.exchange_config", "app." .. LocalTblPath .. ".config_server.exchange_config"
		local _ENV, useItemExchangeList = LocalTblPath, LocalTblPath
		for i, v in ipairs(config) do
			local exchangeID = v.exchangeID
			exchangeList[exchangeID] = v
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.useItem = serviceFunctions.tableFormat(v.useItem, nil)
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.result = serviceFunctions.tableFormat(v.result, nil)
			for k, item in ipairs(v.useItem) do
				if not useItemExchangeList[item.id] then
					_ENV = useItemExchangeList[item.id]
				end
				useItemExchangeList[item.id] = useItemExchangeList[item.id]
				table.insert(useItemExchangeList[item.id], v)
			end
		end
		exchangeltCtrl.exchangeList = exchangeList
		exchangeltCtrl.useItemExchangeList = useItemExchangeList
		if name == "exchangeList" then
			return exchangeList
		elseif name == "useItemExchangeList" then
			return useItemExchangeList
		end
	end
	exchangeltCtrl:defineValue("exchangeList", createData)
	exchangeltCtrl:defineValue("useItemExchangeList", createData)
end
init()
function exchangeltCtrl:exchangeIDValid(eid)
	if eid and self.exchangeList[eid] then
		return true
	end
	return false
end
function exchangeltCtrl:getUseItem(eid)
	local useItem = self.exchangeList and self.exchangeList[eid].useItem
	if useItem then
		return serviceFunctions.table_copy_table(useItem)
	end
end
function exchangeltCtrl:getResult(eid)
	local result = self.exchangeList and self.exchangeList[eid].result
	if result then
		return serviceFunctions.table_copy_table(result)
	end
end
function exchangeltCtrl:getExchangeList(id)
	if not self.useItemExchangeList or not self.useItemExchangeList[id] then
		_UPVALUE0_ = self.useItemExchangeList[id]
	end
	return self.useItemExchangeList[id]
end
return exchangeltCtrl
