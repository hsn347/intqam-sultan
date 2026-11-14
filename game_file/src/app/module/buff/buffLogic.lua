local _ENV, buffLogic
function buffLogic.getBuffSourceList()
	_UPVALUE15_ = nil
	;(nil)[1] = gBuffSource.CITY
	;(nil)[2] = gBuffSource.OFFICIAL
	;(nil)[3] = gBuffSource.SKILL
	;(nil)[4] = gBuffSource.VIP
	;(nil)[5] = gBuffSource.RECHARGE_MONTH_CARD
	;(nil)[6] = gBuffSource.RECHARGE_WEEK_CARD
	;(nil)[7] = gBuffSource.GOD_ARMS
	;(nil)[8] = gBuffSource.HALLOWEEN
	;(nil)[9] = gBuffSource.GLORIOUS_SHINE_ACTIVITY
	;(nil)[10] = gBuffSource.NEWBIE
	;(nil)[11] = gBuffSource.SULTAN_BACK
	;(nil)[12] = gBuffSource.SULTAN_BACK_REBATE
	;(nil)[13] = gBuffSource.KINGDOM_CHRONICLES
	;(nil)[14] = gBuffSource.NEW_START_BUFF
	local (nil)[15], config = gBuffSource.NEW_YEAR_ACTIVITY_GUIDE, nil
	return config
end
function buffLogic.canReplace(origin)
	_ENV = nil
	;(nil)[gBuffSource.CITY] = true
	;(nil)[gBuffSource.OFFICIAL] = false
	;(nil)[gBuffSource.SKILL] = true
	;(nil)[gBuffSource.VIP] = true
	;(nil)[gBuffSource.RECHARGE_MONTH_CARD] = true
	;(nil)[gBuffSource.RECHARGE_WEEK_CARD] = true
	;(nil)[gBuffSource.GOD_ARMS] = true
	;(nil)[gBuffSource.HALLOWEEN] = true
	;(nil)[gBuffSource.GLORIOUS_SHINE_ACTIVITY] = true
	;(nil)[gBuffSource.SULTAN_BACK] = true
	local (nil)[gBuffSource.SULTAN_BACK_REBATE], config = true, nil
	return config[origin]
end
function buffLogic.canInterrupt(origin)
	_ENV = nil
	;(nil)[gBuffSource.CITY] = true
	;(nil)[gBuffSource.OFFICIAL] = false
	;(nil)[gBuffSource.SKILL] = true
	;(nil)[gBuffSource.VIP] = false
	;(nil)[gBuffSource.RECHARGE_MONTH_CARD] = true
	;(nil)[gBuffSource.RECHARGE_WEEK_CARD] = true
	;(nil)[gBuffSource.GOD_ARMS] = true
	;(nil)[gBuffSource.HALLOWEEN] = false
	;(nil)[gBuffSource.GLORIOUS_SHINE_ACTIVITY] = true
	;(nil)[gBuffSource.SULTAN_BACK] = true
	local (nil)[gBuffSource.SULTAN_BACK_REBATE], config = true, nil
	return config[origin]
end
function buffLogic.isNeedThousand(buffID)
	_ENV = nil
	;(nil).INFANTRY_BASE_ATTACK = 440
	;(nil).INFANTRY_BASE_DEFENSE = 441
	;(nil).INFANTRY_BASE_HP = 442
	;(nil).CAVALRY_BASE_ATTACK = 443
	;(nil).CAVALRY_BASE_DEFENSE = 444
	;(nil).CAVALRY_BASE_HP = 445
	;(nil).ARCHER_BASE_ATTACK = 446
	;(nil).ARCHER_BASE_DEFENSE = 447
	;(nil).ARCHER_BASE_HP = 448
	;(nil).CHARIOTS_BASE_ATTACK = 449
	;(nil).CHARIOTS_BASE_DEFENSE = 450
	;(nil).CHARIOTS_BASE_HP = 451
	;(nil).ELITE_BASE_ATTACK = 452
	;(nil).ELITE_BASE_DEFENSE = 453
	local (nil).ELITE_BASE_HP, list = 454, nil
	local ret = false
	for k, v in pairs(list) do
		if v == buffID then
			ret = true
			break
		end
	end
	return ret
end
return buffLogic
