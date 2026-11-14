local resurrectionltCtrl = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "resurrection_config"
	;(nil)[2] = true
	resurrectionltCtrl:defineValue("resurrectionConfig", nil)
end
init()
function resurrectionltCtrl.getNeedItem(index)
	local maxindex = #resurrectionltCtrl.resurrectionConfig
	if index > maxindex then
		index = maxindex
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local needitem = serviceFunctions.tableFormat(resurrectionltCtrl.resurrectionConfig[index].need_item, nil)
	return needitem
end
function resurrectionltCtrl.getResurgenceRate(index)
	local maxindex = #resurrectionltCtrl.resurrectionConfig
	if index > maxindex then
		index = maxindex
	end
	local rate = resurrectionltCtrl.resurrectionConfig[index].resurgence_rate / 1000
	return rate
end
function resurrectionltCtrl.getFinalResurrectionIndex(curIndex, unResurrectionCount, totalDeadCount)
	local gametop = gModuleMgr.getObject("gametop")
	local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
	local theoryIndex = math.ceil(curIndex + unResurrectionCount / (0.05 * totalDeadCount + 5000))
	local needCount = 0
	local retIndex = curIndex
	while true do
		retIndex = retIndex + 1
		local needitem = resurrectionltCtrl.getNeedItem(retIndex)
		local curToolCount = backpackCtrl:getItemCount(needitem[1].id)
		needCount = needCount + needitem[1].count
		if theoryIndex <= retIndex then
			retIndex = theoryIndex
			break
		end
	end
	return retIndex
end
return resurrectionltCtrl
