local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local equipDesRead = include("equipDesRead")
local rechargePresentUtil = include("rechargePresentUtil")
local RechargePopView = class("rechargePopView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("rechargePopView")
	end
	return target
end)
function RechargePopView:ctor()
	self.buffDatas, _ENV, self.itemOcxsList, _ENV, self.giftData, _ENV, self.isAddToPopManager = nil, nil, nil, nil, nil, nil, true
	self.fromCenter = nil
	self.isPageTurn = nil
	SoraDGetChildByName(self, "Size_Image_bg"):setFillType(1)
	self.Image_itemBg = SoraDGetChildByName(self, "Image_itemBg")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_itemList")
	self.txtNowPrice = SoraDGetChildByName(self, "Text_nowPrice")
	self.txtOriPrice = SoraDGetChildByName(self, "Text_oriPrice")
	self.txtGiftTip = SoraDGetChildByName(self, "Text_giftTip")
	self.txtRechargeDes = SoraDGetChildByName(self, "Bottom_Text_tip")
	self.nodeHead = SoraDGetChildByName(self, "Top_Node_head")
	self.btnRechargeCenter = SoraDGetChildByName(self, "Bottom_Button_rechargeCenter")
	self.btnRechargeCenter:setVisible(false)
	self.btnBuy = SoraDGetChildByName(self, "Bottom_Button_buy")
	self.btnBuy:setPressedActionEnabled(false)
	self.btnClose = SoraDGetChildByName(self, "Top_Button_close")
	if not IsArClient then
		SoraDGetChildByName(self.btnClose, "Sprite_close"):setSpriteFrame("icon_XXX.png")
	end
	self.spCloth = SoraDGetChildByName(self, "Top_Sprite_cloth")
	self.nodeCharge = SoraDGetChildByName(self, "Node_charge")
	self.spFlagTxt = SoraDGetChildByName(self, "Sprite_flagTxt")
	self.imgItem = SoraDGetChildByName(self, "Image_item")
	self.imgItem:setVisible(false)
	self.ccs_car = SoraDGetExtendChildFromCCSByName(self, "Bottom_CCS_giftShopCar_car")
	self.txtRechargeDes:setString(i18n("common_text_789"))
	self.btnBuy:addTouchEventListener(handler(self, self.btnBuyClick))
	self.btnClose:addTouchEventListener(handler(self, self.btnCloseClick))
	self.dailyRechargeOCX = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_rechargeFirstAward_node")
	self:suitView()
	self:addBtnBuyEffect()
end
function RechargePopView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_CLIENT_RECHARGECENTER_POPVIEWCLOSE", function(...)
		if not tolua.isnull(self) then
			self:doubleClose()
		end
	end)
	SoraDAddMessage(self, "MESSAGE_RECHARGE_PRESENT_REFRESH_ACTIVE", function(...)
		self:initView()
	end)
	SoraDAddMessage(self, "MESSAGE_PRINCE_GIFT_BUY_PACKAGE", function(...)
		print("关闭了吗222")
		SoraDCloseLoading()
		self:removeFromParent()
	end)
end
function RechargePopView:suitView()
	self.Image_itemBg:setContentSize(cc.size(640, display.height - 650))
	self.scroll:setPositionY(162)
	self.scroll:setContentSize(cc.size(640, self.Image_itemBg:getContentSize().height - 40))
end
function RechargePopView:checkRedPackage(id)
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local redPackageID = activityShowCtrl:getRedPackageRid()
	if SoraDisInList(id, redPackageID) then
		local conquestWarCtrl = gametop.playertop_:getModule("conquestWarCtrl")
		local isInConquestWar = conquestWarCtrl:isPlayerConquestWarMigration()
		if not self.btnRedPackage and not isInConquestWar then
			self.btnRedPackage = include("rechargeRedPackageNode").new()
			self.btnRedPackage:setPosition(cc.p(140, display.height - 117))
			self.btnRedPackage:addTo(self, 99)
		end
	elseif self.btnRedPackage then
		self.btnRedPackage:removeFromParent()
		self.btnRedPackage = nil
	end
end
function RechargePopView:checkRechargeCenterBtn(...)
	if self.otherInfo and self.otherInfo.needLocateBtn then
		self.btnRechargeCenter:setVisible(true)
		self.btnRechargeCenter:addTouchEventListener(handler(self, self.btnRechargeCenterClick))
	else
		self.btnRechargeCenter:setVisible(false)
	end
end
function RechargePopView:initData(id, fromCenter, isPageTurn, otherInfo)
