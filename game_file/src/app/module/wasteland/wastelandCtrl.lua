local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local wastelandCtrl = class("wastelandCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function wastelandCtrl:ctor(properties)
	wastelandCtrl.super.ctor(self, properties)
	self:resetData()
	self.maxBossLevel = 10
end
function wastelandCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_WASTELAND_MODULE, gCmd.REQ_WASTELAND_DATA, handler(self, self.reqInitDataRsp))
	msgCtrl.register(gCmd.CMD_WASTELAND_MODULE, gCmd.REQ_WASTELAND_ALLIANCE_SCORE_RANK, handler(self, self.reqAllianceScoreRankRsp))
	self:registerNotify()
end
function wastelandCtrl:initClientData(data)
	dump(data, "wastelandCtrl:initClientData", 10)
	if not data then
		return
	end
	self.maxKillBossLevel = data.maxKillBossLevel
end
function wastelandCtrl:Logout()
	wastelandCtrl.super.Logout(self)
	self:resetData()
end
function wastelandCtrl:resetData()
	self.maxKillBossLevel = 0
end
function wastelandCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.WASTELAND, handler(self, self.notifyHandler))
end
function wastelandCtrl:notifyHandler(event)
	dump(event.data, "wastelandCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		local notifyType = v.type
		local notifyData = v.data
		if notifyType == "setData" then
			self:initClientData(notifyData)
		elseif notifyType == "killBoss" then
			uiManager:show("wastelandVictory", notifyData)
		end
	end
end
function wastelandCtrl:reqInitData()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_WASTELAND_MODULE, gCmd.REQ_WASTELAND_DATA, nil)
end
function wastelandCtrl:reqAllianceScoreRank(iBegin, nCount)
	serverproxy = nil
	;(nil).iBegin = iBegin
	;(nil).nCount = nCount
	serverproxy:Request(gCmd.CMD_WASTELAND_MODULE, gCmd.REQ_WASTELAND_ALLIANCE_SCORE_RANK, nil)
end
function wastelandCtrl:sendReqInitDataMsg(...)
	self:reqInitData()
end
function wastelandCtrl:reqInitDataRsp(content)
	dump(content, "wastelandCtrl:reqInitDataRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self:initClientData(content.rspdata)
	end
end
function wastelandCtrl:reqAllianceScoreRankRsp(content)
	dump(content, "wastelandCtrl:reqAllianceScoreRankRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_WASTELAND_REFRESH_RANK"
		gErrDef.Err_None.rspdata = content.rspdata
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function wastelandCtrl:getMaxAttackBossLevel(...)
	return math.min(self.maxBossLevel, self.maxKillBossLevel + 1)
end
function wastelandCtrl:getBossConfig(bossID)
	if not self.bossConfig then
		local _ENV, ret = self.bossConfig, self.bossConfig
		local wasteland_boss = require_data("wasteland_boss", true).data
		for i, v in ipairs(wasteland_boss) do
			ret[tostring(v.monsterID)] = v
		end
		self.bossConfig = ret
	end
	return self.bossConfig[tostring(bossID)]
end
function wastelandCtrl:getBossConfigByLv(lv)
	local wasteland_boss = require_data("wasteland_boss", true).data
	return wasteland_boss[lv] or wasteland_boss[1]
end
function wastelandCtrl:getMaxBossLv()
	local wasteland_boss = require_data("wasteland_boss", true).data
	local maxLv = 0
	for i, v in ipairs(wasteland_boss) do
		if maxLv < v.LV then
			maxLv = v.LV
		end
	end
	dump(maxLv, "wastelandCtrl:getMaxBossLv()")
	return maxLv
end
function wastelandCtrl:getMonsterCountStr(...)
	local constantRead = include("constantRead")
	local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
	local max = constantRead.getConstValue("WASTELAND_GUARDIAN_REWARD_TIME", 100)
	local cur = lordInfoCtrl:getKillWastelandNpcCount()
	local remain = math.max(0, max - cur)
	local remainStr = tostring(remain)
	if remain == 0 then
		_ENV = nil
		;(nil).color = "#FF0000"
		remainStr = SoraDWrapHtmlTagByStyle(remainStr, nil)
	end
	_ENV = nil
	;(nil).val1 = remainStr
	;(nil).val2 = max
	local countStr = i18n("wasteland_text_025", nil)
	return countStr, remain
end
function wastelandCtrl:getBossCountStr(...)
	local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
	local info = kingdomMapCtrl:getKingdomMapCell():getBossRewardLeftTimes(gBossType.wastelandBoss)
	local remain = math.max(0, info.maxKillNum - info.killNum)
	local remainStr = tostring(remain)
	if remain == 0 then
		_ENV = nil
		;(nil).color = "#FF0000"
		remainStr = SoraDWrapHtmlTagByStyle(remainStr, nil)
	end
	_ENV = nil
	;(nil).val1 = remainStr
	;(nil).val2 = info.maxKillNum
	local countStr = i18n("wasteland_text_026", nil)
	return countStr
end
function wastelandCtrl:checkKillMonsterCount(...)
	local __, remain = self:getMonsterCountStr()
	if 0 < remain then
		return true
	else
		local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
		local cur = lordInfoCtrl:getKillWastelandNpcCount()
		return false, cur
	end
end
return wastelandCtrl
