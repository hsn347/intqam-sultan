local newExchangeMallCtrl = SoraDGetCtrl("newExchangeMallCtrl")
local newExchangeMallRead = include("newExchangeMallRead")
local baseComponent = require("fgui.base.baseComponent")
local ExchangeShopSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://ExchangeShopNew/ExchangeShopSingle", ExchangeShopSingle)
function ExchangeShopSingle:onInit()
	self.fields.Rect_itemDetail:addEventListener(fgui.UIEventType.TouchBegin, handler(self, self.onToucBeginShow))
	self.fields.Rect_itemDetail:addEventListener(fgui.UIEventType.TouchEnd, handler(self, self.onToucEndShow))
	self.fields.item_Num2:setVisible(false)
	self.fields.com_line:setVisible(false)
end
local foreverTime = 315360000
local LONG_EVENT_TIME = 0.2
function ExchangeShopSingle:initData(data, parentList)
	self.parentList = parentList
	self.data = data
	self:setTag(data.activityID or 0)
	local ret, num = newExchangeMallCtrl:getReceiveStatusAndNum(self.data.activityID)
	self.fields.redPoint:setVisible(ret)
	local newActivityID = self:replaceResource(self.data.activityID)
	if not newExchangeMallRead.getNewCfg(newActivityID) then
		local newExchangeMallCtrl, newCfg = newExchangeMallRead.getNewCfg(newActivityID), newExchangeMallRead.getNewCfg(newActivityID)
	end
	local bgName = newCfg.exchcange_bg or string.format("bg_exchange_%d.png", newActivityID)
	self.fields.bg:setURL(bgName)
	if (not SoraDFIsRA() or not newCfg.wordart_ar) and not newCfg.wordart_en then
		_ENV = newActivityID
		newActivityID[1] = "ar"
		newActivityID[2] = "en"
		local lanName = SoraDGetImageNameByLang("bg_exchange_" .. newActivityID .. "_%s.png", newActivityID)
	end
	self.fields.lan:setURL(lanName)
	self:initTime(self.data)
	self.costIDArray = newExchangeMallCtrl:getCostIDByActivityID(self.data.activityID)
	self.fields.Rect_itemDetail:setTag(self.costIDArray[1] or 0)
	self.fields.Rect_itemDetail:setTouchable(self.data.activityID ~= gActivityTimeActivityID.EXCHANGE_MALL_DRESS_ROLL)
	local exchangeIndex = 0
	if self.costIDArray and #self.costIDArray >= 1 and self.data.activityID ~= gActivityTimeActivityID.EXCHANGE_MALL_DRESS_ROLL then
		for i, v in ipairs(self.costIDArray) do
			local item_Num = self.fields["item_Num" .. i]
			if item_Num then
				item_Num:setVisible(true)
				item_Num:initData(v, 1, 1)
			end
		end
		self.fields.item_Num1:setPositionY(#self.costIDArray > 1 and 171 or 168)
		exchangeIndex = #self.costIDArray > 1 and 1 or 0
	end
	self.fields.item_Num1:setVisible(self.data.activityID ~= gActivityTimeActivityID.EXCHANGE_MALL_DRESS_ROLL)
	local isNewExID = newCfg.new and newCfg.new == 1 or false
	print("isNewExID", isNewExID, newActivityID)
	self.fields.com_line:setVisible(isNewExID or self:isNewExchange(self.data.activityID))
	if isNewExID then
		self.controllers.c1:setSelectedIndex(exchangeIndex)
	end
	self.detailOnTouch = false
end
function ExchangeShopSingle:isNewExchange(activityID)
	_ENV = nil
	;(nil)[gActivityTimeActivityID.EXCHANGE_MALL_HYFL] = true
	local (nil)[gActivityTimeActivityID.EXCHANGE_MALL_ICEDRADON_MARCH], newExchangeID = true, nil
	return newExchangeID[activityID] or false
end
function ExchangeShopSingle:replaceResource(actID)
	if actID == gActivityTimeActivityID.EXCHANGE_MALL_RED_GEM_CROSS_SERVER then
		self.fields.lan:setScale(0.9)
		return gActivityTimeActivityID.EXCHANGE_MALL_RED_GEM
	end
	return actID
end
function ExchangeShopSingle:setRedPointVisible(ret)
	if self and self.fields.redPoint then
		self.fields.redPoint:setVisible(ret)
	end
end
function ExchangeShopSingle:onItemRenderer(index, object)
	object:initData(self.costIDArray[index + 1], 1, 1)
end
function ExchangeShopSingle:onToucBeginShow(context)
	self.detailOnTouch = true
	self._touchStartPos = context:getInput():getPosition()
	self._input = context:getInput()
	self.target = self._input:getTarget()
	self.id = self.fields.Rect_itemDetail:getTag()
	_ENV = self.fields.Rect_itemDetail
	self.fields.Rect_itemDetail.msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
	SoraDSendMessage(self.fields.Rect_itemDetail)
	self.isLong = false
	local longTime = 0
	self:removeTouchTimer()
	self.showTimer = SoradCreateTimer(self, function(dt)
		if longTime >= LONG_EVENT_TIME then
			if self._input and self.target == self._input:getTarget() then
				local pos = self._input:getPosition()
				local distance = cc.pGetDistance(self._touchStartPos, pos)
				if tonumber(distance) <= TOUCH_MOVED_ERROR_VALUE then
					self.isLong = true
					SoraDPlaySound()
					longTime = TOUCH_MOVED_ERROR_VALUE
					TOUCH_MOVED_ERROR_VALUE.msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
					TOUCH_MOVED_ERROR_VALUE.id = self.id
					TOUCH_MOVED_ERROR_VALUE.num = nil
					TOUCH_MOVED_ERROR_VALUE.pos = self._touchStartPos
					TOUCH_MOVED_ERROR_VALUE.customName = nil
					TOUCH_MOVED_ERROR_VALUE.customTip = nil
					SoraDSendMessage(TOUCH_MOVED_ERROR_VALUE)
				end
			end
			self:removeTouchTimer()
			return
		end
	end, true)
end
function ExchangeShopSingle:removeTouchTimer()
	if self.showTimer then
		SoraDManagerRemoveTimer(self, self.showTimer)
		self.showTimer = nil
		self.detailOnTouch = false
	end
end
function ExchangeShopSingle:onToucEndShow()
	self:removeTouchTimer()
end
function ExchangeShopSingle:onclickShow(context)
	if self.detailOnTouch then
		return
	end
	if self.fields.Rect_itemDetail == context:getInput():getTarget() then
		return
	end
	SoraDPlaySound()
	if self:getTag() == gActivityTimeActivityID.ROARING_FLAME_WAR_EXCHANGE then
		uiManager:show("RoaringFlame_Shop")
		return
	end
	if self:getTag() == gActivityTimeActivityID.EXCHANGE_MALL_NEBULA_STONE then
		local id = self:getTag()
		if not newExchangeMallRead.isReachOpenLvByID(id) then
			local buildLogic = include("buildLogic")
			local config = newExchangeMallRead.getConfigByActivityID(id)
			_ENV = nil
			;(nil).lv = buildLogic.getBuildLvStr(config[1].exchangeLv)
			SoraDShowMsgTip(i18n("common_text_2749", nil))
			return
		end
	end
	if self.data.state and self.data.state == gActivityState.OPEN then
		_ENV = self.data.state
		local self.data.state.id, param = self:getTag(), self.data.state
		uiManager:show("ExchangeEventPage", param):setOwnerKey(self)
	else
		SoraDShowMsgTip(i18n("shop_text_10"))
	end
end
function ExchangeShopSingle:initTime(v)
	self.fields.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	local textState = self.fields.Text_time
	local activityState = v.state
	local activityRemainTime = v.remainTime
	if activityState == gActivityState.OPEN then
		if activityRemainTime >= foreverTime then
			textState:setString(i18n("shop_text_11"))
		else
			textState:setTimeLast(function(str)
				_ENV = nil
				;(nil).Time = str
				return i18n("shop_text_12", nil)
			end)
			textState:beginTime(activityRemainTime)
			textState:setTimeEndListener(function(...)
				self:initData(self.data)
			end)
		end
		textState:setColor(cc.c3b(0, 255, 0))
	elseif activityState == gActivityState.PREPARE then
		textState:setTimeLast(function(str)
			_ENV = nil
			;(nil).Time = str
			return i18n("shop_text_13", nil)
		end)
		textState:beginTime(activityRemainTime)
		textState:setTimeEndListener(function(...)
			self:initData(self.data)
		end)
	elseif activityState == gActivityState.CLOSE then
		textState:setString(i18n("shop_text_14"))
	end
	if v.activityID == gActivityTimeActivityID.EXCHANGE_MALL_XJZBFC then
		self.fields.Text_time:setVisible(false)
	else
		self.fields.Text_time:setVisible(true)
	end
end
function ExchangeShopSingle:onShow()
end
return ExchangeShopSingle
