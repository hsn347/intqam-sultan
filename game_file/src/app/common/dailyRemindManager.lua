local _ENV, dailyRemindManager.list, _ENV, _ENV, dailyRemindManager
;(nil).resourceBuyView = 1
;(nil).petTrainView = 2
;(nil).soldiersCampView_soldier = 3
;(nil).soldiersCampView_trap = 4
;(nil).troopFlagView = 5
;(nil).heroTrialMapView = 6
;(nil).worldMapEmojiSeal = 7
;(nil).treasureHuntView_ten = 8
;(nil).treasureHuntView_gold = 9
;(nil).treasureHuntView_tenGold = 10
;(nil).ramadanPartyView_Gift = 11
;(nil).gemGoodsView_buy = 12
;(nil).eidTycoonDonatePopView = 13
;(nil).eidTycoonView_task = 14
;(nil).eidTycoonView_rank = 15
;(nil).togetherTeam_completeGrid = 16
;(nil).togetherTeam_openCount = 17
;(nil).warframeForgDetail = 18
;(nil).coffeeCraftsmanDel = 19
;(nil).coffeeCraftsmanBake = 20
;(nil).coffeeCraftsmanBakeTen = 21
;(nil).coffeeCraftsmanPoolGuide = 22
;(nil).wargemEnchantChange = 23
;(nil).romanSoulChallengeEnter = 24
;(nil).wastelandRank = 25
;(nil).armyTransferCon = 26
;(nil).desertTreasureEnterAni = 27
;(nil).snowmanDonateOrBuyPrompt = 28
;(nil).snowmanMaxBoxContinue = 29
;(nil).homePopupPanel = 30
;(nil).inheritGiftBuy = 31
;(nil).ramandanMarketSaleItemBuy = 32
;(nil).allianceEscortRecord = 33
;(nil).storageBoxView = 34
;(nil).towerdefendGuide = 35
;(nil).outapppurchase = 36
;(nil).starryNightJounry = 37
;(nil).nebulaTreasure = 38
;(nil).nebulaWarEnterAction = 39
;(nil).nebulaWonderlandEnter = 40
;(nil).meteoriteActive = 41
;(nil).tenwargemcompose = 42
;(nil).equipRemakeGold = 43
;(nil).dessertsKingShop = 44
;(nil).runeLuckyValue = 45
;(nil).nebulaEmperorEnter = 46
;(nil).monsterInvasionTip = 47
;(nil).activity_9001594 = 48
;(nil).activity_9001629 = 49
;(nil).heroChipExchange = 50
;(nil).itemRecycle = 51
;(nil).attackTip_bossType35 = 52
;(nil).commonSpeedUpBest = 53
;(nil).armorTechnologyGold = 54
;(nil).activity_9001661 = 55
;(nil).marchSpeedUp = 56
;(nil).useSpeedItemCount = 57
;(nil).divineBeastMarkRecycle = 58
;(nil).roaringFlame_enter_first = 59
;(nil).wastelandMonster = 60
;(nil).activity_9001770_1 = 61
;(nil).activity_9001770_2 = 62
;(nil).activity_9001770_3 = 63
;(nil).magiclampskill_lock = 64
;(nil).armsrune_lock = 65
;(nil).wargemenchant_lock = 66
;(nil).activity_9001704 = 67
;(nil).activity_9001702_1 = 68
;(nil).activity_9001702_2 = 69
;(nil).activity_9001713_1 = 70
;(nil).activity_9001713_2 = 71
;(nil).rechargePop = 72
;(nil).herostnt_times = 73
;(nil).gardenWarEnter = 74
dailyRemindManager.REMIND_TYPE, (nil).recharge_hide_gift = nil, 75
function dailyRemindManager.addRemindToManager(key, value)
	dailyRemindManager.list[tostring(key)] = value or serviceFunctions.systemTime()
	dump(dailyRemindManager.list, "==dailyRemindManager.addRemindToManager==")
	dailyRemindManager = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:dailyRemindManager:saveTime~table", dailyRemindManager.list, nil)
end
function dailyRemindManager.checkNeedRemind(key)
	local configTime = dailyRemindManager.getRemindTime(key)
	if not serviceFunctions.isSameDay(configTime) then
		return true
	end
end
function dailyRemindManager.addRemindOnceToManager(key, activityID)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local openCount = activityShowCtrl:getOpenCount(activityID)
	dailyRemindManager.list[tostring(key)] = openCount
	dump(dailyRemindManager.list, "==dailyRemindManager.addRemindOnceToManager==")
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:dailyRemindManager:saveTime~table", dailyRemindManager.list, nil)
end
function dailyRemindManager.checkNeedRemindOnce(key, activityID)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local openCount = activityShowCtrl:getOpenCount(activityID)
	dump(openCount, "jksdfjdkjfkdjfkdfjkjfk")
	local configCount = dailyRemindManager.getRemindTime(key)
	dump(configCount, "fskldfjkdfjkdfjkdfjk")
	if not configCount or configCount == 0 or configCount ~= openCount then
		return true
	end
end
function dailyRemindManager.getRemindTime(key)
	dailyRemindManager.init()
	return dailyRemindManager.list[tostring(key)] or 0
end
function dailyRemindManager.init()
