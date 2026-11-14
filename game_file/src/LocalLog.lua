LocalLog, _ENV = nil, nil
function LocalLog:Init()
	_ENV = nil
	;(nil)[20371338] = true
	;(nil)[14657591] = true
	self.uidWhiteList, (nil)[14657563] = nil, true
	self.persistent_path = CS.UnityEngine.Application.persistentDataPath .. "/LocalLog"
	CS.System.IO.Directory.CreateDirectory(self.persistent_path)
end
function LocalLog:IsInWhiteList(uid)
	return self.uidWhiteList[uid] == true
end
function LocalLog:Log(message)
	local timestamp = os.date("%Y-%m-%d")
	self.filename = string.format("%s/%s-log.txt", self.persistent_path, timestamp)
	local timestamp = os.date("%Y-%m-%d %H:%M:%S")
	local logEntry = string.format("%s - %s\n", timestamp, message)
	self.logFile = io.open(self.filename, "a")
	self.logFile:write(logEntry)
	self.logFile:close()
end
function LocalLog:LogFightDemoOut(data, name)
	local filename = self.persistent_path .. "/" .. name
	os.remove(filename)
	local logFile = io.open(filename, "a")
	logFile:write(json.encode(data))
	logFile:close()
end
function LocalLog:LogFightDemoIn(name)
	local filename = self.persistent_path .. "/" .. name
	local logFile = io.open(filename, "r")
	local data
	if logFile then
		data = logFile:read("a")
		logFile:close()
	end
	return data
end
LocalLog:Init()
return LocalLog
