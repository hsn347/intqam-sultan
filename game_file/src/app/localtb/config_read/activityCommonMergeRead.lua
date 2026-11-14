local activityCommonMergeRead = include("aAReadClass").new()
local createData = function(name)
	local config = require_data(name, true, true).data
	local _ENV, ret = name, name
	for k, v in ipairs(config) do
		if not ret[v.classType] then
			ret[v.classType], _ENV = nil, nil
		end
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.formula = serviceFunctions.tableFormat(v.formula, nil)
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		v.rewaryd = serviceFunctions.tableFormat(v.rewaryd, nil)
		v.bubbleType = v.bubbleType or v.boxType
		v.bubbleName = v.bubbleName or v.boxName
		table.insert(ret[v.classType], v)
	end
	return ret
end
activityCommonMergeRead:defineValue("activity_9001692_config", function()
	return createData("collect_colored_ribbon")
end)
activityCommonMergeRead:defineValue("activity_9001663_config", function()
	return createData("bubble_carnival_compose")
end)
function activityCommonMergeRead.getConfig(activityID)
	if activityID == gActivityTimeActivityID.NORMAL_ACTIVITY_9001692 then
		return activityCommonMergeRead.activity_9001692_config
	elseif activityID == gActivityTimeActivityID.BUBBLE_CARNIVAL then
		return activityCommonMergeRead.activity_9001663_config
	end
end
function activityCommonMergeRead.getClassTypeConfig(activityID)
	local config = activityCommonMergeRead.getConfig(activityID)
	if not config then
		return
	end
	local classType = SoraDGetActivityClassType(activityID)
	return config[classType] or config[1]
end
function activityCommonMergeRead.getCfgNum(activityID)
	local config = activityCommonMergeRead.getClassTypeConfig(activityID)
	return #config
end
function activityCommonMergeRead.getCfg(activityID, index)
	local config = activityCommonMergeRead.getClassTypeConfig(activityID)
	return index and config[index] or config
end
function activityCommonMergeRead.getCfgFormula(activityID)
	local config = activityCommonMergeRead.getClassTypeConfig(activityID)
	local activityCommonMergeRead, list = activityID, activityID
	for k, v in ipairs(config) do
		for _, n in ipairs(v.formula) do
			if not SoraDisInList(n.id, list) then
				table.insert(list, n.id)
			end
		end
	end
	return list
end
return activityCommonMergeRead
