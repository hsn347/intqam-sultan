local sultansBackRebateUtil = include("sultansBackRebateUtil")
local RECHARGE_GIFT_STATUES = sultansBackRebateUtil.RECHARGE_GIFT_STATUES
local publicRead = include("publicRead")
local sultansBackRebateGiftPopView = class("sultansBackRebateGiftPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("sultansBackRebateGiftPopView")
	end
	return target
end)
function sultansBackRebateGiftPopView:ctor()
	self.tableItems, _ENV = nil, nil
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("hero_title_02"))
	self.btn_ok = SoraDGetChildByName(self, "btn_ok")
	self.btn_ok:addTouchEventListener(handler(self, self.onClick_btn_operate))
	self.scroll_items = SoraDGetChildByName(self, "scroll_items")
	self.item_single = SoraDGetChildByName(self, "Node_single")
	self.tableItems[1] = self.item_single
end
function sultansBackRebateGiftPopView:initData(data)
	self.data = data
	self.curGiftID = self.data.rechargeID
	local showPrice = paymentManager.judgePrice(self.curGiftID, self.data.price)
	self.btn_ok:setTitleText(showPrice)
	_UPVALUE2_ = showPrice
	showPrice[1] = "id"
	showPrice[2] = "count"
	local rewards = serviceFunctions.tableFormat(self.data.rewards, showPrice)
	local newH = math.max(self.scroll_items:getContentSize().height, #rewards * 90)
	self.scroll_items:setInnerContainerSize(cc.size(self.scroll_items:getContentSize().width, newH))
	for k, v in ipairs(rewards) do
		if not self.tableItems[k] then
			self.tableItems[k] = self.item_single:clone()
			self.tableItems[k]:addTo(self.scroll_items)
		end
	end
	for k, v in ipairs(self.tableItems) do
		v:setPosition(SoraDFPosX(0, self.scroll_items:getContentSize().width), newH - 90 * k)
		local text_name = SoraDGetChildByName(v, "text_name")
		local text_num = SoraDGetChildByName(v, "text_num")
		local img_bg_item = SoraDGetChildByName(v, "img_bg_item")
		local ccs_item = SoraDGetExtendChildFromCCSByName(v, "CCS_commonItemAward_item")
		text_name:setString(publicRead.getName(rewards[k].id))
		text_num:setString("X" .. string.formatnumberthousands(rewards[k].count))
		img_bg_item:setVisible(k % 2 == 0)
		ccs_item:initData(rewards[k].id, rewards[k].count)
		ccs_item:setScale(0.7)
		ccs_item:setBaseScale(1.0)
		ccs_item:hideNum()
		ccs_item:setTouchEnabled(false)
	end
end
function sultansBackRebateGiftPopView:onClick_btn_operate(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local statues = self.data.statues
		if statues == RECHARGE_GIFT_STATUES.RECHARGE_GIFT_STATUES_NORMAL then
			_ENV = nil
			;(nil).price = self.data.extralimit
			SoraDShowMsgTip(i18n("back_recharge_text12", nil))
		elseif statues == RECHARGE_GIFT_STATUES.RECHARGE_GIFT_STATUES_FORBID_NUM then
			SoraDShowMsgTip(i18n("back_recharge_text13"))
		elseif statues == RECHARGE_GIFT_STATUES.RECHARGE_GIFT_STATUES_COMPLETE then
			paymentManager.normalGiftBuyClassify(self.curGiftID)
			paymentManager.OnemtReadyBuy(self.curGiftID, gRechargeActiveFromEnum.ROAD16)
			self:removeFromParent()
		end
	end
end
return sultansBackRebateGiftPopView
