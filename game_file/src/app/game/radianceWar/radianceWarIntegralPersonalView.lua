local allianceMgr = SoraDGetCtrl("allianceMgr")
local gametop = gModuleMgr.getObject("gametop")
local radianceActivityCtrl = SoraDGetCtrl("radianceActivityCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local radianceWarIntegralPersonalView = class("radianceWarIntegralPersonalView", function(ccsFileName)
	local target = SoraDCreateBasePanel(ccsFileName)
	SoraDDeviceFitOffset(target)
	return target
end)
_ENV = "radianceWarIntegralPersonalView"
;("radianceWarIntegralPersonalView").RANK_VIEW_TYPE_CHECKPOINT = 1
local ("radianceWarIntegralPersonalView").RANK_VIEW_TYPE_PALACE, RANK_VIEW_TYPE = 2, "radianceWarIntegralPersonalView"
function radianceWarIntegralPersonalView:ctor()
	_UPVALUE3_ = nil
	self.ocxNum, (nil)[1] = nil, "icon_ranking_1.png"
	self.ocxNum, (nil)[2] = nil, "icon_ranking_2.png"
	self.ocxNum, (nil)[3] = nil, "icon_ranking_3.png"
	self.nodeLord = SoraDGetChildByName(self, "Node_Lord")
	self.textMyRank = SoraDGetChildByName(self.nodeLord, "Text_myRank")
	self.spMyRank = SoraDGetChildByName(self.nodeLord, "Sprite_myRank")
	self.textMyNum = SoraDGetChildByName(self.nodeLord, "Text_myNum")
	self.textMyName = SoraDGetChildByName(self.nodeLord, "Text_myName")
	self.nodeFlag = SoraDGetChildByName(self.nodeLord, "Node_flag")
	self.imgMyHead = SoraDGetChildByName(self.nodeLord, "Image_myHead")
	self.btnJump = SoraDGetChildByName(self.nodeLord, "Button_jump")
	self.btnJump:setTouchEnabled(true)
	self.btnJump:addTouchEventListener(handler(self, self.btnJumpClick))
	self.textPoint = SoraDGetChildByName(self, "Text_point")
	self.textRank = SoraDGetChildByName(self, "Text_Rank")
	self.textName = SoraDGetChildByName(self, "Text_Name")
	self.scrollRank = SoraDGetChildByName(self, "Size_ScrollView_rank")
	self.scrollRank = include("commonAutoScrollList").new(self.scrollRank)
	self.scrollRank:setSingleCCS("commonRankingSingle")
	self.textNotice = SoraDGetChildByName(self.scrollRank, "Text_notice")
	self.textNoRecrod = SoraDGetChildByName(self, "Text_noRecrod")
	self.textPoint:setString(i18n("brightWar_text_196"))
	self.textRank:setString(i18n("common_text_2193"))
	self.textName:setString(i18n("common_text_2037"))
	self.textNoRecrod:setString(i18n("common_text_927"))
	self.btnJumpMyPlayer = SoraDGetChildByName(self, "Button_Jump_Player")
	self.btnJumpMyPlayer:addTouchEventListener(handler(self, self.btnJumpMyPlayerClick))
	self.maxRank = 100
	_ENV, self.nodeCommonTabBtnEX = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_Top"), SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_Top")
	SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_Top").tabNum = 2
	_ENV, _ENV, SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_Top").defaultClick = "CCS_commonTabBtnEX_Top", self, 1
	;("CCS_commonTabBtnEX_Top").title = i18n("brightWar_text_207")
	;("CCS_commonTabBtnEX_Top").handle = handler(self, self.btnTabClick)
	_ENV, self[1], ("CCS_commonTabBtnEX_Top").tag = "CCS_commonTabBtnEX_Top", "CCS_commonTabBtnEX_Top", RANK_VIEW_TYPE.RANK_VIEW_TYPE_CHECKPOINT
	;("CCS_commonTabBtnEX_Top").title = i18n("brightWar_text_206")
	;("CCS_commonTabBtnEX_Top").handle = handler(self, self.btnTabClick)
	SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_Top").tabsetArray, self[2], ("CCS_commonTabBtnEX_Top").tag = self, "CCS_commonTabBtnEX_Top", RANK_VIEW_TYPE.RANK_VIEW_TYPE_PALACE
	local param = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_Top")
	self.nodeCommonTabBtnEX:initView(param)
end
function radianceWarIntegralPersonalView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
	SoraDAddMessage(self, "MESSAGE_SERVER_RADIANCE_WAR_UI_REFRESH", handler(self, self.initData))
end
function radianceWarIntegralPersonalView:btnTabClick(showViewType)
	self.showViewType = showViewType
	if self.showViewType == RANK_VIEW_TYPE.RANK_VIEW_TYPE_CHECKPOINT then
		self.textPoint:setString(i18n("brightWar_text_196"))
		SoraDShowLoading(self)
		radianceActivityCtrl:reqPlayerKillRank()
		self.maxRank = 100
	else
		self.textPoint:setString(i18n("brightWar_text_34"))
		radianceActivityCtrl:reqKindomPalacePlayerRank()
		self.maxRank = 10
	end
end
function radianceWarIntegralPersonalView:initData(target, data)
	if data.subMsg == "KillRank" and data.rankType == self.showViewType then
		SoraDCloseLoading(self)
		if data.err then
			return
		end
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
		for i, v in ipairs(self.rankInfo) do
			local _ENV, singleData
			singleData.player, _ENV, singleData.rank = nil, nil, i
			singleData.player.iconID = v.headid
			if v.allianceAbbr then
				_ENV = nil
				;(nil).abbr = v.allianceAbbr
				;(nil).name = v.playerName
				if i18n("common_text_186", nil) then
					goto lbl_89
				end
			end
			local lineOneName = v.playerName
			::lbl_89::
			lineOneName = lineOneName .. "#" .. v.kid
			singleData.lineOneName = lineOneName
			singleData.player.avatar = v.avatar
			singleData.player.uid = v.uid
			singleData.player.kid = v.kid
			singleData.score = v.totalSecs and SoraDConvertSecondToString(v.totalSecs) or v.exploit
			singleData.model = 1
			singleData.nameShowType = 1
			singleData.btnClickType = 2
			singleData.selfRank = self.rank
			table.insert(tmp, singleData)
		end
		if self.rankInfo and next(self.rankInfo) then
			self.scrollRank:setVisible(true)
			_ENV = nil
			;(nil).scroll = self.scrollRank
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
function radianceWarIntegralPersonalView:initMyRank()
	local switchNum = function(num)
		num = tonumber(num)
		if num <= RANK_TOP_SPECIAL and 0 < num then
			self.textMyRank:setVisible(false)
			self.spMyRank:setVisible(true)
			self.spMyRank:setSpriteFrame(self.ocxNum[num], ccui.TextureResType.plistType)
		else
			self.spMyRank:setVisible(false)
			self.textMyRank:setVisible(true)
			self.textMyRank:setString(num)
		end
	end
	self.nodeLord:setVisible(true)
	local lordInfo = lordInfoCtrl:getLordInfo()
	dump(lordInfo, "lordInfo", 10)
	SoraDGetHeadFromManager(self.imgMyHead, lordInfo.base.imageId, lordInfo.base.avatar)
	local textMyName = lordInfo.base.nickName .. "#" .. gametop.playertop_:getKingdomID() .. "\n"
	local allianceInfo = allianceMgr:getAllianceInfo()
	_ENV = nil
	;(nil).abbr = allianceInfo.property.abbr
	;(nil).name = allianceInfo.property.name
	textMyName = textMyName .. i18n("common_text_186", nil)
	self.textMyName:setString(textMyName)
	if self.rank <= 0 or self.rank > self.maxRank then
		switchNum(0)
		self.textMyRank:setString(i18n("common_text_827"))
		SoraDGetAutoHeightLabel(self.textMyRank, 92)
		self.textMyNum:setString(self.myScore)
	else
		switchNum(self.rank)
		self.textMyNum:setString(self.myScore)
	end
end
function radianceWarIntegralPersonalView:btnJumpClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		if self.rank == nil then
			return
		end
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
				if self.rank <= self.maxRank and self.rank > 0 then
					self.scrollRank:scrollToPercentVertical(scrollRankPercent + 0.5, 0.2, false)
				end
			end)
			;(0.2)[2] = cca.delay(0.3)
			;(0.2)[3] = cca.callFunc(function(...)
				if self.rank <= self.maxRank and self.rank > 0 then
					self.scrollRank:scrollToPercentVertical(scrollRankPercent, 0.1, true)
				end
			end)
			;(0.2)[4] = cca.callFunc(function(...)
				if self.rank <= self.maxRank and self.rank > 0 then
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
function radianceWarIntegralPersonalView:btnJumpMyPlayerClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local tag = target:getTag()
		SoraDOpenLordView(lordInfoCtrl:getLordInfo())
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
function radianceWarIntegralPersonalView:msgCallBack(target, data)
end
function radianceWarIntegralPersonalView:serverMessageGetLordInfo(target, data)
	SoraDCloseLoading(self)
	if data and data.lord then
		SoraDOpenLordView(data.lord)
	end
end
return radianceWarIntegralPersonalView
