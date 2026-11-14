local wrathBeastCtrl = SoraDGetCtrl("wrathBeastCtrl")
local shopSingleBuy = include("shopSingleBuy")
local worldMapWrathBeastBuy = class("worldMapWrathBeastBuy", shopSingleBuy)
function worldMapWrathBeastBuy:ctor()
	worldMapWrathBeastBuy.super.ctor(self)
	self.item:setVisible(false)
	self.labelDes:setAnchorPoint(cc.p(0.5, 1.0))
	self.labelDes:setPositionX(320)
	self.labelDes:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	self:initData()
end
function worldMapWrathBeastBuy:initData()
	self.tableItem, wrathBeastCtrl = nil, nil
	self.atkConfig = wrathBeastCtrl:getAtkTimesConfig()
	self.buyTimes = wrathBeastCtrl:getActivityData("buyTimes")
	local leftTimes = #self.atkConfig - self.buyTimes
	self.labelName:setString(i18n("god_beast_text_28"))
	wrathBeastCtrl = i18n("god_beast_text_28")
	i18n("god_beast_text_28").left = leftTimes
	i18n("god_beast_text_28").total = #self.atkConfig
	self.labelDes:setString(string.format([[
%s
%s]], i18n("god_beast_text_29"), i18n("god_beast_text_30", i18n("god_beast_text_28"))))
	self.curValue = 1
	wrathBeastCtrl = string.format([[
%s
%s]], i18n("god_beast_text_29"), i18n("god_beast_text_30", i18n("god_beast_text_28")))
	string.format([[
%s
%s]], i18n("god_beast_text_29"), i18n("god_beast_text_30", i18n("god_beast_text_28"))).maxValue = leftTimes
	string.format([[
%s
%s]], i18n("god_beast_text_29"), i18n("god_beast_text_30", i18n("god_beast_text_28"))).minValue = 1
	string.format([[
%s
%s]], i18n("god_beast_text_29"), i18n("god_beast_text_30", i18n("god_beast_text_28"))).curValue = self.curValue or 1
	self.bagShopSlider:initData(string.format([[
%s
%s]], i18n("god_beast_text_29"), i18n("god_beast_text_30", i18n("god_beast_text_28"))))
	self:payGoldChange(self.curValue or 1)
	self.bagShopSlider:setSliderCallBack(handler(self, self.payGoldChange))
	self:setBuyHandle(handler(self, self.onClick_btnBuy))
end
function worldMapWrathBeastBuy:getTotalPrice(needBuy)
	local totalPrice = 0
	local beginIndex = self.buyTimes + 1
	local endIndex = beginIndex + needBuy - 1
	for i = beginIndex, endIndex do
		local cost = self.atkConfig[i] or self.atkConfig[#self.atkConfig] or 0
		totalPrice = totalPrice + cost
	end
	return totalPrice
end
function worldMapWrathBeastBuy:onClick_btnBuy(needBuy)
	if SoraDEnoughGold(self:getTotalPrice(needBuy)) then
		wrathBeastCtrl:sendReqBuyAtkTimesMsg(needBuy)
	end
end
return worldMapWrathBeastBuy
