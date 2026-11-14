local gametop = gModuleMgr.getObject("gametop")
local rechargeRead = include("rechargeRead")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local dailySpecialCtrl = gametop.playertop_:getModule("dailySpecialCtrl")
local weeklySpecialCtrl = gametop.playertop_:getModule("weeklySpecialCtrl")
local dailySpecialRewardTable = require_data("special_offer_daily_reward", true)
local dailySpecialPopView = class("dailySpecialPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("dailySpecialPopView")
	end
	return target
end)
_ENV, _UPVALUE5_ = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("dailySpecialPopView")
	end
	return target
end, "dailySpecialPopView"
_ENV, (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("dailySpecialPopView")
	end
	return target
end).posX = nil, 210
_ENV, (nil).posX = nil, 190
_ENV, (nil).posX = nil, 190
_ENV, (nil).posX = nil, 190
;(nil).posX = 80
;("dailySpecialPopView")[1] = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("dailySpecialPopView")
	end
	return target
end
;("dailySpecialPopView")[2] = nil
;("dailySpecialPopView")[3] = nil
;("dailySpecialPopView")[4] = nil
local ("dailySpecialPopView")[5], rewardPos = nil, "dailySpecialPopView"
function dailySpecialPopView:ctor()
	self:initControls()
end
function dailySpecialPopView:initControls()
	self.panel = SoraDGetChildByName(self, "Panel_cut")
	self.btnGet = SoraDGetChildByName(self, "btn_get")
	self.txtDes = SoraDGetChildByName(self, "text_des")
	self.panel:setPositionY(display.height / 2)
	self.btnGet:addTouchEventListener(handler(self, self.getClickCallBack))
end
function dailySpecialPopView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_DAILY_SPECIAL_GET_REWARD_BACK", handler(self, self.refreshData))
end
function dailySpecialPopView:initData(rewardList, number, isWeekly)
	if table.nums(rewardList) <= 0 then
		return
	end
	self.isWeekly = isWeekly
	for i, v in ipairs(rewardList) do
		local single = SoraDCreatePanel("eventGeocentricCell")
		single:initData(v.rewardId, v.rewardNum)
		single:setClickDelegate(handler(self, self.singleCellClick))
		single:setPosition(cc.p((i - 1) * 80 + rewardPos[table.nums(rewardList)].posX, 210))
		single:sendParentToButton(self)
		single:setScale(0.68)
		single:addTo(self.panel)
		if serviceFunctions.isSameDay(dailySpecialCtrl:getFreeGiftTime()) and number == 0 then
			single.nodeItem:setColor(cc.c3b(120, 120, 120))
		end
	end
	if number == 0 then
		self.txtDes:setString(i18n("daily_sale_text_03"))
		if serviceFunctions.isSameDay(dailySpecialCtrl:getFreeGiftTime()) then
			self.btnGet:setTitleText(i18n("common_text_1892"))
			self.btnGet:setEnabled(false)
			self.btnGet:getVirtualRenderer():setState(1)
		else
			self.btnGet:setTitleText(i18n("common_text_1146"))
			self.btnGet:setEnabled(true)
			self.btnGet:getVirtualRenderer():setState(0)
		end
		if self.isWeekly then
			self.txtDes:setString(i18n("weekly_sale_text_04"))
			if serviceFunctions.isSameYearWeeks(gWeekDay.MONDAY, weeklySpecialCtrl:getFreeGiftTime()) then
				self.btnGet:setTitleText(i18n("common_text_1892"))
				self.btnGet:setEnabled(false)
				self.btnGet:getVirtualRenderer():setState(1)
			else
				self.btnGet:setTitleText(i18n("common_text_1146"))
				self.btnGet:setEnabled(true)
				self.btnGet:getVirtualRenderer():setState(0)
			end
		end
	elseif number == 3 then
		self.txtDes:setString(i18n("weekly_sale_text_05"))
		if 3 > dailySpecialCtrl:getAlreadyBuyPackageNum() then
			self.btnGet:setTitleText(i18n("common_text_1146"))
			self.btnGet:setEnabled(false)
			self.btnGet:getVirtualRenderer():setState(1)
		elseif serviceFunctions.isSameDay(dailySpecialCtrl:getSpecialGiftTime()) and dailySpecialCtrl:getSpecialGiftTime() ~= 0 then
			self.btnGet:setTitleText(i18n("common_text_1892"))
			self.btnGet:setEnabled(false)
			self.btnGet:getVirtualRenderer():setState(1)
		else
			self.btnGet:setTitleText(i18n("common_text_1146"))
			self.btnGet:setEnabled(true)
			self.btnGet:getVirtualRenderer():setState(0)
		end
		if self.isWeekly then
			self.txtDes:setString(i18n("weekly_sale_text_05"))
			if 3 > weeklySpecialCtrl:getAlreadyBuyPackageNum() then
				self.btnGet:setTitleText(i18n("common_text_1146"))
				self.btnGet:setEnabled(false)
				self.btnGet:getVirtualRenderer():setState(1)
			elseif serviceFunctions.isSameYearWeeks(gWeekDay.MONDAY, weeklySpecialCtrl:getSpecialGiftTime()) then
				self.btnGet:setTitleText(i18n("common_text_1146"))
				self.btnGet:setEnabled(false)
				self.btnGet:getVirtualRenderer():setState(1)
			else
				self.btnGet:setTitleText(i18n("common_text_1146"))
				self.btnGet:setEnabled(true)
				self.btnGet:getVirtualRenderer():setState(0)
			end
		end
	end
	self.btnGet:setTag(number)
end
function dailySpecialPopView:refreshData(target, data)
	if serviceFunctions.isSameDay(dailySpecialCtrl:getFreeGiftTime()) then
		self.btnGet:setTitleText(i18n("common_text_1892"))
		self.btnGet:setEnabled(false)
		self.btnGet:getVirtualRenderer():setState(1)
	else
		self.btnGet:setTitleText(i18n("common_text_1146"))
		self.btnGet:setEnabled(true)
		self.btnGet:getVirtualRenderer():setState(0)
	end
	if self.isWeekly then
		if serviceFunctions.isSameYearWeeks(gWeekDay.MONDAY, weeklySpecialCtrl:getFreeGiftTime()) then
			self.btnGet:setTitleText(i18n("common_text_1892"))
			self.btnGet:setEnabled(false)
			self.btnGet:getVirtualRenderer():setState(1)
		else
			self.btnGet:setTitleText(i18n("common_text_1146"))
			self.btnGet:setEnabled(true)
			self.btnGet:getVirtualRenderer():setState(0)
		end
	end
end
function dailySpecialPopView:singleCellClick(pItem)
end
function dailySpecialPopView:getClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isWeekly then
			if button:getTag() == 0 then
				weeklySpecialCtrl:sendReceiveFreeGiftMsg()
			else
				weeklySpecialCtrl:sendReceiveSpecialGiftMsg()
			end
		elseif button:getTag() == 0 then
			dailySpecialCtrl:sendReceiveFreeGiftMsg()
		else
			dailySpecialCtrl:sendReceiveSpecialGiftMsg()
		end
		self:removeFromParent()
	end
end
function dailySpecialPopView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.DAILY_DISCOUNT_GIFT_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return dailySpecialPopView
