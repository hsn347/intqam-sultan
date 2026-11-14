local redPackageRead = include("aAReadClass").new()
local isInited = false
local init = function()
	if isInited then
		return
	end
	redPackageRead = nil
	;(nil)[1] = "red_package_task_describe"
	redPackageRead:defineValue("taskInfo", nil)
end
init()
function redPackageRead.getTaskInfo()
	return redPackageRead.taskInfo
end
function redPackageRead.getTaskDesByID(taskID)
	return i18n(redPackageRead.taskInfo[taskID].taskDes)
end
return redPackageRead
