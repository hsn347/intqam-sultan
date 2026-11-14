local rechargeDailyPopView = class("rechargeDailyPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("rechargeDailyPopView")
	end
	return target
end)
local gametop = gModuleMgr.getObject("gametop")
local dailyDiscountGiftCtrl = gametop.playertop_:getModule("dailyDiscountGiftCtrl")
local serverproxy = gModuleMgr.getObject("serverproxy")
_ENV = "serverproxy"
;("serverproxy").free = gCmd.REQ_RECEIVE_FREE_GIFT
local _ENV, ("serverproxy").special, REQtoSend = gCmd.REQ_RECEIVE_SPECIAL_GIFT, gCmd.REQ_RECEIVE_SPECIAL_GIFT, "serverproxy"
gCmd.REQ_RECEIVE_SPECIAL_GIFT.begin = 320
gCmd.REQ_RECEIVE_SPECIAL_GIFT.dis = 48
local gCmd.REQ_RECEIVE_SPECIAL_GIFT.size, giftPosMsg = 94, gCmd.REQ_RECEIVE_SPECIAL_GIFT
function rechargeDailyPopView:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.curType = nil
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.labelAlter = SoraDGetChildByName(self, "Text_alter")
	self.btnReceive = SoraDGetChildByName(self, "Button_receive")
	self.scroll = SoraDGetChildByName(self, "ScrollView_gifts")
	self.btnReceive:addTouchEventListener(handler(self, self.onClickReceive))
	self.curTime = nil
end
function rechargeDailyPopView:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_DAILYSPECIALGIFT_REFRESH", function(...)
		self.curTime = dailyDiscountGiftCtrl:getDailyDiscountGiftData().rewardGiftTime
		if not serviceFunctions.isSameDay(self.curTime) then
			SoraDShowMsgTip(i18n("spcial_office_text_03"))
			self.btnReceive:setTitleText(i18n("common_text_1146"))
			self.btnReceive:setTitleColor(cc.c3b(145, 145, 145))
			self.btnReceive:setTouchEnabled(false)
			self.btnReceive:setBright(false)
		else
			SoraDShowMsgTip(i18n("common_text_1892"))
			self:removeFromParent()
		end
	end)
	SoraDAddMessage(self, "MESSAGE_SERVER_RECHARGECENTER_DAILYFREEGIFT_REFRESH", function(...)
		SoraDShowMsgTip(i18n("common_text_1892"))
		self:removeFromParent()
	end)
end
function rechargeDailyPopView:initData(data)
	self.ccs_bg:setTitleName(i18n("hero_title_02"))
	self.curType = data.curType
	self.labelAlter:setString(data.content)
	self.btnReceive:setTitleColor(cc.c3b(255, 255, 255))
	if data.receiveTime ~= 0 and serviceFunctions.isSameDay(data.receiveTime) then
		self.btnReceive:setTitleText(i18n("common_text_1892"))
		self.btnReceive:setTitleColor(cc.c3b(145, 145, 145))
		self.btnReceive:setTouchEnabled(false)
		self.btnReceive:setBright(false)
	elseif data.buyGiftCount ~= nil and data.buyGiftCount < 3 then
		self.btnReceive:setTitleText(i18n("common_text_1146"))
		self.btnReceive:setTitleColor(cc.c3b(145, 145, 145))
		self.btnReceive:setTouchEnabled(false)
		self.btnReceive:setBright(false)
	else
		self.btnReceive:setTitleText(i18n("common_text_1146"))
		self.btnReceive:setTouchEnabled(true)
		self.btnReceive:setBright(true)
	end
	local giftsData = data.giftsData
	local posX = giftPosMsg.begin - 5 * giftPosMsg.dis
	local scrollWidth = math.max(self.scroll:getContentSize().width, #giftsData * 100)
	self.scroll:setInnerContainerSize(cc.size(scrollWidth, self.scroll:getContentSize().height))
	local allLine = math.ceil(#giftsData / 5)
	for index, item in pairs(giftsData) do
		local line = math.ceil(index / 5)
		local row = 0 < index % 5 and index % 5 or 5
		print("行数", line)
		print("row", row)
		local single = SoraDCreatePanel("commonItemAward")
		local pos = posX + (row - 1) * giftPosMsg.size
		if SoraDFIsRA() then
			pos = 540 - (posX + (row - 1) * giftPosMsg.size)
		end
		single:setPosition(cc.p(pos, self.scroll:getPositionY() + 240 - 80 * line))
		single:setScale(0.8)
		single:setOwnView(self)
		single:initData(item.id, item.count)
		single:addTo(self.scroll)
	end
end
function rechargeDailyPopView:onClickReceive(button, type)
	if type == ccui.TouchEventType.ended then
		self.curTime = serviceFunctions.systemTime()
		dailyDiscountGiftCtrl:receiveGift(REQtoSend[self.curType])
	end
end
return rechargeDailyPopView
