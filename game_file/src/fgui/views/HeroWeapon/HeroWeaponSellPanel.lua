local heroWeaponCtrl = SoraDGetCtrl("heroWeaponCtrl")
local heroWeaponRead = include("heroWeaponRead")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroWeaponSellPanel = class("HeroWeaponSellPanel", baseFguiPanel)
function HeroWeaponSellPanel:ctor(...)
	HeroWeaponSellPanel.super.ctor(self, ...)
	print("HeroWeaponSellPanel:ctor", self.viewName)
end
function HeroWeaponSellPanel:onInit()
	print("=======HeroWeaponSellPanel:onInit")
	self.selectList, _ENV, self.listData, _ENV, self.curType = gHeroWeaponType.all, gHeroWeaponType.all, gHeroWeaponType.all, gHeroWeaponType.all, gHeroWeaponType.all
	self.sellReturnID = 225201
	self.fields.Panel_bg:setString(i18n("HeroWeapon_10"))
	self.fields.Label_title:setString(i18n("HeroWeapon_60"))
	self.fields.Btn_help:addClickListener(handler(self, self.onClickHelp))
	_UPVALUE4_ = self.fields.Btn_help.addClickListener
	_UPVALUE5_, self.fields.Btn_help.addClickListener[1] = i18n("HeroWeapon_4"), i18n("HeroWeapon_4")
	_UPVALUE5_, self.fields.Btn_help.addClickListener[2] = i18n("HeroWeapon_4"), i18n("HeroWeapon_5")
	_UPVALUE5_, self.fields.Btn_help.addClickListener[3] = i18n("HeroWeapon_4"), i18n("HeroWeapon_6")
	_UPVALUE5_, self.fields.Btn_help.addClickListener[4] = i18n("HeroWeapon_4"), i18n("HeroWeapon_7")
	_UPVALUE5_, self.fields.Btn_help.addClickListener[5] = i18n("HeroWeapon_4"), i18n("HeroWeapon_8")
	_UPVALUE5_, self.fields.Btn_help.addClickListener[6] = i18n("HeroWeapon_4"), i18n("HeroWeapon_8")
	_UPVALUE5_, self.fields.Btn_help.addClickListener[7] = i18n("HeroWeapon_4"), i18n("HeroWeapon_8")
	local _UPVALUE5_, self.fields.Btn_help.addClickListener[8], items = i18n("HeroWeapon_4"), i18n("HeroWeapon_8")
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
	self.fields.Com_have:hideBtnAdd()
	self.fields.Text_add:setVisible(false)
	self.fields.Btn_sell:setString(i18n("HeroWeapon_23"))
	self.fields.Btn_sell:addClickListener(handler(self, self.btnSellClick))
	self.fields.Btn_sell:setEnabled(false)
	self.fields.Text_none:setString(i18n("HeroWeapon_53"))
	self.fields.Text_none:setVisible(false)
	self.fields.Text_add:fixPos()
	self.fields.Btn_help:fixPos()
end
function HeroWeaponSellPanel:onShow()
	print("=======HeroWeaponSellPanel:onShow")
	self:initData()
end
function HeroWeaponSellPanel:onListRenderer(index, obj)
	obj:initData(self.listData[index + 1], index + 1, self.selectList)
end
function HeroWeaponSellPanel:onComboBoxClick()
	SoraDPlaySound()
	self.curType = tonumber(self.fields.ComboBox_sel:getValue())
	print("self.curType", self.curType)
	self:initData()
end
function HeroWeaponSellPanel:selectBack(target, data)
	local isSelect = data.isSelect
	local index = data.index
	if isSelect then
		self.selectList[tostring(index)] = true
	elseif self.selectList[tostring(index)] then
		self.selectList[tostring(index)] = false
	end
	self.fields.List:setNumItems(#self.listData)
	self:updateCoin()
end
function HeroWeaponSellPanel:updateCoin()
	local returnNum = 0
	for k, v in pairs(self.selectList) do
		if v then
			local data = self.listData[tonumber(k)]
			local num = heroWeaponRead.getWeaponSellCfg(data.weaponID, data.stage)
			returnNum = returnNum + num
		end
	end
	self.fields.Com_have:initData(self.sellReturnID)
	self.fields.Text_add:setVisible(0 < returnNum)
	self.fields.Text_add:setString(0 < returnNum and (SoraDFIsRA() and tostring(returnNum) .. "+" or "+" .. tostring(returnNum)) or "0")
	self.fields.Btn_sell:setEnabled(0 < returnNum)
end
function HeroWeaponSellPanel:initData()
	local heroWeaponCtrl, weaponList
	local weaponMap = heroWeaponCtrl:getWeaponMap()
	for k, v in pairs(weaponMap) do
		if not heroWeaponCtrl:getWearHeroId(v.id) then
			local cfg = heroWeaponRead.getWeaponCfg(v.weaponID, v.stage)
			v.type = cfg.type
			v.quality = cfg.quality
			table.insert(weaponList, v)
		end
	end
	self.selectList, heroWeaponCtrl, self.listData, heroWeaponCtrl = pairs(weaponMap)
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
	self:updateCoin()
end
function HeroWeaponSellPanel:btnSellClick()
	SoraDPlaySound()
	local readySell = function(weaponUidList)
		SoraDCheckSecondaryLock(function()
			heroWeaponCtrl:reqSell(weaponUidList)
		end, gSecondaryLockType.SellWeapon, "HeroWeaponSell")
	end
	local _ENV, weaponUidList
	local isHaveDeveloped = false
	for k, v in pairs(self.selectList) do
		if v then
			local data = self.listData[tonumber(k)]
			table.insert(weaponUidList, data.id)
			if data.lv > 0 or 0 < data.exp or 0 < data.stage then
				isHaveDeveloped = true
			end
		end
	end
	if isHaveDeveloped then
		_ENV = nil
		;(nil).content = i18n("HeroWeapon_66")
		;(nil).confirmString = i18n("common_text_204")
		;(nil).cancelString = i18n("common_text_185")
		;(nil).confirmFunc = function()
			readySell(weaponUidList)
		end
		uiManager:show("MessageBox", nil)
		return
	end
	readySell(weaponUidList)
end
function HeroWeaponSellPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = i18n("HeroWeapon_17")
	;(nil).content = i18n("HeroWeapon_18")
	uiManager:show("RuleView", nil)
end
return HeroWeaponSellPanel
