local gametop = gModuleMgr.getObject("gametop")
local newPlayerTaskCtrl = gametop.playertop_:getModule("newPlayerTaskCtrl")
local newPlayerTaskRead = include("newPlayerTaskRead")
local NewPlayerQuestView = class("newPlayerQuestView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("newPlayerQuestView")
	end
	return target
end)
function NewPlayerQuestView:ctor()
	self.Panel_touch = SoraDGetChildByName(self, "Panel_touch")
	if display.height < 960 then
		local scale = display.height / 960
		self._ccsView:setScale(scale)
		self._ccsView:setPosition((640 - 640 * scale) / 2, (960 - display.height) / 2)
		self.Panel_touch:setScale(1 / scale)
	end
	self.curChapterID = -1
	self.tableQuestSinge, _ENV, self.tablePrizeSinge, _ENV, self.questData, _ENV, self.isAllFinished = display.height / 960, display.height / 960, display.height / 960, display.height / 960, display.height / 960, display.height / 960, false
	self.centerBg = SoraDGetChildByName(self, "Center_Bg")
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	self.Node_head = SoraDGetChildByName(self, "Node_head")
	self.Node_bottom = SoraDGetChildByName(self, "Node_bottom")
	self.labelTitle = SoraDGetChildByName(self, "Text_title")
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.nodeQuestSingle = SoraDGetChildByName(self, "Node_questSingle")
	self.closeButton = SoraDGetChildByName(self, "Button_close")
	self.titleSp = SoraDGetChildByName(self, "Sprite_title")
	self.leftLineTitle = SoraDGetChildByName(self, "Image_line_l_title")
	self.rightLineTitle = SoraDGetChildByName(self, "Image_line_r_title")
	self.leftLine = SoraDGetChildByName(self, "Image_line_l")
	self.rightLine = SoraDGetChildByName(self, "Image_line_r")
	_UPVALUE2_ = (960 - display.height) / 2
	;(960 - display.height) / 2[1] = "ar"
	;(960 - display.height) / 2[2] = "en"
	self.titleSp:setSpriteFrame(SoraDGetImageNameByLang("frame_zjjl_chapter_%s.png", (960 - display.height) / 2))
	for i = 1, 5 do
		local single = self.nodeQuestSingle
		if 1 < i then
			single = self.nodeQuestSingle:clone()
			single:addTo(self.nodeQuestSingle:getParent())
		end
		single = include("newPlayerQuestSingle").new(single)
		single:setPositionY(self.Node_head:getPositionY() - 100 - (i - 1) * 85)
		single:setVisible(false)
		table.insert(self.tableQuestSinge, single)
	end
	self.nodePrize = SoraDGetChildByName(self, "Node_prize")
	self.labelPro = SoraDGetChildByName(self, "Text_pro")
	self.labelPrizeTitle = SoraDGetChildByName(self, "Text_prizeTitle")
	self.labelPrizeTitle:setString(i18n("common_text_3680"))
	self.leftLine:setPositionX(-self.labelPrizeTitle:getContentSize().width / 2 - 20)
	self.rightLine:setPositionX(self.labelPrizeTitle:getContentSize().width / 2 + 20)
	self.btnGetAll = SoraDGetChildByName(self, "Button_getAll")
	self.Image_btn = SoraDGetChildByName(self.btnGetAll, "Image_btn")
	self.Text_getAll = SoraDGetChildByName(self.btnGetAll, "Text_getAll")
	self.btnCastle = SoraDGetChildByName(self, "Button_castle")
	self.btnCastle:setTitleText(i18n("common_text_477"))
	SoraDAutoSizeButtonText(self.btnCastle)
	self.Node_items = SoraDGetChildByName(self, "Node_items")
	self.Button_show = SoraDGetChildByName(self, "Button_show")
	self.Button_show:addTouchEventListener(handler(self, self.btnRewardCallBack))
	for i = 1, 5 do
		local single = include("commonItemAward").new()
		single:setScale(0.75)
		single:setOwnView(self)
		single:setBaseScale(1.0)
		single:addTo(self.Node_items)
		single:setCascadeOpacityEnabled(true)
		table.insert(self.tablePrizeSinge, single)
	end
	self.labelWarning = SoraDGetChildByName(self, "Text_warning")
	if self.btnGetAll then
		self.btnGetAll:addTouchEventListener(handler(self, self.btnClickCallBack))
		self.btnCastle:addTouchEventListener(handler(self, self.btnJumpClickCallBack))
	end
	self.closeButton:addTouchEventListener(handler(self, self.closeSelf))
	self:initData()
end
function NewPlayerQuestView:onEnterPanel()
	self.centerNode:setOpacity(0)
	_UPVALUE1_ = nil
	;(nil)[1] = cca.delay(0.43333333333333335)
	;(nil)[2] = cca.fadeIn(0.16666666666666666)
	;(nil)[3] = cca.fadeIn(0.16666666666666666)
	;(nil)[4] = cca.fadeIn(0.16666666666666666)
	self.centerNode:runAction(cca.seq(nil))
	local effect_normal = SoraDCreatAnimation("xinshourenwu_zhangkai", nil, false)
	self.effect_normal = effect_normal
	effect_normal:setPosition(cc.p(0, 0))
	_UPVALUE1_ = cc.p(0, 0)
	cc.p(0, 0)[1] = cca.delay(0.43333333333333335)
	cc.p(0, 0)[2] = cca.callFunc(function()
		self.effect_normal = effect_normal
		effect_normal:setPosition(cc.p(0, 0))
		self.centerBg:addChild(effect_normal)
	end)
	cc.p(0, 0)[3] = cca.callFunc(function()
		self.effect_normal = effect_normal
		effect_normal:setPosition(cc.p(0, 0))
		self.centerBg:addChild(effect_normal)
	end)
	effect_normal:runAction(cca.seq(cc.p(0, 0)))
	self.centerBg:addChild(effect_normal)
	self.spine_bg = sp.SkeletonAnimation:create("spine/xsydzhangjie.skel", "spine/xsydzhangjie.atlas", 1)
	self.spine_bg:addTo(self.centerBg, -1)
	self.spine_bg:setAnimation(0, "animation01", false)
	local isFirst = false
	self.spine_bg:registerSpineEventHandler(function()
		if not isFirst then
			self.spine_bg:setAnimation(0, "animation02", true)
		end
	end, sp.EventType.ANIMATION_COMPLETE)
	self.spine_bg:setPositionY(-568)
end
function NewPlayerQuestView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_NEW_PLAYER_QUEST_UPDATE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_NEW_PLAYER_QUEST_GET", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_NEW_PLAYER_QUEST_CHAPTER", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function NewPlayerQuestView:judgeClose(target, data)
	if type(data.activityID) == "number" then
		_UPVALUE1_ = type(data.activityID)
		type(data.activityID)[1] = data.activityID
		if type(data.activityID) then
			goto lbl_12
		end
	end
	local activityID = data.activityID
	::lbl_12::
	if activityID and next(activityID) then
		for k, v in pairs(activityID) do
			if v == gActivityTimeActivityID.EXOTIC_PAVILION_ACTIVITY then
				self:initData()
			end
		end
	end
end
function NewPlayerQuestView:initData()
	self.curChapterID = newPlayerTaskCtrl:getCurChapterID()
	print("self.curChapterID =  ", self.curChapterID)
	self.labelTitle:setString(newPlayerTaskRead.getTitleByCID(self.curChapterID))
	self.labelTaskTitle = SoraDGetChildByName(self, "Text_taskTitle")
	self.labelTaskTitle:setString(newPlayerTaskRead.getNameByCID(self.curChapterID))
	self.leftLineTitle:setPositionX(-self.labelTaskTitle:getContentSize().width / 2 - 20)
	self.rightLineTitle:setPositionX(self.labelTaskTitle:getContentSize().width / 2 + 20)
	self.labelNotice:setString(newPlayerTaskRead.getDesByCID(self.curChapterID))
	if self.curChapterID == 0 then
	else
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local castleLv = newPlayerTaskRead.getCastleLevelByChapterID(self.curChapterID)
		local curCastleLv = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
		if castleLv <= curCastleLv then
			self.questData = newPlayerTaskRead.getTaskIDByChapterID(self.curChapterID)
			self:updatePro()
		else
			self.questData, newPlayerTaskCtrl = self.updatePro, self.updatePro
			newPlayerTaskCtrl = newPlayerTaskRead.getDesByCID(self.curChapterID)
			newPlayerTaskRead.getDesByCID(self.curChapterID).name = newPlayerTaskRead.getTitleByCID(self.curChapterID)
			newPlayerTaskRead.getDesByCID(self.curChapterID).lv = castleLv
			self.labelWarning:setString(i18n("common_text_3128", newPlayerTaskRead.getDesByCID(self.curChapterID)))
		end
		self:updateQuestList()
		self:updateChapter(self.curChapterID > 0 and castleLv <= curCastleLv)
		if self.curChapterID == 4103100 then
			local heroCtrl = SoraDGetCtrl("heroCtrl")
			heroCtrl:updateGuideHeroUnlock(2)
		end
	end
end
function NewPlayerQuestView:updatePro()
	self.isAllFinished = true
	local data = newPlayerTaskCtrl:getTaskInfo()
	local maxCount = 0
	local curCount = 0
	for k, v in pairs(data) do
		if not self:isForgeinPvilionTaskAndHide(tonumber(k)) then
			maxCount = maxCount + 1
			if v.finishStatus then
				curCount = curCount + 1
			end
			if not v.receiveStatus then
				self.isAllFinished = false
			end
		end
	end
	newPlayerTaskCtrl = nil
	;(nil).count = curCount
	;(nil).total = maxCount
	self.labelPro:setString(i18n("common_text_3684", nil))
end
function NewPlayerQuestView:isForgeinPvilionTaskAndHide(taskId)
	if taskId == 4103305 and not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.EXOTIC_PAVILION_ACTIVITY) then
		return true
	end
	return false
end
function NewPlayerQuestView:updateQuestList()
	for k, v in pairs(self.questData) do
		if self:isForgeinPvilionTaskAndHide(v) then
			table.remove(self.questData, k)
			break
		end
	end
	for i, v in ipairs(self.tableQuestSinge) do
		if self.questData[i] then
			v:initData(self.questData[i])
			v:setVisible(true)
		else
			v:setVisible(false)
		end
	end
end
function NewPlayerQuestView:updateChapter(isUnlock)
	self.Node_bottom:setVisible(isUnlock)
	self.labelWarning:setVisible(not isUnlock)
	self.btnCastle:setVisible(not isUnlock)
	if isUnlock then
		local canGetAll = newPlayerTaskCtrl:isChapterRewardCanReceive()
		self.btnGetAll:setTouchEnabled(canGetAll)
		SoraDSetNodeGray(self.Image_btn, not canGetAll)
		self.Text_getAll:setString(canGetAll and i18n("common_text_3681") or i18n("common_text_2139"))
		self:updatePrize()
	else
	end
end
function NewPlayerQuestView:updatePrize()
	local prizeData = newPlayerTaskRead.getRewardByChapterID(self.curChapterID)
	for i, v in ipairs(self.tablePrizeSinge) do
		if prizeData[i] then
			v:setVisible(true)
			v:initData(prizeData[i].itemID, prizeData[i].itemCount)
		else
			v:setVisible(false)
		end
	end
	SoraDautoSortPos(self.Node_items, 5, 1, cc.size(80, 80), SoraDFIsRA())
end
function NewPlayerQuestView:btnJumpClickCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).bid = BUILDID.CASTLE
		;(nil).lv = newPlayerTaskRead.getCastleLevelByChapterID(self.curChapterID)
		gModuleMgr.sharedMgr("mildGuideManager"):starToUpgrade(nil)
		SoraDRemoveAllPanelFromManager()
	end
end
function NewPlayerQuestView:btnRewardCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local prizeData = newPlayerTaskRead.getAllChapterReward()
		local curIdx = 1
		for k, v in ipairs(prizeData) do
			if v.chapterID == self.curChapterID then
				curIdx = k
			end
			_UPVALUE2_ = v.chapterID
			v.rank, v.chapterID[1] = v.chapterID, k
			v.rank, v.chapterID[2] = v.chapterID, k
		end
		local panel = SoraDCreatePanel("newPlayerQuestAwardView")
		panel:setTitle(i18n("guide_text_169"))
		_ENV = i18n("guide_text_169")
		i18n("guide_text_169").fontSize = 18
		i18n("guide_text_169").chapter = true
		i18n("guide_text_169").curIdx = curIdx
		panel:initData(prizeData, i18n("guide_text_169"))
		panel:show()
	end
end
function NewPlayerQuestView:btnClickCallBack(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).curChapterID = self.curChapterID
		;(nil).isOtherReward = not self.isAllFinished
		gModuleMgr.sharedMgr("mildGuideManager"):setVariate("newPlayerQuestPrizeView", nil)
		newPlayerTaskCtrl:sendReceiveChapterReward()
		self:removeFromParent()
	end
end
function NewPlayerQuestView:closeSelf(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:closePanel()
	end
end
function NewPlayerQuestView:onExitPanel()
	print("newPlayerTaskCtrl:getCurChapterID()", newPlayerTaskCtrl:getCurChapterID())
	if newPlayerTaskCtrl:getCurChapterID() > 4103000 then
		print("NewPlayerQuestView:onExitPanel")
		SoraDRemovePanelFromManager(self)
		_ENV = self
		self.msg = "MESSAGE_MAIN_AGREEMENT_BOX"
		SoraDSendMessage(self)
	end
	local remainsTeamCtrl = gametop.playertop_:getModule("remainsTeamCtrl")
	if remainsTeamCtrl:isHasInvitedInfo() then
		_ENV = remainsTeamCtrl
		remainsTeamCtrl.msg = "MESSAGE_SERVER_REMAINS_TEAM_INVITED_INFO"
		SoraDSendMessage(remainsTeamCtrl)
	end
end
function NewPlayerQuestView:endShow()
	print("NewPlayerQuestView:endShow-----------------")
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	local moudle = mildGuideManager:getVariate(self.__cname, "gGuideModule")
	dump(moudle)
	mildGuideManager:starMildByNewPlayerQuestID(moudle)
end
function NewPlayerQuestView:gameGuide_getTarget(itemName, parameters)
	if itemName == "Button_get" then
		for i, v in ipairs(self.tableQuestSinge) do
			if v.qid == parameters.qData.qid then
				if parameters.qData.isFinished then
					if newPlayerTaskCtrl:isTaskFinish(v.qid) then
						return SoraDGetChildByName(v, itemName)
					else
						return nil
					end
				else
					return SoraDGetChildByName(v, itemName)
				end
			end
		end
	elseif itemName == "buildCastleLv2" then
		for i, v in ipairs(self.tableQuestSinge) do
			if v.qid == parameters.qid then
				if newPlayerTaskCtrl:isTaskFinish(v.qid) then
					return nil
				else
					return SoraDGetChildByName(v, "Button_get")
				end
			end
		end
	elseif itemName == "getCastleLv2" then
		for i, v in ipairs(self.tableQuestSinge) do
			if v.qid == parameters.qid then
				if newPlayerTaskCtrl:isTaskFinish(v.qid) then
					return SoraDGetChildByName(v, "Button_get")
				else
					return nil
				end
			end
		end
	end
	return SoraDGetChildByName(self, itemName)
end
function NewPlayerQuestView:starMildguideAfter()
	print("当新手引导结束，弹出第2章界面时")
	local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
	mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.TO_BUILD_CASTLE_LV2)
end
return NewPlayerQuestView
