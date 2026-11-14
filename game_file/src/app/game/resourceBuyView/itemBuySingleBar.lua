local ItemBuySingleBar = class("itemBuySingleBar", function(target)
	return target
end)
function ItemBuySingleBar:ctor()
	self.tableItem, _ENV = nil, nil
	self.scroll = nil
	self.useCallBack = nil
	self.singleIsMoved = false
	self.txtTitle = SoraDGetChildByName(self, "Text_name")
	self.txtDes = SoraDGetChildByName(self, "Text_des")
	self.itemCount = SoraDGetChildByName(self, "Text_count")
	self.itemIcon = SoraDGetChildByName(self, "Image_itemHead")
	self.itemBg = SoraDGetChildByName(self, "Image_itemBg")
	self.btnGold = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldSmallBtn_gold")
	_ENV = "CCS_commonGoldSmallBtn_gold"
	self.btnGold:initData("CCS_commonGoldSmallBtn_gold", 1)
	self.btnUse = SoraDGetChildByName(self, "Button_use")
	self.labelCanBuy = SoraDGetChildByName(self, "Text_canBuy")
	self.imgCanBuy = SoraDGetChildByName(self, "Image_canBuy")
	self.imgSbg = SoraDGetChildByName(self, "Image_sbg")
	if self.imgSbg then
		self.imgSbg:setFillType(1)
	end
	self.imgD = SoraDGetChildByName(self, "Image_d")
	if self.imgD then
		self.imgD:setFillType(1)
	end
	self.Panel_Touch = SoraDGetChildByName(self, "Panel_Touch")
	if self.Panel_Touch then
		self.Panel_Touch:setSwallowTouches(false)
	end
	self.btnUse:setTitleText(i18n("common_text_314"))
	self.btnGold:setTitleStr(i18n("common_text_426"))
	function self.aLive()
		return true
	end
	if SoraDGetDefaultLanguage() == "es" then
		SoraDSetTextWidthHeight(self.txtTitle, cc.size(300, 60))
	end
	self.btnUse:addTouchEventListener(handler(self, self.btnNormalUseCall))
	self.btnGold:addTouchEventListener(handler(self, self.btnUseGoldCall))
end
function ItemBuySingleBar:openItemIconClick(handl)
	if handl then
		self.itemIcon:setTouchEnabled(true)
		self.itemIcon:setSwallowTouches(false)
		self.itemIcon.itemData = self.tableItem
		self.itemIcon:addTouchEventListener(handl)
	end
end
function ItemBuySingleBar:initData(itemtype)
	self.tableItem = itemtype
	self:initView()
	if self.itemInitCallBack then
		self.itemInitCallBack(self)
	end
end
function ItemBuySingleBar:initView(...)
	local publicRead = include("publicRead")
	self.btnGold:setGoldText(self.tableItem.gold or 0)
	self.itemCount:setString(self.tableItem.count or 0)
	self.txtTitle:setString(publicRead.getName(self.tableItem.iid))
	if self.txtDes then
		self.txtDes:setString(publicRead.getDes(self.tableItem.iid))
	end
	self.itemIcon:loadTexture(publicRead.getIcon(self.tableItem.iid), ccui.TextureResType.plistType)
	self.itemBg:loadTexture(publicRead.getBg(self.tableItem.iid), ccui.TextureResType.plistType)
	if self.tableItem.limitData and (not self.tableItem.count or not (0 < self.tableItem.count)) then
		_ENV = publicRead.getDes(self.tableItem.iid)
		publicRead.getDes(self.tableItem.iid).member = self.tableItem.limitData.cur
		publicRead.getDes(self.tableItem.iid).total = self.tableItem.limitData.max
		self.labelCanBuy:setString(i18n("common_text_155", publicRead.getDes(self.tableItem.iid)))
		self.imgCanBuy:setVisible(true)
	else
		self.imgCanBuy:setVisible(false)
	end
	if self.tableItem.count and 0 < self.tableItem.count then
		self.btnGold:setVisible(false)
		self.btnUse:setVisible(true)
		self.btnUse:setGrayed(false)
	elseif self.tableItem.isUseOnly then
		self.btnGold:setVisible(false)
		self.btnUse:setVisible(true)
		self.btnUse:setGrayed(true)
	else
		self.btnUse:setVisible(false)
		self.btnGold:setVisible(true)
	end
	if self.tableItem.isBuyOnly then
		self.btnGold:setTitleStr(i18n("common_text_282"))
		self.itemCount:setString("")
		self.btnGold:setVisible(true)
		self.btnUse:setVisible(false)
		if self.tableItem.buyCount then
			self.txtTitle:setString(self.tableItem.buyCount .. "x " .. publicRead.getName(self.tableItem.iid))
		end
	end
	if self.tableItem.isbattleExclusive then
		_ENV = self.tableItem.buyCount .. "x " .. publicRead.getName(self.tableItem.iid)
		self.btnGold:initData(self.tableItem.buyCount .. "x " .. publicRead.getName(self.tableItem.iid), 0)
		self.btnGold:setTitleText(i18n("common_text_4347"))
	end
end
function ItemBuySingleBar:setUseCallBack(handl)
	self.useCallBack = handl
end
function ItemBuySingleBar:setItemInitCallBack(handl)
	self.itemInitCallBack = handl
end
function ItemBuySingleBar:setScroll(scroll)
	self.scroll = scroll
end
function ItemBuySingleBar:btnUseGoldCall(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		SoraDPlaySound()
		if self.useCallBack then
			_ENV = "node is not on view"
			;("node is not on view").buy = true
			;("node is not on view").needGold = self.tableItem.gold or 0
			;("node is not on view").itemID = self.tableItem.iid
			;("node is not on view").shopID = self.tableItem.shopID
			;("node is not on view").oriData = self.tableItem
			self.useCallBack("node is not on view")
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
function ItemBuySingleBar:btnNormalUseCall(button, type)
	if type == ccui.TouchEventType.ended then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			print("node is not on view")
			return
		end
		SoraDPlaySound()
		if self.useCallBack then
			_ENV = "node is not on view"
			;("node is not on view").use = true
			;("node is not on view").itemID = self.tableItem.iid
			;("node is not on view").itemCount = self.tableItem.count or 0
			;("node is not on view").oriData = self.tableItem
			self.useCallBack("node is not on view")
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
return ItemBuySingleBar
