local happyEggCtrl = SoraDGetCtrl("happyEggCtrl")
local newLotteryRead = include("newLotteryRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HappyEggViewPanel = class("HappyEggViewPanel", baseFguiPanel)
function HappyEggViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("HappyEggViewPanel:ctor", self.viewName)
end
function HappyEggViewPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "DesertMining"
	end
	return self._packageList
end
function HappyEggViewPanel:onInit()
	print("=======HappyEggViewPanel:onInit")
	self.canPlead = true
	self.fields.n13:fixPos()
	self.fields.Text_PT:fixPos()
	self.fields.Text_Num:fixPos()
	self.activityID = gActivityTimeActivityID.LOTTERY_ACTIVITY_9001544
	self.itemID = newLotteryRead.getCostItemIDByActivityID(self.activityID)
	self.fields.Com_title:initData(i18n("activity_name_9001544"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Com_title:initCommonActivityTime(self.activityID)
	self.fields.Com_Choose:setString(i18n("Lamp_secret_text_12"))
	self.fields.Com_Choose:addClickListener(handler(self, self.onClickChoose))
	self.fields.Com_Stage:initData(newLotteryRead.getStageConfig(self.activityID, happyEggCtrl:getClassType()))
	self.fields.Com_Have:initData(self.itemID)
	self.fields.Text_PT:setString(i18n("common_text_448"))
	self.fields.Button_Cost:addClickListener(handler(self, self.onClickCost))
	self.fields.Button_Cost:setString(i18n("happyegg_06"))
	self.fields.Button_EndChoose:setString(i18n("Lamp_secret_text_12"))
	self.fields.Button_EndChoose:addClickListener(handler(self, self.onClickCost))
	self.fields.Button_Reset:addClickListener(handler(self, self.onClickChoose))
	self.fields.Button_Reset:setString(i18n("common_text_4152"))
	self.fields.Usm_Effect:setPrepareCallback(handler(self, self.effectPrepareBack))
	self.fields.Usm_Effect:setCompleteCallback(handler(self, self.effectComPletBack))
	self.fields.Button_Reset:getChild("ani"):setAllFrameName("dh_llkcz1_%02d.png", 1)
	_ENV = "dh_llkcz1_%02d.png"
	;("dh_llkcz1_%02d.png").byUID = true
	self.isSkipAni = SoraDConfigGet("Game:HappyEggView:ani~bool", "dh_llkcz1_%02d.png") or false
	self.fields.Text_tick:setString(i18n("happyegg_14"))
	self.fields.Check_tick:addClickListener(handler(self, self.btnTickClick))
	self.fields.Check_tick:setSelected(self.isSkipAni)
	self.fields.Text_tick:fixPos()
	self.fields.Check_tick:fixPos()
end
function HappyEggViewPanel:onShow()
	print("=======HappyEggViewPanel:onShow")
	SoraDShowLoading(self)
	happyEggCtrl:sendReqInitDataMsg()
	self:updateItemNum()
end
function HappyEggViewPanel:initEgg()
	self.poolTbl = happyEggCtrl:getPrizePoolTbl()
	for i = 1, 8 do
		if self.poolTbl[i] and self.poolTbl[i].get == 1 then
			local icon = newLotteryRead.getEggIcon(self.activityID, happyEggCtrl:getClassType(), self.poolTbl[i].orderID)
			self.fields[string.format("n%d", i - 1)]:setURL(icon)
		else
			self.fields[string.format("n%d", i - 1)]:setURL("img_happyegg_white.png")
		end
	end
	if not happyEggCtrl:isFirstChoose() then
		for i = 1, 8 do
			local reward = newLotteryRead.getRewardByItemOrder(self.activityID, happyEggCtrl:getClassType(), self.poolTbl[i].orderID)
			self.fields[string.format("Com_Item%d", i - 1)]:initData(reward[1].id, reward[1].count)
			if self.poolTbl[i] and self.poolTbl[i].get == 1 then
				self.fields[string.format("Com_Item%d", i - 1)]:setBright(false)
			else
				self.fields[string.format("Com_Item%d", i - 1)]:setBright(true)
			end
		end
	end
end
function HappyEggViewPanel:updateView()
	if not happyEggCtrl:isFirstChoose() then
		if happyEggCtrl:isAllPoolGot() then
			self.controllers.c1:setSelectedIndex(2)
			self.fields.Button_EndChoose:setString(i18n("happyegg_07"))
		else
			self.controllers.c1:setSelectedIndex(1)
			self.fields.Button_EndChoose:setString(i18n("Lamp_secret_text_12"))
		end
		self.fields.Button_Reset:setVisible(happyEggCtrl:isCanReset())
	else
		self.fields.Button_Reset:setVisible(false)
		self.controllers.c1:setSelectedIndex(0)
	end
end
function HappyEggViewPanel:updateButton()
	local lotteryCount = happyEggCtrl:getRoundLotteryCount()
	self.costNum = newLotteryRead.getCostNum(self.activityID, lotteryCount)
	self.fields.Button_Cost:setCost(self.itemID, self.costNum)
	self.fields.Button_Cost:setReddot(self.costNum <= SoraDGetCtrl("backpackCtrl"):getItemCount(self.itemID), -1)
end
function HappyEggViewPanel:updateItemNum()
	self.fields.Com_Have:updateNum()
end
function HappyEggViewPanel:updatePoint()
	self.lotteryCount = happyEggCtrl:getLotteryCount()
	self.fields.Com_Stage:setBarValue(self.lotteryCount, happyEggCtrl)
	self.fields.Text_Num:setString(string.formatnumberthousands(self.lotteryCount))
end
function HappyEggViewPanel:runAction(index, awardGain)
	self.lotteryIndex = index
	self.awardGain = awardGain
	if not self.isSkipAni then
		local effectName, pos = newLotteryRead.getEggEffect(self.activityID, happyEggCtrl:getClassType(), self.poolTbl[index].orderID)
		self.fields.Usm_Effect:clearEffect()
		self.fields.Usm_Effect:setVisible(true)
		self.fields.Usm_Effect:setPosition(self.fields[string.format("n%d", index - 1)]:getPosition())
		self.fields.Usm_Effect:setUsmPos(pos)
		self.fields.Usm_Effect:setEffectPath(effectName, false)
		self.fields[string.format("Com_Item%d", index - 1)]:setVisible(false)
	else
		self:effectComPletBack()
	end
end
function HappyEggViewPanel:effectPrepareBack()
	self.fields.Usm_Effect:play()
end
function HappyEggViewPanel:effectComPletBack()
	self.fields[string.format("Com_Item%d", self.lotteryIndex - 1)]:setVisible(true)
	local icon = newLotteryRead.getEggIcon(self.activityID, happyEggCtrl:getClassType(), self.poolTbl[self.lotteryIndex].orderID)
	self.fields[string.format("n%d", self.lotteryIndex - 1)]:setURL(icon)
	self.fields[string.format("Com_Item%d", self.lotteryIndex - 1)]:setBright(false)
	self.fields.Usm_Effect:setVisible(false)
	SoraDMailGainItems(self.awardGain, true)
	self.canPlead = true
end
function HappyEggViewPanel:onClickChoose()
	SoraDPlaySound()
	if not self.canPlead then
		return
	end
	if happyEggCtrl:isFirstChoose() then
		uiManager:show("HappyEggPop")
		return
	elseif happyEggCtrl:getLeftResetCont() <= 0 then
		SoraDShowMsgTip(i18n("Lamp_secret_text_16"))
		return
	end
	if happyEggCtrl:isCanReset() then
		_ENV = i18n("Lamp_secret_text_16")
		i18n("Lamp_secret_text_16").byUID = true
		local noticeTime = SoraDConfigGet("Game:HappyEggView:timeNotice1~integer", i18n("Lamp_secret_text_16")) or 0
		local isSameDay = serviceFunctions.isSameDay(noticeTime)
		if isSameDay then
			uiManager:show("HappyEggPop")
		else
			_ENV = i18n("Lamp_secret_text_16")
			_ENV = i18n("Lamp_secret_text_16")
			i18n("Lamp_secret_text_16").num = happyEggCtrl:getLeftResetCont()
			i18n("Lamp_secret_text_16").content = i18n("happyegg_11", i18n("Lamp_secret_text_16"))
			i18n("Lamp_secret_text_16").confirmFunc = function()
				uiManager:show("HappyEggPop")
			end
			i18n("Lamp_secret_text_16").cancelString = i18n("common_text_185")
			i18n("Lamp_secret_text_16").remindString = i18n("coffeeCraftsman_text_27")
			i18n("Lamp_secret_text_16").remindFunc = function(value)
				if value then
					_ENV = nil
					;(nil).byUID = true
					SoraDConfigSet("Game:HappyEggView:timeNotice1~integer", serviceFunctions.systemTime(), nil)
				end
			end
			uiManager:show("MessageBox", i18n("Lamp_secret_text_16"))
		end
	else
		SoraDShowMsgTip(i18n("happyegg_05"))
	end
end
function HappyEggViewPanel:onClickCost()
	SoraDPlaySound()
	if happyEggCtrl:isFirstChoose() then
		uiManager:show("HappyEggPop")
	elseif happyEggCtrl:isAllPoolGot() then
		SoraDShowMsgTip(i18n("happyegg_12"))
	elseif self.costNum <= SoraDGetCtrl("backpackCtrl"):getItemCount(self.itemID) then
		if self.canPlead then
			self.canPlead = false
			SoraDShowLoading(self)
			happyEggCtrl:reqCommonLottery9001544Lottery()
		end
	else
		self:jumpToGift()
	end
end
function HappyEggViewPanel:jumpToGift()
	_ENV = nil
	;(nil).itemID = self.itemID
	uiManager:show("CommonSourceGuide", nil)
end
function HappyEggViewPanel:btnTickClick()
	SoraDPlaySound()
	self.isSkipAni = not self.isSkipAni
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:HappyEggView:ani~bool", self.isSkipAni, nil)
end
function HappyEggViewPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("happyegg_01")
	uiManager:show("RuleView", nil)
end
return HappyEggViewPanel
