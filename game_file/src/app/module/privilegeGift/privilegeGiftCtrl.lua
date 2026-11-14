local GameModule = include("GameModule")
local privilegeGiftCtrl = class("privilegeGiftCtrl", GameModule)
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local privilegeGiftRead = include("privilegeGiftRead")
function privilegeGiftCtrl:ctor(properties)
	privilegeGiftCtrl.super.ctor(self, properties)
end
function privilegeGiftCtrl:EnterGame()
	gametop = nil
	;(nil).name = gEventName.event_req_player_data
	gametop.playertop_:dispatchEvent(nil)
	msgCtrl.register(gCmd.CMD_PRIVILEGE_GIFT_MODULE, gCmd.REQ_PRIVILEGE_GIFT_INIT, handler(self, self.reqInitResp))
	msgCtrl.register(gCmd.CMD_PRIVILEGE_GIFT_MODULE, gCmd.REQ_PRIVILEGE_GIFT_BUY, handler(self, self.reqBuyResp))
	self:resetData()
end
function privilegeGiftCtrl:resetData()
	self.buyRecord, _UPVALUE0_ = nil, nil
	self.lv = nil
	self.rid = nil
	self.wallLV = nil
	self.wallRid = nil
end
function privilegeGiftCtrl:Logout()
	self:resetData()
	privilegeGiftCtrl.super.Logout(self)
end
function privilegeGiftCtrl:initClientData(data)
	if not data then
		return
	end
	if data.buyRecord then
		self.buyRecord = data.buyRecord
	end
	self:registerNotify()
end
function privilegeGiftCtrl:dump()
	local curCanBuyRechargeID = self:getCurCanBuyRechargeID()
	local keys = table.keys(privilegeGiftRead.getPrivilegeGiftData())
	for k, rechargeID in pairs(keys) do
		print("self:getErrByRechargeID(rechargeID)=", rechargeID, self:getErrByRechargeID(rechargeID))
	end
end
function privilegeGiftCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.PRIVILEGE_GIFT, handler(self, self.notifyHandler))
end
function privilegeGiftCtrl:notifyHandler(event)
	if event.data then
		for _, content in pairs(event.data) do
			dump(content, "privilegeGiftCtrl:notifyHandler", 10)
			if content then
				if content.buyRecord then
					self.buyRecord = content.buyRecord
				end
				if content.success == true then
					paymentManager.OnemtRechargeSuccess(content.price)
					paymentManager.loopForFinishTransaction()
					local reward = content.reward
					local mailid = content.mailid
					local rid = content.rid
					_ENV = nil
					;(nil).msg = "MESSAGE_MAINCITY_CASTLE_GIFT_MSG"
					;(nil).success = true
					SoraDSendMessage(nil)
					_ENV = nil
					_ENV, (nil).msg = nil, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
					;(nil).result = true
					;(nil).rid = rid
					;(nil).itemList = reward
					;(nil).data, (nil).mailID = nil, mailid
					SoraDSendMessage(nil)
					_ENV = nil
					;(nil).msg = "MESSAGE_MAINCITYVIEW_VIP_PRIVILEGE_GIFT"
					SoraDSendMessage(nil)
					_ENV = nil
					;(nil).msg = "MESSAGE_GODREWARDS_GRAFT_PRIVILEGE_GIFT"
					SoraDSendMessage(nil)
					local gifts = self:getCurCanBuyRechargeID()
					if not next(gifts) then
						_ENV = gifts
						gifts.msg = "MESSAGE_MAINCITYVIEW_REMOVE_CASTLE_GIFT_TOP_TIP"
						SoraDSendMessage(gifts)
					end
				elseif content.success == false then
					paymentManager.loopForFinishTransaction()
					local rid = content.rid
					_ENV = content.rid
					content.rid.msg = "MESSAGE_MAINCITY_CASTLE_GIFT_MSG"
					content.rid.success = false
					SoraDSendMessage(content.rid)
					_ENV = content.rid
					_ENV, content.rid.msg = self:getCurCanBuyRechargeID(), "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
					self:getCurCanBuyRechargeID().result = false
					content.rid.data, self:getCurCanBuyRechargeID().rid = self:getCurCanBuyRechargeID(), rid
					SoraDSendMessage(content.rid)
				end
				if content.lv and content.rid then
					local giftInfo = privilegeGiftRead.getRechargeGiftByID(content.rid)
					self.privilegeType = giftInfo and giftInfo.privilegeType or nil
					dump(giftInfo, "giftInfo")
					if self.privilegeType == gPrivilegeType.PRIVILEGE_GIFT_WALL_LV then
						self.wallLv = content.lv
						self.wallRid = content.rid
						print("lv,rid=", self.lv, self.rid)
						_ENV = self.lv
						self.lv.lv = self.wallLv
						_ENV, self.lv.rid = self.wallRid, self.wallRid
						self.wallRid.byUID = true
						SoraDConfigSet("Game:WallLvUpView:wallLvList~table", self.lv, self.wallRid)
						_ENV = self.lv
						self.lv.byUID = true
						local wallTb = SoraDConfigGet("Game:WallLvUpView:wallLvList~table", self.lv)
						dump(wallTb, "wallTb111===")
						_ENV = wallTb
						wallTb.msg = "MESSAGE_MAINCITY_CASTLE_GIFT_POP_MSG"
						wallTb.rid = content.rid
						wallTb.privilegeType = self.privilegeType
						SoraDSendMessage(wallTb)
					else
						self.lv = content.lv
						self.rid = content.rid
						print("lv,rid=", self.lv, self.rid)
						_ENV = self.lv
						self.lv.lv = self.lv
						_ENV, self.lv.rid = self.rid, self.rid
						self.rid.byUID = true
						SoraDConfigSet("Game:CastleLvUpView:castleLvList~table", self.lv, self.rid)
						_ENV = self.lv
						self.lv.byUID = true
						local castleTb = SoraDConfigGet("Game:CastleLvUpView:castleLvList~table", self.lv)
						dump(castleTb, "castleTb111===")
						if content.lv > CASTLE_LV30_LIMITED or content.lv <= CASTLE_LV30_LIMITED and content.lv % 5 == 0 then
							_ENV = CASTLE_LV30_LIMITED
							CASTLE_LV30_LIMITED.msg = "MESSAGE_MAINCITY_CASTLE_GIFT_POP_MSG"
							CASTLE_LV30_LIMITED.rid = content.rid
							CASTLE_LV30_LIMITED.privilegeType = self.privilegeType
							SoraDSendMessage(CASTLE_LV30_LIMITED)
						end
					end
					print("--主堡升级刷新在线奖励显示==========")
					if not (content.lv >= CASTLE_LV7_LIMITED) or self.privilegeType == gPrivilegeType.PRIVILEGE_GIFT_WALL_LV then
					end
					_ENV = gPrivilegeType.PRIVILEGE_GIFT_WALL_LV
					gPrivilegeType.PRIVILEGE_GIFT_WALL_LV.msg = "MESSAGE_NEW_PLAYER_QUEST_UPDATE"
					gPrivilegeType.PRIVILEGE_GIFT_WALL_LV.isUpdate = true
					SoraDSendMessage(gPrivilegeType.PRIVILEGE_GIFT_WALL_LV)
				end
			end
		end
	end
end
function privilegeGiftCtrl:sendInitMsg()
	local serverproxy, data
	serverproxy:Request(gCmd.CMD_PRIVILEGE_GIFT_MODULE, gCmd.REQ_PRIVILEGE_GIFT_INIT, data)
end
function privilegeGiftCtrl:sendBuyMsg(rechargeID)
	local serverproxy, data
	data.rechargeID = rechargeID
	serverproxy:Request(gCmd.CMD_PRIVILEGE_GIFT_MODULE, gCmd.REQ_PRIVILEGE_GIFT_BUY, data)
end
function privilegeGiftCtrl:reqInitResp(ret)
	dump(ret, "privilegeGiftCtrl:reqInitResp", 10)
	if ret and ret.data then
		local data = ret.data
	end
end
function privilegeGiftCtrl:reqBuyResp(ret)
	if ret and ret.data then
		local rechargeID = ret.data.rechargeID
		if ret.err == gErrDef.Err_None then
			local orderID = ret.data.orderID
			paymentManager.purchase(rechargeID, orderID)
		else
			SoraDCloseLoading()
			paymentManager.isInRecharging = false
			if ret.err == gErrDef.Err_PRIVILEGE_GIFT_NOT_GIFT then
			elseif ret.err == gErrDef.Err_PRIVILEGE_GIFT_LV_NOT_ENOUGH then
			elseif ret.err == gErrDef.Err_PRIVILEGE_GIFT_ALREADY_BUY then
			end
		end
	end
end
function privilegeGiftCtrl:getErrByRechargeID(rechargeID)
	local privilegeType = privilegeGiftRead.getValueByRechargeID(rechargeID, "privilegeType")
	if privilegeType == _G.gPrivilegeType.PRIVILEGE_GIFT_CASTLE_LV then
		if not privilegeGiftRead.getRechargeIDExist(rechargeID) then
			return gErrDef.Err_PRIVILEGE_GIFT_NOT_GIFT
		end
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local curCastlelv = cityCtrl:getBuildMaxLv(BUILDID.CASTLE) or 0
		local castleLv = privilegeGiftRead.getValueByRechargeID(rechargeID, "lv")
		if curCastlelv < castleLv then
			return gErrDef.Err_PRIVILEGE_GIFT_LV_NOT_ENOUGH
		end
	elseif privilegeType == _G.gPrivilegeType.PRIVILEGE_GIFT_VIP_LV then
		if not privilegeGiftRead.getVipRechargeIDExist(rechargeID) then
			return gErrDef.Err_PRIVILEGE_GIFT_NOT_GIFT
		end
		local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
		local vipInfo = lordInfoCtrl:getVipDetails()
		local needLv = privilegeGiftRead.getValueByRechargeID(rechargeID, "lv")
		if needLv > vipInfo.level then
			return gErrDef.Err_PRIVILEGE_GIFT_VIP_LV_NOT_ENOUGH
		end
	elseif privilegeType == _G.gPrivilegeType.PRIVILEGE_GIFT_STAR_LV then
		if not privilegeGiftRead.getStarLvRechargeIDExist(rechargeID) then
			return gErrDef.Err_PRIVILEGE_GIFT_NOT_GIFT
		end
		if not SoraDCheckIsOpenBuildStar() then
			return gErrDef.Err_PRIVILEGE_GIFT_LV_NOT_ENOUGH
		end
	elseif privilegeType == _G.gPrivilegeType.PRIVILEGE_GIFT_ACTIVITY then
		if not privilegeGiftRead.getGraftPrivilegeGiftExist(rechargeID) then
			return gErrDef.Err_PRIVILEGE_GIFT_NOT_GIFT
		end
		local buyNum = self:getBoughtNums(rechargeID)
		if 0 < buyNum then
			return gErrDef.Err_PRIVILEGE_GIFT_ALREADY_BUY
		end
		return gErrDef.Err_None
	elseif privilegeType == _G.gPrivilegeType.PRIVILEGE_GIFT_WALL_LV then
		if not privilegeGiftRead.getRechargeIDExist(rechargeID) then
			return gErrDef.Err_PRIVILEGE_GIFT_NOT_GIFT
		end
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local curWallLv = cityCtrl:getBuildMaxLv(BUILDID.WALLS) or 0
		local wallLv = privilegeGiftRead.getValueByRechargeID(rechargeID, "lv")
		if curWallLv < wallLv then
			return gErrDef.Err_PRIVILEGE_GIFT_LV_NOT_ENOUGH
		end
	end
	if not self.buyRecord then
		privilegeGiftRead = self.buyRecord
	end
	self.buyRecord = self.buyRecord
	local giftInfo = privilegeGiftRead.getRechargeGiftByID(rechargeID)
	giftInfo = giftInfo or privilegeGiftRead.getStarRechargeGiftByID(rechargeID)
	local limitNum = giftInfo and giftInfo.extraData or 1
	if privilegeType == _G.gPrivilegeType.PRIVILEGE_GIFT_VIP_LV then
		limitNum = 1
	end
	local remainNums = limitNum - self:getBoughtNums(rechargeID)
	if remainNums <= 0 then
		return gErrDef.Err_PRIVILEGE_GIFT_ALREADY_BUY
	end
	return gErrDef.Err_None
end
function privilegeGiftCtrl:getCurCanBuyRechargeID()
	local privilegeGiftRead, ret
	local privilegeGiftRead, retValue
	local privilegeGiftData = privilegeGiftRead.getPrivilegeGiftData()
	for rechargeID, value in pairs(privilegeGiftData) do
		if self:getErrByRechargeID(rechargeID) == gErrDef.Err_None and value.privilegeType ~= _G.gPrivilegeType.PRIVILEGE_GIFT_WALL_LV then
			table.insert(retValue, value)
		end
	end
	if table.nums(retValue) > 0 then
		table.sort(retValue, function(a, b)
			return a.lv > b.lv
		end)
		local isKLVOpen = include("kingdomLevelDataModuleAPI"):isOpen()
		for k, v in ipairs(retValue) do
			if v.lv <= CASTLE_MAXLV_WAR then
				table.insert(ret, v.rechargeID)
			end
			if v.lv > CASTLE_MAXLV_WAR and isKLVOpen then
				table.insert(ret, v.rechargeID)
			end
		end
	end
	return ret
end
function privilegeGiftCtrl:getCurStarLvCanBuyRechargeID()
	local privilegeGiftRead, ret
	local privilegeGiftRead, retValue
	local starGiftData = privilegeGiftRead.getStarLvPrivilegeGiftData()
	for rechargeID, value in pairs(starGiftData) do
		if self:getErrByRechargeID(rechargeID) == gErrDef.Err_None then
			table.insert(retValue, value)
		end
	end
	if table.nums(retValue) > 0 then
		table.sort(retValue, function(a, b)
			return a.lv1 > b.lv1
		end)
		for i, v in ipairs(retValue) do
			local needLv = privilegeGiftRead.getStarValueByRechargeID(v.rechargeID, "lv1")
			local curStarLv = SoraDGetBuildStarLv()
			if SoraDCheckIsOpenBuildStar() and curStarLv == 0 and needLv == 1 then
				table.insert(ret, v.rechargeID)
				break
			end
			if SoraDCheckIsOpenBuildStar() and 0 < curStarLv and needLv <= curStarLv then
				table.insert(ret, v.rechargeID)
			end
		end
	end
	return ret
end
function privilegeGiftCtrl:getCurWallGiftRechargeID()
	local privilegeGiftRead, ret
	local privilegeGiftRead, retValue
	local privilegeGiftData = privilegeGiftRead.getPrivilegeGiftData()
	for rechargeID, value in pairs(privilegeGiftData) do
		if self:getErrByRechargeID(rechargeID) == gErrDef.Err_None and value.privilegeType == _G.gPrivilegeType.PRIVILEGE_GIFT_WALL_LV then
			table.insert(retValue, value)
		end
	end
	if table.nums(retValue) > 0 then
		table.sort(retValue, function(a, b)
			return a.lv > b.lv
		end)
		local isKLVOpen = include("kingdomLevelDataModuleAPI"):isOpen()
		for k, v in ipairs(retValue) do
			if v.lv <= CASTLE_MAXLV_WAR then
				table.insert(ret, v.rechargeID)
			end
			if v.lv > CASTLE_MAXLV_WAR and isKLVOpen then
				table.insert(ret, v.rechargeID)
			end
		end
	end
	return ret
end
function privilegeGiftCtrl:isBought(rechargeID)
	return self.buyRecord[tostring(rechargeID)]
end
function privilegeGiftCtrl:getBoughtNums(rechargeID)
	local remainNums = 0
	if self.buyRecord[tostring(rechargeID)] then
		remainNums = self.buyRecord[tostring(rechargeID)]
	end
	return remainNums
end
function privilegeGiftCtrl:getUpgradeLvAndRid()
	return self.lv, self.rid, self.privilegeType
end
function privilegeGiftCtrl:getWallUpgradeLvAndRid()
	return self.wallLv, self.wallRid, self.privilegeType
end
return privilegeGiftCtrl
