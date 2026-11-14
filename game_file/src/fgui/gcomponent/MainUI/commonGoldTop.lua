local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseComponent = require("fgui.base.baseComponent")
local commonGoldTop = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/commonGoldTop", commonGoldTop)
function commonGoldTop:onInit()
	self.fields.et_gold:setAllFrameName("dh_zjmvipk_%.2d.png", 1)
	self.openOff = true
	self.dataGold = 0
	self.oriDataGold = 0
	self.scoreTextGold = SoraDCreateScoreLabel(self.fields.Text_gold, true)
	local updateHandler = function(...)
		self:addTextEffect(cc.c3b(255, 233, 155), cc.c3b(255, 253, 222))
	end
	self.scoreTextGold:setUpdateHandler(updateHandler)
	self:setUIModel(0)
	self:updateGold()
	self:addClickListener(handler(self, self.onBtnClick))
end
function commonGoldTop:onShow()
end
function commonGoldTop:addTextEffect(fromColor, toColor)
	self.fields.Text_gold:enableGradient(fromColor or cc.c3b(230, 219, 197), toColor or cc.c3b(178, 140, 68))
	self.fields.Text_gold:enableShadow(cc.c3b(98, 69, 13), cc.size(2, -2))
end
function commonGoldTop:registerEvent()
	SoraDAddMessage(self, "MESSAGE_LORDINFO_UPDATE_BASE", handler(self, self.updateGold))
end
function commonGoldTop:setRedPoint(ret)
	self.fields.Sprite_red:setVisible(ret)
end
function commonGoldTop:updateMonthRedPoint()
	local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
	local weeklyData = rechargeActivityCtrl:getWeekActivityList()
	if weeklyData and next(weeklyData) then
		for k, v in pairs(weeklyData) do
			if v.isbuy and not v.isdayget then
				return true
			end
		end
	end
	local monthData = rechargeActivityCtrl:getMonthActivityList()
	if monthData and next(monthData) then
		for k, v in pairs(monthData) do
			if v.isbuy and not v.isdayget then
				return true
			end
		end
	end
	local takeData = rechargeActivityCtrl:getTakeActivityList()
	if takeData and next(takeData) and takeData.isbuy and not takeData.isdayget then
		return true
	end
	return false
end
function commonGoldTop:updateGoldRedPoint()
	local getTabLength = function(_table)
		local leng = 0
		if _table == nil then
			return leng
		end
		for k, v in pairs(_table) do
			leng = leng + 1
		end
		return leng
	end
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local actOpen = activityShowCtrl:isActivityOpen(gActivityTimeActivityID.DAILY_DISCOUNT_GIFT_ACTIVITY)
	local dailyDiscountGiftCtrl = SoraDGetCtrl("dailyDiscountGiftCtrl")
	local isReceiveFreeGift = serviceFunctions.isSameDay(dailyDiscountGiftCtrl.dailyDiscountGiftData.freeGiftTime)
	local isReceiveSpecialGift = serviceFunctions.isSameDay(dailyDiscountGiftCtrl.dailyDiscountGiftData.rewardGiftTime)
	local _maxValue = getTabLength(dailyDiscountGiftCtrl.dailyDiscountGiftData.giftData)
	local _curValue = getTabLength(dailyDiscountGiftCtrl.dailyDiscountGiftData.buyGiftList)
	local isNeedReceiveSpeGift = not isReceiveSpecialGift and _maxValue == _curValue
	if actOpen and (not isReceiveFreeGift or isNeedReceiveSpeGift) then
		return true
	else
		return false
	end
end
function commonGoldTop:updateRechargeRedPoint()
	_UPVALUE1_ = nil
	;(nil)[1] = handler(self, self.updateMonthRedPoint)
	;(nil)[2] = handler(self, self.updateGoldRedPoint)
	;(nil)[3] = handler(self, self.updateGoldRedPoint)
	;(nil)[4] = handler(self, self.updateGoldRedPoint)
	;(nil)[5] = handler(self, self.updateGoldRedPoint)
	;(nil)[6] = handler(self, self.updateGoldRedPoint)
	;(nil)[7] = handler(self, self.updateGoldRedPoint)
	local (nil)[8], tableFun = handler(self, self.updateGoldRedPoint)
	for i, v in ipairs(tableFun) do
		if v() then
			self:setRedPoint(true)
			return
		end
	end
	self:setRedPoint(false)
end
function commonGoldTop:closeTouch()
	self.openOff = false
end
function commonGoldTop:updateGold()
	if self.rid and self.rid ~= gIDDef.GOLD then
		return
	end
	self.dataGold = lordInfoCtrl:getBaseInfo().gold
	self:refreshGoldTxt()
	self:updateRechargeRedPoint()
end
function commonGoldTop:refreshGoldTxt()
	if self.oriDataGold == 0 then
		self.fields.Text_gold:setString(string.formatnumberthousands(self.dataGold))
		self:addTextEffect(cc.c3b(255, 233, 155), cc.c3b(255, 253, 222))
	elseif self.oriDataGold and self.dataGold then
		self.scoreTextGold:runScoreAnimation(self.oriDataGold, self.dataGold, 1)
		self:addTextEffect(cc.c3b(255, 233, 155), cc.c3b(255, 253, 222))
	end
	self.oriDataGold = self.dataGold
end
function commonGoldTop:getGold()
	self:updateGold()
	return self.dataGold
end
function commonGoldTop:setUIModel(model)
end
function commonGoldTop:onBtnClick()
	SoraDPlaySound("uicontrol", 25)
	if self.handleGoldClick then
		self.handleGoldClick()
		return
	end
	_ENV = "uicontrol"
	;("uicontrol").msg = "MESSAGE_MAINCITYVIEW_LEAVE_MOVE_MODE"
	SoraDSendMessage("uicontrol")
	if self.openOff then
		advertiseCollect.TriggerEvent(gSDKDef.TDonEvent.advertise_coin_btn)
		if GLOBAL_GAME_RECHARGE_MODE then
			uiManager:show("rechargeView")
		else
			SoraDCreatePanel("rechargeView"):show()
		end
		paymentManager.openRechargeView(gRechargeActiveFromEnum.ROAD07)
	end
end
function commonGoldTop:initWithData(data)
	self:setUIModel(0)
	if data.rid then
		self.rid = data.rid
		self.fields.icon:setSpriteFrame(include("resDesRead").getIcon(self.rid))
		self.oriDataGold = 0
		if self.rid ~= gIDDef.GOLD then
			SoraDRemoveMessageFromTargetByName(self, "MESSAGE_LORDINFO_UPDATE_BASE")
		end
	end
	if data.rcount then
		self.dataGold = data.rcount
		self:refreshGoldTxt()
	end
	if data.handle then
		self.handleGoldClick = data.handle
	end
end
return commonGoldTop
