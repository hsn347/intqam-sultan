local weaponSprctrumRead = include("weaponSprctrumRead")
local equipActivityTypeBar = class("equipActivityTypeBar", function(target)
	if target == nil then
		return SoraDCreateBasePanel("equipActivityTypeBar")
	end
	return target
end)
function equipActivityTypeBar:ctor()
	self.percent = 100
	self.Panel_cut = SoraDGetChildByName(self, "Panel_cut")
	self.Panel_cut:setSwallowTouches(false)
	self.Panel_cut:setContentSize(cc.size(132, 16))
	self.Node_unity = SoraDGetChildByName(self, "Node_unity")
	for k, v in pairs(weaponSprctrumRead.jindut1Cfg) do
		SoraDCreateShaderEffect(v, self.Node_unity)
	end
end
function equipActivityTypeBar:setPercent(percent)
	self.percent = percent
	local realW = math.max(0, math.min(132 * self.percent / 100, 132))
	self.Panel_cut:setContentSize(cc.size(realW, 16))
end
function equipActivityTypeBar:getPercent()
	return self.percent
end
return equipActivityTypeBar
