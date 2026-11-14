local game_path = "LuaScripts/"
local createCtrlTool = class("createCtrlTool")
function createCtrlTool:ctor()
	local config = createCtrlTool:initConfig()
	createCtrlTool:begin(config)
	SoraDShowMsgTip("生成文件成功")
end
function createCtrlTool:initConfig(...)
	_UPVALUE0_ = nil
	;(nil).name = "eidSign"
	_UPVALUE4_, (nil).module = nil, "CMD_EID_SIGN_MODULE"
	;(nil).notifyID, _UPVALUE0_, (nil).cmd, (nil)[1] = nil, nil, nil, "REQ_EID_SIGN_INIT"
	;(nil).notifyID, _UPVALUE0_, (nil).cmd, (nil)[2] = nil, nil, nil, "REQ_EID_SIGN_COMMON_SIGN"
	;(nil).notifyID, _UPVALUE0_, (nil).cmd, (nil)[3] = nil, nil, nil, "REQ_EID_SIGN_USE_GOLD_SIGN"
	;(nil).notifyID, _UPVALUE0_, (nil).cmd, (nil)[4] = nil, nil, nil, "REQ_EID_SIGN_GET_EXTRA"
	;(nil).needDump = true
	;(nil).folder = "activity"
	;(nil).write2Include = true
	local (nil).write2PlayerTopModule, config = true, nil
	return config
end
function createCtrlTool:begin(config)
	local fileData = ""
	local flieName = config.name
	local folderName = config.folder and config.folder ~= "" and config.folder or config.name
	local fullDirName = game_path .. "src/app/module/" .. folderName
	io.mkdir(fullDirName)
	flieName = flieName .. "Ctrl"
	local fullName = fullDirName .. "/" .. flieName .. ".lua"
	local file = io.open(fullName, "w+")
	fileData = fileData .. "--\n"
	fileData = fileData .. "-- Author:\n"
	fileData = fileData .. string.format("-- Date: %s\n", os.date("%Y-%m-%d %H:%M:%S", os.time()))
	if config.mark then
		fileData = fileData .. string.format("-- %s\n", config.mark)
	end
	fileData = fileData .. "--\n"
	fileData = fileData .. "\n"
	fileData = fileData .. "local gamemodulec = include \"GameModule\"" .. "\n"
	fileData = fileData .. "local gametop = gModuleMgr.getObject(\"gametop\")" .. "\n"
	fileData = fileData .. string.format("local %s = class(\"%s\",gamemodulec)", flieName, flieName) .. "\n"
	fileData = fileData .. "local serverproxy = gModuleMgr.getObject(\"serverproxy\")" .. "\n"
	fileData = fileData .. "local msgCtrl = include(\"msgCtrl\")" .. "\n"
	fileData = fileData .. "" .. "\n"
	fileData = fileData .. "------------------------------------------常   规------------------------------------------" .. "\n"
	fileData = fileData .. string.format("function %s:ctor(properties)", flieName) .. "\n"
	fileData = fileData .. string.format("\t%s.super.ctor(self,properties)", flieName) .. "\n"
	fileData = fileData .. "    self:resetData()" .. "\n"
	fileData = fileData .. "end" .. [[


]]
	fileData = fileData .. string.format("function %s:EnterGame()", flieName) .. "\n"
	local findIndex
	local cmd1 = config.cmd[1]
	for i = 1, #cmd1 do
		local prefix = string.sub(cmd1, 1, i)
		for _, v in ipairs(config.cmd) do
			local _prefix = string.sub(v, 1, i)
			if _prefix ~= prefix then
				findIndex = i
				break
			end
		end
		if findIndex then
			break
		end
	end
	findIndex = findIndex or 1
	local game_path, cmdFuncList = 1, 1
	for _, v in ipairs(config.cmd) do
		local tempStr = string.sub(v, findIndex, -1)
		local tab = string.split(tempStr, "_")
		local rspFuncName = "req"
		for i = 1, #tab do
			local w = tab[i]
			local str = string.upper(string.sub(w, 1, 1)) .. string.lower(string.sub(w, 2, string.len(w)))
			rspFuncName = rspFuncName .. str
		end
		table.insert(cmdFuncList, rspFuncName)
		rspFuncName = rspFuncName .. "Rsp"
		fileData = fileData .. string.format("    msgCtrl.register(gCmd.%s, gCmd.%s,    handler(self, self.%s))", config.module, v, rspFuncName) .. "\n"
	end
	if config.notifyID and next(config.notifyID) then
		fileData = fileData .. "" .. "\n"
		fileData = fileData .. "    self:registerNotify()" .. "\n"
	end
	fileData = fileData .. "end" .. [[


]]
	fileData = fileData .. string.format("function %s:Logout()", flieName) .. "\n"
	fileData = fileData .. string.format("    %s.super.Logout(self)", flieName) .. "\n"
	fileData = fileData .. "    self:resetData()" .. "\n"
	fileData = fileData .. "end" .. [[


]]
	fileData = fileData .. string.format("function %s:resetData()", flieName) .. "\n"
	fileData = fileData .. "    self.initData = {}" .. "\n"
	fileData = fileData .. "end" .. [[


]]
	if config.initClientData then
		fileData = fileData .. string.format("function %s:initClientData(data)", flieName) .. "\n"
		fileData = fileData .. "    if not data then" .. "\n"
		fileData = fileData .. "        return" .. "\n"
		fileData = fileData .. "    end" .. "\n"
		fileData = fileData .. string.format("    dump(data, \"==%s:initClientData==\", 10)", flieName) .. "\n"
		fileData = fileData .. "    self.initData = data" .. "\n"
		fileData = fileData .. "end" .. [[


]]
	end
	if config.notifyID and next(config.notifyID) then
		fileData = fileData .. string.format("function %s:registerNotify()", flieName) .. "\n"
		fileData = fileData .. "    local notifyCtrl = gametop.playertop_:getModule(\"notifyCtrl\")" .. "\n"
		local game_path, notityFuncList = fileData, fileData
		for i, v in ipairs(config.notifyID) do
			local name1 = "handle_notify"
			local name2 = "notifyHandler"
			if i ~= 1 then
				name1 = name1 .. i
				name2 = name2 .. i
			end
			table.insert(notityFuncList, name2)
			fileData = fileData .. string.format("    self.%s = notifyCtrl:register(gNotifyID.%s, handler(self, self.%s))", name1, string.gsub(v, "NOTIFY_", ""), name2) .. "\n"
		end
		fileData = fileData .. "end" .. [[


]]
		for i, v in ipairs(notityFuncList) do
			fileData = fileData .. string.format("function %s:%s(event)", flieName, v) .. "\n"
			if config.needDump then
				fileData = fileData .. string.format("    dump(event.data, \"%s:%s\", 10)", flieName, v) .. "\n"
			end
			fileData = fileData .. "    for k,v in ipairs(event.data) do" .. "\n"
			fileData = fileData .. "        local notifyType = v.notifyType" .. "\n"
			fileData = fileData .. "        local notifyData = v.notifyData" .. "\n"
			fileData = fileData .. "        if notifyType == \"refreshData\" then" .. "\n"
			fileData = fileData .. "        end" .. "\n"
			fileData = fileData .. "    end" .. "\n"
			fileData = fileData .. "end" .. [[


]]
		end
	end
	fileData = fileData .. "------------------------------------------指令发送------------------------------------------" .. "\n"
	if not config.cmdMark then
		local game_path, cmdMark = config.cmdMark, config.cmdMark
	end
	for i, v in ipairs(config.cmd) do
		if cmdMark[i] then
			fileData = fileData .. string.format("-- %s", cmdMark[i]) .. "\n"
		end
		fileData = fileData .. string.format("function %s:%s()", flieName, cmdFuncList[i]) .. "\n"
		fileData = fileData .. string.format("    serverproxy:Request(gCmd.%s, gCmd.%s, {})", config.module, v) .. "\n"
		fileData = fileData .. "end" .. [[


]]
		fileData = fileData .. string.format("function %s:%s(content)", flieName, cmdFuncList[i] .. "Rsp") .. "\n"
		if config.needDump then
			fileData = fileData .. string.format("    dump(content, \"%s:%s(content)\", 10)", flieName, cmdFuncList[i] .. "Rsp") .. "\n"
		end
		fileData = fileData .. "    if content.err == gErrDef.Err_None then" .. "\n"
		fileData = fileData .. "    end" .. "\n"
		fileData = fileData .. "end" .. [[


]]
	end
	fileData = fileData .. "------------------------------------------通用接口------------------------------------------" .. "\n"
	fileData = fileData .. string.format([[

return %s]], flieName) .. "\n"
	file:write(fileData)
	file:close()
	if config.write2Include then
		game_path = fileData
		fileData.folderName = folderName
		fileData.flieName = flieName
		createCtrlTool:write2Include(fileData)
	end
	if config.write2PlayerTopModule then
		game_path = fileData
		fileData.flieName = flieName
		createCtrlTool:write2PlayerTopModule(fileData)
	end
	if config.initClientData then
		game_path = fileData
		fileData.name = flieName
		fileData.key = config.ctrlServerKey or flieName
		createCtrlTool:write2PlayerTopModule_initDataTable(fileData)
	end
	if config.resetActivityData then
		game_path = fileData
		fileData.activityName = config.activityName
		fileData.name = flieName
		createCtrlTool:write2PlayerTopModule_resetActivityData(fileData)
	end
	if config.delayInitCall then
		game_path = fileData
		fileData.name = flieName
		createCtrlTool:write2PlayerTopModule_delayInitCall(fileData)
	end
end
function createCtrlTool:write2Include(data)
	local fullName = game_path .. "src/app/includes/include.lua"
	local file = io.open(fullName, "r+")
	if not file then
		return
	end
	local content = file:read("*l")
	local fileData = ""
	local beginFind = false
	while content do
		if string.find(content, data.flieName) then
			print("已经有这个文件的路径了,不加了")
			return
		end
		if string.find(content, "local nametopath") then
			beginFind = true
		end
		if beginFind and string.find(content, "}") then
			fileData = fileData .. string.format("    %s = \"app.module.%s.%s\",\n", data.flieName, data.folderName, data.flieName)
			beginFind = false
		end
		fileData = fileData .. content .. "\n"
		content = file:read("*l")
	end
	file:close()
	local file = io.open(fullName, "w+")
	file:write(fileData)
	file:close()
end
function createCtrlTool:write2PlayerTopModule(data)
	local fullName = game_path .. "src/app/module/general/PlayerTopModule.lua"
	local file = io.open(fullName, "r+")
	if not file then
		return
	end
	local content = file:read("*l")
	local fileData = ""
	local beginFind = false
	while content do
		if string.find(content, data.flieName) then
			print("已经有这个文件的路径了,不加了")
			return
		end
		if string.find(content, "playerTopModule.asynCtrls") then
			beginFind = true
		end
		if beginFind and string.find(content, "}") then
			fileData = fileData .. string.format("    [\"%s\"] = true,\n", data.flieName)
			beginFind = false
		end
		fileData = fileData .. content .. "\n"
		content = file:read("*l")
	end
	file:close()
	local file = io.open(fullName, "w+")
	file:write(fileData)
	file:close()
end
function createCtrlTool:write2PlayerTopModule_initDataTable(data)
	local fullName = game_path .. "src/app/module/general/PlayerTopModule.lua"
	local file = io.open(fullName, "r+")
	if not file then
		return
	end
	local content = file:read("*l")
	local fileData = ""
	local beginFind = false
	while content do
		if string.find(content, "playerTopModule.initDataTable") then
			beginFind = true
		end
		if beginFind and content == "}" then
			fileData = fileData .. string.format("    {name = \"%s\", key = \"%s\"},\n", data.name, data.key)
			beginFind = false
		end
		fileData = fileData .. content .. "\n"
		content = file:read("*l")
	end
	file:close()
	local file = io.open(fullName, "w+")
	file:write(fileData)
	file:close()
end
function createCtrlTool:write2PlayerTopModule_delayInitCall(data)
	local fullName = game_path .. "src/app/module/general/PlayerTopModule.lua"
	local file = io.open(fullName, "r+")
	if not file then
		return
	end
	local content = file:read("*l")
	local fileData = ""
	local beginFind = false
	while content do
		if string.find(content, "playerTopModule.delayInitCall") then
			beginFind = true
		end
		if beginFind and content == "}" then
			fileData = fileData .. string.format("    {name = \"%s\"},\n", data.name)
			beginFind = false
		end
		fileData = fileData .. content .. "\n"
		content = file:read("*l")
	end
	file:close()
	local file = io.open(fullName, "w+")
	file:write(fileData)
	file:close()
end
function createCtrlTool:write2PlayerTopModule_resetActivityData(data)
	local fullName = game_path .. "src/app/module/general/PlayerTopModule.lua"
	local file = io.open(fullName, "r+")
	if not file then
		return
	end
	local content = file:read("*l")
	local fileData = ""
	local beginFind = false
	while content do
		if string.find(content, "playerTopModule.resetActivityData") then
			beginFind = true
		end
		if beginFind and content == "}" then
			fileData = fileData .. string.format("    [gActivityTimeActivityID.%s] = {name = \"%s\"},\n", data.activityName, data.name)
			beginFind = false
		end
		fileData = fileData .. content .. "\n"
		content = file:read("*l")
	end
	file:close()
	local file = io.open(fullName, "w+")
	file:write(fileData)
	file:close()
end
function createCtrlTool:write2ClientEventMgr(data)
	local fullName = game_path .. "src/app/common/clientEventMgr.lua"
	local file = io.open(fullName, "r+")
	if not file then
		return
	end
	local content = file:read("*l")
	local fileData = ""
	local beginFind = false
	local beginFind2 = false
	while content do
		if string.find(content, "local commonActivityIDList") then
			beginFind = true
		end
		if beginFind and string.find(content, "}") then
			fileData = fileData .. string.format("        gActivityTimeActivityID.%s,\n", data.activityName)
			beginFind = false
		end
		if string.find(content, "local singleClickEventConfig") then
			beginFind2 = true
		end
		if beginFind2 and content == "        }" then
			local baseStr = string.format("[gActivityTimeActivityID.%s] = {viewName = \"%s\", checkIsOpen = true, checkCastleLv = CASTLE_LV6_LIMITED, isFgui = true},", data.activityName, data.panelName)
			fileData = fileData .. string.format("            %s\n", baseStr)
			beginFind2 = false
		end
		fileData = fileData .. content .. "\n"
		content = file:read("*l")
	end
	file:close()
	local file = io.open(fullName, "w+")
	file:write(fileData)
	file:close()
end
function createCtrlTool:write2ActivityDef(data)
	local fullName = game_path .. "src/app/constdef/activityDef.lua"
	local file = io.open(fullName, "r+")
	if not file then
		return
	end
	local content = file:read("*l")
	local fileData = ""
	local beginFind = false
	while content do
		if string.find(content, "gActivityTimeActivityID = {") then
			beginFind = true
		end
		if beginFind and string.find(content, "}") then
			fileData = fileData .. string.format("    %s\n", data.activityStr)
			beginFind = false
		end
		fileData = fileData .. content .. "\n"
		content = file:read("*l")
	end
	file:close()
	local file = io.open(fullName, "w+")
	file:write(fileData)
	file:close()
end
function createCtrlTool:write2CmdDef(data)
	local fullName = game_path .. "src/app/constdef/cmdDef.lua"
	local file = io.open(fullName, "r+")
	if not file then
		return
	end
	local content = file:read("*l")
	local fileData = ""
	local beginFind = false
	while content do
		if string.find(content, "gCmd = {") then
			beginFind = true
		end
		if beginFind and string.find(content, "}") then
			fileData = fileData .. string.format([[

    -- %s
]], data[1].mark)
			fileData = fileData .. string.format("    %s = \"%s\",\n", data[1].key, data[1].value)
			for i = 2, #data do
				fileData = fileData .. string.format("        %s = \"%s\", -- %s\n", data[i].key, data[i].value, data[i].mark)
			end
			beginFind = false
		end
		fileData = fileData .. content .. "\n"
		content = file:read("*l")
	end
	file:close()
	local file = io.open(fullName, "w+")
	file:write(fileData)
	file:close()
end
function createCtrlTool:write2NotifyCmdDef(data)
	local fullName = game_path .. "src/app/constdef/cmdDef.lua"
	local file = io.open(fullName, "r+")
	if not file then
		return
	end
	local content = file:read("*l")
	local fileData = ""
	local beginFind = false
	while content do
		if string.find(content, "CMD_NOTIFY_MODULE") then
			beginFind = true
		end
		if beginFind and string.find(content, "") then
			content = content .. "\n" .. file:read("*l")
			if string.find(content, "NOTIFY_CLICKPRAISE_INFO") then
				fileData = fileData .. string.format([[
        %s = "%s",

]], data.key, data.value)
				beginFind = false
			end
		end
		fileData = fileData .. content .. "\n"
		content = file:read("*l")
	end
	file:close()
	local file = io.open(fullName, "w+")
	file:write(fileData)
	file:close()
end
function createCtrlTool:write2NotifyIDDef(data)
	local fullName = game_path .. "src/app/constdef/notifyIDDef.lua"
	local file = io.open(fullName, "r+")
	if not file then
		return
	end
	local content = file:read("*l")
	local fileData = ""
	local beginFind = false
	while content do
		if string.find(content, "gNotifyID = {") then
			beginFind = true
		end
		if beginFind and string.find(content, "}") then
			fileData = fileData .. string.format("    %s = \"%s\",\n", data.key, data.value)
			beginFind = false
		end
		fileData = fileData .. content .. "\n"
		content = file:read("*l")
	end
	file:close()
	local file = io.open(fullName, "w+")
	file:write(fileData)
	file:close()
end
function createCtrlTool:write2NotifyCtrl(data)
	local fullName = game_path .. "src/app/module/notifyCtrl.lua"
	local file = io.open(fullName, "r+")
	if not file then
		return
	end
	local content = file:read("*l")
	local fileData = ""
	local beginFind = false
	while content do
		if string.find(content, "local notifyMsgConfig") then
			beginFind = true
		end
		if beginFind and content == "}" then
			fileData = fileData .. string.format("    [gNotifyID.%s] = {cmd = gCmd.CMD_NOTIFY_MODULE, subcmd = gCmd.%s},\n", data.key, data.value)
			beginFind = false
		end
		fileData = fileData .. content .. "\n"
		content = file:read("*l")
	end
	file:close()
	local file = io.open(fullName, "w+")
	file:write(fileData)
	file:close()
end
function createCtrlTool:createNotify(config)
	createCtrlTool = nil
	;(nil).key = config.cmdKey
	local (nil).value, notifyCmdDef = config.cmdValue, nil
	createCtrlTool:write2NotifyCmdDef(notifyCmdDef)
	createCtrlTool = createCtrlTool.write2NotifyCmdDef
	createCtrlTool.write2NotifyCmdDef.key = config.idKey
	local createCtrlTool.write2NotifyCmdDef.value, notifyIDDef = config.idValue, createCtrlTool.write2NotifyCmdDef
	createCtrlTool:write2NotifyIDDef(notifyIDDef)
	createCtrlTool = createCtrlTool.write2NotifyIDDef
	createCtrlTool.write2NotifyIDDef.key = config.idKey
	local createCtrlTool.write2NotifyIDDef.value, notifyCtrl = config.cmdKey, createCtrlTool.write2NotifyIDDef
	createCtrlTool:write2NotifyCtrl(notifyCtrl)
end
function createCtrlTool:initNormalActivityConfig(config)
	local activity = config.activity
	_ENV = nil
	;(nil).activityName = activity.key
	local (nil).panelName, clientEventMgr = activity.panelName or string.format("Activity_%s_Main", activity.value), nil
	createCtrlTool:write2ClientEventMgr(clientEventMgr)
	_ENV = createCtrlTool.write2ClientEventMgr
	local createCtrlTool.write2ClientEventMgr.activityStr, activityDef = string.format("%s = %s, -- %s", activity.key, activity.value, activity.mark), createCtrlTool.write2ClientEventMgr
	createCtrlTool:write2ActivityDef(activityDef)
	createCtrlTool:write2CmdDef(config.cmd)
	local notify = config.notify
	if notify and next(notify) then
		createCtrlTool:createNotify(config.notify)
	end
	local cmd = config.cmd
	_ENV = createCtrlTool
	createCtrlTool.name = activity.ctrlName or string.format("activity_%s_", activity.value)
	createCtrlTool.notifyID, _ENV, createCtrlTool.cmdMark, _ENV, createCtrlTool.cmd, _ENV, createCtrlTool.module = cmd[1].key, cmd[1].key, cmd[1].key, cmd[1].key, cmd[1].key, cmd[1].key, cmd[1].key
	createCtrlTool.needDump = true
	createCtrlTool.folder = "activity"
	createCtrlTool.write2Include = true
	createCtrlTool.write2PlayerTopModule = true
	createCtrlTool.mark = activity.mark
	createCtrlTool.initClientData = config.initClientData
	createCtrlTool.ctrlServerKey = config.ctrlServerKey
	createCtrlTool.resetActivityData = config.resetActivityData
	local createCtrlTool.activityName, ctrl = activity.key, createCtrlTool
	for i = 2, #cmd do
		table.insert(ctrl.cmd, cmd[i].key)
		local mark = cmd[i].mark or ""
		if mark ~= "" then
			ctrl.cmdMark[i - 1] = mark
		end
	end
	if notify and next(notify) then
		table.insert(ctrl.notifyID, notify.idKey)
	end
	createCtrlTool:begin(ctrl)
	SoraDShowMsgTip("生成文件成功")
end
function createCtrlTool:createNormalActivity(...)
	createCtrlTool, createCtrlTool = nil, nil
	;(nil).key = "NORMAL_ACTIVITY_9001700"
	;(nil).value = "9001700"
	createCtrlTool, createCtrlTool, (nil).activity, (nil).mark = nil, nil, nil, "开斋礼花"
	;(nil).key = "CMD_EIDAL_SALUTE_MODULE"
	;(nil).value = "2395"
	createCtrlTool, (nil)[1], (nil).mark = nil, nil, "开斋礼花"
	;(nil).key = "REQ_EIDAL_SALUTE_INIT"
	;(nil).value = "1"
	createCtrlTool, (nil)[2], (nil).mark = nil, nil, ""
	;(nil).key = "REQ_EIDAL_SALUTE_QUEST_REWARD"
	;(nil).value = "2"
	createCtrlTool, (nil)[3], (nil).mark = nil, nil, "领取任务奖励"
	;(nil).key = "REQ_EIDAL_SALUTE_MAKE"
	;(nil).value = "3"
	createCtrlTool, (nil)[4], (nil).mark = nil, nil, "制作礼花"
	;(nil).key = "REQ_EIDAL_SALUTE_GIVE"
	;(nil).value = "4"
	createCtrlTool, (nil)[5], (nil).mark = nil, nil, "赠送礼花"
	;(nil).key = "REQ_EIDAL_SALUTE_LET_OFF"
	;(nil).value = "5"
	createCtrlTool, (nil).cmd, (nil)[6], (nil).mark = nil, nil, nil, "燃放礼花"
	;(nil).cmdKey = "NOTIFY_EIDAL_SALUTE"
	;(nil).cmdValue = "669"
	;(nil).idKey = "EIDAL_SALUTE"
	;(nil).notify, (nil).idValue = nil, "NOTIFY_EIDAL_SALUTE"
	local config
	createCtrlTool:initNormalActivityConfig(config)
end
return createCtrlTool
