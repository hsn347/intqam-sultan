local worldMapComUtil = class("worldMapComUtil", include("worldMapCom"))
function worldMapComUtil:ctor()
	worldMapComUtil.super.ctor(self, "worldMapComUtil")
end
function worldMapComUtil:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_LUA_WILL_OPEN", handler(self, self.willOpen))
end
function worldMapComUtil:willOpen(target, data)
	local instanceCacheMgr = include("instanceCacheMgr")
	instanceCacheMgr.clearCache()
end
function worldMapComUtil:onEnter()
end
function worldMapComUtil:onExit()
	worldMapComUtil.super.onExit(self)
end
function worldMapComUtil:exportMethods()
	return self.target_
end
return worldMapComUtil
