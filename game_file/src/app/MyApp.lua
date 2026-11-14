require("app.includes.requireManager")
local MyApp = class("MyApp", cc.mvc.AppBase)
function MyApp:ctor()
	MyApp.super.ctor(self)
end
function MyApp:run()
	print("开始游戏")
	local gameName = "ROS"
	if userSDKManager.isAR() then
		gameName = "KOH"
	end
	PlistDataManager:getInstance():initData("res/plist_config.conf")
	dumpInit()
	local criwareAudioEngine = require("app.common.criwareAudioEngine")
	_G.AudioEngine = criwareAudioEngine
	_G.AudioEngine.init()
	self:enterScene("MainScene")
	self:quickDevelop_()
	if device.platform == "mac" or userSDKManager and (userSDKManager.isBeta() or userSDKManager.isReportError() or userSDKManager.isGameDevelop()) then
		CS.Sultan.Init.GameServices.initSRDebug()
		SoraDOpenConsole()
	end
end
function debugTraceback(msg)
	local traceback = debug.traceback(10)
	print(msg, traceback)
	return traceback
end
local getAllRequiredPathInProject = function()
	local _ENV, result
	local i = 1
	for path, v in pairs(package.loaded) do
		if string.find(path, "^app%.") then
			result[i] = path
			i = i + 1
		end
	end
	return result
end
local lastModifyTime = os.time()
function MyApp:quickDevelop_()
	if DEBUG > 0 and device.platform == "mac" then
		local SRC_PATH = "../Game/LuaScripts/src/"
		local lfs = require("lfs")
		local function findModifyLua_(path, paths)
			if not string.endwith(path, "/") then
				path = path .. "/"
			end
			if not paths then
				paths, _ENV = path, path
			end
			for entry in lfs.dir(path) do
				if entry ~= "." and entry ~= ".." and not string.startwith(entry, "%.") then
					local fileName = path .. entry
					local attr = lfs.attributes(fileName)
					if attr.mode == "directory" then
						findModifyLua_(fileName, paths)
					else
						local modification = attr.modification
						if modification > lastModifyTime and string.endwith(fileName, "%.lua") then
							local luafile = string.gsub(fileName, SRC_PATH, "")
							luafile = string.gsub(luafile, ".lua", "")
							luafile = string.gsub(luafile, "/", ".")
							table.insert(paths, luafile)
						end
					end
				end
			end
			return paths
		end
		local function findChildren_(path, packageRequiredPaths, children)
			if not children then
				children, _ENV = nil, nil
			end
			local pathRequire = require(path)
			if istable(pathRequire) and pathRequire.__cname then
				local pathCName = pathRequire.__cname
				util.each(function(requiredPath)
					local required = require(requiredPath)
					if istable(required) and required.super then
						local parentCName = required.super.__cname
						if parentCName and parentCName == pathCName then
							table.insert(children, requiredPath)
							findChildren_(requiredPath, packageRequiredPaths, children)
						end
					end
				end, packageRequiredPaths)
			end
			return children
		end
		local exceptTheClassFile = function(tbl)
			_ENV = nil
			local (nil)["app.common.clientEventMgr"], ignoreFileName = true, nil
			local _ENV, ret
			for i, v in ipairs(tbl) do
				if not ignoreFileName[v] then
					table.insert(ret, v)
				end
			end
			return ret
		end
		function MyApp:callOpenLua4Dev(refresh)
			local paths = findModifyLua_(SRC_PATH)
			dump(paths, "MyApp:callOpenLua4Dev")
			if table.isnotempty(paths) then
				local findModifyLua_, willClears = table.isnotempty(paths), table.isnotempty(paths)
				local packageRequiredPaths = getAllRequiredPathInProject()
				util.each(function(path, index)
					willClears[path] = findChildren_(path, packageRequiredPaths)
				end, paths)
				local findModifyLua_, package_re_require_paths = util.each, util.each
				util.each(function(children, path)
					printf("[开发调试]更新文件: %s", path)
					table.insert(package_re_require_paths, path)
					if table.isnotempty(children) then
						print("\t\t其子类一同清除:")
						util.each(function(child, index)
							printf("\t\t\t %s", child)
							table.insert(package_re_require_paths, child)
						end, children, true)
					end
				end, willClears, true)
				local uniquePaths = table.unique(package_re_require_paths, true)
				local findModifyLua_, tempClearPathLastPart = package_re_require_paths, package_re_require_paths
				local lastPart
				util.each(function(path)
					local content = CS.LuaManager.readLuaContent(path)
					util.each(function(clearPath, index)
						if tempClearPathLastPart[clearPath] then
						else
							tempClearPathLastPart[clearPath] = lastPart
						end
						if string.find(content, lastPart) then
							printf("\t\t 清除包含:(%s) %s", clearPath, path)
							table.insert(package_re_require_paths, path)
						end
					end, uniquePaths)
				end, packageRequiredPaths)
				package_re_require_paths = table.unique(package_re_require_paths, true)
				package_re_require_paths = exceptTheClassFile(package_re_require_paths)
				util.each(function(path, index)
					package.loaded[path] = nil
				end, package_re_require_paths)
				util.each(function(path, index)
					require(path)
				end, package_re_require_paths)
				if false ~= refresh then
					if #SoraDPanelManager == 0 then
						findModifyLua_ = #SoraDPanelManager
						local (#SoraDPanelManager).isFromLogin, data = true, #SoraDPanelManager
						local scene = display.getRunningScene()
						if scene:currentSceneShowView().__cname == "mainCityView" then
							data.viewType = VIEW_TYPE_CITY
						else
							data.viewType = VIEW_TYPE_MAP
						end
						scene:showView(nil, data)
						print("[开发调试]mainCity已重载")
					else
						SoraDRemoveTopPanelFromManager()
						print("[开发调试]请手工进入先前界面")
					end
				end
			else
				print("[开发调试]未修改过任何lua文件!!!")
			end
			util.resetCSDCatch()
			uiManager:clearCachedInstanceView()
			cocosUIManager:clearCachedInstanceView()
		end
		function MyApp:returnToMainScene4Dev()
			app:callOpenLua4Dev(false)
			app:enterScene("MainScene")
		end
	end
end
return MyApp
