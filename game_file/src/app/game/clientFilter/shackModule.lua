ShackModule, _ENV = nil, nil
function ShackModule.load(...)
	ShackModule.enableShack = true
	ShackModule.shackInterval = 2
	ShackModule.shackSensitivity = 700
	if device.platform == "android" then
		ShackModule.shackSensitivity = 700
	elseif device.platform == "ios" then
		ShackModule.shackSensitivity = 700
	end
	SoraDAddShakeOffsetHandl(ShackModule.judgeShack, "ShackModule")
	ShackModule.isLoaded = true
end
function ShackModule.unload(...)
	SoraDDelShakeOffsetHandl("ShackModule")
	ShackModule.enableShack = false
	ShackModule.isLoaded = nil
	ShackModule.extCallBackTbl = nil
end
function ShackModule.checkAndClean(funName)
	for k, v in pairs(ShackModule.extCallBackTbl) do
		if v.name == funName then
			table.remove(ShackModule.extCallBackTbl, k)
			break
		end
	end
end
function ShackModule.init(handl, funName)
	if ShackModule.extCallBackTbl then
		ShackModule.checkAndClean(funName)
		_ENV = nil
		;(nil).fun = handl
		;(nil).name = funName
		table.insert(ShackModule.extCallBackTbl, 1, nil)
	else
		_ENV, _UPVALUE1_ = 1, ShackModule.extCallBackTbl
		;(1).fun = handl
		;(1).name = funName
		ShackModule.extCallBackTbl, ShackModule.extCallBackTbl[1] = ShackModule.extCallBackTbl, 1
	end
	if not ShackModule.isLoaded then
		ShackModule.load()
	end
end
function ShackModule.judgeShack(acc, x, y, z, timestemp)
	if ShackModule.enableShack then
		x, y, z = x / 1000, y / 1000, z / 1000
		if not ShackModule.isFirstinit then
			ShackModule.mLastSx = x
			ShackModule.mLastSy = y
			ShackModule.mLastSz = z
			ShackModule.isFirstinit = true
			ShackModule.mLastSensorTime = SoraDGetSocketTime() * 1000
		else
			local nowTIme = SoraDGetSocketTime() * 1000
			local interval = nowTIme - ShackModule.mLastSensorTime
			if interval < 50 then
				return
			end
			ShackModule.mLastSensorTime = nowTIme
			local deltaX = x - ShackModule.mLastSx
			local deltaY = y - ShackModule.mLastSy
			local deltaZ = z - ShackModule.mLastSz
			ShackModule.mLastSx = x
			ShackModule.mLastSy = y
			ShackModule.mLastSz = z
			local speed = math.sqrt(deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ) / interval * 10000
			if speed >= ShackModule.shackSensitivity then
				print("final speed = ", speed)
				ShackModule.shakeCallBack()
				ShackModule.enableShack = false
				local fPanel = shakeOffsetModule:getInstance():getShackPanel()
				if fPanel then
					local actionTo1 = cca.delay(ShackModule.shackInterval)
					local callFunc = cca.callFunc(function()
						ShackModule.enableShack = true
					end)
					_UPVALUE2_ = nil
					;(nil)[1] = actionTo1
					;(nil)[2] = callFunc
					fPanel:runAction(cca.seq(nil))
				end
			end
		end
	end
end
function ShackModule.shakeCallBack(...)
	if not ShackModule.extCallBackTbl then
		_ENV = ShackModule.extCallBackTbl
	end
	for i, v in ipairs(ShackModule.extCallBackTbl) do
		v.fun()
	end
end
function ShackModule.remove(funName)
	if not ShackModule.extCallBackTbl then
		_ENV = ShackModule.extCallBackTbl
	end
	for k, v in pairs(ShackModule.extCallBackTbl) do
		if v.name == funName then
			table.remove(ShackModule.extCallBackTbl, k)
			break
		end
	end
	if not ShackModule.extCallBackTbl then
		_ENV = ShackModule.extCallBackTbl
	end
	if not next(ShackModule.extCallBackTbl) then
		ShackModule.unload()
	end
end
