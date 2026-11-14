local annihilationRead = include("annihilationRead")
local totalSweepRankReward = class("totalSweepRankReward", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("totalSweepRankReward")
	end
	return target
end)
function totalSweepRankReward:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_2194"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_item")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("commonRankAwardSingle")
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	_ENV = i18n("common_text_2194")
	i18n("common_text_2194").rank = 100
	self.Text_tip:setString(i18n("annihilation_text_01", i18n("common_text_2194")))
	self:initData()
end
function totalSweepRankReward:initData()
	local rankReward = annihilationRead.getRankReward()
	annihilationRead = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	self.scroll:updateScrollView(cc.size(536, 80), rankReward, 1, nil)
end
return totalSweepRankReward
