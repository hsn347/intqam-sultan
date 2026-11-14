_UPVALUE7_, CreatEnumTable = function(tbl, index)
	local _ENV, enumtbl
	local enumindex = index or 0
	for i, v in ipairs(tbl) do
		enumtbl[v] = enumindex + i - 1
	end
	return enumtbl
end, function(tbl, index)
	local _ENV, enumtbl
	local enumindex = index or 0
	for i, v in ipairs(tbl) do
		enumtbl[v] = enumindex + i - 1
	end
	return enumtbl
end
Plugin_type, (function(tbl, index)
	local _ENV, enumtbl
	local enumindex = index or 0
	for i, v in ipairs(tbl) do
		enumtbl[v] = enumindex + i - 1
	end
	return enumtbl
end)[1] = function(tbl, index)
	local _ENV, enumtbl
	local enumindex = index or 0
	for i, v in ipairs(tbl) do
		enumtbl[v] = enumindex + i - 1
	end
	return enumtbl
end, "kPluginAds"
Plugin_type, (function(tbl, index)
	local _ENV, enumtbl
	local enumindex = index or 0
	for i, v in ipairs(tbl) do
		enumtbl[v] = enumindex + i - 1
	end
	return enumtbl
end)[2] = function(tbl, index)
	local _ENV, enumtbl
	local enumindex = index or 0
	for i, v in ipairs(tbl) do
		enumtbl[v] = enumindex + i - 1
	end
	return enumtbl
end, "kPluginAnalytics"
Plugin_type, (function(tbl, index)
	local _ENV, enumtbl
	local enumindex = index or 0
	for i, v in ipairs(tbl) do
		enumtbl[v] = enumindex + i - 1
	end
	return enumtbl
end)[3] = function(tbl, index)
	local _ENV, enumtbl
	local enumindex = index or 0
	for i, v in ipairs(tbl) do
		enumtbl[v] = enumindex + i - 1
	end
	return enumtbl
end, "kPluginIAP"
Plugin_type, (function(tbl, index)
	local _ENV, enumtbl
	local enumindex = index or 0
	for i, v in ipairs(tbl) do
		enumtbl[v] = enumindex + i - 1
	end
	return enumtbl
end)[4] = function(tbl, index)
	local _ENV, enumtbl
	local enumindex = index or 0
	for i, v in ipairs(tbl) do
		enumtbl[v] = enumindex + i - 1
	end
	return enumtbl
end, "kPluginShare"
Plugin_type, (function(tbl, index)
	local _ENV, enumtbl
	local enumindex = index or 0
	for i, v in ipairs(tbl) do
		enumtbl[v] = enumindex + i - 1
	end
	return enumtbl
end)[5] = function(tbl, index)
	local _ENV, enumtbl
	local enumindex = index or 0
	for i, v in ipairs(tbl) do
		enumtbl[v] = enumindex + i - 1
	end
	return enumtbl
end, "kPluginUser"
Plugin_type, (function(tbl, index)
	local _ENV, enumtbl
	local enumindex = index or 0
	for i, v in ipairs(tbl) do
		enumtbl[v] = enumindex + i - 1
	end
	return enumtbl
end)[6] = function(tbl, index)
	local _ENV, enumtbl
	local enumindex = index or 0
	for i, v in ipairs(tbl) do
		enumtbl[v] = enumindex + i - 1
	end
	return enumtbl
end, "kPluginSocial"
Plugin_type, (function(tbl, index)
	local _ENV, enumtbl
	local enumindex = index or 0
	for i, v in ipairs(tbl) do
		enumtbl[v] = enumindex + i - 1
	end
	return enumtbl
end)[7] = function(tbl, index)
	local _ENV, enumtbl
	local enumindex = index or 0
	for i, v in ipairs(tbl) do
		enumtbl[v] = enumindex + i - 1
	end
	return enumtbl
end, "kPluginPush"
_UPVALUE8_, Plugin_type = CreatEnumTable(Plugin_type, 1), CreatEnumTable(Plugin_type, 1)
AdsResultCode, CreatEnumTable(Plugin_type, 1)[1] = CreatEnumTable(Plugin_type, 1), "kAdsReceived"
AdsResultCode, CreatEnumTable(Plugin_type, 1)[2] = CreatEnumTable(Plugin_type, 1), "kAdsShown"
AdsResultCode, CreatEnumTable(Plugin_type, 1)[3] = CreatEnumTable(Plugin_type, 1), "kAdsDismissed"
AdsResultCode, CreatEnumTable(Plugin_type, 1)[4] = CreatEnumTable(Plugin_type, 1), "kPointsSpendSucceed"
AdsResultCode, CreatEnumTable(Plugin_type, 1)[5] = CreatEnumTable(Plugin_type, 1), "kPointsSpendFailed"
AdsResultCode, CreatEnumTable(Plugin_type, 1)[6] = CreatEnumTable(Plugin_type, 1), "kNetworkError"
AdsResultCode, CreatEnumTable(Plugin_type, 1)[7] = CreatEnumTable(Plugin_type, 1), "kUnknownError"
AdsResultCode, CreatEnumTable(Plugin_type, 1)[8] = CreatEnumTable(Plugin_type, 1), "kOfferWallOnPointsChanged"
_UPVALUE7_, AdsResultCode = CreatEnumTable(AdsResultCode, 0), CreatEnumTable(AdsResultCode, 0)
AdsPos, CreatEnumTable(AdsResultCode, 0)[1] = CreatEnumTable(AdsResultCode, 0), "kPosCenter"
AdsPos, CreatEnumTable(AdsResultCode, 0)[2] = CreatEnumTable(AdsResultCode, 0), "kPosTop"
AdsPos, CreatEnumTable(AdsResultCode, 0)[3] = CreatEnumTable(AdsResultCode, 0), "kPosTopLeft"
AdsPos, CreatEnumTable(AdsResultCode, 0)[4] = CreatEnumTable(AdsResultCode, 0), "kPosTopRight"
AdsPos, CreatEnumTable(AdsResultCode, 0)[5] = CreatEnumTable(AdsResultCode, 0), "kPosBottom"
AdsPos, CreatEnumTable(AdsResultCode, 0)[6] = CreatEnumTable(AdsResultCode, 0), "kPosBottomLeft"
AdsPos, CreatEnumTable(AdsResultCode, 0)[7] = CreatEnumTable(AdsResultCode, 0), "kPosBottomRight"
_UPVALUE4_, AdsPos = CreatEnumTable(AdsPos, 0), CreatEnumTable(AdsPos, 0)
AdsType, CreatEnumTable(AdsPos, 0)[1] = CreatEnumTable(AdsPos, 0), "AD_TYPE_BANNER"
AdsType, CreatEnumTable(AdsPos, 0)[2] = CreatEnumTable(AdsPos, 0), "AD_TYPE_FULLSCREEN"
AdsType, CreatEnumTable(AdsPos, 0)[3] = CreatEnumTable(AdsPos, 0), "AD_TYPE_MOREAPP"
AdsType, CreatEnumTable(AdsPos, 0)[4] = CreatEnumTable(AdsPos, 0), "AD_TYPE_OFFERWALL"
_UPVALUE8_, AdsType = CreatEnumTable(AdsType, 0), CreatEnumTable(AdsType, 0)
PayResultCode, CreatEnumTable(AdsType, 0)[1] = CreatEnumTable(AdsType, 0), "kPaySuccess"
PayResultCode, CreatEnumTable(AdsType, 0)[2] = CreatEnumTable(AdsType, 0), "kPayFail"
PayResultCode, CreatEnumTable(AdsType, 0)[3] = CreatEnumTable(AdsType, 0), "kPayCancel"
PayResultCode, CreatEnumTable(AdsType, 0)[4] = CreatEnumTable(AdsType, 0), "kPayNetworkError"
PayResultCode, CreatEnumTable(AdsType, 0)[5] = CreatEnumTable(AdsType, 0), "kPayProductionInforIncomplete"
PayResultCode, CreatEnumTable(AdsType, 0)[6] = CreatEnumTable(AdsType, 0), "kPayInitSuccess"
PayResultCode, CreatEnumTable(AdsType, 0)[7] = CreatEnumTable(AdsType, 0), "kPayInitFail"
PayResultCode, CreatEnumTable(AdsType, 0)[8] = CreatEnumTable(AdsType, 0), "kPayNowPaying"
_UPVALUE1_, PayResultCode = CreatEnumTable(PayResultCode, 0), CreatEnumTable(PayResultCode, 0)
PushActionResultCode, CreatEnumTable(PayResultCode, 0)[1] = CreatEnumTable(PayResultCode, 0), "kPushReceiveMessage"
_UPVALUE4_, PushActionResultCode = CreatEnumTable(PushActionResultCode, 0), CreatEnumTable(PushActionResultCode, 0)
ShareResultCode, CreatEnumTable(PushActionResultCode, 0)[1] = CreatEnumTable(PushActionResultCode, 0), "kShareSuccess"
ShareResultCode, CreatEnumTable(PushActionResultCode, 0)[2] = CreatEnumTable(PushActionResultCode, 0), "kShareFail"
ShareResultCode, CreatEnumTable(PushActionResultCode, 0)[3] = CreatEnumTable(PushActionResultCode, 0), "kShareCancel"
ShareResultCode, CreatEnumTable(PushActionResultCode, 0)[4] = CreatEnumTable(PushActionResultCode, 0), "kShareNetworkError"
_UPVALUE8_, ShareResultCode = CreatEnumTable(ShareResultCode, 0), CreatEnumTable(ShareResultCode, 0)
SocialRetCode, CreatEnumTable(ShareResultCode, 0)[1] = CreatEnumTable(ShareResultCode, 0), "kScoreSubmitSucceed"
SocialRetCode, CreatEnumTable(ShareResultCode, 0)[2] = CreatEnumTable(ShareResultCode, 0), "kScoreSubmitfail"
SocialRetCode, CreatEnumTable(ShareResultCode, 0)[3] = CreatEnumTable(ShareResultCode, 0), "kAchUnlockSucceed"
SocialRetCode, CreatEnumTable(ShareResultCode, 0)[4] = CreatEnumTable(ShareResultCode, 0), "kAchUnlockFail"
SocialRetCode, CreatEnumTable(ShareResultCode, 0)[5] = CreatEnumTable(ShareResultCode, 0), "kSocialSignInSucceed"
SocialRetCode, CreatEnumTable(ShareResultCode, 0)[6] = CreatEnumTable(ShareResultCode, 0), "kSocialSignInFail"
SocialRetCode, CreatEnumTable(ShareResultCode, 0)[7] = CreatEnumTable(ShareResultCode, 0), "kSocialSignOutSucceed"
SocialRetCode, CreatEnumTable(ShareResultCode, 0)[8] = CreatEnumTable(ShareResultCode, 0), "kSocialSignOutFail"
_UPVALUE17_, SocialRetCode = CreatEnumTable(SocialRetCode, 1), CreatEnumTable(SocialRetCode, 1)
UserActionResultCode, CreatEnumTable(SocialRetCode, 1)[1] = CreatEnumTable(SocialRetCode, 1), "kInitSuccess"
UserActionResultCode, CreatEnumTable(SocialRetCode, 1)[2] = CreatEnumTable(SocialRetCode, 1), "kInitFail"
UserActionResultCode, CreatEnumTable(SocialRetCode, 1)[3] = CreatEnumTable(SocialRetCode, 1), "kLoginSuccess"
UserActionResultCode, CreatEnumTable(SocialRetCode, 1)[4] = CreatEnumTable(SocialRetCode, 1), "kLoginNetworkError"
UserActionResultCode, CreatEnumTable(SocialRetCode, 1)[5] = CreatEnumTable(SocialRetCode, 1), "kLoginNoNeed"
UserActionResultCode, CreatEnumTable(SocialRetCode, 1)[6] = CreatEnumTable(SocialRetCode, 1), "kLoginFail"
UserActionResultCode, CreatEnumTable(SocialRetCode, 1)[7] = CreatEnumTable(SocialRetCode, 1), "kLoginCancel"
UserActionResultCode, CreatEnumTable(SocialRetCode, 1)[8] = CreatEnumTable(SocialRetCode, 1), "kLogoutSuccess"
UserActionResultCode, CreatEnumTable(SocialRetCode, 1)[9] = CreatEnumTable(SocialRetCode, 1), "kLogoutFail"
UserActionResultCode, CreatEnumTable(SocialRetCode, 1)[10] = CreatEnumTable(SocialRetCode, 1), "kPlatformEnter"
UserActionResultCode, CreatEnumTable(SocialRetCode, 1)[11] = CreatEnumTable(SocialRetCode, 1), "kPlatformBack"
UserActionResultCode, CreatEnumTable(SocialRetCode, 1)[12] = CreatEnumTable(SocialRetCode, 1), "kPausePage"
UserActionResultCode, CreatEnumTable(SocialRetCode, 1)[13] = CreatEnumTable(SocialRetCode, 1), "kExitPage"
UserActionResultCode, CreatEnumTable(SocialRetCode, 1)[14] = CreatEnumTable(SocialRetCode, 1), "kAntiAddictionQuery"
UserActionResultCode, CreatEnumTable(SocialRetCode, 1)[15] = CreatEnumTable(SocialRetCode, 1), "kRealNameRegister"
UserActionResultCode, CreatEnumTable(SocialRetCode, 1)[16] = CreatEnumTable(SocialRetCode, 1), "kAccountSwitchSuccess"
UserActionResultCode, CreatEnumTable(SocialRetCode, 1)[17] = CreatEnumTable(SocialRetCode, 1), "kAccountSwitchFail"
_UPVALUE6_, UserActionResultCode = CreatEnumTable(UserActionResultCode, 0), CreatEnumTable(UserActionResultCode, 0)
ToolBarPlace, CreatEnumTable(UserActionResultCode, 0)[1] = CreatEnumTable(UserActionResultCode, 0), "kToolBarTopLeft"
ToolBarPlace, CreatEnumTable(UserActionResultCode, 0)[2] = CreatEnumTable(UserActionResultCode, 0), "kToolBarTopRight"
ToolBarPlace, CreatEnumTable(UserActionResultCode, 0)[3] = CreatEnumTable(UserActionResultCode, 0), "kToolBarMidLeft"
ToolBarPlace, CreatEnumTable(UserActionResultCode, 0)[4] = CreatEnumTable(UserActionResultCode, 0), "kToolBarMidRight"
ToolBarPlace, CreatEnumTable(UserActionResultCode, 0)[5] = CreatEnumTable(UserActionResultCode, 0), "kToolBarBottomLeft"
ToolBarPlace, CreatEnumTable(UserActionResultCode, 0)[6] = CreatEnumTable(UserActionResultCode, 0), "kToolBarBottomRight"
ToolBarPlace = CreatEnumTable(ToolBarPlace, 1)
