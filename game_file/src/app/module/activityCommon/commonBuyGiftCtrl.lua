local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local commonBuyGiftCtrl = class("commonBuyGiftCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function commonBuyGiftCtrl:ctor(properties)
	commonBuyGiftCtrl.super.ctor(self, properties)
	self:resetData()
end
function commonBuyGiftCtrl:EnterGame()
	_ENV = nil
	_ENV = nil
	;(nil).cmd = gCmd.CMD_DECORATION_BATTLE_MODULE
	;(nil).subCmd = gCmd.REQ_DECORATION_BATTLE_BUY_GIFT
	;(nil)[gBuyType.DECORATION_BATTLE], (nil).notifyID = nil, gNotifyID.DECORATION_BATTLE
	_ENV = nil
	;(nil).cmd = gCmd.CMD_KOH_MIGRATE_HELP_MODULE
	;(nil).subCmd = gCmd.REQ_KOH_MIGRATE_HELP_BUY_GIFT
	;(nil)[gBuyType.KOH_MIGRATE_HELP], (nil).notifyID = nil, gNotifyID.KOH_MIGRATE_HELP
	_ENV = nil
	;(nil).cmd = gCmd.CMD_CRUISE_EMPTY_ISLAND_MODULE
	;(nil).subCmd = gCmd.REQ_CRUISE_EMPTY_ISLAND_RECHARGE
	;(nil)[gBuyType.CRUISE_SKY_ISLAND], (nil).notifyID = nil, gNotifyID.CRUISE_SKY_ISLAND
	_ENV = nil
	;(nil).cmd = gCmd.CMD_END_OF_RAMADAN_KITCHEN_MODULE
	;(nil).subCmd = gCmd.REQ_END_OF_RAMADAN_KITCHEN_BUY_GIFT
	;(nil)[gBuyType.END_OF_RAMADAN_KITCHEN], (nil).notifyID = nil, gNotifyID.END_OF_RAMADAN_KITCHEN
	_ENV = nil
	;(nil).cmd = gCmd.CMD_USER_ACTIVITY_MODULE
	;(nil)[gBuyType.TWO_MAGIC_LAMP_ORDER], (nil).subCmd = nil, gCmd.REQ_TWO_MAGIC_LAMP_ORDER_BUY
	_ENV = nil
	;(nil).cmd = gCmd.CMD_ROARING_FLAME_WAR_MODULE
	;(nil).subCmd = gCmd.REQ_ROARING_FLAME_WAR_BUY_GIFT
	;(nil)[gBuyType.ROARING_FLAME_WAR], (nil).notifyID = nil, gNotifyID.ROARING_FLAME_WAR
	_ENV = nil
	;(nil).cmd = gCmd.CMD_USER_ACTIVITY_MODULE
	;(nil)[gBuyType.MAGIC_LAMP_HATCH_ORDER], (nil).subCmd = nil, gCmd.REQ_MAGIC_LAMP_HATCH_ORDER_BUY
	_ENV = nil
	;(nil).cmd = gCmd.CMD_REBUILD_BUBBLE_LAND_MODULE
	;(nil).subCmd = gCmd.REQ_REBUILD_BUBBLE_LAND_BUY_GIFT
	;(nil)[gBuyType.REBUILD_BUBBLE_LAND], (nil).notifyID = nil, gNotifyID.REBUILD_BUBBLE_LAND
	_ENV = nil
	;(nil).cmd = gCmd.CMD_HERO_POWER_SKILL_GIFT_MODULE
	;(nil)[gBuyType.HERO_POWER_SKILL], (nil).subCmd = nil, gCmd.REQ_HERO_POWER_SKILL_BUY
	_ENV = nil
	;(nil).cmd = gCmd.CMD_SNOW_COMPETITION_MODULE
	;(nil).subCmd = gCmd.REQ_SNOW_COMPETITION_BUY_GIFT
	;(nil)[gBuyType.SNOW_COMPETITION], (nil).notifyID = nil, gNotifyID.SNOW_COMPETITION
	_ENV = nil
	;(nil).cmd = gCmd.CMD_GOLD_MINER_MODULE
	;(nil).subCmd = gCmd.REQ_GOLD_MINER_BUY_GIFT
	;(nil)[gBuyType.GOLD_MINER], (nil).notifyID = nil, gNotifyID.GOLD_MINER
	_ENV = nil
	;(nil).cmd = gCmd.CMD_SKY_COMPETITION_MODULE
	;(nil).subCmd = gCmd.REQ_SKY_COMPETITION_BUY_GIFT
	;(nil)[gBuyType.SKY_COMPETITION], (nil).notifyID = nil, gNotifyID.SKY_COMPETITION
	_ENV = nil
	;(nil).cmd = gCmd.CMD_FROSTY_MARKET_MODULE
	;(nil).subCmd = gCmd.REQ_FROSTY_MARKET_BUY_GIFT
	;(nil)[gBuyType.FROSTY_MARKET], (nil).notifyID = nil, gNotifyID.FROSTY_MARKET
	_ENV = nil
	;(nil).cmd = gCmd.CMD_KOREAN_CHESS_MODULE
	;(nil).subCmd = gCmd.REQ_KOREAN_CHESS_BUY_GIFT
	;(nil)[gBuyType.KOREAN_CHESS], (nil).notifyID = nil, gNotifyID.KOREAN_CHESS
	_ENV = nil
	;(nil).cmd = gCmd.CMD_SURPRISE_BOX_MODULE
	;(nil).subCmd = gCmd.REQ_SURPRISE_BOX_BUY_GIFT
	;(nil)[gBuyType.SURPRISE_BOX], (nil).notifyID = nil, gNotifyID.SURPRISE_BOX
	_ENV = nil
	;(nil).cmd = gCmd.CMD_BALLOON_HUNTER_MODULE
	;(nil).subCmd = gCmd.REQ_BALLOON_HUNTER_RECHARGE
	;(nil)[gBuyType.BALLOON_HUNTER], (nil).notifyID = nil, gNotifyID.BALLOON_HUNTER
	_ENV = nil
	;(nil).cmd = gCmd.CMD_CRESCENT_ORDER_MODULE
	;(nil).subCmd = gCmd.REQ_CRESCENT_BUY_GIFT
	;(nil)[gBuyType.CRESCENT_ORDER], (nil).notifyID = nil, gNotifyID.CRESCENT_ORDER
	_ENV = nil
	;(nil).cmd = gCmd.CMD_ADVENTURE_GIFT_MODULE
	;(nil)[gBuyType.ADVENTURE_GIFT], (nil).subCmd = nil, gCmd.REQ_ADVENTURE_GIFT_BUY
	_ENV = nil
	;(nil).cmd = gCmd.CMD_MAGIC_CARPET_MODULE
	;(nil).subCmd = gCmd.REQ_MAGIC_CARPET_BUY_GIFT
	;(nil)[gBuyType.MAGIC_CARPET], (nil).notifyID = nil, gNotifyID.MAGIC_CARPET
	_ENV = nil
	;(nil).cmd = gCmd.CMD_USER_ACTIVITY_MODULE
	;(nil).subCmd = gCmd.REQ_ANNIVERSARY_2025_SHOP_BUY_GIFT
	;(nil)[gBuyType.ANNIVERSARY_2025_SHOP], (nil).notifyID = nil, gNotifyID.USER_ACTIVITY
	_ENV = nil
	;(nil).cmd = gCmd.CMD_FANTASY_LAND_MODULE
	;(nil).subCmd = gCmd.REQ_FANTASY_LAND_BUY_GIFT
	;(nil)[gBuyType.FANTASY_LAND], (nil).notifyID = nil, gNotifyID.FANTASY_LAND
	_ENV = nil
	;(nil).cmd = gCmd.CMD_SNOW_WOLF_KING_MODULE
	;(nil).subCmd = gCmd.REQ_SNOW_WOLF_KING_BUY_GIFT
	;(nil)[gBuyType.SNOW_WOLF_KING], (nil).notifyID = nil, gNotifyID.ANGRY_SNOW_WOLF_KING
	_ENV = nil
	;(nil).cmd = gCmd.CMD_ALBARQ_DECREE_MODULE
	;(nil).subCmd = gCmd.REQ_ALBARQ_BUY_GIFT
	;(nil)[gBuyType.ALBARQ_DECREE], (nil).notifyID = nil, gNotifyID.ALBARQ_DECREE
	_ENV = nil
	;(nil).cmd = gCmd.CMD_CRESCENT_TREASURE_MODULE
	;(nil).subCmd = gCmd.REQ_CRESCENT_TREASURE_BUY_GIFT
	;(nil)[gBuyType.CRESCENT_TREASURE], (nil).notifyID = nil, gNotifyID.CRESCENT_TREASURE
	_ENV = nil
	;(nil).cmd = gCmd.CMD_GREEN_GRASS_FLIP_MODULE
	;(nil).subCmd = gCmd.REQ_GREEN_GRASS_FLIP_BUY_GIFT
	;(nil)[gBuyType.GREEN_GRASS_FLIP], (nil).notifyID = nil, gNotifyID.GREEN_GRASS_FLIP
	_ENV = nil
	;(nil).cmd = gCmd.CMD_FREE_KICK_MASTER_MODULE
	;(nil).subCmd = gCmd.REQ_FREE_KICK_MASTER_BUY_GIFT
	;(nil)[gBuyType.FREE_KICK_MASTER], (nil).notifyID = nil, gNotifyID.FREE_KICK_MASTER
	_ENV = nil
	;(nil).cmd = gCmd.CMD_GREEN_GRASS_PREDICT_MODULE
	;(nil).subCmd = gCmd.REQ_GREEN_GRASS_PREDICT_BUY_GIFT
	;(nil)[gBuyType.GREEN_GRASS_PREDICT], (nil).notifyID = nil, gNotifyID.GREEN_GRASS_PREDICT
	_ENV = nil
	;(nil).cmd = gCmd.CMD_BALL_FIELD_MATCH_MODULE
	;(nil).subCmd = gCmd.REQ_BALL_FIELD_MATCH_BUY_GIFT
	self.cmdConfig, (nil)[gBuyType.BALL_FIELD_MATCH], (nil).notifyID = nil, nil, gNotifyID.BALL_FIELD_MATCH
	for buyType, cmdCfg in pairs(self.cmdConfig) do
		msgCtrl.register(cmdCfg.cmd, cmdCfg.subCmd, handler(self, self.reqBuyGiftRsp))
	end
	self:registerNotify()
end
function commonBuyGiftCtrl:Logout()
	commonBuyGiftCtrl.super.Logout(self)
	self:resetData()
end
function commonBuyGiftCtrl:resetData()
end
function commonBuyGiftCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	for buyType, cmdCfg in pairs(self.cmdConfig) do
		if cmdCfg.notifyID then
			notifyCtrl:register(cmdCfg.notifyID, handler(self, self.notifyHandler))
		end
	end
end
function commonBuyGiftCtrl:notifyHandler(event)
	dump(event.data, "commonBuyGiftCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		local notifyType = v.notifyType or v.type
		local notifyData = v.notifyData or v.data
		if notifyType == "buyGift" then
			self:notifyBuyGift(notifyData)
		end
	end
end
function commonBuyGiftCtrl:notifyBuyGift(rechargeInfo)
	if rechargeInfo.success then
		paymentManager.loopForFinishTransaction()
		local reward = rechargeInfo.reward
		local rid = rechargeInfo.rid
		local mailid = rechargeInfo.mailid or rechargeInfo.mailID
		_ENV = nil
		_ENV, (nil).msg = nil, "MESSAGE_SERVER_RECHARGECENTER_REFRESH"
		;(nil).result = true
		;(nil).rid = rid
		;(nil).itemList = reward
		;(nil).data, (nil).mailID = nil, mailid
		SoraDSendMessage(nil)
	end
end
function commonBuyGiftCtrl:reqBuyGift(buyType, rid)
	local cmdCfg = self.cmdConfig[buyType]
	serverproxy = nil
	;(nil).rid = rid
	serverproxy, (nil).rechargeID = nil, rid
	;(nil).buyType = buyType
	serverproxy:Request(cmdCfg.cmd, cmdCfg.subCmd, nil, nil)
end
function commonBuyGiftCtrl:reqBuyGiftRsp(content)
	dump(content, "commonBuyGiftCtrl:reqBuyGiftRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		local data = content.data
		local rspdata = content.rspdata
		local rid = data.rid or data.rechargeID or rspdata.rechargeID
		paymentManager.purchase(rid, rspdata.orderID)
	elseif content.err == gErrDef.Err_FANTASY_LAND_JOIN_ALLIANCE_TIME then
		SoraDShowMsgTip(i18n("fantasy_land_text_05"))
	end
end
function commonBuyGiftCtrl:checkHasConfig(buyType)
	local cmdCfg = self.cmdConfig[buyType]
	if cmdCfg then
		return true
	else
		return false
	end
end
return commonBuyGiftCtrl
