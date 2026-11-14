local gametop = gModuleMgr.getObject("gametop")
local activityExchangeMallCtrl = gametop.playertop_:getModule("activityExchangeMallCtrl")
local legendPointsCtrl = gametop.playertop_:getModule("legendPointsCtrl")
local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local landOfSoulCtrl = SoraDGetCtrl("landOfSoulCtrl")
local hegemonStoreSingle = class("hegemonStoreSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("hegemonStoreSingle")
	end
	return target
end)
function hegemonStoreSingle:ctor()
	self.exChangeStatus = 0
	self.Panel_touch = SoraDGetChildByName(self, "Panel_touch")
	self.Panel_touch:setSwallowTouches(false)
	SoraDGetChildByName(self, "Image_L"):setFillType(1)
	SoraDGetChildByName(self, "Image_R"):setFillType(1)
	self.CheckBox_notify = SoraDGetChildByName(self, "CheckBox_notify")
	self.CheckBox_notify:addEventListener(handler(self, self.onCheckBoxCallBack))
	self.Text_notify = SoraDGetChildByName(self, "Text_notify")
	self.Text_notify:setString(i18n("exchange_btn_01"))
	self.Text_leftCount = SoraDGetChildByName(self, "Text_leftCount")
	self.ccs_item = SoraDGetExtendChildFromCCSByName(self, "CCS_commonItemAward_item")
	self.Button_exchange = SoraDGetExtendChildFromCCSByName(self, "CCS_commonGoldSmallBtn_ex")
	self.Button_exchange:addTouchEventListener(handler(self, self.onBtnCallBack))
	self.Button_tip = SoraDGetChildByName(self, "Button_tip")
	self.Button_tip:setSwallowTouches(false)
	self.Button_tip:addTouchEventListener(handler(self, self.onBtnTipCallBack))
	self.Text_leftTime = SoraDGetChildByName(self, "Text_leftTime")
	self.Text_leftTime = SoraDCreateTimerLabel(self, self.Text_leftTime)
	self.Text_leftTime:setTimeEndListener(handler(self, self.onTimeEnd))
end
function hegemonStoreSingle:initData(data, otherData)
	self.view = otherData.view
	self.scroll = otherData.scroll
	self.activityID = otherData.activityID
	self.baseData = data
	local myPoint = legendPointsCtrl:getHegemonPoint()
	local leftCount = self.baseData.limitnum - activityExchangeMallCtrl:getExchangeNum(gActivityTimeActivityID.LEGEND_HEGEMON_1, self.baseData.shopItemID)
	legendPointsCtrl = nil
	;(nil).num = leftCount
	;(nil).total = self.baseData.limitnum
	self.Text_leftCount:setString(i18n("god_beast_text_13", nil))
	self.ccs_item:setOwnView(self.view)
	self.ccs_item:initData(self.baseData.shopitem, self.baseData.shopitemnum)
	legendPointsCtrl = self.baseData.shopitem
	self.baseData.shopitem.title = i18n("common_text_1889")
	self.baseData.shopitem.gold = self.baseData.exchangenum
	self.Button_exchange:initData(self.baseData.shopitem)
	self.Button_exchange:setIconTexture("1622.png")
	self.Button_exchange:setScroll(self.scroll)
	self.isEnough = myPoint >= self.baseData.exchangenum
	self.Button_exchange:setTextGoldColor(self.isEnough and cc.c3b(255, 255, 255) or cc.c3b(190, 40, 40))
	self.Button_exchange:setVisible(0 < leftCount)
	local isRemind = activityExchangeMallCtrl:getRemindStatus(gActivityTimeActivityID.LEGEND_HEGEMON_1, self.baseData.shopItemID)
	self.CheckBox_notify:setSelected(isRemind == 1)
	if self.baseData.shopitem == 311401 then
		self.Text_leftTime:setVisible(true)
		self.Button_exchange:setPositionY(45)
		self:onTimeEnd()
	else
		self.Text_leftTime:setVisible(false)
		self.Button_exchange:setPositionY(60)
		self.Button_tip:setVisible(false)
	end
end
function hegemonStoreSingle:onTimeEnd()
	local leftTime = self:getLeftTime()
	if 0 < leftTime then
		self.Text_leftTime:setPositionY(92)
		self.Text_leftTime:beginTime(leftTime)
		self.Button_tip:setVisible(true)
	else
		self.Text_leftTime:setPositionY(60)
		self.Button_tip:setVisible(false)
		self.Button_exchange:setVisible(false)
		self.Text_leftTime:setString(i18n("legendaryking_text_68"))
	end
end
function hegemonStoreSingle:getLeftTime()
	local leftTime = 0
	local joinBid = hegemonCtrl:getJoinBid()
	if joinBid then
		leftTime = landOfSoulCtrl:getActivityRemainTime(self.activityID)
	end
	return leftTime
end
function hegemonStoreSingle:onCheckBoxCallBack(button, event)
	if event == ccui.CheckBoxEventType.selected then
		SoraDPlaySound()
		activityExchangeMallCtrl:reqExchangeRemind(self.baseData.shopItemID, 1)
	elseif event == ccui.CheckBoxEventType.unselected then
		SoraDPlaySound()
		activityExchangeMallCtrl:reqExchangeRemind(self.baseData.shopItemID, 0)
	end
end
function hegemonStoreSingle:onBtnCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isEnough then
			local myPoint = legendPointsCtrl:getHegemonPoint()
			local leftCount = self.baseData.limitnum - activityExchangeMallCtrl:getExchangeNum(gActivityTimeActivityID.LEGEND_HEGEMON_1, self.baseData.shopItemID)
			local maxNum = math.min(leftCount, math.floor(myPoint / self.baseData.exchangenum))
			_ENV, _ENV, _ENV = math.floor(myPoint / self.baseData.exchangenum)
			math.floor(myPoint / self.baseData.exchangenum).targetID = self.baseData.shopitem
			math.floor(myPoint / self.baseData.exchangenum).exchangeID = self.baseData.exchangeitem
			math.floor(myPoint / self.baseData.exchangenum).singCount = self.baseData.exchangenum
			math.floor(myPoint / self.baseData.exchangenum).curNum = maxNum
			math.floor(myPoint / self.baseData.exchangenum).exchangeData, math.floor(myPoint / self.baseData.exchangenum).singleGet = math.floor(myPoint / self.baseData.exchangenum)
			math.floor(myPoint / self.baseData.exchangenum).exchangeCfg, math.floor(myPoint / self.baseData.exchangenum).exchangeHandler = math.floor(myPoint / self.baseData.exchangenum)
			uiManager:show("newShopSingleBuy", math.floor(myPoint / self.baseData.exchangenum))
		else
			SoraDShowMsgBox(i18n("hegemon_text_58"), i18n("common_text_204"), nil, function(callBack)
				if callBack == MSGBOX_CALLBACK_YES then
					SoraDCreatePanel("hegemonPointView"):show()
				end
			end)
		end
	end
end
function hegemonStoreSingle:onBtnTipCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowMsgTip(i18n("hegemon_text_59"))
	end
end
return hegemonStoreSingle
