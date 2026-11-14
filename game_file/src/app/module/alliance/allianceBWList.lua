local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local allianceBWList = class("allianceBWList", gameModule)
local _ENV, RSP = "allianceBWList", "allianceBWList"
function allianceBWList:ctor(properties)
	allianceBWList.super.ctor(self, properties)
	self:resetData()
end
function allianceBWList:resetData()
	self.bwIDList, (nil).whiteList, _UPVALUE0_, (nil).blackList, _UPVALUE0_, _UPVALUE0_, self.bwDetailList, (nil).whiteList, _UPVALUE0_, (nil).blackList, _UPVALUE0_, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
end
function allianceBWList:EnterGame()
	allianceBWList.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_GET_BWIDLIST, handler(self, RSP.getAllianceBWIDListRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_GET_BWDETAILLIST, handler(self, RSP.getAllianceBWDetailListRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_ADD_BWLIST, handler(self, RSP.addAllianceBWListRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_DEL_BWLIST, handler(self, RSP.delAllianceBWListRsp))
end
function allianceBWList:Logout()
	self:resetData()
end
function allianceBWList:setBWIDList(bwIDList)
	self.bwIDList = bwIDList
end
function allianceBWList:setBWDetailList(bwDetailList)
	self.bwDetailList = bwDetailList
end
function allianceBWList:addBWID(aid, bwtype)
	if bwtype == gAllianceBWListType.BLACK then
		self.bwIDList.blackList[tostring(aid)] = true
	else
		self.bwIDList.whiteList[tostring(aid)] = true
	end
end
function allianceBWList:delBWID(aid, bwtype)
	if bwtype == gAllianceBWListType.BLACK then
		self.bwIDList.blackList[tostring(aid)] = nil
	else
		self.bwIDList.whiteList[tostring(aid)] = nil
	end
end
function allianceBWList:isFindBWDetail(aid, bwtype)
	if bwtype == gAllianceBWListType.BLACK then
		for index, v in pairs(self.bwDetailList.blackList) do
			if v.aid == aid then
				return true, index
			end
		end
	else
		for index, v in pairs(self.bwDetailList.whiteList) do
			if v.aid == aid then
				return true, index
			end
		end
	end
end
function allianceBWList:addBWDetail(aid, ainfo, bwtype)
	local isfind, index = self:isFindBWDetail(aid, bwtype)
	if not isfind then
		if bwtype == gAllianceBWListType.BLACK then
			table.insert(self.bwDetailList.blackList, ainfo)
		else
			table.insert(self.bwDetailList.whiteList, ainfo)
		end
	end
end
function allianceBWList:delBWDetail(aid, bwtype)
	local isfind, index = self:isFindBWDetail(aid, bwtype)
	if isfind then
		if bwtype == gAllianceBWListType.BLACK then
			table.remove(self.bwDetailList.blackList, index)
		else
			table.remove(self.bwDetailList.whiteList, index)
		end
	end
end
function allianceBWList:getScoreCost(bwListType)
	local count = table.nums(self.bwIDList.blackList)
	if bwListType == gAllianceBWListType.WHITE then
		count = table.nums(self.bwIDList.whiteList)
	end
	local ret = 100000 * (count * count + 1)
	return ret
end
function allianceBWList:isInBWList(aid)
	if self.bwIDList.blackList[tostring(aid)] then
		return gAllianceBWListType.BLACK
	elseif self.bwIDList.whiteList[tostring(aid)] then
		return gAllianceBWListType.WHITE
	else
		return nil
	end
end
function allianceBWList:getAllianceBWIDList(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_GET_BWIDLIST, nil, ...)
end
function allianceBWList:getAllianceBWDetailList(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_GET_BWDETAILLIST, nil, ...)
end
function allianceBWList:addAllianceBWList(aid, bwListType, ...)
	serverproxy = nil
	;(nil).aid = aid
	;(nil).bwListType = bwListType
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_ADD_BWLIST, nil, ...)
end
function allianceBWList:delAllianceBWList(aid, bwListType, ...)
	serverproxy = nil
	;(nil).aid = aid
	;(nil).bwListType = bwListType
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_DEL_BWLIST, nil, ...)
end
function RSP:getAllianceBWIDListRsp(content)
	if content.err == gErrDef.Err_None then
		local bwIDList = content.data.retdata
		self:setBWIDList(bwIDList)
	else
		print("rsp error: ", content.err)
	end
end
function RSP:getAllianceBWDetailListRsp(content)
	if content.err == gErrDef.Err_None then
		local bwDetailList = content.data.retdata
		self:setBWDetailList(bwDetailList)
	else
		print("rsp error: ", content.err)
	end
	_ENV = "rsp error: "
	;("rsp error: ").msg = "MESSAGE_ALLIACNE_GET_BWLIST_SUCCESS"
	SoraDSendMessage("rsp error: ")
end
function RSP:addAllianceBWListRsp(content)
	if content.err == gErrDef.Err_None then
		local retdata = content.data.retdata
		local aid = retdata.aid
		local ainfo = retdata.ainfo
		local bwtype = retdata.bwtype
		local score = retdata.score
		self:addBWDetail(aid, ainfo, bwtype)
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		local alliance = allianceMgr:getAlliance()
		if alliance then
			alliance:setProperty("bonus", score)
		end
		_ENV = alliance
		alliance.msg = "MESSAGE_ALLIACNE_ADD_BWLIST_SUCCESS"
		alliance.aid = aid
		alliance.bwtype = bwtype
		SoraDSendMessage(alliance)
	else
		print("rsp error: ", content.err)
		_ENV = "rsp error: "
		;("rsp error: ").msg = "MESSAGE_ALLIACNE_ADD_BWLIST_SUCCESS"
		;("rsp error: ").err = content.err
		;("rsp error: ").bwtype = bwtype
		SoraDSendMessage("rsp error: ")
	end
end
function RSP:delAllianceBWListRsp(content)
	if content.err == gErrDef.Err_None then
		local aid = content.data.aid
		local bwListType = content.data.bwListType
		self:delBWDetail(aid, bwListType)
		_ENV = self
		self.msg = "MESSAGE_ALLIACNE_DEL_BWLIST_SUCCESS"
		self.aid = aid
		self.bwtype = bwListType
		SoraDSendMessage(self)
	else
		print("rsp error: ", content.err)
		_ENV = "rsp error: "
		;("rsp error: ").msg = "MESSAGE_ALLIACNE_DEL_BWLIST_SUCCESS"
		;("rsp error: ").err = content.err
		;("rsp error: ").bwtype = bwListType
		SoraDSendMessage("rsp error: ")
	end
end
return allianceBWList
