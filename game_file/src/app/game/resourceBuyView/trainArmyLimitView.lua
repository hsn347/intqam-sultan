local trainArmyLimitView = class("trainArmyLimitView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("normalStyleBuyView")
	end
	return target
end)
function trainArmyLimitView:ctor()
	self.itemList, _ENV, self.troopData, _ENV, self.isHideCurrentSceneView = nil, nil, nil, nil, true
	self.itemType = nil
	self.itemScroll = include("itemBuyScroll").new()
	self.txtTitle = SoraDGetChildByName(self, "Text_title")
	self.windowTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_normalBuyView")
	self.windowTitle:setTitle(i18n("common_text_3631"))
	self.windowTitle:setTitleWidthHeight(cc.size(450, 100))
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_normalBuyView")
	self.goldTop = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonGoldTop_normalBuyView")
	self.nodeLoadingBar = SoraDGetChildByName(self, "Node_loadingBar")
	self.loadingBar = SoraDGetChildByName(self, "LoadingBar_progress")
	self.txtTime = SoraDGetChildByName(self, "Text_BarTime")
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	self.loadingBar:setScale9Enabled(true)
	self.loadingBar:setCapInsets(cc.rect(4, 0, 4, 21))
	self.nodeLoadingBar:setVisible(false)
	self.txtTitle:setVisible(false)
	self.scroll:setPositionY(self.scroll:getPositionY() + 60)
	self.scroll:setContentSize(cc.size(self.scroll:getContentSize().width, self.scroll:getContentSize().height + 60))
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_MALL_SUCCESS", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_ITEM_LIMITITEM_TIMEOUT_BACK", handler(self, self.refreshData))
end
function trainArmyLimitView:initData(itemType, troopData)
	self.troopData = troopData
	self.itemType = itemType
	self:refreshData()
end
function trainArmyLimitView:refreshData(...)
	SoraDCloseLoading(self)
	local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
	local listData = backpackltCtrl:getItemArray(self.itemType)
	self.itemList = listData
	dump(self.itemList, "self.itemList")
	self:initView()
end
function trainArmyLimitView:initView(...)
	local gametop = gModuleMgr.getObject("gametop")
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local publicRead = include("publicRead")
	_ENV = "publicRead"
	;("publicRead").itemList = self.itemList
	;("publicRead").itemCallBack = handler(self, self.buyOrUseCallBack)
	;("publicRead").itemStyle = "commonItemUseBar_02"
	local ("publicRead").itemSize, transTbl = cc.size(620, 170), "publicRead"
	self.itemScroll:setScroll(self.scroll)
	self.itemScroll:init(transTbl)
end
function trainArmyLimitView:buyOrUseCallBack(controlTbl)
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
return trainArmyLimitView
