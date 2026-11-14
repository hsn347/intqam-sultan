local heroWeaponCtrl = SoraDGetCtrl("heroWeaponCtrl")
local heroWeaponRead = include("heroWeaponRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroWeaponListPanel = class("HeroWeaponListPanel", baseFguiPanel)
function HeroWeaponListPanel:ctor(...)
	HeroWeaponListPanel.super.ctor(self, ...)
	print("HeroWeaponListPanel:ctor", self.viewName)
end
function HeroWeaponListPanel:onInit()
	print("=======HeroWeaponListPanel:onInit")
	self.listData, _ENV, self.curType = gHeroWeaponType.all, gHeroWeaponType.all, gHeroWeaponType.all
	self.fields.Com_title:initData(i18n("HeroWeapon_1"), handler(self, self.onClickClose))
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
	self.fields.Text_none:setString(i18n("HeroWeapon_59"))
	self.fields.Text_none:setVisible(false)
	self.fields.Btn_map:setString(i18n("HeroWeapon_9"))
	self.fields.Btn_map:addClickListener(handler(self, self.btnMapClick))
	self.fields.Btn_sell:setString(i18n("HeroWeapon_10"))
	self.fields.Btn_sell:addClickListener(handler(self, self.btnSellClick))
	self.fields.Btn_map:fixPos()
	self.fields.Btn_sell:fixPos()
end
function HeroWeaponListPanel:onShow()
	print("=======HeroWeaponListPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self:initData()
end
function HeroWeaponListPanel:onComboBoxClick()
	SoraDPlaySound()
	self.curType = tonumber(self.fields.ComboBox_sel:getValue())
	print("self.curType", self.curType)
	self:initData()
end
function HeroWeaponListPanel:onListRenderer(index, obj)
	obj:initData(self.listData[index + 1])
end
function HeroWeaponListPanel:initData()
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
	local ret, map = heroWeaponCtrl:isHaveMergeEnable()
	heroWeaponCtrl = nil
	;(nil).visible = ret
	;(nil).num = table.nums(map)
	self.fields.Btn_map:setRedDot(nil)
end
function HeroWeaponListPanel:btnMapClick()
	SoraDPlaySound()
	uiManager:show("HeroWeaponMap")
end
function HeroWeaponListPanel:btnSellClick()
	SoraDPlaySound()
	uiManager:show("HeroWeaponSell")
end
function HeroWeaponListPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "firstWeapon" then
		return self.fields.List:getChildAt(0)
	else
		return self.fields[itemName]
	end
end
return HeroWeaponListPanel
