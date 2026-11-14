local gametop = gModuleMgr.getObject("gametop")
local publicRead = include("publicRead")
local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local shopCtrl = gametop.playertop_:getModule("shopCtrl")
local commonItemBuyUseSingle = class("commonItemBuyUseSingle", function(luaFileName)
	if "userdata" == type(luaFileName) then
		return luaFileName
	else
		return SoraDCreateBasePanel("commonItemBuyUseSingle")
	end
end)
function commonItemBuyUseSingle:ctor()
	self.size = cc.size(640, 170)
	self.ownView = nil
	self.scroll = nil
	self.singleData = nil
	self.useHandle = nil
	self.buyHandle = nil
	self.Image_sbg = SoraDGetChildByName(self, "Image_sbg")
	if self.Image_sbg then
		self.Image_sbg:setFillType(1)
	end
	self.frame_light = SoraDGetChildByName(self, "frame_light")
	self.item = SoraDGetExtendChildFromCCSByName(self, "CCS_commonItemAward_item")
	self.Text_count = SoraDGetChildByName(self, "Text_count")
	if self.Text_count then
		self.Text_count:setVisible(false)
	end
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	self.Image_frmBg = SoraDGetChildByName(self, "Image_frmBg")
	self.Button_use = SoraDGetChildByName(self, "Button_use")
	if self.Button_use then
		self.Button_use:setTitleText(i18n("common_text_314"))
		self.Button_use:addTouchEventListener(handler(self, self.btnUseClickCallBack))
	end
	self.Button_buy = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldSmallBtn_gold")
	if self.Button_buy then
		_ENV = "CCS_commonGoldSmallBtn_gold"
		;("CCS_commonGoldSmallBtn_gold").title = i18n("common_text_426")
		self.Button_buy:initData("CCS_commonGoldSmallBtn_gold", 1)
		self.Button_buy:addTouchEventListener(handler(self, self.btnBuyClickCallBack))
	end
	self:initDefaultView()
end
function commonItemBuyUseSingle:initData(data)
	self.singleData = data
	if self.item then
		self.item:initData(self.singleData.itemID, self.singleData.itemNum or 0)
		if self.singleData.isHideNum then
			self.item:hideNum()
		end
	end
	if self.Text_name then
		self.Text_name:setString(publicRead.getName(self.singleData.itemID))
	end
	if self.Text_des then
		self.Text_des:setString(publicRead.getDes(self.singleData.itemID))
	end
	self.singleData.itemNum = self.singleData.itemNum or 0
	self.singleData.gold = self.singleData.gold or shopltCtrl:getPriceByItemID(self.singleData.itemID) or 0
	local ret = self.singleData.isBuy or self.singleData.itemNum == 0
	if self.Button_buy then
		self.Button_buy:setVisible(ret)
		self.Button_buy:setGoldText(string.formatnumberthousands(self.singleData.gold))
	end
	if self.Button_use then
		self.Button_use:setVisible(not ret)
	end
end
function commonItemBuyUseSingle:btnUseClickCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.useHandle then
			self.useHandle(self.singleData)
		else
			_ENV, _ENV = nil, nil
			;(nil).id = self.singleData.itemID
			;(nil).itemData, (nil).count = nil, self.singleData.itemNum
			uiManager:show("newItemSingleUse", nil)
		end
	end
end
function commonItemBuyUseSingle:btnBuyClickCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.buyHandle then
			self.buyHandle(self.singleData)
		else
			local shopItem = shopltCtrl:getShopItemByItemID(self.singleData.itemID)
			shopCtrl:reqBuyInItemShop(shopItem.shopItemID, 1, true)
		end
	end
end
function commonItemBuyUseSingle:setUseHandle(handle)
	self.useHandle = handle
end
function commonItemBuyUseSingle:setBuyHandle(handle)
	self.buyHandle = handle
end
function commonItemBuyUseSingle:initDefaultView()
	if self.item then
		self.item:setPositionY(-self.size.height / 2)
	end
end
function commonItemBuyUseSingle:setContentSize(size)
	self.size = size
	if self.Image_frmBg then
		self.Image_frmBg:setContentSize(self.size)
	end
	if self.Image_sbg then
		self.Image_sbg:setScaleX(size.width / 640)
		self.Image_sbg:setScaleY(size.height / 170)
	end
	if self.frame_light then
		self.frame_light:setPositionY(-self.size.height + 10)
	end
	if self.item then
		self.item:setPositionY(-self.size.height / 2)
	end
	if self.Button_use then
		self.Button_use:setPositionY(-self.size.height / 2)
	end
	if self.Button_buy then
		self.Button_buy:setPositionY(-self.size.height / 2)
	end
	if self.Text_name then
		self.Text_name:setPositionY(-30)
	end
	if self.Text_des then
		self.Text_des:setPositionY(-60)
		self.Text_des:setContentSize(cc.size(275, self.size.height / 2))
	end
	if self.Text_count then
		self.Text_count:setPositionY(-self.size.height + 30)
	end
end
function commonItemBuyUseSingle:getContentSize()
	return self.size
end
function commonItemBuyUseSingle:setOwnView(view)
	self.ownView = view
	if self.item then
		self.item:setOwnView(self.ownView)
	end
end
function commonItemBuyUseSingle:setScroll(scroll)
	self.scroll = scroll
	if self.item then
		self.item:setScroll(self.ownView)
	end
end
function commonItemBuyUseSingle:setSpecialNumShow()
	if self.Text_count then
		self.Text_count:setVisible(true)
		self.Text_count:setPositionY(-self.size.height + 30)
		if self.item then
			self.item:setPositionY(-self.size.height / 2 + 10)
		end
	end
end
function commonItemBuyUseSingle:setBuyBtnTitle(title)
	if self.Button_buy then
		self.Button_buy:setTitleStr(title)
	end
end
function commonItemBuyUseSingle:initSpecialView()
	if self.item then
		self.item:setPositionY(95)
	end
end
return commonItemBuyUseSingle
