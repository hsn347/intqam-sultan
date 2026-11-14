local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local publicRead = include("publicRead")
local armorSystemCtrl = SoraDGetCtrl("armorSystemCtrl")
local baseComponent = require("fgui.base.baseComponent")
local ExchangeSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BrilliantBrave/ExchangeSingle", ExchangeSingle)
function ExchangeSingle:onInit()
	self:fixChildrenPos()
	self.fields.n09:fix()
	self.exChangeStatus = 0
	self.fields.Button_exchange:setTitle(i18n("common_text_1889"))
	self.fields.Button_exchange:addClickListener(handler(self, self.btnExchangeClick))
end
function ExchangeSingle:onShow()
end
function ExchangeSingle:initData(data)
	self.data = data
	self.shopItemID = data.shopItemID
	self:setBtnToData(data.shopItem)
	self:setBtnFromData(data.exchangeItem)
	self:setLeftCount(data.limitNum, armorSystemCtrl:getCurExchangeNum(self.shopItemID))
	self:setBtnExchangeStatus()
end
function ExchangeSingle:setBtnToData(data)
	local itemID = data[1]
	local needNum = data[2]
	self.fields.toItemL:initData(itemID, needNum)
end
function ExchangeSingle:setBtnFromData(data)
	local itemID = data[1]
	local needNum = data[2]
	local ownNum = backpackCtrl:getItemCount(itemID)
	self.ownCount = ownNum
	if needNum > ownNum then
		self.exChangeStatus = 1
	else
		self.exChangeStatus = 0
	end
	self.fields.fromItemL:initData(itemID, ownNum, needNum)
end
function ExchangeSingle:setLeftCount(limitnum, curExchangeNum)
	self.leftCount = math.max(0, limitnum - curExchangeNum)
	if limitnum <= curExchangeNum then
		self.exChangeStatus = 2
	end
	_ENV = nil
	;(nil).num = string.formatnumberthousands(self.leftCount)
	_ENV, _ENV, (nil).maxnum = limitnum, string.formatnumberthousands(limitnum), string.formatnumberthousands(limitnum)
	_ENV, string.formatnumberthousands(limitnum).num, limitnum.color = limitnum, limitnum, self.leftCount > 0 and "#FFEBB9" or "#BE2828"
	string.formatnumberthousands(limitnum).__default, limitnum.color = limitnum, "#FFEBB9"
	self.fields.Text_leftCount:setString(i18n_html("alliance_prosperity_text_16", nil, (string.formatnumberthousands(limitnum))))
end
function ExchangeSingle:setBtnExchangeStatus()
	if self.exChangeStatus == 0 then
		self.fields.Button_exchange:setBright(true)
		self.fields.Button_exchange:setTitleColor(cc.c3b(255, 255, 255))
	elseif self.exChangeStatus == 1 then
		self.fields.Button_exchange:setBright(true)
		self.fields.Button_exchange:setTitleColor(cc.c3b(255, 0, 0))
	elseif self.exChangeStatus == 2 then
		self.fields.Button_exchange:setBright(false)
		self.fields.Button_exchange:setTitleColor(cc.c3b(115, 115, 115))
	end
end
function ExchangeSingle:btnExchangeClick()
	SoraDPlaySound()
	if self.exChangeStatus == 2 then
		SoraDShowMsgTip(i18n("common_text_1865"))
	elseif self.exChangeStatus == 1 then
		SoraDShowMsgTip(i18n("gemEnchant_text_48"))
	else
		uiManager:show("WarframeExchangePop", self.data)
	end
end
return ExchangeSingle
