require("app.common.userSDKManager")
local language = userSDKManager.getChannel()
print("===language===", language)
LocalTblPath = "localtb"
ConstDefPath = "constdef"
IsArClient = true
if language ~= "ar" then
	LocalTblPath = "localtb_en"
	ConstDefPath = "constdef_en"
	IsArClient = false
end
LocalFullTblPath = "app." .. LocalTblPath
function SoraDReRequireFile(fullpath)
	package.loaded[fullpath] = nil
	require(fullpath)
end
function SoraDSetTableDefault(table, defaultValue)
end
function SoraDMergeDefineTable(tableMain, table_koh, table_ros, needDefault)
	if IsArClient then
		if needDefault then
			for k, v in pairs(table_ros) do
				tableMain[k] = tableMain.NULL or "NULL"
			end
		end
		for k, v in pairs(table_koh) do
			tableMain[k] = v
		end
	else
		if needDefault then
			for k, v in pairs(table_koh) do
				tableMain[k] = tableMain.NULL or "NULL"
			end
		end
		for k, v in pairs(table_ros) do
			tableMain[k] = v
		end
	end
end
SoraDReRequireFile("app.includes.requireDefine")
SoraDReRequireFile("app.includes.requireCommon")
require("app.common.advertiseCollect")
xpcall(function()
	SoraDReRequireFile("LocalLog")
end, function()
	_G.sendTraceBackLog("Error = LocalLog require\n" .. debug.traceback(), nil, nil, true)
end)
