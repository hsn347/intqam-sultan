local remainsWarRankView = class("remainsWarRankView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("remainsWarRankView")
	end
	return target
end)
_ENV = "remainsWarRankView"
;("remainsWarRankView").RANK_VIEW_TYPE_SCORE = 1
;("remainsWarRankView").RANK_VIEW_TYPE_HISTORY = 2
;("remainsWarRankView").RANK_VIEW_TYPE_HISTORY_SEASON = 3
local ("remainsWarRankView").RANK_VIEW_TYPE_TITLE, RANK_VIEW_TYPE = 4, "remainsWarRankView"
function remainsWarRankView:ctor()
	self.isHideCurrentSceneView = true
	self.title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_bag")
	self.title:setTitle(i18n("common_text_851"))
	self.nodeTop = SoraDGetChildByName(self, "Top_Node")
	self.ccs_tab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtn_tab")
	self.ccs_tab:setContentSize(cc.size(660, 72))
	_ENV, _ENV = self.ccs_tab, self.ccs_tab.setContentSize
	self.ccs_tab.title = i18n("remains_btn_17")
	self.ccs_tab.tag = RANK_VIEW_TYPE.RANK_VIEW_TYPE_SCORE
	_ENV, self.ccs_tab.setContentSize[1], self.ccs_tab.handle = self.ccs_tab, self.ccs_tab, handler(self, self.OnBtnChangeClick)
	self.ccs_tab.title = i18n("common_text_3032")
	self.ccs_tab.tag = RANK_VIEW_TYPE.RANK_VIEW_TYPE_HISTORY
	_ENV, self.ccs_tab.setContentSize[2], self.ccs_tab.handle = self.ccs_tab, self.ccs_tab, handler(self, self.OnBtnChangeClick)
	self.ccs_tab.title = i18n("remains_text_199")
	self.ccs_tab.tag = RANK_VIEW_TYPE.RANK_VIEW_TYPE_HISTORY_SEASON
	_ENV, self.ccs_tab.setContentSize[3], self.ccs_tab.handle = self.ccs_tab, self.ccs_tab, handler(self, self.OnBtnChangeClick)
	self.ccs_tab.title = i18n("remains_text_382")
	self.ccs_tab.tag = RANK_VIEW_TYPE.RANK_VIEW_TYPE_TITLE
	self.tableData, self.ccs_tab.setContentSize[4], self.ccs_tab.handle = self.ccs_tab.setContentSize, self.ccs_tab, handler(self, self.OnBtnChangeClick)
	self.showViewType = nil
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClickCallBack))
	_ENV = handler(self, self.btnHelpClickCallBack)
	handler(self, self.btnHelpClickCallBack).tabNum = #self.tableData
	handler(self, self.btnHelpClickCallBack).defaultClick = 1
	handler(self, self.btnHelpClickCallBack).tabsetArray = self.tableData
	self.ccs_tab:initView(handler(self, self.btnHelpClickCallBack))
end
function remainsWarRankView:initShowBtn(showViewType)
	if self.showViewType == showViewType then
		return
	end
	self.showViewType = showViewType
	for i, v in ipairs(self.tableData) do
		local show = i == showViewType
		if show then
			if not v.panel then
				v.panel = self:createPanel(showViewType)
			end
			if v.panel then
				v.panel:setVisible(true)
			end
		elseif v.panel then
			v.panel:setVisible(false)
		end
	end
	self.btnHelp:setVisible(showViewType == RANK_VIEW_TYPE.RANK_VIEW_TYPE_SCORE)
end
function remainsWarRankView:createPanel(showViewType)
	local panel
	if showViewType == RANK_VIEW_TYPE.RANK_VIEW_TYPE_SCORE then
		panel = SoraDCreatePanelByFixName("remainsWarRankScoreView")
		panel:setPosition(SoraDFPoint(0, 765, 0))
		panel:addTo(self.nodeTop, -1)
		panel:init()
	elseif showViewType == RANK_VIEW_TYPE.RANK_VIEW_TYPE_HISTORY then
		panel = SoraDCreatePanelByFixName("remainsWarRankHistoryView")
		panel:setPosition(SoraDFPoint(0, 765, 0))
		panel:addTo(self.nodeTop, -2)
		panel:init()
	elseif showViewType == RANK_VIEW_TYPE.RANK_VIEW_TYPE_HISTORY_SEASON then
		panel = SoraDCreatePanelByFixName("remainsWarRankHistorySeasonView")
		panel:setPosition(SoraDFPoint(0, 765, 0))
		panel:addTo(self.nodeTop, -3)
		panel:init()
	elseif showViewType == RANK_VIEW_TYPE.RANK_VIEW_TYPE_TITLE then
		panel = SoraDCreatePanelByFixName("remainsWarRankTitleView")
		panel:setPosition(SoraDFPoint(0, 765, 0))
		panel:addTo(self.nodeTop, -4)
		panel:init()
	end
	return panel
end
function remainsWarRankView:OnBtnChangeClick(showViewType)
	self:initShowBtn(showViewType)
end
function remainsWarRankView:btnHelpClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("remains_text_173"))
	end
end
return remainsWarRankView
