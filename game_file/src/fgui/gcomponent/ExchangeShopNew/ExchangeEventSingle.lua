local gametop = gModuleMgr.getObject("gametop")
local exchangeMallCtrl = gametop.playertop_:getModule("exchangeMallCtrl")
local newExchangeMallCtrl = SoraDGetCtrl("newExchangeMallCtrl")
local activityExchangeMallCtrl = gametop.playertop_:getModule("activityExchangeMallCtrl")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local shopltCtrl = gModuleMgr.sharedMgr("shopltCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local publicRead = include("publicRead")
local publicUtil = include("publicUtil")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local dressCtrl = SoraDGetCtrl("dressCtrl")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local ExchangeEventSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ExchangeShopNew/ExchangeEventSingle", ExchangeEventSingle)
fgui.register_extension("ui://NebulaMarket/Com_Single", ExchangeEventSingle)
function ExchangeEventSingle:onInit()
	self.CheckBox_notify = self.fields.CheckBox_notify
	self.Text_leftCount = self.fields.Text_leftCount
	self.Button_exchange = self.fields.Button_exchange
	self.fields.Button_exchange:addClickListener(handler(self, self.onBtnCallBack))
	self.fields.CheckBox_notify:addClickListener(handler(self, self.onCheckBoxCallBack))
	self.fields.toItemL:setItemRenderer(handler(self, self.onToItemRender))
	self.fields.fromItemL:setItemRenderer(handler(self, self.onFromItemRender))
	self.exChangeStatus = 0
	if self.fields.Text_notify then
		self.fields.Text_notify:setString(i18n("exchange_btn_01"))
	end
	self.Button_exchange:setTitle(i18n("common_text_1889"))
	if self.fields.Text_tip then
		self.fields.Text_tip:setVisible(false)
	end
	self:fixChildrenPos()
	if self.fields.Sprite_line then
		self.fields.Sprite_line:fix()
	end
	if self.fields.Sprite_arrow then
		self.fields.Sprite_arrow:fix()
	end
end
function ExchangeEventSingle:initData(data, otherData)
	self.activityID = otherData.activityID
	self.exchangeItemID = data.exchangeitem[1]
	self.shopItemID = data.shopItemID
	self.itemID = data.shopitem[1]
	self.singleGet = data.shopitem[2]
	self.toolID = data.exchangeitem[1]
	self.singleCount = data.exchangeitem[2]
	self.storeID = data.storeID
	self.limitNum = data.limitnum
	self.limitType = data.limitType
	self.ownCount = self:getCount(self.toolID)
	self.curExchangeNum = data.curExchangeNum
	_UPVALUE2_ = self.toolID
	self.toolID[1] = "id"
	self.toolID[2] = "count"
	self.shopItemList = serviceFunctions.tableFormat(data.shopitem, self.toolID)
	_UPVALUE2_ = self.toolID
	self.toolID[1] = "id"
	self.toolID[2] = "count"
	self.exchangeitemList = serviceFunctions.tableFormat(data.exchangeitem, self.toolID)
	self.fields.CheckBox_notify:setSelected(data.remindStatus == 1)
	self.fields.fromItemL:setNumItems(self:getExchangeItemCount())
	self.fields.toItemL:setNumItems(#self.shopItemList)
	self:setLeftCount(data.limitType, data.limitnum, self.curExchangeNum)
	self:updateExChangeStatus(self.limitType)
	self:setBtnExchangeStatus()
	self:checkDressTip()
end
function ExchangeEventSingle:getCount(toolID)
	return publicUtil.getCount(toolID)
end
function ExchangeEventSingle:getExchangeItemCount()
	return #self.exchangeitemList
end
function ExchangeEventSingle:checkDressTip()
	if not self.fields.Text_tip then
		return
	end
	self.fields.Text_tip:setVisible(false)
	for k, v in ipairs(self.shopItemList) do
		local resultType = backpackltCtrl:getResultType(v.id)
		if not backpackltCtrl:getResult(v.id) then
			local _ENV, result = backpackltCtrl:getResult(v.id), backpackltCtrl:getResult(v.id)
		end
		local dressID = type(result) == "number" and result or result[1]
		if dressID then
			if resultType == gItemEffectDef.HERO_DRESS then
				local ret = heroCtrl:isHaveHeroDress(dressID)
				if ret then
					self.fields.Text_tip:setVisible(true)
					self.fields.Text_tip:setString(i18n("common_text_4831"))
				end
			elseif resultType == gItemEffectDef.DRESS then
				local ret = dressCtrl:ownDress(dressID)
				if ret then
					self.fields.Text_tip:setVisible(true)
					self.fields.Text_tip:setString(i18n("common_text_4831"))
				end
			elseif resultType == gItemEffectDef.MERGE_FRAGMENG then
				local _resultType = backpackltCtrl:getResultType(dressID)
				if not backpackltCtrl:getResult(dressID) then
					local _ENV, _result = backpackltCtrl:getResult(dressID), backpackltCtrl:getResult(dressID)
				end
				local _dressID = type(_result) == "number" and _result or _result[1]
				if _resultType == gItemEffectDef.HERO_DRESS then
					local ret = heroCtrl:isHaveHeroDress(_dressID)
					if ret then
						self.fields.Text_tip:setVisible(true)
						self.fields.Text_tip:setString(i18n("common_text_4831"))
					end
				elseif _resultType == gItemEffectDef.DRESS then
					local ret = dressCtrl:ownDress(_dressID)
					if ret then
						self.fields.Text_tip:setVisible(true)
						self.fields.Text_tip:setString(i18n("common_text_4831"))
					end
				end
			end
		end
	end
end
function ExchangeEventSingle:updateExChangeStatus(limitType)
	self.exChangeStatus = 0
	if limitType ~= 0 and self.curExchangeNum >= self.limitNum then
		self.exChangeStatus = 2
	else
		for _, v in ipairs(self.exchangeitemList) do
			local ownNum = publicUtil.getCount(v.id)
			if ownNum < v.count then
				self.exChangeStatus = 1
				break
			end
		end
	end
end
function ExchangeEventSingle:setLeftCount(limitType, limitnum, curExchangeNum)
	if limitType == 0 or limitnum == 0 then
		self.Text_leftCount:setString("")
	else
		self.leftCount = math.max(0, limitnum - curExchangeNum)
		local countStr = string.format("%d/%d", self.leftCount, limitnum)
		if limitType == 1 then
			_ENV = nil
			;(nil).count = countStr
			self.Text_leftCount:setString(i18n("exchange_columntext_01", nil))
		elseif limitType == 3 then
			_ENV = i18n("exchange_columntext_01", nil)
			i18n("exchange_columntext_01", nil).num = self.leftCount
			i18n("exchange_columntext_01", nil).limitNum = limitnum
			self.Text_leftCount:setString(i18n("shop_text_16", i18n("exchange_columntext_01", nil)))
		else
			_ENV = i18n("shop_text_16", i18n("exchange_columntext_01", nil))
			i18n("shop_text_16", i18n("exchange_columntext_01", nil)).count = countStr
			self.Text_leftCount:setString(i18n("common_text_1673", i18n("shop_text_16", i18n("exchange_columntext_01", nil))))
		end
	end
end
function ExchangeEventSingle:setBtnExchangeStatus()
	if self.exChangeStatus == 0 then
		self.Button_exchange:setGrayed(false)
		self.Button_exchange:setTitleColor(cc.c3b(255, 255, 255))
	elseif self.exChangeStatus == 1 then
		self.Button_exchange:setGrayed(false)
		self.Button_exchange:setTitleColor(cc.c3b(255, 0, 0))
	elseif self.exChangeStatus == 2 then
		self.Button_exchange:setGrayed(true)
		self.Button_exchange:setTitleColor(cc.c3b(115, 115, 115))
	end
end
function ExchangeEventSingle:onBtnCallBack(context)
	SoraDPlaySound()
	if self.exChangeStatus == 2 then
		SoraDShowMsgTip(i18n("common_text_1865"))
	elseif self.exChangeStatus == 1 then
		if IsArClient and self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_RAMADAN then
			SoraDShowMsgBox(i18n("common_text_2086"), i18n("common_text_204"), i18n("common_text_185"), function(boxEvent)
				if boxEvent == MSGBOX_CALLBACK_YES then
					if self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_RAMADAN then
						clientEventMgr.singleClickEvent(gActivityTimeActivityID.COFFEE_CRAFTSMAN_ACTIVITY)
					else
						_ENV = nil
						;(nil).type = 1
						;(nil).jumpStore = "btnOther"
						uiManager:show("bagView", nil)
					end
				end
			end)
		elseif self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_SNATCH_TREASURE then
			local eventState = activityShowCtrl:getStateByID(gActivityTimeActivityID.EXCHANGE_MALL_SNATCH_TREASURE)
			if eventState == gActivityState.OPEN then
				local panel = SoraDCreatePanel("raidersLostArkView")
				panel:show()
			else
				SoraDShowMsgTip(i18n("common_text_2486"))
			end
		else
			SoraDShowMsgTip(i18n("common_text_2512"))
		end
	elseif #self.shopItemList == 1 and #self.exchangeitemList == 1 then
		local maxNum = math.floor(self.ownCount / self.singleCount)
		local tempItemID = self.itemID
		if self.leftCount and self.leftCount > 0 then
			maxNum = math.min(math.floor(self.ownCount / self.singleCount), self.leftCount)
		end
		_ENV, _ENV, _ENV = i18n("common_text_2512")
		i18n("common_text_2512").targetID = self.itemID
		i18n("common_text_2512").exchangeID = self.toolID
		i18n("common_text_2512").singCount = self.singleCount
		i18n("common_text_2512").curNum = maxNum
		i18n("common_text_2512").exchangeData, i18n("common_text_2512").singleGet = i18n("common_text_2512")
		self.singleCount.exchangeCfg, i18n("common_text_2512").exchangeHandler = i18n("common_text_2512")
		uiManager:show("newShopSingleBuy", self.singleCount)
	else
		_ENV = uiManager
		uiManager.shopItemList = self.shopItemList
		uiManager.exchangeItemList = self.exchangeitemList
		uiManager.leftCount = self.leftCount
		function uiManager.exchangeHandler(exchangeNum)
			newExchangeMallCtrl:reqNewExchangeGood(self.storeID, exchangeNum)
		end
		uiManager:show("ShopSingleMoreBuy", uiManager)
	end
end
function ExchangeEventSingle:exChangeCallback(itemID, exchangeNum)
	if self.storeID then
		newExchangeMallCtrl:reqNewExchangeGood(self.storeID, exchangeNum)
	else
		exchangeMallCtrl:sendExchange(itemID, exchangeNum, self.activityID, self.exchangeItemID)
	end
end
function ExchangeEventSingle:onCheckBoxCallBack(context)
	if self.activityID == gActivityTimeActivityID.SULTAN_BACK_MAIN_ACTIVITY or self.activityID == gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010011 then
		if self.CheckBox_notify:isSelected() then
			SoraDPlaySound()
			activityExchangeMallCtrl:reqExchangeRemind(self.shopItemID, 1)
		elseif not self.CheckBox_notify:isSelected() then
			SoraDPlaySound()
			activityExchangeMallCtrl:reqExchangeRemind(self.shopItemID, 0)
		end
	elseif self.CheckBox_notify:isSelected() then
		SoraDPlaySound()
		if self.storeID then
			newExchangeMallCtrl:reqNewExchangeRemind(self.storeID, 1)
		else
			exchangeMallCtrl:sendExchangeRemind(self.itemID, 1, self.activityID, self.exchangeItemID)
		end
	elseif not self.CheckBox_notify:isSelected() then
		SoraDPlaySound()
		if self.storeID then
			newExchangeMallCtrl:reqNewExchangeRemind(self.storeID, 0)
		else
			exchangeMallCtrl:sendExchangeRemind(self.itemID, 0, self.activityID, self.exchangeItemID)
		end
	end
end
function ExchangeEventSingle:onToItemRender(index, object)
	local itemInfo = self.shopItemList[index + 1]
	object:initData(itemInfo.id, itemInfo.count)
end
function ExchangeEventSingle:onFromItemRender(index, object)
	local itemID = self.exchangeitemList[index + 1].id
	local needNum = self.exchangeitemList[index + 1].count
	local ownNum = publicUtil.getCount(itemID)
	object:initData(itemID)
	local stringColor = "#FFFFFF"
	if needNum > ownNum then
		stringColor = "#BE2828"
	else
		stringColor = "#36bf36"
	end
	object:setNum(ownNum, needNum, stringColor)
end
return ExchangeEventSingle
