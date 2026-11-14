local allianceWarltCtrl = include("allianceWarltCtrl")
local pyramidwarShopCtrl = SoraDGetCtrl("pyramidwarShopCtrl")
local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local pyramidBattleStoreViewPanel = class("pyramidBattleStoreViewPanel", baseFguiPanel)
function pyramidBattleStoreViewPanel:ctor(...)
	pyramidBattleStoreViewPanel.super.ctor(self, ...)
	print("pyramidBattleStoreViewPanel:ctor", self.viewName)
end
function pyramidBattleStoreViewPanel:onInit()
	print("=======pyramidBattleStoreViewPanel:onInit")
	self.listData, _ENV, self.matchType = gSeasonType.REGULAR_SEASON, gSeasonType.REGULAR_SEASON, gSeasonType.REGULAR_SEASON
	self.fields.Com_title:initData(i18n("allianceWar_shop_title02"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Lab_ins:setString(i18n("allianceWar_shopPoint_desc"))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Btn_tip:addClickListener(handler(self, self.btnTipClick))
	self.fields.Btn_tip:fixPos()
	self.fields.Lab_item:fixChildrenPos()
	self.fields.Lab_item:fixPos()
	self.fields.Text_reset:fixPos()
end
function pyramidBattleStoreViewPanel:onItemRenderer(index, obj)
	obj:initData(self.listData[index + 1], self.matchType, self)
end
function pyramidBattleStoreViewPanel:onShow()
	print("=======pyramidBattleStoreViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.matchType, self.matchType
	;(nil).title = i18n("allianceWar_regularSeason_title")
	_ENV, self.matchType[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("allianceWar_peakSeason_title")
	;(nil).tabsetArray, self.matchType[2], (nil).tag = self.matchType, nil, 2
	;(nil).callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView(nil)
	local remainTime = pyramidwarShopCtrl:getRemainTime()
	self.fields.Text_reset:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("allianceWar_point_reset_name", nil)
	end)
	if 0 < remainTime then
		self.fields.Text_reset:beginTime(remainTime)
	end
	self.fields.Text_reset:setVisible(0 < remainTime)
end
function pyramidBattleStoreViewPanel:onClickTab(tag)
	self.matchType = tag
	if self.matchType == gSeasonType.REGULAR_SEASON then
		self.fields.Text_diff:setString(i18n("allianceWar_regularSeason_desc"))
		self.fields.Lab_item:setIcon("icon_regularSeason_point.png")
	else
		self.fields.Text_diff:setString(i18n("allianceWar_peakSeason_desc"))
		self.fields.Lab_item:setIcon("icon_peakSeason_point.png")
	end
	self:updateRed()
	self:updateView()
	self.fields.List:jumpToTop()
end
function pyramidBattleStoreViewPanel:updateRed()
	local redShow, num, regularNum, peakNum = pyramidwarShopCtrl:getReceiveStatusAndNum(gActivityCenterUIEnum.PYRAMID_BATTLE)
	self.fields.Com_tab:setBtnRedDot(1, 0 < regularNum, regularNum)
	self.fields.Com_tab:setBtnRedDot(2, 0 < peakNum, peakNum)
end
function pyramidBattleStoreViewPanel:updateView()
	SoraDCloseLoading(self)
	local commonScore = self.matchType == gSeasonType.REGULAR_SEASON and pyramidwarShopCtrl:getRegularScore() or pyramidwarShopCtrl:getPeakScore()
	self.fields.Lab_item:setTitle(commonScore)
	self.listData = allianceWarltCtrl.getShopItemInfo(self.matchType)
	self.fields.List:setNumItems(#self.listData)
end
function pyramidBattleStoreViewPanel:exchangeRefresh()
	SoraDCloseLoading(self)
	SoraDShowMsgTip(i18n("allianceWar_exchange_success_tips"))
	self:updateView()
end
function pyramidBattleStoreViewPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).matchType = self.matchType
	uiManager:show("pyramidBattleScorePopView", nil)
end
function pyramidBattleStoreViewPanel:btnTipClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).matchType = self.matchType
	uiManager:show("pyramidBattleTipPopView", nil)
end
return pyramidBattleStoreViewPanel
