local heroJailCtrl = SoraDGetCtrl("heroJailCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroPayMoneyPanel = class("HeroPayMoneyPanel", baseFguiPanel)
function HeroPayMoneyPanel:ctor(...)
	self.super.ctor(self, ...)
	print("HeroPayMoneyPanel:ctor", self.viewName)
end
function HeroPayMoneyPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function HeroPayMoneyPanel:onInit()
	print("=======HeroPayMoneyPanel:onInit")
	self.fields.Label_resNum:fixChildrenPos()
	self.fields.Button_getRes:fixPos()
	self.heroJailInfo = self.proxy.param.jailInfo
	self.heroExInfo = heroltCtrl.getHeroInfo(self.heroJailInfo.heroID)
	self.fields.Panel_bg:setString(i18n("hero_btn_03"))
	self.fields.Text_Tips:setString(i18n("hero_text_17"))
	self.fields.Label_resNum:getChild("Text_realGain"):setString(i18n("hero_text_87"))
	self.fields.Label_resNum:getChild("Text_realGain"):setColor(cc.c3b(215, 195, 155))
	self.fields.Button_getRes:setTitleText(i18n("common_text_337"))
	self.fields.Button_ok:setTitleText(i18n("common_text_204"))
	self.fields.Button_ok:addClickListener(handler(self, self.btnOkClick))
	self.fields.Button_getRes:addClickListener(handler(self, self.btnResClick))
end
function HeroPayMoneyPanel:onShow()
	print("=======HeroPayMoneyPanel:onShow")
	self:initView()
end
function HeroPayMoneyPanel:initView(...)
	self.fields.Com_Hero:initData(self.heroJailInfo.heroID)
	self.fields.Text_heroName:setString(i18n(self.heroExInfo.herName))
	self:initResData()
end
function HeroPayMoneyPanel:initResData()
	self.resData = self.heroJailInfo.ransomData
	self.fields.Label_resNum:setIcon(publicRead.getSmallIcon(self.resData.id))
	self.fields.Label_resNum:setString(string.formatnumberthousands(self.resData.num))
	self:refreshRes()
end
function HeroPayMoneyPanel:refreshRes(...)
	local curNum = cityCtrl:getNormalRes(self.resData.id)
	if curNum < self.resData.num then
		self.fields.Label_resNum:getChild("title"):setColor(display.COLOR_RED)
		self.fields.Button_getRes:setVisible(true)
	else
		self.fields.Label_resNum:getChild("title"):setColor(display.COLOR_GREEN)
		self.fields.Button_getRes:setVisible(false)
	end
end
function HeroPayMoneyPanel:btnOkClick()
	SoraDPlaySound()
	local resCurNum = cityCtrl:getNormalRes(self.resData.id)
	if resCurNum < self.resData.num then
		SoraDShowMsgTip(i18n("hero_text_90"))
		return
	end
	local resName = publicRead.getName(self.resData.id)
	_ENV = i18n("hero_text_90")
	_ENV = i18n("hero_text_90")
	i18n("hero_text_90").res = SoraDConvertNumberWithUnit(self.resData.num) .. resName
	i18n("hero_text_90").content = i18n("hero_text_18", i18n("hero_text_90"))
	i18n("hero_text_90").confirmString = i18n("common_text_054")
	i18n("hero_text_90").confirmFunc = function()
		SoraDShowLoading(self)
		heroJailCtrl:reqPayRansom(self.heroJailInfo.heroID)
	end
	uiManager:show("MessageBox", i18n("hero_text_90")):setOwnerKey(self)
end
function HeroPayMoneyPanel:btnResClick()
	SoraDPlaySound()
	_ENV, cityCtrl = nil, SoraDPlaySound
	;(nil).resid = self.heroJailInfo.ransomData.id
	;(nil).rescount = self.heroJailInfo.ransomData.num
	;(nil).curcount = cityCtrl:getNormalRes(self.heroJailInfo.ransomData.id)
	local SoraDPlaySound[1], needResList = nil, SoraDPlaySound
	_ENV = self.heroJailInfo.ransomData.id
	self.heroJailInfo.ransomData.id.rid = self.heroJailInfo.ransomData.id
	self.heroJailInfo.ransomData.id.needResData = needResList
	uiManager:show("resourceBuyView", self.heroJailInfo.ransomData.id)
end
return HeroPayMoneyPanel
