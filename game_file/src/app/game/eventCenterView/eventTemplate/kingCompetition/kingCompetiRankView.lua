local kingCompetiRankView = class("kingCompetiRankView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("kingCompeRankingsView")
	end
	return target
end)
function kingCompetiRankView:ctor()
	self.tableSpare, _ENV, self.tableSingle, _ENV, self.tableData, _ENV, self.type = lordRankingsDef.alliancePower, lordRankingsDef.alliancePower, lordRankingsDef.alliancePower, lordRankingsDef.alliancePower, lordRankingsDef.alliancePower, lordRankingsDef.alliancePower, lordRankingsDef.alliancePower
	self.ownPosY = 0
	self.haveGetRankData = false
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_rank")
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.labelTime = SoraDGetChildByName(self, "Text_msg_time")
	self.labelTime = SoraDCreateTimerLabel(self, self.labelTime)
	self.labelTime:setVisible(false)
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.labelName:setString(i18n("common_text_264"))
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.textRank = SoraDGetChildByName(self, "Text_rank")
	self.textRank:setString(i18n("common_text_2193"))
	self.nodeBottom = SoraDGetChildByName(self, "Top_Node")
	SoraDGetChildByName(self.nodeBottom, "Image_18"):setFillType(1)
	self.imageLight = SoraDGetChildByName(self, "Image_1")
	self.imageTitle = SoraDGetChildByName(self, "Image_2")
	self.textTips = SoraDGetChildByName(self, "text_tips")
	self.textTips:setString(i18n("kindom_competition_text_11"))
	self.textMyRank = SoraDGetChildByName(self, "Text_myRank")
	self.textMyLordName = SoraDGetChildByName(self, "Text_myLordName")
	self.spriteBottomBg = SoraDGetChildByName(self, "bottomBg")
	self.textMyLordName:setVisible(false)
	self.leftFrame = SoraDGetChildByName(self, "frame_main_decoration_1")
	self.rightFrame = SoraDGetChildByName(self, "frame_main_decoration_1")
	self.textMyNum = SoraDGetChildByName(self, "Text_myNum")
	self.textMyName = SoraDGetChildByName(self, "Text_myName")
	self.textMyLordName = SoraDGetChildByName(self, "Text_myLordName")
	self.imageMyHead = SoraDGetChildByName(self, "Image_head")
	self.imageBottomBg = SoraDGetChildByName(self, "bottomBg")
	self.imageBottomBg_1 = SoraDGetChildByName(self, "bottomBg_1")
	self.imageMyHead:setVisible(false)
	self.spriteWar = SoraDGetChildByName(self, "Sprite_war")
	self.nodeFlag = SoraDGetChildByName(self, "Node_flag")
	self.spriteWar:setVisible(false)
	if SoraDFIsRA() then
		self.spriteWar:setPositionX(self.textMyNum:getPositionX() + self.textMyNum:getContentSize().width + 50)
	else
		self.spriteWar:setPositionX(self.textMyNum:getPositionX() - self.textMyNum:getContentSize().width - 50)
	end
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_rankings")
	self.scroll:setListenAllScrollingEnabled(true)
	self.scroll:addEventListener(handler(self, self.scrollEventCallBack))
	local height = self:getPanelOffsetHeight() - 410
	self.scroll:setContentSize(640, height)
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	self.btnHelp:addTouchEventListener(handler(self, self.btnHelpClickCallBack))
	self.imageBottomBg:addTouchEventListener(handler(self, self.btnJumpClickCallBack))
	self.imageBottomBg_1:addTouchEventListener(handler(self, self.btnJumpClickCallBack))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_RANKINGS_SUCCESS", handler(self, self.receiveRepeatRank))
end
function kingCompetiRankView:receiveRepeatRank(target, data)
	if self.haveGetRankData then
		return
	end
	self.haveGetRankData = true
	if data.rank then
		self.requestAgain = data.rank.bCanContinueGet or false
		self.requestIndex = data.rank.newStartIndex or 0
		if not self.isFirstTime then
			self.isFirstTime = true
			self.tableData = data.rank
			if 0 >= table.nums(self.tableData.data) then
				local text = ccui.Text:create(i18n("common_text_927"), "", 20)
				text:addTo(SoraDGetChildByName(self, "Image_bg"))
				text:setPosition(320, 400)
				return
			end
			self:addScrollView()
		else
			for i, v in ipairs(data.rank.data) do
				table.insert(self.tableData.data, v)
			end
			self:updateScrollSize()
		end
	end
	SoraDCloseLoading(self)
end
function kingCompetiRankView:initData(type)
	self.type = type
	self:flowerRankDifferences(type)
	local _ENV, tableTitle = self.flowerRankDifferences, self.flowerRankDifferences
	tableTitle[lordRankingsDef.lordPower] = i18n("common_text_820")
	tableTitle[lordRankingsDef.lordCastle] = i18n("common_text_822")
	tableTitle[lordRankingsDef.lordLevel] = i18n("common_text_823")
	self.nodeTitle:setTitle(tableTitle[self.type])
	if self.type == lordRankingsDef.lordPower then
		self.labelDes:setString(i18n("common_text_090"))
	elseif self.type == lordRankingsDef.lordCastle or self.type == lordRankingsDef.lordLevel then
		self.labelDes:setString(i18n("common_text_748"))
		self.labelDes:setPositionX(543)
	end
	SoraDShowLoading(self)
	local gametop = gModuleMgr.getObject("gametop")
	local rankingsCtrl = gametop.playertop_:getModule("rankingsCtrl")
	rankingsCtrl:getRankings(self.type)
end
function kingCompetiRankView:addScrollView()
	local msg = self.tableData.league
	local gametop = gModuleMgr.getObject("gametop")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local ownInfo = lordInfoCtrl:getLordInfo()
	local maxCount = RANK_ALLIANCE_MAX_SHOW or RANK_MAX_SHOW
	if (self.tableData.league <= 0 or maxCount < self.tableData.league) and self.tableData.league <= 0 then
		msg = i18n("common_text_827")
	end
	self.textMyRank:setString(msg)
	self:initMyData(self.type)
	local scrollInner = self.scroll:getInnerContainer()
	local scrollInnerNewH = math.max(115 * #self.tableData.data, self.scroll:getContentSize().height)
	local myRankIndex = self.tableData.league
	for i, v in ipairs(self.tableData.data) do
		local isOwnRank = v.uid == ownInfo.base.uid
		_ENV = nil
		_ENV, (nil).point = nil, nil
		;(nil).data = v
		;(nil).rank = i
		;(nil).type = self.type
		;(nil).data, (nil).isOwn = nil, isOwnRank
		;(nil).posY = scrollInnerNewH - 115 * (i - 1) - 0
		table.insert(self.tableSingle, nil)
		if isOwnRank then
			myRankIndex = i
		end
	end
	self.ownPosY = scrollInnerNewH - 115 * myRankIndex - 0.5 * self.scroll:getContentSize().height
	self.scroll:setInnerContainerSize(cc.size(640, scrollInnerNewH))
	self.scroll:jumpToTop()
	self:initRankingsList()
end
function kingCompetiRankView:updateScrollSize()
	local gametop = gModuleMgr.getObject("gametop")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local ownInfo = lordInfoCtrl:getLordInfo()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	local scrollInnerNewH = math.max(115 * #self.tableData.data, self.scroll:getContentSize().height)
	for i, v in ipairs(self.tableData.data) do
		local offset = scrollInnerNewH - (i - 1) * 115
		local single = self.tableSingle[i]
		if single and single.point then
			single.posY = offset
			single.point:setPositionY(offset)
		elseif single then
			single.posY = offset
		else
			local isOwnRank = v.uid == ownInfo.base.uid
			_ENV = nil
			_ENV, (nil).point = nil, nil
			;(nil).data = v
			;(nil).rank = i
			;(nil).type = self.type
			;(nil).data, (nil).isOwn = nil, isOwnRank
			;(nil).posY = offset
			table.insert(self.tableSingle, nil)
			if isOwnRank then
				self.ownPosY = scrollInnerNewH - 115 * i - 0.5 * self.scroll:getContentSize().height
			end
		end
	end
	scrollInnerNewH = scrollInnerNewH + 10
	offsetY = offsetY - (scrollInnerNewH - scrollInner:getContentSize().height)
	self.scroll:setInnerContainerSize(cc.size(640, scrollInnerNewH))
	scrollInner:setPositionY(offsetY)
	self:initRankingsList()
end
function kingCompetiRankView:initRankingsList()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = -scrollInner:getPositionY()
	local scrollH = self.scroll:getContentSize().height
	_ENV = self.scroll
	self.scroll.beginY = math.max(0, offsetY - 0.5 * scrollH)
	local self.scroll.endY, tableShowH = offsetY + 1.5 * scrollH, self.scroll
	for i, v in ipairs(self.tableSingle) do
		if v.point then
			if v.posY < tableShowH.beginY or v.posY > tableShowH.endY then
				v.point:setVisible(false)
				table.insert(self.tableSpare, v.point)
				v.point = nil
			end
		elseif tableShowH.beginY <= v.posY and tableShowH.endY >= v.posY then
			local single
			if 0 < #self.tableSpare then
				single = table.remove(self.tableSpare)
				single:setVisible(true)
			else
				single = SoraDCreatePanel("rankingsScrollSingle")
				single:setScroll(self.scroll)
				single:addTo(self.scroll)
			end
			single:initData(v.data)
			single.spriteIndex:setPosition(70, 60)
			single.labelIndex:setPosition(70, 60)
			single.imgHead:setPositionX(170)
			single.labelName:setPositionX(220)
			single.labelAlliance:setPositionX(220)
			single:setPosition(cc.p(320, v.posY))
			v.point = single
		end
	end
end
function kingCompetiRankView:scrollEventCallBack(target, event)
	if event == ccui.ScrollviewEventType.containerMoved then
		self:initRankingsList()
	elseif event == ccui.ScrollviewEventType.bounceBottom then
		self:requestRankDataAgain()
	end
end
function kingCompetiRankView:requestRankDataAgain()
	if self.requestAgain and self.requestIndex ~= 0 then
		self.haveGetRankData = false
		local gametop = gModuleMgr.getObject("gametop")
		local rankingsCtrl = gametop.playertop_:getModule("rankingsCtrl")
		rankingsCtrl:getRankings(self.type, self.requestIndex)
		SoraDShowLoading(self)
	end
end
function kingCompetiRankView:btnJumpClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		self:stopAllActions()
		SoraDPlaySound()
		local scrollPercent = 100 * (1 - self.ownPosY / (self.scroll:getInnerContainerSize().height - self.scroll:getContentSize().height))
		scrollPercent = math.min(100, math.max(0, scrollPercent))
		local scrollH = self.scroll:getContentSize().height
		if math.abs(self.ownPosY + self.scroll:getInnerContainer():getPositionY()) < 0.5 * scrollH then
			self.scroll:scrollToPercentVertical(scrollPercent, 0.2, true)
		else
			_UPVALUE2_ = 0.2
			;(0.2)[1] = cca.callFunc(function(...)
				if self.tableData.league <= 150 and self.tableData.league > 0 then
					self.scroll:scrollToPercentVertical(scrollPercent + 0.5, 0.2, false)
				end
			end)
			;(0.2)[2] = cca.delay(0.3)
			;(0.2)[3] = cca.callFunc(function(...)
				if self.tableData.league <= 150 and self.tableData.league > 0 then
					self.scroll:scrollToPercentVertical(scrollPercent, 0.1, true)
				end
			end)
			;(0.2)[4] = cca.callFunc(function(...)
				if self.tableData.league <= 150 and self.tableData.league > 0 then
					self.scroll:scrollToPercentVertical(scrollPercent, 0.1, true)
				end
			end)
			self:runAction(cca.seq(0.2))
		end
	elseif type == ccui.TouchEventType.began then
	elseif type == ccui.TouchEventType.canceled then
	end
end
function kingCompetiRankView:btnHelpClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.KING_COMPETITION)
	end
end
function kingCompetiRankView:flowerRankDifferences(type)
	if type == lordRankingsDef.lordCastle then
		self.imageLight:loadTexture("bg_xinwangguozhengbasai11@2x.png", ccui.TextureResType.plistType)
	elseif type == lordRankingsDef.lordLevel then
		self.imageLight:loadTexture("bg_xinwangguozhengbasai10@2x.png", ccui.TextureResType.plistType)
	elseif type == lordRankingsDef.lordPower then
		self.imageLight:loadTexture("bg_xinwangguozhengbasai12@2x.png", ccui.TextureResType.plistType)
	end
	self.imageLight:setFlippedY(false)
end
function kingCompetiRankView:initMyData(type)
	local rankType = type
	local gametop = gModuleMgr.getObject("gametop")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local ownInfo = lordInfoCtrl:getLordInfo()
	local abbr = ownInfo.abbr
	if abbr and abbr ~= "" then
		self.textMyName:setString(string.format("(%s)", abbr) .. i18n(ownInfo.base.nickName))
	else
		self.textMyName:setString(ownInfo.base.nickName)
	end
	self.imageMyHead:setVisible(true)
	self.textMyName:setPositionY(50)
	self.textMyLordName:setVisible(false)
	SoraDGetHeadFromManager(self.imageMyHead, ownInfo.base.imageId, ownInfo.base.avatar)
	if rankType == lordRankingsDef.lordCastle then
		local buildLogic = include("buildLogic")
		local warLv = buildLogic.transformBuildLvToWarLv(self.tableData.ranking)
		self.spriteWar:setVisible(warLv >= CASTLE_MIN_WARLV)
		self.spriteWar:setSpriteFrame("icon_main_honourgrade.png")
		self.spriteWar:setScale(0.8)
		if 0 <= warLv then
			if warLv == 0 then
				warLv = CASTLE_MAXLV_NOWAR
			end
			self.textMyNum:setString(string.formatnumberthousands(warLv))
		else
			self.textMyNum:setString(string.formatnumberthousands(self.tableData.ranking))
		end
	else
		self.spriteWar:setVisible(false)
		self.textMyNum:setString(string.formatnumberthousands(self.tableData.ranking))
	end
	if SoraDFIsRA() then
		self.spriteWar:setPositionX(self.textMyNum:getPositionX() + self.textMyNum:getContentSize().width)
	elseif rankType == lordRankingsDef.lordCastle then
		self.spriteWar:setPositionX(self.textMyNum:getPositionX() - 10)
	else
		self.spriteWar:setPositionX(self.textMyNum:getPositionX() - self.textMyNum:getContentSize().width)
	end
end
function kingCompetiRankView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEW_SERVER_RANK_MATCH) then
		self:removeFromParent()
		return
	end
end
return kingCompetiRankView
