local salesRoomAgCtrl = SoraDGetCtrl("salesRoomAgCtrl")
local publicRead = include("publicRead")
local newTradeBoardAddPricePopView = class("newTradeBoardAddPricePopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("newTradeBoardAddPricePopView")
	end
	return target
end)
function newTradeBoardAddPricePopView:ctor()
	self.curCount = 0
	self:initWidget()
end
function newTradeBoardAddPricePopView:initWidget(...)
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.itemAward = SoraDGetExtendChildFromCCSByName(self, "CCS_commonItemAward_item")
	self.itemAward:setOwnView(self)
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_gold = SoraDGetChildByName(self, "Text_gold")
	self.Sprite_icon = SoraDGetChildByName(self, "Sprite_icon")
	self.Button_up = SoraDGetChildByName(self, "Button_up")
	self.Button_up:addTouchEventListener(handler(self, self.btn_upClick))
	self.Button_down = SoraDGetChildByName(self, "Button_down")
	self.Button_down:addTouchEventListener(handler(self, self.btn_downClick))
	self.Button_addPrice = SoraDGetChildByName(self, "Button_addPrice")
	SoraDAutoSizeButtonTextByContent(self.Button_addPrice)
	self.Button_addPrice:addTouchEventListener(handler(self, self.btn_addPriceClick))
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("auction_text_40"))
end
function newTradeBoardAddPricePopView:initData(data)
	self.data = data
	self.itemAward:initData(data.item[1], data.item[2])
	self.Text_name:setString(publicRead.getName(data.item[1]))
	local resPng = include("resDesRead").getIcon(data.res)
	self.Sprite_icon:setSpriteFrame(resPng)
	local curPrice = data._curprice
	self.plusPrice = data.plus
	self.minPrice = curPrice + self.plusPrice
	self.myPrice = self.minPrice
	self:refreshMyPrice()
end
function newTradeBoardAddPricePopView:btn_upClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.myPrice = self.myPrice + self.plusPrice
		if self.myPrice > self.data.fixedPrice then
			self.myPrice = self.data.fixedPrice
			SoraDShowMsgTip(i18n("auction_text_21"))
		end
		self:refreshMyPrice()
	end
end
function newTradeBoardAddPricePopView:btn_downClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.myPrice = self.myPrice - self.plusPrice
		if self.myPrice < self.minPrice then
			self.myPrice = self.minPrice
			SoraDShowMsgTip(i18n("auction_text_22"))
		end
		self:refreshMyPrice()
	end
end
function newTradeBoardAddPricePopView:btn_addPriceClick(button, type)
	if type ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	if not salesRoomAgCtrl:checkEnoughRes(self.myPrice - self.data._curprice, self.data.res) then
		local str
		if self.data.res == gIDDef.BORE then
			str = i18n("auction_text_17")
		else
			str = i18n("auction_text_16")
		end
		SoraDShowMsgBox(str, i18n("common_text_678"), nil, function(type)
			if type == MSGBOX_CALLBACK_YES then
				if GLOBAL_GAME_RECHARGE_MODE then
					uiManager:show("rechargeView")
				else
					SoraDCreatePanel("rechargeView"):show()
				end
				paymentManager.openRechargeView(gRechargeActiveFromEnum.ROAD09)
			end
		end)
	else
		local str
		_ENV = i18n("common_text_678")
		i18n("common_text_678").name = publicRead.getName(self.data.item[1])
		i18n("common_text_678").count = self.data.item[2]
		local itemStr = i18n("common_text_1460", (i18n("common_text_678")))
		if self.myPrice >= self.data.fixedPrice then
			if self.data.res == gIDDef.BORE then
				_ENV = self.data.item[2]
				self.data.item[2].gold = self.myPrice
				self.data.item[2].item = itemStr
				str = i18n("auction_text_13", self.data.item[2])
			else
				_ENV = self.data.item[2]
				self.data.item[2].gold = self.myPrice
				self.data.item[2].item = itemStr
				str = i18n("auction_text_12", self.data.item[2])
			end
		elseif self.data.res == gIDDef.BORE then
			_ENV = self.data.item[2]
			self.data.item[2].item = itemStr
			self.data.item[2].gold = self.myPrice
			str = i18n("auction_text_24", self.data.item[2])
		else
			_ENV = self.data.item[2]
			self.data.item[2].item = itemStr
			self.data.item[2].gold = self.myPrice
			str = i18n("auction_text_23", self.data.item[2])
		end
		SoraDShowMsgBox(str, i18n("common_text_054"), i18n("common_text_185"), function(type)
			if type == MSGBOX_CALLBACK_YES then
				salesRoomAgCtrl:sendNewAddPlusMsg(self.data.shopID, self.myPrice)
				self:removeFromParent()
			end
		end)
	end
end
function newTradeBoardAddPricePopView:refreshMyPrice(...)
	self.Text_gold:setString(string.formatnumberthousands(self.myPrice - self.data._curprice))
	if self.myPrice >= self.data.fixedPrice then
		self.Button_addPrice:setTitleText(i18n("auction_btn_01"))
	else
		self.Button_addPrice:setTitleText(i18n("auction_text_39"))
	end
	if not salesRoomAgCtrl:checkEnoughRes(self.myPrice - self.data._curprice, self.data.res) then
		self.Button_addPrice:setTitleColor(display.COLOR_RED)
	else
		self.Button_addPrice:setTitleColor(display.COLOR_WHITE)
	end
end
return newTradeBoardAddPricePopView
