local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local rechargeRead = include("rechargeRead")
local baseComponent = require("fgui.base.baseComponent")
local monthCardNode = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RechargeView/monthCardNode", monthCardNode)
function monthCardNode:onInit()
	self.buffMonthDataBuff, _ENV, self.buffMonthDataItem, _ENV = nil, nil, nil, nil
	self.buyMode = 1
	self.fields.Label_timer:setVisible(false)
	self.fields.Com_buffTitle:setString(i18n("rechare_title_02"))
	self.fields.Com_itemTitle:setString(i18n("rechare_title_03"))
	self.fields.List_item:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_item:setAlignCenter(true)
	self.fields.List_buff:setItemRenderer(handler(self, self.onBuffRenderer))
	self.fields.Com_tip:setHandle(handler(self, self.onBtnHelpCallBack))
	self.fields.Button_buffMonthBuy:addClickListener(handler(self, self.btnBuyClick))
	self.fields.Btn_first:fixPos()
	self.fields.rechargeGift:fixPos()
	self.fields.rechargeGift:fixNodePos()
end
function monthCardNode:onItemRenderer(index, obj)
	local itemData = self.buffMonthDataItem[index + 1]
	obj:initData(tonumber(itemData.id), tonumber(itemData.count))
	obj:showCoolSquare(tonumber(itemData.id) == gIDDef.GOLD)
end
function monthCardNode:onBuffRenderer(index, obj)
	obj:initData(self.buffMonthDataBuff[index + 1])
end
function monthCardNode:onShow()
end
function monthCardNode:initData()
	self.buffMonthDataBuff, rechargeActivityCtrl, self.buffMonthDataItem, rechargeActivityCtrl, self.buffMonthData = nil, nil, nil, nil, nil
	local buffMonthData = rechargeActivityCtrl:getMonthActivityList()
	local isOpen = false
	local isHave = true
	for k, v in pairs(buffMonthData) do
		if isHave and tonumber(k) == 14080 then
			isOpen = true
		end
	end
	if next(buffMonthData) then
		for k, v in pairs(buffMonthData) do
			self.buffMonthData = v
			if self.buffMonthData.isbuy then
				break
			end
		end
		if not rechargeActivityCtrl:getMonthAwardList(self.buffMonthData.ID) then
			rechargeActivityCtrl = rechargeActivityCtrl:getMonthAwardList(self.buffMonthData.ID)
		end
		self.buffMonthDataItem = rechargeActivityCtrl:getMonthAwardList(self.buffMonthData.ID)
		if self.buffMonthData.buff and next(self.buffMonthData.buff) then
			for i, v in ipairs(self.buffMonthData.buff) do
				if tonumber(v) ~= 9002528 and tonumber(v) ~= 9002558 and tonumber(v) ~= 9002559 then
					rechargeActivityCtrl = nil
					;(nil).id = v
					table.insert(self.buffMonthDataBuff, nil)
				end
			end
		end
		self.fields.List_item:setNumItems(#self.buffMonthDataItem)
	end
	if self.buffMonthData then
		local pageInfo = rechargeRead.getPageViewData(self.buffMonthData.ID)
		if pageInfo and next(pageInfo) and pageInfo.activeDesc ~= "" then
			self.fields.Com_tip:setTitle(i18n(pageInfo.activeDesc))
		end
		self.fields.List_buff:setNumItems(#self.buffMonthDataBuff)
	end
	self:updateMonthBtn()
	self:createRechargeGiftNode()
end
function monthCardNode:createRechargeGiftNode()
	local buffMonthData = rechargeActivityCtrl:getMonthActivityList()
	local rechargeActivityCtrl, rechargeIDList = rechargeActivityCtrl, rechargeActivityCtrl
	for i, v in pairs(buffMonthData) do
		if v.endtime then
			local remaintime = v.endtime - serviceFunctions.systemTime()
			if 0 < remaintime then
				rechargeActivityCtrl = nil
				;(nil).rechargeID = v.ID
				;(nil).basePrice = v.price
				table.insert(rechargeIDList, nil)
			end
		else
			local lasttime = serviceFunctions.systemTime() - v.starttime
			if lasttime / 86400 >= v.totalday then
				rechargeActivityCtrl = nil
				;(nil).rechargeID = v.ID
				;(nil).basePrice = v.price
				table.insert(rechargeIDList, nil)
			end
		end
	end
	table.sort(rechargeIDList, function(l, r)
		if l.basePrice ~= r.basePrice then
			return l.basePrice < r.basePrice
		else
			return l.rechargeID < r.rechargeID
		end
	end)
	self.fields.rechargeGift:initData(rechargeIDList)
end
function monthCardNode:updateMonthBtn()
	if self.buffMonthData and self.buffMonthData.isbuy then
		self.fields.Com_tip:setTitle(i18n("common_text_4194"))
		local leftTime = rechargeActivityCtrl:getRechargeLeftTime(self.buffMonthData.ID)
		local monthDays, showTicket = SoraDConverSecondToDayAndHours(leftTime)
		if self.buffMonthData.isdayget then
			if monthDays < 60 and self.buffMonthData.canRenew then
				self.fields.Button_buffMonthBuy:setEnabled(true)
				self.fields.Button_buffMonthBuy:setString(i18n("rechare_btn_01"))
				self.buyMode = 1
			else
				self.fields.Button_buffMonthBuy:setEnabled(false)
				self.fields.Button_buffMonthBuy:setString(i18n("common_text_1892"))
			end
		else
			self.fields.Button_buffMonthBuy:setEnabled(true)
			self.fields.Button_buffMonthBuy:setString(i18n("common_text_1146"))
			self.buyMode = 2
		end
		if 0 < leftTime then
			self.fields.Label_timer:setVisible(true)
			self.fields.Label_timer:setTimeLast(function(ticket)
				_ENV = nil
				;(nil).time = ticket
				return i18n("common_text_4179", nil)
			end)
			self.fields.Label_timer:beginTime(leftTime)
			self.fields.Label_timer:setTimeEndListener(function()
				self:initData()
			end)
		else
			self.fields.Label_timer:setVisible(false)
		end
	else
		self.fields.Label_timer:setVisible(false)
		self.fields.Button_buffMonthBuy:setEnabled(true)
		self.fields.Com_tip:setTitle(i18n("common_text_3798"))
		self.fields.Button_buffMonthBuy:setString(i18n("monthCard_btn_01"))
		self.buyMode = 1
	end
end
function monthCardNode:btnBuyClick()
	SoraDPlaySound()
	if self.buyMode == 1 then
		if SoraDCheckOAPIsOpen(self.buffMonthData.ID) then
			uiManager:show("RechargeViewMonthlyBuyBox")
		else
			SoraDCreatePanel("rechargeViewMonthlyBuyBox"):show()
		end
		paymentManager.OnemtOpenGiftUI(self.buffMonthData.ID, gRechargeActiveFromEnum.ROAD25)
	elseif self.buyMode == 2 then
		self.fields.Button_buffMonthBuy:setEnabled(false)
		self.fields.Button_buffMonthBuy:setString(i18n("common_text_1892"))
		rechargeActivityCtrl:getMonthAwardReq(self.buffMonthData.ID)
		paymentManager.OnemtOpenGiftUI(self.buffMonthData.ID, gRechargeActiveFromEnum.ROAD25)
	end
end
function monthCardNode:onBtnHelpCallBack()
	_ENV = "common_text_4176"
	;("common_text_4176").align = SoraDFLabelR()
	SoraDShowHelpMsgTip(i18n("common_text_4176"), "common_text_4176")
end
return monthCardNode
