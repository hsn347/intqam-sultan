local rocketRushRead = include("rocketRushRead")
local publicRead = include("publicRead")
local rocketRushCtrl = SoraDGetCtrl("rocketRushCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SkyrocketViewPanel = class("SkyrocketViewPanel", baseFguiPanel)
function SkyrocketViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("SkyrocketViewPanel:ctor", self.viewName)
end
function SkyrocketViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function SkyrocketViewPanel:onInit()
	print("=======SkyrocketViewPanel:onInit")
	self.isFirst = true
	self.activityID = gActivityTimeActivityID.ROCKET_RUSH
	self.exchange_activityID = gActivityTimeActivityID.EXCHANGE_MALL_SKYROCKET
	self.classType = rocketRushCtrl:getClassType()
	self.expandCfgItem1, self.expandCfgCount1 = rocketRushRead.getExpandItemCfg(self.classType, 1)
	self.expandCfgItem2, self.expandCfgCount2 = rocketRushRead.getExpandItemCfg(self.classType, 2)
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Btn_one:setString(i18n("common_text_284"))
	self.fields.Btn_one:setCostIcon(publicRead.getIcon(self.expandCfgItem1))
	self.fields.Btn_one:addClickListener(handler(self, self.btnOneClick))
	self.fields.Lab_one:setString(i18n("common_text_4458"))
	self.fields.Btn_two:setString(i18n("common_text_284"))
	self.fields.Btn_two:setCostIcon(publicRead.getIcon(self.expandCfgItem2))
	self.fields.Btn_two:addClickListener(handler(self, self.btnTwoClick))
	self.fields.Lab_two:setString(i18n("common_text_4458"))
	self.fields.Btn_exchangeShop:setString(i18n("common_text_1809"))
	self.fields.Btn_exchangeShop:addClickListener(handler(self, self.btnExchangeShopClick))
	self.fields.Btn_rank:setString(i18n("common_text_851"))
	self.fields.Btn_rank:addClickListener(handler(self, self.btnRankClick))
	self.fields.Btn_icon:addClickListener(handler(self, self.btnRewardClick))
	self.fields.Btn_exchangeShop:fixPos()
	self.fields.Btn_rank:fixPos()
	self.fields.Btn_icon:fixPos()
	self.fields.Bar:setScaleX(SoraDFIsRA() and -1 or 1)
	self.fields.Text_progress:fixPos()
	self.fields.Icon_item:fixPos()
	self.fields.Btn_one:fixPos()
	self.fields.Btn_two:fixPos()
	self.fields.Lab_one:fixPos()
	self.fields.Lab_two:fixPos()
	self.fields.Usm_yfct:setEffectPath("YFCT_daiji01.usm")
end
function SkyrocketViewPanel:onShow()
	print("=======SkyrocketViewPanel:onShow")
	if allianceMgr:hasJoinAlliance() then
		rocketRushCtrl:sendData()
		SoraDShowLoading(self)
	else
		self:updateView()
	end
end
function SkyrocketViewPanel:updateView(target, data)
	SoraDCloseLoading(self)
	local isAct = false
	if data and data.isDonate and data.err == gErrDef.Err_None then
		if self.isFirst then
			self.fields.Usm_yfct:setEffectPath("YFCT_donghua.usm,YFCT_daiji02.usm")
		else
			self.fields.Usm_yfct:setEffectPath("YFCT_donghua01.usm,YFCT_daiji02.usm", nil, true)
		end
		isAct = true
		self.isFirst = false
	end
	self.curLevel = rocketRushCtrl:getCurRewardLevel()
	self.chestPoint = rocketRushRead.getChestPoint(self.classType, self.curLevel)
	print("self.curLevel,self.chestPoint=====", self.curLevel, self.chestPoint)
	self.fields.Bar:setMax(self.chestPoint)
	local hasRewardCount = rocketRushCtrl:getHasRewardCount()
	local chestLimit = rocketRushRead.getChestLimit(self.classType)
	if hasRewardCount >= chestLimit then
		self.fields.Bar:setBarValue(self.chestPoint)
		self.fields.Text_progress:setString(i18n("common_text_2601"))
		self.fields.Btn_icon:setStatus(0)
	else
		local allianceScore = rocketRushCtrl:getAllianceScore()
		local mayGetCount = rocketRushCtrl:getMayGetCount()
		local curScore = math.min(allianceScore, self.chestPoint)
		self.fields.Bar:setBarValue(curScore, isAct)
		_ENV = i18n("common_text_2601")
		i18n("common_text_2601").var1 = string.formatnumberthousands(curScore)
		i18n("common_text_2601").var2 = string.formatnumberthousands(self.chestPoint)
		self.fields.Text_progress:setString(i18n("%{var1}/%{var2}", i18n("common_text_2601")))
		self.fields.Btn_icon:setStatus(mayGetCount)
	end
	_ENV = self.fields.Btn_icon
	self.fields.Btn_icon.var1 = hasRewardCount
	self.fields.Btn_icon.var2 = chestLimit
	self.fields.Btn_icon:setTitle(i18n("%{var1}/%{var2}", self.fields.Btn_icon))
	self.expandCount1 = backpackCtrl:getItemCount(self.expandCfgItem1)
	self.expandCount2 = backpackCtrl:getItemCount(self.expandCfgItem2)
	self.fields.Btn_one:setNumTotal2(self.expandCount1, self.expandCfgCount1, "#FF0000")
	self.fields.Btn_two:setNumTotal2(self.expandCount2, self.expandCfgCount2, "#FF0000")
end
function SkyrocketViewPanel:btnOneClick()
	SoraDPlaySound()
	if not allianceMgr:hasJoinAlliance() then
		SoraDShowMsgTip(i18n("EidalAdha_King_text_09"))
		return
	end
	if self.expandCount1 >= self.expandCfgCount1 then
		_ENV = i18n("EidalAdha_King_text_09")
		i18n("EidalAdha_King_text_09").itemID = self.expandCfgItem1
		i18n("EidalAdha_King_text_09").donateType = 1
		uiManager:show("SkyrocketPop", i18n("EidalAdha_King_text_09"))
	else
		_ENV = i18n("EidalAdha_King_text_09")
		i18n("EidalAdha_King_text_09").itemID = self.expandCfgItem1
		uiManager:show("CommonSourceGuide", i18n("EidalAdha_King_text_09"))
	end
end
function SkyrocketViewPanel:btnTwoClick()
	SoraDPlaySound()
	if not allianceMgr:hasJoinAlliance() then
		SoraDShowMsgTip(i18n("EidalAdha_King_text_09"))
		return
	end
	if self.expandCount2 >= self.expandCfgCount2 then
		_ENV = i18n("EidalAdha_King_text_09")
		i18n("EidalAdha_King_text_09").itemID = self.expandCfgItem2
		i18n("EidalAdha_King_text_09").donateType = 2
		uiManager:show("SkyrocketPop", i18n("EidalAdha_King_text_09"))
	else
		_ENV = i18n("EidalAdha_King_text_09")
		i18n("EidalAdha_King_text_09").itemID = self.expandCfgItem2
		uiManager:show("CommonSourceGuide", i18n("EidalAdha_King_text_09"))
	end
end
function SkyrocketViewPanel:btnExchangeShopClick()
	SoraDPlaySound()
	print("跳转到对应兑换商城======")
	if clientEventMgr.judgeIsOpen(self.exchange_activityID, true) then
		_ENV = nil
		;(nil).id = self.exchange_activityID
		uiManager:show("ExchangeEventPage", nil)
	end
end
function SkyrocketViewPanel:btnRankClick()
	SoraDPlaySound()
	if not allianceMgr:hasJoinAlliance() then
		SoraDShowMsgTip(i18n("EidalAdha_King_text_09"))
		return
	end
	_ENV = i18n("EidalAdha_King_text_09")
	i18n("EidalAdha_King_text_09").group = self.classType
	uiManager:show("SkyrocketRankView", i18n("EidalAdha_King_text_09"))
end
function SkyrocketViewPanel:btnRewardClick()
	SoraDPlaySound()
	uiManager:show("SkyrocketPointsGiftBox")
end
function SkyrocketViewPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("RocketRush_text_01")
	uiManager:show("RuleView", nil)
end
return SkyrocketViewPanel
