local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroTaskCtrl = SoraDGetCtrl("heroTaskCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local cityltCtrl = include("cityltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroTaskSelectPopPanel = class("HeroTaskSelectPopPanel", baseFguiPanel)
function HeroTaskSelectPopPanel:ctor(...)
	HeroTaskSelectPopPanel.super.ctor(self, ...)
	print("HeroTaskSelectPopPanel:ctor", self.viewName)
end
function HeroTaskSelectPopPanel:onInit()
	print("=======HeroTaskSelectPopPanel:onInit")
	self.heros, _ENV = print, print
	self.heroID = nil
	self.fields.Panel_bg:setString(i18n("hero_appoint_32"))
	self.fields.Lab_hero:setString(i18n("hero_title_07"))
	self.fields.List:setItemRenderer(handler(self, self.onHeroRenderer))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
	self.fields.Btn_ok:setString(i18n("common_text_204"))
	self.fields.Btn_ok:addClickListener(handler(self, self.btnOkClick))
	self.fields.Btn_ok:setEnabled(false)
	self.fields.Btn_heroPre:initData()
	self.fields.Text_attr:setString(i18n("hero_appoint_13"))
	self.fields.Lab_attr:setString(i18n("hero_appoint_14"))
	self.fields.Text_attr:fixPos()
	self.fields.Lab_attr:fixPos()
	self.fields.Btn_heroPre:fixPos()
end
function HeroTaskSelectPopPanel:onHeroRenderer(index, obj)
	obj:initData(self.heros[index + 1])
end
function HeroTaskSelectPopPanel:onClickItem()
	SoraDPlaySound()
	local index = self.fields.List:getSelectedIndex() + 1
	print("self.fields.List", index)
	self.heroID = self.heros[index]
	self.fields.Btn_ok:setEnabled(true)
	_ENV = true
	;(true).heroID = self.heroID
	;(true).isBeAppoint = 0
	self.fields.Btn_heroPre:initData(true)
	local attrTb = heroltCtrl:getHeroAppointAttr(self.heroID)
	local _ENV, attrStrTb = heroltCtrl, heroltCtrl
	for k, v in ipairs(attrTb) do
		_ENV = nil
		;(nil).des = cityltCtrl.getHeroAttrName(k)
		;(nil).num = v
		local attrStr = fguiHelper.getColorString("#B4A078", i18n("%{des}:%{num}", nil))
		table.insert(attrStrTb, attrStr)
	end
	self.fields.Lab_attr:setString(table.concat(attrStrTb, "\n"))
end
function HeroTaskSelectPopPanel:onShow()
	print("=======HeroTaskSelectPopPanel:onShow")
	self.index = self.param.index
	if not self.param.heros then
		_ENV = self.param.heros
	end
	self.selectHeros = self.param.heros
	local myHeroList = heroCtrl:getHaveHerosList()
	for k, v in ipairs(myHeroList) do
		local heroID = tonumber(v)
		if not heroTaskCtrl:isHeroInTask(heroID) and not self:isSelectHero(heroID) then
			table.insert(self.heros, heroID)
		end
	end
	self.fields.List:setNumItems(#self.heros)
end
function HeroTaskSelectPopPanel:isSelectHero(heroID)
	for k, v in pairs(self.selectHeros) do
		if v == heroID then
			return true
		end
	end
	return false
end
function HeroTaskSelectPopPanel:btnOkClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_HEROTASK_HERO_SELECT"
	;(nil).index = self.index
	;(nil).heroID = self.heroID
	SoraDSendMessage(nil)
	self:close()
end
return HeroTaskSelectPopPanel
