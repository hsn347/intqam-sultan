local GameModule = include("GameModule")
local serverproxy = gModuleMgr.getObject("serverproxy")
local gametop = gModuleMgr.getObject("gametop")
local msgCtrl = include("msgCtrl")
local ramadanLetterCtrl = class("ramadanLetterCtrl", GameModule)
local ramadanLetterRead = include("ramadanLetterRead")
function ramadanLetterCtrl:ctor(properties)
	ramadanLetterCtrl.super.ctor(self, properties)
	self.activityID = gActivityTimeActivityID.RAMADAN_LETTER_ACTIVITY
end
function ramadanLetterCtrl:EnterGame()
	print("ramadanLetterCtrl:EnterGame")
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	msgCtrl.register(gCmd.CMD_RAMADAN_LETTER_MODULE, gCmd.REQ_RAMADAN_LETTER_INIT, handler(self, self.sendReqInitRsp))
	msgCtrl.register(gCmd.CMD_RAMADAN_LETTER_MODULE, gCmd.REQ_RAMADAN_LETTER_RECEIVE, handler(self, self.sendReceiveRsp))
	self:resetData()
	self:registerNotify()
	self:sendDataMsg()
end
function ramadanLetterCtrl:judgeClose(target, data)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		self:resetData()
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.eventID = self.activityID
		SoraDSendMessage(self)
	end
end
function ramadanLetterCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.RAMADAN_MARKET, handler(self, self.notifyHandler))
end
function ramadanLetterCtrl:notifyHandler(event)
	dump(event.data, "ramadanLetterCtrl:notifyHandler", 10)
	for _, content in ipairs(event.data) do
		self:setData(content)
		_ENV = self
		self.msg = "MESSAGE_RAMADAN_LETTER"
		self.subMsg = "init"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.eventID = self.activityID
		SoraDSendMessage(self)
	end
end
function ramadanLetterCtrl:initClientData(data)
	dump(data, "ramadanLetterCtrl:initClientData", 10)
	if data then
		self:setData(data)
	end
end
function ramadanLetterCtrl:Logout()
	self:resetData()
	ramadanLetterCtrl.super.Logout(self)
end
function ramadanLetterCtrl:resetData()
	self.data = nil
	self.isDialogShow = false
end
function ramadanLetterCtrl:setData(data)
	self.data = data
	if self.data and self.checkHandler then
		self.checkHandler()
		self.checkHandler = nil
	end
end
function ramadanLetterCtrl:sendDataMsg()
	serverproxy:Request(gCmd.CMD_RAMADAN_LETTER_MODULE, gCmd.REQ_RAMADAN_LETTER_INIT)
end
function ramadanLetterCtrl:sendReceiveMsg(chapterId)
	serverproxy = nil
	;(nil).chapterId = chapterId
	serverproxy:Request(gCmd.CMD_RAMADAN_LETTER_MODULE, gCmd.REQ_RAMADAN_LETTER_RECEIVE, nil)
end
function ramadanLetterCtrl:sendReqInitRsp(content)
	dump(content, "ramadanLetterCtrl:sendReqInfoRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		self:setData(data)
		_ENV = self
		self.msg = "MESSAGE_RAMADAN_LETTER"
		self.subMsg = "init"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		self.eventID = self.activityID
		SoraDSendMessage(self)
		return
	end
	if content.err == gErrDef.Err_RAMADAN_LETTER_ACTIVITY_NOT_OPEN then
		self:resetData()
	end
end
function ramadanLetterCtrl:sendReceiveRsp(content)
	dump(content, "==ramadanLetterCtrl：sendReqDonateRsp==", 20)
	if content.err == gErrDef.Err_None then
		local data = content.rspdata
		SoraDMailGainItems(content.rspdata.reward, true)
		_ENV = content.rspdata.reward
		content.rspdata.reward.msg = "MESSAGE_RAMADAN_LETTER"
		content.rspdata.reward.subMsg = "buy"
		content.rspdata.reward.reward = data.curInfo
		SoraDSendMessage(content.rspdata.reward)
		self:sendDataMsg()
		return
	end
end
function ramadanLetterCtrl:getReceiveStatusAndNum()
	print("ramadanLetterCtrl:getReceiveStatusAndNum")
	if not self.data then
		return false, 0
	end
	local curChapter = self:getCurChapter()
	local num = 0
	for index = 1, curChapter do
		if self:getIsHaveReward(index) then
			num = num + 1
		end
	end
	return 0 < num, num
end
function ramadanLetterCtrl:getdata()
	return self.data
end
function ramadanLetterCtrl:getCurChapter()
	local letters = ramadanLetterRead.getLetters()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local activityStartTime = activityShowCtrl:getBeginTimeSecond(gActivityTimeActivityID.RAMADAN_LETTER_ACTIVITY)
	local curChapter = 0
	for key, value in ipairs(letters) do
		local curStartTime = activityStartTime + (value.time - 1) * 24 * 60 * 60
		if curStartTime <= serviceFunctions.systemTime() then
			curChapter = key
		else
			break
		end
	end
	return curChapter
end
function ramadanLetterCtrl:getIsHaveReward(chapter)
	if not self.data then
		return false
	end
	chapter = chapter or self:getCurChapter()
	if chapter == 0 then
		return false
	end
	if not self.data.chapterRewards or not self.data.chapterRewards[tostring(chapter)] then
		return true
	end
	return false
end
function ramadanLetterCtrl:getIsNeedDialog()
	return self:getIsHaveReward() and not self.isDialogShow
end
function ramadanLetterCtrl:setIsDialogShow(isShow)
	self.isDialogShow = isShow
end
function ramadanLetterCtrl:setCheckDialog(checkHandler)
	self.checkHandler = checkHandler
end
return ramadanLetterCtrl
