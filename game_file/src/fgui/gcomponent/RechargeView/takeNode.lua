local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local rechargeRead = include("rechargeRead")
local baseComponent = require("fgui.base.baseComponent")
local takeNode = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RechargeView/takeNode", takeNode)
function takeNode:onInit()
	self.buffArray, _ENV, self.itemArray, _ENV = nil, nil, nil, nil
	self.fields.Text_under:setString(device.platform == "android" and i18n("subscribe_gift_text_15") or i18n("subscribe_gift_text_14"))
	self.fields.Text_getTitle:setString(i18n("subscribe_gift_text_06"))
	self.fields.Text_title:setString(i18n("subscribe_gift_text_07"))
	self.fields.Com_tip:setHandle(handler(self, self.btnHelpClickCallBack))
	self.fields.Button_long:addClickListener(handler(self, self.btnClickCallBack))
	_ENV = handler(self, self.btnClickCallBack)
	_ENV, _ENV, handler(self, self.btnClickCallBack).link = handler(self, self.btnClickCallBack)
	handler(self, self.btnClickCallBack).u = "true"
	handler(self, self.btnClickCallBack).c = "true"
	_ENV, gSvrConfig.linkUrlConfig.service.link, handler(self, self.btnClickCallBack).color = handler(self, self.btnClickCallBack)
	gSvrConfig.linkUrlConfig.service.__default, handler(self, self.btnClickCallBack).color = handler(self, self.btnClickCallBack)
	self.fields.Text_superLink1:setString(i18n_html("common_text_4507", handler(self, self.btnClickCallBack)))
	self.fields.Text_superLink1:addClickListener(handler(self, self.btnTermsClickCallBack))
	_ENV = handler(self, self.btnTermsClickCallBack)
	_ENV, _ENV, handler(self, self.btnTermsClickCallBack).link = handler(self, self.btnTermsClickCallBack)
	handler(self, self.btnTermsClickCallBack).u = "true"
	handler(self, self.btnTermsClickCallBack).c = "true"
	_ENV, gSvrConfig.linkUrlConfig.policy.link, handler(self, self.btnTermsClickCallBack).color = handler(self, self.btnTermsClickCallBack)
	gSvrConfig.linkUrlConfig.policy.__default, handler(self, self.btnTermsClickCallBack).color = handler(self, self.btnTermsClickCallBack)
	self.fields.Text_superLink2:setString(i18n_html("common_text_4508", handler(self, self.btnTermsClickCallBack)))
	self.fields.Text_superLink2:addClickListener(handler(self, self.btnPolicyClickCallBack))
	_ENV = handler(self, self.btnPolicyClickCallBack)
	_ENV, _ENV, handler(self, self.btnPolicyClickCallBack).link = handler(self, self.btnPolicyClickCallBack)
	handler(self, self.btnPolicyClickCallBack).u = "true"
	handler(self, self.btnPolicyClickCallBack).c = "true"
	_ENV, handler(self, self.btnPolicyClickCallBack).link, handler(self, self.btnPolicyClickCallBack).color = handler(self, self.btnPolicyClickCallBack)
	handler(self, self.btnPolicyClickCallBack).__default, handler(self, self.btnPolicyClickCallBack).color = handler(self, self.btnPolicyClickCallBack)
	self.fields.Text_superLink3:setString(i18n_html("common_text_4656", handler(self, self.btnPolicyClickCallBack)))
	self.fields.Text_superLink3:addClickListener(handler(self, self.btnGoogleClickCallBack))
	self.fields.Text_superLink3:setVisible(false)
	if IsArClient and device.platform == "android" then
		self.fields.Text_superLink3:setVisible(true)
		self.fields.Text_under:setPositionY(self.fields.Text_superLink3:getPositionY() + self.fields.Text_superLink3:getContentSize().height)
	else
		self.fields.Text_under:setPositionY(self.fields.Text_superLink2:getPositionY() + self.fields.Text_superLink2:getContentSize().height)
	end
	self.fields.List_item:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_item:setAlignCenter(true)
	self.fields.List_buff:setItemRenderer(handler(self, self.onBuffRenderer))
	self.fields.List_buff:setAlignCenter(true)
	self.Text_long = SoraDCreateTimerLabel(self, self.fields.Text_long)
	self.Text_long:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("subscribe_gift_text_11", nil)
	end)
	self.Text_long:setTimeEndListener(function()
		self.Text_long:setString("")
	end)
	self.fields.Btn_first:fixPos()
end
function takeNode:onItemRenderer(index, obj)
	local itemData = self.itemArray[index + 1]
	obj:initData(tonumber(itemData.id), tonumber(itemData.count))
	obj:showCoolSquare(tonumber(itemData.id) == gIDDef.GOLD)
end
function takeNode:onBuffRenderer(index, obj)
	obj:initData(self.buffArray[index + 1])
end
function takeNode:onShow()
end
function takeNode:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_TAKE_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_ACTIVETIMEOUT", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_CLIENT_RECHARGECENTER_DAYFIRST", handler(self, self.initData))
end
function takeNode:initData()
	SoraDCloseLoading()
	if not rechargeActivityCtrl:getTakeActivityList() then
		_ENV = rechargeActivityCtrl:getTakeActivityList()
	end
	self.takeDate = rechargeActivityCtrl:getTakeActivityList()
	self:updateView()
end
function takeNode:updateView()
	self.fields.Text_title_name:setString(i18n(rechargeRead.getPageViewData(self.takeDate.ID).activeName))
	local starTime = serviceFunctions.systemTime()
	if self.takeDate.isbuy then
		starTime = rechargeActivityCtrl:getRechargeLeftTime(self.takeDate.ID) + serviceFunctions.systemTime() - 604800
	end
	_ENV = i18n(rechargeRead.getPageViewData(self.takeDate.ID).activeName)
	i18n(rechargeRead.getPageViewData(self.takeDate.ID).activeName).time1 = SoraDConvertTimeToYear(starTime)
	i18n(rechargeRead.getPageViewData(self.takeDate.ID).activeName).time2 = SoraDConvertTimeToYear(starTime + 604800)
	self.fields.Com_tip:setTitle(i18n(self.takeDate.isbuy and "subscribe_gift_text_16" or "subscribe_gift_text_03", i18n(rechargeRead.getPageViewData(self.takeDate.ID).activeName)))
	self:updateItem()
	self:updateBuff()
	self:updateButton()
end
function takeNode:updateItem()
	if not self.takeDate.gift then
		_ENV = self.takeDate.gift
	end
	local tmpList = SoraDStringSplit(self.takeDate.gift, ",")
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	self.itemArray = serviceFunctions.tableFormat(tmpList, nil)
	self.fields.List_item:setNumItems(#self.itemArray)
end
function takeNode:updateBuff()
	self.buffArray, _ENV = nil, nil
	local index = 0
	if self.takeDate.buff and next(self.takeDate.buff) then
		for i, v in ipairs(self.takeDate.buff) do
			if index < 3 then
				_ENV = nil
				;(nil).id = v
				table.insert(self.buffArray, nil)
				index = index + 1
			end
		end
	end
	self.fields.List_buff:setNumItems(#self.buffArray)
end
function takeNode:updateButton()
	if self.takeDate.isbuy then
		local leftTime = rechargeActivityCtrl:getRechargeLeftTime(self.takeDate.ID)
		if 0 < leftTime then
			self.Text_long:beginTime(leftTime)
		else
			self.Text_long:endTime()
			self.Text_long:setString("")
		end
		if self.takeDate.isdayget then
			self.fields.Button_long:setTitle(i18n("subscribe_gift_btn_03"))
		else
			self.fields.Button_long:setTitle(i18n("common_text_854"))
		end
	else
		local originalPrice = paymentManager.judgePrice(self.takeDate.ID, self.takeDate.price)
		local price = paymentManager.judgePrice(self.takeDate.ID, self.takeDate.price)
		if not gSvrConfig.isReview and rechargeActivityCtrl:isTakeFree(self.takeDate.ID) then
			rechargeActivityCtrl = i18n("common_text_854")
			i18n("common_text_854").price = originalPrice
			rechargeActivityCtrl, rechargeActivityCtrl, i18n("common_text_854").tips = "recharge_sub_1", i18n("recharge_sub_1"), i18n("recharge_sub_1")
			rechargeActivityCtrl, i18n("recharge_sub_1").price, ("recharge_sub_1").color = "recharge_sub_1", "recharge_sub_1", "#FFFBD5"
			rechargeActivityCtrl, i18n("recharge_sub_1").tips, ("recharge_sub_1").color = "recharge_sub_1", "recharge_sub_1", "#006E00"
			i18n("recharge_sub_1").__default, ("recharge_sub_1").color = "recharge_sub_1", "#FFFBD5"
			self.fields.Button_long:setFirstFree(i18n_html("recharge_sub_2", i18n("common_text_854")))
			rechargeActivityCtrl = i18n_html("recharge_sub_2", i18n("common_text_854"))
			i18n_html("recharge_sub_2", i18n("common_text_854")).price1 = originalPrice
			i18n_html("recharge_sub_2", i18n("common_text_854")).price2 = price
			self.Text_long:setString(i18n("subscribe_gift_text_10", i18n_html("recharge_sub_2", i18n("common_text_854"))))
		else
			self.Text_long:setString("")
			self.fields.Button_long:setTitle(i18n("subscribe_gift_btn_01") .. price)
		end
	end
	self.fields.Button_long:setEnabled(not self.takeDate.isdayget)
end
function takeNode:btnTermsClickCallBack()
	SoraDPlaySound()
	userSDKManager.openSDKLink(gSvrConfig.linkUrlConfig.service)
end
function takeNode:btnPolicyClickCallBack()
	SoraDPlaySound()
	userSDKManager.openSDKLink(gSvrConfig.linkUrlConfig.policy)
end
function takeNode:btnGoogleClickCallBack()
	SoraDPlaySound()
	userSDKManager.openSDKLink("https://play.google.com/store/account/subscriptions")
end
function takeNode:btnClickCallBack()
	SoraDPlaySound()
	if self.takeDate.isbuy == false then
		local showMsg = device.platform == "android" and i18n("subscribe_gift_text_09") or i18n("subscribe_gift_text_08")
		SoraDShowMsgBox(showMsg, i18n("common_text_204"), nil, function(event)
			if event == MSGBOX_CALLBACK_YES then
				paymentManager.normalGiftBuyClassify(self.takeDate.ID)
			end
		end)
	elseif not self.takeDate.isdayget then
		rechargeActivityCtrl:getMonthAwardReq(self.takeDate.ID)
		SoraDShowLoading()
	end
end
function takeNode:openBuyBox(giftID)
	if giftID == self.takeDate.ID then
		if self.takeDate.isbuy == false then
			local showMsg = device.platform == "android" and i18n("subscribe_gift_text_09") or i18n("subscribe_gift_text_08")
			SoraDShowMsgBox(showMsg, i18n("common_text_204"), nil, function(event)
				if event == MSGBOX_CALLBACK_YES then
					paymentManager.normalGiftBuyClassify(self.takeDate.ID)
				end
			end)
		elseif not self.takeDate.isdayget then
			rechargeActivityCtrl:getMonthAwardReq(self.takeDate.ID)
			SoraDShowLoading()
		end
	end
end
function takeNode:btnHelpClickCallBack()
	_ENV = "subscribe_gift_text_04"
	;("subscribe_gift_text_04").align = SoraDFLabelR()
	SoraDShowHelpMsgTip(i18n("subscribe_gift_text_04"), "subscribe_gift_text_04")
end
return takeNode
