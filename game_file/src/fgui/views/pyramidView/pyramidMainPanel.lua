local pyramidCtrl = SoraDGetCtrl("pyramidCtrl")
local guideCtrl = SoraDGetCtrl("guideCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local pyramidMainPanel = class("pyramidMainPanel", baseFguiPanel)
function pyramidMainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("pyramidMainPanel:ctor", self.viewName)
end
function pyramidMainPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function pyramidMainPanel:onInit()
	print("=======pyramidMainPanel:onInit")
	self.isShowLimitTip = false
	self.defaultRefreshPrice = pyramidCtrl:getCostRefresh()
	self.defaultBeginPrice = pyramidCtrl:getCostStart()
	self.defaultOneKeyPrice = pyramidCtrl:getCostOneKey()
	self.fields.Com_title:initData(i18n("common_text_1140"), handler(self, self.onClickClose), nil)
	self.fields.Button_copper:initData(gIDDef.COPPER, handler(self, self.onClickCopper))
	self.fields.Button_helpSmall:addClickListener(handler(self, self.onBtnHelp))
	self.fields.btnRefresh:addClickListener(handler(self, self.onBtnRefresh))
	self.fields.btnRefresh:setTitle(i18n("common_text_911"))
	self.fields.btnOneKey:addClickListener(handler(self, self.onBtnOneKey))
	self.fields.btnOneKey:setTitle(i18n("common_text_1141"))
	self.fields.btnBegin:addClickListener(handler(self, self.onBtnBegin))
	self.fields.btnBegin:setTitle(i18n("common_text_1139"))
	self.fields.com_Score:setString(i18n("common_text_1142"))
	self.fields.com_Score:setScore()
	self.fields.Text_actTip:setString(i18n("pyramids_text_1"))
	self.fields.check_Act:addClickListener(handler(self, self.onBtnCheckAct))
	_ENV = handler(self, self.onBtnCheckAct)
	handler(self, self.onBtnCheckAct).byUID = true
	local switch = SoraDConfigGet("Game:pyramidView:actSwitch~bool", handler(self, self.onBtnCheckAct)) or false
	self.fields.check_Act:setSelected(switch)
	_ENV = handler(self, self.onBtnCheckAct)
	handler(self, self.onBtnCheckAct).lv = VIP_LV8_LIMITED
	self.fields.text_vip_tip_refresh:setString(i18n("common_text_1144", handler(self, self.onBtnCheckAct)))
	_ENV = i18n("common_text_1144", handler(self, self.onBtnCheckAct))
	i18n("common_text_1144", handler(self, self.onBtnCheckAct)).lv = VIP_LV6_LIMITED
	self.fields.text_vip_tip_onekey:setString(i18n("common_text_1148", i18n("common_text_1144", handler(self, self.onBtnCheckAct))))
	self:checkMoreThanLimit()
end
function pyramidMainPanel:onShow()
	print("=======pyramidMainPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	if self:getHeight() > 1136 then
		self.fields.Label_banner:setPositionY(70)
	else
		self.fields.Label_banner:setPositionY(-55)
	end
	local floorItem1 = pyramidCtrl:getItemByFloor(1)
	if not floorItem1 then
		pyramidCtrl:sendInitData()
		SoraDShowLoading(self:displayObject())
		return
	end
	guideCtrl:updateGuideModule(gGuideModule.LOTTERY)
	self:updatePrice()
	self:updateCopperNum()
	self:updateBottom()
	self:updateItem()
	self:updateState()
	self:setScore()
end
function pyramidMainPanel:setScore()
	local score = pyramidCtrl:getScore() or 0
	self.fields.com_Score:setScore(score)
	self.fields.com_Content:setBarPercent(score)
end
function pyramidMainPanel:updateItem(actionEnabled)
	self.fields.com_Content:initWithData(actionEnabled)
end
function pyramidMainPanel:updateBottom()
	self:updateVipLevel()
	self:updateRefreshBtn()
	self:updateBeginBtn()
end
function pyramidMainPanel:updateScore(isSound, isNotAct)
	local score = pyramidCtrl:getScore() or 0
	if isSound then
		SoraDPlaySound("pyramid", 1)
	end
	pyramidCtrl = 1
	;(1).byUID = true
	local switch = SoraDConfigGet("Game:pyramidView:actSwitch~bool", 1) or false
	self.fields.com_Content:setBarPercent(score, not switch and not isNotAct)
	self.fields.com_Score:setScore(score)
	self.fields.com_Content:showRewardAnimation(switch or isNotAct)
end
function pyramidMainPanel:updateBeginBtn()
	local freeTimes = pyramidCtrl:getFreeTime()
	if freeTimes <= 0 then
		self.fields.btnBegin:setCostNum(self.defaultBeginPrice, self.copperNum)
	else
		self.fields.btnBegin:setFree(i18n("common_text_049"))
	end
	self.fields.btnOneKey:setCostNum(self.defaultOneKeyPrice, self.copperNum)
end
function pyramidMainPanel:updateRefreshBtn()
	if self.isFreeRefresh then
		self.fields.btnRefresh:setFree(i18n("common_text_049"))
	else
		self.fields.btnRefresh:setCostNum(self.defaultRefreshPrice, self.copperNum)
	end
end
function pyramidMainPanel:updateVipLevel()
	local vipLevel, isActive = SoraDGetVipLv()
	self.isFreeRefresh = isActive == true and vipLevel >= VIP_LV8_LIMITED
	self.isCanOneKey = isActive == true and vipLevel >= VIP_LV6_LIMITED
	self.fields.text_vip_tip_refresh:setVisible(not self.isFreeRefresh)
	self.fields.text_vip_tip_onekey:setVisible(not self.isCanOneKey)
end
function pyramidMainPanel:updateCopperNum()
	self.copperNum = pyramidCtrl:getCopperNum()
	self.fields.Button_copper:setString(tostring(self.copperNum))
end
function pyramidMainPanel:updateState()
	local awardState = pyramidCtrl:getAwardState()
	if awardState == gPyramidState.AWARD_WITH_CANNOT_THROW or awardState == gPyramidState.AWARD_WITH_CAN_THROW or awardState == gPyramidState.AWARD_WITH_CAN_THROW then
		self:openRewardView()
	elseif awardState == gPyramidState.BE_CONTINUE then
		pyramidCtrl = nil
		;(nil).byUID = true
		local switch = SoraDConfigGet("Game:pyramidView:actSwitch~bool", nil) or false
		if not switch then
			self:openDiceView()
			pyramidCtrl = self
			self.msg = "MESSAGE_UI_PYRAMID_SET_PYRAMID_MASK"
			self.isMask = true
			SoraDSendMessage(self)
		else
			pyramidCtrl:sendStartThrow()
		end
	end
end
function pyramidMainPanel:onClickCopper()
	SoraDPlaySound()
	self:showBuyCopper()
end
function pyramidMainPanel:showBuyCopper()
	uiManager:show("copperBuyView")
end
function pyramidMainPanel:onBtnHelp()
	SoraDPlaySound()
	_ENV = "common_text_001"
	;("common_text_001")[1] = i18n("common_text_1149")
	;("common_text_001")[2] = i18n("common_text_1149")
	SoraDShowFixWindow(i18n("common_text_001"), "common_text_001")
end
function pyramidMainPanel:onBtnCheckAct()
	SoraDPlaySound()
	local isSelected = self.fields.check_Act:isSelected()
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:pyramidView:actSwitch~bool", isSelected, nil)
end
function pyramidMainPanel:onBtnRefresh()
	SoraDPlaySound()
	if self.fields.com_Content.isShowingRewardAnimation or self:checkState() then
		return
	end
	if not self.isFreeRefresh then
		local isEnoughCopper = self:checkEnoughCopper(self.defaultRefreshPrice)
		if not isEnoughCopper then
			return
		else
			_ENV = self.defaultRefreshPrice
			self.defaultRefreshPrice.msg = "MESSAGE_UI_PYRAMID_SHOW_LOADING"
			self.defaultRefreshPrice.isShow = true
			SoraDSendMessage(self.defaultRefreshPrice)
			pyramidCtrl:sendRefreshItem()
		end
	else
		_ENV = pyramidCtrl.sendRefreshItem
		pyramidCtrl.sendRefreshItem.msg = "MESSAGE_UI_PYRAMID_SHOW_LOADING"
		pyramidCtrl.sendRefreshItem.isShow = true
		SoraDSendMessage(pyramidCtrl.sendRefreshItem)
		pyramidCtrl:sendRefreshItem()
	end
end
function pyramidMainPanel:onBtnOneKey()
	SoraDPlaySound()
	local todayPlayInfo = pyramidCtrl:getTodayPlayInfo()
	if todayPlayInfo and todayPlayInfo.bCanContinuePlay == false then
		_ENV = nil
		;(nil).num = todayPlayInfo.maxTodayPlayTime
		SoraDShowMsgTip(i18n("common_text_2820", nil))
		return
	end
	if not self.isCanOneKey then
		SoraDShowMsgBox(i18n("common_text_1403"), i18n("mail_text_67"), i18n("common_text_185"), function(event)
			if event == MSGBOX_CALLBACK_YES then
				uiManager:show("vipCenterView")
			end
		end)
		return
	end
	if self.fields.com_Content.isShowingRewardAnimation or self:checkState() then
		return
	end
	local isEnoughCopper = self:checkEnoughCopper(self.defaultOneKeyPrice)
	if not isEnoughCopper then
		return
	end
	_ENV = self.defaultOneKeyPrice
	self.defaultOneKeyPrice.msg = "MESSAGE_UI_PYRAMID_SHOW_LOADING"
	self.defaultOneKeyPrice.isShow = true
	SoraDSendMessage(self.defaultOneKeyPrice)
	pyramidCtrl:sendOneKeyThrow()
end
function pyramidMainPanel:onBtnBegin()
	SoraDPlaySound()
	local todayPlayInfo = pyramidCtrl:getTodayPlayInfo()
	if todayPlayInfo and todayPlayInfo.bCanContinuePlay == false then
		_ENV = nil
		;(nil).num = todayPlayInfo.maxTodayPlayTime
		SoraDShowMsgTip(i18n("common_text_2820", nil))
		return
	end
	if self.fields.com_Content.isShowingRewardAnimation or self:checkState() then
		return
	end
	local freeTimes = pyramidCtrl:getFreeTime()
	if freeTimes <= 0 then
		local isEnoughCopper = self:checkEnoughCopper(self.defaultBeginPrice)
		if not isEnoughCopper then
			return
		end
	end
	_ENV = self.defaultBeginPrice
	self.defaultBeginPrice.byUID = true
	local switch = SoraDConfigGet("Game:pyramidView:actSwitch~bool", self.defaultBeginPrice) or false
	if not switch then
		self:openDiceView()
		_ENV = self
		self.msg = "MESSAGE_UI_PYRAMID_SET_PYRAMID_MASK"
		self.isMask = true
		SoraDSendMessage(self)
	else
		pyramidCtrl:sendStartThrow()
	end
end
function pyramidMainPanel:openDiceView()
	pyramidCtrl = nil
	;(nil)[1] = ffa.delay(0.1)
	;(nil)[2] = ffa.callFunc(function()
		SoraDCreatePanel("pyramidDiceView"):show()
		pyramidCtrl:sendStartThrow()
	end)
	;(nil)[3] = ffa.callFunc(function()
		SoraDCreatePanel("pyramidDiceView"):show()
		pyramidCtrl:sendStartThrow()
	end)
	self:runAction(ffa.seq(nil))
end
function pyramidMainPanel:checkEnoughCopper(needCooper)
	local isEnough = false
	if needCooper > self.copperNum then
		SoraDShowMsgBox(i18n("common_text_1162"), i18n("common_text_477"), nil, function(type)
			if type == MSGBOX_CALLBACK_YES and not tolua.isnull(self) then
				self:showBuyCopper()
			end
		end)
	else
		isEnough = true
	end
	return isEnough
end
function pyramidMainPanel:checkState()
	local ret = false
	local awardState = pyramidCtrl:getAwardState()
	pyramidCtrl = nil
	;(nil).byUID = true
	local switch = SoraDConfigGet("Game:pyramidView:actSwitch~bool", nil) or false
	if awardState == gPyramidState.AWARD_WITH_CANNOT_THROW or awardState == gPyramidState.AWARD_WITH_CAN_THROW then
		self:openRewardView()
		ret = true
		if switch then
			ret = false
		end
	end
	return ret
end
function pyramidMainPanel:openRewardView()
	local award = pyramidCtrl:getAwardItemIDAndNum()
	if award and next(award) and award.itemnum > 0 then
		local showRewardPanel = function()
			local panel = SoraDSearchPanelFromManagerByName("pyramidRewardView")
			if panel then
				_ENV = nil
				;(nil).id = award.itemid
				;(nil).count = award.itemnum
				;(nil).multiple = award.multiple
				panel:initWithData(nil)
			else
				local pyramidRewardView = SoraDCreatePanel("pyramidRewardView")
				_ENV = award.multiple
				award.multiple.id = award.itemid
				award.multiple.count = award.itemnum
				award.multiple.multiple = award.multiple
				pyramidRewardView:initWithData(award.multiple)
				pyramidRewardView:show()
			end
		end
		local switch
		_ENV = nil
		;(nil)[1] = ffa.delay(switch and 0.1 or 0.5)
		;(nil)[2] = ffa.callFunc(function()
			showRewardPanel()
		end)
		;(nil)[3] = ffa.callFunc(function()
			showRewardPanel()
		end)
		self:runAction(ffa.seq(nil))
	end
end
function pyramidMainPanel:setPyramidMask(isMask)
	if isMask == true then
		self.fields.Mask_Layer:setVisible(true)
	else
		self.fields.Mask_Layer:setVisible(false)
	end
end
function pyramidMainPanel:updatePrice()
	self.defaultRefreshPrice = pyramidCtrl:getCostRefresh()
	self.defaultBeginPrice = pyramidCtrl:getCostStart()
	self.defaultOneKeyPrice = pyramidCtrl:getCostOneKey()
end
function pyramidMainPanel:checkMoreThanLimit()
	if pyramidCtrl:getMoreThanLimit() then
		if self.isShowLimitTip == true then
			return
		else
			self.isShowLimitTip = true
			SoraDShowMsgTip(i18n("common_text_2609"))
		end
	else
		self.isShowLimitTip = false
	end
end
function pyramidMainPanel:resetScore()
	self.fields.com_Score:setScore(0)
	self.fields.com_Content:resetScore()
end
return pyramidMainPanel
