local _ENV, testBuffAndAttr
local gametop = gModuleMgr.getObject("gametop")
local newBuffCtrl = gametop.playertop_:getModule("newBuffCtrl")
local attributeCtrl = gametop.playertop_:getModule("attributeCtrl")
function testBuffAndAttr:testAttr()
	attributeCtrl:add(1, 100, 100, 998)
	attributeCtrl:add(1, 200, 200, 998)
	attributeCtrl:add(2, 300, 300, 998)
	attributeCtrl:add(2, 200, 200, 998)
	dump(attributeCtrl.attrModule, "attributeCtrl.attrModule", 10)
	local queryAttr = function(attrType, key)
		local attrValue, attrMap = attributeCtrl:query(attrType, key)
		print("query result:", attrValue)
		dump(attrMap, "attrMap", 10)
		dump(attributeCtrl.attrModule, "attributeCtrl.attrModule", 10)
		return attrMap
	end
	print("query: { battleUnitID = 401}")
	attributeCtrl = 10
	;(10).battleUnitID = 401
	queryAttr(1, 10)
	print("query: { battleUnitID = 401} end")
	print("query: { battleUnitID = 401, battleField = 1 } begin")
	attributeCtrl = 10
	;(10).battleUnitID = 401
	;(10).battleField = 1
	queryAttr(2, 10)
	print("query: { battleUnitID = 401, battleField = 1 } end")
	attributeCtrl:remove(1, 100, 100, 998)
	attributeCtrl:remove(1, 200, 200, 998)
	attributeCtrl:remove(2, 300, 300, 998)
	attributeCtrl:remove(2, 200, 200, 998)
	dump(attributeCtrl.attrModule, "attributeCtrl", 10)
end
function testBuffAndAttr:testBuff(...)
	newBuffCtrl:add(10000001)
	newBuffCtrl:add(10000002)
	newBuffCtrl:add(10000003)
	newBuffCtrl:add(10000004)
	newBuffCtrl:add(10000005)
	dump(newBuffCtrl.buffModule, "newBuffCtrl", 10)
	local queryAttr = function(attrType, key)
		local attrValue, attrMap = attributeCtrl:query(attrType, key)
		print("query result:", attrValue)
		dump(attrMap, "attrMap", 10)
		dump(attributeCtrl.attrModule, "attrModule", 10)
		return attrMap
	end
	print("==============")
	newBuffCtrl = 10
	;(10).battleUnitID = 401
	local attrMap = queryAttr(1, 10)
	newBuffCtrl:useAttr(attrMap)
	dump(attributeCtrl.attrModule, "attrModule", 10)
	dump(newBuffCtrl.buffModule, "newBuffCtrl", 10)
	SoraDDelayCallOnce("testbuff1", function()
		print("6s 之后--------------------------------")
		dump(attributeCtrl.attrModule, "attrModule", 10)
		dump(newBuffCtrl.buffModule, "newBuffCtrl", 10)
	end, 6)
	SoraDDelayCallOnce("testbuff2", function()
		print("12s 之后--------------------------------")
		dump(attributeCtrl.attrModule, "attrModule", 10)
		dump(newBuffCtrl.buffModule, "newBuffCtrl", 10)
	end, 12)
end
return testBuffAndAttr
