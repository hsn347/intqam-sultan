local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroWeaponRead = include("heroWeaponRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CheatHeroWeaponChoosePanel = class("CheatHeroWeaponChoosePanel", baseFguiPanel)
function CheatHeroWeaponChoosePanel:ctor(...)
	CheatHeroWeaponChoosePanel.super.ctor(self, ...)
	print("CheatHeroWeaponChoosePanel:ctor", self.viewName)
end
function CheatHeroWeaponChoosePanel:onInit()
	print("=======CheatHeroWeaponChoosePanel:onInit")
	self.weaponList, _ENV, self.heroList, _ENV, self.selIndex = print, print, print, print, nil
	self.fields.List:setItemRenderer(handler(self, self.onHeroRenderer))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onChooseHero))
	self.fields.List_weapon:setItemRenderer(handler(self, self.onWeaponRenderer))
	self.fields.List_weapon:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onChooseWeapon))
	self.fields.Btn_ok:setString(i18n("common_text_204"))
	self.fields.Btn_ok:addClickListener(handler(self, self.btnClick))
	self.fields.Btn_ok:setEnabled(false)
end
function CheatHeroWeaponChoosePanel:onShow()
	print("=======CheatHeroWeaponChoosePanel:onShow")
	self.style = self.param and self.param.style or 1
	self.index = self.param and self.param.index or 1
	if not self.param or not self.param.editData then
		_ENV = self.param.editData
	end
	self.editData = self.param.editData
	self.id = self.param and self.param.id
	if self.style == 1 then
		self.fields.Panel_bg:setString("选择英雄")
		self.heroList = self:getSortHeroList()
		self.fields.List:setVisible(true)
		self.fields.List_weapon:setVisible(false)
		self.fields.List:setNumItems(#self.heroList)
	elseif self.style == 2 then
		self.fields.Panel_bg:setString("选择武器")
		local weaponList = heroWeaponRead.getWeaponMapCfg()
		self.weaponList, _ENV = self.fields.Panel_bg, self.fields.Panel_bg
		local mainHero = self.editData.heroList[self.index]
		local heroType = heroltCtrl.getHeroType(mainHero)
		_ENV = mainHero
		mainHero[gHeroType.INFANTRY] = gHeroWeaponType.infantry
		mainHero[gHeroType.CAVALRY] = gHeroWeaponType.cavalry
		local mainHero[gHeroType.ARCHER], cfg = gHeroWeaponType.bowmen, mainHero
		for k, v in ipairs(weaponList) do
			if v.type == gHeroWeaponType.common or cfg[heroType] == v.type then
				table.insert(self.weaponList, v.weaponId)
			end
		end
		self.fields.List:setVisible(false)
		self.fields.List_weapon:setVisible(true)
		self.fields.List_weapon:setNumItems(#self.weaponList)
	elseif self.style == 3 then
		self.fields.Panel_bg:setString("选择副将")
		self.heroList = self:getSortHeroList()
		self.fields.List:setVisible(true)
		self.fields.List_weapon:setVisible(false)
		self.fields.List:setNumItems(#self.heroList)
	end
end
function CheatHeroWeaponChoosePanel:getSortHeroList()
	local heroList = heroltCtrl:getHeroIDAll()
	table.sort(heroList)
	if self.editData.heroList and table.nums(self.editData.heroList) > 0 then
		for _, v in pairs(self.editData.heroList) do
			table.removebyvalue(heroList, v)
		end
	end
	if self.editData.viceHeroList and 0 < table.nums(self.editData.viceHeroList) then
		for _, v in pairs(self.editData.viceHeroList) do
			table.removebyvalue(heroList, v)
		end
	end
	return heroList
end
function CheatHeroWeaponChoosePanel:onHeroRenderer(index, obj)
	local heroID = self.heroList[index + 1]
	obj:getChild("hero"):initMax(heroID)
	obj:setTitle(i18n(heroltCtrl.getHeroName(heroID)))
end
function CheatHeroWeaponChoosePanel:onWeaponRenderer(index, obj)
	obj:initData(self.weaponList[index + 1])
end
function CheatHeroWeaponChoosePanel:onChooseHero()
	SoraDPlaySound()
	self.selIndex = self.fields.List:getSelectedIndex() + 1
	print("self.selIndex=====", self.selIndex, self.heroList[self.selIndex])
	self.fields.Btn_ok:setEnabled(true)
end
function CheatHeroWeaponChoosePanel:onChooseWeapon()
	SoraDPlaySound()
	self.selIndex = self.fields.List_weapon:getSelectedIndex() + 1
	print("self.selIndex=====", self.selIndex, self.weaponList[self.selIndex])
	self.fields.Btn_ok:setEnabled(true)
end
function CheatHeroWeaponChoosePanel:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_CHEAT_UI_FIGHTDEMO_CHOOSE"
	;(nil).style = self.style
	;(nil).index = self.index
	;(nil).heroID = self.heroList[self.selIndex]
	;(nil).weaponID = self.weaponList[self.selIndex]
	SoraDSendMessage(nil)
	self:close()
end
return CheatHeroWeaponChoosePanel
