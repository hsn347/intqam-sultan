local CommonItemUseBar = class("commonItemUseBar", function(target)
	if target == nil then
		return cc.uiloader:load(getCCSPath("commonItemUseBar"))
	end
	return target
end)
function CommonItemUseBar:ctor()
	self.tableItem, _ENV, self.useCallBack = nil, nil, nil
	self.meBuyOnly = false
	self.scroll = nil
	self.singleIsMoved = false
	self.needResCount = nil
	self.txtTitle = SoraDGetChildByName(self, "Text_name")
	self.txtDes = SoraDGetChildByName(self, "Text_des")
	self.itemCount = SoraDGetChildByName(self, "Text_count")
	self.itemIcon = SoraDGetChildByName(self, "Image_head")
	self.itemBg = SoraDGetChildByName(self, "Image_itemBg")
	self.txtGold = SoraDGetChildByName(self, "Text_gold")
	self.btnGold = SoraDGetChildByName(self, "Button_gold")
	self.btnUse = SoraDGetChildByName(self, "Button_use")
	self.labelCanBuy = SoraDGetChildByName(self, "Text_canBuy")
	self.imgCanBuy = SoraDGetChildByName(self, "Image_canBuy")
	self.btnUse:addTouchEventListener(handler(self, self.btnNormalUseCall))
	self.btnGold:addTouchEventListener(handler(self, self.btnUseGoldCall))
end
function CommonItemUseBar:initData(itemtype)
	local itemDesRead = include("itemDesRead")
	self.tableItem = itemtype
	self.txtGold:setString(self.tableItem.gold)
	self.txtTitle:setString(self.tableItem.title)
	self.txtDes:setString(self.tableItem.des)
	self.itemCount:setString(self.tableItem.count)
	self.itemIcon:loadTexture(self.tableItem.icon, ccui.TextureResType.plistType)
	self.itemBg:loadTexture(itemDesRead.getBg(self.tableItem.iid), ccui.TextureResType.plistType)
	if self.tableItem.count > 0 then
		self.btnGold:setVisible(false)
		self.btnUse:setVisible(true)
	else
		self.btnUse:setVisible(false)
		self.btnGold:setVisible(true)
	end
end
function CommonItemUseBar:setNeedResCount(needResList)
	self.needResCount = needResList
end
function CommonItemUseBar:showLimitCount(limitData)
	if limitData then
		_ENV = nil
		;(nil).member = limitData.cur
		;(nil).total = limitData.max
		self.labelCanBuy:setString(i18n("common_text_155", nil))
		self.imgCanBuy:setVisible(true)
	else
		self.imgCanBuy:setVisible(false)
	end
end
function CommonItemUseBar:setMeBuyOnly()
	self.btnGold:getChildByName("Text_title"):setString(i18n("common_text_282"))
	self.itemCount:setString("")
	self.btnGold:setVisible(true)
	self.btnUse:setVisible(false)
	self.meBuyOnly = true
end
function CommonItemUseBar:setUseCallBack(handl)
	self.useCallBack = handl
end
function CommonItemUseBar:getItemID()
	return self.tableItem.iid
end
function CommonItemUseBar:btnUseGoldCall(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		print("我是金币")
		SoraDPlaySound()
		self:sureToBuy(MSGBOX_CALLBACK_YES)
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function CommonItemUseBar:btnNormalUseCall(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		print("我是普通")
		SoraDPlaySound()
		if self.useCallBack then
			local gametop = gModuleMgr.getObject("gametop")
			local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
			if backpackltCtrl:getUseMax(self.tableItem.iid) > 1 and 1 < self.tableItem.count then
				_ENV, _ENV = nil, nil
				;(nil).id = self.tableItem.iid
				;(nil).itemData, (nil).count = nil, self.tableItem.count
				;(nil).needResList = self.needResCount
				uiManager:show("newItemSingleUse", nil)
				self.useCallBack(self.tableItem.iid, nil, true)
			else
				self.useCallBack(self.tableItem.iid)
			end
		end
	elseif type == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif type == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function CommonItemUseBar:setScroll(scroll)
	self.scroll = scroll
end
function CommonItemUseBar:sureToBuy(type)
	if type == MSGBOX_CALLBACK_YES and self.useCallBack then
		if self.meBuyOnly then
			self.useCallBack(self.tableItem.iid, self.tableItem.gold, nil, self.tableItem.shopItemID)
		else
			self.useCallBack(self.tableItem.iid, self.tableItem.gold)
		end
	end
end
return CommonItemUseBar
