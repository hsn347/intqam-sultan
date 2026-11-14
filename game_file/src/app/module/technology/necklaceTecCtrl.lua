local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local necklaceTecCtrl = class("necklaceTecCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local necklaceTechRead = include("necklaceTechRead")
function necklaceTecCtrl:ctor(properties)
	necklaceTecCtrl.super.ctor(self, properties)
	self:resetData()
end
function necklaceTecCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_NECKLACE_TECHNOLOGY_MODULE, gCmd.REQ_NECKLACE_TECHNOLOGY_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_NECKLACE_TECHNOLOGY_MODULE, gCmd.REQ_NECKLACE_TECHNOLOGY_UPLV, handler(self, self.reqUpLvRsp))
end
function necklaceTecCtrl:Logout()
	necklaceTecCtrl.super.Logout(self)
	self:resetData()
end
function necklaceTecCtrl:resetData()
	self.technology, _UPVALUE0_ = nil, nil
end
function necklaceTecCtrl:initClientData(data)
	dump(data, "necklaceTecCtrl:initClientData===")
end
function necklaceTecCtrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_NECKLACE_TECHNOLOGY_MODULE, gCmd.REQ_NECKLACE_TECHNOLOGY_INIT, nil)
end
function necklaceTecCtrl:reqInitRsp(content)
	dump(content, "necklaceTecCtrl:reqInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.technology = content.rspdata.technology
	end
end
function necklaceTecCtrl:sendReqUpLvDataMsg(technologyId)
	serverproxy = nil
	;(nil).technologyId = technologyId
	serverproxy:Request(gCmd.CMD_NECKLACE_TECHNOLOGY_MODULE, gCmd.REQ_NECKLACE_TECHNOLOGY_UPLV, nil)
end
function necklaceTecCtrl:reqUpLvRsp(content)
	dump(content, "necklaceTecCtrl:reqUpLvRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.technology = content.rspdata.technology
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_NECKLACE_TECHNOLOGY_UPDATE"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function necklaceTecCtrl:getTechnoDataByID(technologyID)
	local lv = self.technology[tostring(technologyID)]
	_ENV = tostring(technologyID)
	tostring(technologyID).isOpened = self:isTechOpen(technologyID)
	tostring(technologyID).currentLevel = lv or 0
	local tostring(technologyID).maxLevel, data = necklaceTechRead.getTechMaxLv(technologyID), tostring(technologyID)
	return data
end
function necklaceTecCtrl:isTechOpen(technologyID)
	if technologyID == necklaceTechRead.getInitTechID() then
		return true
	end
	local isOpen = true
	local technologyPre = necklaceTechRead.getTechPre(technologyID, 1)
	if technologyPre and 0 < #technologyPre then
		for _, v in ipairs(technologyPre) do
			local tData = self:getTechnoDataByID(v.tid)
			if not tData or tData and tData.currentLevel < v.level then
				isOpen = false
				break
			end
		end
	end
	return isOpen
end
function necklaceTecCtrl:getTechnoAttrPandect()
	local _ENV, data
	local _ENV, map
	for k, v in pairs(self.technology) do
		local attribute = necklaceTechRead.getTechAttribute(tonumber(k), v)
		_UPVALUE2_ = nil
		;(nil)[1] = "buffType"
		;(nil)[2] = "buffValue"
		local attrList = serviceFunctions.tableFormat(attribute, nil)
		for _, v in ipairs(attrList) do
			map[v.buffType] = (map[v.buffType] or 0) + v.buffValue
		end
	end
	for k, v in pairs(map) do
		_ENV = ipairs(attrList)
		ipairs(attrList).buffType = k
		ipairs(attrList).buffValue = v
		table.insert(data, ipairs(attrList))
	end
	table.sort(data, function(a, b)
		return a.buffType < b.buffType
	end)
	return data, map
end
function necklaceTecCtrl:getBuffVale(buffType)
	local data, map = self:getTechnoAttrPandect()
	return map[buffType] or 0
end
function necklaceTecCtrl:getTechPower()
	local power = 0
	for k, v in pairs(self.technology) do
		power = power + necklaceTechRead.getTechFighting(tonumber(k), v)
	end
	return power
end
return necklaceTecCtrl
