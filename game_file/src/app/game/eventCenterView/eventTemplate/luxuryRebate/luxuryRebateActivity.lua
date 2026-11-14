local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local luxuryRebateCtrl = gametop.playertop_:getModule("luxuryRebateCtrl")
local luxuryRebateRead = include("luxuryRebateRead")
local luxuryRebateDef = include("luxuryRebateDef")
local luxuryRebateActivity = class("luxuryRebateActivity", function(target)
	if target == nil then
		return SoraDCreateBasePanel("luxuryRebateActivity")
	end
	return target
end)
function luxuryRebateActivity:ctor()
	self.isHideCurrentSceneView = true
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnResurgence = SoraDGetChildByName(self, "Button_resurgence")
	self.btnBuy = SoraDGetChildByName(self, "Button_buy")
	self.txtBoxTitle = SoraDGetChildByName(self, "Text_box_title")
	self.txtActivieyTime = SoraDGetChildByName(self, "Text_activiey_time")
	self.txtInfoTitle = SoraDGetChildByName(self, "Text_info_title")
	self.txtInfoDay = SoraDGetChildByName(self, "Text_info_day")
	self.txtInfoStatus = SoraDGetChildByName(self, "Text_info_status")
	self.btns = SoraDGetExtendChildFromCCSByName(self, "CCS_luxuryRebateActivityTab_tab")
	self.btns:setContentSize(cc.size(640, 56))
	self.btns:setNewStyle()
	self.txtScrollTitleGod = SoraDGetChildByName(self, "Text_scroll_title_god")
	self.txtScrollTitleNormal = SoraDGetChildByName(self, "Text_scroll_title_normal")
	self.txtScrollTitleValue = SoraDGetChildByName(self, "Text_scroll_title_value")
	self.btnHelpTip = SoraDGetChildByName(self, "Button_help_tip")
	self.imgLeft = SoraDGetChildByName(self, "Top_Size_Image_Left")
	self.imgRight = SoraDGetChildByName(self, "Top_Size_Image_Right")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_award")
	self.title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.txtActiviteTip = SoraDGetChildByName(self, "Text_activite_tip")
	self.btnAward = SoraDGetChildByName(self, "Button_award")
	self.spAwardRed = SoraDGetChildByName(self, "Sprite_award_red")
	self.spBuyRed = SoraDGetChildByName(self, "Sprite_buy_red")
	self.spBoxRed = SoraDGetChildByName(self, "Sprite_box_red")
	self.nodeLock = SoraDGetChildByName(self, "Node_lock")
	self.nodeLine = SoraDGetChildByName(self, "Node_Single_line")
	self.btnHelp:addTouchEventListener(handler(self, self.onClickHelp))
	self.btnResurgence:addTouchEventListener(handler(self, self.onClickResurgence))
	self.btnResurgence:setPressedActionEnabled(false)
	self.btnBuy:addTouchEventListener(handler(self, self.onClickBuy))
	self.btnHelpTip:addTouchEventListener(handler(self, self.onClickHelpTip))
	self.btnAward:addTouchEventListener(handler(self, self.onClickAward))
	self.txtBoxTitle:setString(i18n("PrideRebate_text_06"))
	_G.SoraDChangeTextToHtml(self.txtInfoDay)
	_G.SoraDChangeTextToHtml(self.txtInfoStatus)
	self.txtScrollTitleGod:setString(i18n("PrideRebate_text_11"))
	self.txtScrollTitleNormal:setString(i18n("PrideRebate_text_10"))
	self.txtScrollTitleValue:setString(i18n("PrideRebate_text_09"))
	self.title:setTitle(i18n("activity_name_9001264"))
	self.txtActiviteTip:setString(i18n("PrideRebate_text_21"))
	self.btnAward:setTitleText(i18n("PrideRebate_text_14"))
	self.btnBuy:setTitleText(i18n("common_text_282"))
	self.txtActivieyTime = SoraDCreateTimerLabel(self, self.txtActivieyTime)
	self.curDay = nil
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("luxuryRebateActivitySingle")
	self:initView()
end
function luxuryRebateActivity:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_LUXURY_REBATE_REFRESH", handler(self, self.updateView))
end
function luxuryRebateActivity:initView()
	SoraDCreatAnimation("luxuryRebateActivity", self)
	self:initActivityTime()
	self:initTabs()
	self:updateView()
end
function luxuryRebateActivity:updateView()
	self:updateTabs()
	self:updateBox()
	self:updateAwardStatus()
	self:updateScroll()
	self.btns:updateStatus()
end
function luxuryRebateActivity:initActivityTime()
	local _eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.LUXURY_REBATE_ACTIVITY)
	if _eventTime then
		self.txtActivieyTime:beginTime(_eventTime.timerNode.timer:getRemainTime())
	end
	activityShowCtrl = _eventTime.timerNode.timer:getRemainTime()
	_eventTime.timerNode.timer:getRemainTime().byUID = true
	local ret = SoraDConfigGet("Game:luxuryRebateActivity:first~bool", _eventTime.timerNode.timer:getRemainTime())
	self.spBuyRed:setVisible(ret)
end
local maxday = luxuryRebateDef.MAX_DAY
function luxuryRebateActivity:initTabs()
	local maxday, configData
	configData.tabsetArray, maxday, configData.tabNum = maxday, maxday, maxday
	configData.defaultClick = math.min(luxuryRebateCtrl:getRechargeCurDay() or 1, maxday)
	for k = 1, maxday do
		maxday = nil
		maxday = nil
		;(nil).day = k
		;(nil).title = i18n("PrideRebate_text_08", nil)
		;(nil).handle = handler(self, self.btnClickCallBack)
		;(nil).tag = k
		table.insert(configData.tabsetArray, nil)
	end
	self.btns:setChooseLight()
	self.btns:reset()
	self.btns:initView(configData)
end
function luxuryRebateActivity:updateTabs()
	for i = 1, maxday do
		local needRedPoint = luxuryRebateCtrl:isHasLuxuryAwardByDay(i)
		self.btns:setRedPointState(i, needRedPoint)
	end
end
function luxuryRebateActivity:updateBox()
	if luxuryRebateCtrl:isBoxRewardGet() then
		self.txtInfoTitle:setString(i18n("PrideRebate_text_03"))
	else
		self.txtInfoTitle:setString(i18n("PrideRebate_text_02"))
	end
	do
		local numColor, status, width
		if luxuryRebateCtrl:isSpuerReward() then
			numColor = cc.c3b(255, 255, 255)
			status = i18n("common_text_3833")
			self.btnBuy:setVisible(false)
			self.btnHelpTip:setVisible(false)
			width = 350
		else
			numColor = cc.c3b(255, 0, 0)
			status = i18n("PrideRebate_text_05")
			width = 240
			self.btnBuy:setVisible(true)
			self.btnHelpTip:setVisible(true)
		end
		luxuryRebateCtrl = true
		luxuryRebateCtrl, luxuryRebateCtrl, (true).status = i18n("PrideRebate_text_02")
		;(0).status, i18n("PrideRebate_text_02").color = i18n("PrideRebate_text_02")
		local strDes = _G.i18n_html("PrideRebate_text_27", true, 0)
		self.txtInfoStatus:setString(strDes)
		_G.SoraDGetAutoHeightLabelNew(self.txtInfoStatus, width, true)
	end
	do
		local rechargeDay = luxuryRebateCtrl:getRechargeRewardDay()
		local numColor
		if rechargeDay >= luxuryRebateRead.getBoxAwardDay() then
			numColor = cc.c3b(255, 255, 255)
		else
			numColor = cc.c3b(255, 0, 0)
		end
		luxuryRebateCtrl = 0
		luxuryRebateCtrl, luxuryRebateCtrl, (0).num = width, 0, rechargeDay
		;(0).num, width.color = width, numColor
		local strDes = _G.i18n_html("PrideRebate_text_04", 0, 0)
		self.txtInfoDay:setString(strDes)
		_G.SoraDGetAutoHeightLabelNew(self.txtInfoDay, 350, true)
	end
	local canGetBox = luxuryRebateCtrl:checkCanGetBox()
	self.nodeLock:setVisible(not canGetBox)
	self.spBoxRed:setVisible(canGetBox and not luxuryRebateCtrl:isBoxRewardGet())
end
function luxuryRebateActivity:updateAwardStatus()
	local hasAward = luxuryRebateCtrl:isHasLuxuryAwardAll()
	self.spAwardRed:setVisible(hasAward)
end
function luxuryRebateActivity:updateScroll()
	local showList = luxuryRebateRead.getAwardListByDay(self.curDay)
	local height = 180 * #showList + 120
	self.nodeLine:setPositionY(height + 5)
	luxuryRebateRead = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	;(nil).customHeight = height
	self.scroll:updateScrollView(cc.size(640, 180), showList, 1, nil)
end
function luxuryRebateActivity:switchToDay(day)
	if day == self.curDay then
		return
	end
	self.curDay = day
	self:updateScroll()
	self.scroll:jumpToTop()
end
function luxuryRebateActivity:btnClickCallBack(tag, name)
	self:switchToDay(tag)
end
function luxuryRebateActivity:onClickHelp(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "PrideRebate_text_01"
		;("PrideRebate_text_01").align = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("PrideRebate_text_01"), "PrideRebate_text_01")
	end
end
function luxuryRebateActivity:onClickResurgence(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("luxuryRebateGiftView"):show()
	end
end
function luxuryRebateActivity:onClickBuy(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("luxuryRebateBuyView"):show()
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:luxuryRebateActivity:first~bool", false, nil)
		self.spBuyRed:setVisible(false)
	end
end
function luxuryRebateActivity:onClickHelpTip(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("PrideRebate_text_12"))
	end
end
function luxuryRebateActivity:onClickAward(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("luxuryRebateAwardView"):show()
	end
end
function luxuryRebateActivity:judgeClose()
	if not _G.clientEventMgr.judgeIsOpen(gActivityTimeActivityID.LUXURY_REBATE_ACTIVITY) then
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return luxuryRebateActivity
