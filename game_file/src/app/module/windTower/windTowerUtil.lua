local _ENV, windTowerUtil
local windTowerCtrl = SoraDGetCtrl("windTowerCtrl")
_UPVALUE7_ = "windTowerCtrl"
;("windTowerCtrl")[1] = "lost_ruins_text_06"
;("windTowerCtrl")[2] = "lost_ruins_text_07"
;("windTowerCtrl")[3] = "lost_ruins_text_09"
;("windTowerCtrl")[4] = "lost_ruins_text_10"
;("windTowerCtrl")[5] = "togetherTeam_text_68"
;("windTowerCtrl")[6] = "lost_ruins_text_08"
local ("windTowerCtrl")[7], taskStateStr = "common_text_1892", "windTowerCtrl"
function windTowerUtil.getStateStr(state)
	return i18n(taskStateStr[state])
end
function windTowerUtil.getBuildCD(pos)
	windTowerCtrl = nil
	;(nil).x = pos.x + 1
	;(nil).y = pos.y + 1
	local cdInfo = windTowerCtrl:getBuildCD(nil)
	if cdInfo and cdInfo.endtime then
		local leftTime = math.max(0, cdInfo.endtime - serviceFunctions.systemTime())
		return leftTime
	end
	return 0
end
function windTowerUtil.isBuildCD(pos)
	local leftTime = windTowerUtil.getBuildCD(pos)
	if leftTime and 0 < leftTime then
		return true
	end
	return false
end
return windTowerUtil
