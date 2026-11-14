local constantRead = include("constantRead")
local flyingStarWishCtrl = SoraDGetCtrl("flyingStarWishCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local FlyingStarWishPanel = class("FlyingStarWishPanel", baseFguiPanel)
function FlyingStarWishPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("FlyingStarWishPanel:ctor", self.viewName)
end
function FlyingStarWishPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "CommonBoxSingle"
	end
	return self._packageList
end
function FlyingStarWishPanel:onInit()
	print("=======FlyingStarWishPanel:onInit")
	self.fields.Button_task:fixPos()
	flyingStarWishCtrl:sendReqInitDataMsg()
	self.activityID = gActivityTimeActivityID.FLYING_STAR_WISH
	self.fields.Com_title:initData(i18n("activity_name_9001454"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Label_time:initCommonActivityTime(self.activityID)
	self.fields.Label_time:setTimeUpdateListener(handler(self, self.refreshPage))
	self.fields.Text_tip:setString(i18n("giftgiving_text_10"))
	self.fields.Button_buy:setTitleText(i18n("giftgiving_text_4"))
	self.fields.Button_buy:addClickListener(handler(self, self.onClickBuy))
	self.fields.Button_task:setTitleText(i18n("giftgiving_text_17"))
	self.fields.Button_task:addClickListener(handler(self, self.onClickTask))
	self.maxGivingCount = constantRead.getConstValue("GIFTGIVING_GIVING_MAX")
	self.maxCostGold = constantRead.getConstValue("GIFTGIVING_GOLD_MAX")
	self.fields.Usm_close:setPrepareCallback(function()
		self.fields.Usm_close:getCriSprite():start()
	end)
	self.fields.Usm_open:setCompleteCallback(function()
		self.transitions.t0:play()
		self.fields.Usm_close:setVisible(true)
	end)
end
function FlyingStarWishPanel:playGiftAni()
	self.fields.Usm_close:setVisible(false)
	self.fields.Usm_open:setAlpha(1)
	self.fields.Usm_close:setAlpha(0)
	self.fields.Usm_open:play(false)
end
function FlyingStarWishPanel:initData()
	_ENV = nil
	;(nil).num = flyingStarWishCtrl:getAllGiftCount()
	self.fields.Text_giftNum:setString(i18n("giftgiving_text_3", nil))
	_ENV = i18n("giftgiving_text_3", nil)
	i18n("giftgiving_text_3", nil).num = flyingStarWishCtrl:getAllPlayerCount()
	self.fields.Text_personNum:setString(i18n("giftgiving_text_2", i18n("giftgiving_text_3", nil)))
	_ENV = i18n("giftgiving_text_2", i18n("giftgiving_text_3", nil))
	i18n("giftgiving_text_2", i18n("giftgiving_text_3", nil)).num = self.maxGivingCount - flyingStarWishCtrl:getDayBuyCount()
	self.fields.Text_leftNum:setString(i18n("giftgiving_text_28", i18n("giftgiving_text_2", i18n("giftgiving_text_3", nil))))
	_ENV = i18n("giftgiving_text_28", i18n("giftgiving_text_2", i18n("giftgiving_text_3", nil)))
	i18n("giftgiving_text_28", i18n("giftgiving_text_2", i18n("giftgiving_text_3", nil))).num1 = self.maxCostGold - flyingStarWishCtrl:getDayBuyGold()
	i18n("giftgiving_text_28", i18n("giftgiving_text_2", i18n("giftgiving_text_3", nil))).num2 = self.maxCostGold
	self.fields.Text_leftCost:setString(i18n("giftgiving_text_31", i18n("giftgiving_text_28", i18n("giftgiving_text_2", i18n("giftgiving_text_3", nil)))))
	self.state, self.des = self:serverTimeToState()
	self.fields.Text_giving:setString(self.des)
	if self.fields.Text_giving:getWidth() > 580 then
		self.fields.Text_giving:setAutoSize(fgui.AutoSizeType.SHRINK)
		self.fields.Text_giving:setWidth(580)
	else
		self.fields.Text_giving:setAutoSize(fgui.AutoSizeType.BOTH)
	end
	self.controllers.c1:setSelectedIndex(self.state == 1 and 0 or 1)
	self:updateBtnRed()
end
function FlyingStarWishPanel:updateBtnRed()
	local visible, num = flyingStarWishCtrl:getReceiveStatusAndNum()
	self.fields.Button_task:getChild("Label_reddot"):initData(visible, num)
end
function FlyingStarWishPanel:refreshPage()
	local tb = os.date("!*t", serviceFunctions.systemTime())
	if tb.hour == 20 and tb.min == 0 and tb.sec <= 1 then
		print("20点刷新")
		self:initData()
		_ENV = self
		self.msg = "MESSAGE_FLYING_STAR_WISH"
		self.subMsg = "giveTimeEnd"
		SoraDSendMessage(self)
		return
	end
	if tb.hour == 22 and tb.min == 0 and tb.sec <= 1 then
		print("22点刷新")
		self:initData()
		return
	end
end
function FlyingStarWishPanel:refreshPageInZero()
	flyingStarWishCtrl:sendReqInitDataMsg()
	print("零点刷新")
end
function FlyingStarWishPanel:serverTimeToState()
	local time = serviceFunctions.systemTime() or os.time()
	local h = tonumber(os.date("!%H", time))
	if 0 <= h and h < 20 then
		return 1, ""
	elseif 0 < flyingStarWishCtrl:getDayBuyCount() and 20 <= h and h < 22 then
		return 2, i18n("giftgiving_text_7")
	elseif 0 < flyingStarWishCtrl:getDayBuyCount() then
		return 3, i18n("giftgiving_text_8")
	else
		return 4, i18n("giftgiving_text_9")
	end
end
function FlyingStarWishPanel:onClickBuy(eventContext)
	SoraDPlaySound()
	local time = serviceFunctions.systemTime() or os.time()
	local h = tonumber(os.date("!%H", time))
	if 0 <= h and h < 20 then
		if flyingStarWishCtrl:getDayBuyCount() >= self.maxGivingCount then
			SoraDShowMsgTip(i18n("giftgiving_text_5"))
		elseif flyingStarWishCtrl:getDayBuyGold() >= self.maxCostGold then
			SoraDShowMsgTip(i18n("giftgiving_text_25"))
		else
			uiManager:show("FlyingStarWishBuyGift"):setOwnerKey(self)
		end
	else
		SoraDShowMsgTip(i18n("giftgiving_text_6"))
	end
end
function FlyingStarWishPanel:onClickTask(eventContext)
	SoraDPlaySound()
	uiManager:show("FlyingStarWishTask"):setOwnerKey(self)
end
function FlyingStarWishPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	_ENV = nil
	;(nil).giving = self.maxGivingCount
	;(nil).gold = self.maxCostGold
	;(nil).content = i18n("giftgiving_text_1", nil)
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function FlyingStarWishPanel:onShow()
	print("=======FlyingStarWishPanel:onShow")
	self.fields.Usm_open:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
	self.fields.Usm_close:setBlendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA)
end
return FlyingStarWishPanel
