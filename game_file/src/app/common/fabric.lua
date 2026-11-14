local fabric = class("fabric")
local _fabricInstance
function fabric:getInstance()
	if _fabricInstance == nil then
	end
	return _fabricInstance
end
function fabric:ctor()
	self.haveSentDeviceInfo = false
	self.reportPool, _UPVALUE0_, self.haveSentDeviceChangeInfo = nil, nil, nil
end
function fabric:allSet(errorMsg, errorStack, stpMsg, force)
	if not force and not userSDKManager.isFabricEnable then
		return
	end
	xpcall(function()
		self:allSet_imp(errorMsg, errorStack, stpMsg)
	end, function()
		print(debug.traceback(2))
	end)
end
function fabric:allSet_imp(errorMsg, errorStack, stpMsg)
	local md5Key = crypto.md5(errorMsg .. errorStack)
	if self.reportPool[md5Key] then
		self.reportPool[md5Key].count = self.reportPool[md5Key].count + 1
		fabric.reportErrSupport("Exception:" .. md5Key, self.reportPool[md5Key].count)
		self:reportDeviceInfo()
		self:reportDeviceInfoChange()
	else
		local retTbl = self:arrangeStrackInfo(errorStack)
		local _ENV, firstLine = self, self
		firstLine.file = "lua"
		firstLine.func = errorMsg or "????"
		firstLine.funcline = 0
		firstLine.line = 0
		table.insert(retTbl, 1, firstLine)
		_ENV = retTbl
		retTbl.errHead = errorMsg .. " :errMd5 = " .. md5Key
		retTbl.errStack = retTbl
		local jsonData = json.encode(retTbl)
		_ENV = errorMsg .. " :errMd5 = " .. md5Key
		;(errorMsg .. " :errMd5 = " .. md5Key).count = 1
		self.reportPool[md5Key], (errorMsg .. " :errMd5 = " .. md5Key).reportJson = errorMsg .. " :errMd5 = " .. md5Key, jsonData
		self:reportDeviceInfo()
		self:reportDeviceInfoChange()
		if stpMsg then
			fabric.reportErrSupport("Stp:" .. md5Key, stpMsg)
		end
		fabric.reportLuaErr(jsonData)
	end
end
local getUid = function(...)
	local gametop
	if gModuleMgr then
		gametop = gModuleMgr.getObject("gametop")
	end
	local userid
	if gametop and gametop.playertop_ then
		userid = gametop.playertop_:getPlayerID()
	end
	return tostring(userid or "?")
end
local getKid = function(...)
	if not gModuleMgr then
		return "?"
	end
	local gametop = gModuleMgr.getObject("gametop")
	local kid
	if gametop and gametop.playertop_ then
		kid = gametop.playertop_:getKingdomID()
	else
		kid = "?"
	end
	return tostring(kid)
end
function getOnemtID()
	return userSDKManager and userSDKManager.userid or ""
end
local getHotVersion = function(needBaseVersion, preDownloadVersion)
	local hotVersion = "???"
	if device.platform ~= "mac" then
		hotVersion = require("app.game.updateModule.updateModule"):getInstance():getVersion(needBaseVersion, preDownloadVersion)
	end
	return hotVersion
end
fabric.getHotVersion = getHotVersion
function fabric:reportDeviceInfo(...)
	if not self.haveSentDeviceInfo then
		local getHotVersion, reportTbl = self.haveSentDeviceInfo, self.haveSentDeviceInfo
		reportTbl.hotVersion = getHotVersion()
		for k, v in pairs(reportTbl) do
			fabric.reportErrSupport(k, v)
		end
		self.haveSentDeviceInfo = true
	end
end
function fabric:reportDeviceInfoChange(...)
	local getUid, reportTbl
	reportTbl.userID = getUid()
	reportTbl.onemtID = getOnemtID()
	reportTbl.kingDom = getKid()
	if userSDKManager.isBeta() then
		reportTbl.serverInfo = (gSvrConfig.ip or "?") .. ":" .. (gSvrConfig.loginPort or "?")
	end
	local isChangeMd5 = json.encode(reportTbl)
	if self.haveSentDeviceChangeInfo ~= isChangeMd5 then
		for k, v in pairs(reportTbl) do
			fabric.reportErrSupport(k, v)
		end
		fabric.setUserId(reportTbl.userID)
		self.haveSentDeviceChangeInfo = isChangeMd5
	end
end
function fabric:arrangeStrackInfo(indata)
	local tbl = fabric.stringsSplit(indata, "\n")
	local fabric, rangeTbl = indata, indata
	local insertRangeTbl = function(item)
		item.func = item.func or "?"
		item.line = item.line or -1
		item.funcline = item.funcline or -1
		item.file = item.file or "?"
		table.insert(rangeTbl, item)
	end
	for _, v in ipairs(tbl) do
		if string.trim(v) ~= "" then
			local tmp = fabric.stringsSplit(v, "in function")
			local fabric, insertTbl = v, v
			if tmp[1] and tmp[2] then
				local retTbl = fabric.analyzeBlock(tmp[2])
				if retTbl.func then
					insertTbl.func = retTbl.func
				end
				if retTbl.line then
					insertTbl.funcline = retTbl.line
				end
				local innerTbl = fabric.analyzeBlock(tmp[1])
				insertTbl.line = innerTbl.line
				insertTbl.file = innerTbl.file
				insertRangeTbl(insertTbl)
			elseif string.find(v, "in main chunk") then
				local retTbl = fabric.analyzeBlock(v)
				insertTbl.line = retTbl.line
				insertTbl.file = retTbl.file
				insertTbl.func = "main chunk"
				insertRangeTbl(insertTbl)
			elseif string.find(v, "(tail call)") then
				insertTbl.func = "(tail call)"
				insertRangeTbl(insertTbl)
			end
		end
	end
	return rangeTbl
end
function fabric.reportErrSupport(key, val)
	print("key=", key, "val=", val)
	if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.Android or UnityEngine.Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer then
		CSUserSDKManager:setCustomValue(key, val)
	end
end
function fabric.setUserId(id)
	print(id, "userid")
	if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.Android or UnityEngine.Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer then
		CSUserSDKManager:setUserId(id)
	end
end
function fabric.log(data)
	print("fabric.log", data)
	if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.Android or UnityEngine.Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer then
		CSUserSDKManager:logFabric(data)
	end
end
function fabric.reportLuaErr(info)
	print("info=", info)
	if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.Android or UnityEngine.Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer then
		CSUserSDKManager:recordException(info)
	end
end
function fabric.postEvent2Fabric(info)
end
function fabric.analyzeBlock(indata)
	local _ENV, ret
	if string.find(indata, "%[[C]%]") then
		ret.file = "[C]"
	else
		ret.file = string.match(indata, "%/(([%w]+)[%.]([%w]+))")
		ret.line = string.match(indata, ":(%d+)")
		ret.func = string.match(indata, "['](.-)[']")
	end
	return ret
end
function fabric.stringsSplit(s, delim)
	if type(delim) ~= "string" or string.len(delim) <= 0 then
		return
	end
	local start = 1
	local _ENV, t = delim, delim
	while true do
		local pos = string.find(s, delim, start, true)
		if not pos then
			break
		end
		table.insert(t, string.sub(s, start, pos - 1))
		start = pos + string.len(delim)
	end
	table.insert(t, string.sub(s, start))
	return t
end
_G.fabric = fabric:getInstance()
