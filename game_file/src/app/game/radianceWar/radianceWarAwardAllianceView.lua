local radianceWarAwardAllianceView = class("radianceWarAwardAllianceView", function(target)
	return include("radianceWarAwardPersonalView").new(target)
end)
_ENV = "radianceWarAwardAllianceView"
;("radianceWarAwardAllianceView").REWARD_VIEW_TYPE_CHECKPOINT = 1
local ("radianceWarAwardAllianceView").REWARD_VIEW_TYPE_PALACE, REWARD_VIEW_TYPE_NEXT = 2, "radianceWarAwardAllianceView"
local REWARD_VIEW_TYPE = include("radianceWarDef").REWARD_VIEW_TYPE
function radianceWarAwardAllianceView:ctor()
	self.rewardViewType = REWARD_VIEW_TYPE.REWARD_VIEW_TYPE_ALLIANCE
	self.showViewType = REWARD_VIEW_TYPE_NEXT.REWARD_VIEW_TYPE_CHECKPOINT
	self.btnRank:setTitleText(i18n("brightWar_title_07"))
	REWARD_VIEW_TYPE, self.nodeCommonTabBtnEX = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_Top"), SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_Top")
	SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_Top").tabNum = 2
	REWARD_VIEW_TYPE, REWARD_VIEW_TYPE, SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_Top").defaultClick = "CCS_commonTabBtnEX_Top", self, 1
	;("CCS_commonTabBtnEX_Top").title = i18n("brightWar_text_194")
	;("CCS_commonTabBtnEX_Top").handle = handler(self, self.btnTabClick)
	REWARD_VIEW_TYPE, self[1], ("CCS_commonTabBtnEX_Top").tag = "CCS_commonTabBtnEX_Top", "CCS_commonTabBtnEX_Top", REWARD_VIEW_TYPE_NEXT.REWARD_VIEW_TYPE_CHECKPOINT
	;("CCS_commonTabBtnEX_Top").title = i18n("brightWar_title_06")
	;("CCS_commonTabBtnEX_Top").handle = handler(self, self.btnTabClick)
	SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_Top").tabsetArray, self[2], ("CCS_commonTabBtnEX_Top").tag = self, "CCS_commonTabBtnEX_Top", REWARD_VIEW_TYPE_NEXT.REWARD_VIEW_TYPE_PALACE
	local param = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_Top")
	self.nodeCommonTabBtnEX:initView(param)
end
function radianceWarAwardAllianceView:btnTabClick(showViewType)
	self.showViewType = showViewType
	self.scroll:jumpToTop()
	self:initData(self.showViewType + 2)
end
return radianceWarAwardAllianceView
