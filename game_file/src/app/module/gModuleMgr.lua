gModuleMgr, _ENV = nil, nil
gModuleMgr.objects, _ENV = nil, nil
gModuleMgr.mgrs, _ENV = nil, nil
function gModuleMgr.init()
	if not gModuleMgr.getObject("user") then
		_ENV = "User"
		;("User").id = "user"
		local user = include("User").new("User")
		gModuleMgr.setObject("user", user)
	end
	if not gModuleMgr.getObject("serverproxy") then
		_ENV = "ServerProxy"
		;("ServerProxy").id = "serverproxy"
		local serverproxy = include("ServerProxy").new("ServerProxy")
		gModuleMgr.setObject("serverproxy", serverproxy)
	end
	if not gModuleMgr.getObject("gametop") then
		_ENV = "GameTop"
		;("GameTop").id = "gametop"
		local gametop = include("GameTop").new("GameTop")
		gModuleMgr.setObject("gametop", gametop)
	end
	if not gModuleMgr.getObject("timerList") then
		_ENV = "timerList"
		;("timerList").id = "timerList"
		local timerlist = include("timerList").new("timerList")
		gModuleMgr.setObject("timerList", timerlist)
	end
	if not gModuleMgr.getObject("permissionCtrl") then
		_ENV = "permissionCtrl"
		;("permissionCtrl").id = "permissionCtrl"
		local permissionCtrl = include("permissionCtrl").new("permissionCtrl")
		gModuleMgr.setObject("permissionCtrl", permissionCtrl)
	end
end
function gModuleMgr.refresh()
	for k, v in pairs(gModuleMgr.objects) do
		gModuleMgr.objects[k] = nil
	end
	for k, v in pairs(gModuleMgr.mgrs) do
		gModuleMgr.mgrs[k] = nil
	end
end
function gModuleMgr.setObject(id, object)
	if not gModuleMgr.objects[id] then
		gModuleMgr.objects[id] = object
	end
end
function gModuleMgr.getObject(id)
	return gModuleMgr.objects[id]
end
function gModuleMgr.sharedMgr(mgrname)
	local mgr = gModuleMgr.mgrs[mgrname]
	if mgr == nil then
		local MgrTemplate = include(mgrname)
		_ENV = nil
		;(nil).id = mgrname
		mgr = MgrTemplate.new(nil)
		gModuleMgr.mgrs[mgrname] = mgr
	end
	return mgr
end
function gModuleMgr.getGameState()
	if gModuleMgr.gameData_ then
		return gModuleMgr.gameData_
	end
	local gamestate = require(cc.PACKAGE_NAME .. ".api.GameState")
	gamestate.init(gModuleMgr.gameStateCB, "localdata.koh", "this is a super game")
	gamestate.load()
	return gModuleMgr.gameData_
end
function gModuleMgr.saveGameState()
	local gamestate = require(cc.PACKAGE_NAME .. ".api.GameState")
	gamestate.init(gModuleMgr.gameStateCB, "localdata.koh", "this is a super game")
	gamestate.save(gModuleMgr.gameData_)
end
function gModuleMgr.gameStateCB(info)
	if info.name == "init" then
		printf("game state filename =%s ", info.filename)
	elseif info.name == "load" then
		if info.errorCode then
			printf("game state errorcode=%d", info.errorCode)
			gModuleMgr.gameData_, _ENV = "game state errorcode=%d", "game state errorcode=%d"
			return
		end
		gModuleMgr.gameData_ = info.values
	else
		printf("game state saved file")
		return info.values
	end
end
return gModuleMgr
