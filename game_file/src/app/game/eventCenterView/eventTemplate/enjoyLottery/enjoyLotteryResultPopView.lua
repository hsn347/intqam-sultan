local enjoyLotteryResultPopView = class("enjoyLotteryResultPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("enjoyLotteryResultPopView")
	end
	return target
end)
function enjoyLotteryResultPopView:ctor()
	self.isAddToPopManager = true
	self.lotteryCounts = SoraDGetCtrl("backpackCtrl"):getItemCount(852101)
	self:bandWidget()
end
function enjoyLotteryResultPopView:bandWidget()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:hideTitle()
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	_UPVALUE1_ = "Center_Node"
	;("Center_Node")[1] = "Node_content"
	self.Node_content = SoraDGetChildByFullPath(self.Center_Node, "Center_Node")
	_UPVALUE2_ = "Center_Node"
	;("Center_Node")[1] = "Node_head"
	;("Center_Node")[2] = "Text_9"
	self.Text_9 = SoraDGetChildByFullPath(self.Node_content, "Center_Node")
	self.Text_9:setString(i18n("enjoylottery_text_03"))
	_UPVALUE1_ = i18n("enjoylottery_text_03")
	i18n("enjoylottery_text_03")[1] = "Node_rewards"
	self.Node_rewards = SoraDGetChildByFullPath(self.Node_content, i18n("enjoylottery_text_03"))
	_UPVALUE1_ = i18n("enjoylottery_text_03")
	i18n("enjoylottery_text_03")[1] = "Button_one"
	self.Button_one = SoraDGetChildByFullPath(self.Node_content, i18n("enjoylottery_text_03"))
	_UPVALUE1_ = i18n("enjoylottery_text_03")
	i18n("enjoylottery_text_03")[1] = "Button_two"
	self.Button_two = SoraDGetChildByFullPath(self.Node_content, i18n("enjoylottery_text_03"))
	_UPVALUE1_ = i18n("enjoylottery_text_03")
	i18n("enjoylottery_text_03")[1] = "Text_1"
	SoraDGetChildByFullPath(self.Button_one, i18n("enjoylottery_text_03")):setString(i18n("enjoylottery_btn_01"))
	_UPVALUE1_ = i18n("enjoylottery_btn_01")
	i18n("enjoylottery_btn_01")[1] = "Text_2"
	SoraDGetChildByFullPath(self.Button_one, i18n("enjoylottery_btn_01")):setString(1)
	_UPVALUE1_ = 1
	;(1)[1] = "Text_1"
	SoraDGetChildByFullPath(self.Button_two, 1):setString(i18n("enjoylottery_btn_02"))
	_UPVALUE1_ = i18n("enjoylottery_btn_02")
	i18n("enjoylottery_btn_02")[1] = "Text_2"
	SoraDGetChildByFullPath(self.Button_two, i18n("enjoylottery_btn_02")):setString(5)
	self.Button_one:addTouchEventListener(handler(self, self.btnClickCallback))
	self.Button_two:addTouchEventListener(handler(self, self.btnClickCallback))
	_UPVALUE1_ = handler(self, self.btnClickCallback)
	handler(self, self.btnClickCallback)[1] = "Node_counts"
	self.Node_counts = SoraDGetChildByFullPath(self.Node_content, handler(self, self.btnClickCallback))
	_UPVALUE1_ = handler(self, self.btnClickCallback)
	handler(self, self.btnClickCallback)[1] = "Node_counts_up"
	self.Node_counts_up = SoraDGetChildByFullPath(self.Node_counts, handler(self, self.btnClickCallback))
	_UPVALUE1_ = handler(self, self.btnClickCallback)
	handler(self, self.btnClickCallback)[1] = "Text_has"
	self.Text_has = SoraDGetChildByFullPath(self.Node_counts_up, handler(self, self.btnClickCallback))
	self.Text_has:setString(i18n("common_text_3893"))
	_UPVALUE1_ = i18n("common_text_3893")
	i18n("common_text_3893")[1] = "Text_count"
	self.Text_count = SoraDGetChildByFullPath(self.Node_counts_up, i18n("common_text_3893"))
	_UPVALUE1_ = i18n("common_text_3893")
	i18n("common_text_3893")[1] = "Image_add"
	self.Image_add = SoraDGetChildByFullPath(self.Node_counts_up, i18n("common_text_3893"))
	self.Image_add:setTouchEnabled(true)
	self.Image_add:addTouchEventListener(handler(self, self.btnClickCallback))
	self.singleItem = SoraDGetChildByName(self, "Node_single_item")
	self.Text_count:setString(self.lotteryCounts)
	SoraDToCenter(self.Node_counts_up, 10)
end
function enjoyLotteryResultPopView:initData(data)
	if not data.rewards then
		local _ENV, rewards = data.rewards, data.rewards
	end
	self.resultType = #rewards
	local scale = 1
	local posTab
	if self.resultType == 1 then
		self.Button_two:setVisible(false)
	else
		self.Button_one:setVisible(false)
		scale = 0.9054054054054054
		local offsety = 142
		self.ccs_bg:setSize(cc.size(self.ccs_bg:getSize().width, self.ccs_bg:getSize().height + offsety))
		_UPVALUE4_ = self.ccs_bg
		self.ccs_bg[1] = self.ccs_bg
		self.ccs_bg[2] = self.Button_one
		self.ccs_bg[3] = self.Button_two
		self.ccs_bg[4] = self.Node_counts
		for i, widget in ipairs(self.ccs_bg) do
			widget:setPositionY(widget:getPositionY() - offsety)
		end
		self.Node_rewards:setPositionY(self.Node_rewards:getPositionY() - offsety / 2)
		if display.height < 900 then
			self.Center_Node:setPositionY(self.Center_Node:getPositionY() + 40)
		end
		_ENV = self.Center_Node.setPositionY
		self.Center_Node.setPositionY[1] = cc.p(-74, 78)
		self.Center_Node.setPositionY[2] = cc.p(74, 78)
		self.Center_Node.setPositionY[3] = cc.p(-146, -78)
		self.Center_Node.setPositionY[4] = cc.p(0, -78)
		posTab, self.Center_Node.setPositionY[5] = self.Center_Node.setPositionY, cc.p(146, -78)
	end
	for i, v in ipairs(rewards) do
		local item = self.singleItem:clone()
		local singleItem = include("itemSingleView").new()
		singleItem:setPosition(cc.p(-72, 72))
		singleItem:addTo(item, -1)
		singleItem:setScale(0.9536423841059603)
		_ENV = 0.9536423841059603
		;(0.9536423841059603).itemData = v
		singleItem:initData(0.9536423841059603)
		singleItem:setButtonTag(v.id)
		singleItem:setItemClickCallback(handler(self, self.showDetail))
		singleItem.imgFrame:setVisible(false)
		item:addTo(self.Node_rewards)
		item:setPosition(cc.p(0, 0))
		item:setScale(scale)
		if posTab and posTab[i] then
			item:setPosition(posTab[i])
		end
	end
end
function enjoyLotteryResultPopView:showDetail(target, etype)
	if etype == ccui.TouchEventType.ended or etype == ccui.TouchEventType.canceled then
		SoraDPlaySound()
		self:stopAllActions()
		SoraDCloseCommonTips()
	elseif etype == ccui.TouchEventType.began then
		_UPVALUE1_ = nil
		;(nil)[1] = cca.delay(0.2)
		;(nil)[2] = cca.callFunc(function()
			SoraDShowCommonTips(target, target:getTag())
		end)
		;(nil)[3] = cca.callFunc(function()
			SoraDShowCommonTips(target, target:getTag())
		end)
		self:runAction(cca.seq(nil))
	end
end
function enjoyLotteryResultPopView:btnClickCallback(button, event)
	if event == ccui.TouchEventType.ended then
		if self.isAction then
			return
		end
		SoraDPlaySound()
		SoraDRemoveAllAfterPanelFromManager(self, true)
		if button == self.Image_add then
			self:btnAddCallback()
		elseif button == self.Button_one or button == self.Button_two then
			self:btnPumpClickCallBack(button)
		end
	end
end
function enjoyLotteryResultPopView:btnAddCallback()
	self:removeFromParent()
	if SoraDCheckShow() then
		if GLOBAL_GAME_RECHARGE_MODE then
			_ENV = nil
			;(nil).fromCenter = gRechargeActiveFromEnum.ROAD01
			uiManager:show("rechargePopFrame", nil)
		else
			local panel = SoraDCreatePanel("rechargePopFrame")
			panel:initData(nil, gRechargeActiveFromEnum.ROAD01)
			panel:show()
		end
	elseif GLOBAL_GAME_RECHARGE_MODE then
		uiManager:show("rechargeView")
	else
		SoraDCreatePanel("rechargeView"):show()
	end
end
function enjoyLotteryResultPopView:btnPumpClickCallBack(button, etype)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ENJOY_LOTTERY, true) then
		self:removeFromParent()
		return
	end
	if button == self.Button_one and self.lotteryCounts < 1 or button == self.Button_two and self.lotteryCounts < 5 then
		SoraDShowMsgBox(i18n("enjoylottery_text_04"), i18n("common_text_204"), nil, function(etype)
			if etype == MSGBOX_CALLBACK_YES then
				self:btnAddCallback()
			end
		end)
		return
	end
	if button == self.Button_one then
		self:removeFromParent()
		SoraDGetCtrl("enjoyLotteryCtrl"):sendReqPond(1)
	elseif button == self.Button_two then
		self:removeFromParent()
		SoraDGetCtrl("enjoyLotteryCtrl"):sendReqPond(5)
	end
end
return enjoyLotteryResultPopView
