_ENV = nil
;(nil).QueueShowSwitch = 1
;(nil).HideAllianceGiftMailNickname = 2
;(nil).ShareEquipmentToAllianceChat = 3
;(nil).QueueShowSolider = 4
;(nil).HideAllianceGiftMailGiftName = 5
;(nil).bingPhoneReward = 6
;(nil).chatTitleShow = 7
_ENV, gSettingKeyType, (nil).passwdVerify = nil, nil, 8
;(nil)[gSettingKeyType.QueueShowSwitch] = true
;(nil)[gSettingKeyType.HideAllianceGiftMailNickname] = true
;(nil)[gSettingKeyType.ShareEquipmentToAllianceChat] = true
;(nil)[gSettingKeyType.QueueShowSolider] = true
;(nil)[gSettingKeyType.HideAllianceGiftMailGiftName] = true
;(nil)[gSettingKeyType.bingPhoneReward] = true
;(nil)[gSettingKeyType.chatTitleShow] = true
_ENV, gCanSettingKeyType, (nil)[gSettingKeyType.passwdVerify] = nil, nil, true
;(nil).Force = 0
;(nil).DispatchArmy = 1
;(nil).DelBuilding = 2
;(nil).SellWeapon = 3
;(nil).HeroReforge = 4
;(nil).HeroChipExchange = 5
;(nil).BeastMarkUnlock = 6
;(nil).MagicLampSkillUnlock = 7
;(nil).ArmsRuneUnlock = 8
;(nil).WarGemEnchantUnlock = 9
;(nil).PremiumStoreRestPsw = 10
;(nil).BagItemLock = 11
_ENV, gSecondaryLockType, (nil).EquipLock = nil, nil, 12
;(nil)[gSettingKeyType.QueueShowSwitch] = function(v)
	if type(v) ~= "number" then
		return false
	end
	if v < 0 or 1 < v then
		return false
	end
	return true
end
;(nil)[gSettingKeyType.HideAllianceGiftMailNickname] = function(v)
	if gStatus.YES ~= v and gStatus.NO ~= v then
		return false
	end
	return true
end
;(nil)[gSettingKeyType.ShareEquipmentToAllianceChat] = function(v)
	if gStatus.YES ~= v and gStatus.NO ~= v then
		return false
	end
	return true
end
;(nil)[gSettingKeyType.QueueShowSolider] = function(v)
	if type(v) ~= "number" then
		return false
	end
	if v < 0 or 1 < v then
		return false
	end
	return true
end
;(nil)[gSettingKeyType.HideAllianceGiftMailGiftName] = function(v)
	if gStatus.YES ~= v and gStatus.NO ~= v then
		return false
	end
	return true
end
;(nil)[gSettingKeyType.bingPhoneReward] = function(v)
	if gStatus.YES ~= v and gStatus.NO ~= v then
		return false
	end
	return true
end
;(nil)[gSettingKeyType.chatTitleShow] = function(v)
	if gStatus.YES ~= v and gStatus.NO ~= v then
		return false
	end
	return true
end
gSettingValueCheck, (nil)[gSettingKeyType.passwdVerify] = nil, function(v)
	if gStatus.YES ~= v and gStatus.NO ~= v then
		return false
	end
	return true
end
