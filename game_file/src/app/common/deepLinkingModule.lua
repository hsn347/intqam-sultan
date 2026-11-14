deepLinking, _ENV = nil, nil
deepLinking.ios, _ENV = nil, nil
deepLinking.android, _ENV = nil, nil
deepLinking.workingSheet = require("app." .. LocalTblPath .. ".config_client.deepLinking_config")
deepLinking.url = ""
deepLinking.isWaiting = false
function deepLinking.init(...)
	CS.Sultan.Manager.DeepLinkingManager:GetInstance()
end
function deepLinking.req4Link(needWaiting)
end
function deepLinking.getUrlAndRun(...)
end
function deepLinking.log2server(_host, _event, _eventID, _otherArg)
	_ENV = nil
	;(nil).host = _host
	;(nil).event = _event
	;(nil).eventID = _eventID
	;(nil).otherArg = _otherArg
	userSDKManager.logEvent(gSDKDef.TDonEvent.ad_deeplinking, nil)
end
function deepLinking.handlURL(_url)
	local check4fun = function(url)
		local urlPart = SoraDStringsSplit(url, "://")
		local _scheme = urlPart[1]
		local pathPart = SoraDStringsSplit(urlPart[2] or "", "/")
		local _host = pathPart[1]
		local argPart = SoraDStringsSplit(pathPart[2] or "", "?")
		local _param = argPart[1]
		local _argList = argPart[2] or ""
		print("_scheme:", _scheme, "_host:", _host, "_param:", _param)
		if _scheme == "" or _host == "" or _param == "" then
			return false
		end
		if next(deepLinking.workingSheet) ~= nil then
			for k, v in pairs(deepLinking.workingSheet) do
				if v.scheme == _scheme and v.host == _host and v.param == _param then
					print("argList:", _argList)
					_ENV = "argList:"
					;("argList:").host = _host
					;("argList:").param = _param
					;("argList:").argList = _argList
					return v.work, "argList:"
				end
			end
		end
		return false
	end
	if _url ~= "" then
		print("_url", _url)
		local wFun, args = check4fun(string.rtrim(_url))
		if wFun then
			wFun(args)
		end
		deepLinking.url = ""
	else
		print("url is nil")
	end
end
function deepLinking.splitTheArgList(arglist)
	if arglist ~= "" then
		local tbl = SoraDStringsSplit(arglist, "&")
		local _ENV, reTbl = arglist, arglist
		if next(tbl) ~= nil then
			for i, v in ipairs(tbl) do
				local tmpTbl = SoraDStringsSplit(v, "=")
				reTbl[tostring(tmpTbl[1])] = tmpTbl[2] or ""
			end
		end
		return reTbl
	else
		_ENV = SoraDStringsSplit(arglist, "&")
		return (SoraDStringsSplit(arglist, "&"))
	end
end
function DeepLinking_CallBackisDeepLinking(deepLinkingUrl)
	print("deepLinkingUrl", deepLinkingUrl)
	deepLinking.url = deepLinkingUrl or ""
	deepLinking.handlURL(deepLinking.url)
end
