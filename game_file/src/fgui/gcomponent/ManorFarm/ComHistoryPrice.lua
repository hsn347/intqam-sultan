local baseComponent = require("fgui.base.baseComponent")
local ComHistoryPrice = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ManorFarm/ComHistoryPrice", ComHistoryPrice)
function ComHistoryPrice:onInit()
	self.fields.btnHide:addClickListener(handler(self, self.onClick_btnHide))
end
function ComHistoryPrice:onShow()
end
function ComHistoryPrice:onClick_btnHide(...)
	local proxy = uiManager:getProxy("FarmTrade")
	if proxy then
		proxy:hideHistoryPrice()
	end
end
function ComHistoryPrice:initData(priceData)
	self.fields.txtLastPrice:setString(i18n("farmland_text_60") .. priceData.lastPrice)
	self.fields.txtHighPrice:setString(i18n("farmland_text_61") .. priceData.maxPrice.price)
	self.fields.txtLowPrice:setString(i18n("farmland_text_62") .. priceData.minPrice.price)
end
return ComHistoryPrice
