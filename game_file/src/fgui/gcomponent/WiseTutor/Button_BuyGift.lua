local baseComponent = require("fgui.base.baseComponent")
local Button_BuyGift = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://WiseTutor/Button_BuyGift", Button_BuyGift)
function Button_BuyGift:onInit()
end
function Button_BuyGift:onShow()
end
function Button_BuyGift:initData(giftID, originPrice, Pirce)
	self.fields.Text_Orige:setString(paymentManager.judgePrice(giftID, originPrice))
	self.fields.Text_Price:setString(paymentManager.judgePrice(giftID, Pirce))
end
return Button_BuyGift
