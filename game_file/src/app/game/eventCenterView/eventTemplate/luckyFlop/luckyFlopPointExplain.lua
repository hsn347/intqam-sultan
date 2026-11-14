local luckyFlopCtrl = SoraDGetCtrl("luckyFlopCtrl")
local luckyFlopRead = include("luckyFlopRead")
local luckyFlopPointExplain = class("luckyFlopPointExplain", function(target)
	return target or SoraDCreateTouchPanel("luckyFlopPointExplain")
end)
function luckyFlopPointExplain:ctor()
	self.popBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox")
	self.popBox:setTitleName(i18n("luckyFlip_title_10"))
	self.singleNode = SoraDGetChildByName(self, "Node_Single")
	self.scroll = SoraDGetChildByName(self, "ScrollView")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.scroll:setSingleRefresh(handler(self, self.refreshSingle))
	self.textPoint = SoraDGetChildByName(self, "text_point")
	self.textCoin = SoraDGetChildByName(self, "text_coin")
	self.textPoint:setString(i18n("luckyFlip_title_12"))
	self.textCoin:setString(i18n("luckyFlip_title_11"))
	local itemList = luckyFlopRead.getGiftConfig()
	self.scroll:updateScrollView(cc.size(522, 40), itemList, 1)
end
function luckyFlopPointExplain:createSingle()
	local single = self.singleNode:clone()
	return single
end
function luckyFlopPointExplain:refreshSingle(parent, data)
	local bg = SoraDGetChildByName(parent, "Image_bg")
	bg:setVisible(parent:getTag() % 2 ~= 0)
	local textCoin = SoraDGetChildByName(parent, "Text_Coin")
	local textPoint = SoraDGetChildByName(parent, "Text_Point")
	local strPrice = paymentManager.judgePrice(nil, data.price)
	textCoin:setString(strPrice)
	textPoint:setString(string.formatnumberthousands(data.points))
end
function luckyFlopPointExplain:createSingleLabel()
	local single = ccui.Text:create("", "", 22)
	return single
end
return luckyFlopPointExplain
