local gametop = gModuleMgr.getObject("gametop")
local premiumStoreCtrl = gametop.playertop_:getModule("premiumStoreCtrl")
local publicRead = include("publicRead")
local vipLocalData = include("vipLocalData")
local RechargeVipLimitBox = class("rechargeVipLimitBox", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("rechargeVipLimitBox")
	end
	return target
end)
function RechargeVipLimitBox:ctor()
	self.commonPopBox_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.item = SoraDGetExtendChildFromCCSByName(self, "CCS_commonItemAward_item")
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.labelUnlock = SoraDGetChildByName(self, "Text_unlock")
	self.labelUnlock:setString(i18n("enjoyable_store_01"))
	self.nodeCheck1 = SoraDGetChildByName(self, "Node_check_1")
	self.nodeCheck2 = SoraDGetChildByName(self, "Node_check_2")
end
function RechargeVipLimitBox:initData(data)
	self.itemData = data
	self.item:initData(self.itemData.commodityID)
	self.item:setBaseScale(0.95)
	self.item:setTouchEnabled(false)
	self.labelDes:setString(publicRead.getDes(self.itemData.commodityID))
	self.commonPopBox_bg:setTitleName(publicRead.getName(self.itemData.commodityID))
	self:bindCheckNode(self.nodeCheck1, true)
	self:bindCheckNode(self.nodeCheck2)
	self.labelUnlock:setVisible(false)
	self.nodeCheck1:setVisible(false)
	self.nodeCheck2:setVisible(false)
	self.nodeCheck1:setPositionY(-72)
	self.nodeCheck2:setPositionY(-112)
	if gPremiumUnlockType.meetGold == self.itemData.unlocktype then
		self.nodeCheck1:setVisible(true)
		self.nodeCheck1:setPositionY(-40)
	elseif gPremiumUnlockType.meetVip == self.itemData.unlocktype then
		self.nodeCheck2:setVisible(true)
		self.nodeCheck2:setPositionY(-40)
	elseif gPremiumUnlockType.meetGoldOrVip == self.itemData.unlocktype then
		self.nodeCheck1:setVisible(true)
		self.nodeCheck2:setVisible(true)
		self.labelUnlock:setVisible(true)
	elseif gPremiumUnlockType.both == self.itemData.unlocktype then
		self.nodeCheck1:setVisible(true)
		self.nodeCheck2:setVisible(true)
		self.nodeCheck1:setPositionY(-40)
		self.nodeCheck2:setPositionY(-80)
	end
end
function RechargeVipLimitBox:bindCheckNode(node, isGold)
	local viplv = SoraDGetVipLv()
	node.imgIcon = SoraDGetChildByName(node, "Image_icon")
	node.labelDes = SoraDGetChildByName(node, "Text_des")
	node.btnJump = SoraDGetChildByName(node, "Button_jump")
	node.imgState = SoraDGetChildByName(node, "Image_state")
	SoraDAutoSizeButtonText(node.btnJump)
	if isGold then
		node.imgIcon:loadTexture(publicRead.getIcon(gIDDef.GOLD), ccui.TextureResType.plistType)
		node.btnJump:setTag(1)
		node.btnJump:setTitleText(i18n("common_text_2002"))
		self:isConditionMet(premiumStoreCtrl:getDollor() >= self.itemData.total, node)
		_ENV = i18n("common_text_2002")
		_ENV = i18n("common_text_2002")
		i18n("common_text_2002").n = paymentManager.returnCurrencyByChannel()
		i18n("common_text_2002").c = paymentManager.exchangeByChannel(string.formatnumberthousands(self.itemData.total))
		i18n("common_text_2002").price = i18n("common_text_2358", i18n("common_text_2002"))
		node.labelDes:setString(i18n("common_text_1977", i18n("common_text_2002")))
	else
		node.imgIcon:loadTexture(publicRead.getIcon(gIDDef.VIP_POINT), ccui.TextureResType.plistType)
		node.btnJump:setTag(2)
		node.btnJump:setTitleText(i18n("common_text_452"))
		self:isConditionMet(viplv >= self.itemData.viplv, node)
		local num, isVip = vipLocalData:getVipNum(self.itemData.viplv)
		if isVip then
			node.labelDes:setString(i18n("recharge_label_014") .. num)
		else
			_ENV = i18n("common_text_452")
			i18n("common_text_452").lv = num
			node.labelDes:setString(i18n("common_text_3974", i18n("common_text_452")))
		end
	end
	node.imgIcon:setScale(40 / node.imgIcon:getContentSize().height)
	node.btnJump:addTouchEventListener(function(button, event)
		if event == ccui.TouchEventType.ended then
			SoraDPlaySound()
			if button:getTag() == 1 then
				if GLOBAL_GAME_RECHARGE_MODE then
					uiManager:show("rechargeView")
				else
					SoraDCreatePanel("rechargeView"):show()
				end
			else
				uiManager:show("vipCenterView")
			end
			self:removeFromParent()
		end
	end)
end
function RechargeVipLimitBox:isConditionMet(isMet, node)
	if isMet then
		node.imgState:loadTexture("icon_yes.png", ccui.TextureResType.plistType)
		node.labelDes:setColor(display.COLOR_WHITE)
	else
		node.imgState:loadTexture("icon_no.png", ccui.TextureResType.plistType)
		node.labelDes:setColor(display.COLOR_RED)
	end
	node.btnJump:setVisible(not isMet)
end
function RechargeVipLimitBox:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		print("btn click")
	end
end
return RechargeVipLimitBox
