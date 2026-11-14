local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroSpecialLieutenantPanel = class("HeroSpecialLieutenantPanel", baseFguiPanel)
function HeroSpecialLieutenantPanel:ctor(...)
	HeroSpecialLieutenantPanel.super.ctor(self, ...)
	print("HeroSpecialLieutenantPanel:ctor", self.viewName)
end
function HeroSpecialLieutenantPanel:onInit()
	print("=======HeroSpecialLieutenantPanel:onInit")
	self.inheritAttrList, _ENV = print, print
	self.fields.Text_stitle:setString(i18n("lieutenant_text_03"))
	self.fields.Text_tip:setString(i18n("lieutenant_text_05"))
	self.fields.Text_lv:setString(i18n("lieutenant_text_06"))
	self.fields.Text_jj:setString(i18n("lieutenant_text_07"))
	self.fields.Text_zj:setString(i18n("lieutenant_text_18"))
	self.fields.List:setItemRenderer(handler(self, self.onAttrRenderer))
	self.fields.Text_lv:fixPos()
	self.fields.Text_jj:fixPos()
	self.fields.Text_zj:fixPos()
	self.fields.n17:fixPos()
	self.fields.n18:fixPos()
end
function HeroSpecialLieutenantPanel:onAttrRenderer(index, obj)
	obj:initData(self.inheritAttrList[index + 1], index + 1)
end
function HeroSpecialLieutenantPanel:onShow()
	print("=======HeroSpecialLieutenantPanel:onShow")
	self.dressID = self.param.dressID
	self.heroID = self.param.heroID
	self:initView()
end
function HeroSpecialLieutenantPanel:initView()
	_ENV = nil
	;(nil).name = fguiHelper.getColorString("#FFC864", i18n(heroltCtrl.getHeroName(self.heroID)))
	self.fields.text_Tips:setString(i18n("lieutenant_text_02", nil))
	self.fields.heroHead:initData(self.heroID)
	local heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	local heroQuality = heroInfo and heroInfo.quality or 1
	self.fields.heroHead:setHeadBg(heroQuality)
	if self.dressID then
		self.fields.heroHead:setSpHead(self.dressID)
	end
	local cfg = heroltCtrl:getInheriAttrByLevel(heroInfo.level)
	_ENV = i18n("lieutenant_text_02", nil)
	i18n("lieutenant_text_02", nil).num1 = fguiHelper.getColorString("#FFC864", string.format("%d%%", math.floor(cfg.stuntAttrAdd / 100)))
	i18n("lieutenant_text_02", nil).num2 = fguiHelper.getColorString("#FFC864", string.format("%d%%", math.floor(cfg.awakeAttrAdd / 100)))
	self.fields.Text_add:setString(i18n("hero_appoint_42", i18n("lieutenant_text_02", nil)))
	self.inheritAttrList = heroltCtrl:getHeroInheritAttr()
	self.fields.List:setNumItems(#self.inheritAttrList)
end
return HeroSpecialLieutenantPanel
