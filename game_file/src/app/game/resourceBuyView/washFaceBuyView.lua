local WashFaceBuyView = class("washFaceBuyView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("washFaceBuyView")
	end
	return target
end)
function WashFaceBuyView:ctor()
	self.itemID2List, _ENV, self.resBtns, _ENV, self.isHideCurrentSceneView = nil, nil, nil, nil, true
	self.curBtn = nil
	self.itemScroll = include("itemBuyScroll").new()
	self.btnRes = SoraDGetChildByName(self, "Button_res")
	self.nodeTop = SoraDGetChildByName(self, "Top_Node")
	self.goldTop = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldTop_resBuy")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_List")
	self.windowTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_resourceBuyView")
	self.windowTitle:setTitle(i18n("common_text_1288"))
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	self.btnRes:addTouchEventListener(handler(self, self.btnResClick))
end
function WashFaceBuyView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", handler(self, self.update))
	SoraDAddMessage(self, "MESSAGE_MALL_SUCCESS", handler(self, self.update))
end
function WashFaceBuyView:initData(curIndex)
	print("curIndex====", curIndex)
	local equipmentltCtrl = include("equipmentltCtrl")
	local rIDList = equipmentltCtrl.getAllRemakeMaterial()
	local _ENV, resIDList = curIndex, curIndex
	for i, v in ipairs(rIDList) do
		if v ~= NEBULA_WASHFACE_STONE then
			table.insert(resIDList, v)
		end
	end
	local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
	for i, v in ipairs(resIDList) do
		if not shopltCtrl:getQuickShopItemArrayByItemID(v) then
			local _ENV, listData = shopltCtrl:getQuickShopItemArrayByItemID(v), shopltCtrl:getQuickShopItemArrayByItemID(v)
		end
		self.itemID2List[v] = listData
		if v == LEGEND_WASHFACE_STONE then
			local nebulaData = shopltCtrl:getQuickShopItemArrayByItemID(NEBULA_WASHFACE_STONE)
			for ki, vi in ipairs(nebulaData) do
				table.insert(self.itemID2List[v], vi)
			end
		end
		table.sort(self.itemID2List[v], function(a, b)
			return a.shopItemID < b.shopItemID
		end)
	end
	dump(self.itemID2List, "self.itemID2List222")
	local btnCount = #resIDList
	for i, v in pairs(resIDList) do
		local btn = self.btnRes:clone()
		btn:setPositionX(SoraDFSign(display.width / (btnCount * 2) * (1 + (i - 1) * 2)))
		btn:setContentSize(cc.size(display.width / btnCount, btn:getContentSize().height))
		btn:getChildByName("Text_res"):setPositionX(btn:getContentSize().width / 2 - 20)
		btn:getChildByName("Text_res"):setFontSize(18)
		local resImg = "icon_equip_materialtype_0" .. i .. ".png"
		local spRes = cc.Sprite:createWithSpriteFrameName(resImg)
		local iconRes = cc.Sprite:createWithSpriteFrameName("icon_goods_reset.png")
		spRes:setScale(0.75)
		spRes:setPosition(display.width / btnCount - 25, btn:getContentSize().height / 2)
		iconRes:setPosition(display.width / btnCount - 30, btn:getContentSize().height / 2)
		iconRes:setScale(0.6)
		spRes:addTo(btn)
		iconRes:addTo(btn)
		btn:addTo(self.nodeTop, -1)
		btn:setTag(v)
		table.insert(self.resBtns, btn)
	end
	self:refreshRes()
	self.btnRes:setVisible(false)
	if curIndex then
		for i, v in ipairs(self.resBtns) do
			if curIndex == NEBULA_WASHFACE_STONE and v:getTag() == LEGEND_WASHFACE_STONE then
				self:btnResClick(self.resBtns[i], ccui.TouchEventType.ended, true)
			elseif v:getTag() == tonumber(curIndex) then
				self:btnResClick(self.resBtns[i], ccui.TouchEventType.ended, true)
			end
		end
	else
		self:btnResClick(self.resBtns[1], ccui.TouchEventType.ended, true)
	end
end
function WashFaceBuyView:refreshRes()
	local gametop = gModuleMgr.getObject("gametop")
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	for i, v in ipairs(self.resBtns) do
		for k, v in pairs(self.resBtns) do
			local itemCount = backpackCtrl:getItemCount(v:getTag())
			v:getChildByName("Text_res"):setString(itemCount)
		end
	end
end
function WashFaceBuyView:update()
	SoraDCloseLoading(self)
	self:btnResClick(self.curBtn, ccui.TouchEventType.ended, true)
	self:refreshRes()
end
function WashFaceBuyView:btnResClick(button, type, notSound)
	if type == ccui.TouchEventType.ended then
		if not notSound then
			SoraDPlaySound()
		end
		for i, v in ipairs(self.resBtns) do
			if v ~= button then
				v:setBright(false)
				v:setTouchEnabled(true)
				v:getChildByName("Text_res"):setColor(cc.c3b(148, 148, 152))
			else
				v:getChildByName("Text_res"):setColor(cc.c3b(255, 255, 255))
				_ENV = v:getChildByName("Text_res").setColor
				v:getChildByName("Text_res").setColor.itemList = self.itemID2List[button:getTag()]
				v:getChildByName("Text_res").setColor.itemCallBack = handler(self, self.buyOrUseCallBack)
				v:getChildByName("Text_res").setColor.itemStyle = "commonItemUseBar_02"
				v:getChildByName("Text_res").setColor.itemSize = cc.size(620, 170)
				local v:getChildByName("Text_res").setColor.isBuyOnly, transTbl = true, v:getChildByName("Text_res").setColor
				self.itemScroll:setScroll(self.scroll)
				self.itemScroll:init(transTbl)
			end
		end
		self.curBtn = button
		button:setBright(true)
		button:setTouchEnabled(false)
	end
end
function WashFaceBuyView:buyOrUseCallBack(controlTbl)
	local buyItem = function(shopID)
		local itemInfo = gModuleMgr.sharedMgr("shopltCtrl"):getShopItemByShopItem(shopID)
		dump(itemInfo, "itemInfo")
		if itemInfo then
			_ENV = nil
			;(nil).quickBuyData = itemInfo
			uiManager:show("newShopSingleBuy", nil)
		else
			SoraDShowMsgTip(i18n("notice_0170"))
		end
	end
	dump(controlTbl, "controlTbl")
	if controlTbl.buy and SoraDEnoughGold(controlTbl.needGold) then
		buyItem(controlTbl.shopID)
	end
end
return WashFaceBuyView
