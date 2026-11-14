local mapResExplainRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	mapResExplainRead = nil
	;(nil)[1] = "mapguideinfo"
	mapResExplainRead:defineValue("mapGuideInfo", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "alliancemapmark"
	;(nil)[2] = true
	mapResExplainRead:defineValue("alliancemapmark", nil)
end
init()
function mapResExplainRead.getResList(instanceType, rid)
	local _ENV, reTable
	for i, v in ipairs(mapResExplainRead.mapGuideInfo) do
		if instanceType == v.instanceType and rid == v.resType then
			table.insert(reTable, v)
		end
	end
	table.sort(reTable, function(a, b)
		return a.stepNum < b.stepNum
	end)
	return reTable
end
function mapResExplainRead:getAlliancemapmark()
	return mapResExplainRead.alliancemapmark
end
function mapResExplainRead:getAlliancemapmarkNums()
	return #mapResExplainRead.alliancemapmark
end
function mapResExplainRead.getAlliancemapmarkName(index)
	return mapResExplainRead.alliancemapmark[index].name
end
function mapResExplainRead.getAlliancemapmarkIcon(index)
	return mapResExplainRead.alliancemapmark[index].icon
end
return mapResExplainRead
