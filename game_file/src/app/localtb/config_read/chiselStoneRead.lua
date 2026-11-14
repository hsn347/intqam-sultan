local chiselStoneRead = include("aAReadClass").new()
function chiselStoneRead.getTaskByDayLabel(day, label)
	if label then
		return chiselStoneRead.Task_Config[day][label].quests
	else
		return chiselStoneRead.Task_Config[day]
	end
end
function chiselStoneRead.getTabNameByDayLabel(day, label)
	return chiselStoneRead.Task_Config[day][label].tabName
end
function chiselStoneRead.getTaskNumByDayLabel(day, label)
	return chiselStoneRead.Task_Config[day][label].num
end
function chiselStoneRead.init()
	chiselStoneRead:defineValue("Task_Config", function()
		chiselStoneRead.Task_Config, chiselStoneRead = nil, nil
		local oriData = require_data("diggingtask", true, true).data
		for i, v in pairs(oriData) do
			if not chiselStoneRead.Task_Config[v.MainLabel] then
				chiselStoneRead.Task_Config[v.MainLabel], chiselStoneRead = nil, nil
			end
			if not chiselStoneRead.Task_Config[v.MainLabel][v.SubLabel] then
				chiselStoneRead = nil
				;(nil).quests, chiselStoneRead, (nil).tabName = v.SubLabelText, v.SubLabelText, v.SubLabelText
				chiselStoneRead.Task_Config[v.MainLabel][v.SubLabel], (nil).num = nil, 0
			end
			chiselStoneRead.Task_Config[v.MainLabel][v.SubLabel].num = chiselStoneRead.Task_Config[v.MainLabel][v.SubLabel].num + 1
			chiselStoneRead = v.SubLabel
			v.SubLabel.taskID = v.QeustID
			v.SubLabel.order = v.Order
			table.insert(chiselStoneRead.Task_Config[v.MainLabel][v.SubLabel].quests, v.SubLabel)
		end
		return chiselStoneRead.Task_Config
	end)
end
function chiselStoneRead.getTaskConfig()
	return chiselStoneRead.Task_Config
end
chiselStoneRead.init()
return chiselStoneRead
