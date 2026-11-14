local DirectorEx = cc.Director
function DirectorEx:getEventDispatcher()
	if not self.__eventDispatcher then
		local EventDispatcher = require("midware.cocos2d.Event.EventDispatcher")
		self.__eventDispatcher = EventDispatcher.new()
		print("new EventDispatcher")
	end
	print("return EventDispatcher")
	return self.__eventDispatcher
end
function DirectorEx:getScheduler()
	if not self.__scheduler then
		self.__scheduler = cc.Scheduler.new()
		self.__scheduler:startTimer()
	end
	return self.__scheduler
end
function DirectorEx:getConsole()
	local instance = CS.Sultan.Core.Console.GetInstance()
	if not instance.addCommand then
		function instance.addCommand()
			print("console 未实现")
		end
	end
	return instance
end
function DirectorEx:setProjection()
	print_warn("暂不处理 DirectorEx:setProjection")
end
function DirectorEx:isDisplayStats(isMem)
	if isMem then
		local Profile = CS.Sultan.Core.ProfileMem
		return Profile.isShow()
	end
	local Profile = CS.Sultan.Core.Profile
	return Profile.isShow()
end
function DirectorEx:setDisplayStats(isShow)
	local Profile = CS.Sultan.Core.Profile
	if isShow then
		Profile.Show()
	else
		Profile.Hiden()
	end
end
function DirectorEx:setDisplayMemStats(isShow)
	local Profile = CS.Sultan.Core.ProfileMem
	if isShow then
		Profile.Show()
	else
		Profile.Hiden()
	end
end
