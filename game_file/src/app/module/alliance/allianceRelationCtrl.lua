local GameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local allianceRelationClass = include("allianceRelation")
local allianceRelationCtrl = class("allianceRelation", GameModule)
function allianceRelationCtrl:ctor(properties)
	allianceRelationCtrl.super.ctor(self, properties)
end
function allianceRelationCtrl:EnterGame()
	allianceRelationCtrl.super.EnterGame(self)
	self.ar = allianceRelationClass.new()
	msgCtrl.register(gCmd.CMD_PLAYER_ALLIANCE_MODULE, gCmd.REQ_INVITE_ALLY_ALLIANCE, handler(self, self.onRspInviteAllyAlliance))
	msgCtrl.register(gCmd.CMD_PLAYER_ALLIANCE_MODULE, gCmd.REQ_CANCEL_INVITE_ALLY_ALLIANCE, handler(self, self.onRspCancelInviteAllyAlliance))
	msgCtrl.register(gCmd.CMD_PLAYER_ALLIANCE_MODULE, gCmd.REQ_REJECT_ALLY_ALLIANCE_INVITE, handler(self, self.onRspRejectAllyAllianceInvite))
	msgCtrl.register(gCmd.CMD_PLAYER_ALLIANCE_MODULE, gCmd.REQ_ACCEPT_ALLY_ALLIANCE_INVITE, handler(self, self.onRspAcceptAllyAllianceInvite))
	msgCtrl.register(gCmd.CMD_PLAYER_ALLIANCE_MODULE, gCmd.REQ_ADD_FRIENDLY_ALLIANCE, handler(self, self.onRspAddFriendlyAlliance))
	msgCtrl.register(gCmd.CMD_PLAYER_ALLIANCE_MODULE, gCmd.REQ_ADD_ENEMY_ALLIANCE, handler(self, self.onRspAddEnemyAlliance))
	msgCtrl.register(gCmd.CMD_PLAYER_ALLIANCE_MODULE, gCmd.REQ_DEL_ALLIANCE_RELATION, handler(self, self.onRspDelRelation))
	msgCtrl.register(gCmd.CMD_PLAYER_ALLIANCE_MODULE, gCmd.REQ_GET_ALLIANCE_RELATIONS, handler(self, self.onRspGetRelations))
	msgCtrl.register(gCmd.CMD_PLAYER_ALLIANCE_MODULE, gCmd.REQ_GET_ALLIANCE_RELATION_INVITES, handler(self, self.onRspGetRelationInvites))
	self:registerNotifyHandler()
end
function allianceRelationCtrl:Logout()
	allianceRelationCtrl.super.Logout(self)
	self.ar = nil
end
function allianceRelationCtrl:reqInviteAllyAlliance(aid, ...)
	serverproxy = nil
	;(nil).aid = aid
	serverproxy:Request(gCmd.CMD_PLAYER_ALLIANCE_MODULE, gCmd.REQ_INVITE_ALLY_ALLIANCE, nil, ...)
end
function allianceRelationCtrl:reqCancelInviteAllyAlliance(aid, ...)
	serverproxy = nil
	;(nil).aid = aid
	serverproxy:Request(gCmd.CMD_PLAYER_ALLIANCE_MODULE, gCmd.REQ_CANCEL_INVITE_ALLY_ALLIANCE, nil, ...)
end
function allianceRelationCtrl:reqRejectAllyAllianceInvite(aid, ...)
	serverproxy = nil
	;(nil).aid = aid
	serverproxy:Request(gCmd.CMD_PLAYER_ALLIANCE_MODULE, gCmd.REQ_REJECT_ALLY_ALLIANCE_INVITE, nil, ...)
end
function allianceRelationCtrl:reqAcceptAllyAllianceInvite(aid, ...)
	serverproxy = nil
	;(nil).aid = aid
	serverproxy:Request(gCmd.CMD_PLAYER_ALLIANCE_MODULE, gCmd.REQ_ACCEPT_ALLY_ALLIANCE_INVITE, nil, ...)
end
function allianceRelationCtrl:reqAddFriendlyAlliance(aid, ...)
	serverproxy = nil
	;(nil).aid = aid
	serverproxy:Request(gCmd.CMD_PLAYER_ALLIANCE_MODULE, gCmd.REQ_ADD_FRIENDLY_ALLIANCE, nil, ...)
end
function allianceRelationCtrl:reqAddEnemyAlliance(aid, ...)
	serverproxy = nil
	;(nil).aid = aid
	serverproxy:Request(gCmd.CMD_PLAYER_ALLIANCE_MODULE, gCmd.REQ_ADD_ENEMY_ALLIANCE, nil, ...)
end
function allianceRelationCtrl:reqDelRelation(aid, ...)
	serverproxy = nil
	;(nil).aid = aid
	serverproxy:Request(gCmd.CMD_PLAYER_ALLIANCE_MODULE, gCmd.REQ_DEL_ALLIANCE_RELATION, nil, ...)
end
function allianceRelationCtrl:reqGetRelations(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_PLAYER_ALLIANCE_MODULE, gCmd.REQ_GET_ALLIANCE_RELATIONS, nil, ...)
end
function allianceRelationCtrl:reqGetRelationInvites(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_PLAYER_ALLIANCE_MODULE, gCmd.REQ_GET_ALLIANCE_RELATION_INVITES, nil, ...)
end
function allianceRelationCtrl:onRspInviteAllyAlliance(rsp)
	if rsp.err == gErrDef.Err_None then
		self.ar:addSendInvite(rsp.data.aid, rsp.data.invite)
		SoraDShowMsgTip(i18n("common_text_3090"))
	elseif rsp.err == gErrDef.Err_ALLIANCE_NOT_FOUND_ALLIANCE then
		_ENV = i18n("common_text_3090")
		SoraDShowMsgTip(i18n("common_text_1061", i18n("common_text_3090")))
	elseif rsp.err == gErrDef.Err_ALLIANCE_RELATION_INVITE_SEND_ALREADY then
		_ENV = i18n("common_text_1061", i18n("common_text_3090"))
		SoraDShowMsgTip(i18n("common_text_3113", i18n("common_text_1061", i18n("common_text_3090"))))
	elseif rsp.err == gErrDef.Err_ALLIANCE_RELATION_INVITE_SEND_REJECTED_PERIOD then
		_ENV = i18n("common_text_3113", i18n("common_text_1061", i18n("common_text_3090")))
		SoraDShowMsgTip(i18n("common_text_3087", i18n("common_text_3113", i18n("common_text_1061", i18n("common_text_3090")))))
	elseif rsp.err == gErrDef.Err_ALLIANCE_RELATION_INVITE_SEND_NUM_REACH_MAX then
		_ENV = i18n("common_text_3087", i18n("common_text_3113", i18n("common_text_1061", i18n("common_text_3090"))))
		SoraDShowMsgTip(i18n("notice_0201", i18n("common_text_3087", i18n("common_text_3113", i18n("common_text_1061", i18n("common_text_3090"))))))
	elseif rsp.err == gErrDef.Err_ALLIANCE_RELATION_INVITE_OTHER_RECV_NUM_REACH_MAX then
		_ENV = i18n("notice_0201", i18n("common_text_3087", i18n("common_text_3113", i18n("common_text_1061", i18n("common_text_3090")))))
		SoraDShowMsgTip(i18n("notice_0202", i18n("notice_0201", i18n("common_text_3087", i18n("common_text_3113", i18n("common_text_1061", i18n("common_text_3090")))))))
	end
	_ENV = i18n("notice_0202", i18n("notice_0201", i18n("common_text_3087", i18n("common_text_3113", i18n("common_text_1061", i18n("common_text_3090"))))))
	i18n("notice_0202", i18n("notice_0201", i18n("common_text_3087", i18n("common_text_3113", i18n("common_text_1061", i18n("common_text_3090")))))).msg = "MESSAGE_ALLIANCE_RELATION_DATA_CHANGE"
	i18n("notice_0202", i18n("notice_0201", i18n("common_text_3087", i18n("common_text_3113", i18n("common_text_1061", i18n("common_text_3090")))))).curType = gAllianceRelationType.ALLY
	i18n("notice_0202", i18n("notice_0201", i18n("common_text_3087", i18n("common_text_3113", i18n("common_text_1061", i18n("common_text_3090")))))).err = rsp.err
	SoraDSendMessage(i18n("notice_0202", i18n("notice_0201", i18n("common_text_3087", i18n("common_text_3113", i18n("common_text_1061", i18n("common_text_3090")))))))
end
function allianceRelationCtrl:onRspCancelInviteAllyAlliance(rsp)
	if rsp.err == gErrDef.Err_None then
		self.ar:delSendInvite(rsp.data.aid)
	elseif rsp.err == gErrDef.Err_ALLIANCE_NOT_FOUND_ALLIANCE then
		self.ar:delSendInvite(rsp.data.aid)
		_ENV = nil
		SoraDShowMsgTip(i18n("common_text_1061", nil))
	end
	_ENV = i18n("common_text_1061", nil)
	i18n("common_text_1061", nil).msg = "MESSAGE_ALLIANCE_RELATION_DATA_CHANGE"
	i18n("common_text_1061", nil).err = rsp.err
	SoraDSendMessage(i18n("common_text_1061", nil))
end
function allianceRelationCtrl:onRspRejectAllyAllianceInvite(rsp)
	if rsp.err == gErrDef.Err_None then
		self.ar:delRecvInvite(rsp.data.aid)
	elseif rsp.err == gErrDef.Err_ALLIANCE_NOT_FOUND_ALLIANCE then
		self.ar:delRecvInvite(rsp.data.aid)
		_ENV = nil
		SoraDShowMsgTip(i18n("common_text_1061", nil))
	end
	_ENV = i18n("common_text_1061", nil)
	i18n("common_text_1061", nil).msg = "MESSAGE_ALLIANCE_RELATION_DATA_CHANGE"
	i18n("common_text_1061", nil).err = rsp.err
	SoraDSendMessage(i18n("common_text_1061", nil))
end
function allianceRelationCtrl:onRspAcceptAllyAllianceInvite(rsp)
	if rsp.err == gErrDef.Err_None then
		self.ar:delRecvInvite(rsp.data.aid)
		self.ar:addRelation(rsp.data.aid, rsp.data.relation)
	elseif rsp.err == gErrDef.Err_ALLIANCE_NOT_FOUND_ALLIANCE then
		self.ar:delRecvInvite(rsp.data.aid)
		_ENV = rsp.data.relation
		SoraDShowMsgTip(i18n("common_text_1061", rsp.data.relation))
	elseif rsp.err == gErrDef.Err_ALLIANCE_RELATION_ALLY_NUM_REACH_MAX then
		_ENV = i18n("common_text_1061", rsp.data.relation)
		SoraDShowMsgTip(i18n("notice_0199", i18n("common_text_1061", rsp.data.relation)))
	elseif rsp.err == gErrDef.Err_ALLIANCE_RELATION_OTHER_ALLY_NUM_REACH_MAX then
		_ENV = i18n("notice_0199", i18n("common_text_1061", rsp.data.relation))
		SoraDShowMsgTip(i18n("notice_0200", i18n("notice_0199", i18n("common_text_1061", rsp.data.relation))))
	end
	_ENV = i18n("notice_0200", i18n("notice_0199", i18n("common_text_1061", rsp.data.relation)))
	i18n("notice_0200", i18n("notice_0199", i18n("common_text_1061", rsp.data.relation))).msg = "MESSAGE_ALLIANCE_RELATION_DATA_CHANGE"
	i18n("notice_0200", i18n("notice_0199", i18n("common_text_1061", rsp.data.relation))).err = rsp.err
	SoraDSendMessage(i18n("notice_0200", i18n("notice_0199", i18n("common_text_1061", rsp.data.relation))))
end
function allianceRelationCtrl:onRspAddFriendlyAlliance(rsp)
	if rsp.err == gErrDef.Err_None then
		self.ar:addRelation(rsp.data.aid, rsp.data.relation)
	elseif rsp.err == gErrDef.Err_ALLIANCE_NOT_FOUND_ALLIANCE then
		_ENV = rsp.data.relation
		SoraDShowMsgTip(i18n("common_text_1061", rsp.data.relation))
	end
	_ENV = i18n("common_text_1061", rsp.data.relation)
	i18n("common_text_1061", rsp.data.relation).msg = "MESSAGE_ALLIANCE_RELATION_DATA_CHANGE"
	i18n("common_text_1061", rsp.data.relation).curType = gAllianceRelationType.FRIENDLY
	i18n("common_text_1061", rsp.data.relation).err = rsp.err
	SoraDSendMessage(i18n("common_text_1061", rsp.data.relation))
end
function allianceRelationCtrl:onRspAddEnemyAlliance(rsp)
	if rsp.err == gErrDef.Err_None then
		self.ar:addRelation(rsp.data.aid, rsp.data.relation)
	elseif rsp.err == gErrDef.Err_ALLIANCE_NOT_FOUND_ALLIANCE then
		_ENV = rsp.data.relation
		SoraDShowMsgTip(i18n("common_text_1061", rsp.data.relation))
	end
	_ENV = i18n("common_text_1061", rsp.data.relation)
	i18n("common_text_1061", rsp.data.relation).msg = "MESSAGE_ALLIANCE_RELATION_DATA_CHANGE"
	i18n("common_text_1061", rsp.data.relation).curType = gAllianceRelationType.ENEMY
	i18n("common_text_1061", rsp.data.relation).err = rsp.err
	SoraDSendMessage(i18n("common_text_1061", rsp.data.relation))
end
function allianceRelationCtrl:onRspDelRelation(rsp)
	if rsp.err == gErrDef.Err_None then
		self.ar:delRelation(rsp.data.aid)
		SoraDShowMsgTip(i18n("common_text_3112"))
	elseif rsp.err == gErrDef.Err_ALLIANCE_NOT_FOUND_ALLIANCE then
		self.ar:delRelation(rsp.data.aid)
		_ENV = i18n("common_text_3112")
		SoraDShowMsgTip(i18n("common_text_1061", i18n("common_text_3112")))
	end
	_ENV = i18n("common_text_1061", i18n("common_text_3112"))
	i18n("common_text_1061", i18n("common_text_3112")).msg = "MESSAGE_ALLIANCE_RELATION_DATA_CHANGE"
	i18n("common_text_1061", i18n("common_text_3112")).err = rsp.err
	SoraDSendMessage(i18n("common_text_1061", i18n("common_text_3112")))
end
function allianceRelationCtrl:onRspGetRelations(rsp)
	if rsp.err == gErrDef.Err_None then
		self.ar.data.relationMap = rsp.data.relationMap
		_ENV = rsp.data.relationMap
		rsp.data.relationMap.msg = "MESSAGE_ALLIANCE_RELATION_GET_SUCCESS"
		rsp.data.relationMap.err = rsp.err
		rsp.data.relationMap.data = rsp.data
		SoraDSendMessage(rsp.data.relationMap)
	else
		_ENV = rsp.data.relationMap
		rsp.data.relationMap.msg = "MESSAGE_ALLIANCE_RELATION_GET_SUCCESS"
		rsp.data.relationMap.err = rsp.err
		SoraDSendMessage(rsp.data.relationMap)
	end
end
function allianceRelationCtrl:onRspGetRelationInvites(rsp)
	if rsp.err == gErrDef.Err_None then
		self.ar.data.inviteMap = rsp.data.inviteMap
		_ENV = rsp.data.inviteMap
		rsp.data.inviteMap.msg = "MESSAGE_ALLIANCE_RELATION_INVITES_GET_SUCCESS"
		rsp.data.inviteMap.err = rsp.err
		rsp.data.inviteMap.data = rsp.data
		SoraDSendMessage(rsp.data.inviteMap)
	else
		_ENV = rsp.data.inviteMap
		rsp.data.inviteMap.msg = "MESSAGE_ALLIANCE_RELATION_INVITES_GET_SUCCESS"
		rsp.data.inviteMap.err = rsp.err
		SoraDSendMessage(rsp.data.inviteMap)
	end
end
function allianceRelationCtrl:registerNotifyHandler()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.ALLIANCE_RELATION, handler(self, self.onNotifyMsg))
end
function allianceRelationCtrl:onNotifyMsg(notification)
	print("[INFO] allianceRelationCtrl:onNotifyMsg")
	for _, msg in ipairs(notification.data) do
		if msg.msgType == gAllianceRelationNotifyType.ADD_RELATION then
			self:onNotifyAddRelation(msg)
		elseif msg.msgType == gAllianceRelationNotifyType.DEL_RELATION then
			self:onNotifyDelRelation(msg)
		end
	end
end
function allianceRelationCtrl:onPublishMsg(msg)
	print("[INFO] allianceRelationCtrl:onPublishMsg", msg.msgType)
	if msg.msgType == gAllianceRelationNotifyType.ADD_RELATION then
		self:onNotifyAddRelation(msg)
	elseif msg.msgType == gAllianceRelationNotifyType.DEL_RELATION then
		self:onNotifyDelRelation(msg)
	elseif msg.msgType == gAllianceRelationNotifyType.ADD_RECV_INVITE then
		self:onNotifyAddRecvInvite(msg)
	elseif msg.msgType == gAllianceRelationNotifyType.DEL_RECV_INVITE then
		self:onNotifyDelRecvInvite(msg)
	elseif msg.msgType == gAllianceRelationNotifyType.ADD_SEND_INVITE then
		self:onNotifyAddSendInvite(msg)
	elseif msg.msgType == gAllianceRelationNotifyType.DEL_SEND_INVITE then
		self:onNotifyDelSendInvite(msg)
	elseif msg.msgType == gAllianceRelationNotifyType.UPDATE_TERR_SCORE then
		self:onNotifyUpdateTerrScore(msg)
	end
end
function allianceRelationCtrl:onNotifyAddRelation(msg)
	self.ar:addRelation(msg.aid, msg.data)
	self:notifyMap(msg.aid)
	_ENV = self
	self.msg = "MESSAGE_ALLIANCE_RELATION_DATA_CHANGE"
	SoraDSendMessage(self)
end
function allianceRelationCtrl:onNotifyDelRelation(msg)
	self.ar:delRelation(msg.aid)
	self:notifyMap(msg.aid)
	_ENV = self
	self.msg = "MESSAGE_ALLIANCE_RELATION_DATA_CHANGE"
	SoraDSendMessage(self)
end
function allianceRelationCtrl:onNotifyAddRecvInvite(msg)
	self.ar:addRecvInvite(msg.aid, msg.data)
	self.ar.allyInviteNum = msg.ext
	_ENV = msg.ext
	msg.ext.msg = "MESSAGE_ALLIANCE_RELATION_DATA_CHANGE"
	msg.ext.data = msg.data
	SoraDSendMessage(msg.ext)
	_ENV = msg.ext
	msg.ext.msg = "MESSAGE_GREEN_POINT_UPDATE"
	SoraDSendMessage(msg.ext)
end
function allianceRelationCtrl:onNotifyDelRecvInvite(msg)
	self.ar:delRecvInvite(msg.aid)
	self.ar.allyInviteNum = msg.ext
	_ENV = msg.ext
	msg.ext.msg = "MESSAGE_ALLIANCE_RELATION_DATA_CHANGE"
	msg.ext.data = msg.data
	SoraDSendMessage(msg.ext)
	_ENV = msg.ext
	msg.ext.msg = "MESSAGE_GREEN_POINT_UPDATE"
	SoraDSendMessage(msg.ext)
end
function allianceRelationCtrl:onNotifyAddSendInvite(msg)
	self.ar:addSendInvite(msg.aid, msg.data)
	_ENV = self.ar
	self.ar.msg = "MESSAGE_ALLIANCE_RELATION_DATA_CHANGE"
	self.ar.data = msg.data
	SoraDSendMessage(self.ar)
end
function allianceRelationCtrl:onNotifyDelSendInvite(msg)
	self.ar:delSendInvite(msg.aid)
	_ENV = self.ar
	self.ar.msg = "MESSAGE_ALLIANCE_RELATION_DATA_CHANGE"
	self.ar.data = msg.data
	SoraDSendMessage(self.ar)
end
function allianceRelationCtrl:onNotifyUpdateTerrScore(msg)
	self.ar:updateTerrScore(msg.aid, msg.ext)
	_ENV = self.ar
	self.ar.msg = "MESSAGE_ALLIANCE_RELATION_UPDATE_TERR_SCORE"
	self.ar.score = msg.ext
	SoraDSendMessage(self.ar)
end
function allianceRelationCtrl:notifyMap(aid)
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	kingdomMapCtrl:onAllianceRelationChanged(aid)
	gametop = kingdomMapCtrl
	kingdomMapCtrl.msg = "MESSAGE_WORLD_ALIIANCE_RELATION_CHANGED"
	kingdomMapCtrl.aid = aid
	SoraDSendMessage(kingdomMapCtrl)
end
function allianceRelationCtrl:getAR()
	return self.ar
end
function allianceRelationCtrl:getRelationTypeWith(aid)
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	local mapClassType = kingdomMapCtrl:getKingdomClass()
	local worldMapWarDef = include("worldMapWarDef")
	if worldMapWarDef.isInWarForbidAllianceRelation(mapClassType) then
		return
	end
	if self.ar then
		local relation = self.ar:getRelation(aid)
		if relation then
			return relation.type
		end
	end
end
function allianceRelationCtrl:getTerrScore(aid)
	if aid and 0 < aid then
		local allianceMgr = gametop.playertop_:getModule("allianceMgr")
		if aid == allianceMgr:getOwnAid() then
			local allianceTerritoryAPI = include("allianceTerritoryAPI")
			return allianceTerritoryAPI:getScore()
		elseif self.ar then
			local relation = self.ar:getRelation(aid)
			if relation and relation.aInfo then
				return relation.aInfo.score
			end
		end
	end
end
function allianceRelationCtrl:getAllyInviteNum()
	if self.ar then
		return self.ar.allyInviteNum or 0
	end
	return 0
end
function allianceRelationCtrl:setAllyInviteNum(n)
	if self.ar then
		self.ar.allyInviteNum = n
	end
end
function allianceRelationCtrl:setRelationMap(relationMap)
	if self.ar then
		self.ar.data.relationMap = relationMap
	end
end
function allianceRelationCtrl:clear()
	print("allianceRelationCtrl:clear")
	if self.ar.data.relationMap then
		for aid, relation in pairs(self.ar.data.relationMap) do
			relation.type = nil
			self:notifyMap(tonumber(aid))
		end
	end
	self.ar.data.relationMap, _ENV = pairs(self.ar.data.relationMap)
	self.ar.data.inviteMap, _ENV = pairs(self.ar.data.relationMap)
	self.ar.allyInviteNum = 0
end
return allianceRelationCtrl
