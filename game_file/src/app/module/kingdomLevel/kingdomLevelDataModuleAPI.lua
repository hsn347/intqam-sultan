local kingdomLevelBuff = include("kingdomLevelBuff")
local _ENV, kingdomLevelDataModuleAPI = "kingdomLevelBuff", "kingdomLevelBuff"
function kingdomLevelDataModuleAPI:isOpen()
	return self:getModuleCtrl():isOpen()
end
function kingdomLevelDataModuleAPI:isUnlock()
	return self:getModuleCtrl():isUnlock()
end
function kingdomLevelDataModuleAPI:getKingdomLevel()
	return self:getModuleCtrl():getKingdomLevel()
end
function kingdomLevelDataModuleAPI:getKingdomLevelInfo()
	return self:getModuleCtrl():reqKingdomLevelInfo()
end
function kingdomLevelDataModuleAPI:getKingdomLevelExpInfo()
	return self:getModuleCtrl():reqKingdomLevelExpInfo()
end
function kingdomLevelDataModuleAPI:getBuff(effectType)
	if not self:isUnlock() then
		return
	end
	local kingdomLevel = self:getKingdomLevel()
	return kingdomLevelBuff:getBuffEffect(kingdomLevel, effectType)
end
function kingdomLevelDataModuleAPI:getModuleCtrl()
	return SoraDGetCtrl("kingdomLevelCtrl")
end
return kingdomLevelDataModuleAPI
