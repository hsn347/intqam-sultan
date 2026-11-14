local lifeWaterltCtrl = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "lifespring_config"
	;(nil)[2] = true
	lifeWaterltCtrl:defineValue("resurrectionConfig", nil)
end
init()
function lifeWaterltCtrl.getNeedItem(index)
	local maxindex = #lifeWaterltCtrl.resurrectionConfig
	if index > maxindex then
		index = maxindex
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local needitem = serviceFunctions.tableFormat(lifeWaterltCtrl.resurrectionConfig[index].need_item, nil)
	return needitem
end
function lifeWaterltCtrl.getResurgenceRate(index)
	local maxindex = #lifeWaterltCtrl.resurrectionConfig
	if index > maxindex then
		index = maxindex
	end
	local rate = lifeWaterltCtrl.resurrectionConfig[index].resurgence_rate / 1000
	return rate
end
function lifeWaterltCtrl.getFinalResurrectionIndex(curIndex, unResurrectionCount, totalDeadCount, baseVal)
	local gametop = gModuleMgr.getObject("gametop")
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local theoryIndex = math.ceil(curIndex + unResurrectionCount / (0.05 * totalDeadCount + baseVal))
	local needCount = 0
	local retIndex = curIndex
	while true do
		retIndex = retIndex + 1
		local needitem = lifeWaterltCtrl.getNeedItem(retIndex)
		local curToolCount = backpackCtrl:getItemCount(needitem[1].id)
		needCount = needCount + needitem[1].count
		if theoryIndex <= retIndex then
			retIndex = theoryIndex
			break
		end
	end
	return retIndex
end
return lifeWaterltCtrl
