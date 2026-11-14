local _ENV, pingModule
local serverproxy = gModuleMgr.getObject("serverproxy")
pingModule.url = "kohlogin.menaapp.net"
_ENV, pingModule.reportUrl = "https://ad.menaapp.net/index.php?s=RecordTime/accept/uid/" .. serverproxy.loginCtrl_.token.user .. "/time/", "https://ad.menaapp.net/index.php?s=RecordTime/accept/uid/" .. serverproxy.loginCtrl_.token.user .. "/time/"
;("https://ad.menaapp.net/index.php?s=RecordTime/accept/uid/" .. serverproxy.loginCtrl_.token.user .. "/time/").total = 0
pingModule.totalMs, ("https://ad.menaapp.net/index.php?s=RecordTime/accept/uid/" .. serverproxy.loginCtrl_.token.user .. "/time/").bout = "https://ad.menaapp.net/index.php?s=RecordTime/accept/uid/" .. serverproxy.loginCtrl_.token.user .. "/time/", 0
pingModule.limitBout = 3
function pingModule.start(...)
	pingModule.ping(...)
end
function pingModule.ping(...)
	local socket = require("socket")
	local xhr = cc.XMLHttpRequest:new()
	local beginControl = true
	local bout = 1
	local bTime = 0
	local onReadyStateChange = function()
		if xhr.readyState == 4 and xhr.status >= 200 and xhr.status < 207 then
			local ping = math.ceil(socket.gettime() * 1000 - bTime)
			print("ping :", math.ceil(socket.gettime() * 1000 - bTime) .. "ms")
			pingModule.totalMs.total = pingModule.totalMs.total + ping
			pingModule.totalMs.bout = pingModule.totalMs.bout + 1
		else
			print("ping : time out > 30000ms")
			pingModule.totalMs.total = pingModule.totalMs.total + 30000
			pingModule.totalMs.bout = pingModule.totalMs.bout + 1
		end
		if pingModule.totalMs.bout < pingModule.limitBout then
			pingModule.ping()
		else
			print("----------------------")
			print("avgPing :", math.ceil(pingModule.totalMs.total / pingModule.totalMs.bout) .. "ms")
			pingModule.reportToServer()
		end
	end
	local ping4Time = function(url)
		math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
		local rndNum = crypto.md5(math.random(), false)
		xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
		xhr:open("GET", "https://" .. url .. "/?" .. rndNum)
		xhr:registerScriptHandler(onReadyStateChange)
		print("---------开始---------")
		xhr:send()
	end
	ping4Time(pingModule.url)
end
function pingModule.reportToServer(...)
	local xhr = cc.XMLHttpRequest:new()
	local reportBack = function()
		if xhr.readyState == 4 and xhr.status >= 200 and xhr.status < 207 then
			print("反馈成功！")
		else
			print("反馈失败！")
		end
		xhr = print
		print.total = 0
		pingModule.totalMs, print.bout = print, 0
		print("---------结束---------")
	end
	xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
	xhr:open("GET", pingModule.reportUrl .. math.ceil(pingModule.totalMs.total / pingModule.totalMs.bout))
	print("反馈:" .. pingModule.reportUrl .. math.ceil(pingModule.totalMs.total / pingModule.totalMs.bout))
	xhr:registerScriptHandler(reportBack)
	xhr:send()
end
return pingModule
