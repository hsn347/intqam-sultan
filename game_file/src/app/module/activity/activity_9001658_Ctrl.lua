local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local activity_9001658_Ctrl = class("activity_9001658_Ctrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function activity_9001658_Ctrl:ctor(properties)
	activity_9001658_Ctrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001658
	self:resetData()
end
function activity_9001658_Ctrl:EnterGame()
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_ANNIVERSARY_2024_MAIN_INIT, handler(self, self.reqInitRsp))
	msgCtrl.register(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_ANNIVERSARY_2024_MAIN_GUIDE, handler(self, self.reqGuideRsp))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_INIT", handler(self, self.activityInitRsp))
end
function activity_9001658_Ctrl:Logout()
	activity_9001658_Ctrl.super.Logout(self)
	self:resetData()
end
function activity_9001658_Ctrl:resetData()
	self.initData, (nil).guide, _UPVALUE0_, _UPVALUE0_ = nil, nil, nil, nil
end
function activity_9001658_Ctrl:initClientData(userActivityModule)
	if not userActivityModule then
		return
	end
	local activityData = userActivityModule[tostring(self.activityID)]
	if activityData and next(activityData) then
		dump(activityData, "==activity_9001658_Ctrl:initClientData==", 10)
		self.initData = activityData
	end
end
function activity_9001658_Ctrl:activityInitRsp(target, event)
	if event.activityID == self.activityID then
		dump(event, "==activity_9001658_Ctrl:activityInitRsp==", 10)
		self.initData = event.initData
	end
end
function activity_9001658_Ctrl:sendReqInitDataMsg()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_ANNIVERSARY_2024_MAIN_INIT, nil)
end
function activity_9001658_Ctrl:reqInitRsp(content)
	dump(content, "activity_9001658_Ctrl:reqInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata
	end
end
function activity_9001658_Ctrl:reqGuide(guideID)
	serverproxy = nil
	;(nil).guideID = guideID
	serverproxy:Request(gCmd.CMD_USER_ACTIVITY_MODULE, gCmd.REQ_ANNIVERSARY_2024_MAIN_GUIDE, nil)
	if not self.initData.guide then
		local serverproxy, guide = self.initData.guide, self.initData.guide
	end
	guide[tostring(guideID)] = 1
end
function activity_9001658_Ctrl:reqGuideRsp(content)
	dump(content, "activity_9001658_Ctrl:reqGuideRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.initData = content.rspdata
	end
end
function activity_9001658_Ctrl:getServerStage(...)
	local serverStage = 0
	if not self.initData.guide then
		local _ENV, guide = self.initData.guide, self.initData.guide
	end
	for k, __ in pairs(guide) do
		local stage = tonumber(k)
		if serverStage < stage then
			serverStage = stage
		end
	end
	return serverStage
end
function activity_9001658_Ctrl:getCurTime(...)
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local beginTime = activityShowCtrl:getBeginTimeSecond(self.activityID)
	local curTime = serviceFunctions.systemTime() - beginTime
	return math.max(0, curTime)
end
function activity_9001658_Ctrl:getCurStage(...)
	local curTime = self:getCurTime()
	if curTime <= 0 then
		return 0
	end
	local activity_9001658_Read = include("activity_9001658_Read")
	return activity_9001658_Read.getCurStage()
end
function activity_9001658_Ctrl:checkGuide(...)
	if SoraDIsGameGuide() ~= nil or not SoraDCurrentSceneShowView("mainCityView") then
		return
	end
	if not clientEventMgr.judgeIsOpen(self.activityID) or not clientEventMgr.getEventInfoByeid(self.activityID) then
		return
	end
	local serverStage = self:getServerStage()
	local curStage = self:getCurStage()
	if serverStage < curStage then
		local topPanel = SoraDCurrentTopPanelFromManager()
		if not topPanel then
			_ENV = nil
			;(nil)[1] = 9990401
			;(nil)[2] = 9990402
			;(nil)[3] = 9990403
			;(nil)[4] = 9990404
			;(nil)[5] = 9990405
			;(nil)[6] = 9990406
			;(nil)[7] = 9990407
			;(nil)[8] = 9990408
			local (nil)[9], stage2step = 9990409, nil
			local step = stage2step[curStage] or 9990400 + curStage
			_ENV = nil
			;(nil).msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
			;(nil).step = step
			SoraDSendMessage(nil)
		elseif topPanel == SoraDSearchPanelFromManagerByName("Activity_9001658_Main") then
			topPanel:checkGuide()
		end
	end
end
function activity_9001658_Ctrl:getReceiveStatusAndNum(...)
	local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
	_UPVALUE2_ = "activityExchangeMallCtrl"
	;("activityExchangeMallCtrl")[1] = gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010003
	local ("activityExchangeMallCtrl")[2], config = gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010002, "activityExchangeMallCtrl"
	local num = 0
	for __, activityID in ipairs(config) do
		if clientEventMgr.judgeIsOpen(activityID) then
			local _ret, _num = activityExchangeMallCtrl:getReceiveStatusAndNum(activityID)
			if _ret then
				num = num + 1
			end
		end
	end
	return 0 < num, num
end
function activity_9001658_Ctrl:getChapterNewMap(...)
	if not self.chapterNewMap then
		_ENV = nil
		;(nil).byUID = true
		if not SoraDConfigGet("Game:activity_9001658:chapterNewMap~table", nil) then
			_ENV = SoraDConfigGet("Game:activity_9001658:chapterNewMap~table", nil)
		end
		self.chapterNewMap = SoraDConfigGet("Game:activity_9001658:chapterNewMap~table", nil)
	end
	return self.chapterNewMap
end
function activity_9001658_Ctrl:setChapterNewMap(chapterNewMap)
	self.chapterNewMap = chapterNewMap
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:activity_9001658:chapterNewMap~table", self.chapterNewMap, nil)
end
return activity_9001658_Ctrl
