local questCtrl = SoraDGetCtrl("questCtrl")
local everydayTaskCtrl = SoraDGetCtrl("everydayTaskCtrl")
local guideCtrl = SoraDGetCtrl("guideCtrl")
local questltCtrl = gModuleMgr.sharedMgr("questltCtrl")
local newPlayerTaskCtrl = SoraDGetCtrl("newPlayerTaskCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local everydayTaskRead = include("everydayTaskRead")
local funUnlockRead = include("funUnlockRead")
local resDesRead = include("resDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local questViewPanel = class("questViewPanel", baseFguiPanel)
function questViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("questViewPanel:ctor", self.viewName)
end
function questViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function questViewPanel:onInit()
	print("=======questViewPanel:onInit")
	self.isHideCurrentSceneView = true
	self.isAddToPopManager = true
	self.tabIndex = 1
	self.questListData, _ENV, self.needCheckSDKQuest, _ENV, self.isFirst = print, print, print, print, true
	self.isReduce = true
	self.unlockKey = gFunBuildKey.DAILY_TREASURE
	self.fields.Com_title:initData(i18n("common_text_675"), handler(self, self.onClickClose))
	self.fields.title_questRec:setString(i18n("common_text_679"))
	self.fields.title_questList:setString(i18n("quest_title_02"))
	self.fields.title_daily:setString(i18n("common_text_4496"))
	self.fields.List_quest:setItemRenderer(handler(self, self.onQuestRenderer))
	self.Text_time = SoraDCreateTimerLabel(self, self.fields.text_time)
	self.Text_time:setTimeLast(function(strTime)
		_ENV = nil
		;(nil).num = i18n("Endless_trial_text_07")
		;(nil).char = strTime
		return i18n("common_text_1470", nil)
	end)
	self.fields.List_box:setItemRenderer(handler(self, self.onBoxRenderer))
	self.fields.List_treasure:setItemRenderer(handler(self, self.onTreasureRenderer))
	self.fields.List_events:setItemRenderer(handler(self, self.onEventsRenderer))
	self.fields.Button_reduce:addClickListener(handler(self, self.btnReduceCallBack))
	self.fields.Usm_gold:setCompleteCallback(function()
		self.fields.Usm_gold:setVisible(false)
	end)
	self.fields.progress_bar_score:setScaleX(SoraDFIsRA() and 1 or -1)
	self.fields.List_box:fixPos()
	self.fields.Text_des:fixPos()
	self.fields.item:fixPos()
	self.fields.Button_reduce:fixPos()
end
function questViewPanel:onShow()
	print("=======questViewPanel:onShow")
	local toTab = self:updateRedPoint()
	if guideCtrl:updateGuideModule(gGuideModule.GENERAL_QUEST_GUIDE) then
		self.tabIndex = 1
	elseif self.param and self.param.tab then
		self.tabIndex = self.param.tab
	else
		self.tabIndex = toTab
	end
	_ENV = gGuideModule.GENERAL_QUEST_GUIDE
	_ENV, _ENV, gGuideModule.GENERAL_QUEST_GUIDE.defaultClick = nil, self.tabIndex, self.tabIndex
	;(nil).title = i18n("quest_btn_01")
	_ENV, self.tabIndex[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("quest_btn_02")
	gGuideModule.GENERAL_QUEST_GUIDE.tabsetArray, self.tabIndex[2], (nil).tag = self.tabIndex, nil, 2
	gGuideModule.GENERAL_QUEST_GUIDE.callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView(gGuideModule.GENERAL_QUEST_GUIDE)
	self.controllers.c1:setSelectedIndex(self.tabIndex - 1)
end
function questViewPanel:updateView(target, data)
	if self.tabIndex == 1 then
		self:updateData(target, data)
		self:initQuestData()
	else
		self:initDailyData()
	end
	self:updateRedPoint()
end
function questViewPanel:updateData(target, data)
	if data and next(data) then
		if data.msg == "MESSAGE_QUEST_NOTICE_COMMIT_SUCCESS" then
			if data.questID and questltCtrl:getKindOfQuest(data.questID) == gQuestKind.RECOMMENDED then
				local prizeID = self.fields.Com_recQuest:getPrizeID()
				if prizeID == gIDDef.GOLD then
					self:getRewardGoldEffectNew()
				elseif prizeID == gIDDef.FOOD then
					self:getRewardFoodEffect()
				elseif prizeID == gIDDef.WOOD then
					self:getRewardWoodEffect()
				else
					SoraDCloseLoading(self)
				end
			else
				SoraDCloseLoading(self)
			end
		elseif data.msg == "MESSAGE_QUEST_NOTICE_PROGRESS_UPDATE" then
			for i, v in ipairs(self.questListData) do
				if v.data.getQuestID and questltCtrl:getQuestType(v.data:getQuestID()) == data.questType and v.data:canCommit() then
					self:questBubbleSort()
					break
				end
			end
			self.fields.Com_recQuest:initData(questCtrl:getRecommendedPerformingQuest(), true)
		end
	end
end
function questViewPanel:onQuestRenderer(index, obj)
	local data = self.questListData[index + 1]
	obj:initData(data.data)
end
function questViewPanel:onBoxRenderer(index, obj)
	obj:initWithData(self.boxArray[index + 1])
end
function questViewPanel:onTreasureRenderer(index, obj)
	obj:initWithData(self.bigboxArray[index + 1])
end
function questViewPanel:onEventsRenderer(index, obj)
	obj:initWithData(self.eventsArray[index + 1].eventInfo, self.isReduce)
end
function questViewPanel:initQuestData()
	self.questListData, questCtrl = nil, nil
	local recommended = questCtrl:getRecommendedPerformingQuest()
	self.fields.Com_recQuest:initData(recommended, true)
	local questCtrl, tableNormalList = self.fields.Com_recQuest.initData, self.fields.Com_recQuest.initData
	tableNormalList[1] = questCtrl:getOperationalQuestListOfTop()
	tableNormalList[2] = questCtrl:getNoramlPerformingQuestList()
	tableNormalList[3] = questCtrl:getOperationalQuestListOfBottom()
	local tableFinishedList = questCtrl:getCompleteQuestList()
	if SoraDIsGameGuide() ~= 2031 then
		for j, data in ipairs(tableNormalList) do
			for i, v in ipairs(data) do
				local questType = questltCtrl:getQuestType(v:getQuestID())
				if questType ~= gQuestType.UPGRADESTAR_BUILDING or not not SoraDCheckIsOpenBuildStar() then
					questCtrl = v:getQuestID()
					v:getQuestID().data = v
					table.insert(self.questListData, v:getQuestID())
				end
				if questType == gQuestType.OPERATION and not v:canCommit() then
					table.insert(self.needCheckSDKQuest, v:getQuestID())
				end
			end
		end
		for i, v in ipairs(tableFinishedList) do
			questCtrl, questCtrl = nil, ipairs(data)
			;(nil).qid = v
			ipairs(data).data, (nil).isFinished = nil, true
			table.insert(self.questListData, ipairs(data))
		end
		if questCtrl:needUpdate() then
			questCtrl, questCtrl = nil, ipairs(tableFinishedList)
			ipairs(tableFinishedList).data, (nil).isUpdate = nil, true
			table.insert(self.questListData, ipairs(tableFinishedList))
		end
		if newPlayerTaskCtrl:getCurChapterID() ~= 0 then
			questCtrl, questCtrl = nil, ipairs(tableFinishedList)
			ipairs(tableFinishedList).data, (nil).isNewPlayer = nil, newPlayerTaskCtrl:getCurChapterID()
			table.insert(self.questListData, ipairs(tableFinishedList))
		end
	end
	self:questBubbleSort()
	self.fields.List_quest:setNumItems(#self.questListData)
	self.fields.List_quest:jumpToTop()
	if #self.needCheckSDKQuest > 0 then
		for i, v in ipairs(self.needCheckSDKQuest) do
			self:bindCell(v)
		end
	end
end
function questViewPanel:bindCell(qid)
	if qid == 4000004 and userSDKManager.returnAccountBindType(gSDKDef.platformType.email) then
		questCtrl:completeOperationalQuest(4000004)
	end
	if qid == 4000003 and userSDKManager.returnAccountBindType(gSDKDef.platformType.facebook) then
		questCtrl:completeOperationalQuest(4000003)
	end
end
function questViewPanel:questBubbleSort()
	local _ENV, tableIsCommit
	local _ENV, tableIsLock
	local _ENV, tableIsFinished
	local _ENV, tableIsUpdate
	local _ENV, tableIsNewPlayer
	local _ENV, tableOther
	self.haveNewData = false
	local tableConut = #self.questListData
	for i = tableConut, 1, -1 do
		local qid = self.questListData[i].data.getQuestID and self.questListData[i].data:getQuestID() or nil
		if self.questListData[i].data.canCommit and self.questListData[i].data:canCommit() then
			table.insert(tableIsCommit, table.remove(self.questListData, i))
		elseif self.questListData[i].data.isLock and self.questListData[i].data:isLock() then
			table.insert(tableIsLock, table.remove(self.questListData, i))
		elseif self.questListData[i].data.isFinished then
			table.insert(tableIsFinished, table.remove(self.questListData, i))
		elseif self.questListData[i].data.isUpdate then
			table.insert(tableIsUpdate, table.remove(self.questListData, i))
		elseif self.questListData[i].data.isNewPlayer then
			table.insert(tableIsNewPlayer, table.remove(self.questListData, i))
			self.haveNewData = true
		else
			table.insert(tableOther, table.remove(self.questListData, i))
		end
	end
	for i, v in ipairs(tableIsCommit) do
		table.insert(self.questListData, 1, v)
	end
	for i, v in ipairs(tableIsUpdate) do
		table.insert(self.questListData, v)
	end
	local _ENV, sortOtherGo = (for generator), ipairs(tableIsUpdate)
	local _UPVALUE4_, _ENV, sortOtherNoGo = ipairs(tableIsUpdate)
	ipairs(tableIsUpdate)[1] = 27
	ipairs(tableIsUpdate)[2] = 28
	ipairs(tableIsUpdate)[3] = 31
	local ipairs(tableIsUpdate)[4], behindArray = 37, ipairs(tableIsUpdate)
	for k, v in ipairs(tableOther) do
		if v.data.property then
			local questType = questltCtrl:getQuestType(v.data.property.questID)
			if SoraDisInList(questType, behindArray) then
				table.insert(sortOtherNoGo, v)
			else
				table.insert(sortOtherGo, v)
			end
		end
	end
	for i, v in ipairs(sortOtherGo) do
		table.insert(self.questListData, v)
	end
	for i, v in ipairs(sortOtherNoGo) do
		table.insert(self.questListData, v)
	end
	for i, v in ipairs(tableIsLock) do
		table.insert(self.questListData, v)
	end
	for i, v in ipairs(tableIsFinished) do
		table.insert(self.questListData, v)
	end
	for i, v in ipairs(tableIsNewPlayer) do
		table.insert(self.questListData, 1, v)
	end
end
function questViewPanel:initDailyData()
	self.Text_time:endTime()
	self.Text_time:beginTime(everydayTaskCtrl:getLeftTime())
	self.fields.text_score:setString(i18n("common_text_448") .. fguiHelper.getColorString("#00FF00", everydayTaskCtrl:calCurPoint()))
	self.isUnlockTreasure = funUnlockRead.getUnlockLevel(self.unlockKey) <= SoraDGetCastleLv()
	self.controllers.c2:setSelectedIndex(self.isUnlockTreasure and 1 or 0)
	local curGoal = everydayTaskCtrl:calCurPoint()
	if not everydayTaskCtrl:getGoalArray() then
		everydayTaskCtrl = everydayTaskCtrl:getGoalArray()
	end
	self.boxArray, everydayTaskCtrl, self.goalArray = everydayTaskCtrl:getGoalArray(), everydayTaskCtrl:getGoalArray(), everydayTaskCtrl:getGoalArray()
	for i, v in ipairs(self.goalArray) do
		local isReceived = everydayTaskCtrl:isReceiveNormalReward(i)
		everydayTaskCtrl = everydayTaskCtrl:calCurPoint()
		everydayTaskCtrl:calCurPoint().goal = v
		everydayTaskCtrl:calCurPoint().curGoal = curGoal
		everydayTaskCtrl:calCurPoint().index = i
		everydayTaskCtrl:calCurPoint().isReceived = isReceived
		table.insert(self.boxArray, everydayTaskCtrl:calCurPoint())
	end
	self.fields.List_box:setNumItems(#self.boxArray)
	local percent = SoraDGetStagePercentNew(curGoal, self.goalArray)
	self.fields.progress_bar_score:setValue(percent)
	self.bigboxArray, everydayTaskCtrl, self.chestGoalArray = everydayTaskCtrl:getChestGoalArray(), everydayTaskCtrl:getChestGoalArray(), everydayTaskCtrl:getChestGoalArray()
	for i, v in ipairs(self.chestGoalArray) do
		local isReceived = everydayTaskCtrl:isReceiveChestReward(i)
		everydayTaskCtrl = everydayTaskCtrl:calCurPoint()
		everydayTaskCtrl:calCurPoint().index = i
		everydayTaskCtrl:calCurPoint().score = v
		everydayTaskCtrl:calCurPoint().isReceived = isReceived
		table.insert(self.bigboxArray, everydayTaskCtrl:calCurPoint())
	end
	self.fields.List_treasure:setNumItems(#self.bigboxArray)
	self.eventsArray = self:getEventDatas()
	local everydayTaskCtrl, temp = self:getEventDatas(), self:getEventDatas()
	for k, v in ipairs(self.eventsArray) do
		if v.hidden <= SoraDGetCastleLv() then
			table.insert(temp, v)
		end
	end
	self.eventsArray = temp
	self.fields.List_events:setNumItems(#self.eventsArray)
	self:updatePassTool()
end
function questViewPanel:getEventDatas()
	local everydayTaskCtrl, ret
	local everydayTaskCtrl, finish
	local eventIds = everydayTaskCtrl:getCurTaskIDS()
	for i, v in ipairs(eventIds) do
		local eventId = v
		local taskId = everydayTaskCtrl:getIndexById(eventId)
		if taskId ~= 4100032 or not not SoraDCheckIsOpenBuildStar() then
			local eventInfo = everydayTaskCtrl:getEventInfoByTaskID(eventId)
			local hidden = everydayTaskRead.getDailyRewardHidden(taskId)
			if eventInfo.per >= 1 then
				everydayTaskCtrl = nil
				;(nil).eventId = eventId
				;(nil).eventInfo = eventInfo
				;(nil).taskId = taskId
				;(nil).hidden = tonumber(hidden) or 0
				table.insert(finish, nil)
			else
				everydayTaskCtrl = nil
				;(nil).eventId = eventId
				;(nil).eventInfo = eventInfo
				;(nil).taskId = taskId
				;(nil).hidden = tonumber(hidden) or 0
				table.insert(ret, nil)
			end
		end
	end
	local sortFun = function(l, r)
		return l.eventInfo.rank < r.eventInfo.rank
	end
	table.sort(ret, sortFun)
	table.sort(finish, sortFun)
	for i, v in ipairs(finish) do
		table.insert(ret, v)
	end
	return ret
end
function questViewPanel:onClickTab(index)
	print("questViewPanel:onClickTab====", index, self.tabIndex)
	if self.tabIndex == index and not self.isFirst then
		return
	end
	self.tabIndex = index
	self.controllers.c1:setSelectedIndex(self.tabIndex - 1)
	self:updateView()
	self.isFirst = false
end
function questViewPanel:updateRedPoint()
	local questCount = questCtrl:getCommitQuestNum()
	local taskCount = everydayTaskCtrl:getReceiveNormalRewardCount()
	print("questCount,taskCount====", questCount, taskCount)
	self.fields.Com_tab:setBtnRedDot(1, 0 < questCount, questCount)
	self.fields.Com_tab:setBtnRedDot(2, 0 < taskCount, taskCount)
	if questCount <= taskCount then
		return 2
	else
		return 1
	end
end
function questViewPanel:updatePassTool()
	self.fields.Button_reduce:setBtnColorIndex(self.isReduce and 0 or 1)
	self.fields.Button_reduce:setString(self.isReduce and i18n("Actpass_text_01") or i18n("common_text_185"))
	local passCount = backpackCtrl:getItemCount(510501)
	_ENV = nil
	;(nil).num = fguiHelper.getColorString("#FFD43E", string.formatnumberthousands(passCount))
	self.fields.Text_des:setString(i18n("Actpass_text_02", nil))
end
function questViewPanel:btnReduceCallBack()
	SoraDPlaySound()
	self.isReduce = not self.isReduce
	self:updatePassTool()
	self.fields.List_events:setNumItems(#self.eventsArray)
end
function questViewPanel:getRewardWoodEffect()
	self:overTurnAction()
	SoraDPlaySound("trainsoilder", BUILDID.SAWMILL)
	local rewardNum = 50
	local height = self.fields.Com_recQuest:getHeight()
	local tablePosX = SoraDGetRandNum(rewardNum, -300, 300)
	local targetPosY = SoraDGetRandNum(rewardNum, height / 2 - 300, height / 2 - 200)
	local initPosY = SoraDGetRandNum(rewardNum, height - 250, height - 50)
	local randomDelay = SoraDGetRandNum(rewardNum, 1, 20)
	local tableFade = SoraDGetRandNum(rewardNum, 1, 10)
	local tableRotate = SoraDGetRandNum(rewardNum, 0, 20)
	local disappearTime = 2.0
	local _ENV, resImgArray = 0, 0
	for i = 1, rewardNum do
		resImgArray[i] = cc.Sprite:createWithSpriteFrameName(resDesRead.getMIcon(gIDDef.WOOD))
		resImgArray[i]:setAnchorPoint(cc.p(0.5, 0))
		resImgArray[i]:setRotation(90)
		resImgArray[i]:setOpacity(0)
		resImgArray[i]:setPosition(cc.p(tablePosX[i], initPosY[i]))
		self.fields.Effect_load:setContent(resImgArray[i])
		_UPVALUE4_ = self.fields.Effect_load
		_UPVALUE2_ = cc.p(tablePosX[i], initPosY[i])
		cc.p(tablePosX[i], initPosY[i])[1] = cca.fadeIn(tableFade[i] / 10)
		cc.p(tablePosX[i], initPosY[i])[2] = cc.EaseBounceOut:create(cca.moveTo(1, cc.p(tablePosX[i], targetPosY[i])))
		cc.p(tablePosX[i], initPosY[i])[3] = cca.rotateTo(1, tableRotate[i])
		cc.p(tablePosX[i], initPosY[i])[4] = cca.rotateTo(1, tableRotate[i])
		cc.p(tablePosX[i], initPosY[i])[5] = cca.rotateTo(1, tableRotate[i])
		cc.p(tablePosX[i], initPosY[i])[6] = cca.rotateTo(1, tableRotate[i])
		cc.p(tablePosX[i], initPosY[i])[7] = cca.rotateTo(1, tableRotate[i])
		cc.p(tablePosX[i], initPosY[i])[8] = cca.rotateTo(1, tableRotate[i])
		self.fields.Effect_load[1] = cca.delay(randomDelay[i] / 10)
		self.fields.Effect_load[2] = cca.spawn(cc.p(tablePosX[i], initPosY[i]))
		self.fields.Effect_load[3] = cca.rotateTo(0.2, 0)
		self.fields.Effect_load[4] = cca.delay(disappearTime - randomDelay[i] / 10)
		self.fields.Effect_load[5] = cca.callFunc(function()
			resImgArray[i]:removeFromParent()
		end)
		self.fields.Effect_load[6] = cca.callFunc(function()
			resImgArray[i]:removeFromParent()
		end)
		self.fields.Effect_load[7] = cca.callFunc(function()
			resImgArray[i]:removeFromParent()
		end)
		self.fields.Effect_load[8] = cca.callFunc(function()
			resImgArray[i]:removeFromParent()
		end)
		self.fields.Effect_load[9] = cca.callFunc(function()
			resImgArray[i]:removeFromParent()
		end)
		self.fields.Effect_load[10] = cca.callFunc(function()
			resImgArray[i]:removeFromParent()
		end)
		self.fields.Effect_load[11] = cca.callFunc(function()
			resImgArray[i]:removeFromParent()
		end)
		local seq = cca.seq(self.fields.Effect_load)
		resImgArray[i]:runAction(seq)
	end
end
function questViewPanel:getRewardFoodEffect()
	self:overTurnAction()
	SoraDPlaySound("trainsoilder", BUILDID.FARM)
	local rewardNum = 50
	local height = self.fields.Com_recQuest:getHeight()
	local tablePosX = SoraDGetRandNum(rewardNum, -300, 300)
	local targetPosY = SoraDGetRandNum(rewardNum, height / 2 - 300, height / 2 - 200)
	local initPosY = SoraDGetRandNum(rewardNum, height - 250, height - 50)
	local randomDelay = SoraDGetRandNum(rewardNum, 1, 10)
	local tableFade = SoraDGetRandNum(rewardNum, 1, 10)
	_UPVALUE6_ = rewardNum
	rewardNum[1] = 150
	rewardNum[2] = -120
	rewardNum[3] = -30
	rewardNum[4] = -150
	rewardNum[5] = 120
	local rewardNum[6], moveX = 30, rewardNum
	local _ENV, resImgArray = 150, 150
	for i = 1, rewardNum do
		local random = math.random(2)
		resImgArray[i] = cc.Sprite:createWithSpriteFrameName(resDesRead.getMIcon(gIDDef.FOOD))
		resImgArray[i]:setOpacity(0)
		resImgArray[i]:setPosition(cc.p(tablePosX[i], initPosY[i]))
		self.fields.Effect_load:setContent(resImgArray[i])
		_UPVALUE3_ = self.fields.Effect_load
		_UPVALUE2_ = cc.p(tablePosX[i], initPosY[i])
		cc.p(tablePosX[i], initPosY[i])[1] = cca.fadeIn(tableFade[i] / 10)
		cc.p(tablePosX[i], initPosY[i])[2] = cc.EaseSineInOut:create(cca.moveTo(1, cc.p(tablePosX[i], targetPosY[i])))
		cc.p(tablePosX[i], initPosY[i])[3] = cca.callFunc(function()
			_ENV = nil
			;(nil).x = moveX[3 * (random % 2) + 1]
			;(nil).time = 0.5
			transition.moveBy(resImgArray[i], nil)
			_ENV = nil
			;(nil).x = moveX[3 * (random % 2) + 2]
			;(nil).time = 0.3
			transition.moveBy(resImgArray[i], nil)
			_ENV = nil
			;(nil).x = moveX[3 * (random % 2) + 3]
			;(nil).time = 0.2
			transition.moveBy(resImgArray[i], nil)
		end)
		cc.p(tablePosX[i], initPosY[i])[4] = cca.callFunc(function()
			_ENV = nil
			;(nil).x = moveX[3 * (random % 2) + 1]
			;(nil).time = 0.5
			transition.moveBy(resImgArray[i], nil)
			_ENV = nil
			;(nil).x = moveX[3 * (random % 2) + 2]
			;(nil).time = 0.3
			transition.moveBy(resImgArray[i], nil)
			_ENV = nil
			;(nil).x = moveX[3 * (random % 2) + 3]
			;(nil).time = 0.2
			transition.moveBy(resImgArray[i], nil)
		end)
		cc.p(tablePosX[i], initPosY[i])[5] = cca.callFunc(function()
			_ENV = nil
			;(nil).x = moveX[3 * (random % 2) + 1]
			;(nil).time = 0.5
			transition.moveBy(resImgArray[i], nil)
			_ENV = nil
			;(nil).x = moveX[3 * (random % 2) + 2]
			;(nil).time = 0.3
			transition.moveBy(resImgArray[i], nil)
			_ENV = nil
			;(nil).x = moveX[3 * (random % 2) + 3]
			;(nil).time = 0.2
			transition.moveBy(resImgArray[i], nil)
		end)
		cc.p(tablePosX[i], initPosY[i])[6] = cca.callFunc(function()
			_ENV = nil
			;(nil).x = moveX[3 * (random % 2) + 1]
			;(nil).time = 0.5
			transition.moveBy(resImgArray[i], nil)
			_ENV = nil
			;(nil).x = moveX[3 * (random % 2) + 2]
			;(nil).time = 0.3
			transition.moveBy(resImgArray[i], nil)
			_ENV = nil
			;(nil).x = moveX[3 * (random % 2) + 3]
			;(nil).time = 0.2
			transition.moveBy(resImgArray[i], nil)
		end)
		cc.p(tablePosX[i], initPosY[i])[7] = cca.callFunc(function()
			_ENV = nil
			;(nil).x = moveX[3 * (random % 2) + 1]
			;(nil).time = 0.5
			transition.moveBy(resImgArray[i], nil)
			_ENV = nil
			;(nil).x = moveX[3 * (random % 2) + 2]
			;(nil).time = 0.3
			transition.moveBy(resImgArray[i], nil)
			_ENV = nil
			;(nil).x = moveX[3 * (random % 2) + 3]
			;(nil).time = 0.2
			transition.moveBy(resImgArray[i], nil)
		end)
		cc.p(tablePosX[i], initPosY[i])[8] = cca.callFunc(function()
			_ENV = nil
			;(nil).x = moveX[3 * (random % 2) + 1]
			;(nil).time = 0.5
			transition.moveBy(resImgArray[i], nil)
			_ENV = nil
			;(nil).x = moveX[3 * (random % 2) + 2]
			;(nil).time = 0.3
			transition.moveBy(resImgArray[i], nil)
			_ENV = nil
			;(nil).x = moveX[3 * (random % 2) + 3]
			;(nil).time = 0.2
			transition.moveBy(resImgArray[i], nil)
		end)
		self.fields.Effect_load[1] = cca.delay(randomDelay[i] / 10)
		self.fields.Effect_load[2] = cca.spawn(cc.p(tablePosX[i], initPosY[i]))
		self.fields.Effect_load[3] = cca.delay(1)
		self.fields.Effect_load[4] = cca.callFunc(function()
			resImgArray[i]:removeFromParent()
		end)
		self.fields.Effect_load[5] = cca.callFunc(function()
			resImgArray[i]:removeFromParent()
		end)
		self.fields.Effect_load[6] = cca.callFunc(function()
			resImgArray[i]:removeFromParent()
		end)
		self.fields.Effect_load[7] = cca.callFunc(function()
			resImgArray[i]:removeFromParent()
		end)
		self.fields.Effect_load[8] = cca.callFunc(function()
			resImgArray[i]:removeFromParent()
		end)
		self.fields.Effect_load[9] = cca.callFunc(function()
			resImgArray[i]:removeFromParent()
		end)
		self.fields.Effect_load[10] = cca.callFunc(function()
			resImgArray[i]:removeFromParent()
		end)
		self.fields.Effect_load[11] = cca.callFunc(function()
			resImgArray[i]:removeFromParent()
		end)
		local seq = cca.seq(self.fields.Effect_load)
		resImgArray[i]:runAction(seq)
	end
end
function questViewPanel:getRewardGoldEffectNew()
	self:overTurnAction()
	SoraDPlaySound("trainsoilder", 200)
	self.fields.Usm_gold:play(false)
end
function questViewPanel:overTurnAction()
	_UPVALUE2_ = nil
	;(nil)[1] = ffa.scaleTo(0.2, 1, 0)
	;(nil)[2] = ffa.scaleTo(0.2, 1, 1)
	;(nil)[3] = ffa.callFunc(function()
		self.fields.Com_recQuest:initData(questCtrl:getRecommendedPerformingQuest(), true)
		SoraDCloseLoading(self)
	end)
	;(nil)[4] = ffa.callFunc(function()
		self.fields.Com_recQuest:initData(questCtrl:getRecommendedPerformingQuest(), true)
		SoraDCloseLoading(self)
	end)
	;(nil)[5] = ffa.callFunc(function()
		self.fields.Com_recQuest:initData(questCtrl:getRecommendedPerformingQuest(), true)
		SoraDCloseLoading(self)
	end)
	local seq = ffa.seq(nil)
	self.fields.Com_recQuest:runAction(seq)
end
function questViewPanel:endShow()
	if not include("pyramidWarltCtrl").checkPwXianXiaSai() then
		self:close()
	end
end
function questViewPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "Button_getPrize" then
		return self.fields.Com_recQuest:getTarget(itemName)
	elseif itemName == "tab" then
		return self.fields.Com_tab:getBtn(parameters.tabIndex)
	else
		return self.fields[itemName]
	end
	return nil
end
return questViewPanel
