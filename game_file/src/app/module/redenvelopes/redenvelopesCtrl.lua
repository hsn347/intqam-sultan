local GameModule = include("GameModule")
local msgCtrl = include("msgCtrl")
local redenvelopesCtrl = class("redenvelopesCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
function redenvelopesCtrl:ctor(properties)
	redenvelopesCtrl.super.ctor(self, properties)
	self.dataTable, redenvelopesCtrl, self.handle_notify = redenvelopesCtrl.super.ctor, redenvelopesCtrl.super.ctor, nil
end
function redenvelopesCtrl:getRedenvelopesSendData()
	return self.dataTable
end
function redenvelopesCtrl:checkRetData(data)
	self.dataTable = data
end
function redenvelopesCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_REDENVELOPES_MODULE, gCmd.REQ_REDENVELOPES_CHECK, handler(self, self.getCheckRedenvelopesRsp))
	msgCtrl.register(gCmd.CMD_REDENVELOPES_MODULE, gCmd.REQ_REDENVELOPES_GET, handler(self, self.getGotRedenvelopesRsp))
	self:updateAchievementInfo()
end
function redenvelopesCtrl:sendCheck(mUID, mID)
	if 0 ~= mID then
		_ENV = nil
		;(nil).cmd = gCmd.CMD_REDENVELOPES_MODULE
		_ENV, (nil).subcmd = gCmd.REQ_REDENVELOPES_CHECK, gCmd.REQ_REDENVELOPES_CHECK
		gCmd.REQ_REDENVELOPES_CHECK.id = mID
		;(nil).data, gCmd.REQ_REDENVELOPES_CHECK.uid = gCmd.REQ_REDENVELOPES_CHECK, mUID
		local msg
		serverproxy:SendMsg(msg)
	end
end
function redenvelopesCtrl:sendGet(mUID, mID, target)
	if 0 ~= mID then
		_ENV = nil
		;(nil).cmd = gCmd.CMD_REDENVELOPES_MODULE
		_ENV, (nil).subcmd = gCmd.REQ_REDENVELOPES_GET, gCmd.REQ_REDENVELOPES_GET
		gCmd.REQ_REDENVELOPES_GET.id = mID
		gCmd.REQ_REDENVELOPES_GET.uid = mUID
		;(nil).data, gCmd.REQ_REDENVELOPES_GET.target = gCmd.REQ_REDENVELOPES_GET, target
		local msg
		serverproxy:SendMsg(msg)
	end
end
function redenvelopesCtrl:resetData()
	self.dataTable, _UPVALUE0_ = nil, nil
end
function redenvelopesCtrl:Logout()
	redenvelopesCtrl.super.Logout(self)
end
function redenvelopesCtrl:getGotRedenvelopesRsp(content)
	dump(content, "redenvelopesCtrl:getGotRedenvelopesRsp = ", 5)
	SoraDCloseLoading()
	if gErrDef.Err_None == content.err then
		local redPacketInfo = content.result
		redPacketInfo.uid = content.data.uid
		local log = content.result.log
		local _ENV, rewards = "redenvelopesCtrl:getGotRedenvelopesRsp = ", "redenvelopesCtrl:getGotRedenvelopesRsp = "
		if log then
			local selfUid = gametop.playertop_:getPlayerID()
			for i, v in ipairs(log) do
				if v.uid == selfUid then
					if redPacketInfo.redEnvelopesType == gRedEnvelopesType.DROP_BOX_ACTIVITY then
						_ENV = nil
						;(nil).id = include("constantRead").getConstValue("TREASURECHEA_ITEMID")
						;(nil).count = v.gold
						table.insert(rewards, nil)
					elseif redPacketInfo.redEnvelopesType == gRedEnvelopesType.ICE_RED_PACKET and v.item then
						table.insert(rewards, v.item)
					else
						_ENV = v.item
						v.item.id = gIDDef.GOLD
						v.item.count = v.gold
						table.insert(rewards, v.item)
					end
					if v.extraReward ~= nil and v.extraReward[1].count > 0 then
						_ENV = v.item
						v.item.id = v.extraReward[1].id
						v.item.count = v.extraReward[1].count
						table.insert(rewards, v.item)
					end
				end
			end
		end
		local target = content.data.target
		if target then
		end
		if redPacketInfo.typeinfo then
			redPacketInfo.allianceAbbr = redPacketInfo.typeinfo.allianceAbbr
		end
		if redPacketInfo.redEnvelopesType == gRedEnvelopesType.DROP_BOX_ACTIVITY then
			_ENV = gRedEnvelopesType.DROP_BOX_ACTIVITY
			gRedEnvelopesType.DROP_BOX_ACTIVITY.msg = "MESSAGE_CHAT_SERVER_CLAIM_DROP_BOX"
			gRedEnvelopesType.DROP_BOX_ACTIVITY.redPacketInfo = redPacketInfo
			SoraDSendMessage(gRedEnvelopesType.DROP_BOX_ACTIVITY)
			_ENV = gRedEnvelopesType.DROP_BOX_ACTIVITY
			gRedEnvelopesType.DROP_BOX_ACTIVITY.msg = "MESSAGE_CHAT_SERVER_GET_DROP_BOX"
			gRedEnvelopesType.DROP_BOX_ACTIVITY.redPacketInfo = redPacketInfo
			SoraDSendMessage(gRedEnvelopesType.DROP_BOX_ACTIVITY)
		else
			_ENV = gRedEnvelopesType.DROP_BOX_ACTIVITY
			gRedEnvelopesType.DROP_BOX_ACTIVITY.msg = "MESSAGE_CHAT_SERVER_CLAIM_RED_PACKET"
			gRedEnvelopesType.DROP_BOX_ACTIVITY.redPacketInfo = redPacketInfo
			SoraDSendMessage(gRedEnvelopesType.DROP_BOX_ACTIVITY)
			_ENV = gRedEnvelopesType.DROP_BOX_ACTIVITY
			gRedEnvelopesType.DROP_BOX_ACTIVITY.msg = "MESSAGE_CHAT_SERVER_GET_RED_PACKET"
			gRedEnvelopesType.DROP_BOX_ACTIVITY.redPacketInfo = redPacketInfo
			SoraDSendMessage(gRedEnvelopesType.DROP_BOX_ACTIVITY)
			_ENV = gRedEnvelopesType.DROP_BOX_ACTIVITY
			gRedEnvelopesType.DROP_BOX_ACTIVITY.msg = "MESSAGE_CHAT_SERVER_GET_RED_PACKET_SUCCESS"
			gRedEnvelopesType.DROP_BOX_ACTIVITY.redPacketInfo = redPacketInfo
			gRedEnvelopesType.DROP_BOX_ACTIVITY.isClaim = true
			SoraDSendMessage(gRedEnvelopesType.DROP_BOX_ACTIVITY)
		end
		SoraDMailGainItems(rewards, true)
	else
		_ENV = content.result.log
		content.result.log.msg = "MESSAGE_CHAT_SERVER_CLAIM_RED_PACKET"
		content.result.log.redPacketInfo = content.result
		SoraDSendMessage(content.result.log)
		local chatFunctions = include("chatFunctions")
		if gErrDef.Err_REDENVELOPES_UNKNOW_ERR == content.err then
			if content and content.result then
				print("红包未知错误----------")
				local errMsg = i18n("common_text_1786")
				chatFunctions:ShowRedPacketTip(errMsg)
				_ENV = chatFunctions
				chatFunctions.msg = "MESSAGE_CHAT_SERVER_GET_RED_PACKET_FAILED"
				chatFunctions.errMsg = errMsg
				chatFunctions.isClaim = true
				SoraDSendMessage(chatFunctions)
			end
		elseif gErrDef.Err_REDENVELOPES_GOT_DONE == content.err then
			chatFunctions:ShowRedPacketTip(i18n("common_text_1786"))
			local redPacketInfo = content.result
			redPacketInfo.uid = content.data.uid
			if redPacketInfo.typeinfo then
				redPacketInfo.allianceAbbr = redPacketInfo.typeinfo.allianceAbbr
			end
			dump(redPacketInfo, "slkjflsdjflkdjssdf")
			if redPacketInfo.redEnvelopesType == gRedEnvelopesType.DROP_BOX_ACTIVITY then
				_ENV = gRedEnvelopesType.DROP_BOX_ACTIVITY
				gRedEnvelopesType.DROP_BOX_ACTIVITY.msg = "MESSAGE_CHAT_SERVER_GET_DROP_BOX"
				gRedEnvelopesType.DROP_BOX_ACTIVITY.redPacketInfo = redPacketInfo
				SoraDSendMessage(gRedEnvelopesType.DROP_BOX_ACTIVITY)
			else
				_ENV = gRedEnvelopesType.DROP_BOX_ACTIVITY
				gRedEnvelopesType.DROP_BOX_ACTIVITY.msg = "MESSAGE_CHAT_SERVER_GET_RED_PACKET"
				gRedEnvelopesType.DROP_BOX_ACTIVITY.redPacketInfo = redPacketInfo
				SoraDSendMessage(gRedEnvelopesType.DROP_BOX_ACTIVITY)
				_ENV = gRedEnvelopesType.DROP_BOX_ACTIVITY
				gRedEnvelopesType.DROP_BOX_ACTIVITY.msg = "MESSAGE_CHAT_SERVER_GET_RED_PACKET_SUCCESS"
				gRedEnvelopesType.DROP_BOX_ACTIVITY.redPacketInfo = redPacketInfo
				gRedEnvelopesType.DROP_BOX_ACTIVITY.isClaim = true
				SoraDSendMessage(gRedEnvelopesType.DROP_BOX_ACTIVITY)
			end
		elseif gErrDef.Err_REDENVELOPES_RECEIVE_LIMIT == content.err then
			SoraDShowMsgTip(i18n("Frosty_Carnival_text_10"))
		else
			print("红包其它错误-----------------")
			local errMsg = "err code = " .. content.err
			if content.err == gErrDef.Err_REDENVELOPES_TIME_EXPIRE then
				errMsg = i18n("common_text_1787")
			end
			chatFunctions:ShowRedPacketTip(errMsg)
			_ENV = chatFunctions
			chatFunctions.msg = "MESSAGE_CHAT_SERVER_GET_RED_PACKET_FAILED"
			chatFunctions.errMsg = errMsg
			chatFunctions.isClaim = true
			SoraDSendMessage(chatFunctions)
		end
	end
end
function redenvelopesCtrl:getCheckRedenvelopesRsp(content)
	dump(content, "redenvelopesCtrl:getCheckRedenvelopesRsp=", 5)
	SoraDCloseLoading()
	if gErrDef.Err_None == content.err then
		local redPacketInfo = content.result
		redPacketInfo.uid = content.data.uid
		if redPacketInfo.typeinfo then
			redPacketInfo.allianceAbbr = redPacketInfo.typeinfo.allianceAbbr
		end
		if content.result.redEnvelopesType == gRedEnvelopesType.DROP_BOX_ACTIVITY then
			_ENV = gRedEnvelopesType.DROP_BOX_ACTIVITY
			gRedEnvelopesType.DROP_BOX_ACTIVITY.msg = "MESSAGE_CHAT_SERVER_GET_DROP_BOX"
			gRedEnvelopesType.DROP_BOX_ACTIVITY.redPacketInfo = redPacketInfo
			SoraDSendMessage(gRedEnvelopesType.DROP_BOX_ACTIVITY)
		else
			_ENV = gRedEnvelopesType.DROP_BOX_ACTIVITY
			gRedEnvelopesType.DROP_BOX_ACTIVITY.msg = "MESSAGE_CHAT_SERVER_GET_RED_PACKET"
			gRedEnvelopesType.DROP_BOX_ACTIVITY.redPacketInfo = redPacketInfo
			SoraDSendMessage(gRedEnvelopesType.DROP_BOX_ACTIVITY)
			_ENV = gRedEnvelopesType.DROP_BOX_ACTIVITY
			gRedEnvelopesType.DROP_BOX_ACTIVITY.msg = "MESSAGE_CHAT_SERVER_GET_RED_PACKET_SUCCESS"
			gRedEnvelopesType.DROP_BOX_ACTIVITY.redPacketInfo = redPacketInfo
			SoraDSendMessage(gRedEnvelopesType.DROP_BOX_ACTIVITY)
		end
	else
		local chatFunctions = include("chatFunctions")
		local errMsg = "gift err!"
		if gErrDef.Err_REDENVELOPES_UNKNOW_ERR == content.err or gErrDef.Err_REDENVELOPES_TIME_EXPIRE == content.err then
			errMsg = i18n("common_text_1787")
			chatFunctions:ShowRedPacketTip(errMsg)
		elseif gErrDef.Err_REDENVELOPES_UNFOUND == content.err then
			errMsg = i18n("common_text_1787")
			chatFunctions:ShowRedPacketTip(errMsg)
		elseif gErrDef.Err_REDENVELOPES_ALLIANS_DISMATCH == content.err then
			errMsg = i18n("common_text_1785")
			chatFunctions:ShowRedPacketTip(errMsg)
		else
			print("err = ", content.err)
			errMsg = i18n("common_text_1787")
			chatFunctions:ShowRedPacketTip(errMsg)
		end
		_ENV = chatFunctions
		chatFunctions.msg = "MESSAGE_CHAT_SERVER_GET_RED_PACKET_FAILED"
		chatFunctions.errMsg = errMsg
		SoraDSendMessage(chatFunctions)
	end
end
function redenvelopesCtrl:updateAchievementInfo()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.REDENVELOPES_SEND_INFO, handler(self, self.notifyRedenvelopesSendData))
end
function redenvelopesCtrl:notifyRedenvelopesSendData(respone)
	self:checkRetData(respone.data[1])
end
return redenvelopesCtrl
