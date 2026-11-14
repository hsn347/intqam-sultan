local gametop = gModuleMgr.getObject("gametop")
local allianceHuntCtrl = gametop.playertop_:getModule("allianceHuntCtrl")
local chatFunctions = include("chatFunctions")
local publicRead = include("publicRead")
local nodeHuntShopItem = class("nodeHuntShopItem", function(target)
	local isCreateUI = false
	if isCreateUI then
		local view = include("baseView")
		return view.new(cc.size(0, 0), false)
	else
		if target == nil then
			return SoraDCreateBasePanel("nodeHuntShopItem")
		end
		if type(target) == "string" then
			return SoraDCreateBasePanel(target)
		end
		return target
	end
end)
function nodeHuntShopItem:ctor()
	self:createUI()
	self.textLimit = SoraDGetChildByName(self, "text_limit")
	self.btnBuy = SoraDGetChildByName(self, "btn_buy")
	self.btnBuy:addTouchEventListener(handler(self, self.onClick_btnBuy))
	self.btnBuy:setSwallowTouches(false)
	self.textDes = SoraDGetChildByName(self, "text_des")
	self.iconBuy = SoraDGetChildByName(self, "icon_buy")
	local nodeItem = SoraDGetChildByName(self, "nodeItem")
	self.txtGold = SoraDGetChildByName(self, "text_gold")
	self.commonItemNode = include("commonItemAward").new(nodeItem)
end
function nodeHuntShopItem:createUI()
	local CCSUICreator = include("CCSUICreator")
end
function nodeHuntShopItem:initData(data)
	self.data = data
	local itemdata = self.data.itemdata
	local huntingPoint = allianceHuntCtrl:getHuntingPoint()
	self.commonItemNode:initData(itemdata.itemID[1], itemdata.itemID[2])
	local needNum = itemdata.changeID[2]
	if huntingPoint < needNum then
		self.txtGold:setString(needNum)
		self.txtGold:setTextColor(cc.c3b(255, 0, 0))
		self.btnBuy:setBright(false)
	else
		self.txtGold:setString(needNum)
		self.txtGold:setTextColor(cc.c3b(255, 255, 0))
		self.btnBuy:setBright(true)
	end
	local strName = publicRead.getName(itemdata.itemID[1])
	self.textDes:setString(strName)
	local total = itemdata.limitNum
	local shopData = allianceHuntCtrl:getShopData()
	local cur = shopData[tostring(itemdata.shopIndex)] or 0
	allianceHuntCtrl = cc.c3b(255, 255, 0)
	cc.c3b(255, 255, 0).cur = cur
	cc.c3b(255, 255, 0).total = total
	self.textLimit:setString(i18n("common_text_4417", cc.c3b(255, 255, 0)))
	if 0 < cur and cur == total then
		self.btnBuy:setBright(false)
	end
end
function nodeHuntShopItem:onMessageListener()
end
function nodeHuntShopItem:onClick_btnBuy(sender, event)
	if event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
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
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = sender:getTouchBeganPosition()
		local touchmovePoint = sender:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	elseif type == ccui.TouchEventType.began then
		self.singleIsMoved = false
	end
end
function nodeHuntShopItem:setHandle(handle)
	self.handle = handle
end
function nodeHuntShopItem:setScroll(scroll)
	self.scroll = scroll
	self.commonItemNode:setOwnScroll(scroll)
end
function nodeHuntShopItem:setView(view)
	self.commonItemNode:setOwnView(view)
end
function nodeHuntShopItem:setParentView(parentView)
	self.parentView = parentView
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
