local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroWeaponHeroSelectPanel = class("HeroWeaponHeroSelectPanel", baseFguiPanel)
function HeroWeaponHeroSelectPanel:ctor(...)
	HeroWeaponHeroSelectPanel.super.ctor(self, ...)
	print("HeroWeaponHeroSelectPanel:ctor", self.viewName)
end
function HeroWeaponHeroSelectPanel:onInit()
	print("=======HeroWeaponHeroSelectPanel:onInit")
	self.heroList, _ENV, self.selIndex = print, print, nil
	self.fields.Panel_bg:setString(i18n("hero_title_07"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onChooseItem))
	self.fields.Text_none:setString(i18n("HeroWeapon_47"))
	self.fields.Text_none:setVisible(false)
	self.fields.Btn_ok:setString(i18n("common_text_204"))
	self.fields.Btn_ok:addClickListener(handler(self, self.btnClick))
	self.fields.Btn_ok:setEnabled(false)
end
function HeroWeaponHeroSelectPanel:onItemRenderer(index, obj)
	obj:initData(self.heroList[index + 1])
end
function HeroWeaponHeroSelectPanel:onChooseItem()
	SoraDPlaySound()
	self.selIndex = self.fields.List:getSelectedIndex() + 1
	self.fields.Btn_ok:setEnabled(false)
	local heroID = tonumber(self.heroList[self.selIndex])
	local heroInfo = heroCtrl:getHeroInfoByID(heroID)
	if heroInfo.weaponUid and heroInfo.weaponUid > 0 then
		_ENV = nil
		;(nil).content = i18n("HeroWeapon_27")
		;(nil).confirmString = i18n("common_text_204")
		;(nil).cancelString = i18n("common_text_185")
		;(nil).confirmFunc = function()
			self.fields.Btn_ok:setEnabled(true)
		end
		uiManager:show("MessageBox", nil)
	else
		self.fields.Btn_ok:setEnabled(true)
	end
end
function HeroWeaponHeroSelectPanel:onShow()
	print("=======HeroWeaponHeroSelectPanel:onShow")
	self.weaponUid = self.param.weaponUid
	self.heroList, _ENV, self.heroID = self.param.heroID, self.param.heroID, self.param.heroID
	local heroList = heroCtrl:getHeroSSS(true)
	if self.heroID then
		for k, v in ipairs(heroList) do
			if tonumber(v) ~= tonumber(self.heroID) then
				table.insert(self.heroList, v)
			end
		end
	else
		self.heroList = heroList
	end
	self.fields.List:setNumItems(#self.heroList)
	self.fields.Text_none:setVisible(#self.heroList == 0)
end
function HeroWeaponHeroSelectPanel:endShow()
end
function HeroWeaponHeroSelectPanel:btnClick()
	SoraDPlaySound()
	heroCtrl:weaponWear(tonumber(self.heroList[self.selIndex]), self.weaponUid)
	self:close()
end
function HeroWeaponHeroSelectPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "firstHero" then
		return self.fields.List:getChildAt(0)
	else
		return self.fields[itemName]
	end
end
return HeroWeaponHeroSelectPanel
