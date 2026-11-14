local newKingTrailRead = include("newKingTrailRead")
local newKingTrailCtrl = SoraDGetCtrl("newKingTrailCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local lordSpineDef = include("lordSpineDef")
local lordLocalData = include("lordLocalData")
local newKingTrailView = class("newKingTrailView", function(target)
	return target or SoraDCreateBasePanel("newKingTrailView")
end)
function newKingTrailView:ctor()
	self.tableItemsSel, _ENV, self.tableItemsSpare, _ENV, self.sessionTabTbl, _ENV = nil, nil, nil, nil, nil, nil
	self.selectDay = 1
	self.titleNode = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_GodRewards")
	self.titleNode:setTitle(i18n("king_tri_name_01"))
	self.titleNode:setBtnHelpClickCallBack(handler(self, self.btnClickQuestion))
	self.activityTime = SoraDGetChildByName(self, "Text_remainTime")
	self.activityTime = SoraDCreateTimerLabel(self, self.activityTime)
	self.activityTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("common_text_4415", nil)
	end)
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView")
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	self.scrollSingle = SoraDGetChildByName(self, "Node_Single")
	self.calculateNode = SoraDGetChildByName(self, "Center_Node_Calculate")
	self.activeNode = SoraDGetChildByName(self, "Node_Active")
	self.sessionNode = SoraDGetChildByName(self.activeNode, "Node_Session", true)
	self.infoNode = SoraDGetChildByName(self.activeNode, "Node_Info", true)
	self.bottomNode = SoraDGetChildByName(self, "Bottom_Node")
	self.sessionSingle = SoraDGetChildByName(self, "Node_SessionSingle")
	self.nodeTaskTime = SoraDGetChildByName(self.infoNode, "Node_Tasktime", true)
	self.textTaskName = SoraDGetChildByName(self.infoNode, "Text_TaskName", true)
	self.textTaskExplain = SoraDGetChildByName(self.infoNode, "Text_TaskExpalin", true)
	self.taskTime = SoraDGetChildByName(self.nodeTaskTime, "Text_TaskLeftTime", true)
	self.taskTime = SoraDCreateTimerLabel(self, self.taskTime)
	self.taskTime:setTimeLast(function(ticket)
		_ENV = nil
		;(nil).time = ticket
		return i18n("king_tri_text_08", nil)
	end)
	self.textPointHave = SoraDGetChildByName(self.infoNode, "Text_PointsHave", true)
	self.btnGetPointGo = SoraDGetChildByName(self.infoNode, "Button_GetPoints", true)
	self.btnGetPointGo:addTouchEventListener(handler(self, self.btnClickGetPointGo))
	self.btnGetPointGo:setTitleText(i18n("kingdom_grace_btn_01"))
	SoraDAutoSizeButtonText(self.btnGetPointGo, cc.size(116, 32))
	self.btnOpenRank = SoraDGetChildByName(self.bottomNode, "Button_ShowRank", true)
	self.btnOpenRank:addTouchEventListener(handler(self, self.btnClickOpenRank))
	self.btnOpenRank:setTitleText(i18n("common_text_2187"))
	self.btnOpenAward = SoraDGetChildByName(self.bottomNode, "Button_RankAward", true)
	self.btnOpenAward:addTouchEventListener(handler(self, self.btnClickOpenAward))
	self.btnOpenAward:setTitleText(i18n("common_text_2194"))
	self.spineNode = SoraDGetChildByName(self.calculateNode, "Node_spine", true)
	self.spriteHead = SoraDGetChildByName(self.calculateNode, "Sprite_portrait", true)
	self.btnJump = SoraDGetChildByName(self.calculateNode, "Button_portrait", true)
	self.btnJump:addTouchEventListener(handler(self, self.btnClickJump))
	self.textLeaderName = SoraDGetChildByName(self.calculateNode, "Text_NameA")
	self.textCongrate = SoraDGetChildByName(self.calculateNode, "Text_Congratulation")
	self.imageHead = SoraDGetChildByName(self.calculateNode, "Sprite_head")
	self.calculateNode:setVisible(false)
	self.effectNode = SoraDGetChildByName(self.calculateNode, "Effect_Node")
	local tmpnode = SoraDCreatAnimationEx("newKingTrailEffect", nil, true)
	self.effectNode:addChild(tmpnode)
	SoraDMixtureGLONEByParent(tmpnode)
	tmpnode:setPosition(0, 0)
	if self:getPanelOffsetHeight() < 1136 then
		local lightParticle1 = SoraDGetChildByName(tmpnode, "et_Par_ymzdyyh_002")
		lightParticle1:setPositionY(lightParticle1:getPositionY() - (1136 - self:getPanelOffsetHeight()) / 2)
		local lightParticle2 = SoraDGetChildByName(tmpnode, "et_Par_zxtc_007")
		lightParticle2:setPositionY(lightParticle2:getPositionY() - (1136 - self:getPanelOffsetHeight()) / 2)
	end
	self.eventTime = activityShowCtrl:getTimeInfoByID(gActivityTimeActivityID.NEWKING_TRAIL)
	newKingTrailCtrl:sendReqInit()
	self.firstView = true
	SoraDShowLoading(self)
end
function newKingTrailView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_NEWKINGTRAIL_REFRESH", handler(self, self.UpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
end
function newKingTrailView:UpdateView(target, data)
	SoraDCloseLoading(self)
	dump(data, "data", 10)
	print("self.firstView ", self.firstView)
	if data.refreshAll or self.firstView then
		self.firstView = false
		self:initSessionTab()
	elseif self.nowStage ~= 6 then
		self:initScroll()
	end
end
function newKingTrailView:initTime()
	local totalTime = self.eventTime and self.eventTime.totaltime or 0
	local totalStageTime = newKingTrailRead.getTotalStageTime(5)
	if self.eventTime then
		local activityTime = self.eventTime.timerNode.timer:getRemainTime() - (totalTime - totalStageTime)
		if 0 < activityTime then
			self.activityTime:beginTime(activityTime)
		else
			self.activityTime:beginTime(self.eventTime.timerNode.timer:getRemainTime())
		end
	end
end
function newKingTrailView:initTaskTime()
	local totalTime = self.eventTime and self.eventTime.totaltime or 0
	local stageTime = newKingTrailRead.getTotalStageTime(self.selectDay)
	if self.eventTime then
		local taskTime = stageTime - (totalTime - self.eventTime.timerNode.timer:getRemainTime())
		if self.selectDay == self.nowStage then
			self.taskTime:beginTime(taskTime)
		else
			self.taskTime:endTime()
			self.taskTime:setString(i18n("king_tri_text_09"))
		end
	end
	SoraDToCenter(self.nodeTaskTime)
end
function newKingTrailView:initScroll()
	local scrollData = newKingTrailRead.getStageRewardByType(self.selectDay)
	self:clearOld()
	for i, v in ipairs(scrollData) do
		newKingTrailRead = nil
		;(nil).data = v
		newKingTrailRead, (nil).point = nil, nil
		;(nil).x = 0
		;(nil).pos, (nil).y = nil, 0
		table.insert(self.tableItemsSel, nil)
	end
	self:initTaskScoll()
	self:initTasks()
end
function newKingTrailView:clearOld()
	for i, v in ipairs(self.tableItemsSel) do
		if v.point then
			v.point:setVisible(false)
			table.insert(self.tableItemsSpare, v.point)
			v.point = nil
		end
	end
	self.tableItemsSel, _ENV = ipairs(self.tableItemsSel)
end
function newKingTrailView:initTaskScoll(isReload)
	if isReload then
		self.scroll:jumpToTop()
	end
	self.heightEvent = 160
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local scrollH = self.scroll:getContentSize().height
	local scrollW = self.scroll:getContentSize().width
	local accumulateHeight = math.max(#self.tableItemsSel * self.heightEvent, scrollH)
	for i, v in ipairs(self.tableItemsSel) do
		v.pos.x = 320
		v.pos.y = accumulateHeight - (i - 1) * self.heightEvent
		if v.point then
			v.point:setPositionX(v.pos.x)
			v.point:setPositionY(v.pos.y)
		end
	end
	offsetY = offsetY - (accumulateHeight - scrollInner:getContentSize().height)
	self.scroll:setInnerContainerSize(cc.size(scrollW, accumulateHeight))
	scrollInner:setPositionY(offsetY)
end
function newKingTrailView:initTasks(isReload)
	if isReload then
		self.scroll:jumpToTop()
	end
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scroll:getContentSize().height
	_ENV = self.scroll
	self.scroll.beginY = math.max(0, offsetY - 2 * scrollH)
	local self.scroll.endY, tableShowH = offsetY + 2 * scrollH, self.scroll
	for i, v in ipairs(self.tableItemsSel) do
		if v.point then
			if v.pos.y < tableShowH.beginY or v.pos.y > tableShowH.endY then
				v.point:setVisible(false)
				table.insert(self.tableItemsSpare, v.point)
				v.point = nil
			end
		elseif tableShowH.beginY <= v.pos.y and tableShowH.endY >= v.pos.y then
			local single
			if 0 < #self.tableItemsSpare then
				single = table.remove(self.tableItemsSpare)
				single:setVisible(true)
			else
				single = self.scrollSingle:clone()
				single:addTo(self.scroll)
			end
			self:setScrollSingle(single, v.data)
			single:setPosition(v.pos.x, v.pos.y)
			v.point = single
		end
	end
end
function newKingTrailView:setScrollSingle(parent, data)
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	local reward = serviceFunctions.tableFormat(data.reward, nil)
	local nodeAward = SoraDGetChildByName(parent, "Node_Awrad", true)
	nodeAward:removeAllChildren()
	for i, v in ipairs(reward) do
		local item = include("commonItemAward").new()
		item:setScale(0.8)
		item:setBaseScale(1.0)
		item:setOwnView(self)
		item:setOwnScroll(self.scroll)
		item:setPosition(0, 0)
		item:initData(v.id, v.count)
		item:addTo(nodeAward)
	end
	SoraDToCenter(nodeAward, 100)
	_ENV = nil
	;(nil).point = string.formatnumberthousands(data.score)
	SoraDGetChildByName(parent, "Text_TaskPoints", true):setString(i18n("common_text_2200", nil))
	SoraDGetChildByName(parent, "Text_LastTask"):setString(i18n("common_text_2699"))
	SoraDGetChildByName(parent, "Image_LastInfo", true):setVisible(self.sessionPointHave > data.score)
end
function newKingTrailView:initSessionInfo()
	self.textTaskName:setString(i18n(self.sessionTabTbl[self.selectDay].name))
	self.textTaskExplain:setString(i18n(self.sessionTabTbl[self.selectDay].describe))
	self.sessionPointHave = newKingTrailCtrl:getStagePoint(self.selectDay)
	_ENV = i18n(self.sessionTabTbl[self.selectDay].describe)
	i18n(self.sessionTabTbl[self.selectDay].describe).num = string.formatnumberthousands(math.floor(self.sessionPointHave))
	self.textPointHave:setString(i18n("common_text_2556", i18n(self.sessionTabTbl[self.selectDay].describe)))
	self:initTaskTime()
end
function newKingTrailView:initSessionTab()
	self.sessionInfo = newKingTrailRead.getStageConfig()
	self.nowStage = newKingTrailCtrl:getNowStage() or 1
	self.selectDay = self.nowStage == 6 and 5 or self.nowStage
	local nums = table.nums(self.sessionInfo)
	if self.nowStage ~= 6 then
		for i = 1, nums do
			local tmp = self.sessionTabTbl[i]
			if tmp == nil then
				tmp, newKingTrailRead = nil, nil
				local single = self.sessionSingle:clone()
				single:addTo(self.sessionNode, i, self.sessionInfo[i].type)
				single:setPositionY(-100)
				tmp.itemNode = single
				tmp.name = self.sessionInfo[i].name
				tmp.describe = self.sessionInfo[i].describe
				tmp.icon = self.sessionInfo[i].icon
				tmp.showProgressBg = i ~= nums
				tmp.type = self.sessionInfo[i].type
				self.sessionTabTbl[i] = tmp
				self.next = 1
				local button = SoraDGetChildByName(single, "Button_Item", true)
				button:setTag(i)
				button:addTouchEventListener(handler(self, self.btnClickSessionTab))
			end
			if i < self.nowStage then
				tmp.stageStatus = ACTIVITY_STATE.FINISH
			elseif self.nowStage == i then
				tmp.stageStatus = ACTIVITY_STATE.ACTIVE
			else
				tmp.stageStatus = ACTIVITY_STATE.PREPARE
			end
			self:initSessionSingle(tmp, i)
		end
		if self.next == 1 then
			SoraDToCenter(self.sessionNode, 120, SoraDFIsRA())
		end
		self:initSessionInfo()
		self:initScroll()
		self:initTaskTime()
	else
		self:initCalculateData()
		self.calculateNode:setVisible(true)
		self.scroll:setVisible(false)
		self.activeNode:setVisible(false)
	end
	self:initTime()
end
function newKingTrailView:initCalculateData()
	self.leaderInfo = newKingTrailCtrl:getRankFirstInfo()
	dump(self.leaderInfo, "self.leaderInfo", 10)
	if self.leaderInfo == nil then
		newKingTrailCtrl:sendReqTotalStageRank()
		return
	end
	local info = lordSpineDef.getLordSpineInfo(self.leaderInfo.imageId)
	if info then
		self.spriteHead:setVisible(false)
		if self.animation == nil then
			self.animation = sp.SkeletonAnimation:create(info.json, info.atlas, 1)
			local offset = info.offset or cc.p(0, 0)
			self.animation:setPosition(cc.p(0 + offset.x, 0 + offset.y))
			self.animation:setAnimation(0, "animation", true)
			self.animation:addTo(self.spineNode)
		end
	else
		self.spriteHead:setVisible(true)
		self.spriteHead:setSpriteFrame(lordLocalData.getPortrait(self.leaderInfo.imageId))
	end
	self.textLeaderName:setString(self.leaderInfo.allianceAbbr and self.leaderInfo.nickName .. "\n" .. "(" .. self.leaderInfo.allianceAbbr .. ")" or self.leaderInfo.nickName)
	newKingTrailCtrl = "("
	;("(").name = self.leaderInfo.nickName
	self.textCongrate:setString(i18n("king_tri_text_17", "("))
	SoraDGetHeadFromManager(self.imageHead, self.leaderInfo.imageId, self.leaderInfo.avatar)
	if self:getPanelOffsetHeight() < 900 then
		self.textCongrate:setPositionY(self.textCongrate:getPositionY() + 50)
	elseif self:getPanelOffsetHeight() > 1200 then
		local lightParticle1 = SoraDGetChildByName(self.effectNode, "et_Par_ymzdyyh_002")
		lightParticle1:setPositionY(lightParticle1:getPositionY() - (1136 - self:getPanelOffsetHeight()) / 2)
	end
end
function newKingTrailView:initSessionSingle(tmp, index)
	local progressBar = SoraDGetChildByName(tmp.itemNode, "progressbar_main", true)
	progressBar:setVisible(tmp.showProgressBg)
	print("showProgressBg", tmp.showProgressBg, index)
	local imageIcon = SoraDGetChildByName(tmp.itemNode, "Image_Icon", true)
	SoraDGetChildByName(tmp.itemNode, "Image_Bar"):setVisible(tmp.stageStatus ~= ACTIVITY_STATE.PREPARE)
	SoraDGetChildByName(tmp.itemNode, "Image_Lock", true):setVisible(tmp.stageStatus == ACTIVITY_STATE.PREPARE)
	imageIcon:loadTexture(tmp.icon, ccui.TextureResType.plistType)
	_ENV = nil
	;(nil).num = index
	SoraDGetChildByName(tmp.itemNode, "Text_SessionName", true):setString(i18n("common_text_3198", nil))
	local effectImage = SoraDGetChildByName(tmp.itemNode, "dh_xwjyd_01_1", true)
	effectImage:setVisible(index == self.selectDay)
	effectImage:setScale(0.9)
	effectImage:setBlendFunc(gl.ONE, gl.ONE)
	local action = cca.repeatForever(cca.rotateBy(2.566666666666667, 360))
	effectImage:runAction(action)
	imageIcon:getVirtualRenderer():setState(tmp.stageStatus == ACTIVITY_STATE.FINISH and 1 or 0)
end
function newKingTrailView:btnClickQuestion(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("king_tri_text_01"))
	end
end
function newKingTrailView:btnClickOpenRank(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("newKingTrailRankView"):show()
	end
end
function newKingTrailView:btnClickOpenAward(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("newKingTrailAwardView"):show()
	end
end
function newKingTrailView:btnClickGetPointGo(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.stringHelpData, _ENV = SoraDPlaySound, SoraDPlaySound
		local strList = newKingTrailRead.getStrList(self.selectDay)
		local panel = SoraDCreatePanel("commonFixPopWindow")
		panel:initData(i18n("kingdom_grace_btn_01"), strList)
		panel:setBtnInfo(handler(self, self.btnClickGo), i18n("common_text_678"))
		panel:show()
	end
end
_ENV, _UPVALUE5_, newKingTrailView.btnClickSessionTab = function(target)
	return target or SoraDCreateBasePanel("newKingTrailView")
end, function(self, button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local sessionIndex = button:getTag()
		if sessionIndex <= self.nowStage then
			local lastIndex = self.selectDay
			self.selectDay = sessionIndex
			self:initSessionSingle(self.sessionTabTbl[lastIndex], lastIndex)
			self:initSessionSingle(self.sessionTabTbl[self.selectDay], self.selectDay)
			newKingTrailCtrl:sendReqInit()
		else
			SoraDShowMsgTip(i18n("king_tri_text_02"))
		end
	end
end, function(self, button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local sessionIndex = button:getTag()
		if sessionIndex <= self.nowStage then
			local lastIndex = self.selectDay
			self.selectDay = sessionIndex
			self:initSessionSingle(self.sessionTabTbl[lastIndex], lastIndex)
			self:initSessionSingle(self.sessionTabTbl[self.selectDay], self.selectDay)
			newKingTrailCtrl:sendReqInit()
		else
			SoraDShowMsgTip(i18n("king_tri_text_02"))
		end
	end
end
_ENV, (function(target)
	return target or SoraDCreateBasePanel("newKingTrailView")
end).data, _ENV, (function(target)
	return target or SoraDCreateBasePanel("newKingTrailView")
end).id = gNewPLayerTaskType.BUILD_CAN_UPGRADE, gNewPLayerTaskType.BUILD_CAN_UPGRADE, gNewPLayerTaskType.BUILD_CAN_UPGRADE, gNewPLayerTaskType.BUILD_CAN_UPGRADE
_ENV, gNewPLayerTaskType.BUILD_CAN_UPGRADE.id = gNewPLayerTaskType.TRAIN_SOLDIERS, gNewPLayerTaskType.TRAIN_SOLDIERS
_ENV, gNewPLayerTaskType.BUILD_CAN_UPGRADE.data, gNewPLayerTaskType.TRAIN_SOLDIERS.bid = gNewPLayerTaskType.TRAIN_SOLDIERS, gNewPLayerTaskType.TRAIN_SOLDIERS, 0
_ENV, gNewPLayerTaskType.TRAIN_SOLDIERS.id = gEverydayTaskType.COLLECT_FOOD, gEverydayTaskType.COLLECT_FOOD
_ENV, gNewPLayerTaskType.TRAIN_SOLDIERS.data, gEverydayTaskType.COLLECT_FOOD.resid = gEverydayTaskType.COLLECT_FOOD, gEverydayTaskType.COLLECT_FOOD, 1002
_ENV, gEverydayTaskType.COLLECT_FOOD.data, _ENV, gEverydayTaskType.COLLECT_FOOD.id = gEverydayTaskType.ATTACK_MONSTER, gEverydayTaskType.ATTACK_MONSTER, gEverydayTaskType.ATTACK_MONSTER, gEverydayTaskType.ATTACK_MONSTER
gEverydayTaskType.ATTACK_MONSTER.data, _ENV, gEverydayTaskType.ATTACK_MONSTER.id = gNewPLayerTaskType.QUICK_TO_WORLD, gNewPLayerTaskType.QUICK_TO_WORLD, gNewPLayerTaskType.QUICK_TO_WORLD
;(function(self, button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local sessionIndex = button:getTag()
		if sessionIndex <= self.nowStage then
			local lastIndex = self.selectDay
			self.selectDay = sessionIndex
			self:initSessionSingle(self.sessionTabTbl[lastIndex], lastIndex)
			self:initSessionSingle(self.sessionTabTbl[self.selectDay], self.selectDay)
			newKingTrailCtrl:sendReqInit()
		else
			SoraDShowMsgTip(i18n("king_tri_text_02"))
		end
	end
end)[1] = function(target)
	return target or SoraDCreateBasePanel("newKingTrailView")
end
;(function(self, button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local sessionIndex = button:getTag()
		if sessionIndex <= self.nowStage then
			local lastIndex = self.selectDay
			self.selectDay = sessionIndex
			self:initSessionSingle(self.sessionTabTbl[lastIndex], lastIndex)
			self:initSessionSingle(self.sessionTabTbl[self.selectDay], self.selectDay)
			newKingTrailCtrl:sendReqInit()
		else
			SoraDShowMsgTip(i18n("king_tri_text_02"))
		end
	end
end)[2] = gNewPLayerTaskType.BUILD_CAN_UPGRADE
;(function(self, button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local sessionIndex = button:getTag()
		if sessionIndex <= self.nowStage then
			local lastIndex = self.selectDay
			self.selectDay = sessionIndex
			self:initSessionSingle(self.sessionTabTbl[lastIndex], lastIndex)
			self:initSessionSingle(self.sessionTabTbl[self.selectDay], self.selectDay)
			newKingTrailCtrl:sendReqInit()
		else
			SoraDShowMsgTip(i18n("king_tri_text_02"))
		end
	end
end)[3] = gNewPLayerTaskType.TRAIN_SOLDIERS
;(function(self, button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local sessionIndex = button:getTag()
		if sessionIndex <= self.nowStage then
			local lastIndex = self.selectDay
			self.selectDay = sessionIndex
			self:initSessionSingle(self.sessionTabTbl[lastIndex], lastIndex)
			self:initSessionSingle(self.sessionTabTbl[self.selectDay], self.selectDay)
			newKingTrailCtrl:sendReqInit()
		else
			SoraDShowMsgTip(i18n("king_tri_text_02"))
		end
	end
end)[4] = gEverydayTaskType.COLLECT_FOOD
local (function(self, button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local sessionIndex = button:getTag()
		if sessionIndex <= self.nowStage then
			local lastIndex = self.selectDay
			self.selectDay = sessionIndex
			self:initSessionSingle(self.sessionTabTbl[lastIndex], lastIndex)
			self:initSessionSingle(self.sessionTabTbl[self.selectDay], self.selectDay)
			newKingTrailCtrl:sendReqInit()
		else
			SoraDShowMsgTip(i18n("king_tri_text_02"))
		end
	end
end)[5], questID = gEverydayTaskType.ATTACK_MONSTER, function(self, button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local sessionIndex = button:getTag()
		if sessionIndex <= self.nowStage then
			local lastIndex = self.selectDay
			self.selectDay = sessionIndex
			self:initSessionSingle(self.sessionTabTbl[lastIndex], lastIndex)
			self:initSessionSingle(self.sessionTabTbl[self.selectDay], self.selectDay)
			newKingTrailCtrl:sendReqInit()
		else
			SoraDShowMsgTip(i18n("king_tri_text_02"))
		end
	end
end
function newKingTrailView:btnClickGo(target, event)
	if event == ccui.TouchEventType.ended then
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		if self.selectDay == 4 or self.selectDay == 3 then
			mildGuideManager:starMildByEverydayTaskID(questID[self.selectDay].id, questID[self.selectDay].data)
		else
			mildGuideManager:starMildByNewPlayerQuestID(questID[self.selectDay].id, questID[self.selectDay].data)
		end
		SoraDRemoveAllPanelFromManager()
	end
end
function newKingTrailView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:initTasks()
	end
end
function newKingTrailView:btnClickJump(target, event)
	if event == ccui.TouchEventType.ended then
		local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
		if self.leaderInfo then
			_ENV = nil
			;(nil).targetName = self.__cname
			lordInfoCtrl:getLordInfoByUid(tonumber(self.leaderInfo.uid), self.leaderInfo.kid, nil)
		end
	end
end
function newKingTrailView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEWKING_TRAIL) then
		SoraDRemoveAllAfterPanelFromManager(self, false)
	end
end
function newKingTrailView:serverMessageGetLordInfo(target, data)
	SoraDCloseLoading(self)
	if data and data.lord then
		SoraDOpenLordView(data.lord)
	end
end
return newKingTrailView
