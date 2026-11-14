local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local luckyBlessCtrl = SoraDGetCtrl("luckyBlessCtrl")
local collegeDesRead = include("collegeDesRead")
local waitQueueCtrl = SoraDGetCtrl("waitQueueCtrl")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local exaltedPrivilegeCtrl = SoraDGetCtrl("exaltedPrivilegeCtrl")
local badgeExchangeCtrl = SoraDGetCtrl("badgeExchangeCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local collegeDetailsViewPanel = class("collegeDetailsViewPanel", baseFguiPanel)
function collegeDetailsViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("collegeDetailsViewPanel:ctor", self.viewName)
end
function collegeDetailsViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function collegeDetailsViewPanel:onInit()
	print("=======collegeDetailsViewPanel:onInit")
	self.queue = nil
	self.isFree = false
	self.luckyBlessIsOpen = false
	self.needWarBadgeBuy = 0
	self.needWarBadgeID = gBadgeItemID.COMMON_BADGE_ID
	self.tableNeedList, _ENV, self.tableSingleDetails, _ENV, self.tableSingleData, _ENV, self.cantStudying = TECHNOLOGY_SINGLE_TYPE.NONE, TECHNOLOGY_SINGLE_TYPE.NONE, TECHNOLOGY_SINGLE_TYPE.NONE, TECHNOLOGY_SINGLE_TYPE.NONE, TECHNOLOGY_SINGLE_TYPE.NONE, TECHNOLOGY_SINGLE_TYPE.NONE, TECHNOLOGY_SINGLE_TYPE.NONE
	self.fields.Text_luckyDes:setVisible(false)
	self.fields.Text_luckyDes = SoraDCreateTimerLabel(self, self.fields.Text_luckyDes)
	self.fields.Text_maxLv:setString(i18n("common_text_339"))
	self.fields.Text_leftTime:setString(i18n("common_text_1663"))
	self.fields.Text_time:setTimeUpdateListener(handler(self, self.timeUpdate))
	self.fields.Button_studying:setString(i18n("common_text_062"))
	self.fields.Button_studying:setCostIcon("icon_hourglass.png")
	self.fields.Button_studying:addClickListener(handler(self, self.btnStudyingClickCallBack))
	self.fields.Button_studyingNow:setString(i18n("common_text_335"))
	self.fields.Button_studyingNow:addClickListener(handler(self, self.btnStudyingNowClickCallBack))
	self.fields.Button_speedUp:setString(i18n("common_text_018"))
	self.fields.Button_speedUp:setVisible(false)
	self.fields.Button_speedUp:addClickListener(handler(self, self.btnSpeedUpClickCallBack))
	self.fields.Button_wait:setString(i18n("privilege_btn_04"))
	self.fields.Button_wait:addClickListener(handler(self, self.btnWaitClickCallBack))
	self.fields.Button_wait:setVisible(false)
	_ENV = handler(self, self.btnWaitClickCallBack)
	handler(self, self.btnWaitClickCallBack).need = ""
	self.fields.Com_title:setString(i18n("common_text_380", handler(self, self.btnWaitClickCallBack)))
	self.fields.List_condition:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_leftTime:fixPos()
	self.fields.bar:fixPos()
	self.fields.bar:setScaleX(SoraDFIsRA() and -1 or 1)
	self.fields.Text_time:fixPos()
end
function collegeDetailsViewPanel:onShow()
	print("=======collegeDetailsViewPanel:onShow")
	self.techID = self.param.techID
	self.techType = self.param.techType or collegeDesRead.getType(self.techID)
	self.queueType = self.param.queueType or gQueueTypeDef.technology_upgrade_queue
	self.isPrivilege = exaltedPrivilegeCtrl:checkPrivilege(gExaltedPrivilegeType.TECHNOLOGY_QUEUE) and true or false
	self.fields.Panel_bg:setString(collegeDesRead.getName(self.techID))
	self.freeTime = technologyCtrl:getFreeSpeedUpTime(self.queueType)
	self:updateView()
end
function collegeDetailsViewPanel:onItemRenderer(index, obj)
	obj:initData(self.tableNeedList[index + 1], self.techType)
end
function collegeDetailsViewPanel:updateView()
	self:updateLuckyBless()
	local singleleData = technologyCtrl:getTechnoDataByID(self.techID, self.techType)
	if singleleData then
		self.tableSingleData = singleleData
	end
	local singleDetails = technologyCtrl:getTechnologyDetails(self.techID, self.tableSingleData.currentLevel)
	if singleDetails then
		self.tableSingleDetails = singleDetails
	end
	self.fields.Com_top:initData(self.techID, self.techType, self.tableSingleData, self.tableSingleDetails)
	if self.tableSingleData.currentLevel >= self.tableSingleData.maxLevel then
		self.controllers.c1:setSelectedIndex(2)
	elseif self.tableSingleDetails.upgradeIngTechnology and self.tableSingleDetails.upgradeIngTechnology[3] then
		self.queue = queueCtrl:queryQueue(self.queueType)
		self.controllers.c1:setSelectedIndex(1)
		local leftTime = self.queue and self.queue.timerNode.timer:getRemainTime() or 0
		if 0 < leftTime then
			self.fields.Text_time:beginTime(leftTime)
			self.fields.bar:setMax(self.queue.totaltime)
		end
		local itemList = backpackCtrl:getSpeedUpItemList(gAbbrSpeedUpType.TECH)
		if #itemList <= 0 or self.isFree then
			self.fields.Button_studyingNow:setPositionX(self:getWidth() / 2)
			self.fields.Button_speedUp:setVisible(false)
		else
			self.fields.Button_studyingNow:setPositionX(SoraDFIsRA() and self:getWidth() / 2 + 120 or self:getWidth() / 2 - 120)
			self.fields.Button_speedUp:setVisible(true)
			self.fields.Button_speedUp:setPositionX(not SoraDFIsRA() and self:getWidth() / 2 + 120 or self:getWidth() / 2 - 120)
		end
	else
		self.controllers.c1:setSelectedIndex(0)
		local basetime = self.tableSingleDetails.technologyTime
		local finaltime = technologyCtrl:getResearchTime(basetime, self.queueType)
		local freeTime = technologyCtrl:getFreeSpeedUpTime(self.queueType)
		self.fields.Button_studying:setCostTitle(SoraDConvertSecondToString(finaltime))
		if finaltime <= freeTime and serviceFunctions.timeConvertToGold(finaltime) >= self.tableSingleDetails.cost then
			self.fields.Button_studyingNow:setCostTitle(i18n("common_text_049"))
			self.isFree = true
			if not SoraDIsGameGuide() and not self.isMildFree and self.fields.Button_studyingNow:isTouchEnabled() then
				technologyCtrl = i18n("common_text_049")
				i18n("common_text_049").z = 0
				gModuleMgr.sharedMgr("mildGuideManager"):drawFingerToTarget(self.fields.Button_studyingNow, i18n("common_text_049"))
				self.isMildFree = true
			end
		else
			if self.isMildFree then
				gModuleMgr.sharedMgr("mildGuideManager"):clean()
			end
			self.isMildFree = false
			self.isFree = false
			self.fields.Button_studyingNow:setCostTitle(string.formatnumberthousands(self.tableSingleDetails.cost))
		end
		self:updateBtnState()
		self:initScroll()
	end
	self.fields.Button_speedUp:setPositionX(SoraDFPosX(200))
	self.fields.Button_studying:setPositionX(SoraDFPosX(200))
	self.fields.Button_studyingNow:setPositionX(SoraDFPosX(440))
	self.fields.Button_wait:setPositionX(SoraDFPosX(440))
end
function collegeDetailsViewPanel:updateBtnState()
	local isOpened = true
	local isAmberLack = false
	self.cantStudying = TECHNOLOGY_SINGLE_TYPE.NONE
	if self.tableSingleDetails.build then
		for i, v in ipairs(self.tableSingleDetails.build) do
			if not v.isContentmented then
				isOpened = false
				break
			end
		end
	end
	if self.tableSingleDetails.starbuild then
		for i, v in ipairs(self.tableSingleDetails.starbuild) do
			if not v.isContentmented then
				isOpened = false
				break
			end
		end
	end
	if self.tableSingleDetails.tech then
		for i, v in ipairs(self.tableSingleDetails.tech) do
			if not v.isContentmented then
				isOpened = false
				break
			end
		end
	end
	if self.tableSingleDetails.resources then
		for i, v in ipairs(self.tableSingleDetails.resources) do
			if not v.isContentmented then
				if self.luckyBlessIsOpen then
					local luckyCost = luckyBlessCtrl:getResult(v.consumeResource)
					local haveRes = cityCtrl:getResCount(v.rid)
					if luckyCost > haveRes then
						self.cantStudying = TECHNOLOGY_SINGLE_TYPE.RES
						break
					end
				else
					self.cantStudying = TECHNOLOGY_SINGLE_TYPE.RES
					break
				end
			end
		end
	end
	if self.tableSingleDetails.wartool then
		for i, v in ipairs(self.tableSingleDetails.wartool) do
			if not v.isContentmented then
				self.cantStudying = TECHNOLOGY_SINGLE_TYPE.WAR
				self.needWarBadgeBuy = v.consumeResource - v.currentResource
				self.needWarBadgeID = v.rid
				if (BUILD_STAR_COSTITEM[v.rid] or v.rid == gNebulaPalaceItemID) and self.needWarBadgeBuy > 0 then
					isAmberLack = true
				end
				if v.rid == gNebulaPalaceItemID then
				end
				break
			end
		end
	end
	self.fields.Button_studyingNow:setEnabled(isOpened and not isAmberLack)
	self.fields.Button_studying:setEnabled(isOpened and not isAmberLack)
	if self.isPrivilege and gQueueTypeDef.technology_upgrade_queue == self.queueType then
		local tableStuding = technologyCtrl:studyingTechnology(self.queueType)
		if isOpened and tableStuding then
			self.fields.Button_wait:setVisible(true)
			self.fields.Button_studying:setVisible(false)
		else
			self.fields.Button_wait:setVisible(false)
			self.fields.Button_studying:setVisible(true)
		end
	end
end
function collegeDetailsViewPanel:initScroll()
	self.tableNeedList, technologyCtrl = nil, nil
	local tableStuding, techType = technologyCtrl:studyingTechnology(self.queueType)
	if tableStuding then
		technologyCtrl = nil
		;(nil).data = tableStuding
		;(nil).singleType = TECHNOLOGY_SINGLE_TYPE.QUEUE
		;(nil).queueType = self.queueType
		table.insert(self.tableNeedList, nil)
		self.cantStudying = TECHNOLOGY_SINGLE_TYPE.QUEUE
	end
	dump(self.tableSingleDetails, "self.tableSingleDetails")
	for i, v in ipairs(self.tableSingleDetails.build) do
		technologyCtrl = nil
		;(nil).data = v
		;(nil).singleType = TECHNOLOGY_SINGLE_TYPE.BUILD
		table.insert(self.tableNeedList, nil)
	end
	for i, v in ipairs(self.tableSingleDetails.starbuild) do
		technologyCtrl = nil
		;(nil).data = v
		;(nil).singleType = TECHNOLOGY_SINGLE_TYPE.STAR
		table.insert(self.tableNeedList, nil)
	end
	for i, v in ipairs(self.tableSingleDetails.tech) do
		technologyCtrl = nil
		;(nil).data = v
		;(nil).singleType = TECHNOLOGY_SINGLE_TYPE.TECHNOLOGY
		;(nil).queueType = self.queueType
		;(nil).isJumpNuew = true
		table.insert(self.tableNeedList, nil)
	end
	for i, v in ipairs(self.tableSingleDetails.wartool) do
		technologyCtrl = nil
		;(nil).data = v
		;(nil).singleType = TECHNOLOGY_SINGLE_TYPE.WAR
		table.insert(self.tableNeedList, nil)
	end
	local technologyCtrl, resNeedList = (for generator), ipairs(self.tableSingleDetails.wartool)
	for i, v in ipairs(self.tableSingleDetails.resources) do
		technologyCtrl = self.tableNeedList
		self.tableNeedList.curcount = v.currentResource
		self.tableNeedList.rescount = v.consumeResource
		resNeedList[i], self.tableNeedList.resid = self.tableNeedList, v.rid
	end
	for i, v in ipairs(self.tableSingleDetails.resources) do
		technologyCtrl = TECHNOLOGY_SINGLE_TYPE.WAR
		TECHNOLOGY_SINGLE_TYPE.WAR.data = v
		TECHNOLOGY_SINGLE_TYPE.WAR.singleType = TECHNOLOGY_SINGLE_TYPE.RES
		TECHNOLOGY_SINGLE_TYPE.WAR.resNeedList = resNeedList
		TECHNOLOGY_SINGLE_TYPE.WAR.luckyBlessIsOpen = self.luckyBlessIsOpen
		table.insert(self.tableNeedList, TECHNOLOGY_SINGLE_TYPE.WAR)
	end
	self.fields.List_condition:setNumItems(#self.tableNeedList)
end
function collegeDetailsViewPanel:timeUpdate(time)
	self.fields.bar:setValue(self.queue.totaltime - time)
	if time <= self.freeTime then
		self.isFree = true
		self.fields.Button_studyingNow:setCostTitle(i18n("common_text_049"))
		if not SoraDIsGameGuide() and not self.isMildFree and self.fields.Button_studyingNow:isTouchEnabled() then
			_ENV = i18n("common_text_049")
			i18n("common_text_049").z = 0
			gModuleMgr.sharedMgr("mildGuideManager"):drawFingerToTarget(self.fields.Button_studyingNow, i18n("common_text_049"))
			self.isMildFree = true
		end
	else
		self.isFree = false
		local goldPay = serviceFunctions.timeConvertToGold(time)
		self.fields.Button_studyingNow:setCostTitle(tostring(math.floor(goldPay)))
	end
	if time <= 0 then
		self:updateView()
	end
end
function collegeDetailsViewPanel:updateLuckyBless()
	if self.techType == "nebula" then
		self.fields.Text_luckyDes:setVisible(false)
	end
	self.luckyData = luckyBlessCtrl:getLuckyData()
	if self.luckyData.curEffectType == gLuckyBlessActivityEffectType.TECHNOLOGY_RESEARCH then
		self.luckyBlessIsOpen = true
		self.fields.Text_luckyDes:setVisible(true)
		self.fields.Text_luckyDes:setTimeLast(function(strTime)
			_ENV = nil
			;(nil).num = string.format("%d%%", self.luckyData.discount / 10)
			;(nil).time = strTime
			return i18n("lucky_text_19", nil)
		end)
		local leftTime = luckyBlessCtrl:getRealTime()
		if 0 < leftTime then
			self.fields.Text_luckyDes:beginTime(leftTime)
		end
	else
		self.luckyBlessIsOpen = false
		self.fields.Text_luckyDes:endTime()
		self.fields.Text_luckyDes:setVisible(false)
	end
end
function collegeDetailsViewPanel:btnStudyingNowClickCallBack()
	SoraDPlaySound()
	if self.controllers.c1:getSelectedIndex() == 1 then
		if self.isFree then
			queueCtrl:speedUpQueueReq(tonumber(self.queueType), SPEEDUP_TYPE.FREE)
			self:close()
		else
			SoraDShowSpeedUpBox(self.queue, handler(self, self.speedUpBack), i18n("common_text_765"))
		end
	elseif self.isFree then
		queueCtrl = i18n("common_text_765")
		i18n("common_text_765")[1] = self.tableSingleData.technologyID
		technologyCtrl:instantResearch(self.tableSingleData.technologyID, i18n("common_text_765"))
		self:close()
	else
		SoraDShowBuyBox(i18n("common_text_707"), self.tableSingleDetails.cost, i18n("common_text_335"), function(eventType)
			if eventType == MSGBOX_CALLBACK_YES and not tolua.isnull(self) and SoraDEnoughGold(self.tableSingleDetails.cost) and SoraDEnoughWarBadge(self.needWarBadgeBuy, self.needWarBadgeID) then
				self = nil
				;(nil)[1] = self.tableSingleData.technologyID
				technologyCtrl:instantResearch(self.tableSingleData.technologyID, nil)
				self:close()
			end
		end)
	end
end
function collegeDetailsViewPanel:btnSpeedUpClickCallBack(button, type)
	SoraDPlaySound()
	if self.queue == nil then
		return
	end
	SoraDShowSpeedUpByItemBox(self.queue.qtype, handler(self, self.speedUpBack))
end
function collegeDetailsViewPanel:speedUpBack(event)
	if event == MSGBOX_CALLBACK_SPEEDUP then
		self:close()
	end
end
function collegeDetailsViewPanel:btnWaitClickCallBack()
	SoraDPlaySound()
	local waitTechnology = function(event)
		event = event or UPGRADE_CONDITION.RESOURCES_NOT_ENOUGH
		technologyCtrl:addWaitQueue(self.tableSingleData.technologyID, event)
		self:close()
	end
	if waitQueueCtrl:checkWaitQueueFree(gQueueTypeDef.technology_upgrade_queue) then
		local needGold, tableResNeedBuy = self:getNeedResource()
		if needGold == 0 then
			waitTechnology(UPGRADE_CONDITION.RESOURCES_ENOUGH)
		else
			self:checkEnoughResource(waitTechnology)
		end
	else
		SoraDShowMsgTip(i18n("privilege_text_86"))
	end
end
function collegeDetailsViewPanel:btnStudyingClickCallBack()
	SoraDPlaySound()
	local studyTechnology = function(event)
		event = event or UPGRADE_CONDITION.RESOURCES_NOT_ENOUGH
		technologyCtrl = nil
		;(nil)[1] = self.tableSingleData.technologyID
		technologyCtrl:research(self.tableSingleData.technologyID, event, nil)
		self:close()
	end
	if self.cantStudying == TECHNOLOGY_SINGLE_TYPE.QUEUE then
		SoraDShowMsgBox(i18n("common_text_708"), i18n("common_text_204"))
	elseif (self.cantStudying == TECHNOLOGY_SINGLE_TYPE.RES or self.cantStudying == TECHNOLOGY_SINGLE_TYPE.WAR) and SoraDEnoughWarBadge(self.needWarBadgeBuy, self.needWarBadgeID) then
		self:checkEnoughResource(studyTechnology)
	elseif SoraDEnoughWarBadge(self.needWarBadgeBuy, self.needWarBadgeID) then
		studyTechnology(UPGRADE_CONDITION.RESOURCES_ENOUGH)
	end
end
function collegeDetailsViewPanel:checkEnoughResource(studyTechnology)
	local needGold, tableResNeedBuy = self:getNeedResource()
	local isLackAmber = false
	for i, v in ipairs(tableResNeedBuy) do
		if (BUILD_STAR_COSTITEM[v.resid] or v.resid == gNebulaPalaceItemID) and v.rescount > 0 then
			isLackAmber = true
		end
	end
	if isLackAmber then
		SoraDShowMsgTip(i18n("common_text_2512"))
		return
	end
	local proxy = uiManager:getOrCreateProxy("CommonQuicklyadd")
	if proxy:checkNeedRes(tableResNeedBuy) then
		uiManager:show("CommonQuicklyadd")
		return
	end
	_ENV, _ENV = i18n("common_text_2512")
	i18n("common_text_2512").resToGold = needGold
	i18n("common_text_2512").needResData, i18n("common_text_2512").retCostRes = i18n("common_text_2512")
	i18n("common_text_2512").viewType = RESBUYVIEW_TYPE.STUDY_SCIENCE
	i18n("common_text_2512").handle = studyTechnology
	uiManager:show("buildCreateResBuy", i18n("common_text_2512"))
end
function collegeDetailsViewPanel:getNeedResource()
	local _ENV, tableResNeedBuy
	local needGold = 0
	for i, v in ipairs(self.tableSingleDetails.resources) do
		if not v.isContentmented then
			local needRes = v.consumeResource - v.currentResource
			if self.luckyBlessIsOpen then
				local luckyRes = luckyBlessCtrl:getResult(v.consumeResource)
				needRes = math.max(0, luckyRes - v.currentResource)
			end
			if 0 < needRes then
				needGold = needGold + serviceFunctions.resConvertToGold(v.rid, needRes)
				_ENV = needRes
				needRes.resid = v.rid
				needRes.rescount = needRes
				table.insert(tableResNeedBuy, needRes)
			end
		end
	end
	for i, v in ipairs(self.tableSingleDetails.wartool) do
		if not v.isContentmented then
			local needRes = v.consumeResource - v.currentResource
			needGold = needGold + badgeExchangeCtrl:getCostGoldByCount(needRes, v.rid)
			_ENV = needRes
			needRes.resid = v.rid
			needRes.rescount = needRes
			table.insert(tableResNeedBuy, needRes)
		end
	end
	return needGold, tableResNeedBuy
end
return collegeDetailsViewPanel
