local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CommandHallRecommendPanel = class("CommandHallRecommendPanel", baseFguiPanel)
function CommandHallRecommendPanel:ctor(...)
	self.super.ctor(self, ...)
	print("CommandHallRecommendPanel:ctor", self.viewName)
end
function CommandHallRecommendPanel:onInit()
	print("=======CommandHallRecommendPanel:onInit")
	self.fields.Panel_bg:setString(i18n("commandhall_text_19"))
	self.fields.Text_des:setString(i18n("commandhall_text_100"))
	self.fields.Button_hero:setString(i18n("common_text_477"))
	self.fields.Button_hero:addClickListener(handler(self, self.onClickBtnHero))
	self.fields.Button_hero:setVisible(false)
	self.fields.Button_army:setString(i18n("common_text_477"))
	self.fields.Button_army:addClickListener(handler(self, self.onClickBtnArmy))
	self.fields.Button_army:setVisible(false)
	self.fields.Button_yes:setString(i18n("commandhall_text_103"))
	self.fields.Button_yes:addClickListener(handler(self, self.onClickBtnYes))
	self.fields.Button_no:setString(i18n("common_text_185"))
	self.fields.Button_no:addClickListener(handler(self, self.onClickClose))
	if not SoraDFIsRA() then
		self.fields.Text_hero:fixPos()
		self.fields.Button_hero:fixPos()
		self.fields.Text_army:fixPos()
		self.fields.Button_army:fixPos()
		self.fields.Button_yes:fixPos()
		self.fields.Button_no:fixPos()
	end
end
function CommandHallRecommendPanel:onShow()
	print("=======CommandHallRecommendPanel:onShow")
	if not self.proxy.param then
		local _ENV, param = self.proxy.param, self.proxy.param
	end
	if not param.data then
		local _ENV, data = param.data, param.data
	end
	self.callback = param.callback
	local heroPower = data.heroPower
	local recommendHero = data.recommendHero
	local armyPower = data.armyPower
	local recommendArmy = data.recommendArmy
	local _ENV, style
	if heroPower < recommendHero then
		_ENV, _ENV = nil, nil
		style, (nil).num1, (nil).color = nil, nil, "#FF0000"
		self.fields.Button_hero:setVisible(true)
	end
	local func_fnt = string.formatnumberthousands
	_ENV = nil
	;(nil).num1 = func_fnt(heroPower)
	;(nil).num2 = func_fnt(recommendHero)
	self.fields.Text_hero:setString(i18n_html("commandhall_text_105", nil, style))
	local _ENV, style = self.fields.Text_hero.setString, self.fields.Text_hero.setString
	if armyPower < recommendArmy then
		_ENV, _ENV = i18n_html("commandhall_text_105", nil, style)
		style, self.fields.Text_hero.num1, i18n_html("commandhall_text_105", nil, style).color = self.fields.Text_hero, i18n_html("commandhall_text_105", nil, style)
		self.fields.Button_army:setVisible(true)
	end
	_ENV = i18n_html("commandhall_text_105", nil, style)
	i18n_html("commandhall_text_105", nil, style).num1 = func_fnt(armyPower)
	i18n_html("commandhall_text_105", nil, style).num2 = func_fnt(recommendArmy)
	self.fields.Text_army:setString(i18n_html("commandhall_text_106", i18n_html("commandhall_text_105", nil, style)))
	if SoraDIsGameGuide() then
		local commandHallUtil = include("commandHallUtil")
		commandHallUtil.checkFinishGuide()
	end
end
function CommandHallRecommendPanel:onClickBtnHero(...)
	SoraDPlaySound()
	SoraDRemoveAllPanelFromManager()
	uiManager:show("newHeroListView")
end
function CommandHallRecommendPanel:onClickBtnArmy(...)
	SoraDPlaySound()
	uiManager:show("CommandHallAdviseArmy")
end
function CommandHallRecommendPanel:onClickBtnYes(...)
	SoraDPlaySound()
	if self.callback then
		self.callback()
	end
	self:closePanel()
end
return CommandHallRecommendPanel
