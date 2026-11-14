local newKingTrailCtrl = SoraDGetCtrl("newKingTrailCtrl")
local newKingTrailRead = include("newKingTrailRead")
local newKingTrailRankView = class("newKingTrailRankView", function(target)
	return target or SoraDCreateBasePanel("newKingTrailRankView")
end)
function newKingTrailRankView:ctor()
	_UPVALUE3_ = nil
	self.sessionTabTbl, _ENV, self.ocxNum, (nil)[1] = nil, nil, nil, "icon_ranking_1.png"
	self.sessionTabTbl, _ENV, self.ocxNum, (nil)[2] = nil, nil, nil, "icon_ranking_2.png"
	self.sessionTabTbl, _ENV, self.ocxNum, (nil)[3] = nil, nil, nil, "icon_ranking_3.png"
	self.selectDay = 1
	self.titleNode = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle")
	self.titleNode:setTitle(i18n("king_tri_name_01"))
	self.sessionNode = SoraDGetChildByName(self, "Node_Session")
	self.sessionSingle = SoraDGetChildByName(self, "Node_SessionSingle")
	self.textTotalTip = SoraDGetChildByName(self, "Text_TotalRankTips")
	self.textTotalTip:setString(i18n("king_tri_text_12"))
	SoraDSetTextWidthHeight(self.textTotalTip, cc.size(630, 33))
	self.imageInfo = SoraDGetChildByName(self, "Image_info")
	self.imageInfoHeight = self.imageInfo:getPositionY()
	self.scroll = SoraDGetChildByName(self, "ScrollView_rank")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("commonRankingSingle")
	self.txtMsg = SoraDGetChildByName(self, "text_no_rank_tip")
	self.nodeMyLord = SoraDGetChildByName(self, "Node_Lord")
	self.imgMyLord = SoraDGetChildByName(self.nodeMyLord, "Image_myHead")
	self.txtMyInt = SoraDGetChildByName(self.nodeMyLord, "Text_myNum")
	self.txtMyRank = SoraDGetChildByName(self.nodeMyLord, "Text_myRank")
	self.spMyRank = SoraDGetChildByName(self.nodeMyLord, "Sprite_myRank")
	self.Text_myName = SoraDGetChildByName(self.nodeMyLord, "Text_myName")
	self.btnJumpToSelf = SoraDGetChildByName(self, "Button_jump")
	self.btnJumpToSelf:addTouchEventListener(handler(self, self.btnJumpClickCallBack))
	self.textScoreTitle = SoraDGetChildByName(self, "Text_score")
	self.textNameTitle = SoraDGetChildByName(self, "Text_name")
	self.textScoreTitle:setString(i18n("common_text_1764"))
	self.textScoreTitle:setPositionX(SoraDFIsRA() and 125 or 525)
	self.textNameTitle:setString(i18n("common_text_264"))
	self.textNameTitle:setPositionX(SoraDFIsRA() and 450 or 200)
	self.nowDay = newKingTrailCtrl:getNowStage()
	self.selectDay = self.nowDay == 6 and 5 or self.nowDay
	_ENV, self.btnTab = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn_Rank"), SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn_Rank")
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn_Rank").tabNum = 2
	_ENV, _ENV, SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn_Rank").defaultClick = "Top_CCS_commonTabBtn_Rank", self, 1
	;("Top_CCS_commonTabBtn_Rank").title = i18n("common_text_626")
	_ENV, self[1], ("Top_CCS_commonTabBtn_Rank").handle = "Top_CCS_commonTabBtn_Rank", "Top_CCS_commonTabBtn_Rank", handler(self, self.refreshScroll)
	;("Top_CCS_commonTabBtn_Rank").title = i18n("common_text_627")
	SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn_Rank").tabsetArray, self[2], ("Top_CCS_commonTabBtn_Rank").handle = self, "Top_CCS_commonTabBtn_Rank", handler(self, self.refreshScroll)
	local data = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonTabBtn_Rank")
	self.btnTab:initView(data)
	self:initSessionTab()
end
function newKingTrailRankView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_NEWKINGTRAIL_REFRESH", handler(self, self.updataScrollData))
end
function newKingTrailRankView:initSessionTab()
	self.sessionInfo = newKingTrailRead.getStageConfig()
	newKingTrailRead = nil
	;(nil).stageType = self.selectDay
	newKingTrailCtrl:sendReqStageRank(nil)
	SoraDShowLoading(self)
	local nums = table.nums(self.sessionInfo)
	for i = 1, nums do
		local newKingTrailRead, tmp
		local single = self.sessionSingle:clone()
		single:addTo(self.sessionNode, i, self.sessionInfo[i].type)
		single:setPositionY(-100)
		tmp.itemNode = single
		tmp.name = self.sessionInfo[i].name
		tmp.describe = self.sessionInfo[i].describe
		tmp.icon = self.sessionInfo[i].icon
		tmp.showProgressBg = i ~= nums
		tmp.isUnlock = i <= self.nowDay
		tmp.type = self.sessionInfo[i].type
		local button = SoraDGetChildByName(single, "Button_Item", true)
		button:setTag(i)
		button:addTouchEventListener(handler(self, self.btnClickSessionTab))
		if i < self.nowDay then
			tmp.stageStatus = ACTIVITY_STATE.FINISH
		elseif self.nowDay == i then
			tmp.stageStatus = ACTIVITY_STATE.ACTIVE
		else
			tmp.stageStatus = ACTIVITY_STATE.PREPARE
		end
		self:initSessionSingle(tmp, i)
		table.insert(self.sessionTabTbl, tmp)
	end
	SoraDToCenter(self.sessionNode, 120, SoraDFIsRA())
end
function newKingTrailRankView:initSessionSingle(tmp, index)
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
function newKingTrailRankView:refreshScroll(tag, name)
	self.selectedRank = tag
	if tag == 2 then
		self.textTotalTip:setVisible(true)
		self.sessionNode:setVisible(false)
		self.imageInfo:setPositionY(self.imageInfoHeight + 115)
		self.scroll:setPositionY(self.imageInfoHeight + 55)
		self.scroll:setContentSize(self.scroll:getContentSize().width, 535 + self:getPanelOffsetHeight() - 960)
		newKingTrailCtrl:sendReqTotalStageRank()
	else
		self.textTotalTip:setVisible(false)
		self.sessionNode:setVisible(true)
		self.imageInfo:setPositionY(self.imageInfoHeight)
		self.scroll:setPositionY(self.imageInfoHeight - 55)
		self.scroll:setContentSize(self.scroll:getContentSize().width, 425 + self:getPanelOffsetHeight() - 960)
		newKingTrailCtrl = self.scroll:getContentSize().width
		self.scroll:getContentSize().width.stageType = self.selectDay
		newKingTrailCtrl:sendReqStageRank(self.scroll:getContentSize().width)
	end
end
function newKingTrailRankView:updataScrollData()
	SoraDCloseLoading(self)
	self.selfRankInfo = newKingTrailCtrl:getSelfRank(self.selectedRank)
	if not newKingTrailCtrl:getRank(self.selectedRank) then
		_ENV = newKingTrailCtrl:getRank(self.selectedRank)
	end
	self.rankInfo = newKingTrailCtrl:getRank(self.selectedRank)
	self.rank = self.selfRankInfo and self.selfRankInfo.rank or 0
	self:initMyRank()
	local _ENV, tmp = self.initMyRank, self.initMyRank
	for i, v in ipairs(self.rankInfo) do
		_ENV = nil
		;(nil).model = 1
		_ENV, (nil).nameShowType = nil, 1
		;(nil).uid = v.uid
		;(nil).iconID = v.imageId
		;(nil).player, (nil).avatar = nil, v.avatar
		if v.allianceAbbr then
			_ENV = nil
			;(nil).abbr = v.allianceAbbr
			;(nil).name = v.nickName
			if i18n("common_text_186", nil) then
				goto lbl_58
			end
		end
		::lbl_58::
		;(nil).lineOneName = v.nickName
		;(nil).rank = i
		;(nil).score = v.score
		local (nil).selfRank, data = self.rank, nil
		table.insert(tmp, data)
	end
	_ENV = nil
	;(nil).view = self
	;(nil).scroll = self.scroll
	self.scroll:updateScrollView(cc.size(640, 112), tmp, 1, nil)
end
local MAX_RANK = 100
function newKingTrailRankView:initMyRank()
	local switchNum = function(num)
		num = tonumber(num)
		if num <= RANK_TOP_SPECIAL then
			self.txtMyRank:setVisible(false)
			self.spMyRank:setVisible(true)
			self.spMyRank:setSpriteFrame(self.ocxNum[num], ccui.TextureResType.plistType)
		else
			self.spMyRank:setVisible(false)
			self.txtMyRank:setVisible(true)
			self.txtMyRank:setString(num)
		end
	end
	if self.rank > 0 then
		if self.rank <= MAX_RANK then
			self.nodeMyLord:setVisible(true)
			switchNum(self.rank)
			SoraDGetHeadFromManager(self.imgMyLord, self.selfRankInfo.imageId, self.selfRankInfo.avatar)
			if self.selfRankInfo.allianceAbbr then
				_ENV = nil
				;(nil).abbr = self.selfRankInfo.allianceAbbr
				;(nil).name = self.selfRankInfo.nickName
				if i18n("common_text_186", nil) then
					goto lbl_43
				end
			end
			::lbl_43::
			self.Text_myName:setString(self.selfRankInfo.nickName)
			self.txtMyInt:setString(string.formatnumberthousands(self.selfRankInfo.score))
			self.txtMsg:setString("")
		else
			self.nodeMyLord:setVisible(false)
			self.txtMsg:setString(i18n("common_text_4287"))
		end
	else
		self.nodeMyLord:setVisible(false)
		self.txtMsg:setString(i18n("common_text_827"))
	end
end
function newKingTrailRankView:btnClickSessionTab(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local sessionIndex = button:getTag()
		if sessionIndex <= self.nowDay then
			local lastIndex = self.selectDay
			self.selectDay = sessionIndex
			self:initSessionSingle(self.sessionTabTbl[lastIndex], lastIndex)
			self:initSessionSingle(self.sessionTabTbl[self.selectDay], self.selectDay)
			self.selectDay = sessionIndex
			SoraDShowLoading(self)
			_ENV = self.sessionTabTbl[self.selectDay]
			self.sessionTabTbl[self.selectDay].stageType = self.selectDay
			newKingTrailCtrl:sendReqStageRank(self.sessionTabTbl[self.selectDay])
		else
			SoraDShowMsgTip(i18n("king_tri_text_02"))
		end
	end
end
function newKingTrailRankView:btnJumpClickCallBack(button, EventType)
	if EventType == ccui.TouchEventType.ended then
		self:stopAllActions()
		SoraDPlaySound()
		self.ownPosY = self.scroll:getInnerContainerSize().height - 112 * self.rank - 0.5 * self.scroll:getContentSize().height
		local scrollPercent = 100 * (1 - self.ownPosY / (self.scroll:getInnerContainerSize().height - self.scroll:getContentSize().height))
		scrollPercent = math.min(100, math.max(0, scrollPercent))
		local scrollH = self.scroll:getContentSize().height
		if math.abs(self.ownPosY + self.scroll:getInnerContainer():getPositionY()) < 0.5 * scrollH then
			self.scroll:scrollToPercentVertical(scrollPercent, 0.2, true)
		else
			_UPVALUE2_ = 0.2
			;(0.2)[1] = cca.callFunc(function(...)
				if self.rank <= 100 and self.rank > 0 then
					self.scroll:scrollToPercentVertical(scrollPercent + 0.5, 0.2, false)
				end
			end)
			;(0.2)[2] = cca.delay(0.3)
			;(0.2)[3] = cca.callFunc(function(...)
				if self.rank <= 100 and self.rank > 0 then
					self.scroll:scrollToPercentVertical(scrollPercent, 0.1, true)
				end
			end)
			;(0.2)[4] = cca.callFunc(function(...)
				if self.rank <= 100 and self.rank > 0 then
					self.scroll:scrollToPercentVertical(scrollPercent, 0.1, true)
				end
			end)
			self:runAction(cca.seq(0.2))
		end
	end
end
return newKingTrailRankView
