local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local friendsCallbackCtrl = gametop.playertop_:getModule("friendsCallbackCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local publicRead = include("publicRead")
local friendsCallbackRead = include("friendsCallbackRead")
local callbackStore = class("callbackStore", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("callbackStore")
	end
	return target
end)
function callbackStore:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("return_title_02"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_log")
	self.node_item = SoraDGetChildByName(self, "item_node")
	self.node_line = SoraDGetChildByName(self, "line_node")
	self.btn_tips = SoraDGetChildByName(self, "Button_help")
	self.text_time = SoraDGetChildByName(self, "Text_time")
	self.text_time = SoraDCreateTimerLabel(self, self.text_time)
	self.text_gold = SoraDGetChildByName(self, "Text_gold")
	self.btn_tips:addTouchEventListener(handler(self, self.btnTipsClick))
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	self.tableBgSpare, _ENV, self.tableItemsSpare, _ENV, self.tableItemsSel, _ENV = self.scroll.addEventListener, self.scroll.addEventListener, self.scroll.addEventListener, self.scroll.addEventListener, self.scroll.addEventListener, self.scroll.addEventListener
	self.itemSize = cc.size(290, 160)
	self:initView()
end
function callbackStore:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_FRIEND_BACK_UPDATE_SHOP", function(target, data)
		self:initView()
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_FRIEND_BACK_UPDATE_GOLD", function(target, data)
		self:initView()
	end)
end
function callbackStore:initView()
	local eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.FRIEND_CALLBACK)
	if eventTime then
		self.text_time:beginTime(eventTime.timerNode.timer:getRemainTime())
	end
	self.exchangeID = friendsCallbackCtrl:getExchangeID()
	self:clearOld()
	self.text_gold:setString(string.formatnumberthousands(backpackCtrl:getItemCount(self.exchangeID)))
	self:updateScrollData()
end
function callbackStore:sortItems()
	table.sort(self.storeList, function(l, r)
		local itemCount = backpackCtrl:getItemCount(self.exchangeID)
		if itemCount >= l.changeID.count then
			if itemCount >= r.changeID.count then
				if not friendsCallbackCtrl:canBuy(l.shopItemID) and friendsCallbackCtrl:canBuy(r.shopItemID) then
					return false
				elseif friendsCallbackCtrl:canBuy(l.shopItemID) and not friendsCallbackCtrl:canBuy(r.shopItemID) then
					return true
				else
					if publicRead.getQuality(l.itemID.id) == publicRead.getQuality(r.itemID.id) then
						return l.itemID.id > r.itemID.id
					end
					return publicRead.getQuality(l.itemID.id) > publicRead.getQuality(r.itemID.id)
				end
			else
				return true
			end
		end
		if itemCount < l.changeID.count then
			if itemCount < r.changeID.count then
				return publicRead.getQuality(l.itemID.id) > publicRead.getQuality(r.itemID.id)
			else
				return false
			end
		end
	end)
end
function callbackStore:clearOld()
	for i, v in ipairs(self.tableItemsSel) do
		if v.point then
			v.point:setVisible(false)
			table.insert(self.tableItemsSpare, v.point)
			v.point = nil
		end
	end
	self.tableItemsSel, _ENV = ipairs(self.tableItemsSel)
end
function callbackStore:updateScrollData()
	self.storeList = friendsCallbackRead.returnShopConfig
	self:sortItems()
	for k, v in ipairs(self.storeList) do
		friendsCallbackRead = nil
		;(nil).data = v
		friendsCallbackRead, (nil).point = nil, nil
		;(nil).x = 0
		;(nil).pos, (nil).y = nil, 0
		table.insert(self.tableItemsSel, nil)
	end
	self:initScroll()
	self:initShopItems()
end
function callbackStore:initScroll()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local scrollH = self.scroll:getContentSize().height
	local scrollW = self.scroll:getContentSize().width
	local numColumn = 2
	local numRows = math.floor((#self.tableItemsSel + numColumn - 1) / numColumn)
	local accumulateHeight = self.itemSize.height * numRows
	for i, v in ipairs(self.tableItemsSel) do
		v.pos.y = accumulateHeight - (math.floor((i + numColumn - 1) / numColumn) - 1) * self.itemSize.height - 80
		if SoraDFIsRA() then
			v.pos.x = scrollW - (i - 1) % 2 * self.itemSize.width - 10
		else
			v.pos.x = (i - 1) % 2 * self.itemSize.width + self.itemSize.width / 2 + 145
		end
		if v.point then
			v.point:setPositionY(v.pos.y)
			v.point:setPositionX(v.pos.x)
		end
	end
	local totalCellHeight = accumulateHeight
	if scrollH > totalCellHeight then
		local deltaY = scrollH - totalCellHeight
		totalCellHeight = scrollH
		for i, v in ipairs(self.tableItemsSel) do
			v.pos.y = v.pos.y + deltaY
			if v.point then
				v.point:setPositionY(v.pos.y)
			end
		end
	end
	local scrollInnerNewH = totalCellHeight
	offsetY = offsetY - (scrollInnerNewH - scrollInner:getContentSize().height)
	self.scroll:setInnerContainerSize(cc.size(scrollW, scrollInnerNewH))
	scrollInner:setPositionY(offsetY)
end
function callbackStore:initShopItems()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scroll:getContentSize().height
	_ENV = self.scroll
	self.scroll.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local self.scroll.endY, tableShowH = offsetY + 1.5 * scrollH, self.scroll
	for i, v in ipairs(self.tableItemsSel) do
		if v.point then
			if v.pos.y < tableShowH.beginY or v.pos.y > tableShowH.endY then
				v.point:setVisible(false)
				table.insert(self.tableItemsSpare, v.point)
				v.point = nil
			end
		elseif tableShowH.beginY <= v.pos.y and tableShowH.endY >= v.pos.y then
			local single
			if 0 < #self.tableItemsSpare then
				single = table.remove(self.tableItemsSpare)
				single:setVisible(true)
			else
				single = self.node_item:clone()
				single:addTo(self.scroll)
			end
			self:initNewNode(single)
			single.setData(v.data)
			single:setPosition(v.pos)
			v.point = single
		end
	end
	self:updateRowBg()
end
function callbackStore:updateRowBg()
	local singleBg
	local rowNum = math.ceil(#self.tableItemsSel / 2)
	local singleBgClone = function()
		local singlebg = self.node_line:clone()
		singlebg:setVisible(true)
		return singlebg
	end
	if rowNum < #self.tableBgSpare then
		for i = rowNum + 1, #self.tableBgSpare do
			self.tableBgSpare[i]:setVisible(false)
		end
	end
	for i = 1, rowNum do
		if self.tableBgSpare[i] then
			singleBg = self.tableBgSpare[i]
			singleBg:setVisible(true)
		else
			singleBg = singleBgClone()
			singleBg:addTo(self.scroll)
			table.insert(self.tableBgSpare, singleBg)
		end
		singleBg:setPosition(0, self.tableItemsSel[i * 2 - 1].pos.y + 75)
	end
end
function callbackStore:initNewNode(newNode)
	local single = newNode
	local btn_operate = SoraDGetChildByName(single, "btn_operate")
	local text_gold = SoraDGetChildByName(single, "text_exchange")
	btn_operate:setSwallowTouches(false)
	btn_operate:addTouchEventListener(function(target, event)
		if event == ccui.TouchEventType.ended then
			if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll, event) then
				return
			end
			if single.info.changeID.count > backpackCtrl:getItemCount(single.info.changeID.id) then
				SoraDShowMsgTip(i18n("return_text_27"))
			elseif not single.info.canBuy then
				SoraDShowMsgTip(i18n("notice_0010"))
			else
				local panel = SoraDCreatePanel("callbackItemBuyBox")
				panel:initData(single.info)
				panel:show()
			end
		end
	end)
	function single.setData(info)
		info.canBuy = friendsCallbackCtrl:canBuy(info.shopItemID)
		single.info = info
		single.needExchangeCount = info.changeID.count
		single.name = publicRead.getName(info.itemID.id)
		text_gold:setString(single.needExchangeCount)
		if info.changeID.count > backpackCtrl:getItemCount(info.changeID.id) then
			text_gold:setColor(cc.c3b(204, 8, 8))
			btn_operate:setBright(false)
		elseif not info.canBuy then
			btn_operate:setBright(false)
		else
			text_gold:setColor(cc.c3b(254, 255, 1))
			btn_operate:setBright(true)
		end
		local singleTouch = single:getChildByName("item_single_show")
		local textNum = SoraDGetChildByName(single, "text_num")
		singleTouch:setSwallowTouches(false)
		single:getChildByName("item_color"):loadTexture(publicRead.getBg(info.itemID.id), ccui.TextureResType.plistType)
		single:getChildByName("item_icon"):loadTexture(publicRead.getIcon(info.itemID.id), ccui.TextureResType.plistType)
		local curCount = friendsCallbackCtrl.shopData[tostring(info.shopItemID)] or 0
		textNum:setString(curCount .. "/" .. info.limitNum)
		single:getChildByName("text_name"):setString(publicRead.getName(info.itemID.id))
		if info.canBuy then
			textNum:setColor(cc.c3b(255, 255, 255))
		else
			textNum:setColor(cc.c3b(204, 8, 8))
		end
		singleTouch:addTouchEventListener(function(target, event)
			if event == ccui.TouchEventType.ended or event == ccui.TouchEventType.canceled then
				if single.tips then
					single.tips:removeFromParent()
					single.tips = nil
				end
			elseif event == ccui.TouchEventType.began then
				SoraDPlaySound()
				if self.scroll and not SoraDIsNodeVisibleOnScroll(target, self.scroll, event) then
					return
				end
				self:onClickSingle(single, info.itemID.id)
			end
		end)
	end
end
function callbackStore:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:initShopItems()
	end
end
function callbackStore:onClickSingle(_single, _id)
	local single = _single
	if single.tips then
		single.tips:removeFromParent()
		single.tips = nil
	end
	single.tips = SoraDCreatePanel("commonItemTips")
	single.tips:setPositionY(50)
	single.tips:addTo(self)
	single.tips:setLocalZOrder(10)
	single.tips:setVisible(false)
	local worldPos = single:convertToWorldSpace(cc.p(0, 0))
	local nodePos = self:convertToNodeSpace(worldPos)
	local deltaTipX = 0
	if SoraDFIsRA() then
		deltaTipX = 0
	else
		deltaTipX = -280
	end
	if nodePos.x > 300 then
		single.tips:setPositionX(nodePos.x + 15 + deltaTipX)
	else
		single.tips:setPositionX(nodePos.x + 325 + deltaTipX)
	end
	single.tips:setPositionY(nodePos.y + 200)
	single.tips:setVisible(true)
	single.tips:initData(_id)
end
function callbackStore:btnTipsClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showSingleFAQ(IsArClient and gSDKDef.FAQSingleType.FRIEND_CALLBACK or gSDKDef.FAQSingleType.FRIEND_CALLBACK_ROS)
	end
end
return callbackStore
