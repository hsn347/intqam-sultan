local ltBase = include("ltBase")
local rechargeGiftRead = class("rechargeGiftRead", ltBase, include("aAReadClass").new())
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "recharge_activity_gift"
	;(nil)[2] = true
	rechargeGiftRead:defineValue("giftConfig", nil)
end
function rechargeGiftRead:ctor()
	rechargeGiftRead.super.ctor(self)
end
function rechargeGiftRead:getProperty(itemID, property)
	if not rechargeGiftRead.super.getProperty(self, self.giftConfig, itemID, property) then
		rechargeGiftRead = rechargeGiftRead.super.getProperty(self, self.giftConfig, itemID, property)
	end
	return (rechargeGiftRead.super.getProperty(self, self.giftConfig, itemID, property))
end
init()
return rechargeGiftRead
