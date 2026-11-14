local htPointMgr = include("htPointMgr")
local htBattleMgr = include("htBattleMgr")
local htMapMgr = include("htMapMgr")
local htLogMgr = include("htLogMgr")
local heroTrialEntity = include("heroTrialEntity")
local heroTrialCommon = include("heroTrialCommon")
local msgNotice = include("msgNotice")
local heroTrialltCtrl = include("heroTrialltCtrl")
local heroTrialCtrl = SoraDGetCtrl("heroTrialCtrl")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local armyCtrl = SoraDGetCtrl("armyCtrl")
local dressCtrl = SoraDGetCtrl("dressCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
_ENV = "backpackCtrl"
;("backpackCtrl").QUIT_COMPLETE = 1
;("backpackCtrl").QUIT_MANUAL = 2
local ("backpackCtrl").QUIT_NOSOLDIERS, quitDef = 3, "backpackCtrl"
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local heroTrialMapViewPanel = class("heroTrialMapViewPanel", baseFguiPanel)
function heroTrialMapViewPanel:ctor(...)
	heroTrialMapViewPanel.super.ctor(self, ...)
	print("heroTrialMapViewPanel:ctor", self.viewName)
end
function heroTrialMapViewPanel:onInit()
	print("=======heroTrialMapViewPanel:onInit")
	self.isAttack = false
	self.isAuto = false
	self.isMapWin = false
	self.isBattleFinish = true
	self.fields.Com_title:initData(i18n("common_text_1697"), handler(self, self.onClickClose))
end
function heroTrialMapViewPanel:onShow()
	print("=======heroTrialMapViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.mapId = self.param.mapId
	self:initData(self.mapId)
end
function heroTrialMapViewPanel:initData(mapId)
	self.mapId = mapId
	self.curUnlockId = htMapMgr.getLastUnlockStage()
	self.curStageId = tonumber(mapId .. "01")
	self:initMap()
	if heroTrialCommon.isTrialStarted(self.mapId) then
		self:startTrial()
		self:beginBattle()
	else
		self:setAutoState(false)
	end
	heroTrialCtrl:getMapInfo(self.mapId)
	self:updateLog()
	self:setAutoTime()
	self.fields.Com_bottom:setSweep()
	self:updateData()
end
function heroTrialMapViewPanel:armyGo(data)
	heroTrialCtrl:attackStage(self.curStageId, data.armyList)
end
function heroTrialMapViewPanel:beginBattle()
	self.queue = queueCtrl:queryQueue(gQueueTypeDef.trial_march)
	if not self.queue then
		return
	end
	if not self.isBattleFinish then
		self:stopAllActions()
		self:battleFinish()
	end
	self.isAttack = true
end
function heroTrialMapViewPanel:endBattle(data)
	self.endBattleData = data
	self.isBattleFinish = false
	self.map:initData()
	self:battleFinish()
end
function heroTrialMapViewPanel:battleFinish()
	if not self.endBattleData then
		return
	end
	local entity = self.map:getEntity(self.curStageId)
	local data = self.endBattleData
	if data.battleRet then
		self:playWin()
		self.map:zhujueMove(self.curStageId)
	else
		self:playLose()
	end
	self.curUnlockId = htMapMgr.getLastUnlockStage()
	if not data.finish then
		self.curStageId = htBattleMgr.curTrialMap:getLastStage()
		self.map:getEntity(self.curStageId):updateState()
	end
	if data.battleRet then
		if data.finish then
			self.isMapWin = true
		end
		entity:updateState()
	else
		entity:updateState()
	end
	self.isAttack = false
	self.isBattleFinish = true
	if data.finish then
		self:stopTrial()
	end
	if data.battleRet and data.finish then
		self:quitPanel(1)
	elseif data.battleRet == false and data.finish then
		self:quitPanel(3)
	end
	if self.updateLogAfterAdd then
		self:updateLog()
		self.updateLogAfterAdd = false
	end
end
function heroTrialMapViewPanel:playWin()
	local logList = htLogMgr:getLogList()
	local rewards
	for i, v in ipairs(logList) do
		if v.logData and v.logData.stageID == self.curStageId then
			rewards = v.logData.reward
		end
	end
	if rewards and 0 < #rewards then
		local htLogMgr, itemList = #rewards, #rewards
		for i, v in ipairs(rewards) do
			itemList[v.id] = v.count
		end
		SoraDMailGainItems(itemList)
	end
end
function heroTrialMapViewPanel:playLose(...)
	if uiManager:getProxy("heroTrialFinish") then
		return
	end
	_ENV = nil
	;(nil).isWin = false
	;(nil).tips = i18n("epicbattle_text_17")
	uiManager:show("heroTrialFinish", nil)
end
function heroTrialMapViewPanel:updateLog()
	self.fields.Com_bottom:setLogView()
end
function heroTrialMapViewPanel:setQuitEvent(event)
	self.quitType = event
end
function heroTrialMapViewPanel:quitPanel(event)
	local closeCb = function()
		SoraDRemoveAllAfterPanelFromManager(self, true)
		self:close()
	end
	if event == 1 then
		_ENV = nil
		;(nil).isWin = true
		;(nil).cb = closeCb
		uiManager:show("heroTrialFinish", nil)
	elseif event == 2 then
		closeCb()
	elseif event == 3 then
		_ENV = nil
		;(nil).isWin = false
		;(nil).cb = closeCb
		uiManager:show("heroTrialFinish", nil)
	end
end
function heroTrialMapViewPanel:startTrial()
	SoraDAddMessage(self, "MESSAGE_UI_HEROTRIAL_ARMYGO", self.armyGo)
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRIAL_BEGIN_BATTLE", self.beginBattle)
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRIAL_END_BATTLE", self.endBattle)
	SoraDAddMessage(self, "MESSAGE_UI_HEROTRIAL_AUTOBATTLE", self.autoBattle)
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRIAL_AUTOTIME", self.setAutoTime)
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRIAL_UPDATE_LOG", self.addNewLog)
	SoraDAddMessage(self, "MESSAGE_SERVER_HEROTRIAL_STOP_AUTO", self.stopAuto)
	if htBattleMgr.autoStatus then
		self:setAutoState(true)
	else
		self:setAutoState(false)
	end
	self.curStageId = htBattleMgr.curTrialMap:getLastStage()
	self:updateLog()
	self:resetEntity()
end
function heroTrialMapViewPanel:stopTrial()
	SoraDRemoveMessageFromTargetByName(self, "MESSAGE_UI_HEROTRIAL_ARMYGO")
	SoraDRemoveMessageFromTargetByName(self, "MESSAGE_SERVER_HEROTRIAL_BEGIN_BATTLE")
	SoraDRemoveMessageFromTargetByName(self, "MESSAGE_SERVER_HEROTRIAL_END_BATTLE")
	SoraDRemoveMessageFromTargetByName(self, "MESSAGE_UI_HEROTRIAL_AUTOBATTLE")
	SoraDRemoveMessageFromTargetByName(self, "MESSAGE_SERVER_HEROTRIAL_AUTOTIME")
	SoraDRemoveMessageFromTargetByName(self, "MESSAGE_SERVER_HEROTRIAL_UPDATE_LOG")
	SoraDRemoveMessageFromTargetByName(self, "MESSAGE_SERVER_HEROTRIAL_STOP_AUTO")
	self:setAutoState(false)
	self.isAttack = false
	self.isAuto = false
	self.curStageId = tonumber(self.mapId .. "01")
	self:resetEntity()
end
function heroTrialMapViewPanel:resetEntity()
	self.map:resetEntity()
end
function heroTrialMapViewPanel:initMap()
	self.fields.Com_map:clearContent()
	local mapModel = heroTrialltCtrl.getStageTypeOfStage(self.curStageId)
	self.map = fguiHelper.createObject("heroTrial", "Com_mapMode" .. mapModel)
	self.fields.Com_map:setContent(self.map)
	self.map:init(self.mapId)
end
function heroTrialMapViewPanel:openDispatch()
	_ENV = nil
	;(nil).isAuto = true
	uiManager:show("heroTrialDispatchArmy", nil)
end
function heroTrialMapViewPanel:autoBattle(data)
	heroTrialCtrl:autoTrial(self.curStageId, data.armyList)
end
function heroTrialMapViewPanel:autoRsp(err)
	if err == gErrDef.Err_None then
		self:setAutoState(true)
	end
end
function heroTrialMapViewPanel:stopAuto()
	SoraDShowMsgBox(i18n("common_text_1877"), i18n("common_text_054"))
	self:setAutoState(false)
end
function heroTrialMapViewPanel:updatePraisePanel(target, data)
	if not data or not data.rankingData then
		_UPVALUE0_ = data.rankingData
	end
	self.fields.praiseNode:initData(data and data.likeStatus or false, data.rankingData, data.mapID or self.mapId)
end
function heroTrialMapViewPanel:startTrialRsp(err)
	if err == gErrDef.Err_None then
		self:startTrial()
		if self.canOpenTrial then
			self.canOpenTrial = false
			self:openDispatch()
			self.fields.Com_bottom:setAutoBtnTouch(true)
		end
	end
end
function heroTrialMapViewPanel:likeRsp(err, data)
	if err == gErrDef.Err_None then
		data.likeStatus = true
		self:updatePraisePanel(self, data)
	end
end
function heroTrialMapViewPanel:quitRsp(err, data)
	if err == gErrDef.Err_None then
		self:quitPanel(self.quitType)
		self.quitType = nil
	end
end
function heroTrialMapViewPanel:handleRsp(target, data)
	local specialErr
	if data.rsp.subcmd == gCmd.REQ_HT_OPEN_TRIAL and data.rsp.data.mapID == self.mapId then
		self:startTrialRsp(data.rsp.err, data.rsp.data)
	elseif data.rsp.subcmd == gCmd.REQ_HT_QUIT_TRIAL then
		specialErr = self:quitRsp(data.rsp.err, data.rsp.data)
	elseif data.rsp.subcmd == gCmd.REQ_HT_AUTO_TRIAL and heroTrialCommon.isTrialStarted(self.mapId) then
		specialErr = self:autoRsp(data.rsp.err, data.rsp.data)
	elseif data.rsp.subcmd == gCmd.REQ_HT_LIKE and data.rsp.data.mapID == self.mapId then
		specialErr = self:likeRsp(data.rsp.err, data.rsp.data)
	else
		specialErr = data.rsp.err
	end
	if not specialErr and data.rsp.err ~= gErrDef.Err_None then
		local errStr = msgNotice.getTipCode(data.rsp.err)
		if not errStr then
			errStr = data.rsp.err
		else
			errStr = i18n(errStr)
		end
		SoraDShowMsgTip(errStr)
	end
end
function heroTrialMapViewPanel:setAutoState(isAuto)
	local isAuto = isAuto or self.isAuto
	if isAuto then
		self.isAuto = true
	else
		self.isAuto = false
	end
	self.fields.Com_bottom:init(self.mapId, self)
	self:setAutoTime()
end
function heroTrialMapViewPanel:onNeedOpen()
	self.needOpenTrial = true
end
function heroTrialMapViewPanel:setAutoTime()
	self.fields.autoTime:initData()
end
function heroTrialMapViewPanel:updateData()
	self.fields.Com_point:setPoint()
end
function heroTrialMapViewPanel:onHide()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_HEROTRIAL_UPDATE_AREA"
	SoraDSendMessage(nil)
end
function heroTrialMapViewPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "challenge" then
		local single = self.map:getEntity(self.curStageId)
		return single
	end
	return self.fields[itemName]
end
return heroTrialMapViewPanel
