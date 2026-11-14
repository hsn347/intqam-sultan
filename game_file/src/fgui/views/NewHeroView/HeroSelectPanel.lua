local gametop = gModuleMgr.getObject("gametop")
local heroCtrl = gametop.playertop_:getModule("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local buffDesRead = include("buffDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroSelectPanel = class("HeroSelectPanel", baseFguiPanel)
function HeroSelectPanel:ctor(...)
	self.super.ctor(self, ...)
	print("HeroSelectPanel:ctor", self.viewName)
end
function HeroSelectPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function HeroSelectPanel:onInit()
	print("=======HeroSelectPanel:onInit")
	self.curClass = gHeroListViewAllClass
	self.skillGroup, _ENV, self.isHeroChange = gHeroListViewAllClass, gHeroListViewAllClass, true
	self.fields.List_ComboSkill:fixPos()
	self.fields.Com_HeroLockItemMain:fixPos()
	self.fields.Com_HeroLockItemLie:fixPos()
	self.fields.Button_ok:fixPos()
	self.fields.Button_clear:fixPos()
	self.fields.Com_title:initData(i18n("herotrain_title_01"), handler(self, self.onClickClose))
	self.fields.Text_noSelectTip:setString(i18n("hero_text_32"))
	self.fields.Text_noHerosTip:setString(i18n("hero_text_71"))
	self.fields.Text_LTitle:setString(i18n("lieutenant_text_01"))
	self.fields.Text_divTitle:setString(i18n("common_name_01"))
	self.fields.Text_infoTip:setString(i18n("hero_title_13"))
	self.fields.Button_clear:setTitleText(i18n("hero_text_72"))
	self.fields.Button_clear:addClickListener(handler(self, self.btnClearClick))
	self.fields.Button_ok:setTitleText(i18n("common_text_204"))
	self.fields.Button_ok:addClickListener(handler(self, self.btnOkClick))
	self.fields.heroBanner:initArtifactNode()
	self.fields.heroBanner:hideAllExtendUI()
	self.fields.heroBanner:hideAddCallBack()
	self.fields.Button_advanced:addTouchEventListener(handler(self, self.btnAdvancedClick))
	self.fields.List_btns:setItemRenderer(handler(self, self.onBtnsRenderer))
	self.fields.List_btns:addClickListener(handler(self, self.onClickBtnList))
	self.fields.List_hero:setItemRenderer(handler(self, self.onHeroItemRenderer))
	self.fields.List_ComboSkill:setItemRenderer(handler(self, self.onComboSkillItemRenderer))
	self.fields.List_Buff:setItemRenderer(handler(self, self.onBuffItemRenderer))
end
function HeroSelectPanel:onShow()
	print("=======HeroSelectPanel:onShow")
	self:initBtns()
end
function HeroSelectPanel:initBtns()
	self.fields.List_btns:setNumItems(#heroltCtrl.heroClassesInfo + 1)
	self.fields.List_btns:setSelectedIndex(self.curClass)
end
function HeroSelectPanel:initData(initSelectedHeros, canSelectHeros, lieuTenantInfo)
