local ltBase = include("ltBase")
local rechargeExtraltCtrl = class("rechargeExtraltCtrl", ltBase, include("aAReadClass").new())
local gExtraGiftIDDef = gExtraGiftIDDef
function rechargeExtraltCtrl:ctor()
	rechargeExtraltCtrl.super.ctor(self)
	self:init()
end
function rechargeExtraltCtrl:init()
	self._extraRechargeData, _ENV = nil, nil
	self._language = GameLanguageCopy
	self._textIndex = 0
	print("rechargeExtraltCtrl language", self._language)
end
function rechargeExtraltCtrl:generateCommonIndex()
	local commonKey = "rechargeExtraText_"
	self._textIndex = self._textIndex + 1
	return commonKey .. tostring(self._textIndex)
end
function rechargeExtraltCtrl:transferLanguage(value)
	local key = self:generateCommonIndex()
	print("transferLanguage ,key/value", key, value)
	if value then
		i18n.set(key, value)
		print("i18key", i18n(key))
	else
		print("transferLanguage is nil")
	end
	return key
end
function rechargeExtraltCtrl:resetData()
	self:init()
end
function rechargeExtraltCtrl:getRightLanguage(jsonData)
	local tmpName = json.decode(jsonData)
	if tmpName then
		dump(tmpName, "getRightLanguage", 10)
		local ret = tmpName[self._language]
		return ret
	end
	return nil
end
function rechargeExtraltCtrl:saveLanguageData(extraData)
	local tmpTab = json.decode(extraData.activeName)
	local value
	if type(tmpTab) == "table" then
		value = tmpTab[self._language]
	end
	extraData.activeName = self:transferLanguage(value)
	value = nil
	tmpTab = json.decode(extraData.activeDesc)
	if type(tmpTab) == "table" then
		value = tmpTab[self._language]
	end
	extraData.activeDesc = self:transferLanguage(value)
	return extraData
end
function rechargeExtraltCtrl:addExtraData(data)
	local data = clone(data)
	local ID = data.ID or 0
	local luckyGiftID = data.luckyGiftID or 0
	local realID = 0
	if 0 < ID then
		realID = ID
	elseif 0 < luckyGiftID then
		realID = luckyGiftID
	end
	if not self._extraRechargeData[tostring(realID)] then
		data = self:saveLanguageData(data)
	elseif self._extraRechargeData[tostring(realID)].activeName == i18n(self._extraRechargeData[tostring(realID)].activeName) then
		data = self:saveLanguageData(data)
		print("extra language  is invalid,reset")
	else
		print("extra language  is exist", realID, self._extraRechargeData[tostring(realID)].activeName, self._extraRechargeData[tostring(realID)].activeDesc)
		data.activeName = self._extraRechargeData[tostring(realID)].activeName
		data.activeDesc = self._extraRechargeData[tostring(realID)].activeDesc
	end
	print("rechargeExtraltCtrl:addExtraData", ID, luckyGiftID)
	if realID >= gExtraGiftIDDef.LADDER_GIFT_BEGIN and realID <= gExtraGiftIDDef.NORMAL_GIFT_END then
		self._extraRechargeData[tostring(realID)] = data
	elseif realID >= gExtraGiftIDDef.LUCKY_GIFT_BEGIN and realID <= gExtraGiftIDDef.LUCKY_GIFT_END then
		self._extraRechargeData[tostring(realID)] = data
	else
		print("rechargeExtraltCtrl:addExtraData,ID ERROR", ID)
	end
	print("GameLanguageCopy language", GameLanguageCopy)
	return true
end
function rechargeExtraltCtrl.getCenterCategoryByID(id)
	if id >= gExtraGiftIDDef.LADDER_GIFT_BEGIN and id <= gExtraGiftIDDef.LADDER_GIFT_END then
		return gRechargeCenterCategory.LADDERGIFT
	elseif id >= gExtraGiftIDDef.NORMAL_GIFT_BEGIN and id <= gExtraGiftIDDef.NORMAL_GIFT_END then
		return gRechargeCenterCategory.LIMITGIFT
	elseif id >= gExtraGiftIDDef.LUCKY_GIFT_BEGIN and id <= gExtraGiftIDDef.LUCKY_GIFT_END then
		return gRechargeCenterCategory.HOTGIFT
	end
end
function rechargeExtraltCtrl:isExtraGift(giftID)
	local ID = giftID or 0
	if ID >= gExtraGiftIDDef.LADDER_GIFT_BEGIN and ID <= gExtraGiftIDDef.LUCKY_GIFT_END then
		return true
	else
		return false
	end
end
function rechargeExtraltCtrl:getGiftDataByID(rid)
	local data = self._extraRechargeData[tostring(rid)]
	if data then
		return true, data
	else
		return false, nil
	end
end
function rechargeExtraltCtrl:getGiftPageViewDataByID(rid)
	local ret
	local data = self._extraRechargeData[tostring(rid)]
	if data then
		ret, _ENV = tostring(rid), tostring(rid)
		print("getGiftPageViewDataByID", i18n(data.activeName))
		gExtraGiftIDDef = print
		ret.activeName, print[1] = print, data.activeName
		ret.activeExplain = data.activeDesc
		ret.activeDesc = ""
		if tonumber(rid) >= gExtraGiftIDDef.LADDER_GIFT_BEGIN and tonumber(rid) <= gExtraGiftIDDef.NORMAL_GIFT_END then
			ret.activeModelType = 1
		elseif tonumber(rid) >= gExtraGiftIDDef.LUCKY_GIFT_BEGIN and tonumber(rid) <= gExtraGiftIDDef.LUCKY_GIFT_END then
			ret.activeModelType = 4
		else
			ret.activeModelType = 0
		end
		ret.popBanner = data.popBanner
		ret.activeBg = data.activeBg
		ret.tinyBg = data.tinyBg
		ret.eventType = data.eventType
		ret.hideTime = data.hideTime
	end
	dump(ret, "ret pageview", 10)
	return ret
end
function rechargeExtraltCtrl:getRechargeClientCfgDataByID(rid)
	local ret
	local data = self._extraRechargeData[tostring(rid)]
	if data then
		ret, _ENV = tostring(rid), tostring(rid)
		ret.pid = data.pidindex
		ret.isActive = data.isActive
		ret.device = data.device
	end
	return ret
end
function rechargeExtraltCtrl:getRidByPid(pid)
	for k, v in pairs(self._extraRechargeData) do
		if v.pid == pid then
			return k
		end
	end
	return nil
end
return rechargeExtraltCtrl
