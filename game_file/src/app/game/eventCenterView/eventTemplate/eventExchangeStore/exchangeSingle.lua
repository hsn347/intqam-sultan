local gametop = gModuleMgr.getObject("gametop")
local exchangeMallCtrl = gametop.playertop_:getModule("exchangeMallCtrl")
local activityExchangeMallCtrl = gametop.playertop_:getModule("activityExchangeMallCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local publicRead = include("publicRead")
local exchangeSingle = class("exchangeSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("exchangeSingle")
	end
	return target
end)
function exchangeSingle:ctor()
	self.exChangeStatus = 0
	self.Panel_touch = SoraDGetChildByName(self, "Panel_touch")
	self.Panel_touch:setSwallowTouches(false)
	SoraDGetChildByName(self, "Image_L"):setFillType(1)
	SoraDGetChildByName(self, "Image_R"):setFillType(1)
	self.CheckBox_notify = SoraDGetChildByName(self, "CheckBox_notify")
	self.CheckBox_notify:addEventListener(handler(self, self.onCheckBoxCallBack))
	self.Text_notify = SoraDGetChildByName(self, "Text_notify")
	self.Text_notify:setString(i18n("exchange_btn_01"))
	self.Text_leftCount = SoraDGetChildByName(self, "Text_leftCount")
	self.Button_exchange = SoraDGetChildByName(self, "Button_exchange")
	self.Button_exchange:setTitleText(i18n("common_text_1889"))
	self.Button_exchange:addTouchEventListener(handler(self, self.onBtnCallBack))
	self.Button_from = SoraDGetChildByName(self, "Button_from")
	self.Button_from:setPressedActionEnabled(false)
	self.Button_from:setSwallowTouches(false)
	self.Button_to = SoraDGetChildByName(self, "Button_to")
	self.Button_to:setPressedActionEnabled(false)
	self.Button_to:setSwallowTouches(false)
end
function exchangeSingle:initData(data, otherData)
	self.activityID = otherData.activityID
	self.exchangeItemID = data.exchangeitem[1]
	self.scroll = otherData.scroll
	self.view = otherData.view
	self.shopItemID = data.shopItemID
	self.itemID = data.shopitem[1]
	self.singleGet = data.shopitem[2]
	self.toolID = data.exchangeitem[1]
	self.singleCount = data.exchangeitem[2]
	self.curExchangeNum = data.curExchangeNum
	local isNotify = data.remindStatus == 1
	self.CheckBox_notify:setSelected(isNotify)
	self:setBtnFromData(data.exchangeitem)
	self:setBtnToData(data.shopitem)
	self:setLeftCount(data.limitType, data.limitnum, self.curExchangeNum)
	self:setBtnExchangeStatus()
end
function exchangeSingle:setLeftCount(limitType, limitnum, curExchangeNum)
	if limitType == 0 or limitnum == 0 then
		self.Text_leftCount:setString("")
	else
		self.leftCount = math.max(0, limitnum - curExchangeNum)
		if limitnum <= curExchangeNum then
			self.exChangeStatus = 2
		end
		local countStr = string.format("%d/%d", self.leftCount, limitnum)
		if limitType == 1 then
			_ENV = nil
			;(nil).count = countStr
			self.Text_leftCount:setString(i18n("exchange_columntext_01", nil))
		elseif limitType == 3 then
			_ENV = i18n("exchange_columntext_01", nil)
			i18n("exchange_columntext_01", nil).count = countStr
			self.Text_leftCount:setString(i18n("exchange_columntext_02", i18n("exchange_columntext_01", nil)))
		elseif limitType == 4 then
			_ENV = i18n("exchange_columntext_02", i18n("exchange_columntext_01", nil))
			i18n("exchange_columntext_02", i18n("exchange_columntext_01", nil)).cur = self.leftCount
			i18n("exchange_columntext_02", i18n("exchange_columntext_01", nil)).total = limitnum
			self.Text_leftCount:setString(i18n("common_text_4417", i18n("exchange_columntext_02", i18n("exchange_columntext_01", nil))))
		else
			_ENV = i18n("common_text_4417", i18n("exchange_columntext_02", i18n("exchange_columntext_01", nil)))
			i18n("common_text_4417", i18n("exchange_columntext_02", i18n("exchange_columntext_01", nil))).count = countStr
			self.Text_leftCount:setString(i18n("common_text_1673", i18n("common_text_4417", i18n("exchange_columntext_02", i18n("exchange_columntext_01", nil)))))
		end
	end
end
function exchangeSingle:setBtnExchangeStatus()
	if self.exChangeStatus == 0 then
		self.Button_exchange:setBright(true)
		self.Button_exchange:setTitleColor(cc.c3b(255, 255, 255))
	elseif self.exChangeStatus == 1 then
		self.Button_exchange:setBright(true)
		self.Button_exchange:setTitleColor(cc.c3b(255, 0, 0))
	elseif self.exChangeStatus == 2 then
		self.Button_exchange:setBright(false)
		self.Button_exchange:setTitleColor(cc.c3b(115, 115, 115))
	end
end
function exchangeSingle:setBtnFromData(data)
	local itemID = data[1]
	local needNum = data[2]
	local ownNum = self:getOwnCount(itemID)
	self.ownCount = ownNum
	local Image_itemBg = SoraDGetChildByName(self.Button_from, "Image_itemBg")
	local Image_item = SoraDGetChildByName(self.Button_from, "Image_item")
	local Text_total = SoraDGetChildByName(self.Button_from, "Text_total")
	Text_total = SoraDChangeTextToHtml(Text_total)
	Text_total:setFontSize(18)
	Image_itemBg:loadTexture(publicRead.getBg(itemID), ccui.TextureResType.plistType)
	Image_item:loadTexture(publicRead.getIcon(itemID), ccui.TextureResType.plistType)
	local stringColor = "#FFFFFF"
	if needNum > ownNum then
		stringColor = "#BE2828"
		self.exChangeStatus = 1
	else
		self.exChangeStatus = 0
	end
	_ENV = nil
	;(nil).member = ownNum
	_ENV, _ENV, (nil).total = nil, nil, needNum
	_ENV, (nil).member, (nil).color = nil, nil, stringColor
	;(nil).__default, (nil).color = nil, "#FFFFFF"
	Text_total:setString(i18n_html("common_text_155", nil, nil))
	self.Button_from:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended or event == ccui.TouchEventType.canceled then
			if self.tips then
				self.tips:setVisible(false)
			end
		elseif event == ccui.TouchEventType.began then
			SoraDPlaySound()
			if not self.tips then
				self.tips = SoraDCreatePanel("commonItemTips")
				self.tips:addTo(self.Panel_touch, 99)
			else
				self.tips:setVisible(true)
			end
			self.tips:initData(itemID)
			self.tips:setPosition(cc.p(SoraDFIsRA() and 480 or 150, 155))
		end
	end)
end
function exchangeSingle:getOwnCount(itemID)
	return backpackCtrl:getItemCount(itemID)
end
function exchangeSingle:setBtnToData(data)
	local itemID = data[1]
	local needNum = data[2]
	local Image_itemBg = SoraDGetChildByName(self.Button_to, "Image_itemBg")
	local Image_item = SoraDGetChildByName(self.Button_to, "Image_item")
	local Text_num = SoraDGetChildByName(self.Button_to, "Text_num")
	Text_num:setString(needNum)
	Image_itemBg:loadTexture(publicRead.getBg(self.itemID), ccui.TextureResType.plistType)
	Image_item:loadTexture(publicRead.getIcon(self.itemID), ccui.TextureResType.plistType)
	self.Button_to:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended or event == ccui.TouchEventType.canceled then
			if self.tips then
				self.tips:setVisible(false)
			end
		elseif event == ccui.TouchEventType.began then
			SoraDPlaySound()
			if not self.tips then
				self.tips = SoraDCreatePanel("commonItemTips")
				self.tips:addTo(self.Panel_touch, 99)
			else
				self.tips:setVisible(true)
			end
			self.tips:initData(itemID)
			self.tips:setPosition(cc.p(SoraDFIsRA() and 620 or 10, 155))
		end
	end)
end
function exchangeSingle:onBtnCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if self.exChangeStatus == 2 then
			SoraDShowMsgTip(i18n("common_text_1865"))
		elseif self.exChangeStatus == 1 then
			if IsArClient and self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_RAMADAN then
				SoraDShowMsgBox(i18n("common_text_2086"), i18n("common_text_204"), i18n("common_text_185"), function(boxEvent)
					if boxEvent == MSGBOX_CALLBACK_YES then
						if self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_RAMADAN then
							if GLOBAL_GAME_RECHARGE_MODE then
								_ENV = nil
								;(nil).toCategory = gRechargeCenterCategory.HOTGIFT
								uiManager:show("rechargeView", nil)
							else
								local panel = SoraDCreatePanel("rechargeView")
								panel:expect2SelectTab(gRechargeCenterCategory.HOTGIFT, self.activityID)
								panel:show()
							end
						else
							_ENV = gRechargeCenterCategory.HOTGIFT
							gRechargeCenterCategory.HOTGIFT.type = 1
							gRechargeCenterCategory.HOTGIFT.jumpStore = "btnOther"
							uiManager:show("bagView", gRechargeCenterCategory.HOTGIFT)
						end
					end
				end)
			elseif self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_SPIRITUAL_GIFT then
				if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SPIRITUAL_GIFT, true) then
					SoraDCreatePanel("spiritualGiftView"):show()
				end
			elseif self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_SNATCH_TREASURE then
				local eventState = activityShowCtrl:getStateByID(gActivityTimeActivityID.EXCHANGE_MALL_SNATCH_TREASURE)
				if eventState == gActivityState.OPEN then
					local panel = SoraDCreatePanel("raidersLostArkView")
					panel:show()
				else
					SoraDShowMsgTip(i18n("common_text_2486"))
				end
			else
				SoraDShowMsgTip(i18n("common_text_2512"))
			end
		else
			local maxNum = math.floor(self.ownCount / self.singleCount)
			local tempItemID = self.itemID
			if self.leftCount and self.leftCount > 0 then
				maxNum = math.min(math.floor(self.ownCount / self.singleCount), self.leftCount)
			end
			_ENV, _ENV, _ENV = i18n("common_text_2512")
			i18n("common_text_2512").targetID = self.itemID
			i18n("common_text_2512").exchangeID = self.toolID
			i18n("common_text_2512").singCount = self.singleCount
			i18n("common_text_2512").curNum = maxNum
			i18n("common_text_2512").exchangeData, i18n("common_text_2512").singleGet = i18n("common_text_2512")
			self.singleCount.exchangeCfg, i18n("common_text_2512").exchangeHandler = i18n("common_text_2512")
			uiManager:show("newShopSingleBuy", self.singleCount)
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function exchangeSingle:exChangeCallback(itemID, exchangeNum)
	exchangeMallCtrl:sendExchange(itemID, exchangeNum, self.activityID, self.exchangeItemID)
end
function exchangeSingle:onCheckBoxCallBack(button, event)
	if self.activityID == gActivityTimeActivityID.SULTAN_BACK_MAIN_ACTIVITY then
		if event == ccui.CheckBoxEventType.selected then
			SoraDPlaySound()
			activityExchangeMallCtrl:reqExchangeRemind(self.shopItemID, 1)
		elseif event == ccui.CheckBoxEventType.unselected then
			SoraDPlaySound()
			activityExchangeMallCtrl:reqExchangeRemind(self.shopItemID, 0)
		end
	elseif event == ccui.CheckBoxEventType.selected then
		SoraDPlaySound()
		exchangeMallCtrl:sendExchangeRemind(self.itemID, 1, self.activityID, self.exchangeItemID)
	elseif event == ccui.CheckBoxEventType.unselected then
		SoraDPlaySound()
		exchangeMallCtrl:sendExchangeRemind(self.itemID, 0, self.activityID, self.exchangeItemID)
	end
end
return exchangeSingle
