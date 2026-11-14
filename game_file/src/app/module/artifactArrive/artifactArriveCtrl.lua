local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local artifactArriveCtrl = class("artifactArriveCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function artifactArriveCtrl:ctor(properties)
	self.itemId = 841901
	self.activityID = gActivityTimeActivityID.ARTIFACT_ARRIVE_ACTIVITY
	artifactArriveCtrl.super.ctor(self, properties)
	self:resetData()
end
function artifactArriveCtrl:EnterGame()
	msgCtrl.register(gCmd.CMD_ARTIFACT_ARRIVE_MODULE, gCmd.REQ_ARTIFACT_ARRIVE_INIT, handler(self, self.reqArtifactArriveInitRsp))
	msgCtrl.register(gCmd.CMD_ARTIFACT_ARRIVE_MODULE, gCmd.REQ_ARTIFACT_ARRIVE_PUT, handler(self, self.reqArtifactArrivePutRsp))
	self:registerNotify()
end
function artifactArriveCtrl:Logout()
	artifactArriveCtrl.super.Logout(self)
	self:resetData()
end
function artifactArriveCtrl:resetData()
	self.bossPos = cc.p(0, 0)
	self.captainGetRewardCount = 0
	self.disappearTime = 0
end
function artifactArriveCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.ARTIFACT_ARRIVE, handler(self, self.notifyHandler))
end
function artifactArriveCtrl:notifyHandler(event)
	dump(event.data, "artifactArriveCtrl:notifyHandler", 10)
	for k, v in ipairs(event.data) do
		self.captainGetRewardCount = v.captainGetRewardCount
		self.bossPos = cc.p(v.x or 0, v.y or 0)
		_ENV = v.x or 0
		;(v.x or 0).msg = "MESSAGE_ARTIFACT_ARRIVE_REFRESH"
		SoraDSendMessage(v.x or 0)
		_ENV = v.x or 0
		;(v.x or 0).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		;(v.x or 0).eventID = self.activityID
		SoraDSendMessage(v.x or 0)
	end
end
function artifactArriveCtrl:sendReqInitDataMsg()
	if clientEventMgr.judgeIsOpen(self.activityID) then
		_ENV = nil
		serverproxy:Request(gCmd.CMD_ARTIFACT_ARRIVE_MODULE, gCmd.REQ_ARTIFACT_ARRIVE_INIT, nil)
	end
end
function artifactArriveCtrl:reqArtifactArrivePut()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ARTIFACT_ARRIVE_MODULE, gCmd.REQ_ARTIFACT_ARRIVE_PUT, nil)
end
function artifactArriveCtrl:reqArtifactArriveInitRsp(content)
	dump(content, "artifactArriveCtrl:reqArtifactArriveInitRsp(content)", 10)
	if content.err == gErrDef.Err_None then
		self.bossPos = cc.p(content.rspdata.initData.x or 0, content.rspdata.initData.y or 0)
		self.captainGetRewardCount = content.rspdata.initData.captainGetRewardCount or 0
		self.disappearTime = content.rspdata.initData.disappearTime
		_ENV = content.rspdata.initData.x or 0
		;(content.rspdata.initData.x or 0).msg = "MESSAGE_ARTIFACT_ARRIVE_REFRESH"
		SoraDSendMessage(content.rspdata.initData.x or 0)
		_ENV = content.rspdata.initData.x or 0
		;(content.rspdata.initData.x or 0).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		;(content.rspdata.initData.x or 0).eventID = self.activityID
		SoraDSendMessage(content.rspdata.initData.x or 0)
	end
end
function artifactArriveCtrl:reqArtifactArrivePutRsp(content)
	dump(content, "artifactArriveCtrl:reqArtifactArrivePutRsp(content)", 10)
	SoraDCloseLoading()
	if content.err == gErrDef.Err_None then
		local dataTable = content.rspdata.info
		if dataTable.x and dataTable.y then
			self.bossPos = cc.p(dataTable.x or 0, dataTable.y or 0)
			SoraDGotoWorldMapPoint(cc.p(dataTable.x, dataTable.y), true)
			SoraDRemoveAllPanelFromManager()
		end
		_ENV = cc.p(dataTable.x, dataTable.y)
		cc.p(dataTable.x, dataTable.y).msg = "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH"
		cc.p(dataTable.x, dataTable.y).eventID = self.activityID
		SoraDSendMessage((cc.p(dataTable.x, dataTable.y)))
	else
	end
end
function artifactArriveCtrl:getBossPos()
	return self.bossPos
end
function artifactArriveCtrl:getCaptainRewardCount()
	return self.captainGetRewardCount
end
function artifactArriveCtrl:getDisappearTime()
	return self.disappearTime or serviceFunctions.systemTime()
end
function artifactArriveCtrl:getReceiveStatusAndNum()
	print("self.bossPos.x>0", self.bossPos.x, self.bossPos.y, SoraDGetCtrl("backpackCtrl"):getItemCount(self.itemId))
	if self.bossPos.x == 0 and self.bossPos.y == 0 and SoraDGetCtrl("backpackCtrl"):getItemCount(self.itemId) >= 5 then
		return true, -1
	else
		return false, 0
	end
end
return artifactArriveCtrl
