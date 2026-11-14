local ltBase = include("ltBase")
local petExchangeltCtrl = class("petExchangeltCtrl", ltBase, include("aAReadClass").new())
function petExchangeltCtrl:ctor()
	petExchangeltCtrl.super.ctor(self)
	self:init()
end
function petExchangeltCtrl:init()
	_UPVALUE2_ = nil
	;(nil)[1] = "pet_exchange_eagle_cfg"
	;(nil)[2] = true
	self:defineValue("eagleExchangeData", nil)
	self:defineValue("itemExchangeData", function()
		local itemData = require_once("app." .. LocalTblPath .. ".config_server.pet_exchange_item_cfg")
		self.itemExchangeData, _ENV = "app." .. LocalTblPath .. ".config_server.pet_exchange_item_cfg", "app." .. LocalTblPath .. ".config_server.pet_exchange_item_cfg"
		for k, v in pairs(itemData) do
			self.itemExchangeData[v.Index] = v
		end
		return self.itemExchangeData
	end)
end
function petExchangeltCtrl:getItemExchangeData()
	if not self.itemExchangeData then
		_UPVALUE0_ = self.itemExchangeData
	end
	return self.itemExchangeData
end
function petExchangeltCtrl:getEagleExchangeData()
	return self.eagleExchangeData
end
function petExchangeltCtrl:queryItemExchange(index)
	print("petExchangeltCtrl:queryItemExchange(index) = ", index)
	if not index then
		return false
	end
	dump(self.itemExchangeData, "petExchangeltCtrl:queryItemExchange(index)")
	if self.itemExchangeData then
		return true, self.itemExchangeData[index]
	else
		return false
	end
end
function petExchangeltCtrl:queryEagleExchangeCost(exchangeType, times)
	local cost = 0
	local maxcost = 0
	times = times or 1
	local bFind = false
	for k, v in pairs(self.eagleExchangeData) do
		if exchangeType == gPetExchangeEagleType.POINT then
			if maxcost < v.Point then
				maxcost = v.Point
			end
			cost = v.Point
		elseif exchangeType == gPetExchangeEagleType.GOLD then
			if maxcost < v.Gold then
				maxcost = v.Gold
			end
			cost = v.Gold
		end
		if v.Index == times then
			bFind = true
			break
		end
	end
	if bFind then
		return cost
	else
		return maxcost
	end
end
return petExchangeltCtrl
