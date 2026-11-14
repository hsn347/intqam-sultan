local gametop = gModuleMgr.getObject("gametop")
local luxuryRebateCtrl = gametop.playertop_:getModule("luxuryRebateCtrl")
local luxuryRebateRead = include("luxuryRebateRead")
local luxuryRebateAwardView = class("luxuryRebateAwardView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("luxuryRebateAwardView")
	end
	return target
end)
function luxuryRebateAwardView:ctor()
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("PrideRebate_text_14"))
	self.txtAwardTitleNormal = SoraDGetChildByName(self, "Text_AwardTitle_normal")
	self.txtAwardTipNormal = SoraDGetChildByName(self, "Text_award_tip_normal")
	self.txtAwardTipGod = SoraDGetChildByName(self, "Text_award_tip_god")
	self.btnAwardNormal = SoraDGetChildByName(self, "Button_award_normal")
	self.txtAwardTitleGod = SoraDGetChildByName(self, "Text_AwardTitle_god")
	self.btnAwardGod = SoraDGetChildByName(self, "Button_award_god")
	self.btnBuy = SoraDGetChildByName(self, "Button_buy")
	self.imgTipsNormal = SoraDGetChildByName(self, "Image_bg_normal")
	self.imgTipsGod = SoraDGetChildByName(self, "Image_bg_god")
	self.nodeContentGod = SoraDGetChildByName(self, "Node_content_god")
	self.scrollViewNormal = SoraDGetChildByName(self, "ScrollView_normal")
	self.scrollViewGod = SoraDGetChildByName(self, "ScrollView_god")
	self.scrollViewNormal = include("commonAutoScrollList").new(self.scrollViewNormal)
	self.scrollViewNormal:setSingleCCS("commonItemSingle")
	self.scrollViewNormal:setIsRight(SoraDFIsRA())
	self.scrollViewGod = include("commonAutoScrollList").new(self.scrollViewGod)
	self.scrollViewGod:setSingleCCS("commonItemSingle")
	self.scrollViewGod:setIsRight(SoraDFIsRA())
	self.btnAwardNormal:addTouchEventListener(handler(self, self.onClickAwardNormal))
	self.btnAwardGod:addTouchEventListener(handler(self, self.onClickAwardGod))
	self.btnBuy:addTouchEventListener(handler(self, self.onClickBuy))
	self.textGold = SoraDGetChildByName(self, "Text_Gold")
	self.btnText = SoraDGetChildByName(self, "Text_Button")
	self.txtAwardTitleNormal:setString(i18n("PrideRebate_text_10"))
	self.txtAwardTipNormal:setString(i18n("PrideRebate_text_15"))
	self.btnAwardNormal:setTitleText(i18n("common_text_1146"))
	self.btnAwardGod:setTitleText(i18n("common_text_1146"))
	_ENV = self.btnAwardGod.setTitleText
	self.btnAwardGod.setTitleText.nodeTips = SoraDGetChildByName(self, "Text_award_tip_normal")
	self.btnAwardGod.setTitleText.scroll = self.scrollViewNormal
	self.btnAwardGod.setTitleText.nodeBtn = SoraDGetChildByName(self, "Node_op_normal")
	_ENV, self.tabNormal, self.btnAwardGod.setTitleText.btn = self.btnAwardGod.setTitleText, self.btnAwardGod.setTitleText, self.btnAwardNormal
	self.btnAwardGod.setTitleText.nodeTips = SoraDGetChildByName(self, "Text_award_tip_god")
	self.btnAwardGod.setTitleText.scroll = self.scrollViewGod
	self.btnAwardGod.setTitleText.nodeBtn = SoraDGetChildByName(self, "Node_op_god")
	self.tabGod, self.btnAwardGod.setTitleText.btn = self.btnAwardGod.setTitleText, self.btnAwardGod
	self.hasNormalItem = false
	self:initBtn()
	self:initView()
end
function luxuryRebateAwardView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_LUXURY_REBATE_REFRESH", handler(self, self.initView))
	SoraDAddMessage(self, "MESSAGE_LUXURY_REBATE_REWARD_RSP", handler(self, self.rspDispatchBack))
end
function luxuryRebateAwardView:initView()
	self.normalHasReward = false
	self:setAward_normal()
	self:setAward_god()
end
function luxuryRebateAwardView:initBtn()
	local giftId = luxuryRebateRead.getGiftID()
	local price = luxuryRebateRead.getGiftPrice()
	local goldStr = paymentManager.judgePrice(giftId, price)
	self.textGold:setString(goldStr)
	self.btnText:setString(i18n("common_text_282"))
end
local transItem = function(itemAll)
	local _ENV, items
	for _, dayItems in ipairs(itemAll) do
		for _, v in ipairs(dayItems) do
			table.insert(items, v)
		end
	end
	return items
end
function luxuryRebateAwardView:setAward_imp(tabCfg)
	if #tabCfg.items <= 0 then
		tabCfg.nodeTips:setVisible(true)
		tabCfg.scroll:setVisible(false)
		tabCfg.btn:setBright(false)
		tabCfg.btn:setTouchEnabled(false)
		return
	end
	tabCfg.nodeTips:setVisible(false)
	tabCfg.scroll:setVisible(true)
	tabCfg.btn:setBright(true)
	tabCfg.btn:setTouchEnabled(true)
	_ENV = nil
	;(nil).view = self
	;(nil).scroll = tabCfg.scroll
	;(nil).scale = 0.8
	;(nil).offset = cc.p(45, 45)
	tabCfg.scroll:updateScrollView(cc.size(90, 90), tabCfg.items, 5, nil)
end
function luxuryRebateAwardView:setAward_normal()
	if not luxuryRebateCtrl:getLuxuryAwardAll(false) then
		local luxuryRebateCtrl, items = luxuryRebateCtrl:getLuxuryAwardAll(false), luxuryRebateCtrl:getLuxuryAwardAll(false)
	end
	local itemsAll = transItem(items)
	self.tabNormal.items = itemsAll
	self:setAward_imp(self.tabNormal)
	local hasAward = 0 < #itemsAll
	self.tabNormal.nodeBtn:setVisible(hasAward)
	self.hasNormalItem = hasAward
end
function luxuryRebateAwardView:setAward_god()
	if not luxuryRebateCtrl:getLuxuryAwardAll(true, true) then
		local luxuryRebateCtrl, items = luxuryRebateCtrl:getLuxuryAwardAll(true, true), luxuryRebateCtrl:getLuxuryAwardAll(true, true)
	end
	local itemsAll = transItem(items)
	self.tabGod.items = itemsAll
	self:setAward_imp(self.tabGod)
	local hasAward = 0 < #itemsAll
	if luxuryRebateCtrl:isSpuerReward() then
		self.txtAwardTitleGod:setString(i18n("PrideRebate_text_11"))
		self.btnAwardGod:setVisible(true)
		self.btnBuy:setVisible(false)
		if not hasAward then
			self.txtAwardTipGod:setString(i18n("PrideRebate_text_15"))
		end
	else
		self.btnAwardGod:setVisible(false)
		self.btnBuy:setVisible(true)
		self.txtAwardTitleGod:setString(i18n("PrideRebate_text_17"))
		if not hasAward then
			self.txtAwardTipGod:setString(i18n("PrideRebate_text_16"))
		end
	end
end
function luxuryRebateAwardView:adjustUI()
	if self.hasNormalItem then
		self.imgTipsNormal:setContentSize(cc.size(510, 200))
		self.nodeContentGod:setPositionY(0)
		self.imgTipsGod:setContentSize(cc.size(510, 200))
		self.scrollViewGod:setContentSize(cc.size(520, 185))
		self.tabGod.nodeBtn:setPositionY(-240)
	else
		self.imgTipsNormal:setContentSize(cc.size(510, 80))
		self.nodeContentGod:setPositionY(180)
		self.tabGod.nodeBtn:setPositionY(-440)
		self.imgTipsGod:setContentSize(cc.size(510, 390))
		self.scrollViewGod:setContentSize(cc.size(520, 380))
	end
end
function luxuryRebateAwardView:rspDispatchBack(target, data)
	SoraDCloseLoading(self)
	if data.err ~= gErrDef.Err_None then
		self:removeFromParent()
	elseif self.itemList and #self.itemList > 0 then
		SoraDMailGainItems(self.itemList, true)
	end
	self.itemList = nil
end
function luxuryRebateAwardView:onClickAwardNormal(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		luxuryRebateCtrl:reqLuxuryRebateNormalReward()
		self.itemList = self.tabNormal.items
		SoraDShowLoading(self)
	end
end
function luxuryRebateAwardView:onClickAwardGod(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.itemList = self.tabGod.items
		luxuryRebateCtrl:reqLuxuryRebateLuxuryReward()
		SoraDShowLoading(self)
	end
end
function luxuryRebateAwardView:onClickBuy(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("luxuryRebateBuyView"):show()
		self:removeFromParent()
	end
end
return luxuryRebateAwardView
