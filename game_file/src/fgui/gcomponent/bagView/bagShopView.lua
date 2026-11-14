local limitTimeDiscountShopAPI = include("limitTimeDiscountShopAPI")
local allianceDesRead = include("allianceDesRead")
local shopCtrl = SoraDGetCtrl("shopCtrl")
local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local bagShopView = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://bagView/bagShopView", bagShopView)
function bagShopView:onInit()
	self.fields.img:fix()
	self.tableTabData, _ENV, self.tableItems, _ENV = self.fields.img.fix, self.fields.img.fix, self.fields.img.fix, self.fields.img.fix
	self.curTag = 1
	self.offSetY = self.fields.ScrollView_shop:getPositionY()
	self.fields.Button_discount:setVisible(false)
	self.fields.ScrollView_shop:setVirtual()
	self.fields.ScrollView_shop:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_recovery:setTitle(i18n("recycling_store_text1"))
	self.fields.Button_recovery:addClickEventListener(handler(self, self.onRecoveryClick))
	self.fields.group:fixPos()
	self.fields.tab:updateTab(self.curTag)
	self.fields.tab:setTabClickCallback(handler(self, self.onTabClick))
	self:initData()
end
function bagShopView:onTabClick(tag)
	if self.curTag == tag then
		return
	end
	self.curTag = tag
	self.fields.tab:updateTab(self.curTag)
	self:updateListView()
end
function bagShopView:onItemRenderer(index, obj)
	obj:initData(self.tableTabData[index + 1])
end
function bagShopView:initData()
	self.tableItems = shopCtrl:getShopItemList()
	self:updateNewTag()
	self:updateListView()
	self:updateDiscount()
end
function bagShopView:updateNewTag()
	local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
	self.fields.tab:updateNew(self.curTag)
	local constantRead = include("constantRead")
	local castleLv = constantRead.getConstValue("RECYCLING_STORE_LEVEL", 6)
	self.fields.Button_recovery:setVisible(castleLv <= SoraDGetCastleLv())
	self.fields.Button_recovery:setReddot(backpackCtrl:getIsRecoveryShopRedPoint())
end
function bagShopView:jumpToItem(itemID)
	local key
	for k, itemList in pairs(self.tableItems) do
		for i, v in ipairs(itemList) do
			if v.itemId == itemID then
				key = k
				break
			end
		end
		if key then
			break
		end
	end
	if key then
		local tag = self.fields.tab:getTagKey(key)
		self:updateCurBtn(tag, itemID, true)
		return true
	else
		return false
	end
end
function bagShopView:updateListView(itemID, noJump)
	local tableKey = self.fields.tab:getTabKey(self.curTag)
	self.tableTabData, _UPVALUE0_ = self.fields.tab, self.fields.tab
	if not self.tableItems[tableKey] then
		local _UPVALUE0_, tabData = self.tableItems[tableKey], self.tableItems[tableKey]
	end
	local index = 1
	local floor = 1
	for i = 1, #tabData - 1, 2 do
		_UPVALUE0_ = nil
		;(nil)[1] = tabData[i]
		self.tableTabData[index], (nil)[2] = nil, tabData[i + 1]
		if itemID and (tabData[i].itemId == itemID or tabData[i + 1].itemId == itemID) then
			floor = index
		end
		index = index + 1
	end
	self.fields.ScrollView_shop:setNumItems(#self.tableTabData)
	if itemID then
		self.fields.ScrollView_shop:scrollToView(floor - 1)
	elseif not noJump then
		self:runJumpTop()
	end
end
function bagShopView:runJumpTop()
	self.fields.ScrollView_shop:jumpToTop()
	self.fields.ScrollView_shop:getScrollPane():updatePositionImmediately()
	self.fields.ScrollView_shop:setPositionY(self.offSetY + 50)
	self.fields.ScrollView_shop:stopAllActions()
	self.fields.ScrollView_shop:runAction(ffa.exponentialOut(ffa.moveTo(0.3, self.fields.ScrollView_shop:getPositionX(), self.offSetY)))
end
function bagShopView:jumpToTab(btnName)
	_UPVALUE0_ = nil
	;(nil).btnRes = 1
	;(nil).btnWar = 2
	;(nil).btnBuf = 3
	local (nil).btnOther, tbl = 4, nil
	if tbl[btnName] then
		self:updateCurBtn(tbl[btnName], nil, true)
	end
end
function bagShopView:updateDiscount()
	local status, remainTime = limitTimeDiscountShopAPI:getActivityInfo()
	if status and not allianceDesRead.getPlayerConquestWarMigration(false) and not allianceDesRead.getPlayerBattleGroundMigration(false) then
		self.fields.Button_discount:setVisible(true)
		self.fields.Button_discount:setTime(remainTime)
	else
		self.fields.Button_discount:setVisible(false)
	end
end
function bagShopView:updateCurBtn(tag, itemID, noJump)
	self.curTag = tag
	self.fields.tab:updateTab(self.curTag)
	self:updateNewTag()
	self:updateListView(itemID, noJump)
end
function bagShopView:jumpToNewTab()
	local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
	local isNew = shopltCtrl:getShopNewTag("all")
	if isNew then
		_ENV = shopltCtrl
		shopltCtrl.resource_item_list = 1
		shopltCtrl.battle_item_list = 2
		shopltCtrl.buff_item_list = 3
		local shopltCtrl.other_item_list, keyCfg = 4, shopltCtrl
		for k, v in pairs(keyCfg) do
			if shopltCtrl:getShopNewTag(k) then
				self:updateCurBtn(v)
				break
			end
		end
	end
end
function bagShopView:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", function(target, data)
		if data and data.activityID == gActivityTimeActivityID.LIMITED_DISCOUNT_ACTIVITY then
			self:updateDiscount()
		end
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_ACTIVITY_EXCHANGE_MALL_REFRESH", function(target, data)
		if data.name == "remind" or data.name == "refreshData" then
			self:updateNewTag()
		end
	end)
	SoraDAddMessage(self, "MESSAGE_ITEM_COUNT_CHANGE_BAG_BACK", function(target, data)
		self:updateNewTag()
	end)
	SoraDAddMessage(self, "MESSAGE_MALL_ERR", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ITEM_LIMITITEM_TIMEOUT_BACK", handler(self, self.initData))
end
function bagShopView:onRecoveryClick()
	SoraDPlaySound()
	uiManager:show("BagItemRecovery")
end
return bagShopView
