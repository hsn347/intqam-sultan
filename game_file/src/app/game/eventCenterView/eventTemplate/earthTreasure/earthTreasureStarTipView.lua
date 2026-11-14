local earthTreasureRead = include("earthTreasureRead")
local publicRead = include("publicRead")
local earthTreasureStarTipView = class("earthTreasureStarTipView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("earthTreasureStarTipView")
end)
function earthTreasureStarTipView:ctor(properties)
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.nodeCommonPopBox:setTitleName(i18n("universe_text_08"))
	self.textTips = SoraDGetChildByName(self, "Text_Tips")
	self.textTips:setString(i18n("universe_text_07"))
	self.nodeReward = SoraDGetChildByName(self, "Node_Reward")
	SoraDGetChildByName(self.nodeReward, "Text_Star"):setString(i18n("universe_text_08"))
	SoraDGetChildByName(self.nodeReward, "Text_Reward"):setString(i18n("common_text_2078"))
	self.textNumList = SoraDGetChildsArrayByName(self.nodeReward, "Text_Num_", 5, 1)
	self.textRewardList = SoraDGetChildsArrayByName(self.nodeReward, "Text_Reward_", 5, 1)
	self:initData()
end
function earthTreasureStarTipView:initData(target, data)
	local rewards = earthTreasureRead.getStarReward()
	for i, v in ipairs(rewards) do
		if i == #rewards then
			self.textNumList[i]:setString(string.format("%d+", v.totalPoint[1]))
		else
			self.textNumList[i]:setString(string.format("%d-%d", v.totalPoint[1], v.totalPoint[2]))
		end
		self.textRewardList[i]:setString(i18n(publicRead.getName(v.startReward[1])) .. string.format("*%d", v.startReward[2]))
	end
end
return earthTreasureStarTipView
