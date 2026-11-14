local legendMDesRead = include("legendMDesRead")
local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local LegendMainPanel = class("LegendMainPanel", baseFguiPanel)
function LegendMainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("LegendMainPanel:ctor", self.viewName)
end
function LegendMainPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function LegendMainPanel:onInit()
	print("=======LegendMainPanel:onInit")
	self.curShow = 0
	self.fields.Com_title:initData(i18n("history_name_11"), handler(self, self.onClickBack))
	self.fields.com_Bg:setVisible(false)
	print("self:getHeight()", self:getHeight())
	self.fields.Usm_Book:setPrepareCallback(function()
		self.fields.Usm_Book:play(false)
		self = false
		;(false).frame = 27
		self.fields.Usm_Book:getCriSprite():addFrameEventData(false)
		self.fields.Usm_Book:getCriSprite():setFrameEventCallback(handler(self, self.onFinishAction))
	end)
	self:initMergeHistoryComboBox()
end
function LegendMainPanel:initMergeHistoryComboBox()
	self.myKingdomID = gametop.playertop_:getKingdomID()
	_ENV, self.curKid = self.myKingdomID, self.myKingdomID
	gametop, self.kingdomList, self.myKingdomID[1] = self.myKingdomID, self.myKingdomID, self.myKingdomID
	self.myKingdomID[1] = string.format("%s#%d", i18n("common_text_479"), self.myKingdomID)
	self.myKingdomID[2] = string.format("%s#%d", i18n("common_text_479"), self.myKingdomID)
	self.myKingdomID[3] = string.format("%s#%d", i18n("common_text_479"), self.myKingdomID)
	self.myKingdomID[4] = string.format("%s#%d", i18n("common_text_479"), self.myKingdomID)
	self.myKingdomID[5] = string.format("%s#%d", i18n("common_text_479"), self.myKingdomID)
	self.myKingdomID[6] = string.format("%s#%d", i18n("common_text_479"), self.myKingdomID)
	self.myKingdomID[7] = string.format("%s#%d", i18n("common_text_479"), self.myKingdomID)
	self.myKingdomID[8] = string.format("%s#%d", i18n("common_text_479"), self.myKingdomID)
	local self.myKingdomID[9], items = string.format("%s#%d", i18n("common_text_479"), self.myKingdomID)
	local mergeHistory = lordInfoCtrl:getMergeHistory()
	if mergeHistory and mergeHistory[1] and mergeHistory[1] ~= self.myKingdomID then
		table.insert(self.kingdomList, mergeHistory[1])
		table.insert(items, string.format("%s#%d", i18n("common_text_479"), mergeHistory[1]))
	end
	self.fields.ComboBox_sort:setTitle(i18n("CombineServers_24"))
	local legendMain = uiManager:getProxy("LegendMain").view
	gametop = i18n("CombineServers_24")
	i18n("CombineServers_24").items = items
	i18n("CombineServers_24").values = self.kingdomList
	i18n("CombineServers_24").selectedValue = self.myKingdomID
	i18n("CombineServers_24").changedCallback = handler(self, self.onChooseClick)
	legendMain:setComboBox(self.fields.ComboBox_sort, i18n("CombineServers_24"))
	local dropdown = self.fields.ComboBox_sort:getDropdown()
	self.comboBoxList = dropdown:getChildByName("list")
	self.fields.ComboBox_sort:setVisible(false)
	self.fields.ComboBox_sort:addClickListener(function()
		SoraDPlaySound()
		local index = 0
		for i, v in ipairs(self.kingdomList) do
			if v == self.curKid then
				index = i - 1
				break
			end
		end
		self.comboBoxList:setSelectedIndex(index)
	end)
end
function LegendMainPanel:onChooseClick()
	SoraDPlaySound()
	local curKid = tonumber(self.fields.ComboBox_sort:getValue())
	local curPage = self.fields[string.format("Page_%d", self.curShow)]:getComponent()
	if curPage and curPage.onChooseClick then
		curPage:onChooseClick(curKid)
	end
	self.curKid = curKid
	print("curKid = ", curKid)
	self.fields.ComboBox_sort:setTitle(i18n("CombineServers_24"))
end
function LegendMainPanel:onShow()
	print("=======LegendMainPanel:onShow")
	self.fields.Usm_Book:setScaleY(self.fields.com_Bg:getHeight() / 983)
end
_ENV, LegendMainPanel.onFinishAction = function(self, info)
	self.fields.com_Bg:setVisible(true)
	self.fields.Usm_Book:setVisible(false)
	self:loadNextPage(legendMDesRead.PageType.COVER)
end, function(self, info)
	self.fields.com_Bg:setVisible(true)
	self.fields.Usm_Book:setVisible(false)
	self:loadNextPage(legendMDesRead.PageType.COVER)
end
;(function(self, info)
	self.fields.com_Bg:setVisible(true)
	self.fields.Usm_Book:setVisible(false)
	self:loadNextPage(legendMDesRead.PageType.COVER)
end)[legendMDesRead.PageType.COVER] = "MainPageCover"
;(function(self, info)
	self.fields.com_Bg:setVisible(true)
	self.fields.Usm_Book:setVisible(false)
	self:loadNextPage(legendMDesRead.PageType.COVER)
end)[legendMDesRead.PageType.STORY] = "KingdomStory"
;(function(self, info)
	self.fields.com_Bg:setVisible(true)
	self.fields.Usm_Book:setVisible(false)
	self:loadNextPage(legendMDesRead.PageType.COVER)
end)[legendMDesRead.PageType.STORYDETAIL] = "KingdomStoryDetail"
;(function(self, info)
	self.fields.com_Bg:setVisible(true)
	self.fields.Usm_Book:setVisible(false)
	self:loadNextPage(legendMDesRead.PageType.COVER)
end)[legendMDesRead.PageType.KINGS] = "SultanLegends"
;(function(self, info)
	self.fields.com_Bg:setVisible(true)
	self.fields.Usm_Book:setVisible(false)
	self:loadNextPage(legendMDesRead.PageType.COVER)
end)[legendMDesRead.PageType.KINGDETAIL] = "SultanLegendsDetail"
;(function(self, info)
	self.fields.com_Bg:setVisible(true)
	self.fields.Usm_Book:setVisible(false)
	self:loadNextPage(legendMDesRead.PageType.COVER)
end)[legendMDesRead.PageType.KINGDOM_BATTLE] = "WarSummary"
;(function(self, info)
	self.fields.com_Bg:setVisible(true)
	self.fields.Usm_Book:setVisible(false)
	self:loadNextPage(legendMDesRead.PageType.COVER)
end)[legendMDesRead.PageType.SERVER_BATTLE] = "WarSummary"
;(function(self, info)
	self.fields.com_Bg:setVisible(true)
	self.fields.Usm_Book:setVisible(false)
	self:loadNextPage(legendMDesRead.PageType.COVER)
end)[legendMDesRead.PageType.SERVERROAD] = "ImperialRoad"
;(function(self, info)
	self.fields.com_Bg:setVisible(true)
	self.fields.Usm_Book:setVisible(false)
	self:loadNextPage(legendMDesRead.PageType.COVER)
end)[legendMDesRead.PageType.ALLIANCEROAD] = "ImperialRoad"
local _ENV, (function(self, info)
	self.fields.com_Bg:setVisible(true)
	self.fields.Usm_Book:setVisible(false)
	self:loadNextPage(legendMDesRead.PageType.COVER)
end)[legendMDesRead.PageType.MILESTONE], loadPageFuncMap = legendMDesRead.PageType.MILESTONE, "Milestone", function(self, info)
	self.fields.com_Bg:setVisible(true)
	self.fields.Usm_Book:setVisible(false)
	self:loadNextPage(legendMDesRead.PageType.COVER)
end
legendMDesRead.PageType.MILESTONE[legendMDesRead.PageType.KINGS] = true
legendMDesRead.PageType.MILESTONE[legendMDesRead.PageType.KINGDOM_BATTLE] = true
local legendMDesRead.PageType.MILESTONE[legendMDesRead.PageType.SERVER_BATTLE], chooseKindomsPageMap = true, legendMDesRead.PageType.MILESTONE
function LegendMainPanel:loadNextPage(pageType, pageData)
	if self.fields[string.format("Page_%d", self.curShow)] then
		self.fields[string.format("Page_%d", self.curShow)]:setVisible(false)
	end
	if not self.fields[string.format("Page_%d", self.curShow + 1)] then
		return
	end
	self.curKid = self.myKingdomID
	self.fields.ComboBox_sort:setValue(self.myKingdomID)
	self.fields.ComboBox_sort:setTitle(i18n("CombineServers_24"))
	self.fields[string.format("Page_%d", self.curShow + 1)]:setVisible(true)
	local curPage = self.fields[string.format("Page_%d", self.curShow + 1)]:getComponent()
	if not curPage or curPage.pageType ~= pageType then
		self.fields[string.format("Page_%d", self.curShow + 1)]:setURL(string.format("ui://ChronicleView/%s", loadPageFuncMap[pageType]))
		curPage = self.fields[string.format("Page_%d", self.curShow + 1)]:getComponent()
		curPage:setSize(self.fields.Page_1:getSize().width, self.fields.Page_1:getSize().height)
		curPage:setPageType(pageType)
	end
	if pageData then
		curPage:initData(pageData)
	end
	self.fields.Com_title:updateTitle(curPage:getTitle())
	self.curShow = self.curShow + 1
	self:updateComboBox()
	self:updateGreenBg()
end
function LegendMainPanel:updateGreenBg()
	local curPage = self.fields[string.format("Page_%d", self.curShow)]:getComponent()
	if curPage and (curPage.pageType == legendMDesRead.PageType.COVER or curPage.pageType == legendMDesRead.PageType.MILESTONE) then
		self.fields.com_Bg:getController("c1"):setSelectedIndex(0)
	else
		self.fields.com_Bg:getController("c1"):setSelectedIndex(1)
	end
end
function LegendMainPanel:onClickBack()
	SoraDPlaySound()
	if self.curShow <= 1 then
		self:close()
	else
		self.fields[string.format("Page_%d", self.curShow)]:setVisible(false)
		self.curShow = self.curShow - 1
		local curPage = self.fields[string.format("Page_%d", self.curShow)]
		curPage:setVisible(true)
		self:updateComboBox()
		self:updateGreenBg()
	end
end
function LegendMainPanel:updateComboBox()
	local curPage = self.fields[string.format("Page_%d", self.curShow)]:getComponent()
	local isShowComboBox = chooseKindomsPageMap[curPage.pageType] and #self.kingdomList > 1
	_UPVALUE3_ = self.curShow
	self.curShow[1] = self.curShow
	self.curShow[2] = isShowComboBox
	self.curShow[3] = curPage.pageType
	dump(self.curShow, "self.curShow")
	self.fields.ComboBox_sort:setVisible(isShowComboBox)
end
return LegendMainPanel
