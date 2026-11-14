local activity_9001596_Read = include("aAReadClass").new()
_ENV = "aAReadClass"
;("aAReadClass").carriage = 1
;("aAReadClass").barrel = 2
activity_9001596_Read.partType, ("aAReadClass").wheel = "aAReadClass", 3
activity_9001596_Read:defineValue("assemblinglftergun", function()
	activity_9001596_Read.assemblinglftergun, activity_9001596_Read = nil, nil
	local cfg = require_data("assemblinglftergun", true).data
	for i, v in ipairs(cfg) do
		activity_9001596_Read.assemblinglftergun[v.place] = v
	end
	return activity_9001596_Read.assemblinglftergun
end)
function activity_9001596_Read.getPartName(part)
	return i18n(activity_9001596_Read.assemblinglftergun[part].name)
end
function activity_9001596_Read.getPartDes(part)
	return i18n(activity_9001596_Read.assemblinglftergun[part].text)
end
function activity_9001596_Read.getPartIcon(part)
	return activity_9001596_Read.assemblinglftergun[part].image
end
function activity_9001596_Read.getPartID(part)
	return activity_9001596_Read.assemblinglftergun[part].partNum[1]
end
function activity_9001596_Read.getPartNum(part)
	return activity_9001596_Read.assemblinglftergun[part].partNum[2]
end
function activity_9001596_Read.getPartReward(part)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	return serviceFunctions.tableFormat(activity_9001596_Read.assemblinglftergun[part].reward, nil)
end
function activity_9001596_Read.getPartJump(part)
	local count = 0
	local activity_9001596_Read, ret
	local jump = activity_9001596_Read.assemblinglftergun[part].jump
	if jump[1] and jump[1] ~= 0 then
		activity_9001596_Read, count = jump[1], count + 1
		jump[1].id = jump[1]
		ret[count], jump[1].index = jump[1], 1
	end
	if jump[2] and jump[2] ~= 0 then
		activity_9001596_Read, count = jump[2], count + 1
		jump[2].id = jump[2]
		ret[count], jump[2].index = jump[2], 2
	end
	local jump_gift = activity_9001596_Read.assemblinglftergun[part].jump_gift
	if 0 < #jump_gift then
		activity_9001596_Read, count = #jump_gift, count + 1
		;(#jump_gift).id = jump_gift
		ret[count], (#jump_gift).index = #jump_gift, 3
	end
	return ret
end
function activity_9001596_Read.getWarehouseItems()
	local _ENV, ret
	for k, v in ipairs(activity_9001596_Read.assemblinglftergun) do
		table.insert(ret, v.partNum[1])
	end
	local constantRead = include("constantRead")
	table.insert(ret, constantRead.getConstValue("RAMADAN_2024_ORDINARY_SALUTE", 867701))
	table.insert(ret, constantRead.getConstValue("RAMADAN_2024_LUXURY_Salute", 867801))
	return ret
end
return activity_9001596_Read
