local ExpBuyView = class("expBuyView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("expBuyView")
	end
	return target
end)
function ExpBuyView:ctor()
	self.itemScroll = include("itemBuyScroll").new()
	self.btnRes = SoraDGetChildByName(self, "Button_res")
	self.nodeTop = SoraDGetChildByName(self, "Top_Node")
	self.goldTop = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldTop_resBuy")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_List")
	self.windowTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_resourceBuyView")
	self.windowTitle:setTitle(i18n("common_text_029"))
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	self.btnRes:addTouchEventListener(handler(self, self.btnResClick))
	SoraDAddMessage(self, "MESSAGE_ITEM_UES_FROM_BAG_BACK", handler(self, self.update))
	SoraDAddMessage(self, "MESSAGE_MALL_SUCCESS", handler(self, self.update))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPDATE_BASE", handler(self, self.refreshRes))
	self:initData()
end
function ExpBuyView:initData()
	self.btnRes:setContentSize(cc.size(display.width, self.btnRes:getContentSize().height))
	self.btnRes:getChildByName("Text_res"):setPositionX(self.btnRes:getContentSize().width / 2 - 20)
	local spRes = cc.Sprite:createWithSpriteFrameName("icon_lord_exp.png")
	spRes:setPosition(display.width - 32, self.btnRes:getContentSize().height / 2)
	spRes:addTo(self.btnRes)
	self:btnResClick(self.curBtn, ccui.TouchEventType.ended, true)
	self.btnRes:setTouchEnabled(false)
	self:refreshRes()
end
function ExpBuyView:update()
	SoraDCloseLoading(self)
	self:btnResClick(self.curBtn, ccui.TouchEventType.ended, true)
end
function ExpBuyView:refreshRes()
	local gametop = gModuleMgr.getObject("gametop")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	self.tableLordInfo = lordInfoCtrl:getBaseInfo()
	if self.tableLordInfo.isReachFullExp then
		self.btnRes:getChildByName("Text_res"):setString("MAX")
	else
		self.btnRes:getChildByName("Text_res"):setString(self.tableLordInfo.exp .. "/" .. self.tableLordInfo.expUpper)
	end
end
function ExpBuyView:buyOrUseCallBack(controlTbl)
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
function ExpBuyView:btnResClick(button, type, notSound)
	if type == ccui.TouchEventType.ended then
		if not notSound then
			SoraDPlaySound()
		end
		local gametop = gModuleMgr.getObject("gametop")
		local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
		local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
		local resList = backpackltCtrl:getItemArray(gItemType.LORD_EXP)
		local isOver = true
		_ENV = gItemType.LORD_EXP
		gItemType.LORD_EXP.itemList = resList
		gItemType.LORD_EXP.itemCallBack = handler(self, self.buyOrUseCallBack)
		gItemType.LORD_EXP.itemStyle = "commonItemUseBar_02"
		local gItemType.LORD_EXP.itemSize, transTbl = cc.size(620, 170), gItemType.LORD_EXP
		self.itemScroll:setScroll(self.scroll)
		self.itemScroll:init(transTbl)
		for i, v in ipairs(resList) do
			if backpackCtrl:getItemCount(v) > 0 then
				isOver = false
				break
			end
		end
		if isOver then
			self:removeFromParent()
		end
	end
end
return ExpBuyView
