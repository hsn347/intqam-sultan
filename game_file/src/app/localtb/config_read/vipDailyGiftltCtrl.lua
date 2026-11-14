local vipDailyGiftltCtrl = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	vipDailyGiftltCtrl:initialize()
end
function vipDailyGiftltCtrl:initialize()
	vipDailyGiftltCtrl:defineValue("data", function()
		self.data, self = nil, nil
		local config = require_once("app." .. LocalTblPath .. ".config_server.vip_daily_gift_config")
		local self, ret = "app." .. LocalTblPath .. ".config_server.vip_daily_gift_config", "app." .. LocalTblPath .. ".config_server.vip_daily_gift_config"
		for i, v in ipairs(config) do
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.gift = serviceFunctions.tableFormat(v.gift, nil)
			ret[v.level] = v
		end
		self.data.config = ret
		return self.data
	end)
end
function vipDailyGiftltCtrl:hasLoginGift(vipLevel)
	if not self:hasConfig(vipLevel) then
		return false
	end
	if not self:getConfig()[vipLevel].gift then
		local _UPVALUE0_, gift = self:getConfig()[vipLevel].gift, self:getConfig()[vipLevel].gift
	end
	if gift and gift[1] then
		return true
	end
	return false
end
function vipDailyGiftltCtrl:getGift(vipLevel)
	if not self:hasConfig(vipLevel) then
		return false
	end
	if not self:getConfig()[vipLevel].gift then
		local _UPVALUE0_, gift = self:getConfig()[vipLevel].gift, self:getConfig()[vipLevel].gift
	end
	return gift
end
function vipDailyGiftltCtrl:getConfig()
	if not self.data.config then
		_UPVALUE0_ = self.data.config
	end
	return self.data.config
end
function vipDailyGiftltCtrl:hasConfig(vipLevel)
	local config = self:getConfig()
	if vipLevel and config[vipLevel] then
		return true
	end
	return false
end
init()
return vipDailyGiftltCtrl
