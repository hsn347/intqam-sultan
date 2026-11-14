local _ENV, _ENV, declaredNames
;(nil).SoraDTimerManager = true
;(nil).app = true
;(nil).dump = true
;(nil).qaDump = true
;(nil).AudioEngine = true
;(nil).gItemAwardCaches = true
;(nil).g_is_preparedFont = true
;(nil).gIsReviewGameSever = true
;(nil).gWebCallGameSeverIP = true
;(nil).gPetZ = true
;(nil).lua_extension = true
;(nil)._gBeginingRenderTexture = true
;(nil).gNebulaPalaceItemID = true
;(nil)._VoiceChatSDKManagerInstance = true
;(nil)._uiDequeInstance = true
;(nil).gEnableWorldMap3D = true
;(nil).capi_update_abort = true
;(nil).ng_sys_abort = true
;(nil).capi_update_getIsUpdateReload = true
;(nil).capi_update_setPath = true
;(nil).buff_noDispathchAll = true
;(nil).GLOBAL_BUILD_PRE_BID = true
;(nil).g_is_divinebeast_test_on = true
;(nil)._returnQueueIdList = true
;(nil).gAtlantisUseSkillEffect = true
;(nil).ng_sys_setPath = true
;(nil).ng_sys_getIsOpen = true
local (nil).ng_sys_getVersion, ignoreMap = true, nil
_ENV = nil
;(nil).__newindex = function(t, n, v)
	if not declaredNames[n] then
		local w = debug.getinfo(2, "S").what
		if w ~= "main" and w ~= "C" and not ignoreMap[n] then
			printError("==在非主程序块对全局变量赋值,报给客户端==" .. ", key = " .. n .. ", what = " .. w)
		end
		declaredNames[n] = true
	end
	rawset(t, n, v)
end
;(nil).__index = function(_, n)
	if not declaredNames[n] then
		local w = debug.getinfo(2, "S").what
		if w ~= "main" and w ~= "C" and not ignoreMap[n] then
			printError("==访问了未声明的全局变量,报给客户端==" .. ", key = " .. n .. ", what = " .. w)
		end
		declaredNames[n] = true
	end
end
setmetatable(_G, nil)
