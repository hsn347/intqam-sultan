local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
local artifactRuneRead = include("artifactRuneRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RuneBackpackPanel = class("RuneBackpackPanel", baseFguiPanel)
function RuneBackpackPanel:ctor(...)
	self.super.ctor(self, ...)
	print("RuneBackpackPanel:ctor", self.viewName)
end
function RuneBackpackPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RuneBackpackPanel:onInit()
	print("=======RuneBackpackPanel:onInit")
	self.curSortType = 0
	self.upType = false
	self.upLuckyType = false
	self.fields.Com_title:initData(i18n("Weapon_Rune_button_002"), handler(self, self.onClickClose))
	self.fields.Text_none:setString(i18n("Weapon_Rune_tips_017"))
	self.fields.Text_none:setVisible(false)
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	_UPVALUE5_ = self.fields.List.setItemRenderer
	_UPVALUE6_, self.fields.List.setItemRenderer[1] = i18n("Weapon_Rune_tips_010"), i18n("Weapon_Rune_tips_010")
	_UPVALUE6_, self.fields.List.setItemRenderer[2] = i18n("Weapon_Rune_tips_010"), i18n("Weapon_Rune_tips_014")
	_UPVALUE6_, self.fields.List.setItemRenderer[3] = i18n("Weapon_Rune_tips_010"), i18n("Weapon_Rune_tips_037")
	_UPVALUE6_, self.fields.List.setItemRenderer[4] = i18n("Weapon_Rune_tips_010"), i18n("Weapon_Rune_tips_015")
	_UPVALUE6_, self.fields.List.setItemRenderer[5] = i18n("Weapon_Rune_tips_010"), i18n("Weapon_Rune_tips_016")
	_UPVALUE6_, self.fields.List.setItemRenderer[6] = i18n("Weapon_Rune_tips_010"), i18n("Weapon_Rune_tips_042")
	_UPVALUE6_, self.fields.List.setItemRenderer[7] = i18n("Weapon_Rune_tips_010"), i18n("Weapon_Rune_tips_042")
	local _UPVALUE6_, self.fields.List.setItemRenderer[8], items = i18n("Weapon_Rune_tips_010"), i18n("Weapon_Rune_tips_042")
	i18n("Weapon_Rune_tips_010")[1] = 0
	i18n("Weapon_Rune_tips_010")[2] = 1
	i18n("Weapon_Rune_tips_010")[3] = 2
	i18n("Weapon_Rune_tips_010")[4] = 3
	i18n("Weapon_Rune_tips_010")[5] = 4
	local i18n("Weapon_Rune_tips_010")[6], values = 5, i18n("Weapon_Rune_tips_010")
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
	self.fields.Btn_sortLv:setTitle(self.upType and i18n("Weapon_Rune_tips_013") or i18n("Weapon_Rune_tips_012"))
	self.fields.Btn_sortLv:addClickListener(handler(self, self.onSortClick))
	self.fields.Btn_sortLv:setShowType(self.upType and 1 or 0)
	self.fields.Btn_sortLucky:setTitle(self.upLuckyType and i18n("Weapon_Rune_tips_114") or i18n("Weapon_Rune_tips_115"))
	self.fields.Btn_sortLucky:addClickListener(handler(self, self.onSortLuckyClick))
	self.fields.Btn_sortLucky:setShowType(self.upLuckyType and 1 or 0)
	self.fields.Button_source:setString(i18n("heraldry_text01"))
	self.fields.Button_source:addClickListener(handler(self, self.onSourceClick))
end
function RuneBackpackPanel:onShow()
	print("=======RuneBackpackPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.fields.ComboBox:fixPos()
	self.fields.Btn_sortLv:fixPos()
	self.fields.Btn_sortLucky:fixPos()
	self:initData()
end
function RuneBackpackPanel:onComboBoxClick()
	SoraDPlaySound()
	self.curSortType = tonumber(self.fields.ComboBox:getValue())
	print("self.curSortType=====", self.curSortType)
	self:sortData()
end
function RuneBackpackPanel:onSortClick()
	SoraDPlaySound()
	self.upType = not self.upType
	self.fields.Btn_sortLv:setTitle(self.upType and i18n("Weapon_Rune_tips_013") or i18n("Weapon_Rune_tips_012"))
	self.fields.Btn_sortLv:setShowType(self.upType and 1 or 0)
	self:sortShowRuneList()
end
function RuneBackpackPanel:onSourceClick()
	SoraDPlaySound()
	uiManager:show("RuneSourcePop")
end
function RuneBackpackPanel:sortShowRuneList()
	table.sort(self.showRuneList, function(a, b)
		if a.uid and b.uid then
			if self.upType then
				if a.season ~= b.season then
					return a.season < b.season
				end
				if a.class ~= b.class then
					return a.class < b.class
				end
				if a.level ~= b.level then
					return a.level < b.level
				end
				if a.luckyValue ~= b.luckyValue then
					if self.upLuckyType then
						return a.luckyValue < b.luckyValue
					else
						return a.luckyValue > b.luckyValue
					end
				end
				if a.runeType ~= b.runeType then
					return a.runeType < b.runeType
				end
				return a.rid < b.rid
			else
				if a.season ~= b.season then
					return a.season > b.season
				end
				if a.class ~= b.class then
					return a.class > b.class
				end
				if a.level ~= b.level then
					return a.level > b.level
				end
				if a.luckyValue ~= b.luckyValue then
					if self.upLuckyType then
						return a.luckyValue < b.luckyValue
					else
						return a.luckyValue > b.luckyValue
					end
				end
				if a.runeType ~= b.runeType then
					return a.runeType > b.runeType
				end
				return a.rid > b.rid
			end
		elseif not a.uid and not b.uid then
			return a.rid < b.rid
		else
			return a.uid ~= nil
		end
	end)
	self.fields.List:setNumItems(#self.showRuneList)
end
function RuneBackpackPanel:onSortLuckyClick()
	SoraDPlaySound()
	self.upLuckyType = not self.upLuckyType
	self.fields.Btn_sortLucky:setTitle(self.upLuckyType and i18n("Weapon_Rune_tips_114") or i18n("Weapon_Rune_tips_115"))
	self.fields.Btn_sortLucky:setShowType(self.upLuckyType and 1 or 0)
	self:sortShowRuneList()
end
function RuneBackpackPanel:sortData()
	self.showRuneList, _ENV = nil, nil
	if self.curSortType == 0 then
		self.showRuneList = self.myRuneList
	elseif self.curSortType == 5 then
		for k, v in ipairs(self.myRuneList) do
			if v.isExp then
				table.insert(self.showRuneList, v)
			end
		end
	else
		for k, v in ipairs(self.myRuneList) do
			if v.runeType == self.curSortType then
				table.insert(self.showRuneList, v)
			end
		end
	end
	self.fields.Text_none:setVisible(#self.showRuneList == 0)
	self:sortShowRuneList()
end
function RuneBackpackPanel:onItemRenderer(index, obj)
	obj:initData(self.showRuneList[index + 1])
end
function RuneBackpackPanel:initData()
	local runeList = godArmsRuneCtrl:getRuneData()
	local expruneList = godArmsRuneCtrl:getEXPRuneData()
	self.myRuneList, godArmsRuneCtrl = godArmsRuneCtrl, godArmsRuneCtrl
	for k, v in ipairs(runeList) do
		local info = artifactRuneRead.getRuneInfo(v.rid)
		local lvCfg = artifactRuneRead.getRuneLvCfg(info.ExpGrowingType, v.level)
		if not v.extraProperty then
			local godArmsRuneCtrl, extraProperty = v.extraProperty, v.extraProperty
		end
		godArmsRuneCtrl = nil
		;(nil).rid = v.rid
		;(nil).uid = v.uid
		;(nil).exp = v.exp
		;(nil).isLock = v.isLock
		;(nil).class = lvCfg.Class
		;(nil).season = info.Season
		;(nil).level = v.level
		;(nil).luckyValue = v.luckyValue or 0
		;(nil).cLevel = lvCfg.Level
		;(nil).heritType = info.HeritType
		;(nil).runeType = info.RuneType
		;(nil).isWear = godArmsRuneCtrl:isRuneWear(v.uid)
		;(nil).extraProperty = extraProperty
		;(nil).tempExtraProperty = v.tempExtraProperty
		table.insert(self.myRuneList, nil)
	end
	table.sort(self.myRuneList, function(a, b)
		if a.isWear == b.isWear then
			if a.season ~= b.season then
				return a.season > b.season
			end
			if a.class ~= b.class then
				return a.class > b.class
			end
			if a.level ~= b.level then
				return a.level > b.level
			end
			if a.runeType ~= b.runeType then
				return a.runeType < b.runeType
			end
			return a.rid < b.rid
		end
		return a.isWear
	end)
	local expUnitMax = artifactRuneRead.getRuneExpRuneUnitMax()
	local godArmsRuneCtrl, expList = self.myRuneList, self.myRuneList
	for k, v in pairs(expruneList) do
		if v <= expUnitMax then
			godArmsRuneCtrl = self.myRuneList
			self.myRuneList.isExp = true
			self.myRuneList.rid = tonumber(k)
			self.myRuneList.num = v
			table.insert(expList, self.myRuneList)
		else
			local leftNum = v
			while expUnitMax < leftNum do
				godArmsRuneCtrl = tonumber(k)
				tonumber(k).isExp = true
				tonumber(k).rid = tonumber(k)
				tonumber(k).num = expUnitMax
				table.insert(expList, (tonumber(k)))
				leftNum = leftNum - expUnitMax
			end
			godArmsRuneCtrl = tonumber(k)
			tonumber(k).isExp = true
			tonumber(k).rid = tonumber(k)
			tonumber(k).num = leftNum
			table.insert(expList, (tonumber(k)))
		end
	end
	table.sort(expList, function(a, b)
		if a.rid == b.rid then
			return a.num > b.num
		end
		return a.rid < b.rid
	end)
	for k, v in ipairs(expList) do
		table.insert(self.myRuneList, v)
	end
	self:sortData()
end
return RuneBackpackPanel
