local attrModule = include("attrModule")
local _ENV, attrTesting = "attrModule", "attrModule"
function attrTesting:test()
	_UPVALUE4_ = nil
	;(nil)[1] = 998
	;(nil)[2] = 1
	;(nil)[3] = 2
	;(nil)[4] = 3
	local t_attrModule = attrModule.new(nil)
	t_attrModule:add(1, 100, 100, 998)
	t_attrModule:add(1, 200, 200, 998)
	t_attrModule:add(2, 300, 300, 998)
	t_attrModule:add(2, 200, 200, 998)
	dump(t_attrModule, "t_attrModule", 10)
	local queryAttr = function(attrType, key)
		local attrValue, attrMap = t_attrModule:query(attrType, key)
		print("query result:", attrValue)
		dump(attrMap, "attrMap", 10)
		dump(t_attrModule, "t_attrModule", 10)
		return attrMap
	end
	attrModule = 10
	;(10).battleUnitID = 401
	queryAttr(1, 10)
	attrModule = 10
	;(10).battleUnitID = 401
	;(10).battleField = 1
	queryAttr(1, 10)
	t_attrModule:remove(1, 100, 100, 998)
	t_attrModule:remove(1, 200, 200, 998)
	t_attrModule:remove(2, 300, 300, 998)
	t_attrModule:remove(2, 200, 200, 998)
	t_attrModule:cleanSourceAttrContainer(998)
	dump(t_attrModule, "t_attrModule", 10)
end
return attrTesting
