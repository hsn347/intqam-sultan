local gametop = gModuleMgr.getObject("gametop")
local luxuryRebateCtrl = gametop.playertop_:getModule("luxuryRebateCtrl")
local luxuryRebateRead = include("luxuryRebateRead")
local luxuryRebateGiftView = class("luxuryRebateGiftView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("luxuryRebateGiftView")
	end
	return target
end)
function luxuryRebateGiftView:ctor()
	self.txtTitle = SoraDGetChildByName(self, "Text_Title")
	self.btnResurgence = SoraDGetChildByName(self, "Button_resurgence")
	self.btnResurgence:setBright(true)
	self.txtBoxTitle = SoraDGetChildByName(self, "Text_box_title")
	self.txtInfoTitle = SoraDGetChildByName(self, "Text_info_title")
	self.txtInfoDay = SoraDGetChildByName(self, "Text_info_day")
	self.txtInfoStatus = SoraDGetChildByName(self, "Text_info_status")
	self.txtAwardTitle = SoraDGetChildByName(self, "Text_AwardTitle")
	self.btnClose = SoraDGetChildByName(self, "Button_close")
	self.btnSure = SoraDGetChildByName(self, "Button_Sure")
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
	self.btnClose:addTouchEventListener(handler(self, self.onClickClose))
	self.btnSure:addTouchEventListener(handler(self, self.onClickSure))
	self.btnBuy = SoraDGetChildByName(self, "Button_buy")
	self.btnBuy:addTouchEventListener(handler(self, self.onClickBuy))
	self.txtTitle:setString(i18n("PrideRebate_text_06"))
	self.txtBoxTitle:setString(i18n("PrideRebate_text_06"))
	_G.SoraDChangeTextToHtml(self.txtInfoDay)
	_G.SoraDChangeTextToHtml(self.txtInfoStatus)
	self.txtAwardTitle:setString(i18n("PrideRebate_text_07"))
	self:initView()
	SoraDCreatAnimation("luxuryRebateGiftView", self)
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self:panelScaleAct()
end
function luxuryRebateGiftView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_LUXURY_REBATE_REFRESH", handler(self, self.updateView))
	SoraDAddMessage(self, "MESSAGE_LUXURY_REBATE_BOX_RSP", handler(self, self.rspDispatchBack))
	SoraDAddMessage(self, "MESSAGE_RECHARGE_PRESENT_REFRESH_ACTIVE", handler(self, self.initView))
end
function luxuryRebateGiftView:rspDispatchBack(target, data)
	SoraDCloseLoading(self)
	if data.err ~= gErrDef.Err_None then
		self:removeFromParent()
	elseif self.request then
		local rewardList = luxuryRebateRead.getBoxAwardItem()
		if rewardList and 0 < #rewardList then
			SoraDMailGainItems(rewardList, true)
		end
	end
	self.request = false
end
function luxuryRebateGiftView:initView()
	self:setAward()
	self:updateView()
	local giftId = luxuryRebateRead.getGiftID()
	luxuryRebateRead, _ENV = nil, nil
	;(nil).rechargeID = giftId
	;(nil)[1] = nil
	SoraDCreateRechargeGiftNode(nil, self.btnSure:getParent(), cc.p(SoraDFPosX(-50, 0), -498), 0.8)
end
function luxuryRebateGiftView:updateView()
	self:updateBox()
	self:updateBtn()
end
function luxuryRebateGiftView:updateBtn()
	if luxuryRebateCtrl:isBoxRewardGet() then
		self.btnSure:setTitleText(i18n("common_text_1892"))
		self.btnSure:setBright(false)
		self.btnSure:setTouchEnabled(false)
	else
		self.btnSure:setBright(true)
		self.btnSure:setTouchEnabled(true)
		if luxuryRebateCtrl:checkCanGetBox() then
			self.btnSure:setTitleText(i18n("common_text_1146"))
		else
			self.btnSure:setTitleText(i18n("common_text_204"))
		end
	end
end
function luxuryRebateGiftView:updateBox()
	if luxuryRebateCtrl:isBoxRewardGet() then
		self.txtInfoTitle:setString(i18n("PrideRebate_text_03"))
	else
		self.txtInfoTitle:setString(i18n("PrideRebate_text_02"))
	end
	do
		local numColor, status, width
		if luxuryRebateCtrl:isSpuerReward() then
			numColor = cc.c3b(255, 255, 255)
			status = i18n("common_text_3833")
			width = 250
			self.btnBuy:setVisible(false)
		else
			numColor = cc.c3b(255, 0, 0)
			status = i18n("PrideRebate_text_05")
			width = 150
			local giftId = luxuryRebateRead.getGiftID()
			local price = luxuryRebateRead.getGiftPrice()
			local goldStr = paymentManager.judgePrice(giftId, price)
			self.btnBuy:setTitleText(goldStr)
			self.btnBuy:setVisible(true)
		end
		luxuryRebateCtrl = paymentManager.judgePrice(giftId, price)
		luxuryRebateCtrl, luxuryRebateCtrl, paymentManager.judgePrice(giftId, price).status = self.btnBuy, self.btnBuy.setVisible, status
		self.btnBuy.setVisible.status, self.btnBuy.color = self.btnBuy, numColor
		local strDes = _G.i18n_html("PrideRebate_text_27", paymentManager.judgePrice(giftId, price), self.btnBuy.setVisible)
		self.txtInfoStatus:setString(strDes)
		_G.SoraDGetAutoHeightLabelNew(self.txtInfoStatus, width, true)
	end
	do
		local rechargeDay = luxuryRebateCtrl:getRechargeRewardDay()
		local numColor
		if rechargeDay >= luxuryRebateRead.getBoxAwardDay() then
			numColor = cc.c3b(255, 255, 255)
		else
			numColor = cc.c3b(255, 0, 0)
		end
		luxuryRebateCtrl = 0
		luxuryRebateCtrl, luxuryRebateCtrl, (0).num = width, 0, rechargeDay
		;(0).num, width.color = width, numColor
		local strDes = _G.i18n_html("PrideRebate_text_04", 0, 0)
		self.txtInfoDay:setString(strDes)
		_G.SoraDGetAutoHeightLabelNew(self.txtInfoDay, 250, true)
	end
end
function luxuryRebateGiftView:onClickClose(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:removeFromParent()
	end
end
function luxuryRebateGiftView:onClickSure(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if luxuryRebateCtrl:checkCanGetBox() then
			luxuryRebateCtrl:reqLuxuryRebateLuxuryBox()
			self.request = true
			SoraDShowLoading(self)
		else
			self:removeFromParent()
		end
	end
end
function luxuryRebateGiftView:onClickBuy(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("luxuryRebateBuyView"):show()
		self:removeFromParent()
	end
end
local MAX_ROW_NUM = 5
local WIDTH = 80
function luxuryRebateGiftView:setAward()
	self.nodeAward:removeAllChildren(true)
	local rewardList = luxuryRebateRead.getBoxAwardItem()
	local rechargePresentUtil = include("rechargePresentUtil")
	local fixData = rechargePresentUtil.fixRechargePresentData(luxuryRebateRead.getGiftID(), rewardList)
	rewardList = fixData.gift
	local luxuryRebateRead, item = luxuryRebateRead.getGiftID(), luxuryRebateRead.getGiftID()
	local posy = -10
	for _, v in ipairs(rewardList) do
		table.insert(item, v)
		if #item >= MAX_ROW_NUM then
			self:setAward_imp(item, posy)
			item, luxuryRebateRead, posy = WIDTH, WIDTH, posy - WIDTH
		end
	end
	self:setAward_imp(item, posy)
end
function luxuryRebateGiftView:setAward_imp(rewardList, posY)
	local rechargePresentUtil = include("rechargePresentUtil")
	local num = #rewardList > MAX_ROW_NUM and MAX_ROW_NUM or #rewardList
	local width = WIDTH * (num - 1) * 0.5
	for _, v in ipairs(rewardList) do
		local single = include("commonItemAward").new()
		single:setScale(0.7)
		single:setBaseScale(1.0)
		single:setOwnView(self)
		local posX = SoraDFPosX(width, 0)
		width = width - WIDTH
		single:setPosition(cc.p(posX, posY))
		single:addTo(self.nodeAward)
		if rechargePresentUtil.checkShowHighLight(v.id) then
			single:setCoolSquare()
		else
			single:hideCoolSquare()
		end
		single:initData(v.id, v.count)
	end
end
return luxuryRebateGiftView
