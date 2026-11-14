local _ENV, testFilterSystem
local filterSystem = include("filterSystem")
local filterltCtrl = include("filterltCtrl")
function testFilterSystem:test()
	do
		local group = filterltCtrl.getFilterGroup(1)
		dump(group, "group", 10)
		for _, filterID in ipairs(group) do
			print("getFilterType,getFilterValueType,getFilterValue", filterltCtrl.getFilterType(filterID), filterltCtrl.getFilterValueType(filterID), filterltCtrl.getFilterValue(filterID))
		end
		filterltCtrl = (for generator)
		local ipairs(group).battleUnitID, inputkey = 401, ipairs(group)
		local filterGroupID = 4
		dump(inputkey, "inputkey", 10)
		print("filterGroupID = ", filterGroupID)
		local ret = filterSystem.isFilteredByInputKeyGroupID(inputkey, filterGroupID)
		print("test 401 ret: = ", ret)
		if ret == true then
			print("test pass")
		end
	end
	filterltCtrl = group
	do
		local filterltCtrl.getFilterGroup(1).battleUnitID, inputkey = 601, filterltCtrl.getFilterGroup(1)
		local filterGroupID = 4
		dump(inputkey, "inputkey", 10)
		print("filterGroupID = ", filterGroupID)
		local ret = filterSystem.isFilteredByInputKeyGroupID(inputkey, filterGroupID)
		print("test 601 ret: = ", ret)
		if ret == false then
			print("test pass")
		end
	end
	print("test end ----------------")
end
return testFilterSystem
