local allianceActiveltCtrl = include("allianceActiveltCtrl")
local allianceActiveRandRewardView = class("allianceActiveRandRewardView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("allianceActiveRandRewardView")
	end
	return target
end)
function allianceActiveRandRewardView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("alliance_title_09"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_item")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("commonRankAwardSingle")
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.ccs_tab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_tab")
	self.ccs_tab:setContentSize(cc.size(534, 56))
	self.ccs_tab:setNewStyle()
	_ENV = cc.size(534, 56)
	_ENV, _ENV, cc.size(534, 56).tabNum = cc.size(534, 56)
	cc.size(534, 56).title = i18n("alliance_title_10")
	cc.size(534, 56).tag = 2
	_ENV, cc.size(534, 56)[1], cc.size(534, 56).handle = cc.size(534, 56)
	cc.size(534, 56).title = i18n("alliance_title_11")
	cc.size(534, 56).tag = 1
	cc.size(534, 56).tabsetArray, cc.size(534, 56)[2], cc.size(534, 56).handle = cc.size(534, 56)
	self.ccs_tab:initView(cc.size(534, 56))
end
function allianceActiveRandRewardView:clickTab(tag)
	local rankData = allianceActiveltCtrl.getRankRewardInfo(tag)
	allianceActiveltCtrl = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	;(nil).singleSize = cc.size(536, 80)
	self.scroll:updateScrollView(cc.size(536, 80), rankData, 1, nil)
	self.Text_tip:setString(tag == 2 and i18n("alliance_text_42") or i18n("alliance_text_40"))
end
return allianceActiveRandRewardView
