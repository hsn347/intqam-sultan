local luckyFlopRead = include("luckyFlopRead")
local luckyFlopCtrl = SoraDGetCtrl("luckyFlopCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local gametop = gModuleMgr.getObject("gametop")
local luckyFlopRankView = class("luckyFlopRankView", function(target)
	return target or SoraDCreateBasePanel("luckyFlopRankView")
end)
function luckyFlopRankView:ctor()
	_UPVALUE3_, self.awardArray, _ENV = nil, nil, nil
	self.ocxNum, (nil)[1] = nil, "icon_ranking_1.png"
	self.ocxNum, (nil)[2] = nil, "icon_ranking_2.png"
	self.ocxNum, (nil)[3] = nil, "icon_ranking_3.png"
	SoraDDeviceFitOffset(self)
	self.nodeTop = SoraDGetChildByName(self, "Top_Node")
	self.textTitle = SoraDGetChildByName(self, "Text_Title")
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
	self.btnAward = SoraDGetChildByName(self, "btn_moreReward")
	self.btnAward:setTitleText(i18n("Endless_trial_text_13"))
	SoraDAutoSizeButtonText(self.btnAward, cc.size(100, 40))
	self.btnAward:addTouchEventListener(handler(self, self.btnClickRankAward))
	self.textPoint = SoraDGetChildByName(self, "Text_point")
	self.textName = SoraDGetChildByName(self, "Text_Name")
	self.textRank = SoraDGetChildByName(self, "Text_Rank")
	self.scroll = SoraDGetChildByName(self, "Size_ScrollView_rank")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("commonRankingSingle")
	self.txtMsg = SoraDGetChildByName(self, "text_no_rank_tip")
	self.textTips = SoraDGetChildByName(self, "text_tip")
	self.nodeMyLord = SoraDGetChildByName(self, "Node_Lord")
	self.imgMyLord = SoraDGetChildByName(self.nodeMyLord, "Image_myHead")
	self.txtMyInt = SoraDGetChildByName(self.nodeMyLord, "Text_myNum")
	self.txtMyRank = SoraDGetChildByName(self.nodeMyLord, "Text_myRank")
	self.spMyRank = SoraDGetChildByName(self.nodeMyLord, "Sprite_myRank")
	self.Text_myName = SoraDGetChildByName(self.nodeMyLord, "Text_myName")
	self.btnJumpToSelf = SoraDGetChildByName(self, "Button_jump")
	self.btnJumpToSelf:addTouchEventListener(handler(self, self.btnClickJump))
	self.textName:setString(i18n("common_text_264"))
	self.textRank:setString(i18n("common_text_2193"))
	_ENV = i18n("common_text_2193")
	i18n("common_text_2193").num = luckyFlopRead.getNeedShowInfo().charmNum
	i18n("common_text_2193").num1 = luckyFlopRead.getNeedShowInfo().num
	self.textTips:setString(i18n("luckyFlip_text_15", i18n("common_text_2193")))
end
function luckyFlopRankView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
	SoraDAddMessage(self, "MESSAGE_LUCKY_FLOP_REFRESH_SUCCESS", handler(self, self.updataScrollData))
end
function luckyFlopRankView:initData(rankType, parentView)
	self.parentView = parentView
	self.rankType = rankType
	self.textTips:setVisible(self.rankType == 2)
	if self.rankType == 1 then
		self.textTitle:setString(i18n("luckyFlip_text_10"))
		self.textPoint:setString(i18n("luckyFlip_title_07"))
		self.scroll:recyclingAll()
		luckyFlopCtrl:reqLuckyFlipLuckyRank()
	else
		self.textTitle:setString(i18n("luckyFlip_text_11"))
		self.textPoint:setString(i18n("luckyFlip_text_02"))
		self.scroll:recyclingAll()
		luckyFlopCtrl:reqLuckyFlipLoveRank()
	end
	self:setAward()
end
function luckyFlopRankView:setAward()
	_UPVALUE2_ = self.rankType
	self.rankType[1] = "id"
	self.rankType[2] = "count"
	local reward = serviceFunctions.tableFormat(luckyFlopRead.getShowRankAward(self.rankType), self.rankType)
	local nowNum = table.nums(self.awardArray)
	local realNum = table.nums(reward)
	print("nowNum", nowNum, realNum)
	local MAX_AWARD_NUM = nowNum > realNum and nowNum or realNum
	for i = 1, MAX_AWARD_NUM do
		if not self.awardArray[i] and i <= realNum then
			self.awardArray[i] = include("commonItemAward").new()
			self.awardArray[i]:setScale(0.8)
			self.awardArray[i]:setPosition(0, 0)
			self.awardArray[i]:addTo(self.nodeAward)
			self.awardArray[i]:setOwnView(self.parentView)
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
function luckyFlopRankView:updataScrollData(target, data)
	if data.subMsg == "rank" then
		SoraDCloseLoading(self)
		self.selfRankInfo = data.infoData.selfInfo
		self.rankInfo = data.infoData.rankInfo
		self.rank = self.selfRankInfo.rank or 0
		dump(self.selfRankInfo, "self.selfRankInfo", 10)
		self:initMyRank()
		local _ENV, tmp = self.initMyRank, self.initMyRank
		for i, v in ipairs(self.rankInfo) do
			_ENV = nil
			;(nil).model = 1
			;(nil).nameShowType = 1
			_ENV, (nil).btnClickType = nil, 2
			;(nil).uid = v.uid
			;(nil).iconID = v.iconID
			;(nil).player, (nil).avatar = nil, v.avatar
			if v.abbr then
				_ENV = nil
				;(nil).abbr = v.abbr
				;(nil).name = v.nickName
				if i18n("common_text_186", nil) then
					goto lbl_57
				end
			end
			::lbl_57::
			;(nil).lineOneName = v.nickName
			;(nil).rank = v.rank
			;(nil).score = self.rankType == 1 and v.luckyNumber or v.loveNumber
			local (nil).selfRank, singleData = self.rank, nil
			table.insert(tmp, singleData)
		end
		_ENV = nil
		;(nil).scroll = self.scroll
		;(nil).view = self
		self.scroll:updateScrollView(cc.size(640, 112), tmp, 1, nil)
		self.scroll:jumpToTop()
	end
end
local MAX_RANK = 100
function luckyFlopRankView:initMyRank()
	local switchNum = function(num)
		num = tonumber(num)
		if num <= RANK_TOP_SPECIAL and 0 < num then
			self.txtMyRank:setVisible(false)
			self.spMyRank:setVisible(true)
			self.spMyRank:setSpriteFrame(self.ocxNum[num], ccui.TextureResType.plistType)
		else
			self.spMyRank:setVisible(false)
			self.txtMyRank:setVisible(true)
			self.txtMyRank:setString(num)
		end
	end
	self.nodeMyLord:setVisible(true)
	local lordInfo = lordInfoCtrl:getLordInfo()
	SoraDGetHeadFromManager(self.imgMyLord, lordInfo.base.imageId, lordInfo.base.avatar)
	if lordInfo.abbr ~= "" then
		_ENV = nil
		;(nil).abbr = lordInfo.abbr
		;(nil).name = lordInfo.base.nickName
		if i18n("common_text_186", nil) then
			goto lbl_34
		end
	end
	::lbl_34::
	self.Text_myName:setString(lordInfo.base.nickName)
	if self.rank <= 0 then
		switchNum(0)
		self.txtMyRank:setString(i18n("common_text_827"))
		SoraDGetAutoHeightLabel(self.txtMyRank, 92)
		self.txtMyInt:setString(0)
	else
		switchNum(self.rank)
		self.txtMyInt:setString(string.formatnumberthousands(self.rankType == 1 and self.selfRankInfo.luckyNumber or self.selfRankInfo.loveNumber))
	end
	self.txtMsg:setString("")
end
function luckyFlopRankView:btnClickJump(button, EventType)
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
function luckyFlopRankView:btnClickRankAward(button, EventType)
	if EventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("commonRankAwardView")
		local rankAward = luckyFlopRead.getRankAward(self.rankType)
		if self.rankType == 1 then
			panel:setDownTip(i18n("donate_text_16"))
			panel:initData(rankAward)
			panel:setTitle(i18n("luckyFlip_text_10"))
		else
			_ENV = i18n("luckyFlip_text_10")
			i18n("luckyFlip_text_10").num = luckyFlopRead.getNeedShowInfo().charmNum
			i18n("luckyFlip_text_10").num1 = luckyFlopRead.getNeedShowInfo().num
			panel:setDownTip(i18n("donate_text_16") .. "\n" .. i18n("luckyFlip_text_15", i18n("luckyFlip_text_10")))
			panel:initData(rankAward)
			panel:setTitle(i18n("luckyFlip_text_11"))
		end
		panel:show()
	end
end
function luckyFlopRankView:serverMessageGetLordInfo(target, data)
	SoraDCloseLoading(self)
	if data and data.lord then
		SoraDOpenLordView(data.lord)
	end
end
return luckyFlopRankView
