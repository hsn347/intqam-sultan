local gametop = gModuleMgr.getObject("gametop")
local rechargeActivityCtrl = gametop.playertop_:getModule("rechargeActivityCtrl")
local rechargeRead = include("rechargeRead")
local publicRead = include("publicRead")
local RechargeViewTakeNode = class("rechargeViewTakeNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("rechargeViewTakeNode")
	end
	return target
end)
function RechargeViewTakeNode:ctor()
	self.takeDate, _ENV = nil, nil
	self.scrollBuff = SoraDGetChildByName(self, "ScrollView_buff")
	self.labelTitle = SoraDGetChildByName(self, "Text_title")
	self.bottomNode = SoraDGetChildByName(self, "Bottom_node")
	self.labelUnder = SoraDGetChildByName(self, "Text_under")
	self.labelUnder:setTextHorizontalAlignment(SoraDFLabelR())
	self.nodeOnce = SoraDGetChildByName(self, "Node_once")
	self.btnOnce = SoraDGetChildByName(self, "Button_once")
	self.labelOnce = SoraDGetChildByName(self, "Text_once")
	self.nodeLong = SoraDGetChildByName(self, "Node_long")
	self.btnLong = SoraDGetChildByName(self, "Button_long")
	self.labelLong = SoraDGetChildByName(self, "Text_long")
	self.textLongFree = SoraDGetChildByName(self, "Text_free")
	self.textLongFree = SoraDChangeTextToHtml(self.textLongFree)
	self.nodeLine = SoraDGetChildByName(self, "Node_line")
	self.labelGetTitle = SoraDGetChildByName(self, "Text_getTitle")
	self.scrollItem = SoraDGetChildByName(self, "ScrollView_item")
	self.itemNode = display.newNode()
	self.itemNode:addTo(self.scrollItem)
	self.itemNode:setPosition(320, 0)
	self.nodePolicy = SoraDGetChildByName(self, "Node_policy")
	self.btnPolicy = SoraDGetChildByName(self, "Button_policy")
	self.labelPolicy = SoraDGetChildByName(self, "Text_policy")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.nodeTitle = SoraDGetChildByName(self, "Node_title")
	self.labelTitleName = SoraDGetChildByName(self, "Text_title_name")
	self.labelTitle1 = SoraDGetChildByName(self, "Text_title_1")
	self.labelTitle2 = SoraDGetChildByName(self, "Text_title_2")
	self.nodeSingle = SoraDGetChildByName(self, "Node_single")
	self.btnLong:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnOnce:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClickCallBack))
	self.btnPolicy:addTouchEventListener(handler(self, self.btnHelpClickCallBack))
	self:initData()
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_TAKE_REFRESH", handler(self, self.refreshNode))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_ACTIVETIMEOUT", handler(self, self.refreshNode))
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_REFRESH", handler(self, self.refreshNode))
	SoraDAddMessage(self, "MESSAGE_CLIENT_RECHARGECENTER_DAYFIRST", handler(self, self.refreshNode))
end
function RechargeViewTakeNode:refreshNode()
	self:updateButton(true)
	SoraDCloseLoading()
end
function RechargeViewTakeNode:btnHelpClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.btnPolicy == button then
			userSDKManager.openSDKLink(gSvrConfig.linkUrlConfig.service)
		else
			_ENV = "subscribe_gift_text_04"
			;("subscribe_gift_text_04").align = SoraDFLabelR()
			SoraDShowHelpMsgTip(i18n("subscribe_gift_text_04"), "subscribe_gift_text_04")
		end
	end
end
function RechargeViewTakeNode:btnClickCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if button == self.btnLong then
		else
		end
		if self.takeDate.isbuy == false then
			local showMsg = device.platform == "android" and i18n("subscribe_gift_text_09") or i18n("subscribe_gift_text_08")
			SoraDShowMsgBox(showMsg, i18n("common_text_204"), nil, function(type)
				if type == MSGBOX_CALLBACK_YES then
					paymentManager.normalGiftBuyClassify(self.takeDate.ID)
				end
			end)
		elseif not self.takeDate.isdayget then
			rechargeActivityCtrl:getMonthAwardReq(self.takeDate.ID)
			SoraDShowLoading()
		end
	end
end
function RechargeViewTakeNode:updateLabel()
	_ENV = nil
	;(nil).num = self.takeDate.gold
	self.labelTitle1:setString(i18n("subscribe_gift_text_01", nil) .. "\n" .. i18n("subscribe_gift_text_02"))
	self.labelTitleName:setString(i18n(rechargeRead.getPageViewData(self.takeDate.ID).activeName))
	self.labelGetTitle:setString(i18n("subscribe_gift_text_06"))
	self.labelTitle:setString(i18n("subscribe_gift_text_07"))
	self.labelOnce:setString(i18n("subscribe_gift_text_12"))
	self.labelPolicy:setString(i18n("common_text_3422"))
	self.labelUnder:setString(device.platform == "android" and i18n("subscribe_gift_text_15") or i18n("subscribe_gift_text_14"))
	SoraDToCenter(self.nodeTitle)
end
function RechargeViewTakeNode:initData(...)
	self.takeDate = rechargeActivityCtrl:getTakeActivityList()
	dump(self.takeDate, "self.takeDate", 10)
	self:updateView()
end
function RechargeViewTakeNode:updateButton(isUpdate)
	if isUpdate then
		self.takeDate = rechargeActivityCtrl:getTakeActivityList()
	end
	local starTime = serviceFunctions.systemTime()
	if self.takeDate.isbuy then
		starTime = rechargeActivityCtrl:getRechargeLeftTime(self.takeDate.ID) + serviceFunctions.systemTime() - 604800
		if self.timer == nil then
			self.timer = SoradCreateTimer(self, handler(self, self.updateTime))
		end
		self:updateTime()
		self.labelLong:setString("")
		self.textLongFree:setString("")
		if self.takeDate.isdayget then
			self.btnLong:setTitleText(i18n("subscribe_gift_btn_03"))
		else
			self.btnLong:setTitleText(i18n("common_text_854"))
		end
	else
		if self.timer then
			SoraDManagerRemoveTimer(self, self.timer)
			self.timer = nil
		end
		local originalPrice = paymentManager.judgePrice(self.takeDate.ID, self.takeDate.price)
		local price = paymentManager.judgePrice(self.takeDate.ID, self.takeDate.price)
		self.btnOnce:setTitleText(originalPrice)
		if rechargeActivityCtrl:isTakeFree(self.takeDate.ID) then
			rechargeActivityCtrl = i18n("common_text_854")
			i18n("common_text_854").price = originalPrice
			rechargeActivityCtrl, rechargeActivityCtrl, i18n("common_text_854").tips = "recharge_sub_1", i18n("recharge_sub_1"), i18n("recharge_sub_1")
			rechargeActivityCtrl, i18n("recharge_sub_1").price, ("recharge_sub_1").color = "recharge_sub_1", "recharge_sub_1", "#FFFFFF"
			rechargeActivityCtrl, i18n("recharge_sub_1").tips, ("recharge_sub_1").color = "recharge_sub_1", "recharge_sub_1", "#00FF00"
			i18n("recharge_sub_1").__default, ("recharge_sub_1").color = "recharge_sub_1", "#FFFF00"
			self.textLongFree:setString(i18n_html("recharge_sub_2", i18n("common_text_854")))
			rechargeActivityCtrl = i18n_html("recharge_sub_2", i18n("common_text_854"))
			i18n_html("recharge_sub_2", i18n("common_text_854")).price1 = originalPrice
			i18n_html("recharge_sub_2", i18n("common_text_854")).price2 = price
			self.labelLong:setString(i18n("subscribe_gift_text_10", i18n_html("recharge_sub_2", i18n("common_text_854"))))
		else
			self.labelLong:setString("")
			self.textLongFree:setString("")
			self.btnLong:setTitleText(i18n("subscribe_gift_btn_01") .. price)
		end
	end
	self.btnLong:setTouchEnabled(not self.takeDate.isdayget)
	self.btnLong:setBright(not self.takeDate.isdayget)
	rechargeActivityCtrl = i18n("subscribe_gift_btn_01") .. price
	;(i18n("subscribe_gift_btn_01") .. price).time1 = SoraDConvertTimeToYear(starTime)
	;(i18n("subscribe_gift_btn_01") .. price).time2 = SoraDConvertTimeToYear(starTime + 604800)
	self.labelTitle2:setString(i18n(self.takeDate.isbuy and "subscribe_gift_text_16" or "subscribe_gift_text_03", i18n("subscribe_gift_btn_01") .. price))
end
function RechargeViewTakeNode:updateTime()
	local leftTime = rechargeActivityCtrl:getRechargeLeftTime(self.takeDate.ID)
	rechargeActivityCtrl = nil
	;(nil).time = SoraDConvertSecondToString(leftTime)
	self.labelLong:setString(i18n("subscribe_gift_text_11", nil))
	if leftTime < 0 then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
end
function RechargeViewTakeNode:updateView()
	self:adapterView()
	self:updateLabel()
	self:updateItemScroll()
	self:updateBuffScroll()
	self:updateButton()
end
function RechargeViewTakeNode:adapterView()
	local offsetY = 0
	if display.height < 900 then
		offsetY = -50
	elseif display.height > 960 then
		offsetY = 50
	end
	self.bottomNode:setPositionY(200 - display.height)
	self.scrollBuff:setContentSize(cc.size(640, display.height - 200 - 235 - 340 - 50 - offsetY))
	self.nodeLong:setPosition(0, self.nodeLong:getPositionY() + offsetY)
	self.nodeOnce:setVisible(false)
	self.labelUnder:setContentSize(cc.size(610, 110 + offsetY))
	SoraDGetChildByName(self, "Sprite_sheer_line"):setPositionY(120 + offsetY)
	SoraDGetChildByName(self, "Image_bottom"):setContentSize(cc.size(640, 235 + offsetY))
end
function RechargeViewTakeNode:updateItemScroll()
	local _ENV, itemData
	if not self.takeDate.gift then
		_ENV = self.takeDate.gift
	end
	local tmpList = SoraDStringSplit(self.takeDate.gift, ",")
	for i = 1, #tmpList / 2 do
		local id = tmpList[2 * i - 1]
		local count = tmpList[2 * i]
		_ENV = nil
		;(nil).id = id
		;(nil).count = count
		table.insert(itemData, nil)
	end
	if itemData and next(itemData) then
		for i, v in ipairs(itemData) do
			local _item = include("commonItemAward").new()
			if tonumber(v.id) == gIDDef.GOLD then
				_item:showCoolSquare()
			end
			_item:setScale(0.8)
			_item:setOwnView(display.getRunningScene())
			_item:initData(v.id, v.count)
			_item:setPositionY(45)
			_item:addTo(self.itemNode)
		end
		SoraDToCenter(self.itemNode, 90, SoraDFIsRA())
	end
end
function RechargeViewTakeNode:createMonthSingle(tbl)
	local item = self.nodeSingle:clone()
	local singleItemIcon = item:getChildByName("Image_singleItemBg"):getChildByName("Image_singleItemIcon")
	local singleDes = item:getChildByName("Text_singleDes")
	local singleTitle = item:getChildByName("Text_singleTitle")
	local itemInfo = rechargeRead.getBuffMonthInfoByID(tbl.id)
	if next(itemInfo) then
		singleItemIcon:loadTexture(itemInfo.pictureName, ccui.TextureResType.plistType)
		singleItemIcon:setScale(0.6)
		singleTitle:setString(i18n(itemInfo.rewardName))
		singleDes:setString(itemInfo.rewardBonus)
	end
	item:setVisible(true)
	return item
end
function RechargeViewTakeNode:updateBuffScroll(...)
	local _ENV, buffData
	if self.takeDate.buff and next(self.takeDate.buff) then
		for i, v in ipairs(self.takeDate.buff) do
			_ENV = nil
			;(nil).id = v
			table.insert(buffData, nil)
		end
	end
	local sH = math.max(100 * math.ceil(0.5 * #buffData), self.scrollBuff:getContentSize().height)
	self.scrollBuff:setInnerContainerSize(cc.size(640, sH))
	for i, v in ipairs(buffData) do
		local item = self:createMonthSingle(v)
		item:setPosition(SoraDFPoint(170 + i % 2 * 300, sH - math.floor((i - 1) / 2) * 100 - 2))
		item:addTo(self.scrollBuff)
	end
end
return RechargeViewTakeNode
