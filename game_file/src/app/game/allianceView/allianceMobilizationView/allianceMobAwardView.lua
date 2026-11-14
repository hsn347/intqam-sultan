local gametop = gModuleMgr.getObject("gametop")
local playerMobilizationCtrl = gametop.playertop_:getModule("playerMobilizationCtrl")
local mobilizationltCtrl = gModuleMgr.sharedMgr("mobilizationltCtrl")
local allianceMobAwardView = class("allianceMobAwardView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceMobAwardView")
	end
	return target
end)
function allianceMobAwardView:ctor()
	self.ccs_title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_node")
	self.ccs_title:setTitle(i18n("alliance_mobilize_text_01"))
	self.Text_notice = SoraDGetChildByName(self, "Text_notice")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_list")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("allianceMobAwardSingle")
	self.ccs_tab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtn_tab")
	_ENV = "CCS_commonTabBtn_tab"
	;("CCS_commonTabBtn_tab").tabNum = 2
	_ENV, _ENV, ("CCS_commonTabBtn_tab").defaultClick = i18n("alliance_mobilize_text_01")
	i18n("alliance_mobilize_text_01").title = i18n("common_text_3143")
	_ENV, i18n("alliance_mobilize_text_01")[1], i18n("alliance_mobilize_text_01").handle = i18n("alliance_mobilize_text_01")
	i18n("alliance_mobilize_text_01").title = i18n("common_text_3050")
	;("CCS_commonTabBtn_tab").tabsetArray, i18n("alliance_mobilize_text_01")[2], i18n("alliance_mobilize_text_01").handle = i18n("alliance_mobilize_text_01")
	self.ccs_tab:initView("CCS_commonTabBtn_tab")
end
function allianceMobAwardView:onStageClick()
	self.Text_notice:setString(i18n("alliance_mobilize_text_02"))
	local matchlev = playerMobilizationCtrl:getAllianceMatchlev()
	local array = mobilizationltCtrl:getStagesAwardByLv(matchlev)
	_ENV = i18n("alliance_mobilize_text_02")
	i18n("alliance_mobilize_text_02").scroll = self.scroll
	i18n("alliance_mobilize_text_02").view = self
	i18n("alliance_mobilize_text_02").stage = true
	self.scroll:updateScrollView(cc.size(640, 190), array, 1, i18n("alliance_mobilize_text_02"))
	self.scroll:jumpToTop()
end
function allianceMobAwardView:onRankClick()
	self.Text_notice:setString(i18n("common_text_3594"))
	local matchlev = playerMobilizationCtrl:getAllianceMatchlev()
	local array = mobilizationltCtrl:getAllianceRankAwardByLv(matchlev)
	_ENV = i18n("common_text_3594")
	i18n("common_text_3594").scroll = self.scroll
	i18n("common_text_3594").view = self
	i18n("common_text_3594").customHeight = 190 * (#array - 1) + 350
	i18n("common_text_3594").offSetY = -160
	self.scroll:updateScrollView(cc.size(640, 190), array, 1, i18n("common_text_3594"))
	self.scroll:jumpToTop()
end
return allianceMobAwardView
