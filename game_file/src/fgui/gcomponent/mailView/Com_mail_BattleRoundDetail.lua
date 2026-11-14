local baseComponent = require("fgui.base.baseComponent")
local armyDesRead = include("armyDesRead")
local Com_mail_BattleRoundDetail = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://mailView/Com_mail_BattleRoundDetail", Com_mail_BattleRoundDetail)
_ENV = fgui.register_extension
fgui.register_extension.DIZZINESS = 1
fgui.register_extension.DISARM = 2
fgui.register_extension.INFANTRY_ATK_TIMES_DAMAGE_PLUS = 3
fgui.register_extension.FIRST_ROUND_INFANTRY_HP_SHIELD_PLUS = 4
fgui.register_extension.ENEMY_HP_SHIELD_REDUCE = 5
fgui.register_extension.MAMMOTH_BEAR_DMG_REDUCE = 6
local _ENV, fgui.register_extension.MAMMOTH_ATTACK_DMG_PLUS, BattleEffctType = "ui://mailView/Com_mail_BattleRoundDetail", 7, fgui.register_extension
;("ui://mailView/Com_mail_BattleRoundDetail").tower1 = 3
;("ui://mailView/Com_mail_BattleRoundDetail").tower2 = 4
local _ENV, ("ui://mailView/Com_mail_BattleRoundDetail").tower3, MUType = Com_mail_BattleRoundDetail, 5, "ui://mailView/Com_mail_BattleRoundDetail"
Com_mail_BattleRoundDetail[MUType.tower1] = "buildDes_name_103"
Com_mail_BattleRoundDetail[MUType.tower2] = "buildDes_name_103"
local _ENV, Com_mail_BattleRoundDetail[MUType.tower3], muTypeName = MUType.tower3, "buildDes_name_103", Com_mail_BattleRoundDetail
_ENV = nil
;(nil).title = i18n("battlelog_text_57")
MUType.tower3[BattleEffctType.DIZZINESS], (nil).color = nil, 2
_ENV = nil
;(nil).title = i18n("battlelog_text_58")
MUType.tower3[BattleEffctType.DISARM], (nil).color = nil, 2
_ENV = nil
;(nil).title = i18n("battlelog_text_59")
;(nil).color = 1
MUType.tower3[BattleEffctType.INFANTRY_ATK_TIMES_DAMAGE_PLUS], (nil).percentValue = nil, 1
_ENV = nil
;(nil).title = i18n("battlelog_text_60")
;(nil).color = 1
MUType.tower3[BattleEffctType.FIRST_ROUND_INFANTRY_HP_SHIELD_PLUS], (nil).percentValue = nil, 100
_ENV = nil
;(nil).title = i18n("battlelog_text_61")
;(nil).color = 2
MUType.tower3[BattleEffctType.ENEMY_HP_SHIELD_REDUCE], (nil).percentValue = nil, 100
_ENV = nil
;(nil).title = function(armyType)
	_ENV = nil
	;(nil).armyType = include("mailFunctions"):getSoldierName(armyType)
	return i18n("mail_2_text_94", nil)
end
;(nil).color = 2
;(nil).percentValue = 1
MUType.tower3[BattleEffctType.MAMMOTH_BEAR_DMG_REDUCE], (nil).symbol = nil, "-"
_ENV = nil
;(nil).title = function(armyType)
	_ENV = nil
	;(nil).armyType = include("mailFunctions"):getSoldierName(armyType)
	return i18n("mail_2_text_95", nil)
end
;(nil).color = 1
;(nil).percentValue = 1
MUType.tower3[BattleEffctType.MAMMOTH_ATTACK_DMG_PLUS], (nil).symbol = nil, "+"
local effectName = MUType.tower3
function Com_mail_BattleRoundDetail:onInit()
	self.fields.list_myArmy:setItemRenderer(handler(self, self.itemRenderer_list_myArmy))
	self.fields.list_enemyArmy:setItemRenderer(handler(self, self.itemRenderer_list_enemyArmy))
	self.fields.list_myBuff:setItemRenderer(handler(self, self.itemRenderer_list_myBuff))
	self.fields.list_enemyBuff:setItemRenderer(handler(self, self.itemRenderer_list_enemyBuff))
	self.fields.text_armyNum:setString(i18n("common_text_2709"))
	self.fields.text_armyName:setString(i18n("mail_2_text_35"))
	self.fields.text_buffValue:setString(i18n("battlelog_text_66"))
	self.fields.text_buffName:setString(i18n("battlelog_text_65"))
	self.fields.text_my:setString(i18n("battlelog_text_63"))
	self.fields.text_enmey:setString(i18n("battlelog_text_62"))
	self.fields.text_my2:setString(i18n("battlelog_text_63"))
	self.fields.text_enmey2:setString(i18n("battlelog_text_62"))
	self.fields.Label_title1:setTitle(i18n("battlelog_text_52"))
	self.fields.Label_title2:setTitle(i18n("battlelog_text_53"))
end
function Com_mail_BattleRoundDetail:onShow()
end
function Com_mail_BattleRoundDetail:updateData(curRoundArmyData, curRoundEffectData, isDefense)
	self.curRoundArmyData = curRoundArmyData
	self.curRoundEffectData = curRoundEffectData
	self.isDefense = isDefense
	local myIdx = self.isDefense and "def" or "atk"
	local enemyIdx = self.isDefense and "atk" or "def"
	if not self.curRoundArmyData[myIdx] then
		_ENV = self.curRoundArmyData[myIdx]
	end
	self.myArmyList, _ENV, self.myArmyData = self.curRoundArmyData[myIdx], self.curRoundArmyData[myIdx], self.curRoundArmyData[myIdx]
	for k, v in pairs(self.myArmyData) do
		if muTypeName[tonumber(k)] then
			local towerArmy
			for i, v2 in pairs(self.myArmyList) do
				if v2.armyId == MUType.tower1 then
					towerArmy = v2
					break
				end
			end
			if towerArmy then
				towerArmy.num = towerArmy.num + v
			else
				_ENV = pairs(self.myArmyList)
				pairs(self.myArmyList).armyId = MUType.tower1
				pairs(self.myArmyList).num = v
				table.insert(self.myArmyList, pairs(self.myArmyList))
			end
		else
			_ENV = self.myArmyList
			self.myArmyList.armyId = tonumber(k)
			self.myArmyList.num = v
			table.insert(self.myArmyList, self.myArmyList)
		end
	end
	if not self.curRoundArmyData[enemyIdx] then
		_ENV = self.curRoundArmyData[enemyIdx]
	end
	self.enemyArmyList, _ENV, self.enemyArmyData = self.curRoundArmyData[enemyIdx], self.curRoundArmyData[enemyIdx], self.curRoundArmyData[enemyIdx]
	for k, v in pairs(self.enemyArmyData) do
		if muTypeName[tonumber(k)] then
			local towerArmy
			for i, v2 in pairs(self.enemyArmyList) do
				if v2.armyId == MUType.tower1 then
					towerArmy = v2
					break
				end
			end
			if towerArmy then
				towerArmy.num = towerArmy.num + v
			else
				_ENV = pairs(self.enemyArmyList)
				pairs(self.enemyArmyList).armyId = MUType.tower1
				pairs(self.enemyArmyList).num = v
				table.insert(self.enemyArmyList, pairs(self.enemyArmyList))
			end
		else
			_ENV = self.enemyArmyList
			self.enemyArmyList.armyId = tonumber(k)
			self.enemyArmyList.num = v
			table.insert(self.enemyArmyList, self.enemyArmyList)
		end
	end
	if not self.curRoundEffectData[myIdx] then
		_ENV = self.curRoundEffectData[myIdx]
	end
	self.myBuffList, _ENV, self.myBuffData = self.curRoundEffectData[myIdx], self.curRoundEffectData[myIdx], self.curRoundEffectData[myIdx]
	local isArray = function(t)
		local count = 0
		for k, v in pairs(t) do
			count = count + 1
			if type(k) ~= "number" then
				return false
			end
		end
		return count == #t
	end
	for k, v in pairs(self.myBuffData) do
		if type(v) == "table" then
			for i, v2 in pairs(v) do
				_ENV = nil
				_ENV, (nil).buffId = tonumber(k), tonumber(k)
				tonumber(k).armyClassType = tonumber(i)
				;(nil).num, tonumber(k).effectValue = tonumber(k), v2
				table.insert(self.myBuffList, nil)
			end
		else
			_ENV = pairs(v)
			pairs(v).buffId = tonumber(k)
			pairs(v).num = v
			table.insert(self.myBuffList, pairs(v))
		end
	end
	if not self.curRoundEffectData[enemyIdx] then
		_ENV = self.curRoundEffectData[enemyIdx]
	end
	self.enemyBuffList, _ENV, self.enemyBuffData = self.curRoundEffectData[enemyIdx], self.curRoundEffectData[enemyIdx], self.curRoundEffectData[enemyIdx]
	for k, v in pairs(self.enemyBuffData) do
		if type(v) == "table" then
			for i, v2 in pairs(v) do
				_ENV = nil
				_ENV, (nil).buffId = tonumber(k), tonumber(k)
				tonumber(k).armyClassType = tonumber(i)
				;(nil).num, tonumber(k).effectValue = tonumber(k), v2
				table.insert(self.enemyBuffList, nil)
			end
		else
			_ENV = pairs(v)
			pairs(v).buffId = tonumber(k)
			pairs(v).num = v
			table.insert(self.enemyBuffList, pairs(v))
		end
	end
	self.myArmyListHeight = (#self.myArmyList + 1) * 26
	self.enemyArmyListHeight = (#self.enemyArmyList + 1) * 26
	self.myBuffListHeight = (#self.myBuffList + 1) * 26
	self.enemyBuffListHeight = (#self.enemyBuffList + 1) * 26
	self.fields.list_myArmy:setNumItems(#self.myArmyList)
	self.fields.list_myArmy:setHeight(self.myArmyListHeight)
	self.fields.list_enemyArmy:setNumItems(#self.enemyArmyList)
	self.fields.list_enemyArmy:setHeight(self.enemyArmyListHeight)
	self.fields.list_myBuff:setNumItems(#self.myBuffList)
	self.fields.list_myBuff:setHeight(self.myBuffListHeight)
	self.fields.list_enemyBuff:setNumItems(#self.enemyBuffList)
	self.fields.list_enemyBuff:setHeight(self.enemyBuffListHeight)
end
function Com_mail_BattleRoundDetail:itemRenderer_list_myArmy(index, obj)
	local armyData = self.myArmyList[index + 1]
	print(armyData.armyId, "armyData.armyId")
	local name = muTypeName[armyData.armyId] and i18n(muTypeName[armyData.armyId]) or armyDesRead.getName(armyData.armyId)
	local value = armyData.num
	obj:initData(name, value)
end
function Com_mail_BattleRoundDetail:itemRenderer_list_enemyArmy(index, obj)
	local armyData = self.enemyArmyList[index + 1]
	local name = muTypeName[armyData.armyId] and i18n(muTypeName[armyData.armyId]) or armyDesRead.getName(armyData.armyId)
	local value = armyData.num
	obj:initData(name, value)
end
function Com_mail_BattleRoundDetail:itemRenderer_list_myBuff(index, obj)
	local buffData = self.myBuffList[index + 1]
	local value = buffData.num
	local name = effectName[buffData.buffId].title
	if type(value) == "table" and type(name) == "function" then
		name = effectName[buffData.buffId].title(value.armyClassType)
		value = value.effectValue / 10
	end
	local color = effectName[buffData.buffId].color
	local percentValue = effectName[buffData.buffId].percentValue
	local symbol = effectName[buffData.buffId].symbol
	obj:initData(name, value, color, percentValue, symbol)
end
function Com_mail_BattleRoundDetail:itemRenderer_list_enemyBuff(index, obj)
	local buffData = self.enemyBuffList[index + 1]
	local value = buffData.num
	local name = effectName[buffData.buffId].title
	if type(value) == "table" and type(name) == "function" then
		name = effectName[buffData.buffId].title(value.armyClassType)
		value = value.effectValue / 10
	end
	local color = effectName[buffData.buffId].color
	local percentValue = effectName[buffData.buffId].percentValue
	local symbol = effectName[buffData.buffId].symbol
	obj:initData(name, value, color, percentValue, symbol)
end
return Com_mail_BattleRoundDetail
