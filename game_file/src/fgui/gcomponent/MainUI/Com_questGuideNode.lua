local gametop = gModuleMgr.getObject("gametop")
local questltCtrl = gModuleMgr.sharedMgr("questltCtrl")
local questCtrl = gametop.playertop_:getModule("questCtrl")
local questDesRead = include("questDesRead")
local newPlayerTaskCtrl = gametop.playertop_:getModule("newPlayerTaskCtrl")
local newPlayerTaskRead = include("newPlayerTaskRead")
local everydayTaskCtrl = gametop.playertop_:getModule("everydayTaskCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_questGuideNode = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/Com_questGuideNode", Com_questGuideNode)
function Com_questGuideNode:onInit()
	self.quest = nil
	self.isChapterReward = false
	self.isFirst = true
	self.curQuestName = ""
	self.isNewPlayer = false
	_ENV, self.newPlayerTimer = nil, nil
	;(nil).maxTimes = 10
	self.newPlayerTimeData, (nil).curTimes = nil, 0
	self.fields.spriteHand:setVisible(false)
	self:isShowNoticeParticle(false)
	self:addClickListener(handler(self, self.onBtnClick))
	self:fixChildrenPos()
	self.fields.n0:fix()
end
function Com_questGuideNode:onShow()
end
function Com_questGuideNode:isForgeinPvilionTaskAndHide(taskId)
	if taskId == 4103305 and not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.EXOTIC_PAVILION_ACTIVITY) then
		return true
	end
	return false
end
function Com_questGuideNode:registerEvent()
	SoraDAddMessage(self, "MESSAGE_QUEST_NOTICE_RECOMMEND_UPDATE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_QUEST_NOTICE_COMMIT_SUCCESS", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_QUEST_NOTICE_PROGRESS_UPDATE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_QUEST_NOTICE_SHOW_HAND", handler(self, self.showHand))
	SoraDAddMessage(self, "MESSAGE_NEW_PLAYER_QUEST_UPDATE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_NEW_PLAYER_QUEST_GET", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_NEW_PLAYER_QUEST_CHAPTER", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_NEW_PLAYER_QUEST_NOTICE_HAND_CLEAN", function(target, data)
		if data.needStop then
			self.fields.spriteHand:stopAllActions()
			self.fields.spriteHand:setVisible(false)
		end
		local curCastleLv = SoraDGetCastleLv()
		if curCastleLv < CASTLE_LV6_LIMITED then
			self.newPlayerTimeData.maxTimes = 3
		elseif curCastleLv <= CASTLE_LV13_LIMITED then
			self.newPlayerTimeData.maxTimes = 8
		end
		self.newPlayerTimeData.curTimes = 0
	end)
end
function Com_questGuideNode:judgeClose(target, data)
	if data.activityID == nil then
		self:initData()
		return
	end
	if type(data.activityID) == "number" then
		_UPVALUE1_ = type(data.activityID)
		type(data.activityID)[1] = data.activityID
		if type(data.activityID) then
			goto lbl_18
		end
	end
	local activityID = data.activityID
	::lbl_18::
	for k, v in pairs(activityID) do
		if v == gActivityTimeActivityID.EXOTIC_PAVILION_ACTIVITY then
			self:initData()
		end
	end
end
function Com_questGuideNode:updateNewPlayerGuide()
	local ret = false
	local showEffect = false
	self.isChapterReward = false
	local curChapterID = newPlayerTaskCtrl:getCurChapterID()
	if curChapterID and 0 < curChapterID then
		local castleLv = newPlayerTaskRead.getCastleLevelByChapterID(curChapterID)
		if castleLv <= SoraDGetCastleLv() then
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
				if not showEffect then
					self:showChapterQuestStatus()
				end
			end
			self.fields.Text_quest:setString(newPlayerTitle)
			self.fields.Text_quest:setVisible(true)
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
function Com_questGuideNode:updateMaxTimes()
	local curCastleLv = SoraDGetCastleLv()
	if curCastleLv < 6 then
		self.newPlayerTimeData.maxTimes = 8
	elseif curCastleLv <= 13 then
		self.newPlayerTimeData.maxTimes = 15
	else
		self.newPlayerTimeData.maxTimes = curCastleLv * 5
	end
	self.newPlayerTimeData.curTimes = 0
end
function Com_questGuideNode:newPlayerTimeUp()
	self.newPlayerTimeData.curTimes = self.newPlayerTimeData.curTimes + 1
	if self.newPlayerTimeData.curTimes >= self.newPlayerTimeData.maxTimes then
		if gModuleMgr.sharedMgr("mildGuideManager").mildParent == nil then
			self:showHand()
		end
		self.newPlayerTimeData.curTimes = 0
	end
end
function Com_questGuideNode:showHand()
	local curChapterID = newPlayerTaskCtrl:getCurChapterID()
	if SoraDIsGameGuide() == nil and curChapterID ~= 4103000 then
		_UPVALUE2_ = nil
		;(nil)[1] = ffa.callFunc(function(...)
			self.fields.spriteHand:setVisible(true)
			self.newPlayerTimeData.curTimes = 0
		end)
		;(nil)[2] = ffa.delay(5)
		;(nil)[3] = ffa.callFunc(function(...)
			self.fields.spriteHand:setVisible(false)
			if self.isNewPlayer then
				self:updateMaxTimes()
			end
		end)
		;(nil)[4] = ffa.callFunc(function(...)
			self.fields.spriteHand:setVisible(false)
			if self.isNewPlayer then
				self:updateMaxTimes()
			end
		end)
		local seq = ffa.seq(nil)
		self.fields.spriteHand:runAction(seq)
		print("======显示手指QuestGuideNode========")
	else
		self.fields.spriteHand:stopAllActions()
		self.fields.spriteHand:setVisible(false)
	end
end
function Com_questGuideNode:showHintEffect(isShow)
	if isShow then
		self.fields.Sprite_questBg:setShowType(4)
		if self.isNewPlayer then
			return
		end
		_UPVALUE1_ = self.fields.Sprite_questBg
		self.fields.Sprite_questBg[1] = ffa.delay(8)
		self.fields.Sprite_questBg[2] = ffa.callFunc(function()
			self.fields.Sprite_questBg:setShowType(0)
		end)
		self.fields.Sprite_questBg[3] = ffa.callFunc(function()
			self.fields.Sprite_questBg:setShowType(0)
		end)
		local selfSeq = ffa.seq(self.fields.Sprite_questBg)
		self:runAction(selfSeq)
	else
		self.fields.Sprite_questBg:setShowType(0)
	end
end
function Com_questGuideNode:initData()
	local oldQID = 0
	self.exData = nil
	self.fields.Text_quest:setColor(cc.c3b(255, 255, 255))
	_ENV = self.fields.Text_quest
	self.fields.Text_quest.msg = "MESSAGE_UI_DAILYAWARD_REFRESH_VIEW"
	SoraDSendMessage(self.fields.Text_quest)
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
	self.quest = questCtrl:getCanCommitQuest() or questCtrl:getGuideQuest()
	if not self.quest then
		self.quest = questCtrl:getFirstNormalQuest()
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
			self.fields.Text_quest:setString(self.curQuestName)
			self.fields.Text_quest:setVisible(true)
			self.isFirst = false
		elseif oldQID == self.quest:getQuestID() then
			self.fields.Text_quest:setString(self.curQuestName)
		else
			self:playTurnEffect()
		end
	else
		if self:updateNewPlayerGuide() then
			return
		end
		self:showFinishStatus()
		self:setVisible(false)
		self.fields.Text_quest:setString(i18n("common_text_1117"))
	end
end
function Com_questGuideNode:showChapterQuestStatus()
	self.fields.Sprite_questBg:setShowType(0)
end
function Com_questGuideNode:showFinishStatus()
	self.fields.Sprite_questBg:setShowType(1)
end
function Com_questGuideNode:showUnFinishStatus()
	self.fields.Sprite_questBg:setShowType(2)
end
function Com_questGuideNode:isShowNoticeParticle(ret)
	self.fields.Particle_fz1:setVisible(ret)
	self.fields.Particle_fz2:setVisible(ret)
	if ret then
		self.fields.Particle_fz1:resetSystem()
		self.fields.Particle_fz2:resetSystem()
	else
		self.fields.Particle_fz1:stopSystem()
		self.fields.Particle_fz2:stopSystem()
	end
end
function Com_questGuideNode:changeToExpostulation(data)
	if SoraDIsGameGuide() or self.quest and self.quest:canCommit() or self.isChapterReward or self.isNewPlayer then
		return
	end
	self:setVisible(true)
	self.exData = data
	self.fields.Sprite_questBg:setShowType(3)
	self:playTurnEffect(i18n(self.exData.des), cc.c3b(255, 255, 0))
end
function Com_questGuideNode:playTurnEffect(showStr, color)
	_UPVALUE2_ = nil
	;(nil)[1] = ffa.callFunc(function()
		self:isShowNoticeParticle(true)
	end)
	;(nil)[2] = ffa.delay(0.2)
	;(nil)[3] = ffa.callFunc(function()
		self.fields.Text_quest:setString(showStr or self.curQuestName)
		self.fields.Text_quest:setColor(color or cc.c3b(255, 255, 255))
	end)
	;(nil)[4] = ffa.callFunc(function()
		self.fields.Text_quest:setString(showStr or self.curQuestName)
		self.fields.Text_quest:setColor(color or cc.c3b(255, 255, 255))
	end)
	local seq = ffa.seq(nil)
	self:runAction(seq)
end
function Com_questGuideNode:changeToNormal()
	self:initData()
end
function Com_questGuideNode:onBtnClick()
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
	self.fields.spriteHand:stopAllActions()
	self.fields.spriteHand:setVisible(false)
	_ENV = self.fields.spriteHand
	self.fields.spriteHand.msg = "MESSAGE_MAINCITYVIEW_LEAVE_MOVE_MODE"
	SoraDSendMessage(self.fields.spriteHand)
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
return Com_questGuideNode
