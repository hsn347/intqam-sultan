local gametop = gModuleMgr.getObject("gametop")
local radianceActivityCtrl = SoraDGetCtrl("radianceActivityCtrl")
local allianceDesRead = include("allianceDesRead")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
_ENV = "allianceMgr"
;("allianceMgr").RANK_VIEW_TYPE_CHECKPOINT = 1
local ("allianceMgr").RANK_VIEW_TYPE_PALACE, RANK_VIEW_TYPE = 2, "allianceMgr"
local radianceWarIntegralAllianceView = class("radianceWarIntegralAllianceView", function(ccsFileName)
	local target = SoraDCreateBasePanel(ccsFileName)
	SoraDDeviceFitOffset(target)
	return target
end)
function radianceWarIntegralAllianceView:ctor()
	_UPVALUE3_ = nil
	self.ocxNum, (nil)[1] = nil, "icon_ranking_1.png"
	self.ocxNum, (nil)[2] = nil, "icon_ranking_2.png"
	self.ocxNum, (nil)[3] = nil, "icon_ranking_3.png"
	self.scrollRank = SoraDGetChildByName(self, "Size_ScrollView_rank")
	self.scrollRank = include("commonAutoScrollList").new(self.scrollRank)
	self.scrollRank:setSingleCCS("commonRankingSingle")
	self.textNotice = SoraDGetChildByName(self.scrollRank, "Text_notice")
	self.nodeLord = SoraDGetChildByName(self, "Node_Lord")
	self.textMyRank = SoraDGetChildByName(self.nodeLord, "Text_myRank")
	self.spMyRank = SoraDGetChildByName(self.nodeLord, "Sprite_myRank")
	self.textMyNum = SoraDGetChildByName(self.nodeLord, "Text_myNum")
	self.textMyName = SoraDGetChildByName(self.nodeLord, "Text_myName")
	self.nodeFlag = SoraDGetChildByName(self.nodeLord, "Node_flag")
	self.btnJump = SoraDGetChildByName(self.nodeLord, "Button_jump")
	self.btnJump:addTouchEventListener(handler(self, self.btnJumpClick))
	self.textNoRecrod = SoraDGetChildByName(self, "Text_noRecrod")
	self.textPoint = SoraDGetChildByName(self, "Text_point")
	self.textRank = SoraDGetChildByName(self, "Text_Rank")
	self.textName = SoraDGetChildByName(self, "Text_Name")
	self.textPoint:setString(i18n("devilvalley_text_30"))
	self.textRank:setString(i18n("common_text_2193"))
	self.textName:setString(i18n("common_text_2037"))
	self.textNoRecrod:setString(i18n("common_text_927"))
	self.btnJumpMyAlliance = SoraDGetChildByName(self, "Button_Jump_Alliance")
	self.btnJumpMyAlliance:addTouchEventListener(handler(self, self.btnJumpMyAllianceClick))
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.btnHelp:addTouchEventListener(handler(self, self.onClickHelp))
	_ENV, self.nodeCommonTabBtnEX = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_Top"), SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_Top")
	SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_Top").tabNum = 2
	_ENV, _ENV, SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_Top").defaultClick = "CCS_commonTabBtnEX_Top", self, 1
	;("CCS_commonTabBtnEX_Top").title = i18n("brightWar_text_194")
	;("CCS_commonTabBtnEX_Top").handle = handler(self, self.btnTabClick)
	_ENV, self[1], ("CCS_commonTabBtnEX_Top").tag = "CCS_commonTabBtnEX_Top", "CCS_commonTabBtnEX_Top", RANK_VIEW_TYPE.RANK_VIEW_TYPE_CHECKPOINT
	;("CCS_commonTabBtnEX_Top").title = i18n("brightWar_title_06")
	;("CCS_commonTabBtnEX_Top").handle = handler(self, self.btnTabClick)
	SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_Top").tabsetArray, self[2], ("CCS_commonTabBtnEX_Top").tag = self, "CCS_commonTabBtnEX_Top", RANK_VIEW_TYPE.RANK_VIEW_TYPE_PALACE
	local param = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_Top")
	self.nodeCommonTabBtnEX:initView(param)
end
function radianceWarIntegralAllianceView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_RADIANCE_WAR_UI_REFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK", handler(self, self.sMsgReqInfoBack))
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_REQ_INFO_BACK_ERR", handler(self, self.sMsgReqInfoBackErr))
end
function radianceWarIntegralAllianceView:initData(target, data)
	if data.subMsg == "TeamRank" and data.rankType == self.showViewType then
		SoraDCloseLoading(self)
		if data.err then
			return
		end
		self.scrollRank:jumpToTop()
		if not data.data or not data.data.myInfo then
			_ENV = data.data.myInfo
		end
		self.selfRankInfo = data.data.myInfo
		if not data.data or not data.data.rankList then
			_ENV = data.data.rankList
		end
		self.rankInfo = data.data.rankList
		self.rank = self.selfRankInfo.rank or 0
		self.myScore = self.showViewType == RANK_VIEW_TYPE.RANK_VIEW_TYPE_CHECKPOINT and string.formatnumberthousands(self.selfRankInfo.exploit or 0) or SoraDConvertSecondToString(self.selfRankInfo.totalSecs or 0)
		self:initMyRank()
		local _ENV, tmp = self.initMyRank, self.initMyRank
		for i = 1, math.min(#self.rankInfo, 100) do
			local v = self.rankInfo[i]
			local _ENV, singleData
			singleData.player, _ENV, singleData.rank = nil, nil, i
			singleData.player.flag = v.allianceFlag
			if v.allianceAbbr then
				_ENV = nil
				;(nil).abbr = v.allianceAbbr
				;(nil).name = v.allianceName
			end
			local lineOneName = i18n("common_text_186", nil) or v.allianceName or i18n("common_text_480")
			if v.kid then
				lineOneName = lineOneName .. "#" .. v.kid
			end
			singleData.lineOneName = lineOneName
			_ENV = v.kid
			v.kid.name = v.allianceLeaderName
			singleData.lineTwoName = i18n("common_text_170", v.kid)
			singleData.player.aid = v.teamId
			singleData.player.kid = v.kid
			singleData.score = v.totalSecs and SoraDConvertSecondToString(v.totalSecs) or v.exploit
			singleData.model = 2
			singleData.nameShowType = 2
			singleData.btnClickType = 1
			singleData.selfRank = self.rank
			table.insert(tmp, singleData)
		end
		if self.rankInfo and next(self.rankInfo) then
			self.scrollRank:setVisible(true)
			_ENV = nil
			;(nil).scroll = self.scroll
			;(nil).view = self
			self.scrollRank:updateScrollView(cc.size(640, 112), tmp, 1, nil)
			self.scrollRank:jumpToTop()
			self.textNoRecrod:setVisible(false)
		else
			self.scrollRank:setVisible(false)
			self.textNoRecrod:setVisible(true)
		end
	end
end
function radianceWarIntegralAllianceView:initMyRank()
	local switchNum = function(num)
		num = tonumber(num)
		if num <= RANK_TOP_SPECIAL and 0 < num then
			self.textMyRank:setVisible(false)
			self.spMyRank:setVisible(true)
			self.spMyRank:setSpriteFrame(self.ocxNum[num])
		else
			self.spMyRank:setVisible(false)
			self.textMyRank:setVisible(true)
			self.textMyRank:setString(num)
		end
	end
	local lordInfo = lordInfoCtrl:getLordInfo()
	local hasAlliance = allianceMgr:hasJoinAlliance()
	self.nodeFlag:removeAllChildren()
	if hasAlliance then
		local allianceInfo = allianceMgr:getAllianceInfo()
		allianceDesRead.getFlagWithParticle(allianceInfo.property.flag, self.nodeFlag)
		_ENV = self.nodeFlag
		self.nodeFlag.abbr = allianceInfo.property.abbr
		self.nodeFlag.name = allianceInfo.property.name
		local str = i18n("common_text_186", self.nodeFlag) .. "#" .. gametop.playertop_:getKingdomID() .. "\n"
		_ENV = nil
		;(nil).name = allianceMgr:getAllianceLeaderName()
		str = str .. i18n("common_text_170", nil)
		self.textMyName:setString(str)
	end
	if self.rank > 0 and self.rank <= 100 then
		switchNum(self.rank)
		self.textMyNum:setString(self.myScore)
	elseif not hasAlliance then
		self.nodeLord:setVisible(false)
	else
		switchNum(0)
		self.textMyRank:setString(i18n("common_text_827"))
		SoraDGetAutoHeightLabel(self.textMyRank, 92)
		self.textMyNum:setString(self.myScore)
	end
end
function radianceWarIntegralAllianceView:btnTabClick(showViewType)
	self.showViewType = showViewType
	if self.showViewType == RANK_VIEW_TYPE.RANK_VIEW_TYPE_CHECKPOINT then
		self.textPoint:setString(i18n("brightWar_text_194"))
		radianceActivityCtrl:reqTeamGateRank()
		self.btnHelp:setVisible(true)
	else
		self.textPoint:setString(i18n("brightWar_text_34"))
		radianceActivityCtrl:reqTeamPalaceRank()
		self.btnHelp:setVisible(false)
	end
end
function radianceWarIntegralAllianceView:btnJumpClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local tag = target:getTag()
		self:stopAllActions()
		SoraDPlaySound()
		self.ownPosY = self.scrollRank:getInnerContainerSize().height - 112 * self.rank - 0.5 * self.scrollRank:getContentSize().height
		local scrollRankPercent = 100 * (1 - self.ownPosY / (self.scrollRank:getInnerContainerSize().height - self.scrollRank:getContentSize().height))
		scrollRankPercent = math.min(100, math.max(0, scrollRankPercent))
		local scrollRankH = self.scrollRank:getContentSize().height
		if math.abs(self.ownPosY + self.scrollRank:getInnerContainer():getPositionY()) < 0.5 * scrollRankH then
			self.scrollRank:scrollToPercentVertical(scrollRankPercent, 0.2, true)
		else
			_UPVALUE2_ = 0.2
			;(0.2)[1] = cca.callFunc(function(...)
				if self.rank <= 100 and self.rank > 0 then
					self.scrollRank:scrollToPercentVertical(scrollRankPercent + 0.5, 0.2, false)
				end
			end)
			;(0.2)[2] = cca.delay(0.3)
			;(0.2)[3] = cca.callFunc(function(...)
				if self.rank <= 100 and self.rank > 0 then
					self.scrollRank:scrollToPercentVertical(scrollRankPercent, 0.1, true)
				end
			end)
			;(0.2)[4] = cca.callFunc(function(...)
				if self.rank <= 100 and self.rank > 0 then
					self.scrollRank:scrollToPercentVertical(scrollRankPercent, 0.1, true)
				end
			end)
			self:runAction(cca.seq(0.2))
		end
	elseif eventType == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif eventType == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function radianceWarIntegralAllianceView:btnJumpMyAllianceClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local tag = target:getTag()
		local allianceInfo = allianceMgr:getAllianceInfo()
		dump(allianceInfo, "allianceInfo", 10)
		local allianceQuery = SoraDGetCtrl("allianceQuery")
		_ENV = 10
		_ENV, (10).aid = allianceInfo.property.aid, allianceInfo.property.aid
		allianceInfo.property.aid.from = "commonRankingSingle"
		allianceQuery:reqAllianceByID(10, allianceInfo.property.aid)
		SoraDShowLoading(self)
	elseif eventType == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif eventType == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
function radianceWarIntegralAllianceView:onClickHelp(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "common_text_1173"
		;("common_text_1173")[1] = i18n("brightWar_text_195")
		;("common_text_1173")[2] = i18n("brightWar_text_195")
		SoraDShowFixWindow(i18n("common_text_1173"), "common_text_1173")
	end
end
function radianceWarIntegralAllianceView:msgCallBack(target, data)
end
function radianceWarIntegralAllianceView:sMsgReqInfoBack(target, data)
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
function radianceWarIntegralAllianceView:sMsgReqInfoBackErr(target, data)
	print("请求查看联盟信息回来了--出错")
	SoraDCloseLoading(self)
end
return radianceWarIntegralAllianceView
