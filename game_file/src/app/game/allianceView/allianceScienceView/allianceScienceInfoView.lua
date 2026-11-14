local AllianceScienceInfoView = class("allianceScienceInfoView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("allianceScienceInfoView")
	end
	return target
end)
function AllianceScienceInfoView:ctor()
	self.tableStar, _ENV, self.tableScienceData, _ENV, self.scaleActTarget = SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node")
	self.queue = nil
	self.timer = nil
	self.isLock = false
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.layerTouch = SoraDGetChildByName(self, "Panel_touch")
	self.nodePanelBg = SoraDGetChildByName(self, "Node_panelBg")
	self.nodeDes = SoraDGetChildByName(self, "Node_des")
	self.labelNotice = SoraDGetChildByName(self.nodeDes, "Text_notice")
	self.labelNotice:setString(i18n("common_text_281"))
	self.tableStar[1] = SoraDGetChildByName(self.nodeDes, "Sprite_star")
	self.labelCurPoint = SoraDGetChildByName(self.nodeDes, "Text_curPoint")
	self.labelCur = SoraDGetChildByName(self.nodeDes, "Text_cur")
	self.labelCur:setString(i18n("common_text_279"))
	self.labelCurValue = SoraDGetChildByName(self.nodeDes, "Text_curValue")
	self.labelNext = SoraDGetChildByName(self.nodeDes, "Text_next")
	self.labelNext:setString(i18n("common_text_280"))
	self.labelNextValue = SoraDGetChildByName(self.nodeDes, "Text_nextValue")
	self.labelDes = SoraDGetChildByName(self.nodeDes, "Text_des")
	self.spriteIcon = SoraDGetChildByName(self.nodeDes, "Sprite_icon")
	self.labelLv = SoraDGetChildByName(self.nodeDes, "Text_lv")
	self.nodeBar = SoraDGetChildByName(self.nodeDes, "Node_bar")
	self.imgArr = SoraDGetChildByName(self.nodeDes, "Image_arr")
	self.loadingBar = SoraDGetExtendChildFromCCSByName(self.nodeDes, "CCS_commonProgressBar_point")
	self.loadingBarChild = SoraDGetChildByName(self.nodeDes, "LoadingBar_progress")
	self.loadingBarChild:setScale9Enabled(true)
	self.loadingBarChild:setCapInsets(cc.rect(4, 0, 10, 24))
	self.nodeTime = SoraDGetChildByName(self, "Node_time")
	self.nodeRecommend = SoraDGetChildByName(self, "Node_recommend")
	self.btnCancelRecommend = SoraDGetChildByName(self, "Button_cancelRecommend")
	self.btnCancelRecommend:setTitleText(i18n("alliance_text_03"))
	self.btnRecommend = SoraDGetChildByName(self, "Button_recommend")
	self.btnRecommend:setTitleText(i18n("alliance_text_01"))
	SoraDAutoSizeButtonText(self.btnCancelRecommend, cc.size(210, 50))
	SoraDAutoSizeButtonText(self.btnRecommend, cc.size(210, 50))
	self.btnRecommend:addTouchEventListener(handler(self, self.onClick_Button_Recommend))
	self.btnCancelRecommend:addTouchEventListener(handler(self, self.onClick_Button_CancelRecommend))
	print(self.onClick_Button_CancelRecommend)
	print("xxx----")
	self.nodeBtn = SoraDGetChildByName(self, "Node_btn")
	self.labelTime = SoraDGetChildByName(self, "Text_time")
	self.spriteTimeBg = SoraDGetChildByName(self, "Panel_timeBg")
	self.tableBtn = SoraDGetChildsArrayByName(self.nodeBtn, "CCS_allianceScienceBtn_", 3, 1, true, true)
	for i, v in ipairs(self.tableBtn) do
		v:setDonateType(i)
		v:setHandle(handler(self, self.donateBtnCallBack))
	end
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_DONATE_SUCCESS", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_DONATE_CD_CLEAN_SUCCESS", handler(self, self.updateQueue))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_CONTRIBUTE_DOUBLE", handler(self, self.contributeEffect))
end
function AllianceScienceInfoView:updateData()
	local gametop = gModuleMgr.getObject("gametop")
	local allianceScience = gametop.playertop_:getModule("allianceScience")
	self.tableScienceData = allianceScience:getScienceData(self.tableScienceData.id)
	self:updateView()
	SoraDCloseLoading(self)
end
function AllianceScienceInfoView:initData(scienceData)
	self.tableScienceData = scienceData
	self:updateView()
end
function AllianceScienceInfoView:updateView()
	self:showPublic()
	if not self:showFull() then
		self:showDonate()
		self:updateQueue()
	end
end
function AllianceScienceInfoView:showDonate()
	local allianceltCtrl = include("allianceltCtrl")
	local needPoint = allianceltCtrl.getSciStarLvUpNeedPoint(self.tableScienceData.id, self.tableScienceData.lv, self.tableScienceData.star + 1)
	if needPoint then
		self.labelCurPoint:setString(string.formatnumberthousands(self.tableScienceData.point) .. "/" .. string.formatnumberthousands(needPoint))
		_ENV = string.formatnumberthousands(self.tableScienceData.point) .. "/" .. string.formatnumberthousands(needPoint)
		;(string.formatnumberthousands(self.tableScienceData.point) .. "/" .. string.formatnumberthousands(needPoint)).maxValue = needPoint
		;(string.formatnumberthousands(self.tableScienceData.point) .. "/" .. string.formatnumberthousands(needPoint)).curValue = self.tableScienceData.point
		self.loadingBar:setProgressDate(string.formatnumberthousands(self.tableScienceData.point) .. "/" .. string.formatnumberthousands(needPoint))
	end
end
function AllianceScienceInfoView:showPublic()
	local allianceDesRead = include("allianceDesRead")
	local allianceltCtrl = include("allianceltCtrl")
	for i, v in ipairs(self.tableBtn) do
		v:initData(self.tableScienceData)
	end
	self.spriteIcon:setSpriteFrame(allianceDesRead.getScienceIcon(self.tableScienceData.id))
	self.ccs_bg:setTitleName(allianceDesRead.getScienceName(self.tableScienceData.id))
	self.labelDes:setString(allianceDesRead.getScienceDes(self.tableScienceData.id))
	local curdtype, curvalue = allianceltCtrl.getScienceValue(self.tableScienceData.id, self.tableScienceData.lv)
	local nextdtype, nextvalue = allianceltCtrl.getScienceValue(self.tableScienceData.id, self.tableScienceData.lv + 1)
	if curdtype and curdtype == 1 then
		curvalue = tostring(curvalue * 100) .. "%"
	end
	if nextdtype and nextdtype == 1 then
		nextvalue = tostring(nextvalue * 100) .. "%"
	end
	_ENV = allianceDesRead.getScienceDes(self.tableScienceData.id)
	allianceDesRead.getScienceDes(self.tableScienceData.id).level = self.tableScienceData.lv
	self.labelLv:setString(i18n("common_text_420", allianceDesRead.getScienceDes(self.tableScienceData.id)))
	self.labelCurValue:setString(curvalue)
	self.labelNextValue:setString(nextvalue)
	local maxStar = allianceltCtrl.scienceAttr(self.tableScienceData.id, gAScienceInfo.MAXSTAR)
	self.tableStar[1]:setVisible(false)
	for i = 1, maxStar do
		if i == 1 then
			self.tableStar[i]:setVisible(true)
		elseif self.tableStar[i] == nil then
			local star = display.newSprite("#icon_star1_02.png", self.tableStar[1]:getPositionX() - SoraDFPosX((i - 1) * 65, 0), self.tableStar[1]:getPositionY())
			star:addTo(self.nodeDes)
			table.insert(self.tableStar, star)
		end
		self.tableStar[i]:removeAllChildren()
		if i <= self.tableScienceData.star then
			self.tableStar[i]:setSpriteFrame("icon_star1_01.png")
		else
			self.tableStar[i]:setSpriteFrame("icon_star1_02.png")
		end
	end
	if self.tableStar[self.tableScienceData.star + 1] then
		local starBg = self.tableStar[self.tableScienceData.star + 1]
		local star = self:starFlickEffect()
		self.imgArr:setVisible(true)
		self.imgArr:setPositionX(starBg:getPositionX())
		star:addTo(starBg)
		star:setPosition(cc.p(starBg:getContentSize().width / 2, starBg:getContentSize().height / 2))
	else
		for i, v in ipairs(self.tableStar) do
			self:starHightLightEffect(v)
		end
		self.imgArr:setVisible(false)
	end
end
function AllianceScienceInfoView:updateQueue()
	local gametop = gModuleMgr.getObject("gametop")
	local allianceScience = gametop.playertop_:getModule("allianceScience")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	self.isLock = memberMgr:getOwnMember():getProperty("donateLock") == 1
	self.queue = allianceScience:queryQueue(SCIENCE_DONATE_QUEUE)
	if self.queue then
		if self.isLock then
			self.labelTime:setColor(display.COLOR_RED)
		else
			self.labelTime:setColor(cc.c3b(105, 183, 232))
		end
		self.labelTime:setVisible(true)
		self.spriteTimeBg:setVisible(true)
		if self.timer == nil then
			self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
			self:openTimeUp()
		end
	else
		self.labelTime:setVisible(false)
		self.spriteTimeBg:setVisible(false)
		if self.timer then
			SoraDManagerRemoveTimer(self, self.timer)
			self.timer = nil
		end
	end
	SoraDCloseLoading(self)
end
function AllianceScienceInfoView:openTimeUp(dt)
	local leftTime = self.queue.timerNode.timer:getRemainTime()
	self.labelTime:setString(SoraDConvertSecondToString(leftTime))
	if leftTime <= 0 then
		self:updateQueue()
	end
end
function AllianceScienceInfoView:starFlickEffect(...)
	local star = display.newSprite("#Image_alliance_twinkleStar.png")
	_ENV, _ENV = nil, "#Image_alliance_twinkleStar.png"
	_ENV, ("#Image_alliance_twinkleStar.png")[1], (nil).plist = nil, nil, "et_alliance_twinkleStar_01.plist"
	;("#Image_alliance_twinkleStar.png")[2], (nil).plist = nil, "et_alliance_twinkleStar_02.plist"
	local param = "#Image_alliance_twinkleStar.png"
	local parNode = SoraDCreateEffectNode(param)
	parNode:setPosition(cc.p(star:getContentSize().width / 2, star:getContentSize().height / 2))
	parNode:addTo(star, 2)
	_UPVALUE3_ = parNode
	parNode[1] = cca.fadeOut(1)
	parNode[2] = cca.delay(0.2)
	parNode[3] = cca.fadeIn(1)
	parNode[4] = cca.delay(0.2)
	parNode[5] = cca.delay(0.2)
	local seq = transition.sequence(parNode)
	local action = cc.RepeatForever:create(seq)
	star:runAction(action)
	return star
end
function AllianceScienceInfoView:starHightLightEffect(star)
	_ENV, _ENV = nil, nil
	_ENV, (nil).plist = nil, "et_alliance_shiningStar_01.plist"
	;(nil).x = 1.2
	_ENV, (nil)[1], (nil).scale, (nil).y = nil, nil, nil, 1.2
	_ENV, (nil).plist = nil, "et_alliance_shiningStar_02.plist"
	;(nil).x = 0.996
	;(nil)[2], (nil).scale, (nil).y = nil, nil, 0.996
	local param
	local parNode = SoraDCreateEffectNode(param)
	parNode:setPosition(cc.p(star:getContentSize().width / 2, star:getContentSize().height / 2))
	parNode:addTo(star, 2)
end
function AllianceScienceInfoView:showFull()
	local allianceltCtrl = include("allianceltCtrl")
	local maxLv = allianceltCtrl.scienceAttr(self.tableScienceData.id, gAScienceInfo.MAXLV)
	local maxStar = allianceltCtrl.scienceAttr(self.tableScienceData.id, gAScienceInfo.MAXSTAR)
	local isFull = maxLv <= self.tableScienceData.lv or maxStar <= self.tableScienceData.star
	self.nodeBar:setVisible(not isFull)
	self.nodeBtn:setVisible(not isFull)
	self.labelTime:setVisible(not isFull)
	self.spriteTimeBg:setVisible(not isFull)
	self.labelNext:setVisible(maxLv > self.tableScienceData.lv)
	self.labelNextValue:setVisible(maxLv > self.tableScienceData.lv)
	for i, v in ipairs(self.tableStar) do
		if v:isVisible() then
			v:setVisible(maxLv > self.tableScienceData.lv)
		end
	end
	self.labelNotice:setVisible(isFull)
	local layerH = isFull and 30 or 340
	self.layerTouch:setContentSize(cc.size(560, 310 + layerH))
	self.nodePanelBg:setPositionY(self.layerTouch:getContentSize().height / 2)
	self.ccs_bg:setSize(cc.size(560, 310 + layerH))
	self.ccs_bg:setPositionY(-(310 + layerH) / 2)
	self.nodeDes:setPositionY(210 + layerH)
	if not isFull then
		self:updateRecommend()
	elseif maxLv <= self.tableScienceData.lv and not self.tableScienceData.isRecommended then
		self:hideRecommend()
	else
		self:updateRecommend()
	end
	return isFull
end
function AllianceScienceInfoView:hideRecommend()
	self.btnRecommend:setVisible(false)
	self.btnCancelRecommend:setVisible(false)
end
function AllianceScienceInfoView:updateRecommend()
	local gametop = gModuleMgr.getObject("gametop")
	local allianceScience = gametop.playertop_:getModule("allianceScience")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local member = memberMgr:getOwnMember()
	local rank = member:getProperty("rank")
	local isShowRecommend = false
	if rank >= gAllianceRank.R4 then
		isShowRecommend = true
	end
	if isShowRecommend then
		self.nodeRecommend:setVisible(true)
		if self.tableScienceData.isRecommended then
			self.btnCancelRecommend:setVisible(true)
			self.btnRecommend:setVisible(false)
		elseif #allianceScience:getRecommendList() < 2 then
			self.btnRecommend:setVisible(true)
			self.btnCancelRecommend:setVisible(false)
		else
			self.nodeRecommend:setVisible(false)
			return
		end
	else
		self.nodeRecommend:setVisible(false)
		return
	end
	local addedH = 70
	local bgSize = self.ccs_bg:getSize()
	self.ccs_bg:setSize(cc.size(560, bgSize.height + addedH))
	self.ccs_bg:setPositionY(self.ccs_bg:getPositionY() - addedH)
end
function AllianceScienceInfoView:speedUpCallBack(type)
	if type == MSGBOX_CALLBACK_SPEEDUP then
		local gametop = gModuleMgr.getObject("gametop")
		local allianceScience = gametop.playertop_:getModule("allianceScience")
		allianceScience:reqCleanDonateSciCD()
		SoraDShowLoading(self)
	end
end
function AllianceScienceInfoView:donateBtnCallBack(id, type)
	local gametop = gModuleMgr.getObject("gametop")
	local allianceScience = gametop.playertop_:getModule("allianceScience")
	local memberMgr = gametop.playertop_:getModule("memberMgr")
	local jointime = memberMgr:getOwnMember():getProperty("joinTime")
	local curtime = serviceFunctions.systemTime()
	local needtime = gConstValue.ALLIANCE_DONATE_NEE_JOIN_ALLIANCE_TIME
	if needtime > curtime - jointime then
		SoraDShowMsgTip(i18n("common_text_654"), nil, nil)
		return
	end
	if self.isLock and self.queue then
		_ENV = "common_text_656"
		;("common_text_656").speedUpName = i18n("common_text_655")
		;("common_text_656").isBySelf = false
		;("common_text_656").isAllianceTech = true
		local speedUpBox = SoraDShowSpeedUpBox(self.queue, handler(self, self.speedUpCallBack), i18n("common_text_656"), "common_text_656")
	elseif self.isLock == false then
		SoraDShowLoading(self)
		for i, v in ipairs(self.tableBtn) do
			v:btnStateChange(false, true)
		end
		local gametop = gModuleMgr.getObject("gametop")
		local allianceScience = gametop.playertop_:getModule("allianceScience")
		allianceScience:reqDonateSci(id, type)
	end
end
function AllianceScienceInfoView:contributeEffect(target, data)
	local effectUI = include("effectUI")
	local bType = data.bType
	effectUI.addAllianceScienceContributeEffect(self)
	effectUI.addAllianceScienceRunDoubleAnimation(self, bType)
end
function AllianceScienceInfoView:onClick_Button_Recommend(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("发起推荐请求:", self.tableScienceData.id)
		local gametop = gModuleMgr.getObject("gametop")
		local allianceScience = gametop.playertop_:getModule("allianceScience")
		allianceScience:reqAddRecommendSci(self.tableScienceData.id)
		self:closePanel()
	end
end
function AllianceScienceInfoView:onClick_Button_CancelRecommend(sender, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.moved then
	elseif event == ccui.TouchEventType.canceled then
	elseif event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("取消推荐: ", self.tableScienceData.id)
		local gametop = gModuleMgr.getObject("gametop")
		local allianceScience = gametop.playertop_:getModule("allianceScience")
		allianceScience:reqRemoveRecommendSci(self.tableScienceData.id)
		self:closePanel()
	end
end
return AllianceScienceInfoView
