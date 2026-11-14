local GameModule = include("GameModule")
local msgCtrl = include("msgCtrl")
local allianceStrontholdCtrl = class("allianceStrontholdCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
function allianceStrontholdCtrl:ctor(properties)
	allianceStrontholdCtrl.super.ctor(self, properties)
end
function allianceStrontholdCtrl:Logout()
	allianceStrontholdCtrl.super.Logout(self)
	self:resetData()
end
function allianceStrontholdCtrl:resetData()
	self.strongholdList, _UPVALUE0_ = nil, nil
end
function allianceStrontholdCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_STRONTHOLD_LIST, handler(self, self.getStrontholdListRsp))
end
function allianceStrontholdCtrl:reqAllianceStrontholdList()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_STRONTHOLD_LIST, nil)
end
function allianceStrontholdCtrl:getStrontholdListRsp(content)
	dump(content, "allianceStrontholdCtrl:getStrontholdListRsp", 5)
	if gErrDef.Err_None == content.err then
		self.strongholdList = content.rspdata.strongholdList
	end
	_ENV = content.err
	content.err.msg = "MESSAGE_ALLIANCE_STRONTHOLD_BACK"
	SoraDSendMessage(content.err)
end
function allianceStrontholdCtrl:updateBuildData(data)
	self.strongholdList = data
	_ENV = nil
	;(nil).msg = "MESSAGE_ALLIANCE_STRONTHOLD_BACK"
	SoraDSendMessage(nil)
end
function allianceStrontholdCtrl:getStrontholdList()
	return self.strongholdList
end
function allianceStrontholdCtrl:getHoldListByLv()
	local _ENV, holdList
	local allianceStrongholdMineRead = include("allianceStrongholdMineRead")
	local _ENV, buffTypeList = "allianceStrongholdMineRead", "allianceStrongholdMineRead"
	for i = 1, 4 do
		holdList[i], _ENV = nil, nil
		for k, v in pairs(self.strongholdList) do
			if allianceStrongholdMineRead.getGateLv(v.id) == i and v.status == gKingdomWarStatusType.rule and v.statusEndTime > serviceFunctions.systemTime() then
				local buffType = allianceStrongholdMineRead.getGateBuffType(v.id)
				if SoraDisInList(buffType, buffTypeList) then
					v.isActive = false
				else
					v.isActive = true
					table.insert(buffTypeList, buffType)
				end
				local clientCfg = allianceStrongholdMineRead.getGateClientCfg(v.id)
				v.name = i18n(clientCfg.name)
				v.pos = allianceStrongholdMineRead.getGatePos(v.id)
				v.bonus = allianceStrongholdMineRead.getBuffByType(buffType)
				v.png = clientCfg.image
				table.insert(holdList[i], v)
			end
		end
		table.sort(holdList[i], function(a, b)
			return a.statusEndTime < b.statusEndTime
		end)
	end
	return holdList
end
function allianceStrontholdCtrl:getStrongholdBuff()
	local _ENV, strongholdTypeMap
	local _ENV, strongholdBuff
	local allianceStrongholdMineRead = include("allianceStrongholdMineRead")
	for _, v in pairs(self.strongholdList) do
		local buffType = allianceStrongholdMineRead.getGateBuffType(v.id)
		if not SoraDisInList(buffType, strongholdTypeMap) then
			table.insert(strongholdTypeMap, buffType)
		end
	end
	for _, buffType in pairs(strongholdTypeMap) do
		local bufflist, blist = allianceStrongholdMineRead.getBuffByType(buffType)
		if blist and next(blist) then
			for k, v in ipairs(blist) do
				strongholdBuff[v.buffType] = (strongholdBuff[v.buffType] or 0) + v.buffVal
			end
		end
	end
	return strongholdBuff
end
function allianceStrontholdCtrl:getStrongholdBuffByType(effectType)
	local strongholdBuff = self:getStrongholdBuff()
	return strongholdBuff[effectType] or 0
end
return allianceStrontholdCtrl
