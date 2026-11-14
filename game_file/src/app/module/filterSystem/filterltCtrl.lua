local _ENV, filterltCtrl
function filterltCtrl:init()
	filterltCtrl.filterRelationshipConfig = include("filter_relationship_config")
	filterltCtrl.filterGroupConfig = include("filter_group")
	local filterConfig = include("filter_relationship_config")
	for filterID, v in pairs(filterConfig) do
		local lockType = v.filterValueType
		local lockValue
		if 1 == lockType or 3 == lockType then
			local filterltCtrl, filterValue
			for _, value in ipairs(v.filterValue) do
				filterValue[value] = 1
			end
			lockValue = filterValue
		elseif 5 == lockType then
			local filterltCtrl, tmpValue
			tmpValue.min = v.filterValue[1]
			tmpValue.armyTab, filterltCtrl, tmpValue.max = v.filterValue[2], v.filterValue[2], v.filterValue[2]
			for i = 3, #v.filterValue do
				table.insert(tmpValue.armyTab, v.filterValue[i])
			end
			lockValue = tmpValue
		else
			lockValue = v.filterValue
		end
		filterltCtrl = nil
		filterltCtrl, (nil).filterType = v.filterType, v.filterType
		v.filterType.type = v.filterValueType
		;(nil).lock, v.filterType.value = v.filterType, lockValue
		local filter
		filterConfig[filterID] = filter
	end
	filterltCtrl.filterRelationshipConfig = filterConfig
	local filterGroup = include("filter_group")
	for groupID, v in pairs(filterGroup) do
		filterGroup[groupID] = v.group
	end
	filterltCtrl.filterGroupConfig = filterGroup
end
function filterltCtrl:getFilter(filterID)
	return self.filterRelationshipConfig[filterID]
end
function filterltCtrl:getFilterGroup(groupID)
	return groupID and self.filterGroupConfig[groupID] or nil
end
filterltCtrl:init()
return filterltCtrl
