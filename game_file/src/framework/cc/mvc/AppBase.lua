local AppBase = class("AppBase")
AppBase.APP_ENTER_BACKGROUND_EVENT = "APP_ENTER_BACKGROUND_EVENT"
AppBase.APP_ENTER_FOREGROUND_EVENT = "APP_ENTER_FOREGROUND_EVENT"
function AppBase:ctor(appName, packageRoot)
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
	self.name = appName
	self.packageRoot = packageRoot or "app"
	local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
	local customListenerBg = cc.EventListenerCustom:create(AppBase.APP_ENTER_BACKGROUND_EVENT, handler(self, self.onEnterBackground))
	eventDispatcher:addEventListenerWithFixedPriority(customListenerBg, 1)
	local customListenerFg = cc.EventListenerCustom:create(AppBase.APP_ENTER_FOREGROUND_EVENT, handler(self, self.onEnterForeground))
	eventDispatcher:addEventListenerWithFixedPriority(customListenerFg, 1)
	self.snapshots_, _ENV = eventDispatcher.addEventListenerWithFixedPriority, eventDispatcher.addEventListenerWithFixedPriority
	app = self
end
function AppBase:run()
end
function AppBase:exit()
	cc.Director:getInstance():endToLua()
	cc.Director:getInstance():quitGame()
end
function AppBase:enterScene(sceneName, args, transitionType, time, more)
	local scenePackageName = self.packageRoot .. ".scenes." .. sceneName
	local sceneClass = require(scenePackageName)
	local scene = sceneClass.new(unpack(checktable(args)))
	display.replaceScene(scene, transitionType, time, more)
end
function AppBase:createView(viewName, ...)
	local viewPackageName = self.packageRoot .. ".views." .. viewName
	local viewClass = require(viewPackageName)
	return viewClass.new(...)
end
function AppBase:onEnterBackground()
	AppBase = nil
	;(nil).name = AppBase.APP_ENTER_BACKGROUND_EVENT
	self:dispatchEvent(nil)
end
function AppBase:onEnterForeground()
	AppBase = nil
	;(nil).name = AppBase.APP_ENTER_FOREGROUND_EVENT
	self:dispatchEvent(nil)
end
function AppOnEnterBackground()
	app:onEnterBackground()
end
function AppOnEnterForeground()
	app:onEnterForeground()
end
return AppBase
