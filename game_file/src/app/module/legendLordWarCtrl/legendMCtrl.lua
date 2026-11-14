local GameModule = include("GameModule")
local legendMCtrl = class("legendMCtrl", GameModule)
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
function legendMCtrl:ctor(properties)
	legendMCtrl.super.ctor(self, properties)
end
function legendMCtrl:EnterGame()
	print("legendMCtrl:EnterGame()---")
	legendMCtrl.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_KINGDOM_CHRONICLES_MODULE, gCmd.REQ_CHRONICLES_INIT_DATA, handler(self, self.reqStoryDataRsp))
	msgCtrl.register(gCmd.CMD_KINGDOM_CHRONICLES_MODULE, gCmd.REQ_CHRONICLES_HISTORY_REWARD, handler(self, self.reqHistoryRewardRsp))
	msgCtrl.register(gCmd.CMD_KINGDOM_CHRONICLES_MODULE, gCmd.REQ_CHRONICLES_QUERY_BIOGRAPHY_DATA, handler(self, self.reqKingsRsp))
	msgCtrl.register(gCmd.CMD_KINGDOM_CHRONICLES_MODULE, gCmd.REQ_CHRONICLES_CIVIL_REPORT, handler(self, self.reqCivilReportRsp))
	msgCtrl.register(gCmd.CMD_KINGDOM_CHRONICLES_MODULE, gCmd.REQ_CHRONICLES_COUNTRY_REPORT, handler(self, self.reqCountryReportRsp))
	msgCtrl.register(gCmd.CMD_KINGDOM_CHRONICLES_MODULE, gCmd.REQ_CHRONICLES_PRAISE, handler(self, self.reqPraiseRsp))
	msgCtrl.register(gCmd.CMD_KINGDOM_CHRONICLES_MODULE, gCmd.REQ_CHRONICLES_ALLIANCE_ACHIEVE, handler(self, self.reqAllianceAchieveRsp))
	msgCtrl.register(gCmd.CMD_KINGDOM_CHRONICLES_MODULE, gCmd.REQ_CHRONICLES_KINGDOM_ACHIEVE, handler(self, self.reqKingdomAchieveRsp))
	msgCtrl.register(gCmd.CMD_KINGDOM_CHRONICLES_MODULE, gCmd.REQ_CHRONICLES_SET_BIOGRAPHY, handler(self, self.reqSetKingDesRsp))
	msgCtrl.register(gCmd.CMD_KINGDOM_CHRONICLES_MODULE, gCmd.REQ_CHRONICLES_ALLIANCE_ACHIEVE_CONTENT, handler(self, self.reqAllianceAchieveContentRsp))
	msgCtrl.register(gCmd.CMD_KINGDOM_CHRONICLES_MODULE, gCmd.REQ_CHRONICLES_KINGDOM_ACHIEVE_CONTENT, handler(self, self.reqKingdomAchieveContentRsp))
	msgCtrl.register(gCmd.CMD_KINGDOM_CHRONICLES_MODULE, gCmd.REQ_CHRONICLES_GET_ALLIANCE_ACHIEVE_REWARD, handler(self, self.reqAllianceAchieveRewardRsp))
	msgCtrl.register(gCmd.CMD_KINGDOM_CHRONICLES_MODULE, gCmd.REQ_CHRONICLES_GET_KINGDOM_ACHIEVE_REWARD, handler(self, self.reqKingdomAchieveRewardRsp))
	self:resetData()
	self:registerNotify()
	if IsArClient then
		self:reqStoryData()
	end
end
function legendMCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	self.handle_notify = notifyCtrl:register(gNotifyID.KING_CHRONICLES, handler(self, self.noitfyDataRsp))
end
function legendMCtrl:noitfyDataRsp(content)
	local notifydata = content.data
	dump(notifydata, "legendMCtrl:noitfyDataRsp(content)@@@", 10)
	for _, notifyMsg in ipairs(notifydata) do
		local notifyType = notifyMsg.type
		local notifyData = notifyMsg.data
		local notifyFunc = "onNotify_" .. notifyType
		if not self[notifyFunc] then
			print("hegemonCtrl:" .. notifyFunc .. " not implemented!")
		else
			self[notifyFunc](self, notifyData)
		end
		if notifyType == "kingdomAchieveRefresh" then
			self.kingdomAchieveData = notifyData.achieveData
			self:createBuffList()
			_ENV = self
			self.msg = "MESSAGE_MAINCITYVIEW_UPDATE_CITY_BUFF_VIEW"
			SoraDSendMessage(self)
		end
	end
end
function legendMCtrl:onNotify_story(notifyData)
	self.coverStatus.story = notifyData
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_LEGENDM_UPDATE_COVER_STATUS"
	SoraDSendMessage(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_UPDATE_HISTORY_VIEW"
	SoraDSendMessage(nil)
end
function legendMCtrl:onNotify_biography(notifyData)
	self.coverStatus.biography = notifyData
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_LEGENDM_UPDATE_COVER_STATUS"
	SoraDSendMessage(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_UPDATE_HISTORY_VIEW"
	SoraDSendMessage(nil)
end
function legendMCtrl:onNotify_civilWar(notifyData)
	self.coverStatus.civilWar = notifyData
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_LEGENDM_UPDATE_COVER_STATUS"
	SoraDSendMessage(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_UPDATE_HISTORY_VIEW"
	SoraDSendMessage(nil)
end
function legendMCtrl:onNotify_countryWar(notifyData)
	self.coverStatus.countryWar = notifyData
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_LEGENDM_UPDATE_COVER_STATUS"
	SoraDSendMessage(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_UPDATE_HISTORY_VIEW"
	SoraDSendMessage(nil)
end
function legendMCtrl:onNotify_kingAchieve(notifyData)
	self.coverStatus.kingAchieve = notifyData
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_LEGENDM_UPDATE_COVER_STATUS"
	SoraDSendMessage(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_UPDATE_HISTORY_VIEW"
	SoraDSendMessage(nil)
end
function legendMCtrl:onNotify_allianceAchieve(notifyData)
	self.coverStatus.allianceAchieve = notifyData
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_LEGENDM_UPDATE_COVER_STATUS"
	SoraDSendMessage(nil)
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINCITYVIEW_UPDATE_HISTORY_VIEW"
	SoraDSendMessage(nil)
end
function legendMCtrl:onNotify_contentRefresh(notifyData)
	dump(notifyData, "legendMCtrl:onNotify_contentRefresh(notifyData)", 10)
	local resetData = notifyData.resetData
	local uid = notifyData.uid
	_ENV = 10
	;(10).msg = "MESSAGE_SERVER_LEGENDM_KINGDOM_DES_NOTIFY"
	;(10).resetData = resetData
	;(10).uid = uid
	SoraDSendMessage(10)
end
function legendMCtrl:resetData()
	self.buffList, _UPVALUE0_, self.coverStatus, _UPVALUE0_, self.allianceAchieveData, _UPVALUE0_, self.kingdomAchieveData, _UPVALUE0_, self.initData, _UPVALUE0_ = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
end
function legendMCtrl:Logout()
	self:resetData()
	legendMCtrl.super.Logout(self)
end
function legendMCtrl:initClientData(retdata)
	if retdata and retdata.achieveData then
		self.kingdomAchieveData = retdata.achieveData
		self:createBuffList()
	end
end
function legendMCtrl:getKingsList()
end
function legendMCtrl:getUnlockData()
	return self.initData.unlockData
end
function legendMCtrl:getAllianceRewardData()
	return self.initData.allianceRewardData
end
function legendMCtrl:getKingdomRewardData()
	return self.initData.kingdomRewardData
end
function legendMCtrl:getPraiseData()
	return self.initData.praiseData
end
function legendMCtrl:getIsSelfPraiseById(reportId)
	if self.initData.praiseData and self.initData.praiseData[reportId] then
		return true
	end
	return false
end
function legendMCtrl:getIsChapterUnlock(chapterNum)
	local unlockData = self:getUnlockData()
	if unlockData[tostring(chapterNum)] then
		return true
	end
	return false
end
function legendMCtrl:getIsChapterCanUnlock(chapterNum)
	local unlockData = self:getUnlockData()
	local legendMDesRead = include("legendMDesRead")
	return legendMDesRead.getCanUnlokChapter(chapterNum, unlockData)
end
function legendMCtrl:getKingdomAchieveData()
	return self.kingdomAchieveData
end
function legendMCtrl:getAllianceAchieveData()
	return self.allianceAchieveData
end
function legendMCtrl:getKingdomAchieveDataById(achieveID)
	return self.kingdomAchieveData[tostring(achieveID)]
end
function legendMCtrl:createBuffList()
	local legendMDesRead = include("legendMDesRead")
	local serRoadBuffCfg = legendMDesRead.getServerRoadBuffCfg()
	local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
	local _ENV, buffList = "buffltCtrl", "buffltCtrl"
	for k, v in ipairs(serRoadBuffCfg) do
		if not self.kingdomAchieveData[tostring(v.achieveID)] then
			local _ENV, data = self.kingdomAchieveData[tostring(v.achieveID)], self.kingdomAchieveData[tostring(v.achieveID)]
		end
		if not data.id2buffInfo or not data.id2buffInfo[tostring(v.buff)] then
			local _ENV, buffInfo = data.id2buffInfo[tostring(v.buff)], data.id2buffInfo[tostring(v.buff)]
		end
		if data and data.status and data.status == 3 and next(buffInfo) and 1 < #buffInfo then
			local value = buffltCtrl:getEffect(v.buff)
			_ENV = nil
			;(nil).buffID = v.buff
			;(nil).achieveID = v.achieveID
			;(nil).effectType = buffltCtrl:getEffectType(v.buff)
			;(nil).value = value
			;(nil).finishTime = buffInfo[2]
			;(nil).totalTime = buffInfo[2] - buffInfo[1]
			;(nil).isPass = buffInfo[3]
			table.insert(buffList, nil)
		end
	end
	self.buffList = buffList
	return self.buffList
end
function legendMCtrl:isHaveKingdomAchieveData()
	if not self.buffList then
		local _UPVALUE0_, buffList = self.buffList, self.buffList
	end
	return buffList
end
function legendMCtrl:getKingdomAchiBuffEffect(effectType)
	local buffList = self:isHaveKingdomAchieveData()
	local value = 0
	for k, v in ipairs(buffList) do
		if v.effectType == effectType and v.finishTime > serviceFunctions.systemTime() and not v.isPass then
			value = value + v.value
		end
	end
	return value
end
function legendMCtrl:getAllianceAchieveDataById(achieveID)
	return self.allianceAchieveData[tostring(achieveID)]
end
function legendMCtrl:getIsAllianceAchieveRewardGet(achieveID)
	if self.initData.allianceRewardData[tostring(achieveID)] then
		return true
	end
	return false
end
function legendMCtrl:getIsKingdomAchieveRewardGet(achieveID)
	if self.initData.kingdomRewardData[tostring(achieveID)] then
		return true
	end
	return false
end
function legendMCtrl:getHistoryYear(time, isStr)
	local sysTime = time or serviceFunctions.systemTime()
	local year = os.date("%Y", sysTime)
	local month = os.date("%m", sysTime)
	local day = os.date("%d", sysTime)
	local historyYear = year - 2019 + 1162
	if isStr then
		_ENV = nil
		;(nil).time = historyYear
		return i18n("history_text_12", nil), month, day
	else
		return historyYear, month, day
	end
end
function legendMCtrl:getHistoryYearFull(time, isStr)
	local strY, strM, strD = legendMCtrl:getHistoryYear(time or serviceFunctions.systemTime())
	local strFull = string.format("%s.%s.%s", strY, strM, strD)
	if isStr then
		legendMCtrl = strM
		strM.time = strFull
		strFull = i18n("history_text_58", strM)
	end
	return strFull
end
function legendMCtrl:getHegemonBuildIdBySetType(setType)
	return setType - 3 + 601
end
function legendMCtrl:getCoverStatusData(coverIndex)
	local strType = gLegendHistoryCoverTypeToStr[coverIndex]
	return self.coverStatus[strType]
end
function legendMCtrl:resetCoverStatusData(coverIndex)
	local strType = gLegendHistoryCoverTypeToStr[coverIndex]
	self.coverStatus[strType].status = false
end
function legendMCtrl:getHasBuildReward()
	_UPVALUE3_ = nil
	;(nil)[1] = gLegendHistoryCoverType.STORY
	;(nil)[2] = gLegendHistoryCoverType.KING_ACHIEVE
	local (nil)[3], coverIndexArray = gLegendHistoryCoverType.ALLIANCE_ACHIEVE, nil
	for _, coverIndex in ipairs(coverIndexArray) do
		local strType = gLegendHistoryCoverTypeToStr[coverIndex]
		if self.coverStatus[strType] and self.coverStatus[strType].status then
			return true
		end
	end
	return false
end
function legendMCtrl:reqStoryData()
	print(" legendMCtrl:reqStoryData()")
	_ENV = nil
	serverproxy:Request(gCmd.CMD_KINGDOM_CHRONICLES_MODULE, gCmd.REQ_CHRONICLES_INIT_DATA, nil)
end
function legendMCtrl:reqHistoryReward(index)
	serverproxy = nil
	;(nil).index = index
	serverproxy:Request(gCmd.CMD_KINGDOM_CHRONICLES_MODULE, gCmd.REQ_CHRONICLES_HISTORY_REWARD, nil)
end
function legendMCtrl:reqKings(startIndex, kid)
	local count = 10
	serverproxy = nil
	;(nil).beginIndex = startIndex
	;(nil).count = count
	;(nil).kid = kid
	serverproxy:Request(gCmd.CMD_KINGDOM_CHRONICLES_MODULE, gCmd.REQ_CHRONICLES_QUERY_BIOGRAPHY_DATA, nil)
end
function legendMCtrl:reqCivilReport(startIndex, kid)
	local count = 10
	serverproxy = nil
	;(nil).beginIndex = startIndex
	;(nil).count = count
	;(nil).kid = kid
	serverproxy:Request(gCmd.CMD_KINGDOM_CHRONICLES_MODULE, gCmd.REQ_CHRONICLES_CIVIL_REPORT, nil)
end
function legendMCtrl:reqCountryReport(startIndex, kid)
	local count = 10
	serverproxy = nil
	;(nil).beginIndex = startIndex
	;(nil).count = count
	;(nil).kid = kid
	serverproxy:Request(gCmd.CMD_KINGDOM_CHRONICLES_MODULE, gCmd.REQ_CHRONICLES_COUNTRY_REPORT, nil)
end
function legendMCtrl:reqPraise(recordType, reportID)
	serverproxy = nil
	;(nil).recordType = recordType
	;(nil).reportID = reportID
	serverproxy:Request(gCmd.CMD_KINGDOM_CHRONICLES_MODULE, gCmd.REQ_CHRONICLES_PRAISE, nil)
end
function legendMCtrl:reqAllianceAchieve(index)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_KINGDOM_CHRONICLES_MODULE, gCmd.REQ_CHRONICLES_ALLIANCE_ACHIEVE, nil)
end
function legendMCtrl:reqKingdomAchieve()
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_KINGDOM_CHRONICLES_MODULE, gCmd.REQ_CHRONICLES_KINGDOM_ACHIEVE, nil)
end
function legendMCtrl:reqSetKingDes(des, setType, round, kid)
	serverproxy = nil
	;(nil).setType = setType
	;(nil).setData = des
	;(nil).round = round
	;(nil).kid = kid
	serverproxy:Request(gCmd.CMD_KINGDOM_CHRONICLES_MODULE, gCmd.REQ_CHRONICLES_SET_BIOGRAPHY, nil)
end
function legendMCtrl:reqAllianceAchieveContent(achieveID, startIndex)
	local count = 10
	serverproxy = nil
	;(nil).achieveID = achieveID
	;(nil).beginIndex = startIndex
	;(nil).count = count
	serverproxy:Request(gCmd.CMD_KINGDOM_CHRONICLES_MODULE, gCmd.REQ_CHRONICLES_ALLIANCE_ACHIEVE_CONTENT, nil)
end
function legendMCtrl:reqKingdomAchieveContent(achieveID, startIndex)
	local count = 10
	serverproxy = nil
	;(nil).achieveID = achieveID
	;(nil).beginIndex = startIndex
	;(nil).count = count
	serverproxy:Request(gCmd.CMD_KINGDOM_CHRONICLES_MODULE, gCmd.REQ_CHRONICLES_KINGDOM_ACHIEVE_CONTENT, nil)
end
function legendMCtrl:reqAllianceAchieveReward(achieveID)
	serverproxy = nil
	;(nil).achieveID = achieveID
	serverproxy:Request(gCmd.CMD_KINGDOM_CHRONICLES_MODULE, gCmd.REQ_CHRONICLES_GET_ALLIANCE_ACHIEVE_REWARD, nil)
end
function legendMCtrl:reqKingdomAchieveReward(achieveID)
	serverproxy = nil
	;(nil).achieveID = achieveID
	serverproxy:Request(gCmd.CMD_KINGDOM_CHRONICLES_MODULE, gCmd.REQ_CHRONICLES_GET_KINGDOM_ACHIEVE_REWARD, nil)
end
function legendMCtrl:reqStoryDataRsp(ret)
	if ret and ret.err == gErrDef.Err_None and ret.rspdata and ret.data then
		self.initData = ret.rspdata.initData
		if not ret.rspdata.coverStatus then
			_ENV = ret.rspdata.coverStatus
		end
		self.coverStatus = ret.rspdata.coverStatus
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_LEGENDM_STORY_DATA_BACK"
		SoraDSendMessage(gErrDef.Err_None)
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_MAINCITYVIEW_UPDATE_HISTORY_VIEW"
		SoraDSendMessage(gErrDef.Err_None)
	else
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_LEGENDM_STORY_DATA_BACK"
		SoraDSendMessage(gErrDef.Err_None)
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_MAINCITYVIEW_UPDATE_HISTORY_VIEW"
		SoraDSendMessage(gErrDef.Err_None)
	end
end
function legendMCtrl:reqHistoryRewardRsp(ret)
	dump(ret, "legendMCtrl:reqHistoryRewardRsp(ret)", 10)
	if ret and ret.err == gErrDef.Err_None and ret.rspdata and ret.data then
		self.initData.unlockData = ret.rspdata.unlockData
		local rewardInfo = ret.rspdata.rewardInfo
		SoraDMailGainItems(rewardInfo, true)
		_ENV = rewardInfo
		rewardInfo.msg = "MESSAGE_SERVER_LEGENDM_STORY_REWARD_DATA_BACK"
		SoraDSendMessage(rewardInfo)
	else
		_ENV = SoraDSendMessage
		SoraDSendMessage.msg = "MESSAGE_SERVER_LEGENDM_STORY_REWARD_DATA_BACK"
		SoraDSendMessage(SoraDSendMessage)
	end
end
function legendMCtrl:reqKingsRsp(ret)
	if ret and ret.err == gErrDef.Err_None and ret.rspdata and ret.data then
		local wget = ret.rspdata.hasMore
		local beginIndex = ret.data.beginIndex
		local dataList = ret.rspdata.biographyData
		local idx = beginIndex + #dataList
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_LEGENDM_KINGS_DATA_BACK"
		;(nil).idx = idx
		;(nil).wget = wget
		;(nil).dataList = dataList
		SoraDSendMessage(nil)
	else
		local beginIndex = ret.data.beginIndex
		_ENV = ret.rspdata.biographyData
		ret.rspdata.biographyData.msg = "MESSAGE_SERVER_LEGENDM_KINGS_DATA_BACK"
		ret.rspdata.biographyData.dataList, _ENV, ret.rspdata.biographyData.wget = beginIndex + #dataList, beginIndex + #dataList, false
		ret.rspdata.biographyData.idx = beginIndex
		SoraDSendMessage(ret.rspdata.biographyData)
	end
end
function legendMCtrl:reqCivilReportRsp(ret)
	local pageType = include("legendMDesRead").PageType.KINGDOM_BATTLE
	if ret and ret.err == gErrDef.Err_None and ret.rspdata and ret.data then
		local wget = ret.rspdata.hasMore
		local beginIndex = ret.data.beginIndex
		local dataList = ret.rspdata.civilReport
		local idx = beginIndex + #dataList
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_LEGENDM_CIVIL_REPORT_DATA_BACK"
		;(nil).idx = idx
		;(nil).wget = wget
		;(nil).dataList = dataList
		;(nil).pageType = pageType
		SoraDSendMessage(nil)
	else
		local beginIndex = ret.data.beginIndex
		_ENV = ret.rspdata.civilReport
		ret.rspdata.civilReport.msg = "MESSAGE_SERVER_LEGENDM_CIVIL_REPORT_DATA_BACK"
		ret.rspdata.civilReport.dataList, _ENV, ret.rspdata.civilReport.wget = beginIndex + #dataList, beginIndex + #dataList, false
		ret.rspdata.civilReport.idx = beginIndex
		ret.rspdata.civilReport.pageType = pageType
		SoraDSendMessage(ret.rspdata.civilReport)
	end
end
function legendMCtrl:reqCountryReportRsp(ret)
	local pageType = include("legendMDesRead").PageType.SERVER_BATTLE
	if ret and ret.err == gErrDef.Err_None and ret.rspdata and ret.data then
		local wget = ret.rspdata.hasMore
		local beginIndex = ret.data.beginIndex
		local dataList = ret.rspdata.countryReport
		local idx = beginIndex + #dataList
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_LEGENDM_COUNTRY_REPORT_DATA_BACK"
		;(nil).idx = idx
		;(nil).wget = wget
		;(nil).dataList = dataList
		;(nil).pageType = pageType
		SoraDSendMessage(nil)
	else
		local beginIndex = ret.data.beginIndex
		_ENV = ret.rspdata.countryReport
		ret.rspdata.countryReport.msg = "MESSAGE_SERVER_LEGENDM_CIVIL_REPORT_DATA_BACK"
		ret.rspdata.countryReport.dataList, _ENV, ret.rspdata.countryReport.wget = beginIndex + #dataList, beginIndex + #dataList, false
		ret.rspdata.countryReport.idx = beginIndex
		ret.rspdata.countryReport.pageType = pageType
		SoraDSendMessage(ret.rspdata.countryReport)
	end
end
function legendMCtrl:reqPraiseRsp(ret)
	if ret and ret.err == gErrDef.Err_None and ret.rspdata and ret.data then
		local praiseData = ret.rspdata.praiseData
		for k, v in pairs(praiseData) do
			self.initData.praiseData[k] = v
		end
		local reportData = ret.rspdata.reportData
		_ENV = pairs(praiseData)
		pairs(praiseData).msg = "MESSAGE_SERVER_LEGENDM_PRAISE_BACK"
		pairs(praiseData).reportData = reportData
		SoraDSendMessage(pairs(praiseData))
	else
	end
end
function legendMCtrl:reqAllianceAchieveRsp(ret)
	local pageType = include("legendMDesRead").PageType.ALLIANCEROAD
	if ret and ret.err == gErrDef.Err_None and ret.rspdata and ret.data then
		self.allianceAchieveData = ret.rspdata.achieveData
		_ENV = gErrDef.Err_None
		gErrDef.Err_None.msg = "MESSAGE_SERVER_LEGENDM_ALLIANCE_ACHIEVE_BACK"
		gErrDef.Err_None.pageType = pageType
		SoraDSendMessage(gErrDef.Err_None)
	else
	end
end
function legendMCtrl:reqKingdomAchieveRsp(ret)
	local pageType = include("legendMDesRead").PageType.SERVERROAD
	if ret and ret.err == gErrDef.Err_None and ret.rspdata and ret.data then
		self.kingdomAchieveData = ret.rspdata.achieveData
		self:createBuffList()
		_ENV = self
		self.msg = "MESSAGE_SERVER_LEGENDM_KINGDOM_ACHIEVE_BACK"
		self.pageType = pageType
		SoraDSendMessage(self)
	else
	end
end
function legendMCtrl:reqSetKingDesRsp(ret)
	if ret and ret.err == gErrDef.Err_None and ret.rspdata and ret.data then
		local backData = ret.rspdata.backData
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_LEGENDM_SET_BIOGRAPHY_BACK"
		;(nil).content = backData
		;(nil).sourceKid = ret.data.kid
		SoraDSendMessage(nil)
	else
		_ENV = SoraDSendMessage
		SoraDSendMessage.msg = "MESSAGE_SERVER_LEGENDM_SET_BIOGRAPHY_BACK"
		SoraDSendMessage(SoraDSendMessage)
	end
end
function legendMCtrl:reqAllianceAchieveContentRsp(ret)
	if ret and ret.err == gErrDef.Err_None and ret.rspdata and ret.data then
		local wget = ret.rspdata.hasMore
		local beginIndex = ret.data.beginIndex
		local dataList = ret.rspdata.contentData
		local idx = beginIndex + #dataList
		print("ret.data.achieveID = ", ret.data.achieveID)
		_ENV = "ret.data.achieveID = "
		;("ret.data.achieveID = ").msg = "MESSAGE_SERVER_LEGENDM_ALLIANCE_ACHIEVE_CONTENT"
		;("ret.data.achieveID = ").idx = idx
		;("ret.data.achieveID = ").wget = wget
		;("ret.data.achieveID = ").dataList = dataList
		;("ret.data.achieveID = ").achieveID = ret.data.achieveID
		SoraDSendMessage("ret.data.achieveID = ")
	else
		local beginIndex = ret.data.beginIndex
		_ENV = ret.rspdata.contentData
		ret.rspdata.contentData.msg = "MESSAGE_SERVER_LEGENDM_ALLIANCE_ACHIEVE_CONTENT"
		ret.rspdata.contentData.dataList, _ENV, ret.rspdata.contentData.wget = beginIndex + #dataList, beginIndex + #dataList, false
		ret.rspdata.contentData.idx = beginIndex
		ret.rspdata.contentData.achieveID = ret.data.achieveID
		SoraDSendMessage(ret.rspdata.contentData)
	end
end
function legendMCtrl:reqKingdomAchieveContentRsp(ret)
	if ret and ret.err == gErrDef.Err_None and ret.rspdata and ret.data then
		local wget = ret.rspdata.hasMore
		local beginIndex = ret.data.beginIndex
		local dataList = ret.rspdata.contentData
		local idx = beginIndex + #dataList
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_LEGENDM_KINGDOM_ACHIEVE_CONTENT"
		;(nil).idx = idx
		;(nil).wget = wget
		;(nil).dataList = dataList
		;(nil).achieveID = ret.data.achieveID
		SoraDSendMessage(nil)
	else
		local beginIndex = ret.data.beginIndex
		_ENV = ret.rspdata.contentData
		ret.rspdata.contentData.msg = "MESSAGE_SERVER_LEGENDM_KINGDOM_ACHIEVE_CONTENT"
		ret.rspdata.contentData.dataList, _ENV, ret.rspdata.contentData.wget = beginIndex + #dataList, beginIndex + #dataList, false
		ret.rspdata.contentData.idx = beginIndex
		ret.rspdata.contentData.achieveID = ret.data.achieveID
		SoraDSendMessage(ret.rspdata.contentData)
	end
end
function legendMCtrl:reqAllianceAchieveRewardRsp(ret)
	if ret and ret.err == gErrDef.Err_None and ret.rspdata and ret.data then
		local allianceRewardData = ret.rspdata.allianceRewardData
		if not self.initData.allianceRewardData then
			self.initData.allianceRewardData, _ENV = nil, nil
		end
		for k, v in pairs(allianceRewardData) do
			self.initData.allianceRewardData[k] = v
		end
		local rewardInfo = ret.rspdata.rewardInfo
		SoraDMailGainItems(rewardInfo, true)
		local pageType = include("legendMDesRead").PageType.ALLIANCEROAD
		_ENV = true
		;(true).msg = "MESSAGE_SERVER_LEGENDM_ALLIANCE_ACHIEVE_REWARD"
		;(true).pageType = pageType
		SoraDSendMessage(true)
	else
	end
end
function legendMCtrl:reqKingdomAchieveRewardRsp(ret)
	if ret and ret.err == gErrDef.Err_None and ret.rspdata and ret.data then
		local kingdomRewardData = ret.rspdata.kingdomRewardData
		local rewardInfo = ret.rspdata.rewardInfo
		if not self.initData.kingdomRewardData then
			self.initData.kingdomRewardData, _ENV = nil, nil
		end
		for k, v in pairs(kingdomRewardData) do
			self.initData.kingdomRewardData[k] = v
		end
		SoraDMailGainItems(rewardInfo, true)
		local pageType = include("legendMDesRead").PageType.SERVERROAD
		_ENV = true
		;(true).msg = "MESSAGE_SERVER_LEGENDM_KINGDOM_ACHIEVE_REWARD"
		;(true).pageType = pageType
		SoraDSendMessage(true)
	else
	end
end
return legendMCtrl
