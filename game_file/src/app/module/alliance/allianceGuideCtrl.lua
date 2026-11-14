local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local allianceDesRead = include("allianceDesRead")
local allianceTerritoryAPI = include("allianceTerritoryAPI")
local allianceGuideCtrl = class("allianceGuideCtrl", gameModule)
function allianceGuideCtrl:ctor(properties)
	allianceGuideCtrl.super.ctor(self, properties)
	self.gStuts = -1
end
function allianceGuideCtrl:EnterGame()
	allianceGuideCtrl.super.EnterGame(self)
	allianceGuideCtrl.alliance_guidance_award = require("app." .. LocalTblPath .. ".config_server.alliance_guidance_award")
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_RANDOM_TERR_POS, handler(self, self.getRandomPoint))
	msgCtrl.register(gCmd.CMD_ALLIANCE_GUIDE, gCmd.REQ_ALLIANCE_GUIDE_GET_TERR_MOVECITY_REWARD, handler(self, self.getGuideReward))
end
function allianceGuideCtrl:resetData()
	gModuleMgr.getObject("permissionCtrl"):Logout()
end
function allianceGuideCtrl:Logout()
	allianceGuideCtrl.super.Logout(self)
	self:resetData()
end
function allianceGuideCtrl.getReward()
	return allianceGuideCtrl.alliance_guidance_award
end
function allianceGuideCtrl:getGuideStauts()
	return self.gStuts
end
function allianceGuideCtrl:isGuideDone()
	return self.gStuts ~= gStatus.noReach
end
function allianceGuideCtrl:isShowEnterPoint()
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local isJoin = allianceMgr:hasJoinAlliance()
	gametop = nil
	;(nil).byUID = true
	local tab = SoraDConfigGet("Game:allianceGuideCtrl:isEnterFirsr~table", nil)
	if tab == nil or next(tab) == nil or not isJoin then
		return false
	end
	if self.gStuts == 1 then
		return true
	end
	local isfirst = tab.isFirst
	print(isfirst)
	return not isfirst
end
function allianceGuideCtrl:reqRandomPoint()
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_RANDOM_TERR_POS)
end
function allianceGuideCtrl:reqGuideReward()
	print("获取联盟领地迁城任务奖励")
	serverproxy:Request(gCmd.CMD_ALLIANCE_GUIDE, gCmd.REQ_ALLIANCE_GUIDE_GET_TERR_MOVECITY_REWARD)
end
function allianceGuideCtrl:getRandomPoint(content)
	dump(content, "allianceGuideCtrl:getRandomPoint")
	if content.err == gErrDef.Err_None then
		SoraDRemoveAllPanelFromManager()
		local point = content.rspdata
		SoraDGotoWorldMapPoint(cc.p(point.x - 1, point.y - 1), false, nil, worldMapLayInstanceTypeDef.layInstanceCity)
	else
	end
end
_ENV, allianceGuideCtrl.getGuideReward = function(self, data)
	dump(data, "allianceGuideCtrl:getGuideReward")
	if data.err == gErrDef.Err_None then
		local rewarddata = data.rspdata
		_ENV = "allianceGuideCtrl:getGuideReward"
		;("allianceGuideCtrl:getGuideReward").msg = "MESSAGE_ALLIANCEGUIDE_CLAIM_REWARD"
		;("allianceGuideCtrl:getGuideReward").reward = rewarddata
		SoraDSendMessage("allianceGuideCtrl:getGuideReward")
	end
end, function(self, data)
	dump(data, "allianceGuideCtrl:getGuideReward")
	if data.err == gErrDef.Err_None then
		local rewarddata = data.rspdata
		_ENV = "allianceGuideCtrl:getGuideReward"
		;("allianceGuideCtrl:getGuideReward").msg = "MESSAGE_ALLIANCEGUIDE_CLAIM_REWARD"
		;("allianceGuideCtrl:getGuideReward").reward = rewarddata
		SoraDSendMessage("allianceGuideCtrl:getGuideReward")
	end
end
;(function(self, data)
	dump(data, "allianceGuideCtrl:getGuideReward")
	if data.err == gErrDef.Err_None then
		local rewarddata = data.rspdata
		_ENV = "allianceGuideCtrl:getGuideReward"
		;("allianceGuideCtrl:getGuideReward").msg = "MESSAGE_ALLIANCEGUIDE_CLAIM_REWARD"
		;("allianceGuideCtrl:getGuideReward").reward = rewarddata
		SoraDSendMessage("allianceGuideCtrl:getGuideReward")
	end
end).noReach = 0
;(function(self, data)
	dump(data, "allianceGuideCtrl:getGuideReward")
	if data.err == gErrDef.Err_None then
		local rewarddata = data.rspdata
		_ENV = "allianceGuideCtrl:getGuideReward"
		;("allianceGuideCtrl:getGuideReward").msg = "MESSAGE_ALLIANCEGUIDE_CLAIM_REWARD"
		;("allianceGuideCtrl:getGuideReward").reward = rewarddata
		SoraDSendMessage("allianceGuideCtrl:getGuideReward")
	end
end).nocClaime = 1
local (function(self, data)
	dump(data, "allianceGuideCtrl:getGuideReward")
	if data.err == gErrDef.Err_None then
		local rewarddata = data.rspdata
		_ENV = "allianceGuideCtrl:getGuideReward"
		;("allianceGuideCtrl:getGuideReward").msg = "MESSAGE_ALLIANCEGUIDE_CLAIM_REWARD"
		;("allianceGuideCtrl:getGuideReward").reward = rewarddata
		SoraDSendMessage("allianceGuideCtrl:getGuideReward")
	end
end).claimed, gStatus = 2, function(self, data)
	dump(data, "allianceGuideCtrl:getGuideReward")
	if data.err == gErrDef.Err_None then
		local rewarddata = data.rspdata
		_ENV = "allianceGuideCtrl:getGuideReward"
		;("allianceGuideCtrl:getGuideReward").msg = "MESSAGE_ALLIANCEGUIDE_CLAIM_REWARD"
		;("allianceGuideCtrl:getGuideReward").reward = rewarddata
		SoraDSendMessage("allianceGuideCtrl:getGuideReward")
	end
end
function allianceGuideCtrl:changeType()
	if self.gStuts < 0 or self.gStuts > 1 then
		_ENV, _ENV = nil, nil
		;(nil).byUID = true
		SoraDConfigSet("Game:allianceGuideCtrl:isEnterFirsr~table", nil, nil)
		return
	end
	local isHas = allianceTerritoryAPI:checkHasMainBuilding(gAllianceBuilding.PALACE)
	_ENV = nil
	;(nil).byUID = true
	local tab = SoraDConfigGet("Game:allianceGuideCtrl:isEnterFirsr~table", nil)
	print("allianceGuideCtrl:changeType")
	dump(tab)
	if next(tab) == nil then
		print("未配置过")
		if isHas then
			print("有领地且未完成")
			_ENV = nil
			;(nil).isFirst = false
			;(nil).isnotFirst = true
			;(nil).ishasFirst = false
			_ENV, (nil).isGet = nil, false
			;(nil).byUID = true
			SoraDConfigSet("Game:allianceGuideCtrl:isEnterFirsr~table", nil, nil)
		else
			print("没领地且未完成")
			_ENV = nil
			;(nil).isFirst = false
			;(nil).isnotFirst = false
			;(nil).ishasFirst = false
			_ENV, (nil).isGet = nil, false
			;(nil).byUID = true
			SoraDConfigSet("Game:allianceGuideCtrl:isEnterFirsr~table", nil, nil)
		end
	else
	end
end
function allianceGuideCtrl:initClientData(data)
	local isHas = allianceTerritoryAPI:checkHasMainBuilding(gAllianceBuilding.PALACE)
	if data then
		self.gStuts = data.terrMoveCityStatus == nil and 0 or data.terrMoveCityStatus
		self:changeType()
	end
	allianceTerritoryAPI = self
	self.msg = "MESSAGE_GREEN_POINT_UPDATE"
	SoraDSendMessage(self)
	allianceTerritoryAPI = self
	self.msg = "MESSAGE_ALLIANCE_GUIDE_UPDATE"
	SoraDSendMessage(self)
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.ALLIANCE_GUIDE, handler(self, self.updateDataRsp))
end
function allianceGuideCtrl:updateDataRsp(data)
	if data.data[1] then
		self.gStuts = data.data[1].terrMoveCityStatus == nil and 0 or data.data[1].terrMoveCityStatus
		self:changeType()
	end
	_ENV = self
	self.msg = "MESSAGE_ALLIANCE_GUIDE_UPDATE"
	SoraDSendMessage(self)
	_ENV = self
	self.msg = "MESSAGE_GREEN_POINT_UPDATE"
	SoraDSendMessage(self)
end
return allianceGuideCtrl
