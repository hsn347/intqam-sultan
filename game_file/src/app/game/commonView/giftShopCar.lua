local shoppingCartCtrl = SoraDGetCtrl("shoppingCartCtrl")
local giftShopCar = class("giftShopCar", function(target)
	if target == nil then
		return SoraDCreateBasePanel("giftShopCar")
	end
	return target
end)
function giftShopCar:ctor()
	self.giftID = nil
	self.from = gRechargeGiftFrom.ACTIVITY
	self.icon_car = SoraDGetChildByName(self, "icon_car")
	self.Sprite_red = SoraDGetChildByName(self, "Sprite_red")
	self.Text_num = SoraDGetChildByName(self, "Text_num")
	self.Text_oprate = SoraDGetChildByName(self, "Text_oprate")
	self.Button_touch = SoraDGetChildByName(self, "Button_touch")
	self.Button_touch:addTouchEventListener(handler(self, self.onTouchBack))
	self.Button_oprate = SoraDGetChildByName(self, "Button_oprate")
	self.Button_oprate:addTouchEventListener(handler(self, self.onOprateBack))
	self:initData()
end
function giftShopCar:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_CLIENT_RECHARGECENTER_GIFTCART", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_CLIENT_RECHARGECENTER_GIFTCART_DATA", handler(self, self.suitData))
end
function giftShopCar:initData()
	local giftNum = table.nums(shoppingCartCtrl:getShoppingCartInfo())
	self.Text_num:setString(giftNum)
	self.Sprite_red:setVisible(0 < giftNum)
end
function giftShopCar:updateData()
	self:initData()
	self:setGiftID(self.giftID, self.from)
end
function giftShopCar:suitData()
	local showData = shoppingCartCtrl:getUsefulData()
	local ret = true
	for k, v in pairs(showData) do
		if v.id == self.giftID then
			ret = false
			break
		end
	end
	self.isCanAdd = ret and not shoppingCartCtrl:isInShoppingCart(self.giftID)
	if self.isCanAdd then
		self.Text_oprate:setString(i18n("shopping_text_10"))
		self.Button_oprate:loadTextureNormal("btn_chongzhi_gwcan01.png", ccui.TextureResType.plistType)
	else
		self.Text_oprate:setString(i18n("common_text_697"))
		self.Button_oprate:loadTextureNormal("btn_chongzhi_gwcan02.png", ccui.TextureResType.plistType)
	end
end
function giftShopCar:setGiftID(giftID, from)
	self.giftID = giftID
	self.from = from or gRechargeGiftFrom.ACTIVITY
	self.giftList = shoppingCartCtrl:getShoppingCartInfo()
	local _ENV, ridList = shoppingCartCtrl:getShoppingCartInfo(), shoppingCartCtrl:getShoppingCartInfo()
	for k, v in pairs(self.giftList) do
		table.insert(ridList, tonumber(k))
	end
	if 0 < #ridList then
		shoppingCartCtrl:reqShoppingCartInfo(ridList)
	else
		self.giftDetail, _ENV = shoppingCartCtrl.reqShoppingCartInfo, shoppingCartCtrl.reqShoppingCartInfo
		self:suitData()
	end
end
function giftShopCar:runAddAction()
	self.icon_car:stopAllActions()
	self.icon_car:setRotation(0)
	_UPVALUE6_ = self.icon_car
	self.icon_car[1] = cca.delay(0.1)
	self.icon_car[2] = cca.callFunc(function()
		self.Sprite_red:setVisible(true)
		local labelAdd = ccui.Text:create("", "", 18)
		labelAdd:setString("+1")
		labelAdd:setTextColor(cc.c4b(0, 190, 30, 255))
		labelAdd:setPosition(cc.p(9, 29))
		labelAdd:addTo(self.Sprite_red, 2)
		_ENV = 2
		;(2)[1] = cca.moveTo(0.5, 9, 9)
		;(2)[2] = cca.callFunc(function()
			labelAdd:removeFromParent()
			self:initData()
		end)
		;(2)[3] = cca.callFunc(function()
			labelAdd:removeFromParent()
			self:initData()
		end)
		;(2)[4] = cca.callFunc(function()
			labelAdd:removeFromParent()
			self:initData()
		end)
		labelAdd:runAction(cca.seq(2))
	end)
	self.icon_car[3] = cca.rotateTo(0.1, 15)
	self.icon_car[4] = cca.rotateTo(0.1, -10)
	self.icon_car[5] = cca.rotateTo(0.1, 8)
	self.icon_car[6] = cca.rotateTo(0.1, -5)
	self.icon_car[7] = cca.rotateTo(0.1, 0)
	self.icon_car[8] = cca.rotateTo(0.1, 0)
	self.icon_car[9] = cca.rotateTo(0.1, 0)
	local action = cca.seq(self.icon_car)
	self.icon_car:runAction(action)
end
function giftShopCar:runDelAction()
	local labelDel = ccui.Text:create("", "", 18)
	labelDel:setString("-1")
	labelDel:setTextColor(cc.c4b(190, 40, 40, 255))
	labelDel:setPosition(cc.p(9, 9))
	labelDel:addTo(self.Sprite_red, 2)
	_UPVALUE1_ = 2
	;(2)[1] = cca.moveTo(0.5, 9, -11)
	;(2)[2] = cca.callFunc(function()
		labelDel:removeFromParent()
		self:initData()
	end)
	;(2)[3] = cca.callFunc(function()
		labelDel:removeFromParent()
		self:initData()
	end)
	;(2)[4] = cca.callFunc(function()
		labelDel:removeFromParent()
		self:initData()
	end)
	labelDel:runAction(cca.seq(2))
end
function giftShopCar:onTouchBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("rechargeGiftShopCarView"):show()
	end
end
function giftShopCar:onOprateBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isCanAdd then
			self:runAddAction()
			shoppingCartCtrl:reqAddShoppingCart(self.giftID)
		else
			self:runDelAction()
			shoppingCartCtrl = self.giftID
			self.giftID[1] = self.giftID
			shoppingCartCtrl:reqRemoveShoppingCart(self.giftID)
		end
	end
end
function giftShopCar:setButtomStyle()
	self.Button_oprate:setContentSize(cc.size(80, 53))
	self.Button_oprate:setPosition(cc.p(0, -53))
	self.Button_oprate:setLocalZOrder(1)
	self.Text_oprate:setLocalZOrder(1)
	self.Text_oprate:setPosition(cc.p(0, -53))
end
return giftShopCar
