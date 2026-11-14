local remainsWarReward = class("remainsWarReward", function(target)
	if target == nil then
		target = SoraDCreateTouchPanel("remainsWarReward")
	end
	return target
end)
_ENV = "remainsWarReward"
;("remainsWarReward").REWARD_VIEW_TYPE_SEASON = 1
;("remainsWarReward").REWARD_VIEW_TYPE_ROUND = 2
local ("remainsWarReward").REWARD_VIEW_TYPE_TITLE, REWARD_VIEW_TYPE = 3, "remainsWarReward"
function remainsWarReward:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("common_text_1235"))
	self.nodeTop = SoraDGetChildByName(self, "Top_Node")
	self.ccs_tab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_tab")
	self.ccs_tab:setContentSize(cc.size(570, 56))
	self.ccs_tab:setNewStyle()
	_ENV = cc.size(570, 56)
	cc.size(570, 56).tabNum = 3
	_ENV, _ENV, cc.size(570, 56).defaultClick = cc.size(570, 56)
	cc.size(570, 56).title = i18n("btn_title_02")
	cc.size(570, 56).tag = REWARD_VIEW_TYPE.REWARD_VIEW_TYPE_SEASON
	_ENV, cc.size(570, 56)[1], cc.size(570, 56).handle = cc.size(570, 56)
	cc.size(570, 56).title = i18n("btn_title_01")
	cc.size(570, 56).tag = REWARD_VIEW_TYPE.REWARD_VIEW_TYPE_ROUND
	_ENV, cc.size(570, 56)[2], cc.size(570, 56).handle = cc.size(570, 56)
	cc.size(570, 56).title = i18n("mail_title_92")
	cc.size(570, 56).tag = REWARD_VIEW_TYPE.REWARD_VIEW_TYPE_TITLE
	cc.size(570, 56).tabsetArray, cc.size(570, 56)[3], cc.size(570, 56).handle = cc.size(570, 56)
	self.ccs_tab:initView(cc.size(570, 56))
end
function remainsWarReward:createPanel(showViewType)
	if self.curView then
		self.curView:setVisible(false)
	end
	if showViewType == REWARD_VIEW_TYPE.REWARD_VIEW_TYPE_SEASON then
		if self.seasonView == nil then
			self.seasonView = self:createSinglePanel("remainsWarRewardSeasonView")
		else
			self.seasonView:setVisible(true)
		end
		self.curView = self.seasonView
	elseif showViewType == REWARD_VIEW_TYPE.REWARD_VIEW_TYPE_ROUND then
		if self.roundView == nil then
			self.roundView = self:createSinglePanel("remainsWarRewardRoundView")
		else
			self.roundView:setVisible(true)
		end
		self.curView = self.roundView
	elseif showViewType == REWARD_VIEW_TYPE.REWARD_VIEW_TYPE_TITLE then
		if self.titleView == nil then
			self.titleView = self:createSinglePanel("remainsWarRewardTitleView")
		else
			self.titleView:setVisible(true)
		end
		self.curView = self.titleView
	end
end
function remainsWarReward:createSinglePanel(fileName)
	local panel = SoraDCreatePanelByFixName(fileName)
	panel:setPosition(SoraDFPoint(0, -20, 0))
	panel:addTo(self.nodeTop, -1)
	panel:init()
	return panel
end
return remainsWarReward
