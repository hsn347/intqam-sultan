local gametop = gModuleMgr.getObject("gametop")
local questCtrl = gametop.playertop_:getModule("questCtrl")
local questltCtrl = gModuleMgr.sharedMgr("questltCtrl")
local newPlayerTaskCtrl = gametop.playertop_:getModule("newPlayerTaskCtrl")
local questDesRead = include("questDesRead")
local resDesRead = include("resDesRead")
local QuestViewNode = class("questViewNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("questViewNode")
	end
	return target
end)
function QuestViewNode:ctor()
	self.tableSpare, _ENV, self.questListData, _ENV, self.needCheckSDKQuest, _ENV, self.haveNewData = nil, nil, nil, nil, nil, nil, false
	self.Top_Size_Image_bg = SoraDGetChildByName(self, "Top_Size_Image_bg")
	self.Top_Size_frm = SoraDGetChildByName(self, "Top_Size_frm")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_quest")
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	local title = SoraDGetChildByName(self, "Text_title")
	if title then
		title:setString(i18n("quest_title_02"))
	end
	self.node_recommend = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_questSingleView_recommended")
	self.btn_touch = SoraDGetChildByName(self.node_recommend, "Button_touch")
	self:suitView()
	self:initData()
	if #self.needCheckSDKQuest > 0 then
		for i, v in ipairs(self.needCheckSDKQuest) do
			self:bindCell(v)
		end
	end
end
function QuestViewNode:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_QUEST_NOTICE_COMMIT_SUCCESS", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_QUEST_NOTICE_PROGRESS_UPDATE", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_NEW_PLAYER_QUEST_CHAPTER", handler(self, self.initData))
end
function QuestViewNode:suitView()
	self.scroll:setContentSize(cc.size(640, display.height - 427))
	self.Top_Size_Image_bg:setContentSize(cc.size(622, display.height - 414))
	self.Top_Size_frm:setContentSize(cc.size(645, display.height - 389))
end
function QuestViewNode:initData()
	local questCtrl, tableNormalList
	self:cleanData()
	tableNormalList[1] = questCtrl:getOperationalQuestListOfTop()
	tableNormalList[2] = questCtrl:getNoramlPerformingQuestList()
	tableNormalList[3] = questCtrl:getOperationalQuestListOfBottom()
	local tableFinishedList = questCtrl:getCompleteQuestList()
	local recommended = questCtrl:getRecommendedPerformingQuest()
	if SoraDIsGameGuide() ~= 2031 then
		for j, data in ipairs(tableNormalList) do
			for i, v in ipairs(data) do
				local questType = questltCtrl:getQuestType(v:getQuestID())
				if questType ~= gQuestType.UPGRADESTAR_BUILDING or not not SoraDCheckIsOpenBuildStar() then
					questCtrl = v:getQuestID()
					v:getQuestID().point = nil
					v:getQuestID().data = v
					v:getQuestID().posY = 0
					table.insert(self.questListData, v:getQuestID())
				end
				if questType == gQuestType.OPERATION and not v:canCommit() then
					table.insert(self.needCheckSDKQuest, v:getQuestID())
				end
			end
		end
		for i, v in ipairs(tableFinishedList) do
			questCtrl = ipairs(data)
			questCtrl, ipairs(data).point = nil, nil
			;(nil).qid = v
			ipairs(data).data, (nil).isFinished = nil, true
			ipairs(data).posY = 0
			table.insert(self.questListData, ipairs(data))
		end
		if questCtrl:needUpdate() then
			questCtrl = ipairs(tableFinishedList)
			questCtrl, ipairs(tableFinishedList).point = nil, nil
			ipairs(tableFinishedList).data, (nil).isUpdate = nil, true
			ipairs(tableFinishedList).posY = 0
			table.insert(self.questListData, ipairs(tableFinishedList))
		end
		if newPlayerTaskCtrl:getCurChapterID() ~= 0 then
			questCtrl = ipairs(tableFinishedList)
			questCtrl, ipairs(tableFinishedList).point = nil, nil
			ipairs(tableFinishedList).data, (nil).isNewPlayer = nil, newPlayerTaskCtrl:getCurChapterID()
			ipairs(tableFinishedList).posY = 0
			table.insert(self.questListData, ipairs(tableFinishedList))
		end
	else
		self.labelNotice:setVisible(true)
	end
	self.node_recommend:initData(recommended, true)
	self:questBubbleSort()
	self:updateScrollSize()
	self.scroll:jumpToTop()
	self:initQuestList()
end
function QuestViewNode:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		print("btn click")
	end
end
function QuestViewNode:bindCell(qid)
	if qid == 4000004 and userSDKManager.returnAccountBindType(gSDKDef.platformType.email) then
		questCtrl:completeOperationalQuest(4000004)
	end
	if qid == 4000003 and userSDKManager.returnAccountBindType(gSDKDef.platformType.facebook) then
		questCtrl:completeOperationalQuest(4000003)
	end
end
function QuestViewNode:updateData(target, data)
	if data.msg == "MESSAGE_QUEST_NOTICE_COMMIT_SUCCESS" then
		if data.questID and questltCtrl:getKindOfQuest(data.questID) == gQuestKind.RECOMMENDED then
			local prizeID = self.node_recommend:getPrizeID()
			if prizeID == gIDDef.GOLD then
				self:getRewardGoldEffectNew()
			elseif prizeID == gIDDef.FOOD then
				self:getRewardFoodEffect()
			elseif prizeID == gIDDef.WOOD then
				self:getRewardWoodEffect()
			else
				SoraDCloseLoading(SoraDSearchPanelFromManagerByName("questView"))
			end
		else
			self:initData()
			SoraDCloseLoading(SoraDSearchPanelFromManagerByName("questView"))
		end
	elseif data.msg == "MESSAGE_QUEST_NOTICE_PROGRESS_UPDATE" then
		for i, v in ipairs(self.questListData) do
			if v.data.getQuestID and questltCtrl:getQuestType(v.data:getQuestID()) == data.questType and v.data:canCommit() then
				self:questBubbleSort()
				break
			end
		end
		self:updateScrollSize()
		self.node_recommend:initData(questCtrl:getRecommendedPerformingQuest(), true)
	end
	self:initQuestList()
end
function QuestViewNode:cleanData()
	for i, v in ipairs(self.questListData) do
		if v.point then
			table.insert(self.tableSpare, v.point)
			v.point:setVisible(false)
		end
	end
	self.questListData, _ENV = ipairs(self.questListData)
end
function QuestViewNode:questBubbleSort()
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
		local questType = questltCtrl:getQuestType(v.data.property.questID)
		if SoraDisInList(questType, behindArray) then
			table.insert(sortOtherNoGo, v)
		else
			table.insert(sortOtherGo, v)
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
function QuestViewNode:updateScrollSize()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local scrollInnerNewH = 0
	local offsetH = 0
	self.skipI = 0
	scrollInnerNewH = math.max(184 * #self.questListData + 20, self.scroll:getContentSize().height)
	for i, v in ipairs(self.questListData) do
		v.posY = scrollInnerNewH - 184 * (i - 1)
		if v.point then
			v.point:setPositionY(v.posY)
			v.point:initData(v.data, false)
		end
	end
	offsetY = offsetY - (scrollInnerNewH - scrollInner:getContentSize().height)
	self.scroll:setInnerContainerSize(cc.size(640, scrollInnerNewH))
	scrollInner:setPositionY(offsetY)
end
function QuestViewNode:initQuestList()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scroll:getContentSize().height
	_ENV = self.scroll
	self.scroll.beginY = math.max(0, offsetY - 0.8 * scrollH)
	local self.scroll.endY, tableShowH = offsetY + 1.8 * scrollH, self.scroll
	for i, v in ipairs(self.questListData) do
		if v.point then
			if v.posY < tableShowH.beginY or v.posY > tableShowH.endY then
				v.point:setVisible(false)
				table.insert(self.tableSpare, v.point)
				v.point = nil
			end
		elseif tableShowH.beginY <= v.posY and tableShowH.endY >= v.posY then
			if 0 < #self.tableSpare then
				single = table.remove(self.tableSpare)
				single:setVisible(true)
			else
				single = SoraDCreatePanel("questSingleView")
				single:setScroll(self.scroll)
				single:addTo(self.scroll)
			end
			single:initData(v.data, false)
			single:setPosition(cc.p(320, v.posY))
			v.point = single
		end
	end
end
function QuestViewNode:scrollEventCallBack(target, event)
	self:initQuestList()
end
function QuestViewNode:getRewardWoodEffect()
	self:overTurnAction()
	SoraDPlaySound("trainsoilder", BUILDID.SAWMILL)
	local rewardNum = 50
	local height = self:getContentSize().height
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
		self:addChild(resImgArray[i], 1000)
		_UPVALUE4_ = self
		_UPVALUE2_ = cc.p(tablePosX[i], initPosY[i])
		cc.p(tablePosX[i], initPosY[i])[1] = cca.fadeIn(tableFade[i] / 10)
		cc.p(tablePosX[i], initPosY[i])[2] = cc.EaseBounceOut:create(cca.moveTo(1, cc.p(tablePosX[i], targetPosY[i])))
		cc.p(tablePosX[i], initPosY[i])[3] = cca.rotateTo(1, tableRotate[i])
		cc.p(tablePosX[i], initPosY[i])[4] = cca.rotateTo(1, tableRotate[i])
		cc.p(tablePosX[i], initPosY[i])[5] = cca.rotateTo(1, tableRotate[i])
		cc.p(tablePosX[i], initPosY[i])[6] = cca.rotateTo(1, tableRotate[i])
		cc.p(tablePosX[i], initPosY[i])[7] = cca.rotateTo(1, tableRotate[i])
		cc.p(tablePosX[i], initPosY[i])[8] = cca.rotateTo(1, tableRotate[i])
		self[1] = cca.delay(randomDelay[i] / 10)
		self[2] = cca.spawn(cc.p(tablePosX[i], initPosY[i]))
		self[3] = cca.rotateTo(0.2, 0)
		self[4] = cca.delay(disappearTime - randomDelay[i] / 10)
		self[5] = cca.callFunc(function()
			resImgArray[i]:removeFromParent()
		end)
		self[6] = cca.callFunc(function()
			resImgArray[i]:removeFromParent()
		end)
		self[7] = cca.callFunc(function()
			resImgArray[i]:removeFromParent()
		end)
		self[8] = cca.callFunc(function()
			resImgArray[i]:removeFromParent()
		end)
		self[9] = cca.callFunc(function()
			resImgArray[i]:removeFromParent()
		end)
		self[10] = cca.callFunc(function()
			resImgArray[i]:removeFromParent()
		end)
		self[11] = cca.callFunc(function()
			resImgArray[i]:removeFromParent()
		end)
		local seq = transition.sequence(self)
		resImgArray[i]:runAction(seq)
	end
end
function QuestViewNode:getRewardFoodEffect()
	self:overTurnAction()
	SoraDPlaySound("trainsoilder", BUILDID.FARM)
	local rewardNum = 50
	local height = self:getContentSize().height
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
		self:addChild(resImgArray[i], 1000)
		_UPVALUE3_ = self
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
		self[1] = cca.delay(randomDelay[i] / 10)
		self[2] = cca.spawn(cc.p(tablePosX[i], initPosY[i]))
		self[3] = cca.delay(1)
		self[4] = cca.callFunc(function()
			resImgArray[i]:removeFromParent()
		end)
		self[5] = cca.callFunc(function()
			resImgArray[i]:removeFromParent()
		end)
		self[6] = cca.callFunc(function()
			resImgArray[i]:removeFromParent()
		end)
		self[7] = cca.callFunc(function()
			resImgArray[i]:removeFromParent()
		end)
		self[8] = cca.callFunc(function()
			resImgArray[i]:removeFromParent()
		end)
		self[9] = cca.callFunc(function()
			resImgArray[i]:removeFromParent()
		end)
		self[10] = cca.callFunc(function()
			resImgArray[i]:removeFromParent()
		end)
		self[11] = cca.callFunc(function()
			resImgArray[i]:removeFromParent()
		end)
		local seq = transition.sequence(self)
		resImgArray[i]:runAction(seq)
	end
end
function QuestViewNode:getRewardGoldEffect(...)
	self:overTurnAction()
	SoraDPlaySound("trainsoilder", 200)
	local frames = display.newFrames("et_main_gold_%.2d.png", 1, 9)
	local animation = display.newAnimation(frames, 0.09090909090909091)
	display.setAnimationCache("questGoldAnimation", animation)
	local rewardNum = 50
	local height = self:getContentSize().height
	local tablePosX = SoraDGetRandNum(rewardNum, -300, 300)
	local targetPosY = SoraDGetRandNum(rewardNum, height / 2 - 300, height / 2 - 200)
	local initPosY = SoraDGetRandNum(rewardNum, height - 250, height - 50)
	local randomDelay = SoraDGetRandNum(rewardNum, 1, 20)
	local disappearTime = 2.0
	for i = 1, rewardNum do
		do
			local goldSprite = display.newSprite("#et_main_gold_01.png")
			goldSprite:setPosition(cc.p(tablePosX[i], initPosY[i]))
			goldSprite:setAnchorPoint(cc.p(0.5, 0))
			goldSprite:setOpacity(0)
			goldSprite:setScale(0.6)
			self:addChild(goldSprite, 1000)
			_UPVALUE10_ = self
			_UPVALUE1_ = cc.p(0.5, 0)
			cc.p(0.5, 0)[1] = cca.fadeIn(0.25)
			cc.p(0.5, 0)[2] = cca.moveTo(0.4, cc.p(tablePosX[i], targetPosY[i]))
			cc.p(0.5, 0)[3] = cca.moveTo(0.4, cc.p(tablePosX[i], targetPosY[i]))
			cc.p(0.5, 0)[4] = cca.moveTo(0.4, cc.p(tablePosX[i], targetPosY[i]))
			cc.p(0.5, 0)[5] = cca.moveTo(0.4, cc.p(tablePosX[i], targetPosY[i]))
			cc.p(0.5, 0)[6] = cca.moveTo(0.4, cc.p(tablePosX[i], targetPosY[i]))
			cc.p(0.5, 0)[7] = cca.moveTo(0.4, cc.p(tablePosX[i], targetPosY[i]))
			cc.p(0.5, 0)[8] = cca.moveTo(0.4, cc.p(tablePosX[i], targetPosY[i]))
			cc.p(0.5, 0)[9] = cca.moveTo(0.4, cc.p(tablePosX[i], targetPosY[i]))
			self[1] = cca.delay(randomDelay[i] / 10)
			self[2] = cca.spawn(cc.p(0.5, 0))
			self[3] = cca.callFunc(function()
				goldSprite:playAnimationOnce(display.getAnimationCache("questGoldAnimation"))
			end)
			self[4] = cca.moveTo(0.3, cc.p(tablePosX[i], targetPosY[i] + 70))
			self[5] = cca.moveTo(0.2, cc.p(tablePosX[i], targetPosY[i]))
			self[6] = cca.moveTo(0.15, cc.p(tablePosX[i], targetPosY[i] + 30))
			self[7] = cca.moveTo(0.1, cc.p(tablePosX[i], targetPosY[i]))
			self[8] = cca.delay(0.05)
			self[9] = cca.rotateTo(0.2, -90)
			self[10] = cca.delay(disappearTime - randomDelay[i] / 10)
			self[11] = cca.callFunc(function()
				goldSprite:removeFromParent()
			end)
			self[12] = cca.callFunc(function()
				goldSprite:removeFromParent()
			end)
			local seq = transition.sequence(self)
			goldSprite:runAction(seq)
		end
	end
end
function QuestViewNode:getRewardGoldEffectNew(...)
	self:overTurnAction()
	SoraDPlaySound("trainsoilder", 200)
	local criSprite = cc.criSprite.createCriSprite("Jinbiyouhua.usm", true, false, nil)
	criSprite:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
	criSprite:setPosition(0, 0)
	criSprite:addTo(self, 1000)
end
function QuestViewNode:overTurnAction(...)
	_UPVALUE2_ = nil
	;(nil)[1] = cca.scaleTo(0.2, 1, 0)
	;(nil)[2] = cca.scaleTo(0.2, 1, 1)
	;(nil)[3] = cca.callFunc(function()
		self.node_recommend:initData(questCtrl:getRecommendedPerformingQuest(), true)
		SoraDCloseLoading(SoraDSearchPanelFromManagerByName("questView"))
	end)
	;(nil)[4] = cca.callFunc(function()
		self.node_recommend:initData(questCtrl:getRecommendedPerformingQuest(), true)
		SoraDCloseLoading(SoraDSearchPanelFromManagerByName("questView"))
	end)
	;(nil)[5] = cca.callFunc(function()
		self.node_recommend:initData(questCtrl:getRecommendedPerformingQuest(), true)
		SoraDCloseLoading(SoraDSearchPanelFromManagerByName("questView"))
	end)
	local seq = transition.sequence(nil)
	self.btn_touch:runAction(seq)
end
function QuestViewNode:onExitPanel()
	display.removeAnimationCache("questGoldAnimation")
end
return QuestViewNode
