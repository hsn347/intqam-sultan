local gametop = gModuleMgr.getObject("gametop")
local legendPointsCtrl = gametop.playertop_:getModule("legendPointsCtrl")
local activityExchangeMallCtrl = gametop.playertop_:getModule("activityExchangeMallCtrl")
local landOfSoulCtrl = SoraDGetCtrl("landOfSoulCtrl")
local legendaryExchangeSingle = class("legendaryExchangeSingle", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("legendaryExchangeSingle")
	end
	return target
end)
local colorRed = cc.c3b(255, 0, 0)
function legendaryExchangeSingle:ctor()
	self.CheckBox_notify = SoraDGetChildByName(self, "CheckBox_notify")
	self.CheckBox_notify:addEventListener(handler(self, self.onCheckBoxCallBack))
	self.Text_notify = SoraDGetChildByName(self, "Text_notify")
	self.Text_notify:setString(i18n("exchange_btn_01"))
	self.itemNode = SoraDGetExtendChildFromCCSByName(self, "CCS_commonItemAward")
	self.btn_operate = SoraDGetChildByName(self, "btn_operate")
	SoraDGetChildByName(self.btn_operate, "Text_btnName"):setString(i18n("common_text_1889"))
	self.btn_operate:addTouchEventListener(handler(self, self.onClick_btn_operate))
	self.nodeNeed = SoraDGetChildByName(self.btn_operate, "Node_Need")
	self.text_num = SoraDGetChildByName(self, "text_num")
	self.text_buy = SoraDGetChildByName(self, "text_buy")
	self.btnExplain = SoraDGetChildByName(self, "btnExp")
	self.btnExplain:addTouchEventListener(handler(self, self.btnClickExplain))
	self.textLeftTime = SoraDGetChildByName(self, "Text_LeftTime")
	self.textLeftTime = SoraDChangeTextToHtml(self.textLeftTime)
	self.textLeftTime = SoraDCreateTimerLabel(self, self.textLeftTime)
	self.textLeftTime:setTimeEndListener(handler(self, self.onTimeEnd))
	self.nodeSpecial = SoraDGetChildByName(self, "Node_Special")
	self.textLeftTime:setColor(cc.c3b(255, 245, 175))
	self.iconShalou = SoraDGetChildByName(self, "icon_shalou")
end
function legendaryExchangeSingle:checkLimitTimeItem()
	_UPVALUE4_ = nil
	;(nil)[1] = 311301
	;(nil)[2] = 311302
	;(nil)[3] = 311303
	local (nil)[4], spItems = 311304, nil
	if SoraDisInList(self.itemData.shopitem, spItems) then
		self.nodeSpecial:setVisible(true)
		self:onTimeEnd()
	else
		self.btn_operate:setVisible(true)
		self.nodeSpecial:setVisible(false)
	end
end
function legendaryExchangeSingle:onTimeEnd()
	local leftTime = landOfSoulCtrl:getActivityRemainTime(self.activityID)
	if 0 < leftTime then
		self.textLeftTime:beginTime(leftTime)
	else
		self.textLeftTime:endTimeNoCauseEndCallBack()
		self.textLeftTime:setString(i18n("legendaryking_text_68"))
		self.btn_operate:setVisible(false)
	end
	self.iconShalou:setPositionX(SoraDFPosX(self.textLeftTime:getContentSize().width / 2 + 15, 0))
end
function legendaryExchangeSingle:initData(data, otherData)
	self.itemData = data
	if otherData then
		self.view = otherData.view
		self.scroll = otherData.scroll
		self.activityID = otherData.activityID
	end
	self.itemNode:setRealScale(0.8)
	self.itemNode:setOwnScroll(self.scroll)
	self.itemNode:initData(data.shopitem, data.shopitemnum)
	data.hasExchangeNum = self.activityID == gActivityTimeActivityID.LEGEND_LORD and legendPointsCtrl:getLegenPoint() or legendPointsCtrl:getKingStarPoint(self.activityID)
	data.buyNum = activityExchangeMallCtrl:getExchangeNum(self.activityID, data.shopItemID)
	local isNotify = activityExchangeMallCtrl:getRemindStatus(self.activityID, data.shopItemID) == 1
	self.CheckBox_notify:setSelected(isNotify)
	self.canBuyNum = self.itemData.limitnum - (self.itemData.buyNum or 0)
	self:checkLimitTimeItem()
	self:initView()
end
function legendaryExchangeSingle:initView()
	self.text_buy:setColor(cc.c3b(255, 255, 255))
	self.text_num:setColor(cc.c3b(255, 255, 255))
	_ENV = cc.c3b(255, 255, 255)
	cc.c3b(255, 255, 255).cur = string.formatnumberthousands(self.itemData.buyNum or 0)
	cc.c3b(255, 255, 255).total = string.formatnumberthousands(self.itemData.limitnum)
	self.text_num:setString(i18n("common_text_4417", cc.c3b(255, 255, 255)))
	self.text_buy:setString(string.formatnumberthousands(self.itemData.exchangenum))
	if self.itemData.hasExchangeNum < self.itemData.exchangenum then
		self.text_buy:setColor(colorRed)
	end
	if 0 >= self.canBuyNum then
		self.text_num:setColor(colorRed)
	end
	SoraDToCenter(self.nodeNeed)
end
function legendaryExchangeSingle:onClick_btn_operate(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.scroll and not SoraDIsNodeVisibleOnScroll(sender, self.scroll) then
			return
		end
		self:onClickOperate()
	end
end
function legendaryExchangeSingle:btnClickExplain(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("legendaryking_text_97"))
	end
end
function legendaryExchangeSingle:showBuyView()
	local needNum = self.itemData.exchangenum
	local total = self.itemData.limitnum
	local cur = self.itemData.buyNum
	local maxCount = total - cur
	local canBuyCount = math.floor(self.itemData.hasExchangeNum / needNum)
	maxCount = math.min(maxCount, canBuyCount)
	_ENV, _ENV, _ENV = nil, nil, nil
	;(nil).targetID = self.itemData.shopitem
	;(nil).exchangeID = self.itemData.exchangeitem
	;(nil).singCount = needNum
	;(nil).curNum = maxCount
	;(nil).huntCount = self.itemData.shopitemnum
	;(nil).exchangeData, (nil).singleGet = nil, self.itemData.shopitemnum
	;(nil).exchangeCfg, (nil).exchangeHandler = nil, function(num)
		self:onBuyItem(num)
	end
	uiManager:show("newShopSingleBuy", nil)
end
function legendaryExchangeSingle:onClickOperate()
	if self.canBuyNum == 0 then
		SoraDShowMsgTip(i18n("legendaryking_text_52"))
	elseif self.itemData and self.itemData.hasExchangeNum < self.itemData.exchangenum then
		local tip = self.activityID == gActivityTimeActivityID.KING_STAR_BATTLE and "kingstarbattle_text_16" or "legendaryking_text_53"
		SoraDShowMsgBox(i18n(tip), i18n("common_text_477"), nil, function(callType)
			if callType == MSGBOX_CALLBACK_YES then
				local panel = SoraDCreatePanel("legendaryExchangePointView")
				panel:initData(self.activityID == gActivityTimeActivityID.KING_STAR_BATTLE and worldMapDefine.KINGSTAR_KINGDOM_ID or nil)
				panel:show()
			end
		end)
	else
		self:showBuyView()
	end
end
function legendaryExchangeSingle:onBuyItem(num)
	activityExchangeMallCtrl:reqActivityExchange(self.itemData.shopItemID, num)
	SoraDShowLoading(self.view)
end
function legendaryExchangeSingle:onCheckBoxCallBack(button, event)
	if event == ccui.CheckBoxEventType.selected then
		SoraDPlaySound()
		activityExchangeMallCtrl:reqExchangeRemind(self.itemData.shopItemID, 1)
	elseif event == ccui.CheckBoxEventType.unselected then
		SoraDPlaySound()
		activityExchangeMallCtrl:reqExchangeRemind(self.itemData.shopItemID, 0)
	end
end
return legendaryExchangeSingle
