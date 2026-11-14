local gamemodulec = include("GameModule")
local msgCtrl = include("msgCtrl")
local kingdomCtrl = class("kingdomCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
function kingdomCtrl:ctor(properties)
	kingdomCtrl.super.ctor(self, properties)
	self:resetData()
end
function kingdomCtrl:resetData()
	self.kingdomList, _UPVALUE0_, self.kingdomNum = nil, nil, 0
	self.handle_notify = nil
end
function kingdomCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_KINGDOM_MODULE, gCmd.REQ_GET_KINGDOM_LIST, handler(self, self.getKingdomListRsp))
end
function kingdomCtrl:Logout()
	self:resetData()
end
function kingdomCtrl:setKingdomList(klist)
	self.mergedKingdomMap, _ENV, self.kingdomList, _ENV, self.baseKingdomList = nil, nil, nil, nil, klist
	for i, v in ipairs(klist) do
		if not v.ismerged then
			table.insert(self.kingdomList, v)
		else
			self.mergedKingdomMap[v.kid] = v
		end
	end
	dump(self.mergedKingdomMap, "kingdomCtrl:setKingdomList")
end
function kingdomCtrl:getKingdomList()
	return self.kingdomList
end
function kingdomCtrl:getKindomName(kid)
	if not self.mergedKingdomMap[kid] then
		_UPVALUE0_ = self.mergedKingdomMap[kid]
		self.mergedKingdomMap[kid].kname = ""
	end
	return self.mergedKingdomMap[kid].kname
end
function kingdomCtrl:getBaseKingdomList()
	return self.baseKingdomList
end
function kingdomCtrl:getIsKingdomMerged(kid)
	_UPVALUE2_ = nil
	;(nil)[1] = self.mergedKingdomMap
	;(nil)[2] = kid
	dump(nil, "self.mergedKingdomMap", 10)
	return self.mergedKingdomMap[kid] or false
end
function kingdomCtrl:getKingdomNum()
	if self.kingdomNum <= 0 then
		self.kingdomNum = 0
		for k, v in ipairs(self.baseKingdomList) do
			if v.kid and v.kid < GAME_KINGDOM_ID_ASSIGN.LEGEND.START then
				self.kingdomNum = self.kingdomNum + 1
			end
		end
	end
	return self.kingdomNum
end
function kingdomCtrl:isFoundKingdomID(kid)
	local ret = false
	local kingdom
	for k, v in pairs(self.kingdomList) do
		if kid == v.kid then
			ret = true
			kingdom = v
			break
		end
	end
	return ret, kingdom
end
function kingdomCtrl:getKingdomLevel(kid)
	local ret, kingdom = self:isFoundKingdomID(kid)
	if not ret then
		return 0
	end
	return kingdom.kingdomLevel
end
function kingdomCtrl:reqGetKingdomList(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_KINGDOM_MODULE, gCmd.REQ_GET_KINGDOM_LIST, nil, ...)
end
function kingdomCtrl:getKingdomListRsp(content)
	dump(content, "kingdomCtrl:getKingdomListRsp", 10)
	local err = content.err
	if err == gErrDef.Err_None then
		local klist = content.data.retdata
		self:setKingdomList(klist)
	else
	end
end
function kingdomCtrl:initClientData(data)
	self:setKingdomList(data)
	self:registerNotify()
	self:reqGetKingdomList()
end
function kingdomCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.KINGDOM_LIST, handler(self, self.updateKingdomList))
end
function kingdomCtrl:updateKingdomList(event)
	local data = event.data
	for k, v in pairs(data) do
		if v.kid >= GAME_KINGDOM_ID_ASSIGN.LEGEND.START and v.kid <= GAME_KINGDOM_ID_ASSIGN.LEGEND.END then
			for i = #self.kingdomList, 1, -1 do
				local kcell = self.kingdomList[i]
				if kcell.kid >= GAME_KINGDOM_ID_ASSIGN.LEGEND.START and kcell.kid <= GAME_KINGDOM_ID_ASSIGN.LEGEND.END then
					if v.uname then
						serviceFunctions.deepMerge(kcell, v)
						break
					end
					kcell.uname = nil
					kcell.uid = nil
					kcell.ukid = nil
					kcell.aid = nil
					kcell.aname = nil
					kcell.aabbr = nil
					kcell.aflag = nil
					break
				end
			end
			local kcell
			_ENV = -1
			;(-1).msg = "MESSAGE_SERVER_KINGDOMWAR_KINGDOMNAME_CHANGED"
			;(-1).kid = v.kid
			;(-1).kInfo = kcell
			SoraDSendMessage(-1)
		else
			local kid = v.kid
			local kname = v.kname
			local uid = v.uid
			local uname = v.uname
			local flagid = v.flagid
			local status = v.status
			local palaceModel = v.palaceModel
			local hostKid = v.hostKid
			local fire = v.fire
			local kingdomLevel = v.kingdomLevel
			local kingdomTitle = v.kingdomTitle
			local legendForSepKingdomTitle = v.legendForSepKingdomTitle
			local kInfo
			for _, kcell in pairs(self.kingdomList) do
				if kcell.kid < GAME_KINGDOM_ID_ASSIGN.LEGEND.START or kcell.kid > GAME_KINGDOM_ID_ASSIGN.LEGEND.END then
					if kcell.kid == kid then
						if kname then
							kcell.kname = kname
						end
						kcell.uid = uid
						kcell.uname = uname
						if flagid then
							kcell.flagid = flagid
						end
						if status then
							kcell.status = status
						end
						if palaceModel then
							kcell.palaceModel = palaceModel
						end
						if hostKid then
							kcell.hostKid = hostKid
						end
						if fire then
							kcell.fire = fire
						end
						if kingdomLevel then
							kcell.kingdomLevel = kingdomLevel
						end
						if kingdomTitle then
							kcell.kingdomTitle = kingdomTitle
						end
						if legendForSepKingdomTitle then
							kcell.legendForSepKingdomTitle = legendForSepKingdomTitle
						end
						kcell.atlantisTitle = v.atlantisTitle
						kInfo = kcell
					end
					local bestKingdom = v.bestKingdom
					if bestKingdom and kcell.kid == bestKingdom.kid then
						kcell.bestKingdom = bestKingdom
						kInfo = kcell
					end
				end
			end
			_ENV = pairs(self.kingdomList)
			pairs(self.kingdomList).msg = "MESSAGE_SERVER_KINGDOMWAR_KINGDOMNAME_CHANGED"
			pairs(self.kingdomList).kid = kid
			pairs(self.kingdomList).kInfo = kInfo
			SoraDSendMessage(pairs(self.kingdomList))
			_ENV = pairs(self.kingdomList)
			pairs(self.kingdomList).msg = "MESSAGE_SERVER_KINGDOMWAR_FLAG_CHANGED"
			pairs(self.kingdomList).kid = kid
			pairs(self.kingdomList).kInfo = kInfo
			SoraDSendMessage(pairs(self.kingdomList))
			_ENV = pairs(self.kingdomList)
			pairs(self.kingdomList).msg = "MESSAGE_SERVER_KINGDOMWAR_KINGDOM_STATUS"
			pairs(self.kingdomList).kid = kid
			pairs(self.kingdomList).kInfo = kInfo
			SoraDSendMessage(pairs(self.kingdomList))
			_ENV = pairs(self.kingdomList)
			pairs(self.kingdomList).msg = "MESSAGE_SERVER_KINGDOMWAR_KINGDOM_LV_CHANGE"
			pairs(self.kingdomList).kid = kid
			pairs(self.kingdomList).kInfo = kInfo
			SoraDSendMessage(pairs(self.kingdomList))
		end
	end
	_ENV = pairs(data)
	pairs(data).msg = "MESSAGE_SERVER_KINGDOMWAR_KINGDOMWAR_STATECHANGED"
	SoraDSendMessage(pairs(data))
end
function kingdomCtrl:getPalaceModelByKid(kid)
	local ret = 1
	for k, v in pairs(self.kingdomList) do
		if kid == v.kid then
			ret = ret.palaceModel
			break
		end
	end
	return ret
end
function kingdomCtrl:isOccupy(kid)
	for _, kcell in pairs(self.kingdomList) do
		if kcell.kid == kid and kcell.hostKid and kcell.hostKid ~= kid then
			return true
		end
	end
	return false
end
function kingdomCtrl:isFire(kid)
	for _, kcell in pairs(self.kingdomList) do
		if kcell.kid == kid and kcell.fire and kcell.fire == gServerFireStatus.fire then
			return true
		end
	end
	return false
end
function kingdomCtrl:getCanMoveOut(kid)
	local ret, kingdom = self:isFoundKingdomID(kid)
	if not ret then
		return false
	end
	return kingdom.canMoveOut
end
function kingdomCtrl:getKindomPalaceModelIcon(kid)
	local palaceModel = 1
	local kingdomList = self:getBaseKingdomList()
	if kingdomList[tonumber(kid)] then
		palaceModel = kingdomList[tonumber(kid)].palaceModel or 1
	end
	local palaceInfoRead = include("palaceInfoRead")
	return palaceInfoRead.getIcon(palaceModel)
end
function kingdomCtrl:getKindomPalaceModelImg(kid)
	local palaceModel = 1
	local kingdomList = self:getBaseKingdomList()
	if kingdomList[tonumber(kid)] then
		palaceModel = kingdomList[tonumber(kid)].palaceModel or 1
	end
	local palaceInfoRead = include("palaceInfoRead")
	return palaceInfoRead.getImg(palaceModel)
end
return kingdomCtrl
