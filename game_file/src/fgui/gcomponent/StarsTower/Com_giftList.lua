local nebulastoreRead = include("nebulastoreRead")
local rechargeRead = include("rechargeRead")
local starlightPavilionCtrl = SoraDGetCtrl("starlightPavilionCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_giftList = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://StarsTower/Com_giftList", Com_giftList)
function Com_giftList:onInit()
	self.fields.List_award:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_award:addEventListener(fgui.UIEventType.Scroll, handler(self, self.onScrollItem))
	self.fields.bg:addClickListener(handler(self, self.onBgClick))
	self.fields.Lab_dis:fixPos()
	self.fields.Text_limit:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Com_oap:fixPos()
	self.fields.Com_sul:fixPos()
	self.fields.n33:fixPos()
	self.fields.Usm_1:fixPos()
	self.fields.Usm_2:fixPos()
	self.fields.Usm_1:setScaleX(SoraDFIsRA() and 1 or -1)
	self.fields.Usm_2:setScaleX(SoraDFIsRA() and 1 or -1)
end
function Com_giftList:onShow()
end
function Com_giftList:onScrollItem()
	if #self.giftArray > 4 then
		local offsetX = self.fields.List_award:getScrollPane():getPositionX()
		local listW = self.fields.List_award:getContentSize().width
		local scrollW = self.fields.List_award:getInnerContainerSize().width
		print("offsetX,listW,scrollW======", offsetX, listW, scrollW)
		if offsetX >= scrollW - listW then
			self.fields.nr:setVisible(false)
			self.fields.nl:setVisible(true)
		elseif offsetX <= 0 then
			self.fields.nl:setVisible(false)
			self.fields.nr:setVisible(true)
		else
			self.fields.nr:setVisible(true)
			self.fields.nl:setVisible(true)
		end
	else
		self.fields.nr:setVisible(false)
		self.fields.nl:setVisible(false)
	end
end
function Com_giftList:onItemRenderer(index, obj)
	obj:initData(tonumber(self.giftArray[index + 1].id), tonumber(self.giftArray[index + 1].num))
end
function Com_giftList:initDataWithActivityID(data, activityID)
	self.activityID = activityID
	if self.activityID == gActivityTimeActivityID.BUILD_THRIVING_ACTIVITY then
		_ENV = nil
		;(nil).ID = data.GiftId
		;(nil).frame = data.Frame
		;(nil).Type = data.Type
		self:initData(nil)
	elseif self.activityID == gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY or self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		self.fields.n28:setVisible(false)
		self.fields.n29:setVisible(false)
		data.ID = data.giftId
		self:initData(data)
	else
		self:initData(data)
	end
end
function Com_giftList:initData(data)
	self.rechargeID = data.ID
	local giftData = rechargeRead.getPageViewData(data.ID)
	local svrData = data
	local giftCount = 0
	if self.activityID == gActivityTimeActivityID.BUILD_THRIVING_ACTIVITY then
		local activity_9001496_Read = include("activity_9001496_Read")
		local activity_9001496_Ctrl = SoraDGetCtrl("activity_9001496_Ctrl")
		local cfg = activity_9001496_Read.getGiftCfg(data.ID)
		rechargeRead = data.ID
		data.ID.picture = activity_9001496_Read.getLabelPicture(data.Type)
		data.ID.extraData = cfg.ExtraData
		data.ID.discount = cfg.Discount
		data.ID.price = cfg.Price
		data.ID.originalPrice = cfg.OriginalPrice
		data.ID.gold = cfg.Gold
		svrData, data.ID.gift = data.ID, cfg.Gift
		giftCount = activity_9001496_Ctrl:getGiftCount(data.ID)
	elseif self.activityID == gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY then
		local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
		giftCount = nebulaEmperorCtrl:getGiftCount(data.ID)
	elseif self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		local nebulaAllStarCtrl = SoraDGetCtrl("nebulaAllStarCtrl")
		giftCount = nebulaAllStarCtrl:getGiftCount(data.ID)
	else
		giftCount = starlightPavilionCtrl:getGiftCount(data.ID)
	end
	self.fields.bg:setIcon(svrData.picture)
	if self.activityID == gActivityTimeActivityID.NEBULA_EMPEROR_ACTIVITY or self.activityID == gActivityTimeActivityID.NEBULA_ALL_STAR_ACTIVITY then
		self.fields.border:setSpriteFrame(string.format("frame_xydw_czlb_kuabf_%.2d.png", data.frame))
	else
		self.fields.border:setSpriteFrame(string.format("frame_xhge_kj_%.2d.png", data.frame))
	end
	self.fields.Usm_1:setVisible(data.frame == 2)
	self.fields.Usm_2:setVisible(data.frame == 3)
	self.fields.Lab_dis:setString(svrData.discount .. "%")
	self.discount = svrData.discount
	self.leftBuyCount = svrData.extraData - giftCount
	self.limit = svrData.extraData
	rechargeRead = string.format("frame_xhge_kj_%.2d.png", data.frame)
	string.format("frame_xhge_kj_%.2d.png", data.frame).cur = self.leftBuyCount
	string.format("frame_xhge_kj_%.2d.png", data.frame).total = svrData.extraData
	self.fields.Text_limit:setString(i18n("common_text_4417", string.format("frame_xhge_kj_%.2d.png", data.frame)))
	self.fields.Text_limit:setColor(0 < self.leftBuyCount and cc.c3b(255, 235, 104) or cc.c3b(190, 40, 40))
	self.fields.Text_name:setString(i18n(giftData.activeName))
	self.giftName = giftData.activeName
	starlightPavilionCtrl = i18n(giftData.activeName)
	i18n(giftData.activeName)[1] = "id"
	i18n(giftData.activeName)[2] = "num"
	self.giftArray = serviceFunctions.tableFormat(svrData.gift, i18n(giftData.activeName))
	if svrData.gold then
		rechargeRead = i18n(giftData.activeName)
		i18n(giftData.activeName).id = 1001
		i18n(giftData.activeName).num = svrData.gold
		table.insert(self.giftArray, i18n(giftData.activeName))
	end
	self.fields.List_award:setNumItems(#self.giftArray)
	self.fields.List_award:scrollToView(0)
	self:onScrollItem()
	local info = paymentManager.getPaymentBullets(data.ID)
	local priceStr, __ = paymentManager.getRealPrice(info and info.pid, svrData.price)
	local discount = svrData.originalPrice / svrData.price
	local oriPriceStr = paymentManager.calculateDiscount(data.ID, svrData.price, discount, svrData.originalPrice)
	self.priceStr = priceStr
	self.oriPriceStr = oriPriceStr
	rechargeRead = discount
	discount.rid = data.ID
	discount.nowPrice = priceStr
	rechargeRead, discount.oriPrice = data.ID, oriPriceStr
	discount.logInfo, data.ID.fromCenter = data.ID, gRechargeActiveFromEnum.ROAD42
	discount.handleBuyClick = handler(self, self.onClickBuyGift)
	discount.handleItemBuyClick = handler(self, self.onClickItemBuyGift)
	self.fields.Com_oap:initData(discount)
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SULTAN_EX_RECAHRGE_PRESENT) then
		self.fields.Com_sul:setVisible(true)
		self.fields.Com_sul:initData(self.rechargeID)
	else
		self.fields.Com_sul:setVisible(false)
	end
end
function Com_giftList:onClickItemBuyGift()
	SoraDPlaySound()
	if self.leftBuyCount <= 0 then
		SoraDShowMsgTip(i18n("Nebulastore_text_01"))
		return
	end
	return true
end
function Com_giftList:onClickBuyGift()
	SoraDPlaySound()
	if self.leftBuyCount > 0 then
		paymentManager.OnemtReadyBuy(self.rechargeID, gRechargeActiveFromEnum.ROAD42)
		paymentManager.normalGiftBuyClassify(self.rechargeID)
	else
		SoraDShowMsgTip(i18n("Nebulastore_text_01"))
	end
end
function Com_giftList:onBgClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).rechargeID = self.rechargeID
	;(nil).source = gRechargeActiveFromEnum.ROAD42
	;(nil).name = self.giftName
	;(nil).leftBuyCount = self.leftBuyCount
	;(nil).limit = self.limit
	;(nil).discount = self.discount
	;(nil).giftArray = self.giftArray
	;(nil).priceStr = self.priceStr
	;(nil).oriPriceStr = self.oriPriceStr
	uiManager:show("StarsTowerPopFrame", nil)
end
return Com_giftList
