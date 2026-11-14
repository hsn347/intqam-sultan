local kingdomGraceRead = include("kingdomGraceRead")
local kingdomGraceCtrl = SoraDGetCtrl("kingdomGraceCtrl")
local itemDesRead = include("itemDesRead")
local kGraceExchangePopView = class("kGraceExchangePopView", function(target)
	return target or SoraDCreateTouchPanel("kingGraceChangePop")
end)
function kGraceExchangePopView:ctor()
	self.textExplain = SoraDGetChildByName(self, "Text_Explain")
	self.textHavaPoints = SoraDGetChildByName(self, "Text_CurHave")
	self.textExchangeInfo = SoraDGetChildByName(self, "Text_Change")
	self.btnExchange = SoraDGetChildByName(self, "Button_yes")
	self.btnExchange:setTitleText(i18n("common_text_1889"))
	self.btnExchange:addTouchEventListener(handler(self, self.btnClickExchange))
	self.canExchangeCount = kingdomGraceCtrl:getCanExchangeCount()
	local group = kingdomGraceCtrl:getGroup()
	local awardId = kingdomGraceRead.getExchangeConfig(group, "awardItem")
	local exchangePoint = kingdomGraceRead.getExchangeConfig(group, "exchange")
	if gConstValue.IS_DEBUG_SERVER then
		exchangePoint = math.ceil(exchangePoint / 10)
	end
	local itemName = itemDesRead.getName(awardId)
	_ENV = handler(self, self.btnClickExchange)
	handler(self, self.btnClickExchange).point2 = self.canExchangeCount * exchangePoint
	handler(self, self.btnClickExchange).num = self.canExchangeCount
	_ENV, _ENV, handler(self, self.btnClickExchange).item = handler(self, self.btnClickExchange)
	_ENV, self.canExchangeCount.point2, handler(self, self.btnClickExchange).color = handler(self, self.btnClickExchange)
	_ENV, self.canExchangeCount.num, handler(self, self.btnClickExchange).color = handler(self, self.btnClickExchange)
	self.canExchangeCount.__default, handler(self, self.btnClickExchange).color = handler(self, self.btnClickExchange)
	local str = i18n_html("kingdom_grace_text_16", handler(self, self.btnClickExchange))
	_ENV = handler(self, self.btnClickExchange)
	handler(self, self.btnClickExchange).num1 = exchangePoint
	handler(self, self.btnClickExchange).num2 = 1
	self.textExplain:setString(i18n("kingdom_grace_text_07", handler(self, self.btnClickExchange)) .. i18n(itemName))
	_ENV = itemName
	itemName.num = kingdomGraceCtrl:getScore()
	self.textHavaPoints:setString(i18n("kingdom_grace_text_06", itemName))
	self.textExchangeInfo = SoraDChangeTextToHtml(self.textExchangeInfo)
	self.textExchangeInfo:setString(str)
end
function kGraceExchangePopView:btnClickExchange(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).count = self.canExchangeCount
		kingdomGraceCtrl:sendExcahngeMsg(nil)
		self:close(self, type)
	end
end
return kGraceExchangePopView
