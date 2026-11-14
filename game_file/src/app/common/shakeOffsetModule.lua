local _shakeOffsetModuleInstance
shakeOffsetModule = class("shakeOffsetModule")
function shakeOffsetModule:getInstance()
	if _shakeOffsetModuleInstance == nil then
	end
	return _shakeOffsetModuleInstance
end
function shakeOffsetModule:ctor()
	self:clean()
end
function shakeOffsetModule:startTimer()
	local timerManager = require("framework.timer.timerManager")
	local timer = timerManager:getTimer(0, function(dt)
		self:update(dt)
	end)
	timer:start()
	self.__timer = timer
end
function shakeOffsetModule:run(...)
	if self.__timer then
		self.__timer:resume()
	else
		self:startTimer()
	end
end
function shakeOffsetModule:createShackPanel()
	local panel = cc.Layer:create()
	panel:setName("Panel_Global_physicsShackNode")
	panel:addTo(display.getRunningScene().panelView)
	return panel
end
function shakeOffsetModule:getShackPanel(...)
	if display.getRunningScene() then
		local parent = display.getRunningScene().panelView
		if parent then
			local panel = parent:getChildByName("Panel_Global_physicsShackNode")
			if panel then
				return panel
			else
				return self:createShackPanel()
			end
		end
	end
end
local fun_getAcceleration = CS.Sultan.Middleware.Acceleration.getAcceleration
function shakeOffsetModule:update(dt)
	local acc = fun_getAcceleration()
	local this
	self:caculateShack(this, acc.x, acc.y, acc.z, SoraDGetSocketTime())
end
function shakeOffsetModule:setAccelerometerInterval(num)
end
function shakeOffsetModule:stop(...)
	if self.__timer then
		self.__timer:pause()
	end
end
function shakeOffsetModule:destroy()
	print("shakeOffsetModule:destroy")
	if self.__timer then
		self.__timer:stop()
		self.__timer = nil
	end
end
function shakeOffsetModule:checkAndClean(funName)
	for k, v in pairs(self.callBackList) do
		if v.name == funName then
			self.callBackList[k] = nil
			break
		end
	end
end
function shakeOffsetModule:addHandl(handl, funName)
	self:checkAndClean(funName)
	_ENV = funName
	funName.fun = handl
	funName.name = funName
	table.insert(self.callBackList, funName)
	self:run()
end
function shakeOffsetModule:delHandl(funName)
	print("funName=", funName)
	for k, v in pairs(self.callBackList) do
		if v.name == funName then
			table.remove(self.callBackList, k)
			break
		end
	end
	if not self.callBackList or not next(self.callBackList) then
		self:stop()
	end
end
function shakeOffsetModule:caculateShack(acc, x, y, z, timestamp)
	if self.callBackList and next(self.callBackList) then
		for _, v in pairs(self.callBackList) do
			if v then
				v.fun(acc, x * 1000, y * 1000, z * 1000, timestamp)
			end
		end
	else
		self:stop()
	end
end
function shakeOffsetModule:clean()
	self.callBackList, _UPVALUE0_ = nil, nil
end
