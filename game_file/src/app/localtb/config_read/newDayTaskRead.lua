local newDayTaskRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "change_day_config"
	;(nil)[2] = true
	newDayTaskRead:defineValue("config", nil)
end
init()
function newDayTaskRead.getTaskList(castleLv, starLv)
	for _, v in ipairs(newDayTaskRead.config) do
		print("newDayTaskRead.getTaskList", v.lv[1], v.lv[2], castleLv)
		if next(v.lv) and castleLv >= v.lv[1] and castleLv <= v.lv[2] then
			if next(v.lv1) then
				if starLv >= v.lv1[1] and starLv <= v.lv1[2] then
					return v.taskID
				end
			else
				return v.taskID
			end
		end
	end
end
return newDayTaskRead
