local PhysicalBuyView = class("physicalBuyView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("physicalBuyView")
	end
	return target
end)
function PhysicalBuyView:ctor()
	self.itemScroll = include("itemBuyScroll").new()
	self.btnRes = SoraDGetChildByName(self, "Button_res")
	self.nodeTop = SoraDGetChildByName(self, "Top_Node")
	self.goldTop = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldTop_resBuy")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_List")
	self.windowTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_resourceBuyView")
	self.windowTitle:setTitle(i18n("common_text_028"))
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	self.btnRes:addTouchEventListener(handler(self, self.btnResClick))
	SoraDAddMessage(self, "MESSAGE_ITEM_UES_FROM_BAG_BACK", handler(self, self.update))
	SoraDAddMessage(self, "MESSAGE_MALL_SUCCESS", handler(self, self.update))
	SoraDAddMessage(self, "MESSAGE_MALL_BUY_SUCCESS", handler(self, self.update))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPDATE_BASE", handler(self, self.refreshRes))
	self:initData()
end
function PhysicalBuyView:initData()
	self.btnRes:setContentSize(cc.size(display.width, self.btnRes:getContentSize().height))
	self.btnRes:getChildByName("Text_res"):setPositionX(self.btnRes:getContentSize().width / 2 - 20)
	local spRes = cc.Sprite:createWithSpriteFrameName("icon_lord_sp.png")
	spRes:setPosition(display.width - 32, self.btnRes:getContentSize().height / 2)
	spRes:addTo(self.btnRes)
	self:btnResClick(self.curBtn, ccui.TouchEventType.ended, true)
	self.btnRes:setTouchEnabled(false)
	self:refreshRes()
end
function PhysicalBuyView:update()
	SoraDCloseLoading(self)
	self:refreshRes()
	self:btnResClick(self.curBtn, ccui.TouchEventType.ended, true)
end
function PhysicalBuyView:refreshRes()
	local gametop = gModuleMgr.getObject("gametop")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	self.tableLordInfo = lordInfoCtrl:getBaseInfo()
	self.btnRes:getChildByName("Text_res"):setString(self.tableLordInfo.physical .. "/" .. self.tableLordInfo.physicalUpper)
end
function PhysicalBuyView:buyOrUseCallBack(controlTbl)
	local buyItem = function(itemID)
		local itemInfo = gModuleMgr.sharedMgr("shopltCtrl"):getShopItemByItemID(itemID)
		if itemInfo then
			_ENV = nil
			;(nil).itemData = itemInfo
			;(nil).useAndBuy = true
			;(nil).needResList = self.needResCount
			uiManager:show("newShopSingleBuy", nil)
		else
			SoraDShowMsgTip(i18n("notice_0170"))
		end
	end
	if controlTbl.buy then
		if SoraDEnoughGold(controlTbl.needGold) then
			buyItem(controlTbl.itemID)
		end
	elseif controlTbl.use then
		include("itemLogic").useItemsLine(controlTbl.itemID, controlTbl.itemCount)
	end
end
function PhysicalBuyView:btnResClick(button, type, notSound)
	if type == ccui.TouchEventType.ended then
		if not notSound then
			SoraDPlaySound()
		end
		local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
		local resList = backpackltCtrl:getItemArray(gItemType.STAMINA)
		_ENV = backpackltCtrl
		backpackltCtrl.itemList = resList
		backpackltCtrl.itemCallBack = handler(self, self.buyOrUseCallBack)
		backpackltCtrl.itemStyle = "commonItemUseBar_02"
		local backpackltCtrl.itemSize, transTbl = cc.size(620, 170), backpackltCtrl
		self.itemScroll:setScroll(self.scroll)
		self.itemScroll:init(transTbl)
	end
end
return PhysicalBuyView
