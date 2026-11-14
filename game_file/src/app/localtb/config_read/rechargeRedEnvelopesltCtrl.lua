local rechargeRedEnvelopesltCtrl = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "recharge_red_envelopes"
	;(nil)[2] = true
	rechargeRedEnvelopesltCtrl:defineValue("config", nil)
end
init()
function rechargeRedEnvelopesltCtrl:getPrice(rechargeID)
	return self:getConfig(rechargeID, "price")
end
function rechargeRedEnvelopesltCtrl:getResult(rechargeID)
	return self:getConfig(rechargeID, "result")
end
function rechargeRedEnvelopesltCtrl:getGold(rechargeID)
	local result = self:getResult(rechargeID)
	local ret
	if result then
		ret = result[2]
	end
	ret = ret or 0
	return ret
end
function rechargeRedEnvelopesltCtrl:getRechargeList()
	local _ENV, list
	if self.config then
		for rechargeID, v in pairs(self.config) do
			local data = clone(v)
			data.rid = rechargeID
			table.insert(list, data)
		end
		table.sort(list, function(l, r)
			return l.rid < r.rid
		end)
	end
	return list
end
function rechargeRedEnvelopesltCtrl:getConfig(rechargeID, paramName)
	if not rechargeID or not paramName then
		return
	end
	local data = self.config[rechargeID]
	return data and data[paramName]
end
return rechargeRedEnvelopesltCtrl
