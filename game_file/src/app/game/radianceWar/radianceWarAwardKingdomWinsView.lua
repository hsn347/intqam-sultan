local radianceWarAwardKingdomWinsView = class("radianceWarAwardKingdomWinsView", function(target)
	return include("radianceWarAwardPersonalView").new(target)
end)
local REWARD_VIEW_TYPE = include("radianceWarDef").REWARD_VIEW_TYPE
function radianceWarAwardKingdomWinsView:ctor()
	self.rewardViewType = REWARD_VIEW_TYPE.REWARD_VIEW_TYPE_WINNER
	self.btnRank:setTitleText(i18n("brightWar_title_08"))
	self:initData(1)
end
return radianceWarAwardKingdomWinsView
