local _ENV, allianceWarSettingCtrl
local gametop = gModuleMgr.getObject("gametop")
local SETTING_KEY = "Game:AllianceWar:settings~table"
_ENV = nil
;(nil).level = true
;(nil).levelNum = 0
;(nil).star = false
;(nil).starNum = 0
;(nil).power = true
local (nil).powerNum, defsetting = 0, nil
function allianceWarSettingCtrl:init()
	_ENV = nil
	;(nil).byUID = true
	self.settings = SoraDConfigGet(SETTING_KEY, nil) or defsetting
end
function allianceWarSettingCtrl:checkIsFiler(data, isMass)
	if isMass then
		if not self:isFilerMass() then
			return false
		end
	elseif not self:isFilerSingle() then
		return false
	end
	if data.castleLv and self:isFilerLevel() then
		local level = self:getFilerLevel()
		if level >= data.castleLv then
			return true
		end
	end
	if data.star and self:isFilerStar() then
		local star = self:getFilerStar()
		if star >= data.star then
			return true
		end
	end
	local totalFc = data.totalFc or 0
	if isMass and data.from then
		for _, v in ipairs(data.from) do
			totalFc = totalFc + (v.totalFc or 0)
		end
	end
	if totalFc and self:isFilerPower() then
		local power = self:getFilerPower()
		if totalFc <= power then
			return true
		end
	end
	return false
end
function allianceWarSettingCtrl:checkIsFilerByData(moveLineData)
	local isMass = true
	local lineType = moveLineData.moveLineType
	if lineType == gMapMoveLineType.moveLineTypeAttackLord or lineType == gMapMoveLineType.moveLineTypecapture or lineType == gMapMoveLineType.moveLineTypeRomanSoul then
		isMass = false
	end
	return self:checkIsFiler(moveLineData, isMass)
end
function allianceWarSettingCtrl:checkIsFilerMoveLine(moveLineData)
	if not self:isFilerMoveLine() then
		return false
	end
	if moveLineData.matrixType ~= gMapMoveLineMatrixType.moveLineMatrixTypeTroop then
		return false
	end
	if moveLineData.moveLineColor ~= gMapMoveLineColor.moveLineColorRed then
		return false
	end
	return self:checkIsFilerByData(moveLineData)
end
function allianceWarSettingCtrl:isEnableFiler(data, isMass)
	local isEnable = self:isFilerSingle() or self:isFilerMass()
	return isEnable
end
function allianceWarSettingCtrl:isFilerSingle()
	return self.settings.single or false
end
function allianceWarSettingCtrl:isFilerMass()
	return self.settings.mass or false
end
function allianceWarSettingCtrl:isFilerMoveLine()
	return self.settings.moveline or false
end
function allianceWarSettingCtrl:isFilerLevel()
	return self.settings.level or false
end
function allianceWarSettingCtrl:isFilerStar()
	return self.settings.star or false
end
function allianceWarSettingCtrl:getFilerLevel()
	return self.settings.levelNum or 0
end
function allianceWarSettingCtrl:getFilerStar()
	return self.settings.starNum or 0
end
function allianceWarSettingCtrl:isFilerPower()
	return self.settings.power or false
end
function allianceWarSettingCtrl:getFilerPower()
	return self.settings.powerNum or 0
end
function allianceWarSettingCtrl:updateSetting(data)
	local isDiff, isDiffMoveLine = self:updateSetting_imp(data)
	if isDiff then
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		kingdomMapCtrl.kingdomMapCell:refreshQueueByWarSetting()
		gametop = kingdomMapCtrl.kingdomMapCell
		kingdomMapCtrl.kingdomMapCell.msg = "MESSAGE_ALLIACNE_WAR_SETTING"
		SoraDSendMessage(kingdomMapCtrl.kingdomMapCell)
	end
	if isDiffMoveLine or self:isFilerMoveLine() and isDiff then
		gametop = self
		self.msg = "MESSAGE_ALLIACNE_WAR_SETTING_MOVELINE"
		SoraDSendMessage(self)
	end
end
local syncSetting = function(settings, data, key)
	if data[key] ~= nil and (settings[key] == nil or settings[key] ~= data[key]) then
		settings[key] = data[key]
		return true
	end
end
function allianceWarSettingCtrl:updateSetting_imp(data)
	local isDiff = false
	local isDiffMoveLine = false
	local settings = self.settings
	if syncSetting(settings, data, "single") then
		isDiff = true
	end
	if syncSetting(settings, data, "mass") then
		isDiff = true
	end
	if syncSetting(settings, data, "level") then
		isDiff = true
	end
	if syncSetting(settings, data, "star") then
		isDiff = true
	end
	if syncSetting(settings, data, "power") then
		isDiff = true
	end
	if syncSetting(settings, data, "levelNum") and self:isFilerLevel() then
		isDiff = true
	end
	if syncSetting(settings, data, "starNum") and self:isFilerStar() then
		isDiff = true
	end
	if syncSetting(settings, data, "powerNum") and self:isFilerPower() then
		isDiff = true
	end
	if syncSetting(settings, data, "moveline") then
		isDiffMoveLine = true
	end
	syncSetting = "moveline"
	;("moveline").byUID = true
	SoraDConfigSet(SETTING_KEY, self.settings, "moveline")
	return isDiff, isDiffMoveLine
end
return allianceWarSettingCtrl
