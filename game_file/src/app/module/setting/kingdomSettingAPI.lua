local _ENV, kingdomSettingAPI
function kingdomSettingAPI:canSendChatMail()
	return self:checkCastleLevelLimit(gKingdomSettingKey.NEED_CASTLE_LEVEL_CHAT_MAIL)
end
function kingdomSettingAPI:canChatInAlliance()
	return self:checkCastleLevelLimit(gKingdomSettingKey.NEED_CASTLE_LEVEL_ALLIANCE_CHAT)
end
function kingdomSettingAPI:canChatInWorld()
	return self:checkCastleLevelLimit(gKingdomSettingKey.NEED_CASTLE_LEVEL_WORLD_CHAT)
end
function kingdomSettingAPI:canLeaveMsgInAlliance()
	return self:canChatInWorld()
end
function kingdomSettingAPI:canUseKingdomBugle()
	return self:canChatInWorld()
end
function kingdomSettingAPI:isAutoTranslateSwitchOn()
	local gametop = gModuleMgr.getObject("gametop")
	local settingCtrl = gametop.playertop_:getModule("settingCtrl")
	local status = settingCtrl:getKingdomSetting(gKingdomSettingKey.AUTO_TRANSLATE_SWITCH)
	if nil == status then
		return true
	end
	if gStatus.OPEN == status then
		return true
	end
	return false
end
function kingdomSettingAPI:randomTrueOrFalse()
	local n = math.random(1, 2)
	if 1 == n then
		return true
	else
		return false
	end
end
function kingdomSettingAPI:getCastleLevel()
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	return cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
end
function kingdomSettingAPI:checkCastleLevelLimit(key)
	local gametop = gModuleMgr.getObject("gametop")
	local settingCtrl = gametop.playertop_:getModule("settingCtrl")
	local setting = settingCtrl:getKingdomSetting(key)
	if not setting then
		return true
	end
	setting = setting or 1
	local castleLevel = self:getCastleLevel()
	if "number" ~= type(castleLevel) then
		return false, setting
	end
	if setting <= castleLevel then
		return true
	end
	return false, setting
end
return kingdomSettingAPI
