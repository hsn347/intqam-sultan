local gametop = gModuleMgr.getObject("gametop")
local rechargeActivityCtrl = gametop.playertop_:getModule("rechargeActivityCtrl")
local rechargeRead = include("rechargeRead")
local takeNode = class("takeNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("takeNode")
	end
	return target
end)
function takeNode:ctor()
	self.itemArray, _ENV = nil, nil
	self.Bottom_node = SoraDGetChildByName(self, "Bottom_node")
	self.Text_under = SoraDGetChildByName(self, "Text_under")
	self.Text_under:setString(device.platform == "android" and i18n("subscribe_gift_text_15") or i18n("subscribe_gift_text_14"))
	self.Node_item = SoraDGetChildByName(self, "Node_item")
	self.Text_getTitle = SoraDGetChildByName(self, "Text_getTitle")
	self.Text_getTitle:setString(i18n("subscribe_gift_text_06"))
	self.Node_title = SoraDGetChildByName(self, "Node_title")
	self.Text_title = SoraDGetChildByName(self, "Text_title")
	self.line_l = SoraDGetChildByName(self.Node_title, "frame_cw_line_14")
	self.line_r = SoraDGetChildByName(self.Node_title, "frame_cw_line_14_0")
	self.Text_title:setString(i18n("subscribe_gift_text_07"))
	self.line_l:setPositionX(-(30 + self.Text_title:getContentSize().width / 2 + self.line_l:getContentSize().width / 2))
	self.line_r:setPositionX(30 + self.Text_title:getContentSize().width / 2 + self.line_r:getContentSize().width / 2)
	self.Image_itemBg = SoraDGetChildByName(self, "Image_itemBg")
	self.Node_mLine = SoraDGetChildByName(self, "Node_mLine")
	self.Node_buff = SoraDGetChildByName(self, "Node_buff")
	self.Node_title_daily = SoraDGetChildByName(self, "Node_title_daily")
	self.labelTitle2 = SoraDGetChildByName(self, "Text_title_2")
	self.Text_policy = SoraDGetChildByName(self, "Text_policy")
	self.Text_policy:setString(i18n("common_text_3422"))
	self.Text_title_name = SoraDGetChildByName(self, "Text_title_name")
	self.Node_policy = SoraDGetChildByName(self, "Node_policy")
	self.Button_help = SoraDGetChildByName(self, "Button_help")
	self.Button_help:addTouchEventListener(handler(self, self.btnHelpClickCallBack))
	self.Button_policy = SoraDGetChildByName(self, "Button_policy")
	self.Button_policy:addTouchEventListener(handler(self, self.btnHelpClickCallBack))
	self.Button_long = SoraDGetChildByName(self, "Button_long")
	self.Button_long:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.Text_long = SoraDGetChildByName(self, "Text_long")
	self.Text_free = SoraDGetChildByName(self, "Text_free")
	self.Text_free = SoraDChangeTextToHtml(self.Text_free)
	self.Node_head = SoraDGetChildByName(self, "Node_head")
	self.Text_superLink = SoraDGetChildByName(self, "Text_superLink")
	self.Text_superLink = SoraDChangeTextToHtml(self.Text_superLink)
	self.Text_superLink:addTouchEventListener(handler(self, self.btnTermsClickCallBack))
	_ENV = handler(self, self.btnTermsClickCallBack)
	_ENV, _ENV, handler(self, self.btnTermsClickCallBack).link = handler(self, self.btnTermsClickCallBack)
	handler(self, self.btnTermsClickCallBack).u = "true"
	handler(self, self.btnTermsClickCallBack).c = "true"
	_ENV, gSvrConfig.linkUrlConfig.service.link, handler(self, self.btnTermsClickCallBack).color = handler(self, self.btnTermsClickCallBack)
	gSvrConfig.linkUrlConfig.service.__default, handler(self, self.btnTermsClickCallBack).color = handler(self, self.btnTermsClickCallBack)
	self.Text_superLink:setString(i18n_html("common_text_4507", handler(self, self.btnTermsClickCallBack)))
	SoraDSetTextWidthHeight(self.Text_superLink, cc.size(630, 40))
	self.Text_superLink_2 = SoraDGetChildByName(self, "Text_superLink_2")
	self.Text_superLink_2 = SoraDChangeTextToHtml(self.Text_superLink_2)
	self.Text_superLink_2:addTouchEventListener(handler(self, self.btnPolicyClickCallBack))
	_ENV = handler(self, self.btnPolicyClickCallBack)
	_ENV, _ENV, handler(self, self.btnPolicyClickCallBack).link = handler(self, self.btnPolicyClickCallBack)
	handler(self, self.btnPolicyClickCallBack).u = "true"
	handler(self, self.btnPolicyClickCallBack).c = "true"
	_ENV, gSvrConfig.linkUrlConfig.policy.link, handler(self, self.btnPolicyClickCallBack).color = handler(self, self.btnPolicyClickCallBack)
	gSvrConfig.linkUrlConfig.policy.__default, handler(self, self.btnPolicyClickCallBack).color = handler(self, self.btnPolicyClickCallBack)
	self.Text_superLink_2:setString(i18n_html("common_text_4508", handler(self, self.btnPolicyClickCallBack)))
	SoraDSetTextWidthHeight(self.Text_superLink_2, cc.size(630, 40))
	self.Text_superLink_3 = SoraDGetChildByName(self, "Text_superLink_3")
	self.Text_superLink_3 = SoraDChangeTextToHtml(self.Text_superLink_3)
	self.Text_superLink_3:addTouchEventListener(handler(self, self.btnGoogleClickCallBack))
	_ENV = handler(self, self.btnGoogleClickCallBack)
	_ENV, _ENV, handler(self, self.btnGoogleClickCallBack).link = handler(self, self.btnGoogleClickCallBack)
	handler(self, self.btnGoogleClickCallBack).u = "true"
	handler(self, self.btnGoogleClickCallBack).c = "true"
	_ENV, handler(self, self.btnGoogleClickCallBack).link, handler(self, self.btnGoogleClickCallBack).color = handler(self, self.btnGoogleClickCallBack)
	handler(self, self.btnGoogleClickCallBack).__default, handler(self, self.btnGoogleClickCallBack).color = handler(self, self.btnGoogleClickCallBack)
	self.Text_superLink_3:setString(i18n_html("common_text_4656", handler(self, self.btnGoogleClickCallBack)))
	SoraDSetTextWidthHeight(self.Text_superLink_3, cc.size(630, 40))
	self.Text_superLink_3:setVisible(false)
	self.Text_superLink_2:setPositionY(self.Text_superLink:getPositionY() - self.Text_superLink:getContentSize().height + 15)
	self.Text_superLink_3:setPositionY(self.Text_superLink_2:getPositionY() - self.Text_superLink_2:getContentSize().height + 15)
	if IsArClient and device.platform == "android" then
		self.Text_superLink_3:setVisible(true)
		self.Text_under:setPositionY(self.Text_superLink_3:getPositionY() - self.Text_superLink_3:getContentSize().height + 18)
	else
		self.Text_under:setPositionY(self.Text_superLink_2:getPositionY() - self.Text_superLink_2:getContentSize().height + 18)
	end
	SoraDSetTextWidthHeight(self.Text_under, cc.size(630, 185))
	SoraDSetTextWidthHeight(self.Text_free, cc.size(270, 50))
	self.ccs_first = SoraDGetExtendChildFromCCSByName(self, "CCS_rechargeFirstAward_node")
	self.Node_head:setLocalZOrder(5)
	self.Text_long:setFontSize(14)
	self:suitView()
	self:initData()
end
function takeNode:btnTermsClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("条款")
		userSDKManager.openSDKLink(gSvrConfig.linkUrlConfig.service)
	end
end
function takeNode:btnPolicyClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("政策")
		userSDKManager.openSDKLink(gSvrConfig.linkUrlConfig.policy)
	end
end
function takeNode:btnGoogleClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("谷歌订阅")
		userSDKManager.openSDKLink("https://play.google.com/store/account/subscriptions")
	end
end
function takeNode:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_TAKE_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_ACTIVETIMEOUT", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_CLIENT_RECHARGECENTER_DAYFIRST", handler(self, self.initData))
end
function takeNode:suitView()
	local isShort = display.height < 1136
	self.Bottom_node:setPositionY(self.Node_head:getPositionY() - 550)
	self.Node_buff:setScale(isShort and 0.8 or 1.0)
	self.Node_buff:setPositionY(isShort and 285 or 310)
	self.Node_title:setPositionY(isShort and 370 or 420)
	self.Image_itemBg:setContentSize(cc.size(640, self.Node_title:getPositionY() - 70))
	local headH = math.min(266, display.height - self.Image_itemBg:getContentSize().height - 530)
	self.Node_policy:setPositionY(isShort and -340 or -220)
	if display.height < 960 then
		self.Text_under:setFontSize(13)
		self.Text_superLink:setFontSize(16)
		self.Text_superLink_2:setFontSize(16)
		self.Text_superLink_3:setFontSize(16)
		self.Bottom_node:setPositionY(-440)
		self.Node_item:setScale(0.7)
		self.Node_title_daily:setPositionY(190)
		self.Node_buff:setScale(0.5)
		self.Node_buff:setPositionY(250)
		self.Node_title:setPositionY(320)
		self.Image_itemBg:setContentSize(cc.size(640, self.Node_title:getPositionY() - 70))
		self.labelTitle2:setFontSize(14)
		SoraDSetTextWidthHeight(self.Text_under, cc.size(630, 135))
	elseif display.height == 960 then
		self.Bottom_node:setPositionY(-500)
		self.Text_under:setFontSize(16)
	end
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
	self.Text_title_name:setString(i18n(rechargeRead.getPageViewData(self.takeDate.ID).activeName))
	local starTime = serviceFunctions.systemTime()
	if self.takeDate.isbuy then
		starTime = rechargeActivityCtrl:getRechargeLeftTime(self.takeDate.ID) + serviceFunctions.systemTime() - 604800
	end
	_ENV = i18n(rechargeRead.getPageViewData(self.takeDate.ID).activeName)
	i18n(rechargeRead.getPageViewData(self.takeDate.ID).activeName).time1 = SoraDConvertTimeToYear(starTime)
	i18n(rechargeRead.getPageViewData(self.takeDate.ID).activeName).time2 = SoraDConvertTimeToYear(starTime + 604800)
	self.labelTitle2:setString(i18n(self.takeDate.isbuy and "subscribe_gift_text_16" or "subscribe_gift_text_03", i18n(rechargeRead.getPageViewData(self.takeDate.ID).activeName)))
	self:updateItem()
	self:updateBuff()
	self:updateButton()
end
function takeNode:updateButton()
	local starTime = serviceFunctions.systemTime()
	if self.takeDate.isbuy then
		starTime = rechargeActivityCtrl:getRechargeLeftTime(self.takeDate.ID) + serviceFunctions.systemTime() - 604800
		if self.timer == nil then
			self.timer = SoradCreateTimer(self, handler(self, self.updateTime))
		end
		self:updateTime()
		self.Text_long:setString("")
		self.Text_free:setString("")
		if self.takeDate.isdayget then
			self.Button_long:setTitleText(i18n("subscribe_gift_btn_03"))
		else
			self.Button_long:setTitleText(i18n("common_text_854"))
		end
	else
		if self.timer then
			SoraDManagerRemoveTimer(self, self.timer)
			self.timer = nil
		end
		local originalPrice = paymentManager.judgePrice(self.takeDate.ID, self.takeDate.price)
		local price = paymentManager.judgePrice(self.takeDate.ID, self.takeDate.price)
		if not gSvrConfig.isReview and rechargeActivityCtrl:isTakeFree(self.takeDate.ID) then
			_ENV = i18n("common_text_854")
			i18n("common_text_854").price = originalPrice
			_ENV, _ENV, i18n("common_text_854").tips = "recharge_sub_1", i18n("recharge_sub_1"), i18n("recharge_sub_1")
			_ENV, i18n("recharge_sub_1").price, ("recharge_sub_1").color = "recharge_sub_1", "recharge_sub_1", "#FFFFFF"
			_ENV, i18n("recharge_sub_1").tips, ("recharge_sub_1").color = "recharge_sub_1", "recharge_sub_1", "#00FF00"
			i18n("recharge_sub_1").__default, ("recharge_sub_1").color = "recharge_sub_1", "#FFFF00"
			self.Text_free:setString(i18n_html("recharge_sub_2", i18n("common_text_854")))
			_ENV = i18n_html("recharge_sub_2", i18n("common_text_854"))
			i18n_html("recharge_sub_2", i18n("common_text_854")).price1 = originalPrice
			i18n_html("recharge_sub_2", i18n("common_text_854")).price2 = price
			self.Text_long:setString(i18n("subscribe_gift_text_10", i18n_html("recharge_sub_2", i18n("common_text_854"))))
		else
			self.Text_long:setString("")
			self.Text_free:setString("")
			self.Button_long:setTitleText(i18n("subscribe_gift_btn_01") .. price)
		end
	end
	self.Button_long:setTouchEnabled(not self.takeDate.isdayget)
	self.Button_long:setBright(not self.takeDate.isdayget)
end
function takeNode:updateTime()
	local leftTime = rechargeActivityCtrl:getRechargeLeftTime(self.takeDate.ID)
	rechargeActivityCtrl = nil
	;(nil).time = SoraDConvertSecondToString(leftTime)
	self.Text_long:setString(i18n("subscribe_gift_text_11", nil))
	if leftTime < 0 then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
end
function takeNode:updateBuff()
	local _ENV, buffData
	if self.takeDate.buff and next(self.takeDate.buff) then
		for i, v in ipairs(self.takeDate.buff) do
			_ENV = nil
			;(nil).id = v
			table.insert(buffData, nil)
		end
	end
	for i = 1, 3 do
		local single = SoraDGetExtendChildFromCCSByName(self, "CCS_takeBuffSingle_" .. i)
		if single then
			if buffData[i] then
				single:setVisible(true)
				single:initData(buffData[i])
			else
				single:setVisible(false)
			end
		end
	end
	SoraDToCenter(self.Node_buff, 180)
end
function takeNode:updateItem()
	for k, v in ipairs(self.itemArray) do
		v:setVisible(false)
	end
	local _ENV, itemData = (for generator), ipairs(self.itemArray)
	if not self.takeDate.gift then
		_ENV = self.takeDate.gift
	end
	local tmpList = SoraDStringSplit(self.takeDate.gift, ",")
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	itemData = serviceFunctions.tableFormat(tmpList, nil)
	if itemData and next(itemData) then
		for i, v in ipairs(itemData) do
			if not self.itemArray[i] then
				self.itemArray[i] = include("commonItemAward").new()
				self.itemArray[i]:setScale(0.8)
				self.itemArray[i]:setOwnView(display.getRunningScene())
				self.itemArray[i]:setPositionY(0)
				self.itemArray[i]:addTo(self.Node_item)
			end
			if tonumber(v.id) == gIDDef.GOLD then
				self.itemArray[i]:showCoolSquare()
			else
				self.itemArray[i]:hideCoolSquare()
			end
			self.itemArray[i]:setVisible(true)
			self.itemArray[i]:initData(v.id, v.count)
		end
		SoraDToCenter(self.Node_item, 90, SoraDFIsRA())
	end
end
function takeNode:btnHelpClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.Button_policy == button then
			userSDKManager.openSDKLink(gSvrConfig.linkUrlConfig.service)
		else
			_ENV = "subscribe_gift_text_04"
			;("subscribe_gift_text_04").align = SoraDFLabelR()
			SoraDShowHelpMsgTip(i18n("subscribe_gift_text_04"), "subscribe_gift_text_04")
		end
	end
end
function takeNode:btnClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
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
return takeNode
