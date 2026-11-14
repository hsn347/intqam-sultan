local evilPalaceRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	evilPalaceRead:defineValue("monsterName", function()
		_ENV = nil
		;(nil)[1] = i18n("common_text_3267")
		;(nil)[2] = i18n("common_text_3268")
		return nil
	end)
	evilPalaceRead:defineValue("rewardBoxName", function()
		_ENV = nil
		;(nil)[1] = i18n("common_text_3269")
		;(nil)[2] = i18n("common_text_3270")
		return nil
	end)
end
init()
function evilPalaceRead.getMonsterName(battleType)
	if gMonsterpalaceBattletype.NORMAL_BATTLE == battleType then
		return evilPalaceRead.monsterName[1]
	elseif gMonsterpalaceBattletype.ELITE_BATTLE == battleType then
		return evilPalaceRead.monsterName[2]
	end
end
function evilPalaceRead.getRewardBoxName(battleType)
	if gMonsterpalaceBattletype.NORMAL_BATTLE == battleType then
		return evilPalaceRead.rewardBoxName[1]
	elseif gMonsterpalaceBattletype.ELITE_BATTLE == battleType then
		return evilPalaceRead.rewardBoxName[2]
	end
end
return evilPalaceRead
