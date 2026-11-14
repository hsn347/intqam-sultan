local radianceWarIntegralView = class("radianceWarIntegralView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("radianceWarIntegralView")
	end
	return target
end)
_ENV = "radianceWarIntegralView"
;("radianceWarIntegralView").RANK_VIEW_TYPE_PERSONAL = 1
;("radianceWarIntegralView").RANK_VIEW_TYPE_ALLIANCE = 2
local ("radianceWarIntegralView").RANK_VIEW_TYPE_PALACE, RANK_VIEW_TYPE = 3, "radianceWarIntegralView"
function radianceWarIntegralView:ctor(properties)
	self.isHideCurrentSceneView = true
	self.nodeCommonFramTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle")
	self.nodeCommonFramTitle:setTitle(i18n("brightWar_title_13"))
	_ENV, _ENV, self.nodeCommonTabBtn = self, SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn"), SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn")
	self.title = i18n("common_text_1152")
	self.handle = handler(self, self.btnTabClick)
	_ENV, SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn")[1], self.tag = self, self, RANK_VIEW_TYPE.RANK_VIEW_TYPE_PERSONAL
	self.title = i18n("brightWar_text_191")
	self.handle = handler(self, self.btnTabClick)
	_ENV, SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn")[2], self.tag = self, self, RANK_VIEW_TYPE.RANK_VIEW_TYPE_ALLIANCE
	self.title = i18n("brightWar_title_08")
	self.handle = handler(self, self.btnTabClick)
	self.tableData, SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn")[3], self.tag = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn"), self, RANK_VIEW_TYPE.RANK_VIEW_TYPE_PALACE
	_ENV = RANK_VIEW_TYPE.RANK_VIEW_TYPE_PALACE
	RANK_VIEW_TYPE.RANK_VIEW_TYPE_PALACE.tabNum = #self.tableData
	RANK_VIEW_TYPE.RANK_VIEW_TYPE_PALACE.defaultClick = 1
	RANK_VIEW_TYPE.RANK_VIEW_TYPE_PALACE.tabsetArray = self.tableData
	self.nodeCommonTabBtn:initView(RANK_VIEW_TYPE.RANK_VIEW_TYPE_PALACE)
end
function radianceWarIntegralView:onMessageListener()
end
function radianceWarIntegralView:btnTabClick(showViewType)
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
end
function radianceWarIntegralView:createPanel(showViewType)
	local panel
	if showViewType == RANK_VIEW_TYPE.RANK_VIEW_TYPE_PERSONAL then
		panel = SoraDCreatePanelByFixName("radianceWarIntegralPersonalView")
	elseif showViewType == RANK_VIEW_TYPE.RANK_VIEW_TYPE_ALLIANCE then
		panel = SoraDCreatePanelByFixName("radianceWarIntegralAllianceView")
	elseif showViewType == RANK_VIEW_TYPE.RANK_VIEW_TYPE_PALACE then
		panel = SoraDCreatePanelByFixName("radianceWarIntegralPalaceView")
	end
	panel:setPosition(cc.p(0, 0))
	panel:addTo(self, 10)
	return panel
end
function radianceWarIntegralView:serverMessageGetLordInfo(target, data)
	SoraDCloseLoading(self)
	if data and data.lord then
		SoraDOpenLordView(data.lord)
	end
end
function radianceWarIntegralView:jumpToRank(rankType, subRankType)
	self.nodeCommonTabBtn:clickByTag(rankType)
	local childRankView = self.tableData[rankType].panel
	if subRankType and childRankView and childRankView.nodeCommonTabBtnEX then
		childRankView.nodeCommonTabBtnEX:clickByTag(subRankType)
	end
end
return radianceWarIntegralView
