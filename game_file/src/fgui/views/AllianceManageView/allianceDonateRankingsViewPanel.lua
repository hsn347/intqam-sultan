local allianceRank = SoraDGetCtrl("allianceRank")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceDonateRankingsViewPanel = class("allianceDonateRankingsViewPanel", baseFguiPanel)
function allianceDonateRankingsViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("allianceDonateRankingsViewPanel:ctor", self.viewName)
end
function allianceDonateRankingsViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceDonateRankingsViewPanel:onInit()
	print("=======allianceDonateRankingsViewPanel:onInit")
	self.tableRankData, _ENV, self.curType = gARankType.DAY, gARankType.DAY, gARankType.DAY
	self.ownRank = 0
	self.fields.Com_title:initData(i18n("common_text_239"), handler(self, self.onClickClose))
	self.fields.Text_rank:setString(i18n("common_text_2193"))
	self.fields.Text_name:setString(i18n("common_text_264"))
	self.fields.Text_donation:setString(i18n("common_text_265"))
	self.fields.Text_honor:setString(i18n("common_text_266"))
	self.fields.Button_info:addClickListener(handler(self, self.btnInfoClickCallBack))
	self.fields.Text_myRank:setTouchEnabled(true)
	self.fields.Text_myRank:addClickListener(handler(self, self.btnJumpClickCallBack))
	self.fields.Text_myRankHis:setTouchEnabled(true)
	self.fields.Text_myRankHis:addClickListener(handler(self, self.btnJumpClickCallBack))
	self.fields.List:setItemRenderer(handler(self, self.onRankRenderer))
	self.fields.Text_refreshTime = SoraDCreateTimerLabel(self, self.fields.Text_refreshTime)
	self.fields.Text_refreshTime:setTimeUpdateListener(function(time)
		if time <= 0 then
			allianceRank:reqDonateRank()
		else
			allianceRank = nil
			;(nil).gold = SoraDConvertSecondToString(time)
			self.fields.Text_refreshTime:setString(i18n("common_text_434", nil))
		end
	end)
	self.fields.Text_myRank:fixPos()
	self.fields.Button_info:fixPos()
	self.fields.Text_rank:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Text_donation:fixPos()
	self.fields.Text_honor:fixPos()
end
function allianceDonateRankingsViewPanel:onRankRenderer(index, obj)
	obj:initData(self.tableRankData[self.curType][index + 1], index + 1, self.curType)
end
function allianceDonateRankingsViewPanel:onShow()
	print("=======allianceDonateRankingsViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	allianceRank:reqDonateRank()
end
function allianceDonateRankingsViewPanel:onClickTab(tag)
	self.curType = tag
	self.controllers.c1:setSelectedIndex(self.curType - 1)
	for k, v in ipairs(self.tableRankData[self.curType]) do
		if v:getProperty("uid") == lordInfoCtrl:getLordInfo().base.uid then
			self.ownRank = k
			break
		end
	end
	_ENV = nil
	;(nil).rank = self.ownRank > 0 and self.ownRank or i18n("common_text_827")
	self.fields.Text_myRank:setString(i18n("common_text_825", nil))
	_ENV = i18n("common_text_825", nil)
	i18n("common_text_825", nil).rank = self.ownRank > 0 and self.ownRank or i18n("common_text_827")
	self.fields.Text_myRankHis:setString(i18n("common_text_825", i18n("common_text_825", nil)))
	if self.curType ~= gARankType.HISTORY then
		local leftTime = 0
		if self.curType == gARankType.WEEK then
			leftTime = allianceRank:getWeekRankLeftTime()
		elseif self.curType == gARankType.DAY then
			leftTime = allianceRank:getDayRankLeftTime()
		end
		self.fields.Text_refreshTime:beginTime(leftTime)
	end
	self.fields.List:setNumItems(#self.tableRankData[self.curType])
	self.fields.List:jumpToTop()
end
function allianceDonateRankingsViewPanel:updateData(target, data)
	self.tableRankData[gARankType.DAY] = allianceRank:getDonateRank(gARankType.DAY)
	self.tableRankData[gARankType.WEEK] = allianceRank:getDonateRank(gARankType.WEEK)
	self.tableRankData[gARankType.HISTORY] = allianceRank:getDonateRank(gARankType.HISTORY)
	_ENV = allianceRank:getDonateRank(gARankType.HISTORY)
	_ENV, _ENV, allianceRank:getDonateRank(gARankType.HISTORY).defaultClick = gARankType.HISTORY, self.curType, self.curType
	gARankType.HISTORY.title = i18n("common_text_260")
	_ENV, self.curType[1], gARankType.HISTORY.tag = gARankType.HISTORY, gARankType.HISTORY, 1
	gARankType.HISTORY.title = i18n("common_text_261")
	_ENV, self.curType[2], gARankType.HISTORY.tag = gARankType.HISTORY, gARankType.HISTORY, 2
	gARankType.HISTORY.title = i18n("common_text_262")
	allianceRank:getDonateRank(gARankType.HISTORY).tabsetArray, self.curType[3], gARankType.HISTORY.tag = self.curType, gARankType.HISTORY, 3
	allianceRank:getDonateRank(gARankType.HISTORY).callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView((allianceRank:getDonateRank(gARankType.HISTORY)))
end
function allianceDonateRankingsViewPanel:btnInfoClickCallBack()
	SoraDPlaySound()
	SoraDShowMsgBox(i18n("common_text_1676"), i18n("common_text_054"))
end
function allianceDonateRankingsViewPanel:btnJumpClickCallBack()
	SoraDPlaySound()
	if self.ownRank > 0 then
		self.fields.List:scrollToView(self.ownRank, true)
	end
end
return allianceDonateRankingsViewPanel
