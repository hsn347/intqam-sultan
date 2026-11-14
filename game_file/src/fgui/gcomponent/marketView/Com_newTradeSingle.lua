local gametop = gModuleMgr.getObject("gametop")
local publicRead = include("publicRead")
local salesRoomAgCtrl = SoraDGetCtrl("salesRoomAgCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_newTradeSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://marketView/Com_newTradeSingle", Com_newTradeSingle)
function Com_newTradeSingle:onInit()
	_UPVALUE3_ = nil
	self.giftArray, (nil)[1] = nil, 13508
	self.giftArray, (nil)[2] = nil, 13509
	self.giftArray, (nil)[3] = nil, 13510
	self.fields.Button_record:addClickListener(handler(self, self.btnRecordClick))
	self.fields.Button_addPrice:setString(i18n("auction_text_39"))
	self.fields.Button_addPrice:addClickListener(handler(self, self.btnAddPriceClick))
	self.fields.Button_addPriceMax:setString(i18n("auction_btn_01"))
	self.fields.Button_addPriceMax:addClickListener(handler(self, self.btnMaxPriceClick))
	self:fixChildrenPos()
	self.fields.n2:fix()
	self.fields.icon_state:setPositionX(SoraDFPosX(446, 680))
end
function Com_newTradeSingle:onShow()
end
function Com_newTradeSingle:initData(data)
	self.data = data
	self.fields.item:initData(self.data.item[1], self.data.item[2])
	self.fields.Text_name:setString(publicRead.getName(self.data.item[1]))
	if data._delay >= data.delayTime then
		self.fields.Text_lastTime:setTimeLast(function(ticket)
			return ticket
		end)
	else
		self.fields.Text_lastTime:setTimeLast(nil)
	end
	self.fields.Text_lastTime:beginTime(data._etime - serviceFunctions.systemTime())
	local selfUid = gametop.playertop_:getPlayerID()
	self.fixedPrice = data.fixedPrice
	if data._ownuid and data._ownuid == selfUid then
		self.fixedPrice = data.fixedPrice - data._curprice
		self.fields.Button_addPriceMax:setCostTitle(string.formatnumberthousands(data.fixedPrice - data._curprice))
	else
		self.fields.Button_addPriceMax:setCostTitle(string.formatnumberthousands(data.fixedPrice))
	end
	if salesRoomAgCtrl:checkEnoughRes(self.fixedPrice, data.res) then
		self.fields.Button_addPriceMax:setTitleColor(display.COLOR_WHITE)
		self.fields.Button_addPriceMax:setGoldColor(display.COLOR_YELLOW)
	else
		self.fields.Button_addPriceMax:setTitleColor(display.COLOR_RED)
		self.fields.Button_addPriceMax:setGoldColor(display.COLOR_RED)
	end
	self.addPrice = data.plus
	if data._ownuid and data._ownuid == selfUid then
		self.fields.icon_state:setVisible(true)
		self.fields.icon_state:setSpriteFrame(SoraDFIsRA() and "ay_jpz.png" or "en_jpz.png")
		self.fields.Button_addPrice:setString(i18n("auction_text_39"))
		self.fields.Button_addPrice:setCostTitle(string.formatnumberthousands(self.addPrice))
	elseif data._uidlist and data._uidlist[tostring(selfUid)] then
		self.fields.icon_state:setVisible(true)
		self.fields.icon_state:setSpriteFrame(SoraDFIsRA() and "ay_jpab.png" or "en_jpsb.png")
		self.fields.Button_addPrice:setString(i18n("auction_btn_02"))
		self.addPrice = data._curprice + data.plus
		self.fields.Button_addPrice:setCostTitle(string.formatnumberthousands(self.addPrice))
	else
		self.fields.icon_state:setVisible(false)
		self.fields.Button_addPrice:setString(i18n("auction_btn_02"))
		self.addPrice = data._curprice + data.plus
		self.fields.Button_addPrice:setCostTitle(string.formatnumberthousands(self.addPrice))
	end
	if salesRoomAgCtrl:checkEnoughRes(self.addPrice, data.res) then
		self.fields.Button_addPrice:setTitleColor(display.COLOR_WHITE)
		self.fields.Button_addPrice:setGoldColor(display.COLOR_YELLOW)
	else
		self.fields.Button_addPrice:setTitleColor(display.COLOR_RED)
		self.fields.Button_addPrice:setGoldColor(display.COLOR_RED)
	end
end
function Com_newTradeSingle:btnRecordClick()
	SoraDPlaySound()
	_ENV = nil
	_ENV, (nil).shopID = self.data.shopID, self.data.shopID
	self.data.shopID.id = self.data.item[1]
	;(nil).itemInfo, self.data.shopID.count = self.data.shopID, self.data.item[2]
	uiManager:show("newTradeBoardRecordsView", nil)
end
function Com_newTradeSingle:btnAddPriceClick()
	SoraDPlaySound()
	if not salesRoomAgCtrl:checkEnoughRes(self.addPrice, self.data.res) then
		local str = self.data.res == gIDDef.BORE and i18n("auction_text_17") or i18n("auction_text_16")
		SoraDShowMsgBox(str, i18n("common_text_678"), nil, function(type)
			if type == MSGBOX_CALLBACK_YES then
				if GLOBAL_GAME_RECHARGE_MODE then
					_ENV = nil
					;(nil).rechargeIDList = self.giftArray
					uiManager:show("rechargeView", nil)
				else
					local panel = SoraDCreatePanel("rechargeView")
					panel:jumpToLimitNodeByList(12, self.giftArray)
					panel:show()
				end
				paymentManager.openRechargeView(gRechargeActiveFromEnum.ROAD09)
			end
		end)
	else
		local selfUid = gametop.playertop_:getPlayerID()
		if not (not self.data._uidlist or self.data._uidlist[tostring(selfUid)]) or self.data._ownuid ~= selfUid then
			local str = ""
			if self.data.res == gIDDef.BORE then
				_ENV = nil
				;(nil).item = publicRead.getName(self.data.item[1])
				;(nil).gold = self.addPrice
				str = i18n("auction_text_24", nil)
			else
				_ENV = nil
				;(nil).item = publicRead.getName(self.data.item[1])
				;(nil).gold = self.addPrice
				str = i18n("auction_text_23", nil)
			end
			SoraDShowMsgBox(str, i18n("common_text_204"), i18n("common_text_185"), function(event)
				if event == MSGBOX_CALLBACK_YES then
					salesRoomAgCtrl:sendNewAddPlusMsg(self.data.shopID, self.addPrice)
				end
			end)
		else
			local popView = SoraDCreatePanel("newTradeBoardAddPricePopView")
			popView:initData(self.data)
			popView:show()
		end
	end
end
function Com_newTradeSingle:btnMaxPriceClick()
	SoraDPlaySound()
	if not salesRoomAgCtrl:checkEnoughRes(self.fixedPrice, self.data.res) then
		local str
		if self.data.res == gIDDef.BORE then
			str = i18n("auction_text_17")
		else
			str = i18n("auction_text_16")
		end
		SoraDShowMsgBox(str, i18n("common_text_678"), nil, function(type)
			if type == MSGBOX_CALLBACK_YES then
				if GLOBAL_GAME_RECHARGE_MODE then
					_ENV = nil
					;(nil).rechargeIDList = self.giftArray
					uiManager:show("rechargeView", nil)
				else
					local panel = SoraDCreatePanel("rechargeView")
					panel:jumpToLimitNodeByList(12, self.giftArray)
					panel:show()
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
		if self.data.res == gIDDef.BORE then
			_ENV = self.data.item[2]
			self.data.item[2].gold = self.fixedPrice
			self.data.item[2].item = itemStr
			str = i18n("auction_text_13", self.data.item[2])
		else
			_ENV = self.data.item[2]
			self.data.item[2].gold = self.fixedPrice
			self.data.item[2].item = itemStr
			str = i18n("auction_text_12", self.data.item[2])
		end
		SoraDShowMsgBox(str, i18n("common_text_054"), i18n("common_text_185"), function(type)
			if type == MSGBOX_CALLBACK_YES then
				salesRoomAgCtrl:sendNewAddPlusMsg(self.data.shopID, self.data.fixedPrice)
			end
		end)
	end
end
return Com_newTradeSingle
