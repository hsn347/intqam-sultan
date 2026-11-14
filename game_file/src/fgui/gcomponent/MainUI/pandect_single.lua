local pandectRead = include("pandectRead")
local buildLogic = include("buildLogic")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local stuffWorkshopCtrl = SoraDGetCtrl("stuffWorkshopCtrl")
local petCtrl = SoraDGetCtrl("petCtrl")
local kingdomMapCtrl = SoraDGetCtrl("kingdomMapCtrl")
local timeRewardCtrl = SoraDGetCtrl("timeRewardCtrl")
local treviFountainCtrl = SoraDGetCtrl("treviFountainCtrl")
local escortCtrl = SoraDGetCtrl("escortCtrl")
local pyramidCtrl = SoraDGetCtrl("pyramidCtrl")
local epicWarCtrl = SoraDGetCtrl("epicWarCtrl")
local arenaCtrl = SoraDGetCtrl("arenaCtrl")
local heroTrainGroundCtrl = SoraDGetCtrl("heroTrainGroundCtrl")
local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local allianceScience = SoraDGetCtrl("allianceScience")
local memberMgr = SoraDGetCtrl("memberMgr")
local allianceTreasureCtrl = SoraDGetCtrl("allianceTreasureCtrl")
local baseComponent = require("fgui.base.baseComponent")
local pandect_single = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/pandect_single", pandect_single)
function pandect_single:onInit()
	self.handle = nil
	self.fields.Button_go:addClickListener(handler(self, self.onBtnGoClick))
	self:fixChildrenPos()
	self.fields.Bar_queue:setScaleX(SoraDFIsRA() and 1 or -1)
end
function pandect_single:onShow()
end
function pandect_single:initData(info, isToIdle)
	self.info = info
	self.controllers.c1:setSelectedIndex(self.info.sType)
	if self.info.sType == 0 then
		self.fields.icon1:setSpriteFrame(self.info.data.typePicturt)
		self.fields.Text_name1:setString(i18n(self.info.data.typeName))
	elseif self.info.sType == 1 then
		self.fields.icon2:setSpriteFrame(self.info.data.listPicturt)
		_ENV = i18n(self.info.data.typeName)
		i18n(self.info.data.typeName).num = self.info.index
		self.fields.Text_name2:setString(i18n(self.info.data.listName, i18n(self.info.data.typeName)))
		self.fields.Image_line:setVisible(self.info.isShowLine or false)
		if isToIdle then
			print("防递归========")
			dump(self.info, "self.info====")
		elseif self[self.info.queueInfo.updateFunc] then
			self[self.info.queueInfo.updateFunc](self)
		end
	end
end
function pandect_single:onBtnGoClick()
	SoraDPlaySound()
	if self.handle then
		self.handle()
	end
	if self.info.data.type and self.info.data.index then
		local _str = string.format("%.2d%.2d", self.info.data.type, self.info.data.index)
		local status = self.info.status or 1
		_ENV = _str
		_str.status = status
		userSDKManager.logEvent(gSDKDef.TDonEvent.click_pandect_view .. _str, _str)
	end
	_ENV = 1
	;(1).msg = "MESSAGE_MAINUI_CLOSE_PANDECT"
	SoraDSendMessage(1)
end
function pandect_single:setLessModel(param)
	self.controllers.c2:setSelectedIndex(0)
	self.fields.Text_unLock:setString(param.midText or "")
	self.fields.Text_unLock:setColor(cc.c3b(190, 40, 40))
end
function pandect_single:setIdleModel(param)
	self.controllers.c2:setSelectedIndex(1)
	if param.hideBtn then
		self.fields.Button_go:setVisible(false)
		self.fields.Text_status:setVisible(true)
		self.fields.Text_status:setString(param.statusText or "")
		self.fields.Text_status:setColor(cc.c3b(183, 183, 183))
	else
		self.fields.Button_go:setVisible(true)
	end
	self.fields.Text_unLock:setString(param.midText or "")
	self.fields.Text_unLock:setColor(param.midColor or cc.c3b(255, 255, 0))
	if param.handle then
		self.fields.Button_go:setString(param.btnTitle or i18n("common_text_477"))
		self.handle = param.handle
	end
end
function pandect_single:setBussyModel(otherData)
	self.controllers.c2:setSelectedIndex(2)
	local queueCtrl, otherData = self.controllers.c2.setSelectedIndex, otherData or self.controllers.c2.setSelectedIndex
	local queueInfo = self.info.queueInfo
	local queue = otherData.queue or queueCtrl:queryQueue(queueInfo.queueType) or buildLogic.getBuildQueueByBid(queueInfo.bid)
	local bid = queue and queue.data and queue.data.bid or queueInfo.bid
	local iid = queue and queue.data and queue.data.iid or 0
	local queueCtrl, statusText = bid, otherData.statusText or buildLogic.getBuildStateStr(bid, iid)
	bid.statusText = statusText
	bid.queue = queue
	bid.leftTime = otherData.leftTime
	local bid.totalTime, param = otherData.totalTime, bid
	self:setBarModel(param)
end
function pandect_single:setBarModel(param)
	self.fields.Text_status:setString(param.statusText or "")
	self.fields.Text_status:setColor(cc.c3b(112, 199, 35))
	if param.queue then
		local leftTime = param.queue.timerNode.timer:getRemainTime()
		if 0 < leftTime then
			self.controllers.c2:setSelectedIndex(2)
			self.fields.Text_bar:setString(SoraDConvertSecondToString(leftTime))
			local totaltime = param.queue.ottime or param.queue.totaltime
			self.fields.Bar_queue:setPercent((totaltime - leftTime) / totaltime)
		else
			self.controllers.c2:setSelectedIndex(1)
			self:initData(self.info, true)
		end
	elseif param.totalTime and param.leftTime then
		local totalTime = math.ceil(param.totalTime)
		local leftTime = math.ceil(param.leftTime)
		if 0 < totalTime and 0 < leftTime then
			self.controllers.c2:setSelectedIndex(2)
			self.fields.Text_bar:setString(SoraDConvertSecondToString(leftTime))
			self.fields.Bar_queue:setPercent((totalTime - leftTime) / totalTime)
			leftTime = leftTime - 1
		else
			self.controllers.c2:setSelectedIndex(1)
			self:initData(self.info, true)
		end
	else
		self.controllers.c2:setSelectedIndex(1)
		self:initData(self.info, true)
	end
end
function pandect_single:setAllFinishedModel(statusText)
	_ENV = nil
	;(nil).statusText = statusText or i18n("common_text_2601")
	local (nil).hideBtn, param = true, nil
	self:setIdleModel(param)
end
function pandect_single:checkIsOwnLock(lv)
	local ret = false
	local isOwn = buildLogic.isOwnBuild(self.info.queueInfo.bid)
	local unlockLang = pandectRead.getUnlockLang(self.info.data.type, self.info.data.index, lv or SoraDGetCastleLv())
	if not isOwn then
		if unlockLang then
			buildLogic = self.info.data.type
			local self.info.data.type.midText, param = unlockLang, self.info.data.type
			self:setLessModel(param)
		else
			self:setIdleModel(self.info.queueInfo.lessConfig)
		end
		ret = true
	elseif lv and self.info.queueInfo and self.info.queueInfo.unlockLv and lv < self.info.queueInfo.unlockLv then
		buildLogic = self.info.queueInfo.unlockLv
		local self.info.queueInfo.unlockLv.midText, param = unlockLang, self.info.queueInfo.unlockLv
		self:setLessModel(param)
		ret = true
	end
	return ret
end
function pandect_single:checkCondition(lv)
	local ret = false
	local unlockLang = pandectRead.getUnlockLang(self.info.data.type, self.info.data.index, lv or SoraDGetCastleLv())
	if unlockLang then
		pandectRead, ret = self.info.data.type, true
		local self.info.data.type.midText, param = unlockLang, self.info.data.type
		self:setLessModel(param)
	end
	return ret
end
function pandect_single:checkConquest()
	local ret = false
	local isInConquestWar = conquestWarCtrl:isPlayerConquestWarMigration()
	if isInConquestWar then
		ret = true
		self:setAllFinishedModel(i18n("common_text_3114"))
	elseif worldMapDefine.isInWar() then
		conquestWarCtrl, ret = worldMapDefine.isInWar(), true
		local worldMapDefine.isInWar().midText, param = i18n("common_text_3385"), worldMapDefine.isInWar()
		self:setLessModel(param)
	end
	return ret
end
function pandect_single:checkAlliance()
	local ret = false
	local isJoin = allianceMgr:hasJoinAlliance()
	if not isJoin then
		allianceMgr, ret = allianceMgr, true
		allianceMgr.btnTitle = i18n("common_text_068")
		allianceMgr.status = 3
		local allianceMgr.handle, param = function()
			uiManager:show("AllianceJoinView")
		end, allianceMgr
		self:setIdleModel(param)
	end
	return ret
end
function pandect_single:setFreeBuildQueue()
	local queue = queueCtrl:queryQueue(self.info.queueInfo.queueType)
	if queue and queue.timerNode.timer:getRemainTime() > 0 then
		self:setBussyModel()
	else
		self:setIdleModel(self.info.queueInfo.idleConfig)
	end
end
function pandect_single:setRechargeBuildQueue()
	local rechargeQueue = cityCtrl:getCurCity():queryQueue(gQueueTypeDef.charge_build_queue)
	local queue = queueCtrl:queryQueue(gQueueTypeDef.charge_build_queue)
	if not queue and not rechargeQueue then
		self:setIdleModel(self.info.queueInfo.actConfig)
	elseif rechargeQueue and not queue then
		self:setIdleModel(self.info.queueInfo.idleConfig)
	elseif queue and rechargeQueue then
		self:setBussyModel()
	end
end
function pandect_single:setBuildStarQueue()
	local queue = queueCtrl:queryQueue(self.info.queueInfo.queueType)
	if queue and queue.timerNode.timer:getRemainTime() > 0 then
		queueCtrl = nil
		queueCtrl = nil
		;(nil).build = ""
		;(nil).statusText = i18n("Glory_text_31", nil)
		self:setBussyModel(nil)
	else
		self:setIdleModel(self.info.queueInfo.idleConfig)
	end
end
function pandect_single:setSoldierCampQueue()
	if not self:checkIsOwnLock() then
		local statusStr = buildLogic.getBuildStateStr(self.info.queueInfo.bid)
		if statusStr then
			self:setBussyModel()
		else
			self:setIdleModel(self.info.queueInfo.idleConfig)
		end
	end
end
function pandect_single:setCollegeQueue()
	if not self:checkIsOwnLock() then
		local statusStr = buildLogic.getBuildStateStr(self.info.queueInfo.bid)
		if statusStr then
			self:setBussyModel()
		else
			self:setIdleModel(self.info.queueInfo.idleConfig)
		end
	end
end
function pandect_single:setWorkshopQueue()
	if not self:checkCondition() then
		local queue = queueCtrl:queryQueue(self.info.queueInfo.queueType)
		if queue then
			local cur, total = stuffWorkshopCtrl:getOpenListCount()
			queueCtrl = nil
			queueCtrl = nil
			;(nil).des = cur .. "/" .. total
			;(nil).statusText = i18n("common_text_3951", nil)
			self:setBussyModel(nil)
		else
			self:setIdleModel(self.info.queueInfo.idleConfig)
		end
	end
end
function pandect_single:setPetQueue()
	if not self:checkCondition() then
		local petNum = table.nums(petCtrl:getPetList())
		if self.info.index == 1 then
			if 0 < petNum then
				if petCtrl.feedInfo.curFreeFeed < PET_FEED_FREE_TIMES_LIMIT then
					_ENV = petCtrl:getPetList()
					petCtrl:getPetList().count = PET_FEED_FREE_TIMES_LIMIT - petCtrl.feedInfo.curFreeFeed
					self.info.queueInfo.idleConfig.midText = i18n("common_text_3875", petCtrl:getPetList())
					self:setIdleModel(self.info.queueInfo.idleConfig)
				else
					self:setAllFinishedModel()
				end
			else
				self:setIdleModel(self.info.queueInfo.idleConfig)
			end
		elseif self.info.index == 2 then
			local nums = petCtrl:getCanReceiveSpecialSkillToolNum()
			if 0 < petNum then
				if 0 < nums then
					_ENV = petCtrl
					_ENV = PET_FEED_FREE_TIMES_LIMIT - petCtrl.feedInfo.curFreeFeed
					;(PET_FEED_FREE_TIMES_LIMIT - petCtrl.feedInfo.curFreeFeed).count = nums
					petCtrl.midText = i18n("common_text_3875", PET_FEED_FREE_TIMES_LIMIT - petCtrl.feedInfo.curFreeFeed)
					petCtrl.btnTitle = i18n("common_text_1146")
					local petCtrl.handle, param = function()
						petCtrl:reqOnkeyGetSpecialTool()
					end, petCtrl
					self:setIdleModel(param)
				else
					self:setAllFinishedModel(i18n("common_text_1892"))
				end
			else
				self:setIdleModel(self.info.queueInfo.idleConfig)
			end
		end
	end
end
function pandect_single:fixMass(queue)
	if not queue:isMainQueueFun() and queue:getStatus() == gMapMoveLineStatusType.moveLineStatusTypeWorking then
		return kingdomMapCtrl.kingdomMapCell:optMapEvent4Mass(queue)
	end
	return queue
end
function pandect_single:getRealTroops()
	local troops = kingdomMapCtrl:getMapEventList()
	local kingdomMapCtrl, realTroops = kingdomMapCtrl, kingdomMapCtrl
	for _, v in pairs(troops) do
		local queue = self:fixMass(v)
		local remainTime = queue:getStatusRemainTime()
		local totalTime = queue:getOrgStatusTotalTime()
		if 0 < remainTime and 0 < totalTime or remainTime <= 0 and totalTime <= 0 then
			table.insert(realTroops, queue)
		end
	end
	return realTroops
end
function pandect_single:setMarchQueue()
	local troops = self:getRealTroops()
	if next(troops) and troops[self.info.index] then
		local troop = troops[self.info.index]
		local iconName, scale, param = worldMapDefine.getSqueueIcon(troop:getMoveLineType(), troop.to.mapType, troop)
		self.fields.icon2:setSpriteFrame(iconName)
		if param.totalTime and param.leftTime and param.leftTime > 1 then
			self:setBarModel(param)
		elseif param.midText then
			self:setIdleModel(param)
		end
	else
		self:setIdleModel(self.info.queueInfo.idleConfig)
		self.fields.icon2:setSpriteFrame("icon_pandect_queue_army.png")
	end
end
function pandect_single:setGoodsQueue()
	local queue = queueCtrl:queryQueue(self.info.queueInfo.queueType)
	local isAllReceive = timeRewardCtrl:getTimeRewardData().isAllReceive or 0
	if isAllReceive == 1 then
		self:setAllFinishedModel()
	elseif queue and 1 < queue.timerNode.timer:getRemainTime() then
		queueCtrl = nil
		;(nil).statusText = i18n("common_text_046")
		self:setBussyModel(nil)
	else
		self:setIdleModel(self.info.queueInfo.idleConfig)
	end
end
function pandect_single:setDonateQueue()
	if not self:checkConquest() and not self:checkAlliance() then
		local queue = allianceScience:queryQueue(SCIENCE_DONATE_QUEUE)
		local isLock = memberMgr:getOwnMember():getProperty("donateLock") == 1
		if isLock and queue and queue.timerNode.timer:getRemainTime() > 0 then
			allianceScience = nil
			;(nil).queue = queue
			;(nil).statusText = i18n("common_text_046")
			self:setBussyModel(nil)
		else
			self:setIdleModel(self.info.queueInfo.idleConfig)
		end
	end
end
function pandect_single:setTreasureQueue()
	if not self:checkConquest() and not self:checkAlliance() then
		local depotBcell = cityCtrl:getBuildCell(BUILDID.DEPOT, 0)
		if not self:checkCondition(tonumber(depotBcell.info.lv)) then
			local coldTime, totalTime = allianceTreasureCtrl:getJoin1hourTime()
			if 0 < coldTime then
				cityCtrl = tonumber(depotBcell.info.lv)
				tonumber(depotBcell.info.lv).leftTime = coldTime
				tonumber(depotBcell.info.lv).totalTime = totalTime
				tonumber(depotBcell.info.lv).statusText = i18n("common_text_046")
				self:setBussyModel(tonumber(depotBcell.info.lv))
			else
				local isDigging = allianceTreasureCtrl:isDigging()
				local time = allianceTreasureCtrl:getNextFreeTime()
				if not totalTime or not (0 < totalTime) then
					totalTime = math.floor(time)
				end
				local helpedNum = allianceTreasureCtrl:getMyHelpedDig()
				if isDigging and 1 < time then
					cityCtrl = tonumber(depotBcell.info.lv)
					tonumber(depotBcell.info.lv).leftTime = time
					tonumber(depotBcell.info.lv).totalTime = totalTime
					tonumber(depotBcell.info.lv).statusText = 0 < helpedNum and i18n("overview_text_03") or i18n("overvier_text_07")
					self:setBussyModel(tonumber(depotBcell.info.lv))
				else
					local chance = allianceTreasureCtrl:getLeftChance()
					if 0 < chance then
						cityCtrl = "overvier_text_07"
						;("overvier_text_07").count = chance
						self.info.queueInfo.idleConfig.midText = i18n("common_text_3875", "overvier_text_07")
						self:setIdleModel(self.info.queueInfo.idleConfig)
					else
						self:setAllFinishedModel()
					end
				end
			end
		end
	end
end
function pandect_single:setTreasureHelpQueue()
	if not self:checkConquest() and not self:checkAlliance() then
		local depotBcell = cityCtrl:getBuildCell(BUILDID.DEPOT, 0)
		local target
		if not self:checkCondition(target, tonumber(depotBcell.info.lv)) then
			local coldTime, totalTime = allianceTreasureCtrl:getJoin1hourTime()
			if 0 < coldTime then
				cityCtrl = tonumber(depotBcell.info.lv)
				tonumber(depotBcell.info.lv).leftTime = coldTime
				tonumber(depotBcell.info.lv).totalTime = totalTime
				tonumber(depotBcell.info.lv).statusText = i18n("common_text_046")
				self:setBussyModel(tonumber(depotBcell.info.lv))
			else
				local isHelping, time = allianceTreasureCtrl:isHelping()
				if isHelping then
					cityCtrl = "common_text_046"
					;("common_text_046").leftTime = time
					;("common_text_046").totalTime = time
					;("common_text_046").statusText = i18n("overvier_text_09")
					self:setBussyModel("common_text_046")
				else
					local chance = allianceTreasureCtrl:getHelpCount()
					if 0 < chance then
						cityCtrl = "overvier_text_09"
						;("overvier_text_09").count = chance
						self.info.queueInfo.idleConfig.midText = i18n("common_text_3875", "overvier_text_09")
						self:setIdleModel(self.info.queueInfo.idleConfig)
					else
						self:setAllFinishedModel()
					end
				end
			end
		end
	end
end
function pandect_single:setWishQueue()
	if not self:checkIsOwnLock() then
		local queue = buildLogic.getBuildQueueByBid(self.info.queueInfo.bid)
		if queue then
			self:setBussyModel()
		else
			local freeTimes = treviFountainCtrl:getTreviFountainData().multipleTimes
			if 0 < freeTimes then
				buildLogic = nil
				;(nil).count = freeTimes
				self.info.queueInfo.idleConfig.midText = i18n("common_text_3875", nil)
				self:setIdleModel(self.info.queueInfo.idleConfig)
			else
				self:setAllFinishedModel()
			end
		end
	end
end
function pandect_single:setWishTreasure()
	if not self:checkIsOwnLock() then
		local queue = queueCtrl:queryQueue(gQueueTypeDef.endless_treasure_queue)
		if queue then
			queueCtrl = nil
			;(nil).statusText = i18n("endless_treasures_text_03")
			self:setBussyModel(nil)
		else
			self:setIdleModel(self.info.queueInfo.idleConfig)
		end
	end
end
function pandect_single:setEscortQueue()
	if worldMapDefine.isInWar() then
		_ENV = worldMapDefine.isInWar()
		local worldMapDefine.isInWar().midText, param = i18n("common_text_3385"), worldMapDefine.isInWar()
		self:setLessModel(param)
	elseif not self:checkConquest() and not self:checkCondition() then
		local leftTimes = escortCtrl.dataMgr:getEscortDayMax() - escortCtrl.dataMgr:getEscortCount()
		if 0 < leftTimes then
			local troops = self:getRealTroops()
			local data
			for k, v in pairs(troops) do
				if v:getEventType() == gMapEventTypeDef.mapEventTypeTroopInstance and v:getMoveLineType() == gMapMoveLineType.moveLineTypeEscort then
					data = v
					break
				end
			end
			if data and 0 < data:getStatusRemainTime() then
				_ENV = pairs(troops)
				pairs(troops).leftTime = data:getStatusRemainTime()
				pairs(troops).totalTime = data:getOrgStatusTotalTime()
				pairs(troops).statusText = i18n("common_text_2352")
				self:setBussyModel(pairs(troops))
			else
				_ENV = i18n("common_text_2352")
				i18n("common_text_2352").count = leftTimes
				self.info.queueInfo.idleConfig.midText = i18n("common_text_3875", (i18n("common_text_2352")))
				self:setIdleModel(self.info.queueInfo.idleConfig)
			end
		else
			self:setAllFinishedModel()
		end
	end
end
function pandect_single:setRobQueue()
	if worldMapDefine.isInWar() then
		_ENV = worldMapDefine.isInWar()
		local worldMapDefine.isInWar().midText, param = i18n("common_text_3385"), worldMapDefine.isInWar()
		self:setLessModel(param)
	elseif not self:checkConquest() and not self:checkCondition() then
		local robTimes = escortCtrl.dataMgr:getEscortRobDayMax() - escortCtrl.dataMgr:getRobCount()
		if 0 < robTimes then
			_ENV = nil
			;(nil).count = robTimes
			self.info.queueInfo.idleConfig.midText = i18n("common_text_3875", nil)
			self:setIdleModel(self.info.queueInfo.idleConfig)
		else
			self:setAllFinishedModel()
		end
	end
end
function pandect_single:setPyramidQueue()
	if not self:checkCondition() then
		local freeTimes = pyramidCtrl:getFreeTime()
		if freeTimes and 0 < freeTimes then
			pyramidCtrl = nil
			;(nil).count = freeTimes
			self.info.queueInfo.idleConfig.midText = i18n("common_text_3875", nil)
			self:setIdleModel(self.info.queueInfo.idleConfig)
		else
			self:setAllFinishedModel()
		end
	end
end
function pandect_single:setTrialQueue()
	if not self:checkConquest() and not self:checkCondition() then
		local htPointMgr = include("htPointMgr")
		local points = htPointMgr.getPoint()
		local htBattleMgr = include("htBattleMgr")
		local isAuto = htBattleMgr.autoStatus
		if isAuto then
			self:setAllFinishedModel(i18n("common_text_3911"))
		else
			local queue = queueCtrl:queryQueue(gQueueTypeDef.trial_march)
			if queue and queue.timerNode.timer:getRemainTime() > 0 then
				_ENV = i18n("common_text_3911")
				i18n("common_text_3911").statusText = i18n("common_text_3909")
				self:setBussyModel(i18n("common_text_3911"))
			elseif points and 0 < points then
				_ENV = i18n("common_text_3909")
				i18n("common_text_3909").count = points
				self.info.queueInfo.idleConfig.midText = i18n("common_text_3875", (i18n("common_text_3909")))
				self:setIdleModel(self.info.queueInfo.idleConfig)
			else
				self:setAllFinishedModel()
			end
		end
	end
end
function pandect_single:setEpicWarQueue()
	if not self:checkCondition(target) then
		local curAction = epicWarCtrl:getCurExploreCount()
		local maxAction = epicWarCtrl:getMaxExploreCount()
		_ENV = nil
		;(nil).num = curAction
		;(nil).maxnum = maxAction
		self.info.queueInfo.idleConfig.midText = i18n("epicbattle_text_26", nil)
		self:setIdleModel(self.info.queueInfo.idleConfig)
	end
end
function pandect_single:setArenaQueue()
	if not self:checkConquest() then
		local cell = cityCtrl:getBuildCell(BUILDID.DRILL_GROUDS, 0)
		local lv = cell and tonumber(cell.info.lv) or 0
		if not self:checkIsOwnLock(lv) then
			if not arenaCtrl:getBattleInfo() then
				local cityCtrl, arenaInfo = arenaCtrl:getBattleInfo(), arenaCtrl:getBattleInfo()
			end
			local localRemainTimes = arenaInfo.localArena and arenaInfo.localArena.remainTimes or 0
			local fightChanges = math.max(localRemainTimes, 0)
			if 0 < fightChanges then
				cityCtrl = nil
				;(nil).count = fightChanges
				self.info.queueInfo.idleConfig.midText = i18n("common_text_3875", nil)
				self:setIdleModel(self.info.queueInfo.idleConfig)
			else
				self:setAllFinishedModel()
			end
		end
	end
end
function pandect_single:setHeroTrainQueue()
	if not self:checkCondition() then
		local trainInfo = heroTrainGroundCtrl:getTrainInfoByPosition(self.info.index)
		if trainInfo then
			local myState = heroTrainGroundCtrl.serverState2clientState(trainInfo.status)
			if gHeroTrainSingleStyle.idle == myState then
				self.info.queueInfo.idleConfig.midText = i18n("herotrain_text_01")
				self.info.queueInfo.idleConfig.midColor = cc.c3b(115, 115, 115)
				self:setIdleModel(self.info.queueInfo.idleConfig)
			elseif gHeroTrainSingleStyle.trainning == myState then
				local begintime = trainInfo.begintime
				local endtime = trainInfo.endtime
				local nowtime = serviceFunctions.systemTime()
				local curtime = math.max(endtime - nowtime, 1)
				local totaltime = math.max(endtime - begintime, 1)
				heroTrainGroundCtrl = nil
				;(nil).leftTime = curtime
				;(nil).totalTime = totaltime
				;(nil).statusText = i18n("herotrain_text_02")
				self:setBussyModel(nil)
			elseif gHeroTrainSingleStyle.done == myState then
				self:setAllFinishedModel(i18n("herotrain_text_04"))
			end
		end
	end
end
function pandect_single:setMasteryQueue()
	local queue = queueCtrl:queryQueue(self.info.queueInfo.queueType)
	if queue and queue.timerNode.timer:getRemainTime() > 0 then
		queueCtrl = nil
		;(nil).statusText = i18n("common_text_056")
		self:setBussyModel(nil)
	else
		self:setIdleModel(self.info.queueInfo.idleConfig)
	end
end
function pandect_single:setMasteryDrawQueue()
	local queue = queueCtrl:queryQueue(self.info.queueInfo.queueType)
	if queue and queue.timerNode.timer:getRemainTime() > 0 then
		queueCtrl = nil
		;(nil).statusText = i18n("drawing_text_09")
		self:setBussyModel(nil)
	elseif cityCtrl:checkMasteryDrawCanReceive() then
		queueCtrl = cityCtrl:checkMasteryDrawCanReceive()
		cityCtrl:checkMasteryDrawCanReceive().btnTitle = i18n("common_text_1146")
		local cityCtrl:checkMasteryDrawCanReceive().handle, param = function()
			cityCtrl:sendReqMasteryDrawReceive()
		end, cityCtrl:checkMasteryDrawCanReceive()
		self:setIdleModel(param)
	else
		self:setIdleModel(self.info.queueInfo.idleConfig)
	end
end
function pandect_single:setNewbornTreeBeastQueue()
	print("pandect_single:setNewbornTreeBeastQueue")
	if not self:checkCondition() then
		local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
		local taskLimit = divineBeastCtrl:getTaskLimit()
		local dayTaskRewardCount = divineBeastCtrl:getDayTaskRewardCount()
		if taskLimit > dayTaskRewardCount then
			_ENV = nil
			;(nil).count = taskLimit - dayTaskRewardCount
			self.info.queueInfo.idleConfig.midText = i18n("common_text_3875", nil)
			self:setIdleModel(self.info.queueInfo.idleConfig)
		else
			self:setAllFinishedModel()
		end
	end
end
function pandect_single:setNewbornTree9001547Queue()
	if not self:checkCondition() then
		local num = SoraDGetCtrl("beastCanyonCtrl"):getChallengeTimes(gActivityTimeActivityID.DIVINE_BEAST_CANYON_ACTIVITY)
		if num and 0 < num then
			_ENV = nil
			;(nil).count = num
			self.info.queueInfo.idleConfig.midText = i18n("common_text_3875", nil)
			self:setIdleModel(self.info.queueInfo.idleConfig)
		else
			self:setAllFinishedModel()
		end
	end
end
function pandect_single:setNewbornTree9001650Queue()
	if not self:checkCondition() then
		local num = SoraDGetCtrl("beastCanyonCtrl"):getChallengeTimes(gActivityTimeActivityID.NORMAL_ACTIVITY_9001650)
		if num and 0 < num then
			_ENV = nil
			;(nil).count = num
			self.info.queueInfo.idleConfig.midText = i18n("common_text_3875", nil)
			self:setIdleModel(self.info.queueInfo.idleConfig)
		else
			self:setAllFinishedModel()
		end
	end
end
function pandect_single:setNewbornTree9001650Exchange()
	self:setIdleModel(self.info.queueInfo.idleConfig)
end
return pandect_single
