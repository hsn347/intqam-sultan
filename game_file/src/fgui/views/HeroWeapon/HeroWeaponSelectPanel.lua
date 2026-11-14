local heroWeaponCtrl = SoraDGetCtrl("heroWeaponCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local heroWeaponRead = include("heroWeaponRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroWeaponSelectPanel = class("HeroWeaponSelectPanel", baseFguiPanel)
function HeroWeaponSelectPanel:ctor(...)
	HeroWeaponSelectPanel.super.ctor(self, ...)
	print("HeroWeaponSelectPanel:ctor", self.viewName)
end
function HeroWeaponSelectPanel:onInit()
	print("=======HeroWeaponSelectPanel:onInit")
	self.listData, _ENV, self.curType = gHeroWeaponType.all, gHeroWeaponType.all, gHeroWeaponType.all
	self.curUid = nil
	self.selectUid = nil
	self.fields.Panel_bg:setString(i18n("HeroWeapon_1"))
	self.fields.Text_none:setString(i18n("HeroWeapon_37"))
	self.fields.Text_none:setVisible(false)
	_UPVALUE4_ = self.fields.Text_none.setVisible
	_UPVALUE5_, self.fields.Text_none.setVisible[1] = i18n("HeroWeapon_4"), i18n("HeroWeapon_4")
	_UPVALUE5_, self.fields.Text_none.setVisible[2] = i18n("HeroWeapon_4"), i18n("HeroWeapon_5")
	_UPVALUE5_, self.fields.Text_none.setVisible[3] = i18n("HeroWeapon_4"), i18n("HeroWeapon_6")
	_UPVALUE5_, self.fields.Text_none.setVisible[4] = i18n("HeroWeapon_4"), i18n("HeroWeapon_7")
	_UPVALUE5_, self.fields.Text_none.setVisible[5] = i18n("HeroWeapon_4"), i18n("HeroWeapon_8")
	_UPVALUE5_, self.fields.Text_none.setVisible[6] = i18n("HeroWeapon_4"), i18n("HeroWeapon_8")
	_UPVALUE5_, self.fields.Text_none.setVisible[7] = i18n("HeroWeapon_4"), i18n("HeroWeapon_8")
	local _UPVALUE5_, self.fields.Text_none.setVisible[8], items = i18n("HeroWeapon_4"), i18n("HeroWeapon_8")
	i18n("HeroWeapon_4")[1] = gHeroWeaponType.infantry
	i18n("HeroWeapon_4")[2] = gHeroWeaponType.cavalry
	i18n("HeroWeapon_4")[3] = gHeroWeaponType.bowmen
	i18n("HeroWeapon_4")[4] = gHeroWeaponType.common
	local i18n("HeroWeapon_4")[5], values = gHeroWeaponType.all, i18n("HeroWeapon_4")
	_ENV = gHeroWeaponType.common
	gHeroWeaponType.common.items = items
	gHeroWeaponType.common.values = values
	gHeroWeaponType.common.changedCallback = handler(self, self.onComboBoxClick)
	self:setComboBox(self.fields.ComboBox_sel, gHeroWeaponType.common)
	local dropdown = self.fields.ComboBox_sel:getDropdown()
	self.comboBoxList = dropdown:getChildByName("list")
	self.fields.ComboBox_sel:addClickListener(function()
		SoraDPlaySound()
		self.comboBoxList:setSelectedIndex(self.curType - 1)
	end)
	self.fields.ComboBox_sel:setTitle(items[self.curType])
	self.fields.ComboBox_sel:fixChildrenPos()
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onListRenderer))
	self.fields.Btn_wear:addClickListener(handler(self, self.btnWearClick))
	self.fields.Btn_wear:setEnabled(self.selectUid ~= nil)
	self.fields.Btn_advance:setString(i18n("HeroWeapon_15"))
	self.fields.Btn_advance:addClickListener(handler(self, self.btnAdvanceClick))
	self.fields.Btn_advance:setEnabled(self.selectUid ~= nil)
	self.fields.Btn_strength:setString(i18n("HeroWeapon_14"))
	self.fields.Btn_strength:addClickListener(handler(self, self.btnStengthClick))
	self.fields.Btn_strength:setEnabled(self.selectUid ~= nil)
	self.fields.Btn_wear:fixPos()
	self.fields.Btn_advance:fixPos()
	self.fields.Btn_strength:fixPos()
end
function HeroWeaponSelectPanel:onComboBoxClick()
	SoraDPlaySound()
	self.curType = tonumber(self.fields.ComboBox_sel:getValue())
	print("self.curType", self.curType)
	self.selectUid = nil
	self.fields.Btn_wear:setEnabled(self.selectUid ~= nil)
	self:initData()
end
function HeroWeaponSelectPanel:onShow()
	print("=======HeroWeaponSelectPanel:onShow")
	self.heroID = self.param.heroID
	local heroInfo = heroCtrl:getHeroInfoByID(self.heroID)
	if heroInfo.weaponUid and heroInfo.weaponUid > 0 then
		self.curUid = heroInfo.weaponUid
	end
	self.selectUid = self.curUid
	self.fields.Btn_wear:setString(self.curUid and i18n("HeroWeapon_36") or i18n("Soldiers_armor_text_26"))
	self.fields.Btn_wear:setEnabled(self.selectUid ~= nil)
	self:initData()
end
function HeroWeaponSelectPanel:onListRenderer(index, obj)
	obj:initData(self.listData[index + 1], self.selectUid)
end
function HeroWeaponSelectPanel:selectBack(target, data)
	self.selectUid = data.uid
	self.fields.List:setNumItems(#self.listData)
	self.fields.Btn_wear:setString(self.curUid and self.selectUid == self.curUid and i18n("HeroWeapon_36") or i18n("Soldiers_armor_text_26"))
	self.fields.Btn_wear:setEnabled(self.selectUid ~= nil)
	self:updateBtns()
	self:setPreAttr()
end
function HeroWeaponSelectPanel:updateBtns()
	if self.selectUid then
		self.fields.Btn_advance:setEnabled(true)
		self.fields.Btn_strength:setEnabled(true)
		self.weapon = heroWeaponCtrl:getWeaponByUid(self.selectUid)
		self.fields.Btn_advance:setBright(self.weapon.stage < heroWeaponRead.getMaxStage())
		local lvLimit = heroWeaponRead.getWeaponLvLimit(self.weapon.weaponID, self.weapon.stage)
		self.fields.Btn_strength:setBright(not (self.weapon.lv >= heroWeaponRead.getMaxLv()) and self.weapon.lv ~= lvLimit)
	else
		self.weapon = nil
		self.fields.Btn_advance:setEnabled(false)
		self.fields.Btn_strength:setEnabled(false)
	end
end
function HeroWeaponSelectPanel:setPreAttr()
	local preData
	if self.selectUid then
		for k, v in ipairs(self.listData) do
			if v.id == self.selectUid then
				preData = v
				break
			end
		end
	end
	self.fields.Com_attr:initData(preData)
end
function HeroWeaponSelectPanel:initData()
	local weaponList = heroWeaponCtrl:getWeaponMap()
	for k, v in pairs(weaponList) do
		local cfg = heroWeaponRead.getWeaponCfg(v.weaponID, v.stage)
		v.type = cfg.type
		v.quality = cfg.quality
		v.heroID = heroWeaponCtrl:getWearHeroId(v.id)
	end
	self.listData, heroWeaponCtrl = pairs(weaponList)
	if self.curType == gHeroWeaponType.all then
		for k, v in pairs(weaponList) do
			table.insert(self.listData, v)
		end
	else
		for k, v in pairs(weaponList) do
			if v.type == self.curType then
				table.insert(self.listData, v)
			end
		end
	end
	table.sort(self.listData, function(a, b)
		if a.quality ~= b.quality then
			return a.quality > b.quality
		end
		if not (not a.heroID or b.heroID) or not a.heroID and b.heroID then
			return not not a.heroID
		end
		if a.lv ~= b.lv then
			return a.lv > b.lv
		end
		if a.stage ~= b.stage then
			return a.stage > b.stage
		end
		return a.weaponID < b.weaponID
	end)
	self.fields.List:setNumItems(#self.listData)
	self.fields.Text_none:setVisible(#self.listData == 0)
	self:updateBtns()
	self:setPreAttr()
end
function HeroWeaponSelectPanel:btnWearClick()
	SoraDPlaySound()
	if self.selectUid then
		if self.curUid and self.selectUid == self.curUid then
			heroCtrl:weaponTakeOff(self.heroID)
		else
			heroCtrl:weaponWear(self.heroID, self.selectUid)
		end
		self:close()
	end
end
function HeroWeaponSelectPanel:btnAdvanceClick()
	SoraDPlaySound()
	if self.weapon then
		if self.weapon.stage >= heroWeaponRead.getMaxStage() then
			SoraDShowMsgTip(i18n("HeroWeapon_48"))
			return
		end
		_ENV = i18n("HeroWeapon_48")
		i18n("HeroWeapon_48").data = self.weapon
		uiManager:show("HeroWeaponAdvance", i18n("HeroWeapon_48"))
	end
end
function HeroWeaponSelectPanel:btnStengthClick()
	SoraDPlaySound()
	if self.weapon then
		if self.weapon.lv >= heroWeaponRead.getMaxLv() then
			SoraDShowMsgTip(i18n("HeroWeapon_49"))
			return
		end
		if self.weapon.lv == heroWeaponRead.getWeaponLvLimit(self.weapon.weaponID, self.weapon.stage) then
			SoraDShowMsgTip(i18n("HeroWeapon_50"))
			return
		end
		_ENV = i18n("HeroWeapon_50")
		i18n("HeroWeapon_50").data = self.weapon
		uiManager:show("HeroWeaponStrength", i18n("HeroWeapon_50"))
	end
end
return HeroWeaponSelectPanel
