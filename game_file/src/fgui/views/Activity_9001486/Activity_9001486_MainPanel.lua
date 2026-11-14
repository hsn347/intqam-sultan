local activity_9001486_Ctrl = SoraDGetCtrl("activity_9001486_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001486_MainPanel = class("Activity_9001486_MainPanel", baseFguiPanel)
function Activity_9001486_MainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001486_MainPanel:ctor", self.viewName)
end
function Activity_9001486_MainPanel:onInit()
	print("=======Activity_9001486_MainPanel:onInit")
	self.activityID = self.proxy.param and self.proxy.param.activityID or gActivityTimeActivityID.DICTATORSHIPS_ACTIVITY
	self.proxy:setActivityID(self.activityID)
	self.rewards = activity_9001486_Ctrl:getGiftRewards(self.activityID)
	self.rechargeList1 = activity_9001486_Ctrl:getRechargeList(self.activityID, 1)
	self.rechargeList2 = activity_9001486_Ctrl:getRechargeList(self.activityID, 2)
	self.isIPad = display.height <= 856
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose))
	self.fields.Text_rewad:setString(i18n("dictatorship_08"))
	local cfg = activity_9001486_Ctrl:getGiftConfig(self.activityID)
	local showPrice, isGetPrice = paymentManager.judgePrice(cfg.RechargeID, cfg.Price)
	self.nowPrice = showPrice
	local discount = cfg.OriginalPrice / cfg.Price
	local oriShowPrice = paymentManager.calculateDiscount(cfg.RechargeID, showPrice, discount, cfg.OriginalPrice)
	self.fields.Button_buy:initData(showPrice, oriShowPrice)
	self.fields.Button_buy:addClickListener(handler(self, self.onClickBtnBuy))
	self.fields.List_reward:setItemRenderer(handler(self, self.onRewardItemRenderer))
	self.fields.List_reward:setVirtual()
	self.fields.List_box1:setItemRenderer(handler(self, self.onBox1ItemRenderer))
	self.fields.List_box2:setItemRenderer(handler(self, self.onBox2ItemRenderer))
	if self.isIPad then
		self.fields.List_box2:setContentSize(cc.size(850, self.fields.List_box2:getContentSize().height))
		self.fields.List_box2:setScrollEnable(false)
		self.fields.Image_left:setVisible(false)
		self.fields.Image_right:setVisible(false)
	else
		self.fields.List_box2:addEventListener(fgui.UIEventType.ScrollEnd, handler(self, self.onScrollEnd))
	end
	self.fields.Button_go:setString(i18n("back_recharge_text02"))
	self.fields.Button_go:addClickListener(handler(self, self.onClickBtnGo))
	self.controllers.c2:setSelectedIndex(SoraDFIsRA() and 0 or 1)
end
function Activity_9001486_MainPanel:onScrollEnd(...)
	local scrollPane = self.fields.List_box2:getScrollPane()
	local posx = scrollPane:getPosX()
	local scrollW = scrollPane:getContentSize().width
	local listW = self.fields.List_box2:getContentSize().width
	print("==Activity_9001486_MainPanel:onScrollEnd==", posx, scrollW)
	local bound = 10
	local leftVisible = posx > bound
	self.fields.Image_left:setVisible(leftVisible)
	local rightVisible = posx < scrollW - listW - bound
	self.fields.Image_right:setVisible(rightVisible)
end
function Activity_9001486_MainPanel:onShow()
	print("=======Activity_9001486_MainPanel:onShow", self:getSize().width)
	self:updateCumuDayData()
	self.fields.List_reward:setNumItems(#self.rewards)
	self.fields.List_box1:setNumItems(#self.rechargeList1)
	self.fields.List_box2:setNumItems(#self.rechargeList2)
	if not self.isIPad then
		local scrollIdx = 0
		for i, data in ipairs(self.rechargeList2) do
			if not data.isReceived then
				scrollIdx = i - 1
				break
			end
		end
		self.fields.List_box2:scrollToView(scrollIdx)
		self:onScrollEnd()
	end
	self:updateTextBuy()
end
function Activity_9001486_MainPanel:onRewardItemRenderer(index, obj)
	local data = self.rewards[index + 1]
	obj:initData(data.id, data.count)
end
function Activity_9001486_MainPanel:onBox1ItemRenderer(index, obj)
	local data = self.rechargeList1[index + 1]
	self:initBoxSingle(obj, data)
end
function Activity_9001486_MainPanel:onBox2ItemRenderer(index, obj)
	local data = self.rechargeList2[index + 1]
	self:initBoxSingle(obj, data)
end
function Activity_9001486_MainPanel:initBoxSingle(obj, data)
	if not obj.c_state then
		obj.c_state = obj:getController("c_state")
		obj:addClickListener(handler(self, self.onClickItemObj))
	end
	obj.data = data
	local cfg = data.cfg
	if data.type == 1 then
		_ENV = handler(self, self.onClickItemObj)
		handler(self, self.onClickItemObj).num1 = cfg.days
		handler(self, self.onClickItemObj).num2 = "$" .. cfg.amount
		obj:setString(i18n("dictatorship_01", handler(self, self.onClickItemObj)))
	elseif data.type == 2 then
		_ENV = i18n("dictatorship_01", handler(self, self.onClickItemObj))
		i18n("dictatorship_01", handler(self, self.onClickItemObj)).num = "$" .. cfg.amount
		obj:setString(i18n("dictatorship_02", i18n("dictatorship_01", handler(self, self.onClickItemObj))))
	end
	if data.isReceived then
		obj.c_state:setSelectedIndex(2)
		obj:setIcon(cfg.open)
	elseif data.canReceive then
		obj.c_state:setSelectedIndex(1)
		obj:setIcon(cfg.close)
	else
		obj.c_state:setSelectedIndex(0)
		obj:setIcon(cfg.close)
	end
end
function Activity_9001486_MainPanel:onClickBtnBuy(...)
	SoraDPlaySound()
	if self.achieveDay < self.dayMax then
		return
	end
	if activity_9001486_Ctrl:getHasBuyGift(self.activityID) then
		return
	end
	local rid = activity_9001486_Ctrl:getGiftRechargeID(self.activityID)
	paymentManager.normalGiftBuyClassify(rid)
	paymentManager.OnemtReadyBuy(rid, gRechargeActiveFromEnum.ROAD41, false)
end
function Activity_9001486_MainPanel:onClickBtnGo(...)
	SoraDPlaySound()
	_UPVALUE2_ = SoraDPlaySound
	SoraDPlaySound[1] = 19188
	local SoraDPlaySound[2], giftArray = 19189, SoraDPlaySound
	if GLOBAL_GAME_RECHARGE_MODE then
		_ENV = nil
		;(nil).rechargeIDList = giftArray
		uiManager:show("rechargeView", nil)
	else
		local panel = SoraDCreatePanel("rechargeView"):show()
		panel:jumpToLimitNodeByList(10, giftArray)
	end
end
function Activity_9001486_MainPanel:onClickItemObj(EventContext)
	SoraDPlaySound()
	local sender = EventContext:getSender()
	local data = sender.data
	_ENV = nil
	;(nil).data = data
	;(nil).activityID = self.activityID
	uiManager:show("Activity_9001486_Box", nil)
end
function Activity_9001486_MainPanel:updateClaim(index)
	_UPVALUE2_ = nil
	;(nil)[1] = self.rechargeList1
	;(nil)[2] = self.rechargeList2
	for listIdx, rechargeList in ipairs(nil) do
		local objIdx
		for i, data in ipairs(rechargeList) do
			local cfg = data.cfg
			if cfg.Index == index then
				data.isReceived = true
				objIdx = i
				break
			end
		end
		if objIdx then
			local List_box = self.fields["List_box" .. listIdx]
			local obj = List_box:getChildAt(objIdx - 1)
			obj.c_state:setSelectedIndex(2)
			local data = rechargeList[objIdx]
			local cfg = data.cfg
			obj:setIcon(cfg.open)
			break
		end
	end
end
function Activity_9001486_MainPanel:updateCumuDayData(...)
	local achieveDay, dayMax = activity_9001486_Ctrl:getAchieveDay(self.activityID)
	self.achieveDay = achieveDay
	self.dayMax = dayMax
	local total = activity_9001486_Ctrl:getRechargeTotal(self.activityID)
	_UPVALUE2_ = self.activityID
	self.activityID[1] = self.rechargeList1
	self.activityID[2] = self.rechargeList2
	for __, rechargeList in ipairs(self.activityID) do
		for i, data in ipairs(rechargeList) do
			data.achieveDay = achieveDay
			data.total = total
			local cfg = data.cfg
			local isReceived = activity_9001486_Ctrl:checkBoxReceived(self.activityID, cfg.Index)
			if isReceived then
				data.isReceived = isReceived
			else
				if data.type == 1 and self.achieveDay >= cfg.days then
					data.canReceive = true
				end
				if data.type == 2 and total >= cfg.amount then
					data.canReceive = true
				end
			end
		end
	end
	local buyGift = activity_9001486_Ctrl:getHasBuyGift(self.activityID)
	if buyGift then
		self.controllers.c1:setSelectedIndex(1)
	else
		local unLockGift = self.achieveDay >= self.dayMax
		self.controllers.c1:setSelectedIndex(unLockGift and 0 or 1)
	end
end
function Activity_9001486_MainPanel:onMsgUpdateCumuDayData(...)
	self:updateCumuDayData()
	self.fields.List_box1:setNumItems(#self.rechargeList1)
	self.fields.List_box2:setNumItems(#self.rechargeList2)
end
function Activity_9001486_MainPanel:onMsgBuyGift(...)
	self.controllers.c1:setSelectedIndex(1)
	self:updateTextBuy()
end
function Activity_9001486_MainPanel:updateTextBuy(...)
	if activity_9001486_Ctrl:getHasBuyGift(self.activityID) then
		self.fields.Text_buy:setString(i18n("common_text_3833"))
	else
		activity_9001486_Ctrl = i18n("common_text_3833")
		i18n("common_text_3833").num = self.dayMax
		self.fields.Text_buy:setString(i18n("dictatorship_07", i18n("common_text_3833")))
	end
end
return Activity_9001486_MainPanel
