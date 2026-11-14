local exchangeMallCtrl = SoraDGetCtrl("exchangeMallCtrl")
local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local exchangeSingle = fgui.extension_class(fgui.GComponent, baseComponent)
function exchangeSingle:onInit()
	self.exChangeStatus = 0
	self.CheckBox_notify = self.fields.CheckBox_notify
	self.CheckBox_notify:addClickListener(handler(self, self.onCheckBoxCallBack))
	self.Text_notify = self.fields.Text_notify
	self.Text_notify:setString(i18n("exchange_btn_01"))
	self.Button_exchange = self.fields.Button_exchange
	self.Button_exchange:setString(i18n("common_text_1889"))
	self.Button_exchange:addClickListener(handler(self, self.onBtnCallBack))
	self.Button_from = self.fields.Button_from
	self.Button_to = self.fields.Button_to
	self.Text_leftCount = self.fields.Text_leftCount
	if not SoraDFIsRA() then
		self:fixChildrenPos()
		self.fields.Sprite_line:fix()
		self.fields.Sprite_arrow:fix()
	end
end
function exchangeSingle:onShow()
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
	self.Button_from:initData(itemID)
	self.Button_from:setNum(self.ownCount, needNum)
	if needNum > ownNum then
		self.exChangeStatus = 1
	else
		self.exChangeStatus = 0
	end
end
function exchangeSingle:getOwnCount(itemID)
	return backpackCtrl:getItemCount(itemID)
end
function exchangeSingle:setBtnToData(data)
	local itemID = data[1]
	local needNum = data[2]
	self.Button_to:initData(itemID, needNum)
end
function exchangeSingle:onBtnCallBack()
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
end
function exchangeSingle:exChangeCallback(itemID, exchangeNum)
	exchangeMallCtrl:sendExchange(itemID, exchangeNum, self.activityID, self.exchangeItemID)
end
function exchangeSingle:onCheckBoxCallBack()
	SoraDPlaySound()
	if self.activityID == gActivityTimeActivityID.SULTAN_BACK_MAIN_ACTIVITY then
		if self.CheckBox_notify:isSelected() then
			activityExchangeMallCtrl:reqExchangeRemind(self.shopItemID, 1)
		else
			activityExchangeMallCtrl:reqExchangeRemind(self.shopItemID, 0)
		end
	elseif self.CheckBox_notify:isSelected() then
		exchangeMallCtrl:sendExchangeRemind(self.itemID, 1, self.activityID, self.exchangeItemID)
	else
		exchangeMallCtrl:sendExchangeRemind(self.itemID, 0, self.activityID, self.exchangeItemID)
	end
end
return exchangeSingle
