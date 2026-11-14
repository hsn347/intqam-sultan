local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_tradeSelfSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://marketView/Com_tradeSelfSingle", Com_tradeSelfSingle)
function Com_tradeSelfSingle:onInit()
	self.fields.Text_price1:setString(i18n("auction_text_34"))
	self.fields.Text_time1:setString(i18n("petra_title_09"))
	self.fields.Text_fail:setString(i18n("auction_text_27"))
	self.fields.Text_fail2:setString(i18n("auction_text_36"))
	self:fixChildrenPos()
end
function Com_tradeSelfSingle:onShow()
end
function Com_tradeSelfSingle:initData(data)
	self.fields.item:initData(data.itemID, data.itemCount)
	self.fields.Text_name:setString(publicRead.getName(data.itemID))
	local isAuctionFail = data.isAuctionFail or false
	if isAuctionFail then
		self.controllers.c1:setSelectedIndex(1)
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Image_gold:setSpriteFrame(publicRead.getIcon(data.costid))
		self.fields.Text_price2:setString(string.formatnumberthousands(data.costnum))
		self.fields.Text_time2:setString(os.date("!%Y.%m.%d %H:%M:%S", data.time))
	end
end
return Com_tradeSelfSingle
