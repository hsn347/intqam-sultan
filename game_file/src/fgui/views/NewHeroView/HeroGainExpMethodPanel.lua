local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroGainExpMethodPanel = class("HeroGainExpMethodPanel", baseFguiPanel)
function HeroGainExpMethodPanel:ctor(...)
	self.super.ctor(self, ...)
	print("HeroGainExpMethodPanel:ctor", self.viewName)
end
function HeroGainExpMethodPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function HeroGainExpMethodPanel:onInit()
	print("=======HeroGainExpMethodPanel:onInit")
	self.fields.Panel_bg:setString(i18n("hero_text_53"))
	self.fields.Text_expTip:setString(i18n("hero_text_52"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function HeroGainExpMethodPanel:onShow()
	print("=======HeroGainExpMethodPanel:onShow")
	self.heroID = self.param.heroID
	self.heroRarity = heroltCtrl:getHeroRarity(self.heroID)
	if self.heroRarity >= gHeroRarity.ORANGE then
		self.fields.Panel_bg:setString(i18n("hero_text_122"))
		self.fields.Text_expTip:setString(i18n("hero_text_123"))
	end
	self:initData()
end
function HeroGainExpMethodPanel:initData(...)
	_ENV, _UPVALUE2_ = nil, nil
	;(nil).methodType = gHeroChipMethodType.dailyTask
	_ENV, (nil).des = self.heroRarity >= gHeroRarity.ORANGE and i18n("hero_text_124") or i18n("quest_btn_02"), self.heroRarity >= gHeroRarity.ORANGE and i18n("hero_text_124") or i18n("quest_btn_02")
	;(self.heroRarity >= gHeroRarity.ORANGE and i18n("hero_text_124") or i18n("quest_btn_02")).methodType = gHeroChipMethodType.rechargeExp
	;(self.heroRarity >= gHeroRarity.ORANGE and i18n("hero_text_124") or i18n("quest_btn_02")).des = i18n("hero_text_47")
	self.infoList, (nil)[1] = nil, nil
	self.infoList, (nil)[2] = nil, self.heroRarity >= gHeroRarity.ORANGE and i18n("hero_text_124") or i18n("quest_btn_02")
	self.fields.List:setNumItems(#self.infoList)
end
function HeroGainExpMethodPanel:onItemRenderer(index, obj)
	obj:initData(self.infoList[index + 1], self.heroRarity)
end
return HeroGainExpMethodPanel
