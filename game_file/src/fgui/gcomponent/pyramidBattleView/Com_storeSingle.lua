local pyramidwarShopCtrl = SoraDGetCtrl("pyramidwarShopCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_storeSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://pyramidBattleView/Com_storeSingle", Com_storeSingle)
function Com_storeSingle:onInit()
	self.fields.Text_tick:setString(i18n("exchange_btn_01"))
	self.fields.Check_tick:addClickListener(handler(self, self.btnTickClick))
	self.fields.Button_exchange:addClickListener(handler(self, self.btnExchangeClick))
	self:fixChildrenPos()
end
function Com_storeSingle:onShow()
end
function Com_storeSingle:initData(data, matchType, parent)
	self.data = data
	self.matchType = matchType
	self.parent = parent
	self.isNotice = pyramidwarShopCtrl:getNoticeByShopId(self.data.shopId)
	self.fields.Check_tick:setSelected(self.isNotice)
	local alreadyExchangeTimes = pyramidwarShopCtrl:getExchangedTimes(self.matchType, self.data.shopId)
	self.remainTimes = self.data.limit - alreadyExchangeTimes
	pyramidwarShopCtrl = nil
	;(nil).left = self.remainTimes
	;(nil).total = self.data.limit
	self.fields.Text_limit:setString(i18n("pray_text_13", nil))
	self.fields.item:initData(self.data.item[1], self.data.item[2])
	self.commonScore = self.matchType == gSeasonType.REGULAR_SEASON and pyramidwarShopCtrl:getRegularScore() or pyramidwarShopCtrl:getPeakScore()
	self.fields.Button_exchange:setIcon(self.matchType == gSeasonType.REGULAR_SEASON and "icon_regularSeason_point.png" or "icon_peakSeason_point.png")
	self.fields.Button_exchange:setPrice(self.data.point)
	self.fields.Button_exchange:setTitleColor(self.commonScore >= self.data.point and cc.c3b(255, 251, 213) or cc.c3b(190, 40, 40))
	self.fields.Button_exchange:setReddot(self.isNotice and self.commonScore >= self.data.point and self.remainTimes > 0, 0)
end
function Com_storeSingle:btnTickClick()
	SoraDPlaySound()
	self.isNotice = not self.isNotice
	pyramidwarShopCtrl:reqSetNotice(self.data.shopId, self.isNotice and 1 or 0)
	SoraDShowLoading(self.parent)
end
function Com_storeSingle:btnExchangeClick()
	SoraDPlaySound()
	if self.commonScore < self.data.point then
		SoraDShowMsgTip(i18n("tips_exchange_point_noEnough"))
		return
	end
	if self.remainTimes <= 0 then
		SoraDShowMsgTip(i18n("tips_exchange_num_limit"))
		return
	end
	local costID = self.matchType == gSeasonType.REGULAR_SEASON and gIDDef.PYRAMID_REGULAR_SCORE or gIDDef.PYRAMID_PEAK_SCORE
	local singleCost = self.data.point
	local totalyLimit = math.min(math.floor(self.commonScore / singleCost), self.remainTimes)
	_ENV, _ENV, _ENV = i18n("tips_exchange_num_limit")
	i18n("tips_exchange_num_limit").targetID = self.data.item[1]
	i18n("tips_exchange_num_limit").exchangeID = costID
	i18n("tips_exchange_num_limit").singCount = singleCost
	i18n("tips_exchange_num_limit").curNum = totalyLimit
	i18n("tips_exchange_num_limit").exchangeData, i18n("tips_exchange_num_limit").singleGet = i18n("tips_exchange_num_limit")
	i18n("tips_exchange_num_limit").exchangeCfg, i18n("tips_exchange_num_limit").exchangeHandler = i18n("tips_exchange_num_limit")
	uiManager:show("newShopSingleBuy", i18n("tips_exchange_num_limit"))
end
return Com_storeSingle
