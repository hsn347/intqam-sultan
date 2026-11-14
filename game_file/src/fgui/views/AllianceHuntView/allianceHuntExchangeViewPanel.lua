local gametop = gModuleMgr.getObject("gametop")
local allianceHuntCtrl = gametop.playertop_:getModule("allianceHuntCtrl")
local allianceHuntDesRead = include("allianceHuntDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceHuntExchangeViewPanel = class("allianceHuntExchangeViewPanel", baseFguiPanel)
function allianceHuntExchangeViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("allianceHuntExchangeViewPanel:ctor", self.viewName)
end
function allianceHuntExchangeViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceHuntExchangeViewPanel:onInit()
	print("=======allianceHuntExchangeViewPanel:onInit")
	self.txtTitle = SoraDGetChildByName(self, "Text_title")
	self.btnCoin = SoraDGetChildByName(self, "Button_coin")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.textGold = SoraDGetChildByName(self, "text_gold")
	self.txtCoinNum = SoraDGetChildByName(self, "Button_coin")
	self.scroll = self.fields.scroll
	self.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Com_title:initData(i18n("alliance_hunt_btn_01"), handler(self, self.onClickClose))
	self.txtTitle:setString(i18n("common_text_4416"))
	self:init()
end
function allianceHuntExchangeViewPanel:onShow()
	print("=======allianceHuntExchangeViewPanel:onShow")
end
function allianceHuntExchangeViewPanel:init(data)
	local huntData = allianceHuntCtrl:getHuntData()
	local shopdata = huntData.shopdata
	dump(shopdata, "狩猎商店数据", 10)
	local huntingPoint = allianceHuntCtrl:getHuntingPoint()
	print("玩家当前的狩猎点数:", huntingPoint)
	self.txtCoinNum:setTitle(string.formatnumberthousands(huntingPoint))
	self.itemList, allianceHuntCtrl = self.txtCoinNum.setTitle, self.txtCoinNum.setTitle
	local exchangeList = allianceHuntDesRead.getExchangeList()
	for i, v in ipairs(exchangeList) do
		allianceHuntCtrl = string.formatnumberthousands(huntingPoint)
		string.formatnumberthousands(huntingPoint).itemdata = exchangeList[i]
		table.insert(self.itemList, string.formatnumberthousands(huntingPoint))
	end
	dump(self.itemList, "self.itemList", 10)
	local shopData = allianceHuntCtrl:getShopData()
	table.sort(self.itemList, function(item1, item2)
		item1 = item1.itemdata
		item2 = item2.itemdata
		local total1 = item1.limitNum
		local cur1 = shopData[tostring(item1.shopIndex)] or 0
		local total2 = item2.limitNum
		local cur2 = shopData[tostring(item2.shopIndex)] or 0
		local isItem1Limited = total1 <= cur1 and true or false
		local isItem2Limited = total2 <= cur2 and true or false
		if isItem1Limited == isItem2Limited then
			return item1.shopIndex < item2.shopIndex
		elseif isItem1Limited == false then
			return true
		end
		return false
	end)
	self.scroll:setNumItems(#self.itemList)
	print("刷新scroll-----")
end
function allianceHuntExchangeViewPanel:onItemRenderer(index, single)
	local data = self.itemList[index + 1]
	single:initData(data)
end
function allianceHuntExchangeViewPanel:onClick_btnCoin(sender, event)
	SoraDPlaySound()
end
function allianceHuntExchangeViewPanel:onClick_btnHelp(sender, event)
	SoraDPlaySound()
end
function allianceHuntExchangeViewPanel:sMsgBuySuccess(target, data)
	self:init()
	self:closeLoading()
end
function allianceHuntExchangeViewPanel:sMsgBuyFailed(target, data)
	self:closeLoading()
end
function allianceHuntExchangeViewPanel:showLoading()
	SoraDShowLoading(self, nil, nil, true)
end
function allianceHuntExchangeViewPanel:closeLoading()
	SoraDCloseLoading(self)
end
return allianceHuntExchangeViewPanel
