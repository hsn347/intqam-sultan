local heroWeaponCtrl = SoraDGetCtrl("heroWeaponCtrl")
local heroWeaponRead = include("heroWeaponRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroWeaponMapPanel = class("HeroWeaponMapPanel", baseFguiPanel)
function HeroWeaponMapPanel:ctor(...)
	HeroWeaponMapPanel.super.ctor(self, ...)
	print("HeroWeaponMapPanel:ctor", self.viewName)
end
function HeroWeaponMapPanel:onInit()
	print("=======HeroWeaponMapPanel:onInit")
	self.listData, _ENV, self.curType = gHeroWeaponType.all, gHeroWeaponType.all, gHeroWeaponType.all
	self.fields.Com_title:initData(i18n("HeroWeapon_9"), handler(self, self.onClickClose))
	_UPVALUE4_ = self.fields.Com_title.initData
	_UPVALUE5_, self.fields.Com_title.initData[1] = i18n("HeroWeapon_4"), i18n("HeroWeapon_4")
	_UPVALUE5_, self.fields.Com_title.initData[2] = i18n("HeroWeapon_4"), i18n("HeroWeapon_5")
	_UPVALUE5_, self.fields.Com_title.initData[3] = i18n("HeroWeapon_4"), i18n("HeroWeapon_6")
	_UPVALUE5_, self.fields.Com_title.initData[4] = i18n("HeroWeapon_4"), i18n("HeroWeapon_7")
	_UPVALUE5_, self.fields.Com_title.initData[5] = i18n("HeroWeapon_4"), i18n("HeroWeapon_8")
	_UPVALUE5_, self.fields.Com_title.initData[6] = i18n("HeroWeapon_4"), i18n("HeroWeapon_8")
	_UPVALUE5_, self.fields.Com_title.initData[7] = i18n("HeroWeapon_4"), i18n("HeroWeapon_8")
	local _UPVALUE5_, self.fields.Com_title.initData[8], items = i18n("HeroWeapon_4"), i18n("HeroWeapon_8")
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
end
function HeroWeaponMapPanel:onShow()
	print("=======HeroWeaponMapPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self:initData()
end
function HeroWeaponMapPanel:onComboBoxClick()
	SoraDPlaySound()
	self.curType = tonumber(self.fields.ComboBox_sel:getValue())
	print("self.curType", self.curType)
	self:initData()
end
function HeroWeaponMapPanel:onListRenderer(index, obj)
	obj:initData(self.listData[index + 1])
end
function HeroWeaponMapPanel:initData()
	local weaponList = heroWeaponRead.getWeaponMapCfg()
	self.listData, heroWeaponRead = nil, nil
	local heroWeaponRead, list
	if self.curType == gHeroWeaponType.all then
		list = weaponList
	else
		for k, v in ipairs(weaponList) do
			if v.type == self.curType then
				table.insert(list, v)
			end
		end
	end
	table.sort(list, function(a, b)
		local isHaveA = heroWeaponCtrl:getWeaponByID(a.weaponId) and true or false
		local isHaveB = heroWeaponCtrl:getWeaponByID(b.weaponId) and true or false
		if isHaveA == isHaveB then
			if a.quality == b.quality then
				return a.weaponId < b.weaponId
			else
				return a.quality > b.quality
			end
		else
			return isHaveA
		end
	end)
	local heroWeaponRead, showList = table.sort, table.sort
	for k, v in ipairs(list) do
		if serviceFunctions.systemTime() > v.unlockTime then
			table.insert(showList, v)
		end
	end
	for i = 1, math.ceil(#showList / 3) do
		self.listData[i], heroWeaponRead = table.insert, table.insert
		local _index = (i - 1) * 3
		table.insert(self.listData[i], showList[_index + 1])
		table.insert(self.listData[i], showList[_index + 2])
		table.insert(self.listData[i], showList[_index + 3])
	end
	if #self.listData * 196 < self.fields.List:getHeight() then
		local count = math.ceil(self.fields.List:getHeight() / 196) - #self.listData
		if 0 < count then
			for i = 1, count do
				heroWeaponRead = showList[_index + 3]
				table.insert(self.listData, showList[_index + 3])
			end
		end
		self.fields.List:setScrollEnable(false)
	else
		self.fields.List:setScrollEnable(true)
	end
	self.fields.List:setNumItems(#self.listData)
end
return HeroWeaponMapPanel
