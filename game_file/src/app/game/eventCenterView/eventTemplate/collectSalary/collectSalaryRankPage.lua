local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local collectSalaryRead = include("collectSalaryRead")
local allianceDesRead = include("allianceDesRead")
local collectSalaryCtrl = SoraDGetCtrl("collectSalaryCtrl")
local collectSalaryRankPage = class("collectSalaryRankPage", function(target)
	return target or SoraDCreateBasePanel("collectSalaryRankPage")
end)
function collectSalaryRankPage:ctor()
	self:setNodeEventEnabled(true)
	_UPVALUE3_, self.awardArray, _ENV, self.rank = self.setNodeEventEnabled, self.setNodeEventEnabled, self.setNodeEventEnabled, 0
	self.ocxNum, self.setNodeEventEnabled[1] = self.setNodeEventEnabled, "icon_ranking_1.png"
	self.ocxNum, self.setNodeEventEnabled[2] = self.setNodeEventEnabled, "icon_ranking_2.png"
	self.ocxNum, self.setNodeEventEnabled[3] = self.setNodeEventEnabled, "icon_ranking_3.png"
	SoraDDeviceFitOffset(self)
	self.nodeTop = SoraDGetChildByName(self, "Top_Node")
	self.textTitle = SoraDGetChildByName(self, "Text_Title")
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
	self.btnAward = SoraDGetChildByName(self, "btn_moreReward")
	self.btnAward:setTitleText(i18n("Endless_trial_text_13"))
	SoraDAutoSizeButtonText(self.btnAward, cc.size(100, 40))
	self.btnAward:addTouchEventListener(handler(self, self.btnClickRankAward))
	self.Text_noRecrod = SoraDGetChildByName(self, "Text_noRecrod")
	self.Text_noRecrod:setString(i18n("god_beast_text_16"))
	self.btnJoinAlliance = SoraDGetChildByName(self, "Button_JoinAlliance")
	self.btnJoinAlliance:setTitleText(i18n("common_text_167"))
	self.btnJoinAlliance:setVisible(false)
	self.btnJoinAlliance:addTouchEventListener(handler(self, self.btnClickJoinAlliance))
	self.textPoint = SoraDGetChildByName(self, "Text_point")
	self.textName = SoraDGetChildByName(self, "Text_Name")
	self.textRank = SoraDGetChildByName(self, "Text_Rank")
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView_rank")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("commonRankingSingle")
	self.txtMsg = SoraDGetChildByName(self, "text_no_rank_tip")
	self.nodeMyLord = SoraDGetChildByName(self, "Node_Lord")
	self.imgMyLord = SoraDGetChildByName(self.nodeMyLord, "Image_myHead")
	self.txtMyInt = SoraDGetChildByName(self.nodeMyLord, "Text_myNum")
	self.txtMyRank = SoraDGetChildByName(self.nodeMyLord, "Text_myRank")
	self.spMyRank = SoraDGetChildByName(self.nodeMyLord, "Sprite_myRank")
	self.Text_myName = SoraDGetChildByName(self.nodeMyLord, "Text_myName")
	self.Node_flag = SoraDGetChildByName(self.nodeMyLord, "Node_Flag")
	if self.Node_flag == nil then
		self.Node_flag = display.newNode()
		self.Node_flag:setPosition(500, 60)
		self.Node_flag:setScale(0.5)
		self.Node_flag:addTo(self.nodeMyLord, 2)
	end
	self.btnJumpToSelf = SoraDGetChildByName(self, "Button_jump")
	self.btnJumpToSelf:addTouchEventListener(handler(self, self.btnClickJump))
	self.textName:setString(i18n("common_text_264"))
	self.textRank:setString(i18n("common_text_2193"))
end
function collectSalaryRankPage:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
	SoraDAddMessage(self, "MESSAGE_COLLECT_RANK_MESSAGE", handler(self, self.updataScrollData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
end
function collectSalaryRankPage:initData(rankType)
	self.rankType = rankType
	if self.rankType == gCollectSalaryRankType.PERSONAL_RANK_TYPE then
		self.textTitle:setString(i18n("rides_title_01"))
		self.textPoint:setString(i18n("common_text_2195"))
	else
		self.textTitle:setString(i18n("rides_title_02"))
		self.textPoint:setString(i18n("common_text_032"))
	end
	self.scroll:recyclingAll()
	_ENV = i18n("common_text_032")
	i18n("common_text_032").rankType = self.rankType
	collectSalaryCtrl:reqGetRankData(i18n("common_text_032"))
	self:setAward()
end
function collectSalaryRankPage:setAward()
	_UPVALUE2_ = self.rankType
	self.rankType[1] = "id"
	self.rankType[2] = "count"
	local reward = serviceFunctions.tableFormat(collectSalaryRead.getFirstRankAward(self.rankType), self.rankType)
	local nowNum = table.nums(self.awardArray)
	local realNum = table.nums(reward)
	local MAX_AWARD_NUM = nowNum > realNum and nowNum or realNum
	for i = 1, MAX_AWARD_NUM do
		if not self.awardArray[i] and i <= realNum then
			self.awardArray[i] = include("commonItemAward").new()
			self.awardArray[i]:setScale(0.8)
			self.awardArray[i]:setBaseScale(1.0)
			self.awardArray[i]:setOwnView(self:getParent())
			self.awardArray[i]:setPosition(0, 0)
			self.awardArray[i]:addTo(self.nodeAward)
		end
		if self.awardArray[i] then
			if i <= realNum then
				self.awardArray[i]:initData(reward[i].id, reward[i].count)
			end
			self.awardArray[i]:setVisible(i <= realNum)
		end
	end
	SoraDToCenter(self.nodeAward, 100, SoraDFIsRA())
end
function collectSalaryRankPage:updataScrollData(target, data)
	if data.subMsg == "rank" then
		if data.rankType ~= self.rankType then
			return
		end
		SoraDCloseLoading(self)
		self.rankInfo = nil
		if not data.rankData.rankData then
			_ENV = data.rankData.rankData
		end
		self.rankInfo = data.rankData.rankData
		self.rank = data.rankData.curRank or 0
		self.myScore = data.rankData.myScore or 0
		self:initMyRank()
		local _ENV, tmp = self.initMyRank, self.initMyRank
		for i, v in ipairs(self.rankInfo) do
			local _ENV, singleData
			singleData.player, _ENV, singleData.rank = nil, nil, i
			if self.rankType == gCollectSalaryRankType.PERSONAL_RANK_TYPE then
				singleData.player.iconID = v.uInfo.iconID
				if v.uInfo.allianceAbbr then
					_ENV = nil
					;(nil).abbr = v.uInfo.allianceAbbr
					;(nil).name = v.uInfo.nickName
					if i18n("common_text_186", nil) then
						goto lbl_69
					end
				end
				::lbl_69::
				singleData.lineOneName = v.uInfo.nickName
				singleData.player.avatar = v.uInfo.avatar
				singleData.player.uid = v.uid
				singleData.model = 1
				singleData.nameShowType = 1
				singleData.btnClickType = 1
			elseif self.rankType == gCollectSalaryRankType.ALLIANCE_RANK_TYPE then
				singleData.player.flag = v.aInfo.allianceFlag
				if v.aInfo.allianceAbbr then
					_ENV = nil
					;(nil).abbr = v.aInfo.allianceAbbr
					;(nil).name = v.aInfo.allianceName
					if i18n("common_text_186", nil) then
						goto lbl_108
					end
				end
				::lbl_108::
				singleData.lineOneName = v.aInfo.allianceName
				_ENV = nil
				;(nil).name = v.aInfo.learderName
				singleData.lineTwoName = i18n("common_text_170", nil)
				singleData.player.aid = v.aid
				singleData.model = 2
				singleData.nameShowType = 2
				singleData.btnClickType = 1
			end
			singleData.score = v.score
			singleData.selfRank = self.rank
			table.insert(tmp, singleData)
		end
		if self.rankInfo and next(self.rankInfo) then
			self.scroll:setVisible(true)
			_ENV = nil
			;(nil).scroll = self.scroll
			;(nil).view = self
			self.scroll:updateScrollView(cc.size(640, 112), tmp, 1, nil)
			self.scroll:jumpToTop()
			self.Text_noRecrod:setVisible(false)
		else
			self.scroll:setVisible(false)
			self.Text_noRecrod:setVisible(true)
		end
	end
end
function collectSalaryRankPage:initMyRank()
	local switchNum = function(num)
		num = tonumber(num)
		if num <= RANK_TOP_SPECIAL and 0 < num then
			self.txtMyRank:setVisible(false)
			self.spMyRank:setVisible(true)
			self.spMyRank:setSpriteFrame(self.ocxNum[num])
		else
			self.spMyRank:setVisible(false)
			self.txtMyRank:setVisible(true)
			self.txtMyRank:setString(num)
		end
	end
	local lordInfo = lordInfoCtrl:getLordInfo()
	local gametop = gModuleMgr.getObject("gametop")
	local allianceMgr = gametop.playertop_:getModule("allianceMgr")
	local hasAlliance = allianceMgr:hasJoinAlliance()
	self.Node_flag:removeAllChildren()
	if self.rankType == gCollectSalaryRankType.ALLIANCE_RANK_TYPE and hasAlliance then
		local allianceInfo = allianceMgr:getAllianceInfo()
		self.imgMyLord:setVisible(false)
		allianceDesRead.getFlagWithParticle(allianceInfo.property.flag, self.Node_flag)
		_ENV = self.Node_flag
		self.Node_flag.abbr = allianceInfo.property.abbr
		self.Node_flag.name = allianceInfo.property.name
		local str = i18n("common_text_186", self.Node_flag) .. "\n"
		_ENV = nil
		;(nil).name = allianceMgr:getAllianceLeaderName()
		str = str .. i18n("common_text_170", nil)
		self.Text_myName:setString(str)
	else
		self.imgMyLord:setVisible(true)
		SoraDGetHeadFromManager(self.imgMyLord, lordInfo.base.imageId, lordInfo.base.avatar)
		if lordInfo.abbr ~= "" then
			_ENV = str
			str.abbr = lordInfo.abbr
			str.name = lordInfo.base.nickName
			if i18n("common_text_186", str) then
				goto lbl_91
			end
		end
		::lbl_91::
		self.Text_myName:setString(lordInfo.base.nickName)
	end
	self.nodeMyLord:setVisible(true)
	self.btnJoinAlliance:setVisible(false)
	if self.rank > 0 then
		switchNum(self.rank)
		self.txtMyInt:setString(string.formatnumberthousands(self.myScore))
		self.txtMsg:setString("")
	elseif self.rankType == gCollectSalaryRankType.ALLIANCE_RANK_TYPE and not hasAlliance then
		self.nodeMyLord:setVisible(false)
		self.txtMsg:setVisible(false)
		self.btnJoinAlliance:setVisible(true)
	else
		switchNum(0)
		self.txtMyRank:setString(i18n("common_text_827"))
		SoraDGetAutoHeightLabel(self.txtMyRank, 92)
		self.txtMyInt:setString(0)
	end
end
function collectSalaryRankPage:btnClickJump(button, EventType)
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
function collectSalaryRankPage:btnClickRankAward(button, EventType)
	if EventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("collectSalaryRankAward")
		panel:initData(self.rankType)
		panel:show()
	end
end
function collectSalaryRankPage:btnClickJoinAlliance(button, EventType)
	if EventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDRemoveAllPrePanelFromManager(self)
		uiManager:show("AllianceJoinView")
	end
end
function collectSalaryRankPage:serverMessageGetLordInfo(target, data)
	SoraDCloseLoading(self)
	if data and data.lord then
		SoraDOpenLordView(data.lord)
	end
end
function collectSalaryRankPage:sMsgReqInfoBack(target, data)
	print("请求查看联盟信息回来了")
	SoraDCloseLoading(self)
	local alliance = data.alliance
	if data.clientData then
		local from = data.clientData.from
		if from == "commonRankingSingle" then
			print("frome---commonRankingSingle", from)
			SoraDOpenAllianceInfoView(alliance)
		end
	end
end
function collectSalaryRankPage:onExit()
	SoraDRemoveMessageByTarget(self)
	SoraDManagerRemoveTimerByTarget(self)
end
return collectSalaryRankPage
