local amazingFortuneCtrl = SoraDGetCtrl("amazingFortuneCtrl")
local amazingFortuneFinalRewardShow = class("amazingFortuneFinalRewardShow", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("amazingFortuneFinalRewardShow")
	end
	return target
end)
function amazingFortuneFinalRewardShow:ctor()
	self.isAddToPopManager = true
	self:bandWidget()
	self:initData()
end
function amazingFortuneFinalRewardShow:bandWidget()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("rechare_activename_1634"))
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	_UPVALUE1_ = "Center_Node"
	;("Center_Node")[1] = "Node_rewards"
	self.Node_rewards = SoraDGetChildByFullPath(self.Center_Node, "Center_Node")
	self.Node_rewards:setPositionY(self.Node_rewards:getPositionY() - 18)
end
function amazingFortuneFinalRewardShow:initData()
	local rewards = amazingFortuneCtrl:getFinalRewardsList()
	if rewards then
		for k, v in ipairs(rewards) do
			local single = SoraDCreatePanel("commonItemAward")
			single:addTo(self.Node_rewards)
			single:setScale(0.88)
			single:setOwnView(self)
			single:initData(v.id, v.count)
		end
		local align = SoraDFIsRA() and 2 or 0
		SoraDautoSortPos(self.Node_rewards, 4, align, cc.size(112, 103))
	end
end
return amazingFortuneFinalRewardShow
