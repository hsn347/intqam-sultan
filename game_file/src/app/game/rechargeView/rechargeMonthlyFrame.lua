local gametop = gModuleMgr.getObject("gametop")
local rechargeActivityCtrl = gametop.playertop_:getModule("rechargeActivityCtrl")
local RechargeMonthlyFrame = class("rechargeMonthlyFrame", function(target)
	if target == nil then
		local panel = SoraDCreatePanel("rechargeView")
		paymentManager.openRechargeView(gRechargeActiveFromEnum.ROAD23)
		return panel
	end
	return target
end)
function RechargeMonthlyFrame:ctor()
	self:expect2SelectTab(gRechargeCenterCategory.MONTH)
end
return RechargeMonthlyFrame
