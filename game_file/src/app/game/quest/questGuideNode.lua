local gametop = gModuleMgr.getObject("gametop")
local questltCtrl = gModuleMgr.sharedMgr("questltCtrl")
local questCtrl = gametop.playertop_:getModule("questCtrl")
local questDesRead = include("questDesRead")
local newPlayerTaskCtrl = gametop.playertop_:getModule("newPlayerTaskCtrl")
local newPlayerTaskRead = include("newPlayerTaskRead")
local cityCtrl = gametop.playertop_:getModule("cityCtrl")
local everydayTaskCtrl = gametop.playertop_:getModule("everydayTaskCtrl")
local QuestGuideNode = class("questGuideNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("questGuideNode")
	end
	return target
end)
function QuestGuideNode:ctor()
	self.layerQuest = SoraDGetChildByName(self, "Panel_quest")
	self.layerQuest:setLocalZOrder(2)
	self.labelQuest = SoraDGetChildByName(self, "Text_quest")
	self.spriteQuestBg = SoraDGetChildByName(self, "Sprite_questBg")
	self.btnNpc = SoraDGetChildByName(self, "Button_npc")
	self.spriteNpc = SoraDGetChildByName(self, "Sprite_npc")
	self.Particle_effect = SoraDGetChildByName(self, "Particle_effect")
	self.Particle_effect:setVisible(false)
	self:setPositionX(SoraDFPosX(550, 640))
	self.labelQuest:setContentSize(cc.size(380, 40))
	self.labelQuest:setPositionX(SoraDFPosX(285, 350))
	self.quest = nil
	self.isChapterReward = false
	self.isFirst = true
	self.curQuestName = ""
	self.isNewPlayer = false
	_ENV, self.newPlayerTimer = self.labelQuest.setPositionX, nil
	self.labelQuest.setPositionX.maxTimes = 10
	self.newPlayerTimeData, self.labelQuest.setPositionX.curTimes = self.labelQuest.setPositionX, 0
	self.spriteHand = SoraDFingerAction(true)
	self.spriteHand:setVisible(false)
	self.spriteHand:setPosition(cc.p(SoraDFSign(-230), 0))
	self.spriteHand:addTo(self, 2)
	self.iconSymbol = SoraDGetChildByName(self, "icon_saleRoom_symbol")
	self.node_flip = SoraDGetChildByName(self, "Node_flip")
	SoraDStopEffectNode(self.node_flip)
	self.node_hint = SoraDGetChildByName(self, "Node_hint")
	self.node_hint:setVisible(false)
	self.node_hintEffect = nil
	if self.layerQuest then
		self.layerQuest:addTouchEventListener(handler(self, self.btnClickCallBack))
		self.btnNpc:addTouchEventListener(handler(self, self.btnNpcClickCallBack))
	end
	self.nodeRed = SoraDGetChildByName(self, "icon_red")
	self.labelRed = SoraDGetChildByName(self, "Text_questNum")
	self:updateRed()
end
function QuestGuideNode:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_QUEST_NOTICE_RECOMMEND_UPDATE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_QUEST_NOTICE_COMMIT_SUCCESS", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_QUEST_NOTICE_PROGRESS_UPDATE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_UI_DAILYAWARD_REFRESH_BOXES", handler(self, self.updateRed))
	SoraDAddMessage(self, "MESSAGE_UI_DAILYAWARD_REFRESH_TREASURES", handler(self, self.updateRed))
	SoraDAddMessage(self, "MESSAGE_UI_DAILYAWARD_REFRESH_EVENTS", handler(self, self.updateRed))
	SoraDAddMessage(self, "MESSAGE_UI_DAILYAWARD_REFRESH_VIEW", handler(self, self.updateRed))
	SoraDAddMessage(self, "MESSAGE_QUEST_NOTICE_SHOW_HAND", handler(self, self.showHand))
	SoraDAddMessage(self, "MESSAGE_NEW_PLAYER_QUEST_UPDATE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_NEW_PLAYER_QUEST_GET", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_NEW_PLAYER_QUEST_CHAPTER", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_NEW_PLAYER_QUEST_NOTICE_HAND_CLEAN", function(target, data)
		if data.needStop then
			self.spriteHand:setVisible(false)
			self.spriteHand:stopActionByTag(1)
		end
		local curCastleLv = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
		if curCastleLv < CASTLE_LV6_LIMITED then
			self.newPlayerTimeData.maxTimes = 3
		elseif curCastleLv <= CASTLE_LV13_LIMITED then
			self.newPlayerTimeData.maxTimes = 8
		end
		self.newPlayerTimeData.curTimes = 0
	end)
end
function QuestGuideNode:updateRed()
	local count = 0
	count = count + everydayTaskCtrl:getReceiveNormalRewardCount()
	count = count + questCtrl:getCommitQuestNum()
	self.labelRed:setString(count)
	self.nodeRed:setVisible(0 < count)
	self.Particle_effect:setVisible(0 < count)
end
function QuestGuideNode:changeToExpostulation(data)
	if SoraDIsGameGuide() or self.quest and self.quest:canCommit() or self.isChapterReward or self.isNewPlayer then
		return
	end
	self.exData = data
	self.iconSymbol:setScale(1.0)
	self.iconSymbol:setSpriteFrame("icon_kits.png")
	self:playTurnEffect(i18n(self.exData.des), cc.c3b(255, 255, 0))
	self.iconSymbol:stopAllActions()
	_UPVALUE3_ = self.iconSymbol
	self.iconSymbol[1] = cca.scaleTo(1, 0.85)
	self.iconSymbol[2] = cca.scaleTo(1, 1)
	self.iconSymbol[3] = cca.scaleTo(1, 1.15)
	self.iconSymbol[4] = cca.scaleTo(1, 1)
	self.iconSymbol[5] = cca.scaleTo(1, 1)
	self.iconSymbol[6] = cca.scaleTo(1, 1)
	local seq = cca.seq(self.iconSymbol)
	self.iconSymbol:runAction(cc.RepeatForever:create(seq))
end
function QuestGuideNode:changeToNormal()
	self:initData()
end
function QuestGuideNode:initData()
	local oldQID = 0
	self.iconSymbol:stopAllActions()
	self.iconSymbol:setScale(0.5)
	self.exData = nil
	self.labelQuest:setColor(cc.c3b(255, 255, 255))
	self:updateLayout()
	self:updateRed()
	if self.newPlayerTimer then
		SoraDManagerRemoveTimer(self, self.newPlayerTimer)
		self.newPlayerTimer = nil
		self.isNewPlayer = nil
	end
	if self:updateNewPlayerGuide() then
		return
	end
	if self.quest then
		oldQID = self.quest:getQuestID()
	end
	self.quest = questCtrl:getCanCommitQuest()
	if self.quest == nil then
		self.quest = questCtrl:getGuideQuest()
	end
	if self.quest then
		if self.quest:canCommit() then
			self:showFinishStatus()
		else
			if self:updateNewPlayerGuide() then
				return
			end
			self:showUnFinishStatus()
		end
		self.curQuestName = questDesRead.getName(self.quest:getQuestID())
		if self.isFirst then
			self.labelQuest:setString(self.curQuestName)
			self.labelQuest:setVisible(true)
			self.isFirst = false
		elseif oldQID == self.quest:getQuestID() then
			self.labelQuest:setString(self.curQuestName)
		else
			self:playTurnEffect()
		end
	else
		if self:updateNewPlayerGuide() then
			return
		end
		self:showFinishStatus()
		self.labelQuest:setString(i18n("common_text_1117"))
	end
end
function QuestGuideNode:showClaimEffect()
end
function QuestGuideNode:hideClaimEffect()
end
function QuestGuideNode:updateLayout()
	local questCount = questCtrl:getCommitQuestNum()
	if questCount and 0 < questCount then
		self:showClaimEffect()
	else
		self:hideClaimEffect()
	end
end
function QuestGuideNode:isForgeinPvilionTaskAndHide(taskId)
	if taskId == 4103305 and not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.EXOTIC_PAVILION_ACTIVITY) then
		return true
	end
	return false
end
function QuestGuideNode:updateNewPlayerGuide()
	local ret = false
	local showEffect = false
	self.isChapterReward = false
	local curChapterID = newPlayerTaskCtrl:getCurChapterID()
	if curChapterID and 0 < curChapterID then
		local castleLv = newPlayerTaskRead.getCastleLevelByChapterID(curChapterID)
		local curCastleLv = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
		if castleLv <= curCastleLv then
			local data = newPlayerTaskCtrl:getTaskInfo()
			local maxCount = 0
			local curCount = 0
			for k, v in pairs(data) do
				if not self:isForgeinPvilionTaskAndHide(tonumber(k)) then
					maxCount = maxCount + 1
					if v.finishStatus then
						curCount = curCount + 1
						if not v.receiveStatus then
							showEffect = true
						end
					end
				end
			end
			newPlayerTaskCtrl = pairs(data)
			pairs(data).name = newPlayerTaskRead.getTitleByCID(curChapterID)
			pairs(data).msg = newPlayerTaskRead.getNameByCID(curChapterID)
			local newPlayerTitle = i18n("common_text_1000", pairs(data))
			if maxCount <= curCount then
				newPlayerTaskCtrl = newPlayerTaskRead.getNameByCID(curChapterID)
				newPlayerTaskRead.getNameByCID(curChapterID).title = newPlayerTitle
				newPlayerTaskRead.getNameByCID(curChapterID).des = i18n("common_text_854")
				newPlayerTitle = i18n("common_text_2482", (newPlayerTaskRead.getNameByCID(curChapterID)))
				self:showFinishStatus()
				showEffect = true
				self.isChapterReward = true
			else
				newPlayerTaskCtrl = newPlayerTaskRead.getNameByCID(curChapterID)
				newPlayerTaskRead.getNameByCID(curChapterID).title = newPlayerTitle
				newPlayerTaskCtrl = self
				self.member = curCount
				self.total = maxCount
				newPlayerTaskRead.getNameByCID(curChapterID).des = i18n("common_text_155", self)
				newPlayerTitle = i18n("common_text_2482", (newPlayerTaskRead.getNameByCID(curChapterID)))
				self:showChapterQuestStatus()
				self.iconSymbol:setScale(1.0)
			end
			self.labelQuest:setString(newPlayerTitle)
			self.labelQuest:setVisible(true)
			ret = true
			if self.newPlayerTimer == nil then
				self:updateMaxTimes()
				self.newPlayerTimer = SoradCreateTimer(self, handler(self, self.newPlayerTimeUp))
			end
		end
	end
	self.isNewPlayer = ret
	self:showHintEffect(showEffect)
	return ret
end
function QuestGuideNode:newPlayerTimeUp()
	self.newPlayerTimeData.curTimes = self.newPlayerTimeData.curTimes + 1
	if self.newPlayerTimeData.curTimes >= self.newPlayerTimeData.maxTimes then
		if gModuleMgr.sharedMgr("mildGuideManager").mildParent == nil then
			self:showHand()
		end
		self.newPlayerTimeData.curTimes = 0
	end
end
function QuestGuideNode:updateMaxTimes()
	local curCastleLv = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
	if curCastleLv < 6 then
		self.newPlayerTimeData.maxTimes = 8
	elseif curCastleLv <= 13 then
		self.newPlayerTimeData.maxTimes = 15
	else
		self.newPlayerTimeData.maxTimes = curCastleLv * 5
	end
	self.newPlayerTimeData.curTimes = 0
end
function QuestGuideNode:showHand()
	self.spriteHand:stopActionByTag(1)
	local curChapterID = newPlayerTaskCtrl:getCurChapterID()
	if SoraDIsGameGuide() == nil and curChapterID ~= 4103000 then
		_UPVALUE2_ = 1
		;(1)[1] = cca.callFunc(function(...)
			self.spriteHand:setVisible(true)
			self.newPlayerTimeData.curTimes = 0
		end)
		;(1)[2] = cca.delay(5)
		;(1)[3] = cca.callFunc(function(...)
			self.spriteHand:setVisible(false)
			if self.isNewPlayer then
				self:updateMaxTimes()
			end
		end)
		;(1)[4] = cca.callFunc(function(...)
			self.spriteHand:setVisible(false)
			if self.isNewPlayer then
				self:updateMaxTimes()
			end
		end)
		local seq = transition.sequence(1)
		seq:setTag(1)
		self.spriteHand:runAction(seq)
		print("======显示手指QuestGuideNode========")
	else
		self.spriteHand:setVisible(false)
	end
end
function QuestGuideNode:btnNpcClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound("uicontrol", 20)
		uiManager:show("questView")
	end
end
function QuestGuideNode:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		_ENV = nil
		;(nil).msg = "MESSAGE_UI_EXPOSTULATION_UPDATE"
		;(nil).isInit = true
		SoraDSendMessage(nil)
		if self.exData then
			SoraDPlaySound()
			self.exData.jump()
			self:changeToNormal()
			return
		end
		local guideCtrl = gametop.playertop_:getModule("guideCtrl")
		if self.isNewPlayer and guideCtrl:getCurForceGuideStep() ~= 2011 then
			SoraDPlaySound("uicontrol", 21)
			SoraDCreatePanel("newPlayerQuestView"):show()
			return
		end
		self.spriteHand:stopActionByTag(1)
		self.spriteHand:setVisible(false)
		_ENV = self.spriteHand
		self.spriteHand.msg = "MESSAGE_MAINCITYVIEW_LEAVE_MOVE_MODE"
		SoraDSendMessage(self.spriteHand)
		_ENV = false
		userSDKManager.logEvent(gSDKDef.TDonEvent.click_quest_view, false)
		if self.quest then
			SoraDPlaySound("uicontrol", 21)
			if self.quest:canCommit() then
				questCtrl:reqCommitQuest(self.quest:getQuestID())
			else
				questltCtrl:jumpToFinishedById(self.quest:getQuestID())
			end
		end
	end
end
function QuestGuideNode:showChapterQuestStatus()
	self.iconSymbol:setSpriteFrame("icon_chapterTask.png")
end
function QuestGuideNode:showFinishStatus()
	self.iconSymbol:setSpriteFrame("icon_czhl_g.png")
end
function QuestGuideNode:showUnFinishStatus()
	self.iconSymbol:setSpriteFrame("icon_saleRoom_symbol.png")
end
function QuestGuideNode:showHintEffect(isShow)
	if isShow then
		if self.node_hintEffect == nil then
			local effect = SoraDCreatAnimation("renwutishi", nil, true)
			self.effect = effect
			effect:setPosition(cc.p(-188, 0))
			self.node_hint:addChild(effect, 1)
			self.node_hintEffect = effect
		end
		self.node_hint:setVisible(true)
		self:stopActionByTag(8)
		if self.isNewPlayer then
			return
		end
		_UPVALUE1_ = self
		self[1] = cca.delay(8)
		self[2] = cca.callFunc(function()
			self.node_hint:setVisible(false)
		end)
		self[3] = cca.callFunc(function()
			self.node_hint:setVisible(false)
		end)
		self[4] = cca.callFunc(function()
			self.node_hint:setVisible(false)
		end)
		local selfSeq = cca.seq(self)
		selfSeq:setTag(8)
		self:runAction(selfSeq)
	else
		self:stopActionByTag(8)
		self.node_hint:setVisible(false)
	end
end
function QuestGuideNode:playTurnEffect(showStr, color)
	local tishiEffect = function()
		SoraDResetEffectNode(self.node_flip)
	end
	_UPVALUE4_ = nil
	;(nil)[1] = cca.scaleTo(0.2, 1, 0)
	;(nil)[2] = cca.callFunc(tishiEffect)
	;(nil)[3] = cca.delay(0.2)
	;(nil)[4] = cca.scaleTo(0.2, 1, 1)
	;(nil)[5] = cca.callFunc(function()
		self.labelQuest:setString(showStr or self.curQuestName)
		self.labelQuest:setColor(color or cc.c3b(255, 255, 255))
	end)
	;(nil)[6] = cca.callFunc(function()
		self.labelQuest:setString(showStr or self.curQuestName)
		self.labelQuest:setColor(color or cc.c3b(255, 255, 255))
	end)
	;(nil)[7] = cca.callFunc(function()
		self.labelQuest:setString(showStr or self.curQuestName)
		self.labelQuest:setColor(color or cc.c3b(255, 255, 255))
	end)
	local seq = transition.sequence(nil)
	self.layerQuest:runAction(seq)
end
return QuestGuideNode
