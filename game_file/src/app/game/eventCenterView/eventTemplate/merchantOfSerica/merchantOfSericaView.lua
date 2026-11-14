local merchantOfSericaCtrl = SoraDGetCtrl("merchantOfSericaCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local merchantOfSericaRead = include("merchantOfSericaRead")
local princeGiftCtrl = SoraDGetCtrl("princeGiftCtrl")
local Max_Num = 4
local merchantOfSericaView = class("merchantOfSericaView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("merchantOfSericaView")
	end
	return target
end)
function merchantOfSericaView:ctor(properties)
	SoraDGetAllChildFromWidget(self, self)
	self.flyList, _ENV, self.inFly = SoraDGetAllChildFromWidget, SoraDGetAllChildFromWidget, false
	self.activityID = gActivityTimeActivityID.MERCHANT_OF_SERICA
	merchantOfSericaCtrl:reqSericaInit()
	self.selectNodes = SoraDGetChildsArrayByName(self, "CCS_merchantOfSericaSelect_", 10, 1, true, true)
	self.getNodes = SoraDGetChildsArrayByName(self, "CCS_merchantOfSericaGet_", 4, 1, true, true)
	self.getEffect = SoraDGetChildsArrayByName(self, "FileNode_", 4, 1, true, false)
	self.Bottom_done = SoraDGetChildByName(self, "Bottom_done")
	self.Top_Button_quit = SoraDGetChildByName(self, "Top_Button_quit")
	self.Bottom_buy = SoraDGetChildByName(self, "Bottom_buy")
	self.Text_total = SoraDGetChildByName(self, "Text_total")
	self.Text_total:setColor(cc.c3b(255, 255, 255))
	self.Text_total = SoraDChangeTextToHtml(self.Text_total)
	self.Text_donew = SoraDGetChildByName(self, "Text_donew")
	self.Text_donew:setString(i18n("serica_text_06"))
	self.Text_ps = SoraDGetChildByName(self, "Text_ps")
	self.Text_title = SoraDGetChildByName(self, "Text_title")
	self.Text_day:setString(i18n("serica_text_09"))
	self.Text_7:setString(i18n("serica_text_08"))
	self.Bottom_done:setVisible(false)
	self.Text_ButtonName:setString(i18n("serica_text_14"))
	self.Text_ButtonName:setVisible(false)
	self.Bottom_buy:setVisible(false)
	self.Text_nowPrice = SoraDGetChildByName(self.Node_charge, "Text_nowPrice")
	self.Text_oriPrice = SoraDGetChildByName(self.Node_charge, "Text_oriPrice")
	self:initShopBtn()
	self:suitView()
	self.Bottom_Button_buy:addTouchEventListener(handler(self, self.buttonBuyPackageCallBack))
	self.Top_Button_quit:addTouchEventListener(handler(self, self.buttonQuit))
	SoraDCreatAnimation(self.__cname, self, true)
	self:initEffect()
end
function merchantOfSericaView:initEffect()
	dump(self.getEffect, "self.getEffect")
end
function merchantOfSericaView:suitView()
	local height = display.height
	if 1136 <= height then
		self.Bottom_buy:setPositionY(0)
		self.Bottom_done:setPositionY(0)
	end
	if height < 960 then
		self.bg_slsdsr_di_01_3:setPositionY(0)
		self.bg_slsdsr_di_02_4:setPositionY(-25)
		self.Center_Node_select:setScale(0.85)
		self.Center_Node_select:setPositionY(25)
		self.Node_ps:setPositionY(-170)
		self.Node_get:setPositionY(-265)
	end
end
function merchantOfSericaView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERICA_INIT", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERICA_SHOP", handler(self, self.OnBuyTheItems))
	SoraDAddMessage(self, "MESSAGE_SERICA_SELECT", handler(self, self.selectFlyToItem))
	SoraDAddMessage(self, "MESSAGE_SERICA_DELETE", handler(self, self.initData))
end
function merchantOfSericaView:initData()
	self:initSelectNode()
	self:initGetNode()
	self:initBuyBtn()
end
function merchantOfSericaView:OnBuyTheItems(target, data)
	local reward = data.reward
	local _ENV, itemData
	for i, v in ipairs(reward) do
		if v.id and v.count then
			_ENV = nil
			;(nil).id = v.id
			;(nil).count = v.count
			table.insert(itemData, nil)
		end
	end
	SoraDMailGainItems(itemData, true)
end
function merchantOfSericaView:initSelectNode()
	local data = merchantOfSericaRead.getConfigBygroup(merchantOfSericaCtrl:getServerGroup())
	for k, v in ipairs(data) do
		merchantOfSericaRead = merchantOfSericaCtrl:getServerGroup()
		merchantOfSericaCtrl:getServerGroup().data = v
		merchantOfSericaCtrl:getServerGroup().view = self
		self.selectNodes[k]:initWithData(merchantOfSericaCtrl:getServerGroup())
	end
end
function merchantOfSericaView:initGetNode(index)
	local list = merchantOfSericaCtrl:getCommodityList()
	local length = list and #list or 0
	if index then
		if index > length then
			print("飞行过程中-----")
			for i = 1, index do
				merchantOfSericaCtrl = nil
				;(nil).data = i
				;(nil).view = self
				self.getNodes[i]:initWithData(nil)
			end
		else
			merchantOfSericaCtrl = 1
			;(1).data = index
			;(1).view = self
			self.getNodes[index]:initWithData(1)
		end
	else
		for i = 1, Max_Num do
			merchantOfSericaCtrl = nil
			;(nil).data = i
			;(nil).view = self
			self.getNodes[i]:initWithData(nil)
		end
	end
end
function merchantOfSericaView:initBuyBtn()
	local flag = merchantOfSericaCtrl:getServerFlag()
	local list = merchantOfSericaCtrl:getSelectList()
	local num = #list and #list or 0
	local show = num < 4
	self.Image_btn:setVisible(show)
	self.Text_ButtonName:setVisible(show)
	self.Node_charge:setVisible(not show)
	if not flag then
		self.Bottom_done:setVisible(false)
		self.Bottom_buy:setVisible(true)
		self.Node_ps:setVisible(true)
		merchantOfSericaCtrl = nil
		;(nil).var = num
		merchantOfSericaCtrl, merchantOfSericaCtrl, (nil).var1 = nil, nil, num
		merchantOfSericaCtrl, (nil).var, (nil).color = nil, nil, "#fcdc00"
		merchantOfSericaCtrl, (nil).var1, (nil).color = nil, nil, "#fcdc00"
		;(nil).__default, (nil).color = nil, "#ffffff"
		self.Text_total:setString(i18n_html("serica_text_04", nil, nil))
	else
		self.Bottom_done:setVisible(true)
		self.Node_ps:setVisible(false)
		self:initrestTime()
		self.Bottom_buy:setVisible(false)
	end
	self:updateOutAppPurchase(not flag, not show)
end
function merchantOfSericaView:initTime(price)
	self.text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.text_time:setTimeLast(function(time)
		_ENV = nil
		;(nil).var = time
		return i18n("serica_text_10", nil)
	end)
	local timer = activityShowCtrl:getTimeInfoByID(self.activityID)
	if timer then
		local leftTime = timer.timerNode.timer:getRemainTime()
		self.text_time:beginTime(leftTime)
	end
end
function merchantOfSericaView:initrestTime()
	if not self.text_flash then
		self.text_flash = SoraDCreateTimerLabel(self, self.Text_restTime)
	end
	self.text_flash:setTimeLast(function(time)
		_ENV = nil
		;(nil).var = time
		return i18n("serica_text_07", nil)
	end)
	local lefttime = serviceFunctions.getTodayRemainTime()
	self.text_flash:beginTime(lefttime)
end
function merchantOfSericaView:initShopBtn()
	local Info = merchantOfSericaRead.getPackageInfo()
	local nowPrice = paymentManager.judgePrice(Info.giftBagId, Info.price)
	self.nowPrice = nowPrice
	self.Text_nowPrice:setString(tostring(nowPrice))
	local discount = Info.originalPrice / Info.price
	local showDiscount = math.floor(Info.originalPrice / Info.price * 100)
	local oriPrice = paymentManager.calculateDiscount(Info.giftBagId, nowPrice, discount, Info.originalPrice)
	self.oriPrice = oriPrice
	self.Text_oriPrice:setString(tostring(oriPrice))
	self.Text_discount:setString(SoraDFIsRA() and string.format("%s%d", "%", showDiscount) or string.format("%d%s", showDiscount, "%"))
	self.Bottom_Button_buy:setTag(Info.giftBagId)
	self.giftID = Info.giftBagId
	self:initTime(nowPrice)
end
function merchantOfSericaView:buttonBuyPackageCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local list = merchantOfSericaCtrl:getSelectList()
		if #list == Max_Num then
			self:orderCompleted()
		elseif #list < Max_Num then
			SoraDShowMsgTip(i18n("serica_text_03"))
		end
	end
end
function merchantOfSericaView:buttonQuit(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function merchantOfSericaView:orderCompleted()
	paymentManager.normalGiftBuyClassify(self.Bottom_Button_buy:getTag())
	paymentManager.OnemtReadyBuy(self.Bottom_Button_buy:getTag(), gRechargeActiveFromEnum.ROAD13, false, nil, nil, self.activityID)
end
function merchantOfSericaView:selectFlyToItem(target, data)
	local list = merchantOfSericaCtrl:getCommodityList()
	local length = list and #list or 0
	local itemId = data.id
	local item
	local num = merchantOfSericaRead.getNumById(item, merchantOfSericaCtrl:getServerGroup())
	num = num and num or 0
	local index = data.commodityID
	local line = math.floor(index / 4) + 1
	local star = self.selectNodes[index]
	local endIndex = SoraDFIsRA() and Max_Num + 1 - length or length
	local endItem = self.getNodes[endIndex]
	local starPos = SoraDCoverToPoint(star, cc.p(0, 0), self.Node_fly)
	local endPos = SoraDCoverToPoint(endItem, cc.p(0, 0), self.Node_fly)
	local lineLength = serviceFunctions.lineSpace(starPos.x, starPos.y, endPos.x, endPos.y)
	local flyItem = self:createFlyItem(itemId, num, length)
	local actMoveTo = cca.moveTo(lineLength / 1000, endPos)
	local call = cc.CallFunc:create(function()
		self = nil
		;(nil).index = endIndex
		self:flyDone(flyItem, nil)
	end)
	function _ENV()
		self = nil
		;(nil).index = endIndex
		self:flyDone(flyItem, nil)
	end
	;(function()
		self = nil
		;(nil).index = endIndex
		self:flyDone(flyItem, nil)
	end)[1] = actMoveTo
	;(function()
		self = nil
		;(nil).index = endIndex
		self:flyDone(flyItem, nil)
	end)[2] = call
	local seq = cca.seq(function()
		self = nil
		;(nil).index = endIndex
		self:flyDone(flyItem, nil)
	end)
	flyItem:setPosition(starPos)
	flyItem:setVisible(true)
	flyItem:runAction(seq)
	self.inFly = true
end
function merchantOfSericaView:flyDone(target, data)
	target:setVisible(false)
	self:initGetNode(data.index)
	self:initBuyBtn()
end
function merchantOfSericaView:createFlyItem(id, num, index)
	local item = self.flyList[index]
	if not item then
		local item = include("commonItemAward").new()
		item:setVisible(false)
		item:initData(id, num)
		item:setTouchEnabled(false)
		item:addTo(self.Node_fly)
		self.flyList[index] = item
	else
		item:setVisible(false)
		item:initData(id, num)
		item:setTouchEnabled(false)
	end
	return self.flyList[index]
end
function merchantOfSericaView:judgeClose()
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
function merchantOfSericaView:updateOutAppPurchase(isShow, isShowCharge)
	if isShow and SoraDCheckOAPIsOpen(self.giftID) then
		if not self.outAppPurchaseButtons then
			self.outAppPurchaseButtons = include("outAppPurchaseButtons").new()
			self.outAppPurchaseButtons:addTo(self.Bottom_buy:getParent())
			self.outAppPurchaseButtons:setPosition(cc.p(320, 53))
		end
		self.outAppPurchaseButtons:setVisible(isShowCharge)
		self.Bottom_buy:setVisible(not isShowCharge)
		_ENV = not isShowCharge
		;(not isShowCharge).rid = self.giftID
		;(not isShowCharge).nowPrice = self.nowPrice
		_ENV, (not isShowCharge).oriPrice = self.oriPrice, self.oriPrice
		self.oriPrice.fromCenter = gRechargeActiveFromEnum.ROAD13
		;(not isShowCharge).logInfo, self.oriPrice.activityID = self.oriPrice, self.activityID
		;(not isShowCharge).handleItemBuyClick = handler(self, self.handleItemBuyBack)
		;(not isShowCharge).handleBuyClick = handler(self, self.buttonBuyPackageCallBack)
		self.outAppPurchaseButtons:initData(not isShowCharge)
	elseif self.outAppPurchaseButtons then
		self.outAppPurchaseButtons:setVisible(false)
	end
end
function merchantOfSericaView:handleItemBuyBack()
	local list = merchantOfSericaCtrl:getCommodityList()
	if #list == Max_Num then
		merchantOfSericaCtrl = Max_Num
		Max_Num.items = list
		return true, Max_Num
	elseif #list < Max_Num then
		SoraDShowMsgTip(i18n("serica_text_03"))
		return false
	end
end
return merchantOfSericaView
