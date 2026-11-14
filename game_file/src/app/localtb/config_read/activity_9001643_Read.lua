local activity_9001643_Read = include("aAReadClass").new()
_ENV = "aAReadClass"
;("aAReadClass").NONE = 1
;("aAReadClass").ACCPET = 2
;("aAReadClass").COMPLETE = 3
activity_9001643_Read.TASK_STATUS_ENUM, ("aAReadClass").FINISH = "aAReadClass", 4
_UPVALUE2_ = nil
;(nil)[1] = "eidal_celebration_chapter"
;(nil)[2] = true
activity_9001643_Read:defineValue("eidal_celebration_chapter", nil)
function activity_9001643_Read.getChapterCfg()
	return activity_9001643_Read.eidal_celebration_chapter
end
function activity_9001643_Read.getChapterCfgById(chapter)
	return activity_9001643_Read.eidal_celebration_chapter[chapter]
end
activity_9001643_Read:defineValue("eidal_celebration_task", function()
	local config = require_data("eidal_celebration_task", true, true).data
	local _ENV, ret = "eidal_celebration_task", "eidal_celebration_task"
	for _, v in ipairs(config) do
		ret[v.task_id] = v
	end
	return ret
end)
function activity_9001643_Read.getTaskCfg(taskID)
	return activity_9001643_Read.eidal_celebration_task[taskID]
end
return activity_9001643_Read
