local warTreasureRead = include("warTreasureRead")
local warTreasureRankAward = class("warTreasureRankAward", function(target)
	return target or SoraDCreateTouchPanel("warTreasureRankAward")
end)
function warTreasureRankAward:ctor()
	self.itemSize = cc.size(536, 100)
	self.popBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.popBox:setTitleName(i18n("hero_title_02"))
	self.textTips = SoraDGetChildByName(self, "text_tip")
	self.singleNode = SoraDGetChildByName(self, "Node_Rank")
	self.scroll = SoraDGetChildByName(self, "ScrollView_item")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("commonRankAwardSingle")
	self.ccs_tab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX")
	self.ccs_tab:setContentSize(cc.size(538, 56))
	self.ccs_tab:setNewStyle()
	_ENV = cc.size(538, 56)
	_ENV, _ENV, cc.size(538, 56).tabNum = cc.size(538, 56)
	cc.size(538, 56).title = i18n("warSecrit_title_03")
	cc.size(538, 56).handle = handler(self, self.btnClickTab)
	_ENV, cc.size(538, 56)[1], cc.size(538, 56).tag = cc.size(538, 56)
	cc.size(538, 56).title = i18n("warSecrit_title_04")
	cc.size(538, 56).handle = handler(self, self.btnClickTab)
	cc.size(538, 56).tabsetArray, cc.size(538, 56)[2], cc.size(538, 56).tag = cc.size(538, 56)
	self.ccs_tab:initView(cc.size(538, 56))
	self.textTips:setString(i18n("warSecrit_text_32"))
end
function warTreasureRankAward:setDefaultClick(type)
	self.itemID = type
	print("warTreasureRank:setDefaultClick", type)
	self.ccs_tab:setDefaultClick(tonumber(self.itemID) == 827101 and 1 or 2)
end
function warTreasureRankAward:btnClickTab(tag, name)
	local rankData = warTreasureRead.getRankAward(tag)
	dump(rankData, "warTreasureRankAward", 10)
	warTreasureRead = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	;(nil).singleSize = self.itemSize
	self.scroll:updateScrollView(self.itemSize, rankData, 1, nil)
	self.scroll:jumpToTop()
end
return warTreasureRankAward
