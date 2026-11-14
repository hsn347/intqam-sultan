facebookFriendModule, _ENV = nil, nil
facebookFriendModule.ios, _ENV = nil, nil
facebookFriendModule.android, _ENV = nil, nil
function facebookFriendModule.init(...)
end
function facebookFriendModule.getJoinedFriends(...)
end
function facebookFriendModule.authorize4FB(...)
end
function facebookFriendModule.call4HelpFB(_msg, _ids)
end
function facebookFriendModule.getFBAllFriends(isNext)
end
function facebookFriendModule.onEnterForeground(...)
	_ENV = nil
	;(nil).msg = "MESSAGE_FACEBOOK_FLAGBACK_TREASUREREAUTHORIZE"
	SoraDSendMessage(nil)
end
function facebookFriendModule.recordInfo(tbl)
	_ENV = nil
	;(nil).type = tbl.type
	;(nil).chestlv = tbl.chestlv
	;(nil).chestsc = tbl.chestsc
	;(nil).chestscMax = tbl.chestscMax
	;(nil).ouid = tbl.ouid
	userSDKManager.logEvent(gSDKDef.TDonEvent.facebook_treasure_log, nil)
end
function facebookFriendModule.android.init(...)
end
function facebookFriendModule.ios.init(...)
	print("注册这些回调函数")
	_ENV = nil
	;(nil).funcJoinedFri = FacebookFriendModule_IOS_BackJoinedFriends
	;(nil).funcAllFri = FacebookFriendModule_IOS_BackAllFriends
	;(nil).funcNextFri = FacebookFriendModule_IOS_BackAllNextFriends
	;(nil).funcAuthorizeorBind = FacebookFriendModule_IOS_AuthorizeorBindBack
	luaoc.callStaticMethod("NCSGameCenter", "registFacebookCallBackFunc", nil)
end
function facebookFriendModule.android.getJoinedFriends(...)
	local javaClassName = "org/cocos2dx/lua/AchievementModule"
	local javaMethodName = "getFBJoinedFriends"
	local javaMethodSig = "()V"
	luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
end
function FacebookFriendModule_Android_BackJoinedFriends(args)
	_ENV = nil
	;(nil).msg = "MESSAGE_FACEBOOK_FLAGBACK_MSGARRIVED"
	;(nil).redata = args
	SoraDSendMessage(nil)
end
function FacebookFriendModule_IOS_BackJoinedFriends(args)
	_ENV = nil
	;(nil).msg = "MESSAGE_FACEBOOK_FLAGBACK_MSGARRIVED"
	;(nil).redata = args
	SoraDSendMessage(nil)
end
function facebookFriendModule.ios.getJoinedFriends(...)
	local ok, ret = luaoc.callStaticMethod("NCSGameCenter", "getFBJoinedFriends", nil)
end
function FacebookFriendModule_IOS_AuthorizeorBindBack(...)
	facebookFriendModule.onEnterForeground()
end
function facebookFriendModule.android.authorize4FB(...)
	local javaClassName = "org/cocos2dx/lua/AchievementModule"
	local javaMethodName = "authorize4FB"
	local javaMethodSig = "()V"
	luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
end
function facebookFriendModule.ios.authorize4FB(...)
	local ok, ret = luaoc.callStaticMethod("NCSGameCenter", "authorize4FB", nil)
end
function facebookFriendModule.android.call4HelpFB(_msg, _ids)
	local javaClassName = "org/cocos2dx/lua/AchievementModule"
	local javaMethodName = "call4HelpFB"
	_UPVALUE2_ = nil
	;(nil)[1] = "" .. _msg
	local (nil)[2], javaParams = "" .. _ids, nil
	local javaMethodSig = "(Ljava/lang/String;Ljava/lang/String;)V"
	luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
end
function facebookFriendModule.ios.call4HelpFB(_msg, _ids)
	_ENV = nil
	;(nil).message = _msg
	local (nil).friendsList, param = _ids, nil
	local ok, ret = luaoc.callStaticMethod("NCSGameCenter", "call4HelpFB", param)
end
function facebookFriendModule.android.getFBAllFriends(isNext)
	if isNext then
		local javaClassName = "org/cocos2dx/lua/AchievementModule"
		local javaMethodName = "getFBNextFriends"
		local javaMethodSig = "()V"
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
	else
		local javaClassName = "org/cocos2dx/lua/AchievementModule"
		local javaMethodName = "getFBAllFriends"
		local javaMethodSig = "()V"
		luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig)
	end
end
function FacebookFriendModule_Android_BackAllFriends(args)
	_ENV = nil
	;(nil).msg = "MESSAGE_FACEBOOK_FLAGBACK_ALLFRIENDS"
	;(nil).redata = args
	SoraDSendMessage(nil)
end
function FacebookFriendModule_Android_BackAllNextFriends(args)
	_ENV = nil
	;(nil).msg = "MESSAGE_FACEBOOK_FLAGBACK_ALLNEXTFRIENDS"
	;(nil).redata = args
	SoraDSendMessage(nil)
end
function FacebookFriendModule_IOS_BackAllFriends(args)
	_ENV = nil
	;(nil).msg = "MESSAGE_FACEBOOK_FLAGBACK_ALLFRIENDS"
	;(nil).redata = args
	SoraDSendMessage(nil)
end
function FacebookFriendModule_IOS_BackAllNextFriends(args)
	_ENV = nil
	;(nil).msg = "MESSAGE_FACEBOOK_FLAGBACK_ALLNEXTFRIENDS"
	;(nil).redata = args
	SoraDSendMessage(nil)
end
function facebookFriendModule.ios.getFBAllFriends(isNext)
	if isNext then
		local ok, ret = luaoc.callStaticMethod("NCSGameCenter", "getFBNextFriends", nil)
	else
		local ok, ret = luaoc.callStaticMethod("NCSGameCenter", "getFBAllFriends", nil)
	end
end
