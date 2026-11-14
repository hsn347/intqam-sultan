local baseComponent = require("fgui.base.baseComponent")
local nodeHuntShopItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceHuntView/nodeHuntShopItem", nodeHuntShopItem)
local gametop = gModuleMgr.getObject("gametop")
local allianceHuntCtrl = gametop.playertop_:getModule("allianceHuntCtrl")
local chatFunctions = include("chatFunctions")
local publicRead = include("publicRead")
function nodeHuntShopItem:onInit()
	self:fixChildrenPos(true)
	self.textLimit = SoraDGetChildByName(self, "text_limit")
	self.btnBuy = SoraDGetChildByName(self, "btn_buy")
	self.btnBuy:addClickEventListener(handler(self, self.onClick_btnBuy))
	self.textDes = SoraDGetChildByName(self, "text_des")
	self.iconBuy = SoraDGetChildByName(self, "icon_buy")
	local nodeItem = SoraDGetChildByName(self, "nodeItem")
	self.txtGold = SoraDGetChildByName(self, "text_gold")
	self.commonItemNode = nodeItem
end
function nodeHuntShopItem:onShow()
end
function nodeHuntShopItem:initData(data)
	self.data = data
	local itemdata = self.data.itemdata
	local huntingPoint = allianceHuntCtrl:getHuntingPoint()
	self.commonItemNode:initData(itemdata.itemID[1], itemdata.itemID[2])
	local needNum = itemdata.changeID[2]
	if huntingPoint < needNum then
		self.txtGold:setString(needNum)
		self.btnBuy:setBright(false)
	else
		self.txtGold:setString(needNum)
		self.btnBuy:setBright(true)
	end
	local strName = publicRead.getName(itemdata.itemID[1])
	self.textDes:setString(strName)
	local total = itemdata.limitNum
	local shopData = allianceHuntCtrl:getShopData()
	local cur = shopData[tostring(itemdata.shopIndex)] or 0
	allianceHuntCtrl = nil
	;(nil).cur = cur
	;(nil).total = total
	self.textLimit:setString(i18n("common_text_4417", nil))
	if 0 < cur and cur == total then
		self.btnBuy:setBright(false)
	end
end
function nodeHuntShopItem:onMessageListener()
end
function nodeHuntShopItem:onClick_btnBuy(sender, event)
	SoraDPlaySound()
	local huntingPoint = allianceHuntCtrl:getHuntingPoint()
	local itemdata = self.data.itemdata
	local needNum = itemdata.changeID[2]
	if huntingPoint < needNum then
		SoraDShowMsgTip(i18n("alliance_hunt_text_21"))
	else
		local total = itemdata.limitNum
		local shopData = allianceHuntCtrl:getShopData()
		local cur = shopData[tostring(itemdata.shopIndex)] or 0
		if 0 < cur and cur == total then
			SoraDShowMsgTip(i18n("exchange_text_02"))
			return
		end
		self:showBuyView()
	end
end
function nodeHuntShopItem:setHandle(handle)
	self.handle = handle
end
function nodeHuntShopItem:showBuyView()
	local itemdata = self.data.itemdata
	local needNum = itemdata.changeID[2]
	allianceHuntCtrl = nil
	local (nil).id, data = itemdata.itemID[1], nil
	local total = itemdata.limitNum
	local shopData = allianceHuntCtrl:getShopData()
	local cur = shopData[tostring(itemdata.shopIndex)] or 0
	local maxCount = total - cur
	local canBuyCount = math.floor(allianceHuntCtrl:getHuntingPoint() / needNum)
	maxCount = math.min(maxCount, canBuyCount)
	allianceHuntCtrl, allianceHuntCtrl, allianceHuntCtrl = nil, nil, nil
	;(nil).targetID = itemdata.itemID[1]
	;(nil).exchangeID = allianceHuntCtrl:getHuntingPointItemID()
	;(nil).singCount = needNum
	;(nil).curNum = maxCount
	;(nil).huntCount = itemdata.itemID[2]
	;(nil).exchangeData, (nil).singleGet = nil, itemdata.itemID[2]
	;(nil).exchangeCfg, (nil).exchangeHandler = nil, handler(self, self.sureBuy)
	uiManager:show("newShopSingleBuy", nil)
end
function nodeHuntShopItem:sureBuy(num)
	print("选择了数量:", num)
	allianceHuntCtrl:reqBuy(self.data.itemdata.shopIndex, num)
	if self.parentView then
		self.parentView:showLoading()
	end
end
return nodeHuntShopItem
