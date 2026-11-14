local _ENV, network
function network.isLocalWiFiAvailable()
	return cc.Network:isLocalWiFiAvailable()
end
function network.isInternetConnectionAvailable()
	return cc.Network:isInternetConnectionAvailable()
end
function network.isHostNameReachable(hostname)
	if type(hostname) ~= "string" then
		printError("network.isHostNameReachable() - invalid hostname %s", tostring(hostname))
		return false
	end
	return cc.Network:isHostNameReachable(hostname)
end
function network.getInternetConnectionStatus()
	return cc.Network:getInternetConnectionStatus()
end
function network.createHTTPRequest(callback, url, method)
	method = method or "GET"
	if string.upper(tostring(method)) == "GET" then
		method = cc.kCCHTTPRequestMethodGET
	else
		method = cc.kCCHTTPRequestMethodPOST
	end
	return cc.HTTPRequest:createWithUrl(callback, url, method)
end
function network.uploadFile(callback, url, datas)
	assert(datas or datas.fileFieldName or datas.filePath, "Need file datas!")
	local request = network.createHTTPRequest(callback, url, "POST")
	local fileFieldName = datas.fileFieldName
	local filePath = datas.filePath
	local contentType = datas.contentType
	if contentType then
		request:addFormFile(fileFieldName, filePath, contentType)
	else
		request:addFormFile(fileFieldName, filePath)
	end
	if datas.extra then
		for i in ipairs(datas.extra) do
			local data = datas.extra[i]
			request:addFormContents(data[1], data[2])
		end
	end
	request:start()
	return request
end
local parseTrueFalse = function(t)
	t = string.lower(tostring(t))
	if t == "yes" or t == "true" then
		return true
	end
	return false
end
function network.makeCookieString(cookie)
	local _ENV, arr
	for name, value in pairs(cookie) do
		if type(value) == "table" then
			value = tostring(value.value)
		else
			value = tostring(value)
		end
		arr[#arr + 1] = tostring(name) .. "=" .. string.urlencode(value)
	end
	return table.concat(arr, "; ")
end
function network.parseCookie(cookieString)
	local _ENV, cookie
	local arr = string.split(cookieString, "\n")
	for _, item in ipairs(arr) do
		item = string.trim(item)
		if item ~= "" then
			local parts = string.split(item, "\t")
			_ENV = item
			item.domain = parts[1]
			item.access = parseTrueFalse(parts[2])
			item.path = parts[3]
			item.secure = parseTrueFalse(parts[4])
			item.expire = checkint(parts[5])
			item.name = parts[6]
			local item.value, c = string.urldecode(parts[7]), item
			cookie[c.name] = c
		end
	end
	return cookie
end
return network
