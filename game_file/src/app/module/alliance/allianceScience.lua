local gameModule = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local serverproxy = gModuleMgr.getObject("serverproxy")
local allianceltCtrl = include("allianceltCtrl")
local msgCtrl = include("msgCtrl")
local allianceScience = class("allianceScience", gameModule)
function allianceScience:ctor(properties)
	allianceScience.super.ctor(self, properties)
	self:resetData()
end
function allianceScience:resetData()
	self.scienceList, _UPVALUE0_ = nil, nil
	self.scienceRecommendList, _UPVALUE0_, self.donatequeue, _UPVALUE0_, self.scienceList.queue, _UPVALUE0_ = self.scienceList, self.scienceList, self.scienceList, self.scienceList
	self.prosperity = 0
	self.propertyList, _UPVALUE0_, self.popularity = self.scienceList, self.scienceList, 0
end
function allianceScience:getDonateHonorAdd()
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local addrate = (buffCtrl:getBuffEffect(gBuffEffect.AT_DONATE_HONOR_BOOST, gBuffSource.ACTIVITY) or 0) / 1000
	return addrate
end
function allianceScience:getDonateScoreAdd()
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local addrate = (buffCtrl:getBuffEffect(gBuffEffect.AT_DONATE_BONUS_BOOST, gBuffSource.ACTIVITY) or 0) / 1000
	return addrate
end
function allianceScience:researchSciQueueCallBack(event)
	local data = event.data
	local sciid = data.sciid
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	allianceMgr:reqGetAllianceScience()
	gametop = allianceMgr
	allianceMgr.msg = "MESSAGE_ALLIANCE_STUDY_END"
	allianceMgr.sciid = sciid
	SoraDSendMessage(allianceMgr)
end
function allianceScience:donateSciQueueCallBack(event)
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local member = memberMgr:getOwnMember()
	member:setProperty("donateLock", 0)
	gametop = member
	member.msg = "MESSAGE_ALLIACNE_DONATE_CD_CLEAN_SUCCESS"
	SoraDSendMessage(member)
end
function allianceScience:setScienceList(sciencelist, scienceRecommendList)
	if scienceRecommendList then
		self.scienceRecommendList, _ENV = nil, nil
	end
	for groupid, groupscilist in pairs(sciencelist.scilist) do
		table.sort(groupscilist, function(l, r)
			if l and r then
				return l.id < r.id
			else
				return false
			end
		end)
		if scienceRecommendList then
			for i, v in ipairs(groupscilist) do
				if scienceRecommendList[tostring(v.id)] then
					v.isRecommended = true
					self.scienceRecommendList[v.id] = v
				end
			end
		else
			for i, v in ipairs(groupscilist) do
				if self.scienceRecommendList[v.id] then
					v.isRecommended = true
					self.scienceRecommendList[v.id] = v
				end
			end
		end
	end
	self.scienceList.scilist = sciencelist.scilist
	local researchsciqueue = sciencelist.queue[SCIENCE_RESEARCH_QUEUE]
	if researchsciqueue then
		local starttime = researchsciqueue.starttime
		local totaltime = researchsciqueue.totaltime
		local nowtime = serviceFunctions.systemTime()
		local lasttime = nowtime - starttime
		local lefttime = totaltime - lasttime
		if lefttime <= 0 then
			lefttime = 0
		end
		self:addQueue(SCIENCE_RESEARCH_QUEUE, starttime, totaltime, lefttime, researchsciqueue.data)
	else
		self:removeQueue(SCIENCE_RESEARCH_QUEUE)
	end
	if sciencelist.popularity and sciencelist.popularity ~= self.popularity then
		self.popularity = sciencelist.popularity
		_ENV = self.popularity
		self.popularity.msg = "MESSAGE_ALLIANCE_POPULARITY_CHANGE"
		SoraDSendMessage(self.popularity)
	end
	if sciencelist.prosperity and sciencelist.prosperity ~= self.prosperity then
		self.prosperity = sciencelist.prosperity
		self.propertyList = self:getProsperityPropertyList(self.prosperity)
		_ENV = self
		self.msg = "MESSAGE_GREEN_POINT_UPDATE_BYTYPE"
		self.type = ALLIANCE_MAIN_MENU_TYPE.SCIENCE
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_ALLIANCE_PROSPERITY_CHANGE"
		SoraDSendMessage(self)
	end
end
function allianceScience:getPopularity(...)
	return self.popularity
end
function allianceScience:getProsperity(...)
	return self.prosperity
end
function allianceScience:getPropertyList(...)
	return self.propertyList
end
function allianceScience:getScienceGroup()
	return self.scienceList.scilist
end
function allianceScience:getCurMaxGroupID()
	local ret = gAScienceGroup.G1
	if not self.scienceList.scilist or not table.keys(self.scienceList.scilist) then
		local _ENV, keys = table.keys(self.scienceList.scilist), table.keys(self.scienceList.scilist)
	end
	for k, v in pairs(keys) do
		if ret < tonumber(v) then
			ret = tonumber(v)
		end
	end
	return ret
end
function allianceScience:getNextGroupSciIDList()
	local nextgroupid = self:getCurMaxGroupID() + 1
	if nextgroupid <= gAScienceGroup.G7 then
		local ret = allianceltCtrl.getScienceIDList(nextgroupid)
		table.sort(ret)
		local needlv = allianceltCtrl.scienceAttr(ret[1], gAScienceInfo.OPENLV)
		return ret, needlv
	end
end
function allianceScience:isSciLvFull()
	local ret = true
	if self.scienceList and self.scienceList.scilist then
		for groupid, groupscilist in pairs(self.scienceList.scilist) do
			for k, scidata in pairs(groupscilist) do
				local maxLv = allianceltCtrl.scienceAttr(scidata.id, gAScienceInfo.MAXLV)
				if maxLv > scidata.lv then
					return false
				end
			end
		end
	end
	return ret
end
function allianceScience:getCurSciTotalLv()
	local ret = 0
	if not self.scienceList or not self.scienceList.scilist then
		local _ENV, scilist = self.scienceList.scilist, self.scienceList.scilist
	end
	for groupid, groupscilist in pairs(scilist) do
		for k, scidata in pairs(groupscilist) do
			ret = ret + scidata.lv
		end
	end
	return ret
end
function allianceScience:getScienceData(id)
	if id then
		if not self.scienceList or not self.scienceList.scilist then
			local _ENV, scilist = self.scienceList.scilist, self.scienceList.scilist
		end
		for groupid, groupscilist in pairs(scilist) do
			for _k, _v in pairs(groupscilist) do
				if _v.id == id then
					return _v
				end
			end
		end
	end
end
function allianceScience:getScienceAddValue(scitype)
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local ownalliid = allianceMgr:getOwnAid()
	if not ownalliid then
		return 0
	end
	local ret = 0
	local sciidlist = allianceltCtrl.getSciIDListBySciType(scitype)
	for k, sciid in pairs(sciidlist) do
		local scidata = self:getScienceData(sciid)
		if scidata then
			local dtype, addvalue = allianceltCtrl.getScienceValue(sciid, scidata.lv)
			ret = ret + addvalue
		end
	end
	for i, v in ipairs(self.propertyList) do
		if v.allianceEffect and v.eid == scitype then
			ret = ret + v.value
			break
		end
	end
	return ret
end
function allianceScience:EnterGame()
	allianceScience.super.EnterGame(self)
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_DONATE_SCI, handler(self, self.DonateSciRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_RESEARCH_SCI, handler(self, self.ResearchSciRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_CLEAN_DONATE_SCI_CD, handler(self, self.CleanDonateSciCDRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_ADD_RECOMMEND_SCI, handler(self, self.AddRecommendSciRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_REMOVE_RECOMMEND_SCI, handler(self, self.RemoveRecommendSciRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_DONATE_POPULARITY, handler(self, self.donatePopularityRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_CLEAN_DONATE_POPULARITY_CD, handler(self, self.cleanDonatePopularityCDRsp))
	msgCtrl.register(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_RECIEVE_PROSPERITY_REWARD, handler(self, self.receiveProsperityRewardRsp))
	self:addEventListener(SCIENCE_RESEARCH_QUEUE, handler(self, self.researchSciQueueCallBack))
	self:addEventListener(SCIENCE_DONATE_QUEUE, handler(self, self.donateSciQueueCallBack))
end
function allianceScience:Logout()
	allianceScience.super.Logout(self)
	self:resetData()
end
function allianceScience:addQueue(queuetype, starttime, totaltime, lefttime, data)
	local curqueue = self:queryQueue(queuetype)
	if not curqueue then
		local dispatchQueueEvent = function()
			queuetype = nil
			;(nil).name = queuetype
			local (nil).data, event = data, nil
			if queuetype == SCIENCE_RESEARCH_QUEUE then
				self.scienceList.queue[SCIENCE_RESEARCH_QUEUE] = nil
			else
				self.donatequeue[queuetype] = queue
			end
			self:dispatchEvent(event)
		end
		local _ENV, queue = queuetype, queuetype
		queue.qtype = queuetype
		queue.starttime = starttime
		queue.totaltime = totaltime
		queue.data = data
		local timerList = gModuleMgr.getObject("timerList")
		local ok, node = timerList:createTimer(lefttime, timerHandler(dispatchQueueEvent))
		if ok then
			queue.timerNode = node
			if queuetype == SCIENCE_RESEARCH_QUEUE then
				self.scienceList.queue[SCIENCE_RESEARCH_QUEUE] = queue
			else
				self.donatequeue[queuetype] = queue
			end
		end
	end
end
function allianceScience:removeQueue(queuetype)
	local issuccess = false
	local queue = self:queryQueue(queuetype)
	if queue then
		issuccess = true
		local timerList = gModuleMgr.getObject("timerList")
		timerList:cancelTimer(queue.timerNode)
		if queuetype == SCIENCE_RESEARCH_QUEUE then
			self.scienceList.queue[queuetype] = nil
		else
			self.donatequeue[queuetype] = nil
		end
	end
	return issuccess
end
function allianceScience:queryQueue(queuetype)
	if queuetype == SCIENCE_RESEARCH_QUEUE then
		local ret = self.scienceList.queue[SCIENCE_RESEARCH_QUEUE]
		if ret then
			return clone(ret)
		end
	else
		local ret = self.donatequeue[queuetype]
		if ret then
			return ret
		end
	end
end
function allianceScience:getScienceTechTime(scienceid)
	local buffCtrl = gametop.playertop_:getModule("buffCtrl")
	local addrate = (buffCtrl:getBuffEffect(gBuffEffect.AT_RESEARCH_SPEED_BOOST, gBuffSource.ACTIVITY) or 0) / 1000
	local scidata = self:getScienceData(scienceid)
	local allianceltCtrl = include("allianceltCtrl")
	local basetime = allianceltCtrl.scienceLvInfo(scidata.id, scidata.lv, gAScienceLv.RESEARCH_TIME) or 0
	local addalliacnesci = self:getScienceAddValue(gAScienceType.ALLIANCE_SCIENCE_RESEARCH_TIME)
	local researchtime = basetime * (1 / (1 + addalliacnesci))
	local activitytime = basetime * (1 / (1 + addalliacnesci + addrate))
	return researchtime, activitytime
end
function allianceScience:reqDonateSci(sciid, donatetype, ...)
	serverproxy = nil
	;(nil).sciid = sciid
	;(nil).donatetype = donatetype
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_DONATE_SCI, nil, ...)
end
function allianceScience:reqResearchSci(sciid, ...)
	serverproxy = nil
	;(nil).sciid = sciid
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_RESEARCH_SCI, nil, ...)
end
function allianceScience:reqCleanDonateSciCD(...)
	serverproxy = nil
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_CLEAN_DONATE_SCI_CD, nil, ...)
end
function allianceScience:DonateSciRsp(content)
	if content.err == gErrDef.Err_None then
		local data = content.data.retdata
		self:refreshMember(data.memberinfo)
		local addTime = gConstValue.ALLIANCE_DONATE_CD_TIME_EVERYTIME
		local queue = self:queryQueue(SCIENCE_DONATE_QUEUE)
		if queue then
			local timerList = gModuleMgr.getObject("timerList")
			timerList:increaseTime(queue.timerNode, addTime)
		else
			local starttime = serviceFunctions.systemTime()
			local totaltime = addTime
			local lefttime = addTime
			self:addQueue(SCIENCE_DONATE_QUEUE, starttime, totaltime, lefttime)
		end
		local costres = data.costres
		local get = data.get
		if get then
			local addhonor = get.honor
			local score = get.score
			local addscipoint = get.scipoint
			local scidouble = get.scidouble
			local honordouble = get.honordouble
			local msgNotice = include("msgNotice")
			_ENV = nil
			;(nil).count1 = addhonor
			;(nil).count2 = score
			msgNotice.notice("notice_0079", nil)
			if scidouble and not honordouble then
				_ENV = "notice_0079"
				;("notice_0079").msg = "MESSAGE_ALLIANCE_CONTRIBUTE_DOUBLE"
				;("notice_0079").bType = 1
				SoraDSendMessage("notice_0079")
			end
			if honordouble and not scidouble then
				_ENV = "notice_0079"
				;("notice_0079").msg = "MESSAGE_ALLIANCE_CONTRIBUTE_DOUBLE"
				;("notice_0079").bType = 2
				SoraDSendMessage("notice_0079")
			end
			if scidouble and honordouble then
				_ENV = "notice_0079"
				;("notice_0079").msg = "MESSAGE_ALLIANCE_CONTRIBUTE_DOUBLE"
				;("notice_0079").bType = 3
				SoraDSendMessage("notice_0079")
			end
		end
	else
		print("rsp error: ", content.err)
		if content.err == gErrDef.Err_ALLIANCE_SCORE_DONATE_MAX then
			local msgNotice = include("msgNotice")
			_ENV = data.costres
			data.costres.count = ALLIANCE_SCORE_DONATE_MAX_COUNT_DAY
			msgNotice.notice("notice_0185", data.costres)
		end
	end
	_ENV = msgNotice.notice
	msgNotice.notice.msg = "MESSAGE_ALLIACNE_DONATE_SUCCESS"
	msgNotice.notice.sciid = content.data.sciid
	SoraDSendMessage(msgNotice.notice)
end
function allianceScience:ResearchSciRsp(content)
	if content.err == gErrDef.Err_None then
	else
		print("rsp error: ", content.err)
	end
end
function allianceScience:CleanDonateSciCDRsp(content)
	if content.err == gErrDef.Err_None then
		local data = content.data.retdata
		self:refreshMember(data.memberinfo)
		self:removeQueue(SCIENCE_DONATE_QUEUE)
		_ENV = self
		self.msg = "MESSAGE_ALLIACNE_DONATE_CD_CLEAN_SUCCESS"
		SoraDSendMessage(self)
		_ENV = self
		self.msg = "MESSAGE_UI_PANDECT_ALLIANCE"
		SoraDSendMessage(self)
	else
		print("rsp error: ", content.err)
	end
end
function allianceScience:getAllianceFlagInfo()
	local scitype = gAScienceType.ADD_ALLIANCE_FLAG_NUM
	local _ENV, ret
	ret.curSciAddCount = self:getScienceAddValue(scitype)
	ret.maxSciAddCount = 0
	local sciidlist = allianceltCtrl.getSciIDListBySciType(scitype)
	for k, sciid in pairs(sciidlist) do
		local maxLv = allianceltCtrl.scienceAttr(sciid, gAScienceInfo.MAXLV)
		local dtype, addCount = allianceltCtrl.getScienceValue(sciid, maxLv)
		if addCount then
			ret.maxSciAddCount = ret.maxSciAddCount + addCount
		end
	end
	return ret
end
function allianceScience:getRecommendList()
	local _ENV, ret
	for k, v in pairs(self.scienceRecommendList) do
		table.insert(ret, v)
	end
	if next(ret) then
		table.sort(ret, function(l, r)
			return l.id < r.id
		end)
	end
	return ret
end
function allianceScience:reqAddRecommendSci(sciid)
	serverproxy = nil
	;(nil).sciid = sciid
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_ADD_RECOMMEND_SCI, nil)
end
function allianceScience:reqRemoveRecommendSci(sciid)
	serverproxy = nil
	;(nil).sciid = sciid
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_REMOVE_RECOMMEND_SCI, nil)
end
function allianceScience:AddRecommendSciRsp(content)
	if content.err == gErrDef.Err_None then
		self:addRecommendSci(content.data.sciid)
		SoraDShowMsgTip(i18n("alliance_text_02"))
	else
		print("AddRecommendSciRsp error: ", content.err)
		_ENV = "AddRecommendSciRsp error: "
		;("AddRecommendSciRsp error: ").msg = "MESSAGE_ALLIANCE_SCIENCE_ADD_RECOMMEND_FAILED"
		SoraDSendMessage("AddRecommendSciRsp error: ")
	end
end
function allianceScience:RemoveRecommendSciRsp(content)
	if content.err == gErrDef.Err_None then
		SoraDShowMsgTip(i18n("alliance_text_09"))
	else
		_ENV = i18n("alliance_text_09")
		i18n("alliance_text_09").msg = "MESSAGE_ALLIANCE_SCIENCE_REMOVE_RECOMMEND_FAILED"
		SoraDSendMessage(i18n("alliance_text_09"))
		print("RemoveRecommendSciRsp error: ", content.err)
	end
end
function allianceScience:addRecommendSci(sciid)
	Log.i("addRecommendSci", sciid)
	for groupid, groupscilist in pairs(self.scienceList.scilist) do
		for i, v in ipairs(groupscilist) do
			if v.id == sciid then
				v.isRecommended = true
				self.scienceRecommendList[sciid] = v
				break
			end
		end
	end
	_ENV = pairs(self.scienceList.scilist)
	pairs(self.scienceList.scilist).msg = "MESSAGE_ALLIANCE_SCIENCE_ADD_RECOMMEND_SUCCESS"
	SoraDSendMessage(pairs(self.scienceList.scilist))
end
function allianceScience:removeRecommendSci(sciid)
	Log.i("removeRecommendSci", sciid)
	for groupid, groupscilist in pairs(self.scienceList.scilist) do
		for i, v in ipairs(groupscilist) do
			if v.id == sciid then
				v.isRecommended = nil
				self.scienceRecommendList[sciid] = nil
				break
			end
		end
	end
	_ENV = pairs(self.scienceList.scilist)
	pairs(self.scienceList.scilist).msg = "MESSAGE_ALLIANCE_SCIENCE_REMOVE_RECOMMEND_SUCCESS"
	SoraDSendMessage(pairs(self.scienceList.scilist))
end
function allianceScience:reqDonatePopularity(donatetype)
	serverproxy = nil
	;(nil).donatetype = donatetype
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_DONATE_POPULARITY, nil)
end
function allianceScience:donatePopularityRsp(content)
	dump(content, "allianceScience:donatePopularityRsp", 10)
	if content.err == gErrDef.Err_None then
		local data = content.data.retdata
		self:refreshMember(data.memberinfo)
		local get = data.get
		if get then
			local addhonor = get.honor
			local score = get.score
			local addPopularity = get.addPopularity
			local msgNotice = include("msgNotice")
			_ENV = nil
			;(nil).count1 = addhonor
			;(nil).count2 = score
			;(nil).value = addPopularity / 100
			msgNotice.notice("alliance_prosperity_text_22", nil)
			local scidouble = get.scidouble
			local honordouble = get.honordouble
			local bType
			if scidouble and not honordouble then
				bType = 4
			elseif honordouble and not scidouble then
				bType = 5
			elseif scidouble and honordouble then
				bType = 6
			end
			if bType then
				_ENV = nil
				;(nil).msg = "MESSAGE_ALLIANCE_CONTRIBUTE_DOUBLE"
				;(nil).bType = bType
				SoraDSendMessage(nil)
			end
		end
		_ENV = get.score
		get.score.msg = "MESSAGE_ALLIANCE_PROSPERITY_REFRESH"
		SoraDSendMessage(get.score)
	end
end
function allianceScience:reqCleanDonatePopularityCD()
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_CLEAN_DONATE_POPULARITY_CD)
end
function allianceScience:cleanDonatePopularityCDRsp(content)
	dump(content, "allianceScience:cleanDonatePopularityCDRsp", 10)
	if content.err == gErrDef.Err_None then
		local data = content.data.retdata
		self:refreshMember(data.memberinfo)
		_ENV = self
		self.msg = "MESSAGE_ALLIANCE_PROSPERITY_CLEAN_CD"
		SoraDSendMessage(self)
	end
end
function allianceScience:reqReceiveProsperityReward()
	serverproxy:Request(gCmd.CMD_ALLIANCE_MODULE, gCmd.REQ_ALLIANCE_RECIEVE_PROSPERITY_REWARD)
end
function allianceScience:receiveProsperityRewardRsp(content)
	dump(content, "allianceScience:receiveProsperityRewardRsp", 10)
	if content.err == gErrDef.Err_None then
		local data = content.data.retdata
		self:refreshMember(data.memberinfo)
		if data.rewards and next(data.rewards) then
			SoraDMailGainItems(data.rewards, true)
		end
		_ENV = data.rewards
		data.rewards.msg = "MESSAGE_ALLIANCE_PROSPERITY_REFRESH"
		SoraDSendMessage(data.rewards)
		_ENV = data.rewards
		data.rewards.msg = "MESSAGE_GREEN_POINT_UPDATE_BYTYPE"
		data.rewards.type = ALLIANCE_MAIN_MENU_TYPE.SCIENCE
		SoraDSendMessage(data.rewards)
		SoraDCloseLoading()
	end
end
function allianceScience:refreshMember(memberinfo)
	if not memberinfo then
		return
	end
	local member = include("member").new()
	member:setProperty("minfo", memberinfo)
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	memberMgr:addMember(member)
end
function allianceScience:isProsperityUnlock()
	local prosperityUnlock = require_data("alliance_prosperous_unlock", true).data
	for _, v in ipairs(prosperityUnlock) do
		local scidata = self:getScienceData(v.id)
		if not scidata then
			return false
		end
		if scidata.lv < v.maxLv or scidata.star < v.maxStar then
			return false
		end
	end
	return true
end
function allianceScience:getProsperityRewardsCount(...)
	local member = SoraDGetCtrl("memberMgr"):getOwnMember()
	local lastProsperity = member:getProperty("lastProsperity") or 0
	if lastProsperity >= self.prosperity then
		return 0
	end
	return math.floor((self.prosperity - lastProsperity) / 300)
end
function allianceScience:getProsperityPropertyList(prosperity)
	local prosperous_property = require_data("alliance_prosperous_property", true).data
	local _ENV, propertyList = "alliance_prosperous_property", "alliance_prosperous_property"
	for _, v in ipairs(prosperous_property) do
		if prosperity >= v.prosperous and next(v.effect) then
			_ENV = next(v.effect)
			next(v.effect).eid = v.effect[1]
			local next(v.effect).value, property = v.effect[2], next(v.effect)
			local needInsert = true
			for _, w in ipairs(propertyList) do
				if w.eid == property.eid and not w.allianceEffect then
					w.value = w.value + property.value
					needInsert = false
					break
				end
			end
			if needInsert then
				table.insert(propertyList, property)
			end
		end
		if prosperity >= v.prosperous and next(v.allianceEffect) then
			_ENV = next(v.allianceEffect)
			next(v.allianceEffect).eid = v.allianceEffect[1]
			next(v.allianceEffect).value = v.allianceEffect[2]
			local next(v.allianceEffect).allianceEffect, property = true, next(v.allianceEffect)
			local needInsert = true
			for _, w in ipairs(propertyList) do
				if w.eid == property.eid and w.allianceEffect then
					w.value = w.value + property.value
					needInsert = false
					break
				end
			end
			if needInsert then
				table.insert(propertyList, property)
			end
		end
	end
	dump(propertyList, "allianceScience:getProsperityPropertyList")
	return propertyList
end
function allianceScience:getProsperityNextProperty(prosperity)
	local prosperous_property = require_data("alliance_prosperous_property", true).data
	for _, v in ipairs(prosperous_property) do
		if prosperity < v.prosperous then
			local nextProsperity = v.prosperous
			local nextProperty
			if next(v.effect) then
				_ENV = next(v.effect)
				next(v.effect).eid = v.effect[1]
				nextProperty, next(v.effect).value = next(v.effect), v.effect[2]
			end
			local nextAllianceProperty
			if next(v.allianceEffect) then
				_ENV = next(v.allianceEffect)
				next(v.allianceEffect).eid = v.allianceEffect[1]
				next(v.allianceEffect).value = v.allianceEffect[2]
				nextAllianceProperty, next(v.allianceEffect).allianceEffect = next(v.allianceEffect), true
			end
			return nextProsperity, nextProperty, nextAllianceProperty
		end
	end
end
function allianceScience:getProsperityBuffEffect(effectType)
	local value = 0
	for _, property in ipairs(self.propertyList) do
		if property.eid == effectType then
			value = value + property.value
		end
	end
	return value
end
function allianceScience:getProsperityRemainCount(...)
	local member = SoraDGetCtrl("memberMgr"):getOwnMember()
	local dpState = member:getProperty("donatePopularityState")
	if not dpState.resetTime or not serviceFunctions.isSameDay(dpState.resetTime) then
		dpState.resetTime = serviceFunctions.systemTime()
		dpState.donateTimes = 0
	end
	member:setProperty("donatePopularityState", dpState)
	local constantRead = include("constantRead")
	local maxCount = constantRead.getConstValue("PROSPERITY_DONATE_MAX_NUM", 40)
	return math.max(maxCount - dpState.donateTimes, 0)
end
function allianceScience:isDonatePopularityLock(...)
	local member = SoraDGetCtrl("memberMgr"):getOwnMember()
	local dpLock = member:getProperty("donatePopularityLock")
	if dpLock == 1 then
		local remianTime = self:getDonatePopularityRemainTime()
		if remianTime <= 0 then
			member:setProperty("donatePopularityLock", 0)
			dpLock = 0
		end
	end
	return dpLock == 1
end
function allianceScience:getDonatePopularityRemainTime(...)
	local member = SoraDGetCtrl("memberMgr"):getOwnMember()
	local dpCD = member:getProperty("donatePopularityCD")
	if dpCD and dpCD.starttime then
		local remianTime = dpCD.starttime + dpCD.totaltime - serviceFunctions.systemTime()
		return remianTime
	end
	return 0
end
function allianceScience:dump()
	print("==============allianceScience:dump()=================")
end
return allianceScience
