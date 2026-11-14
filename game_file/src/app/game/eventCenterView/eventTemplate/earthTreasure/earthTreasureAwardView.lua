local earthTreasureAwardView = class("earthTreasureAwardView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("earthTreasureAwardView")
end)
function earthTreasureAwardView:ctor(properties)
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeCommonPopBox:setTitleName(i18n("decrypt_text_03"))
	self.nodeReward = SoraDGetChildByName(self, "Node_Reward")
	self:initData()
end
function earthTreasureAwardView:initData(target, data)
	for i, v in ipairs(include("earthTreasureRead").getRewardList(SoraDGetCtrl("earthTreasureCtrl"):getRewardGroup())) do
		local single = include("commonItemAward").new()
		single:addTo(self.nodeReward)
		single:setBaseScale(0.9)
		single:setOwnView(self)
		single:initData(v.rewards[1], v.rewards[2])
	end
	SoraDautoSortPos(self.nodeReward, 4, 1, cc.size(110, 110), SoraDFIsRA())
end
return earthTreasureAwardView
