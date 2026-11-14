local SteelBuyView = class("steelBuyView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("normalStyleBuyView")
	end
	return target
end)
function SteelBuyView:ctor()
	self.itemList, _ENV, self.isHideCurrentSceneView = nil, nil, true
	self.itemType = nil
	self.itemScroll = include("itemBuyScroll").new()
	self.txtTitle = SoraDGetChildByName(self, "Text_title")
	self.windowTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_normalBuyView")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_normalBuyView")
	self.goldTop = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonGoldTop_normalBuyView")
	self.nodeLoadingBar = SoraDGetChildByName(self, "Node_loadingBar")
	self.loadingBar = SoraDGetChildByName(self, "LoadingBar_progress")
	self.txtTime = SoraDGetChildByName(self, "Text_BarTime")
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	self.loadingBar:setScale9Enabled(true)
	self.loadingBar:setCapInsets(cc.rect(4, 0, 4, 21))
	self.nodeLoadingBar:setVisible(false)
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_MALL_SUCCESS", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_ITEM_LIMITITEM_TIMEOUT_BACK", handler(self, self.refreshData))
	self:initData()
end
function SteelBuyView:initData()
	self.itemType = gItemType.STEEL
	self:refreshData()
end
function SteelBuyView:refreshData()
	SoraDCloseLoading(self)
	local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
	local listData = backpackltCtrl:getItemArray(self.itemType)
	self.itemList = listData
	self:initView()
end
function SteelBuyView:initView(...)
	local gametop = gModuleMgr.getObject("gametop")
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local isOver = true
	self.windowTitle:setTitle(i18n("common_text_025"))
	self.txtTitle:setString(i18n("common_text_025") .. ":" .. string.formatnumberthousands(cityCtrl:getResCount(gIDDef.STEEL)))
	for i, v in ipairs(self.itemList) do
		if backpackCtrl:getItemCount(v) > 0 then
			isOver = false
			break
		end
	end
	if isOver then
		self:removeFromParent()
	else
		_ENV = self.removeFromParent
		self.removeFromParent.itemList = self.itemList
		self.removeFromParent.itemCallBack = handler(self, self.buyOrUseCallBack)
		self.removeFromParent.itemStyle = "commonItemUseBar_01"
		local self.removeFromParent.itemSize, transTbl = cc.size(620, 170), self.removeFromParent
		self.itemScroll:setScroll(self.scroll)
		self.itemScroll:init(transTbl)
	end
end
function SteelBuyView:buyOrUseCallBack(controlTbl)
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
return SteelBuyView
