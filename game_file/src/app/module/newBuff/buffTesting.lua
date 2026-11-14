local _ENV, buffTesting
function buffTesting:test()
	local attrModule = include("attrModule")
	_UPVALUE4_ = nil
	;(nil)[1] = 1
	;(nil)[2] = 2
	;(nil)[3] = 3
	;(nil)[4] = 998
	attrModule = attrModule.new(nil)
	local timerModule = gModuleMgr.getObject("timerList")
	local buffEndCallback = function(buffID)
		print("----buff end", buffID)
	end
	local buffModule = include("buffModule")
	_ENV = nil
	buffModule = buffModule.new(attrModule, timerModule, buffEndCallback, nil)
	buffModule:add(10000001)
	buffModule:add(10000002)
	buffModule:add(10000003)
	buffModule:add(10000004)
	buffModule:add(10000005)
	dump(buffModule:getBuffData(), "buffModule", 10)
	local queryAttr = function(attrType, key)
		local attrValue, attrMap = attrModule:query(attrType, key)
		print("query result:", attrValue)
		dump(attrMap, "attrMap", 10)
		dump(attrModule, "attrModule", 10)
		return attrMap
	end
	print("==============")
	_ENV = 10
	;(10).battleUnitID = 401
	local attrMap = queryAttr(1, 10)
	buffModule:useAttrs(attrMap)
	dump(attrModule, "attrModule", 10)
	dump(buffModule:getBuffData(), "buffModule", 10)
	SoraDDelayCallOnce("testbuff1", function()
		print("6s后的测试-----------------------")
		dump(attrModule, "attrModule", 10)
		dump(buffModule:getBuffData(), "buffModule", 10)
	end, 6)
	SoraDDelayCallOnce("testbuff2", function()
		print("12s后的测试-----------------------")
		dump(attrModule, "attrModule", 10)
		dump(buffModule:getBuffData(), "buffModule", 10)
	end, 12)
end
return buffTesting
