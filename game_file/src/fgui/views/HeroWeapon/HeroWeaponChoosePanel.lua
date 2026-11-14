local heroWeaponCtrl = SoraDGetCtrl("heroWeaponCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroWeaponChoosePanel = class("HeroWeaponChoosePanel", baseFguiPanel)
function HeroWeaponChoosePanel:ctor(...)
	HeroWeaponChoosePanel.super.ctor(self, ...)
	print("HeroWeaponChoosePanel:ctor", self.viewName)
end
function HeroWeaponChoosePanel:onInit()
	print("=======HeroWeaponChoosePanel:onInit")
	self.selList, _ENV = print, print
	self.weaponList, _ENV, self.selNum = print, print, 0
	self.fields.Panel_bg:setString(i18n("HeroWeapon_1"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Btn_ok:setString(i18n("common_text_204"))
	self.fields.Btn_ok:addClickListener(handler(self, self.btnClick))
	self.fields.Btn_ok:setEnabled(false)
	self.fields.Text_none:setString(i18n("HeroWeapon_37"))
	self.fields.Text_none:setVisible(false)
end
function HeroWeaponChoosePanel:onShow()
	print("=======HeroWeaponChoosePanel:onShow")
	self.weaponID = self.param.weaponID
	self.costNum = self.param.costNum
	self.selfUid = self.param.selfUid
	if not self.param.weaponUidList then
		_ENV = self.param.weaponUidList
	end
	self.weaponUidList = self.param.weaponUidList
	local _ENV, exUidList = self.param.weaponUidList, self.param.weaponUidList
	if self.selfUid then
		table.insert(exUidList, self.selfUid)
	end
	for k, v in pairs(self.weaponUidList) do
		table.insert(exUidList, v)
	end
	self.weaponList = heroWeaponCtrl:getWeaponListByID(self.weaponID, exUidList)
	self.fields.List:setNumItems(#self.weaponList)
	self.fields.Text_none:setVisible(#self.weaponList == 0)
	_ENV = nil
	_ENV = v
	v.num = fguiHelper.getColorString("#E02B2B", 0)
	v.need = self.costNum
	;(nil).num = i18n("%{num}/%{need}", v)
	self.fields.Text_selectNum:setString(i18n("HeroWeapon_46", nil))
end
function HeroWeaponChoosePanel:chooseBack(target, data)
	if data.select then
		self.selList[data.weaponUid] = 1
	else
		self.selList[data.weaponUid] = 0
	end
	self.selNum = 0
	for k, v in pairs(self.selList) do
		self.selNum = self.selNum + v
	end
	self.fields.List:setNumItems(#self.weaponList)
	_ENV = nil
	_ENV = nil
	;(nil).num = fguiHelper.getColorString(self.selNum < self.costNum and "#E02B2B" or "#FFFBD5", self.selNum)
	;(nil).need = self.costNum
	;(nil).num = i18n("%{num}/%{need}", nil)
	self.fields.Text_selectNum:setString(i18n("HeroWeapon_46", nil))
	self.fields.Btn_ok:setEnabled(self.selNum >= self.costNum)
end
function HeroWeaponChoosePanel:onItemRenderer(index, obj)
	obj:initData(self.weaponList[index + 1], self.selList, self.selNum >= self.costNum)
end
function HeroWeaponChoosePanel:btnClick()
	SoraDPlaySound()
	local _ENV, list = SoraDPlaySound, SoraDPlaySound
	for k, v in pairs(self.selList) do
		if v == 1 then
			table.insert(list, k)
		end
	end
	_ENV = pairs(self.selList)
	pairs(self.selList).msg = "MESSAGE_HERO_WEAPON_UI_COST_SELECT"
	pairs(self.selList).selList = list
	SoraDSendMessage(pairs(self.selList))
	self:close()
end
return HeroWeaponChoosePanel
