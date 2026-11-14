local artifactRuneRead = include("artifactRuneRead")
local buffDesRead = include("buffDesRead")
local equipDesRead = include("equipDesRead")
local godArmsRuneCtrl = SoraDGetCtrl("godArmsRuneCtrl")
local godArmsCtrl = SoraDGetCtrl("godArmsCtrl")
local propParser = include("propParser")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RuneAttrTotalPanel = class("RuneAttrTotalPanel", baseFguiPanel)
function RuneAttrTotalPanel:ctor(...)
	self.super.ctor(self, ...)
	print("RuneAttrTotalPanel:ctor", self.viewName)
end
function RuneAttrTotalPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RuneAttrTotalPanel:onInit()
	print("=======RuneAttrTotalPanel:onInit")
	self.weaponID = self.param.data.weaponID
	self.fields.Panel_bg:setTitle(equipDesRead.getArtifactName(self.weaponID) .. i18n("Weapon_Rune_button_001"))
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
end
function RuneAttrTotalPanel:onShow()
	print("=======RuneAttrTotalPanel:onShow")
	self.tableAttr, _ENV = print, print
	self.index = 0
	local weaponData = godArmsCtrl:getArmsInfo(self.weaponID)
	local _ENV, skillList = godArmsCtrl, godArmsCtrl
	_ENV = nil
	;(nil).title = i18n("artifact_title_02")
	;(nil).index = 0
	table.insert(self.tableAttr, nil)
	self.index = 1
	for k, v in pairs(weaponData.info.skillList) do
		if v.isActive then
			table.insert(skillList, v)
		end
	end
	table.sort(skillList, function(a, b)
		return a.skillID < b.skillID
	end)
	for k, v in ipairs(skillList) do
		local attrInfo = equipDesRead.getArtifactAttrInfo(v.skillID, weaponData.info.level, weaponData.info.awakeStatus)
		_ENV = weaponData.info.awakeStatus
		weaponData.info.awakeStatus.title = equipDesRead.getArtifactSkillName(v.skillID, weaponData.info.awakeStatus == ARMS_AWAKE_STATUS.STATUS_AWAKE) .. propParser.getFormatByAttrIDAndValue(attrInfo.buffType[1], attrInfo.buffValue[1])
		weaponData.info.awakeStatus.index = self.index
		table.insert(self.tableAttr, weaponData.info.awakeStatus)
		self.index = self.index + 1
	end
	local runeList = godArmsRuneCtrl:getRunedData(self.weaponID)
	local _ENV, buffArray = godArmsRuneCtrl, godArmsRuneCtrl
	for k, v in ipairs(runeList) do
		local info = artifactRuneRead.getRuneInfo(v.rid)
		local pLvCfg = artifactRuneRead.getPropertiesLvCfg(info.BasicProperties.growType, v.level)
		_ENV = attrInfo.buffType[1]
		attrInfo.buffType[1].buffType = info.BasicProperties.buffType
		attrInfo.buffType[1].buffVal = info.BasicProperties.buffVal + pLvCfg.GrowingValue
		attrInfo.buffType[1].buffMode = info.BasicProperties.buffMode
		table.insert(buffArray, attrInfo.buffType[1])
		if not v.extraProperty then
			_ENV = v.extraProperty
		end
		for m, n in ipairs(v.extraProperty) do
			if n[3] then
				local propertyArray, quality = artifactRuneRead.getPropertyArray(n[1])
				for ki, vi in ipairs(propertyArray) do
					local pLvCfg = artifactRuneRead.getPropertiesLvCfg(vi.growType, n[2])
					_ENV = nil
					;(nil).buffType = vi.buffType
					;(nil).buffVal = vi.buffVal + pLvCfg.GrowingValue
					;(nil).buffMode = vi.buffMode
					table.insert(buffArray, nil)
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
	if 0 < #self.buffList then
		function _ENV(a, b)
			return a.id < b.id
		end
		;(function(a, b)
			return a.id < b.id
		end).title = i18n("Weapon_Rune_tips_002")
		;(function(a, b)
			return a.id < b.id
		end).index = 0
		table.insert(self.tableAttr, function(a, b)
			return a.id < b.id
		end)
		self.index = 1
		for k, v in ipairs(self.buffList) do
			_ENV = v.buffMode
			v.buffMode.title = buffDesRead.getBuffDes(v.id, v.val, v.mode)
			v.buffMode.index = self.index
			table.insert(self.tableAttr, v.buffMode)
			self.index = self.index + 1
		end
	end
	self.fields.list:setNumItems(#self.tableAttr)
end
function RuneAttrTotalPanel:onItemRenderer(index, obj)
	obj:initData(self.tableAttr[index + 1])
end
return RuneAttrTotalPanel
