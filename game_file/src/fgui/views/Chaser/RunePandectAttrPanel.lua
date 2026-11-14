local artifactRuneRead = include("artifactRuneRead")
local buffDesRead = include("buffDesRead")
local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RunePandectAttrPanel = class("RunePandectAttrPanel", baseFguiPanel)
function RunePandectAttrPanel:ctor(...)
	self.super.ctor(self, ...)
	print("RunePandectAttrPanel:ctor", self.viewName)
end
function RunePandectAttrPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RunePandectAttrPanel:onInit()
	print("=======RunePandectAttrPanel:onInit")
	self.weaponID = self.param.data.weaponID
	self.fields.Panel_bg:setTitle(i18n("Weapon_Rune_tips_001"))
	self.fields.Text_tip:setString(i18n("Weapon_Rune_tips_002"))
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
	local runeList = godArmsRuneCtrl:getRunedData(self.weaponID)
	self.tableAttr, _ENV = godArmsRuneCtrl, godArmsRuneCtrl
	local _ENV, buffArray = godArmsRuneCtrl, godArmsRuneCtrl
	for k, v in ipairs(runeList) do
		local info = artifactRuneRead.getRuneInfo(v.rid)
		local pLvCfg = artifactRuneRead.getPropertiesLvCfg(info.BasicProperties.growType, v.level)
		_ENV = handler(self, self.onItemRenderer)
		handler(self, self.onItemRenderer).buffType = info.BasicProperties.buffType
		handler(self, self.onItemRenderer).buffVal = info.BasicProperties.buffVal + pLvCfg.GrowingValue
		handler(self, self.onItemRenderer).buffMode = info.BasicProperties.buffMode
		table.insert(buffArray, handler(self, self.onItemRenderer))
		if not v.extraProperty then
			_ENV = v.extraProperty
		end
		for m, n in ipairs(v.extraProperty) do
			if n[3] then
				local propertyArray, quality = artifactRuneRead.getPropertyArray(n[1])
				for ki, vi in ipairs(propertyArray) do
					local pLvCfg = artifactRuneRead.getPropertiesLvCfg(vi.growType, n[2])
					_ENV = handler(self, self.onItemRenderer)
					handler(self, self.onItemRenderer).buffType = vi.buffType
					handler(self, self.onItemRenderer).buffVal = vi.buffVal + pLvCfg.GrowingValue
					handler(self, self.onItemRenderer).buffMode = vi.buffMode
					table.insert(buffArray, handler(self, self.onItemRenderer))
				end
			end
		end
	end
	local cfg = artifactRuneRead.getSuitInfo(self.weaponID)
	local totalLv = godArmsRuneCtrl:getArmTotalLevel(self.weaponID)
	for k, v in ipairs(cfg) do
		if totalLv >= v.lv then
			local skillInfo = artifactRuneRead.getSuitSkillInfo(v.skill)
			for i = 1, #skillInfo.Data, 3 do
				_ENV = ipairs(propertyArray)
				ipairs(propertyArray).buffType = skillInfo.Data[i]
				ipairs(propertyArray).buffVal = skillInfo.Data[i + 2]
				ipairs(propertyArray).buffMode = skillInfo.Data[i + 1]
				table.insert(buffArray, ipairs(propertyArray))
			end
		end
	end
	local _ENV, tempBuffArray = (for generator), ipairs(cfg)
	for k, v in ipairs(buffArray) do
		if tempBuffArray[v.buffType] then
			tempBuffArray[v.buffType].val = tempBuffArray[v.buffType].val + v.buffVal
		else
			_ENV = tempBuffArray[v.buffType].val + v.buffVal
			;(tempBuffArray[v.buffType].val + v.buffVal).val = v.buffVal
			tempBuffArray[v.buffType], (tempBuffArray[v.buffType].val + v.buffVal).mode = tempBuffArray[v.buffType].val + v.buffVal, v.buffMode
		end
	end
	self.buffList, _ENV = ipairs(buffArray)
	for k, v in pairs(tempBuffArray) do
		_ENV = v.buffMode
		v.buffMode.id = k
		v.buffMode.val = v.val
		v.buffMode.mode = v.mode
		table.insert(self.buffList, v.buffMode)
	end
	table.sort(self.buffList, function(a, b)
		return a.id < b.id
	end)
	for k, v in ipairs(self.buffList) do
		table.insert(self.tableAttr, buffDesRead.getBuffDes(v.id, v.val, v.mode))
	end
	self.fields.list:setNumItems(#self.tableAttr)
end
function RunePandectAttrPanel:onItemRenderer(index, obj)
	obj:initData(self.tableAttr[index + 1], index + 1)
end
function RunePandectAttrPanel:onShow()
	print("=======RunePandectAttrPanel:onShow")
end
return RunePandectAttrPanel
