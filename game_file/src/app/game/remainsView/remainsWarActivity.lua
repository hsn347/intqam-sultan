local gametop = gModuleMgr.getObject("gametop")
local remainsTeamCtrl = gametop.playertop_:getModule("remainsTeamCtrl")
local remainsWarRead = include("remainsWarRead")
local remainsWarltCtrl = include("remainsWarltCtrl")
local remainsWarUtil = include("remainsWarUtil")
local remainsWarActivity = class("remainsWarActivity", function(target)
	if target == nil then
		return SoraDCreateBasePanel("remainsWarActivity")
	end
	return target
end)
function remainsWarActivity:ctor()
	self.isHideCurrentSceneView = true
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("activityname_23"))
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClick))
	self.btnHelp:setVisible(IsArClient)
	self.txtTitle = SoraDGetChildByName(self, "Text_title")
	self.spScoreTitle = SoraDGetChildByName(self, "Sprite_score_title")
	if not IsArClient then
		self.txtScoreTitle = SoraDChangeDanToText(self.spScoreTitle)
	end
	self.nodeDanBg = SoraDGetChildByName(self, "Node_dan_bg")
	self.Panel_bar = SoraDGetChildByName(self, "Panel_bar")
	self.nodeCooling = SoraDGetExtendChildFromCCSByName(self, "CCS_timerLabelActivity_cooling")
	self.nodeFlag = SoraDGetChildByName(self, "Node_flag")
	self.txtSeasonTitle = SoraDGetChildByName(self, "Text_season_title")
	self.txtSeasonTime = SoraDGetChildByName(self, "Text_season_time")
	self.btn_quest = fguiHelper.createObject("CommonNew", "Button_question")
	self.btn_quest:setPosition(cc.p(self.txtSeasonTitle:getPositionX() + self.txtSeasonTitle:getContentSize().width / 2 + 5, -self.txtSeasonTitle:getPositionY() - 20))
	self.btn_quest:addTo(self.txtSeasonTitle:getParent(), 9)
	self.btn_quest:addClickListener(handler(self, self.btnQuestClick))
	self.txtMatchStatus = SoraDGetChildByName(self, "Text_match_status")
	self.txtMatchTips = SoraDGetChildByName(self, "Text_match_tips")
	self.txtMatchTips2 = SoraDGetChildByName(self, "Text_match_tips2")
	self.nodeMatchTime = SoraDGetChildByName(self, "Node_match_time")
	self.txtMatchTime = SoraDGetChildByName(self, "Text_match_time")
	self.txtMatchTime2 = SoraDGetChildByName(self, "Text_match_time2")
	self.txtMatchTime:setString(i18n("remains_text_03"))
	self.txtMatchTime2:setString(i18n("remains_text_132"))
	self.txtMatchTips2:setString(i18n("remains_text_133"))
	self.panelBg = SoraDGetChildByName(self, "Panel_Bg")
	self.btnAward = SoraDGetChildByName(self, "Button_award")
	self.txtAward = SoraDGetChildByName(self, "Text_award")
	self.btnRank = SoraDGetChildByName(self, "Button_rank")
	self.txtRank = SoraDGetChildByName(self, "Text_rank")
	self.btnShop = SoraDGetChildByName(self, "Button_shop")
	self.txtShop = SoraDGetChildByName(self, "Text_shop")
	self.txtAward:setString(i18n("common_text_1235"))
	self.txtRank:setString(i18n("common_text_851"))
	self.txtShop:setString(i18n("remains_btn_03"))
	self.nodeTeam = SoraDGetChildByName(self, "Node_team")
	self.nodeActivity = SoraDGetChildByName(self, "Node_activity")
	self.nodeTeamTips = SoraDGetChildByName(self, "Node_team_tips")
	self.txtTeamTips = SoraDGetChildByName(self, "Text_team_tips")
	SoraDSetTextWidthHeight(self.txtTeamTips, cc.size(600, 50))
	self.btnTeamCreate = SoraDGetChildByName(self, "Button_team_create")
	self.btnTeamCreate:setTitleText(i18n("remains_btn_02"))
	self.btnTeamAdd = SoraDGetChildByName(self, "Button_team_add")
	self.btnTeamAdd:setTitleText(i18n("remains_btn_01"))
	self.btnTeamView = SoraDGetChildByName(self, "Button_team_view")
	self.btnTeamView:setTitleText(i18n("remains_btn_16"))
	self.btnTeamInWar = SoraDGetChildByName(self, "Button_team_inwar")
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_activity")
	local sSize = self.scroll:getContentSize()
	self.scroll:setContentSize(cc.size(sSize.width, sSize.height - 50))
	self.scroll:setPositionY(self.scroll:getPositionY() - 50)
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	self.btnDan = SoraDGetChildByName(self, "Button_dan")
	self.btnDan:addTouchEventListener(handler(self, self.btnPanelBg))
	self.img_bar = SoraDGetChildByName(self, "Image_bar")
	self.img_bar:setColor(cc.c3b(50, 50, 50))
	self.img_bar:setOpacity(0)
	self.btnAward:addTouchEventListener(handler(self, self.onClick_btnAward))
	self.btnRank:addTouchEventListener(handler(self, self.onClick_btnRank))
	self.btnShop:addTouchEventListener(handler(self, self.onClick_btnShop))
	self.btnTeamCreate:addTouchEventListener(handler(self, self.onClick_btnTeamCreate))
	self.btnTeamAdd:addTouchEventListener(handler(self, self.onClick_btnTeamAdd))
	self.btnTeamView:addTouchEventListener(handler(self, self.onClick_btnTeamView))
	self.btnTeamInWar:addTouchEventListener(handler(self, self.onClick_btnTeamInWar))
	do
		local _, ret = _G.SoraDIsFileExistByFileName("frame_yjzz_dx.png")
		if ret then
			local imgBg = SoraDGetChildByName(self, "Top_Size_Image_bg")
			if imgBg then
				imgBg:setFillType(1)
			end
		end
	end
	self.isXianXia = remainsWarUtil.checkIsInRemainsXianXia()
	self.danID = nil
	self:adjustPos()
	self:initView()
	local _ENV, imgArray = self.initView, self.initView
	local ret = _G.SoraDIsFileExistByKey("xunzhang")
	if ret then
		_ENV = imgBg
		imgBg.name = "worldMap/xunzhang"
		table.insert(imgArray, imgBg)
	end
	self:loadImages(imgArray, function()
		self.hasHDRes = true
		self:updateDanImg()
	end)
end
function remainsWarActivity:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_MATCH_STATUS", handler(self, self.updateByMatchStatus))
	SoraDAddMessage(self, "MESSAGE_SERVER_REMAINS_WAR_SCORE_STATUS", handler(self, self.updateByScore))
	SoraDAddMessage(self, "MESSAGE_UI_TEAM_MY_INFO", handler(self, self.updateByTeamInfo))
end
function remainsWarActivity:adjustPos()
	local scrollSize = self.scroll:getContentSize()
	local panelContentSize = self.scroll:getInnerContainerSize()
	if scrollSize.height >= panelContentSize.height then
		local nodeActivityInfo = SoraDGetChildByName(self, "Node_acitvity_info")
		nodeActivityInfo:setPositionY(scrollSize.height)
	end
	local scrollHeight = scrollSize.height
	self.img_bar:setContentSize(cc.size(scrollHeight / 2, self.img_bar:getContentSize().height))
	self.bar_size = self.img_bar:getContentSize()
	local scrollPosY = self.scroll:getPositionY()
	self._upY = scrollPosY - self.bar_size.width / 2
	self._downY = scrollPosY + self.bar_size.width / 2 - scrollHeight
end
function remainsWarActivity:updateByTeamInfo()
	self:updateBtnStatus()
end
function remainsWarActivity:updateByMatchStatus()
	self:updateBtnStatus()
	self:updateMatchStatus()
end
function remainsWarActivity:updateByScore()
	self:updateScoreStatus()
end
function remainsWarActivity:initView()
	self.txtSeasonTitle:setString(remainsTeamCtrl:getActivitySeasonTitle())
	if self.isXianXia then
		self.txtSeasonTime:setVisible(false)
		local nodeFlag = SoraDGetChildByName(self, "Node_activity_1")
		nodeFlag:setPositionY(nodeFlag:getPositionY() - 20)
		self.panelBg:setVisible(true)
		self.txtMatchTips:setVisible(false)
		self.nodeMatchTime:setVisible(false)
		self.txtMatchTips2:setVisible(false)
	else
		self.txtSeasonTime:setString(remainsTeamCtrl:getActivitySeasonTime())
	end
	self:updateBtnStatus()
	self:updateScoreStatus()
	self:updateMatchStatus()
	self:checkReqMatchInfo()
end
function remainsWarActivity:checkReqMatchInfo()
	if remainsTeamCtrl:isWarMatchBegin() and remainsTeamCtrl:isHasTeam() and not remainsTeamCtrl:isGetMatchInfo() and remainsTeamCtrl:isTeamCanInWar() and not worldMapDefine.isInRemains() then
		remainsTeamCtrl:reqGetMatchInfo()
	end
end
function remainsWarActivity:judgeClose()
	if not _G.clientEventMgr.judgeIsOpen(gActivityTimeActivityID.RUINS_WAR) then
		self:removeFromParent()
	else
		self:updateByMatchStatus()
	end
end
function remainsWarActivity:updateScoreStatus()
	local danID = remainsTeamCtrl:getPlayerSegment() or 1
	local star = remainsTeamCtrl:getPlayerStar() or 1
	local rankScore = remainsTeamCtrl:getPlayerRankScore() or 0
	local danPoint = remainsWarltCtrl.getDanPoint(danID, star)
	local curScore = rankScore
	local beginScore = danPoint and danPoint.min or rankScore
	local endScore = danPoint and danPoint.max or rankScore + 1
	local expRotation = (curScore - beginScore) * 100 / (endScore - beginScore)
	self.Panel_bar:setContentSize(cc.size(568 * expRotation / 100, 92))
	self.txtTitle:setString(string.formatnumberthousands(curScore) .. "/" .. string.formatnumberthousands(endScore))
	if IsArClient then
		local strTitleName = remainsWarRead.getDanNameIcon(danID)
		self.spScoreTitle:setSpriteFrame(strTitleName)
	else
		local strTitle = remainsWarRead.getDanName(danID)
		self.txtScoreTitle:setString(strTitle)
		local color = remainsWarRead.getDanColor(danID)
		self.txtScoreTitle:setColor(color)
	end
	if self.danID ~= danID then
		self.danID = danID
		self:updateDanImg()
	end
end
function remainsWarActivity:updateDanImg()
	if self.danID then
		self.nodeDanBg:removeAllChildren()
		local resPath = "remainsWarxunzhang" .. self.danID
		local danNode
		if self.hasHDRes then
			danNode = SoraDCreatAnimation(resPath, nil, true)
		else
			danNode = SoraDCreateCSBNode(resPath)
		end
		if danNode then
			local node_content = SoraDGetChildByName(danNode, "Node_content")
			if node_content then
				local array = SoraDGetChildsArrayByName(node_content, "Sprite_additive_", 4, 1)
				_G.SoraDSetNodeArrayAdditive(array)
			end
			danNode:addTo(self.nodeDanBg)
			local startNode = SoraDGetRemainsWarStartNode(remainsTeamCtrl:getPlayerStar())
			startNode:addTo(self.nodeDanBg)
			startNode:setPosition(-15, 130)
		end
	end
end
function remainsWarActivity:updateMatchStatus()
	if remainsTeamCtrl:isWarPrepare() then
		self.txtMatchStatus:setVisible(true)
		self.txtMatchStatus:setString(i18n("remains_text_04"))
		self:updateTipsStatus(false)
		self.nodeCooling:setVisible(true)
		self.nodeTeamTips:setVisible(true)
		local warTime = remainsTeamCtrl:getWarStatusTime()
		if 0 <= warTime then
			self.nodeCooling:beginTime(warTime)
		end
	elseif remainsTeamCtrl:isWarMatchBegin() then
		self.txtMatchStatus:setVisible(true)
		if self.isXianXia then
			local num = remainsTeamCtrl:getWarMatchNum()
			if num <= 1 then
				self.txtMatchStatus:setString(i18n("remains_text_116"))
			else
				self.txtMatchStatus:setString(i18n("remains_text_203"))
			end
		else
			self.txtMatchStatus:setString(i18n("remains_text_05"))
		end
		self:updateTipsStatus(true)
		self.nodeTeamTips:setVisible(true)
		self.nodeCooling:setVisible(true)
		local warTime = remainsTeamCtrl:getWarStatusTime()
		if 0 <= warTime then
			self.nodeCooling:beginTime(warTime)
		end
	elseif remainsTeamCtrl:isWarBattle() then
		self.txtMatchStatus:setVisible(true)
		self.txtMatchStatus:setString(i18n("remains_text_118"))
		self:updateTipsStatus(false)
		self.nodeTeamTips:setVisible(true)
		self.nodeCooling:setVisible(true)
		local warTime = remainsTeamCtrl:getWarStatusTime()
		if 0 <= warTime then
			self.nodeCooling:beginTime(warTime)
		end
	elseif remainsTeamCtrl:isActiveOpen() then
		self.txtMatchStatus:setVisible(true)
		self.txtMatchStatus:setString(i18n("remains_text_119"))
		self:updateTipsStatus(false)
		self.nodeTeamTips:setVisible(false)
		self.nodeCooling:setVisible(true)
		local warTime = remainsTeamCtrl:getActivityStatusTime()
		if 0 <= warTime then
			self.nodeCooling:beginTime(warTime)
		end
	else
		self.nodeTeamTips:setVisible(false)
		self.nodeCooling:setVisible(false)
		self.txtMatchStatus:setVisible(false)
		self.panelBg:setVisible(false)
	end
end
function remainsWarActivity:updateTipsStatus(show)
	if not self.isXianXia then
		self.panelBg:setVisible(show)
		if show then
			local num = remainsTeamCtrl:getWarMatchNum()
			remainsTeamCtrl = nil
			;(nil).num = num
			self.txtMatchTips:setString(i18n("remains_text_06", nil))
			self.nodeMatchTime:setPositionY(-100)
		else
			self.nodeMatchTime:setPositionY(-20)
		end
	end
end
function remainsWarActivity:updateBtnStatus()
	_UPVALUE2_ = nil
	;(nil)[1] = self.btnTeamAdd
	;(nil)[2] = self.btnTeamCreate
	for i, btn in ipairs(nil) do
		btn:setTouchEnabled(true)
		btn:setBright(true)
		btn:setTitleColor(display.COLOR_WHITE)
	end
	self.btnTeamCreate:setTitleText(i18n("remains_btn_02"))
	self.btnTeamAdd:setTitleText(i18n("remains_btn_01"))
	if (remainsTeamCtrl:isWarMatchBegin() or remainsTeamCtrl:isTeamCanInWar()) and remainsTeamCtrl:isHasTeam() then
		self.nodeTeam:setVisible(true)
		self.nodeActivity:setVisible(false)
		if remainsTeamCtrl:isTeamCanInWar() then
			self.btnTeamInWar:setVisible(true)
			self.btnTeamView:setVisible(false)
			if worldMapDefine.isInRemains() then
				self.btnTeamInWar:setTitleText(i18n("common_text_3351"))
				self.btnTeamInWar:setBright(not self.isXianXia)
				self.btnTeamInWar:setTouchEnabled(not self.isXianXia)
			else
				self.btnTeamInWar:setTitleText(i18n("common_text_3318"))
			end
		else
			self.btnTeamInWar:setVisible(false)
			self.btnTeamView:setVisible(true)
		end
	elseif remainsTeamCtrl:isPlayerHasBattleTimes() and remainsTeamCtrl:isWarMatchBegin() then
		self.nodeTeam:setVisible(false)
		self.nodeActivity:setVisible(true)
		self.txtTeamTips:setVisible(true)
		self.txtTeamTips:setString(i18n("remains_text_07"))
		if self.isXianXia then
			local num = remainsTeamCtrl:getWarMatchNum()
			if num <= 1 then
				local allianceDesRead = include("allianceDesRead")
				if allianceDesRead.checkRank(gAllianceRank.R5) then
					self.btnTeamCreate:setTouchEnabled(true)
					self.btnTeamCreate:setBright(true)
					self.btnTeamAdd:setTouchEnabled(false)
					self.btnTeamAdd:setBright(false)
				else
					self.btnTeamCreate:setTouchEnabled(false)
					self.btnTeamCreate:setBright(false)
					self.btnTeamAdd:setTouchEnabled(true)
					self.btnTeamAdd:setBright(true)
				end
			else
				self.btnTeamAdd:setTouchEnabled(false)
				self.btnTeamAdd:setBright(false)
				self.btnTeamCreate:setTouchEnabled(false)
				self.btnTeamCreate:setBright(false)
			end
		else
			self.btnTeamAdd:setTouchEnabled(true)
			self.btnTeamCreate:setTouchEnabled(true)
			self.btnTeamAdd:setBright(true)
			self.btnTeamCreate:setBright(true)
		end
	else
		self.nodeTeam:setVisible(false)
		self.nodeActivity:setVisible(true)
		if remainsTeamCtrl:isPlayerHasBattleTimes() then
			self.txtTeamTips:setVisible(false)
		else
			self.txtTeamTips:setVisible(true)
			self.txtTeamTips:setString(i18n("remains_text_08"))
		end
		self.btnTeamAdd:setTouchEnabled(false)
		self.btnTeamCreate:setTouchEnabled(false)
		self.btnTeamAdd:setBright(false)
		self.btnTeamCreate:setBright(false)
	end
	if remainsTeamCtrl:checkSuspended() then
		_UPVALUE2_ = remainsTeamCtrl
		remainsTeamCtrl[1] = self.btnTeamAdd
		remainsTeamCtrl[2] = self.btnTeamCreate
		for i, btn in ipairs(remainsTeamCtrl) do
			btn:setTouchEnabled(false)
			btn:setBright(false)
			btn:setTitleText(i18n("remains_text_373"))
			btn:setTitleColor(display.COLOR_RED)
		end
	end
end
function remainsWarActivity:btnQuickClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
	end
end
function remainsWarActivity:btnHelpClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if not _G.IsArClient then
			userSDKManager.showSingleFAQ(gSDKDef.FAQSectionType.REMAIS_WAR_EN)
		else
			userSDKManager.showSingleFAQ(gSDKDef.FAQSectionType.REMAIS_WAR)
		end
	end
end
function remainsWarActivity:btnPanelBg(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("remainsWarSegmentInfo")
		panel:show()
	end
end
function remainsWarActivity:onClick_btnAward(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("remainsWarReward")
		panel:show()
	end
end
function remainsWarActivity:onClick_btnRank(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("remainsWarRankView")
		panel:show()
	end
end
function remainsWarActivity:onClick_btnShop(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local curLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
		if curLevel < _G.RW_SHOP_CONDITION.CITYLV then
			_ENV = nil
			;(nil).num = _G.RW_SHOP_CONDITION.CITYLV
			SoraDShowMsgTip(i18n("common_text_1795", nil))
		else
			local panel = SoraDCreatePanel("remainsShopView")
			panel:show()
		end
	end
end
function remainsWarActivity:onClick_btnTeamCreate(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local err = remainsWarUtil.checkTeamBase()
		if gErrDef.Err_None == err then
			local panel = SoraDCreatePanel("teamDispatchArmyView")
			panel:show()
			_ENV = nil
			panel:initCreateView(nil)
		else
			self:errHandle(err)
		end
	end
end
function remainsWarActivity:errHandle(err)
	if err == gErrDef.Err_None then
		return
	end
	if err == gErrDef.Err_RUINS_WAR_NOT_JOIN_ALLIANCE then
		SoraDShowMsgTip(i18n("common_text_583"))
	elseif err == gErrDef.Err_RUINS_WAR_HAS_MASS_QUEUE and worldMapDefine.isInRemains() then
		SoraDShowMsgTip(i18n("remains_text_76"))
	else
		local errType = remainsWarUtil.getErrType(err)
		if errType ~= remainsWarUtil.errType.NONE then
			remainsWarUtil.errShowTips(err)
		end
	end
end
function remainsWarActivity:onClick_btnTeamAdd(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local err = remainsWarUtil.checkTeamBase()
		if gErrDef.Err_None == err then
			local panel = SoraDCreatePanel("teamApplyListView")
			panel:show()
		else
			self:errHandle(err)
		end
	end
end
function remainsWarActivity:onClick_btnTeamView(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("myTeamView")
		panel:show()
	end
end
function remainsWarActivity:onClick_btnTeamInWar(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if worldMapDefine.isInRemains() then
			local err = remainsWarUtil.checkQutiBattleField()
			if gErrDef.Err_None == err then
				local showMsg = i18n("remains_text_75")
				SoraDShowMsgBox(showMsg, i18n("common_text_204"), i18n("common_text_185"), function(callType)
					if callType == MSGBOX_CALLBACK_YES then
						remainsTeamCtrl:reqQuitBattlefield()
						SoraDShowLoading(self, nil, nil, nil, 5)
					end
				end)
			else
				self:errHandle(err)
			end
		elseif remainsTeamCtrl:isTeamCanInWar() then
			local err = remainsWarUtil.checkEnterBattleField()
			if gErrDef.Err_None == err then
				remainsTeamCtrl:reqEnterBattlefield()
				SoraDShowLoading(self, cc.size(150, 150), nil, nil, 5)
			else
				self:errHandle(err)
			end
		end
	end
end
function remainsWarActivity:showGreenFlag(...)
	local filePath = "3d/heroFlag/hero_flag.c3b"
	if _G.SoraDIsFileExistByFileName(filePath) then
		local card = cc.Sprite3D:create(filePath)
		_ENV = nil
		;(nil).x = 0
		;(nil).y = -440
		;(nil).z = 0
		card:setPosition3D(nil)
		card:setScale(0.8)
		card:addTo(self.nodeFlag)
		local animation = cc.Animation3D:create(filePath)
		if nil ~= animation then
			local animate1 = cc.Animate3D:create(animation)
			local animate2 = cc.Animate3D:createWithFrames(animation, 165, 359)
			_UPVALUE8_ = animation
			animation[1] = animate1
			animation[2] = animate2
			animation[3] = animate2
			animation[4] = animate2
			animation[5] = animate2
			animation[6] = animate2
			animation[7] = animate2
			animation[8] = animate2
			local mySeq = cca.seq(animation)
			card:runAction(mySeq)
		end
	end
end
function remainsWarActivity:scrollEventCallBack(target, event)
	local move = function()
		self.img_bar:setOpacity(255)
		self.img_bar:setContentSize(cc.size(self.bar_size.width, self.bar_size.height))
		local inner = self.scroll:getInnerContainer()
		local scrollHeight = inner:getContentSize().height
		local posY = inner:getPositionY()
		self.img_bar:setAnchorPoint(cc.p(0.5, 0))
		local _barLen = math.abs(self._upY - self._downY)
		local _topY = scrollHeight - self.scroll:getContentSize().height
		local _offsetY = -_barLen / _topY * posY + self._downY
		if _offsetY > self._upY then
			_offsetY = self._upY + self.bar_size.width / 2
			self.img_bar:setAnchorPoint(cc.p(0, 0))
			local percent = math.max(1 - math.abs(_topY + posY) / _barLen, 0.05)
			self.img_bar:setContentSize(cc.size(self.bar_size.width * percent, self.bar_size.height))
		elseif _offsetY < self._downY then
			_offsetY = self._downY - self.bar_size.width / 2
			self.img_bar:setAnchorPoint(cc.p(1, 0))
			local percent = math.max(1 - math.abs(posY) / _barLen, 0.05)
			self.img_bar:setContentSize(cc.size(self.bar_size.width * percent, self.bar_size.height))
		end
		self.img_bar:setPositionY(_offsetY)
		self.img_bar:runAction(cca.fadeOut(0.5))
	end
	if event == ccui.ScrollviewEventType.containerMoved then
		move()
	elseif event == ccui.ScrollviewEventType.scrollingEnd and self.img_bar:getOpacity() == 0 then
		self.img_bar:setOpacity(255)
		self.img_bar:setContentSize(cc.size(self.bar_size.width, self.bar_size.height))
		self.img_bar:runAction(cca.fadeOut(0.5))
	end
end
function remainsWarActivity:btnQuestClick()
	SoraDPlaySound()
	uiManager:show("remainsGroupPop")
end
return remainsWarActivity
