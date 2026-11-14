local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local ComTradeMyItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ManorFarm/ComTradeMyItem", ComTradeMyItem)
function ComTradeMyItem:onInit()
	self.fields.btnBuy:setTitle(i18n("farmland_text_84"))
	self.fields.btnBuy:addClickListener(handler(self, self.onClick_btnBuy))
	self.fields.btnDetail:addClickListener(handler(self, self.onClick_btnDetail))
end
function ComTradeMyItem:onShow()
end
function ComTradeMyItem:onClick_btnBuy(context)
	SoraDPlaySound()
	manorCityCtrl:reqMarketOffSale(self.data.itemId)
	local proxy = uiManager:getProxy("FarmTrade")
	SoraDShowLoading(proxy.view, nil, gCmd.REQ_GARDEN_FARMLAND_MARKET_OFF_SALE, nil, 15)
end
function ComTradeMyItem:onClick_btnDetail(context)
	SoraDPlaySound()
	local proxy = uiManager:getProxy("FarmTrade")
	proxy:showHistoryPrice(context.sender, self.data)
end
function ComTradeMyItem:initData(data, create_timer)
	self.data = data
	self.fields.txtNum:setString(tostring(data.n))
	self.fields.txtPrice:setString(tostring(data.price))
	self.fields.comItem:initData(tonumber(data.itemId))
	if CONST_VALUE.FARMLAND_EXCHANGE_LIST_TIME > serviceFunctions.systemTime() - data.t then
		self.controllers.canTakeDown:setSelectedIndex(1)
		if create_timer then
			if self.timer then
				self.timer:endTime()
				self.timer = nil
			end
			local leftTime = CONST_VALUE.FARMLAND_EXCHANGE_LIST_TIME - (serviceFunctions.systemTime() - data.t)
			self.timer = SoraDCreateTimerLabel(self, self.fields.txtTimer)
			self.timer:beginTime(leftTime)
			_ENV = tonumber(data.itemId)
			tonumber(data.itemId).time = SoraDConvertSecondToString(leftTime)
			self.timer:setString(i18n("farmland_text_63", tonumber(data.itemId)))
			self.timer:setTimeUpdateListener(function(time)
				self = nil
				;(nil).time = SoraDConvertSecondToString(time)
				self.timer:setString(i18n("farmland_text_63", nil))
			end)
			self.timer:setTimeEndListener(function()
				self:initData(self.data, false)
			end)
		end
	else
		self.controllers.canTakeDown:setSelectedIndex(0)
	end
end
return ComTradeMyItem
