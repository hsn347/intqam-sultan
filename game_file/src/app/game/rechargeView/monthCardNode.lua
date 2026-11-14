local gametop = gModuleMgr.getObject("gametop")
local rechargeActivityCtrl = gametop.playertop_:getModule("rechargeActivityCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local rechargeRead = include("rechargeRead")
local monthCardNode = class("monthCardNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("monthCardNode")
	end
	return target
end)
function monthCardNode:ctor()
	self.itemArray, _ENV = nil, nil
	self.Text_title = SoraDGetChildByName(self, "Text_title")
	self.Image_buffMonthHead = SoraDGetChildByName(self, "Image_buffMonthHead")
	self.Node_mLine = SoraDGetChildByName(self, "Node_mLine")
	self.Text_buffMonthDes = SoraDGetChildByName(self, "Text_buffMonthDes")
	self.Button_help = SoraDGetChildByName(self, "Button_help")
	self.Button_help:addTouchEventListener(handler(self, self.onBtnHelpCallBack))
	self.Text_sale = SoraDGetChildByName(self, "Text_sale")
	self.Image_itemBg = SoraDGetChildByName(self, "Image_itemBg")
	self.scroll = SoraDGetChildByName(self, "ScrollView_scroll")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setVisbileShowScale(1.5)
	self.scroll:setSingleCCS("monthCardSingle")
	self.Node_buffTitle = SoraDGetChildByName(self, "Node_buffTitle")
	self.Text_buffTitle = SoraDGetChildByName(self, "Text_buffTitle")
	self.Text_buffTitle:setString(i18n("rechare_title_02"))
	self.Node_itemTitle = SoraDGetChildByName(self, "Node_itemTitle")
	self.Text_itemTitle = SoraDGetChildByName(self, "Text_itemTitle")
	self.Text_itemTitle:setString(i18n("rechare_title_03"))
	self.Node_monthItem = SoraDGetChildByName(self, "Node_monthItem")
	self.Node_Bottom = SoraDGetChildByName(self, "Node_Bottom")
	self.Sprite_item = SoraDGetChildByName(self, "Sprite_item")
	self.Image_11 = SoraDGetChildByName(self, "Image_11")
	self.Image_11_0 = SoraDGetChildByName(self, "Image_11_0")
	self.Image_11:setVisible(false)
	self.Image_11_0:setVisible(false)
	self.Text_title:setVisible(false)
	self.Button_buffMonthBuy = SoraDGetChildByName(self, "Button_buffMonthBuy")
	self.Node_buffMonthTime = SoraDGetChildByName(self, "Node_buffMonthTime")
	self.Text_buffMonthTime = SoraDGetChildByName(self, "Text_buffMonthTime")
	self.Node_buffMonthTime:setVisible(false)
	self.Text_sale:setString("sale")
	self.ccs_first = SoraDGetExtendChildFromCCSByName(self, "CCS_rechargeFirstAward_node")
	self:suitView()
	self:initData()
end
function monthCardNode:suitView()
	local suitH = display.height < 960 and 150 or 266
	self.Image_buffMonthHead:setContentSize(cc.size(640, suitH))
	self.Node_mLine:setPositionY(-suitH + 6)
	self.Node_Bottom:setPositionY(-display.height + 203)
	self.Image_itemBg:setContentSize(cc.size(640, display.height - suitH - 380))
	self.Node_buffTitle:setPositionY(self.Image_itemBg:getPositionY() + self.Image_itemBg:getContentSize().height - 30)
	self.scroll:setContentSize(cc.size(640, self.Node_buffTitle:getPositionY() - self.Node_itemTitle:getPositionY() - 32))
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
	self.Sprite_item:setVisible(isOpen)
	self.Text_sale:setVisible(isOpen)
	for k, v in ipairs(self.itemArray) do
		v:setVisible(false)
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
					rechargeActivityCtrl = false
					;(false).id = v
					table.insert(self.buffMonthDataBuff, false)
				end
			end
		end
		for i, v in ipairs(self.buffMonthDataItem) do
			if not self.itemArray[i] then
				self.itemArray[i] = include("commonItemAward").new()
				self.itemArray[i]:setScale(0.7)
				self.itemArray[i]:setOwnView(display.getRunningScene())
				self.itemArray[i]:setPositionY(0)
				self.itemArray[i]:addTo(self.Node_monthItem)
			end
			self.itemArray[i]:setVisible(true)
			if tonumber(v.id) == gIDDef.GOLD then
				self.itemArray[i]:showCoolSquare()
			else
				self.itemArray[i]:hideCoolSquare()
			end
			self.itemArray[i]:initData(v.id, v.count)
		end
		SoraDToCenter(self.Node_monthItem, 90, SoraDFIsRA())
	end
	if self.buffMonthData then
		local pageInfo = rechargeRead.getPageViewData(self.buffMonthData.ID)
		if pageInfo and next(pageInfo) then
			if pageInfo.activeName ~= "" then
				self.Text_title:setString(i18n(pageInfo.activeName))
			end
			if pageInfo.activeDesc ~= "" then
				self.Text_buffMonthDes:setString(i18n(pageInfo.activeDesc))
			end
		end
		self.scroll:updateScrollView(cc.size(284, 120), self.buffMonthDataBuff, 2)
	end
	self:updateMonthBtn()
	self:createRechargeGiftNode()
end
function monthCardNode:createRechargeGiftNode()
	local buffMonthData = rechargeActivityCtrl:getMonthActivityList()
	dump(buffMonthData, "sdklfjsdlkfj")
	local rechargeActivityCtrl, rechargeIDList = dump, dump
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
	SoraDCreateRechargeGiftNode(rechargeIDList, SoraDGetChildByName(self, "Node_monthHead"), cc.p(SoraDFPosX(282, 0), -222), nil, SoraDFPosX(2, 5))
end
function monthCardNode:updateMonthBtn()
	if self.buffMonthData and self.buffMonthData.isbuy then
		self.Text_buffMonthDes:setString(i18n("common_text_4194"))
		local leftTime = rechargeActivityCtrl:getRechargeLeftTime(self.buffMonthData.ID)
		local monthDays, showTicket = SoraDConverSecondToDayAndHours(leftTime)
		if self.buffMonthData.isdayget then
			if monthDays < 60 and self.buffMonthData.canRenew then
				self.Button_buffMonthBuy:setTouchEnabled(true)
				self.Button_buffMonthBuy:setBright(true)
				self.Button_buffMonthBuy:setTitleText(i18n("rechare_btn_01"))
				self.Button_buffMonthBuy:addTouchEventListener(function(button, eventType)
					if eventType == ccui.TouchEventType.ended then
						SoraDPlaySound()
						if SoraDCheckOAPIsOpen(self.buffMonthData.ID) then
							uiManager:show("RechargeViewMonthlyBuyBox")
						else
							SoraDCreatePanel("rechargeViewMonthlyBuyBox"):show()
						end
						paymentManager.OnemtOpenGiftUI(self.buffMonthData.ID, gRechargeActiveFromEnum.ROAD25)
					end
				end)
			else
				self.Button_buffMonthBuy:setTouchEnabled(false)
				self.Button_buffMonthBuy:setBright(false)
				self.Button_buffMonthBuy:setTitleText(i18n("common_text_1892"))
			end
		else
			self.Button_buffMonthBuy:setTouchEnabled(true)
			self.Button_buffMonthBuy:setBright(true)
			self.Button_buffMonthBuy:setTitleText(i18n("common_text_1146"))
			self.Button_buffMonthBuy:addTouchEventListener(function(button, eventType)
				if eventType == ccui.TouchEventType.ended then
					SoraDPlaySound()
					self.Button_buffMonthBuy:setTouchEnabled(false)
					self.Button_buffMonthBuy:setBright(false)
					self.Button_buffMonthBuy:setTitleText(i18n("common_text_1892"))
					SoraDShowLoading()
					rechargeActivityCtrl:getMonthAwardReq(self.buffMonthData.ID)
					paymentManager.OnemtOpenGiftUI(self.buffMonthData.ID, gRechargeActiveFromEnum.ROAD25)
				end
			end)
		end
		if 0 < leftTime then
			self.Node_buffMonthTime:setVisible(true)
			self.Text_buffMonthTime = SoraDCreateTimerLabel(self, self.Text_buffMonthTime)
			self.Text_buffMonthTime:setTimeLast(function(ticket)
				_ENV = nil
				;(nil).time = ticket
				return i18n("common_text_4179", nil)
			end)
			self.Text_buffMonthTime:beginTime(leftTime)
			SoraDToCenter(self.Node_buffMonthTime)
			self.Text_buffMonthTime:setTimeEndListener(function()
				self:initData()
			end)
		else
			SoraDToCenter(self.Node_buffMonthTime)
		end
		self.Button_buffMonthBuy:setPositionY(66)
	else
		self.Node_buffMonthTime:setVisible(false)
		self.Button_buffMonthBuy:setTouchEnabled(true)
		self.Button_buffMonthBuy:setBright(true)
		self.Text_buffMonthDes:setString(i18n("common_text_3798"))
		self.Button_buffMonthBuy:setPositionY(54)
		self.Button_buffMonthBuy:setTitleText(i18n("monthCard_btn_01"))
		self.Button_buffMonthBuy:addTouchEventListener(function(button, eventType)
			if eventType == ccui.TouchEventType.ended then
				SoraDPlaySound()
				if SoraDCheckOAPIsOpen(self.buffMonthData.ID) then
					uiManager:show("RechargeViewMonthlyBuyBox")
				else
					SoraDCreatePanel("rechargeViewMonthlyBuyBox"):show()
				end
				paymentManager.OnemtOpenGiftUI(self.buffMonthData.ID, gRechargeActiveFromEnum.ROAD25)
			end
		end)
	end
end
function monthCardNode:onBtnHelpCallBack(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "common_text_4176"
		;("common_text_4176").align = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("common_text_4176"), "common_text_4176")
	end
end
return monthCardNode
