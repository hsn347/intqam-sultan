local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local artifactRuneRead = include("artifactRuneRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RuneSourcePopPanel = class("RuneSourcePopPanel", baseFguiPanel)
function RuneSourcePopPanel:ctor(...)
	self.isLRU = true
	RuneSourcePopPanel.super.ctor(self, ...)
	print("RuneSourcePopPanel:ctor", self.viewName)
end
function RuneSourcePopPanel:onInit()
	print("=======RuneSourcePopPanel:onInit")
	self.fields.Com_bg:setGradientColor()
	self.fields.Com_title:initData(i18n("heraldry_text01"), handler(self, self.onClickClose))
	self.fields.Text_none:setString(i18n("heraldry_text04"))
	self.fields.Text_none:setVisible(false)
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	_UPVALUE4_, self.curSortType = self.fields.List.setItemRenderer, 0
	_UPVALUE5_, self.fields.List.setItemRenderer[1] = i18n("Weapon_Rune_tips_010"), i18n("Weapon_Rune_tips_010")
	_UPVALUE5_, self.fields.List.setItemRenderer[2] = i18n("Weapon_Rune_tips_010"), i18n("Weapon_Rune_tips_014")
	_UPVALUE5_, self.fields.List.setItemRenderer[3] = i18n("Weapon_Rune_tips_010"), i18n("Weapon_Rune_tips_037")
	_UPVALUE5_, self.fields.List.setItemRenderer[4] = i18n("Weapon_Rune_tips_010"), i18n("Weapon_Rune_tips_015")
	_UPVALUE5_, self.fields.List.setItemRenderer[5] = i18n("Weapon_Rune_tips_010"), i18n("Weapon_Rune_tips_016")
	_UPVALUE5_, self.fields.List.setItemRenderer[6] = i18n("Weapon_Rune_tips_010"), i18n("Weapon_Rune_tips_016")
	_UPVALUE5_, self.fields.List.setItemRenderer[7] = i18n("Weapon_Rune_tips_010"), i18n("Weapon_Rune_tips_016")
	local _UPVALUE5_, self.fields.List.setItemRenderer[8], items = i18n("Weapon_Rune_tips_010"), i18n("Weapon_Rune_tips_016")
	_ENV, i18n("Weapon_Rune_tips_010")[1] = 0, 0
	_ENV, i18n("Weapon_Rune_tips_010")[2] = 0, 1
	_ENV, i18n("Weapon_Rune_tips_010")[3] = 0, 2
	_ENV, i18n("Weapon_Rune_tips_010")[4] = 0, 3
	local _ENV, i18n("Weapon_Rune_tips_010")[5], values = 0, 4, i18n("Weapon_Rune_tips_010")
	;(0)["0"] = 5
	;(0)["1"] = 1
	;(0)["2"] = 2
	;(0)["3"] = 3
	self.holeTypeCfg, (0)["4"] = 0, 4
	_ENV = 3
	;(3).items = items
	;(3).values = values
	;(3).selectedIndex = self.curSortType
	;(3).changedCallback = handler(self, self.onComboBoxClick)
	self:setComboBox(self.fields.ComboBox, 3)
	local dropdown = self.fields.ComboBox:getDropdown()
	self.comboBoxList = dropdown:getChildByName("list")
	self.fields.ComboBox:addClickListener(function()
		SoraDPlaySound()
		self.comboBoxList:setSelectedIndex(self.curSortType)
	end)
end
function RuneSourcePopPanel:onComboBoxClick()
	SoraDPlaySound()
	self.curSortType = tonumber(self.fields.ComboBox:getValue())
	print("self.curSortType===", self.curSortType)
	self:initView()
end
function RuneSourcePopPanel:onItemRenderer(index, obj)
	obj:initData(self.itemList[index + 1])
end
function RuneSourcePopPanel:endShow()
	print("=======RuneSourcePopPanel:endShow")
	self.tag = 1
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("heraldry_text05")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("heraldry_text03")
	;(nil).tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
	;(nil).callback = handler(self, self.onClickTab)
	self.fields.com_TabW:initView(nil)
end
function RuneSourcePopPanel:onClickTab(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	self:initView()
	self.fields.List:jumpToTop()
end
function RuneSourcePopPanel:initView()
	self.itemList, artifactRuneRead = nil, nil
	if self.tag == 1 then
		if not artifactRuneRead.getRuneSkip(5) then
			local artifactRuneRead, cfg = artifactRuneRead.getRuneSkip(5), artifactRuneRead.getRuneSkip(5)
		end
		for k, v in ipairs(cfg) do
			local count = backpackCtrl:getItemCount(v)
			if 0 < count and backpackltCtrl:getItemType(v) ~= gItemType.WAR_PARTERN_FRAGMENT then
				artifactRuneRead = v
				v.id = v
				v.count = count
				table.insert(self.itemList, v)
			end
		end
	else
		local holeType = self.holeTypeCfg[tostring(self.curSortType)]
		if not artifactRuneRead.getRuneSkip(holeType) then
			local artifactRuneRead, runeSkip = artifactRuneRead.getRuneSkip(holeType), artifactRuneRead.getRuneSkip(holeType)
		end
		local artifactRuneRead, itemList = holeType, holeType
		for k, v in ipairs(runeSkip) do
			if backpackltCtrl:getItemType(v) == gItemType.WAR_PARTERN_FRAGMENT then
				artifactRuneRead = v
				v.id = v
				v.count = backpackCtrl:getItemCount(v)
				table.insert(itemList, v)
			end
		end
		for k, v in ipairs(itemList) do
			if self:isCanMerge(v.id, v.count) then
				table.insert(self.itemList, v)
			end
		end
		for k, v in ipairs(itemList) do
			if not self:isCanMerge(v.id, v.count) then
				table.insert(self.itemList, v)
			end
		end
	end
	self.fields.List:setNumItems(#self.itemList)
	self.fields.Text_none:setVisible(#self.itemList == 0)
end
function RuneSourcePopPanel:isCanMerge(id, count)
	local ret = false
	if 0 < count then
		local mergeID = backpackltCtrl:getItemIDByMaterial(id)
		if not backpackltCtrl:getMaterialOfMergeItem(mergeID) then
			local backpackltCtrl, material = backpackltCtrl:getMaterialOfMergeItem(mergeID), backpackltCtrl:getMaterialOfMergeItem(mergeID)
		end
		if #material == 1 then
			local mergeCount = math.floor(count / material[1].count)
			ret = 0 < mergeCount
		end
	end
	return ret
end
return RuneSourcePopPanel
