local _ENV, msgCtrl
local _ENV, dispatch
function msgCtrl.register(cmd, subcmd, cb)
	if cmd == nil or subcmd == nil or "function" ~= type(cb) then
		return
	end
	assert(cmd, "register the msg failed! the cmd is nil")
	assert(subcmd, "register the msg failed! the subcmd is nil")
	assert("function" == type(cb), "register the msg failed! the callback is not a function.")
	if not dispatch[cmd] then
		_ENV = dispatch[cmd]
	end
	dispatch[cmd] = dispatch[cmd]
	if dispatch[cmd][subcmd] then
		return
	end
	assert(not dispatch[cmd][subcmd], "register the msg failed! msg already registered.cmd=" .. cmd .. ",subcmd=" .. subcmd)
	dispatch[cmd][subcmd] = cb
end
function msgCtrl.unregister(cmd, subcmd)
	if cmd == nil or subcmd == nil then
		return
	end
	assert(cmd, "register the msg failed! the cmd is nil")
	assert(subcmd, "register the msg failed! the subcmd is nil")
	if dispatch[cmd] and dispatch[cmd][subcmd] then
		dispatch[cmd][subcmd] = nil
	end
end
function msgCtrl.clean()
	dispatch = nil
end
function msgCtrl.handle(rsp)
	local content = rsp.content
	if content then
		qaDump(content, "receive", 10)
		local err = tostring(content.err)
		if err and "nil" ~= err and gErrDef.Err_None ~= err then
			local msgNotice = include("msgNotice")
			msgNotice.rspNotice(rsp.content)
		end
		local cmd = content.cmd or "nil"
		local subcmd = content.subcmd or "nil"
		local time = content.time
		if type(time) == "number" then
			local gametop = gModuleMgr.getObject("gametop")
			local timeCtrl = gametop.playertop_:getModule("timeCtrl")
			timeCtrl:updateServerTime(time)
		end
		local cb = dispatch[cmd] and dispatch[cmd][subcmd]
		if cb then
			cb(content)
		else
			print("handle the msg failed! msg mot found,cmd=" .. cmd .. ",subcmd=" .. subcmd)
		end
	else
		print("handle the msg failed! content is nil")
	end
end
return msgCtrl
