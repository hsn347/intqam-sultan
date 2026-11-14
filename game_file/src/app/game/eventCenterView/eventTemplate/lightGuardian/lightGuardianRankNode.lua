local gametop = gModuleMgr.getObject("gametop")
local lightGuardianCtrl = SoraDGetCtrl("lightGuardianCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local lightGuardianRead = include("lightGuardianRead")
local lightGuardianRankNode = class("lightGuardianRankNode", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	SoraDDeviceFitOffset(target)
	return target
end)
local ONE_NUM = 50
function lightGuardianRankNode:ctor(properties)
	self.rankList, _ENV, self.activityID = gActivityTimeActivityID.RADIANCE_GUARDIAN_ACTIVITY, gActivityTimeActivityID.RADIANCE_GUARDIAN_ACTIVITY, gActivityTimeActivityID.RADIANCE_GUARDIAN_ACTIVITY
	self.heightEnableNotice = 55
	self.rank = 0
	self.hasMore = false
	_UPVALUE3_, self.iBegin = gActivityTimeActivityID.RADIANCE_GUARDIAN_ACTIVITY, 1
	self.ocxNum, gActivityTimeActivityID.RADIANCE_GUARDIAN_ACTIVITY[1] = gActivityTimeActivityID.RADIANCE_GUARDIAN_ACTIVITY, "icon_ranking_1.png"
	self.ocxNum, gActivityTimeActivityID.RADIANCE_GUARDIAN_ACTIVITY[2] = gActivityTimeActivityID.RADIANCE_GUARDIAN_ACTIVITY, "icon_ranking_2.png"
	self.ocxNum, gActivityTimeActivityID.RADIANCE_GUARDIAN_ACTIVITY[3] = gActivityTimeActivityID.RADIANCE_GUARDIAN_ACTIVITY, "icon_ranking_3.png"
	self.nodeAward = SoraDGetChildByName(self, "Node_Award")
	self.btnMoreReward = SoraDGetChildByName(self, "btn_moreReward")
	self.btnMoreReward:setTitleText(i18n("hero_title_02"))
	SoraDAutoSizeButtonText(self.btnMoreReward, cc.size(95, 40))
	self.btnMoreReward:addTouchEventListener(handler(self, self.btnMoreRewardClick))
	self.textTips = SoraDGetChildByName(self, "Text_Tips")
	self.textTips:setString(i18n("common_text_2211"))
	self.nodeTitle = SoraDGetChildByName(self, "Node_title")
	self.textPoint = SoraDGetChildByName(self.nodeTitle, "Text_point")
	self.textPoint:setString(i18n("guardLight_text_01"))
	self.textRank = SoraDGetChildByName(self.nodeTitle, "Text_Rank")
	self.textRank:setString(i18n("common_text_2193"))
	self.textName = SoraDGetChildByName(self.nodeTitle, "Text_Name")
	self.textName:setString(i18n("common_text_3155"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_content_Size")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createScrollSingle))
	self.scroll:setSingleRefresh(handler(self, self.refreshScrollSingle))
	self.scroll:setScrollMoveFun(handler(self, self.scrollMoveFun))
	self.scroll:setScrollBottomFun(handler(self, self.scrollBottomFun))
	self.nodeRankSingle = SoraDGetChildByName(self, "Node_RankSingle")
	self.textNotice = SoraDGetChildByName(self, "Text_notice")
	self.textNotice:setString(i18n("common_text_089"))
	self.textNotice:setVisible(false)
	self.scrollAward = SoraDGetChildByName(self, "ScrollView_Award")
	self.scrollAward = include("commonAutoScrollList").new(self.scrollAward)
	self.scrollAward:setSingleCreate(handler(self, self.createScrollAwardSingle))
	self.scrollAward:setSingleRefresh(handler(self, self.refreshScrollAwardSingle))
	self.node = SoraDGetChildByName(self, "Bottom_Node")
	self.node:setPositionY(150 - display.height)
	self.nodeLord = SoraDGetChildByName(self.node, "Node_Lord")
	self.txtMyRank = SoraDGetChildByName(self.nodeLord, "Text_myRank")
	self.spMyRank = SoraDGetChildByName(self.nodeLord, "Sprite_myRank")
	self.textMyNum = SoraDGetChildByName(self.nodeLord, "Text_myNum")
	self.textMyName = SoraDGetChildByName(self.nodeLord, "Text_myName")
	self.imgMyHead = SoraDGetChildByName(self.nodeLord, "Image_myHead")
	self.btnJump = SoraDGetChildByName(self.nodeLord, "Button_jump")
	self.btnJump:addTouchEventListener(handler(self, self.btnJumpClick))
	self.textNo = SoraDGetChildByName(self, "text_no_rank_tip")
	self.textNo:setPositionY(75 - display.height / 2)
	self.textNo:setString(i18n("herobattle_text_05"))
	self:setAward()
	self:initMyRank()
end
function lightGuardianRankNode:onEnterOther()
	lightGuardianCtrl = nil
	;(nil).iBegin = self.iBegin
	;(nil).nCount = ONE_NUM
	lightGuardianCtrl:reqRadianceGuardianRank(nil)
end
function lightGuardianRankNode:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
	SoraDAddMessage(self, "MESSAGE_RADIANCE_GUARDIAN_REFRESH", handler(self, self.updataScrollData))
end
function lightGuardianRankNode:setAward()
	local awardConfig = lightGuardianRead.getFirstRankReward()
	if next(awardConfig) then
		_UPVALUE2_ = nil
		;(nil)[1] = "id"
		;(nil)[2] = "count"
		awardConfig = serviceFunctions.tableFormat(awardConfig, nil)
		lightGuardianRead = nil
		;(nil).isAR = SoraDFIsRA()
		;(nil).scroll = self.scroll
		;(nil).view = self
		self.scrollAward:updateScrollView(cc.size(90, 100), awardConfig, #awardConfig, nil)
		if SoraDFIsRA() then
			self.scrollAward:scrollToRight(0, true)
		end
	end
end
function lightGuardianRankNode:createScrollAwardSingle()
	local single = display.newNode()
	local awardNode = include("commonItemAward").new()
	awardNode:setScale(0.75)
	awardNode:setOwnView(self:getParent():getParent())
	awardNode:addTo(single)
	awardNode:setPosition(45, 45)
	single.awardNode = awardNode
	return single
end
function lightGuardianRankNode:refreshScrollAwardSingle(parent, data, otherData)
	dump(data, "data")
	parent.awardNode:initData(data.id, data.count)
end
function lightGuardianRankNode:updataScrollData(target, data)
	if data.subMsg == "rank" then
		SoraDCloseLoading(self)
		if data.infoData.myInfo then
			self.selfRankInfo = data.infoData.myInfo
			self.rank = self.selfRankInfo.rank or 0
			self:initMyRank()
		end
		if not data.infoData.rankList then
			_ENV = data.infoData.rankList
		end
		self.rankInfo = data.infoData.rankList
		self.iBegin = self.iBegin + #self.rankInfo
		self.hasMore = #self.rankInfo >= ONE_NUM + 1
		self.textNotice:setVisible(self.hasMore)
		for i, v in ipairs(self.rankInfo) do
			_ENV = nil
			;(nil).model = 1
			;(nil).nameShowType = 1
			_ENV, (nil).btnClickType = nil, 2
			;(nil).uid = v.uid
			;(nil).iconID = v.headid
			;(nil).player, (nil).avatar = nil, v.avatar
			if v.allianceAbbr then
				_ENV = nil
				;(nil).abbr = v.allianceAbbr
				;(nil).name = v.playerName .. "#" .. v.kid
				if i18n("common_text_186", nil) then
					goto lbl_82
				end
			end
			::lbl_82::
			;(nil).lineOneName = v.playerName .. "#" .. v.kid
			;(nil).rank = #self.rankList + 1
			;(nil).score = math.floor(v.guardScore)
			;(nil).notToCenter = true
			local (nil).selfRank, singleData = self.rank, nil
			table.insert(self.rankList, singleData)
		end
		_ENV = nil
		;(nil).scroll = self.scroll
		;(nil).view = self
		self.scroll:updateScrollView(cc.size(590, 80), self.rankList, 1, nil)
		self.textNo:setVisible(0 >= #self.rankList)
	end
end
function lightGuardianRankNode:initMyRank()
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
	self.nodeLord:setVisible(true)
	local lordInfo = lordInfoCtrl:getLordInfo()
	SoraDGetHeadFromManager(self.imgMyHead, lordInfo.base.imageId, lordInfo.base.avatar)
	local name = lordInfo.base.nickName .. "#" .. gametop.playertop_:getKingdomID()
	if lordInfo.abbr ~= "" then
		_ENV = nil
		;(nil).abbr = lordInfo.abbr
		;(nil).name = name
		if i18n("common_text_186", nil) then
			goto lbl_38
		end
	end
	::lbl_38::
	self.textMyName:setString(name)
	if self.rank <= 0 then
		switchNum(0)
		self.txtMyRank:setString(i18n("common_text_827"))
		SoraDGetAutoHeightLabel(self.txtMyRank, 92)
		self.textMyNum:setString(0)
	else
		switchNum(self.rank)
		self.textMyNum:setString(string.formatnumberthousands(math.floor(self.selfRankInfo.guardScore)))
	end
end
function lightGuardianRankNode:btnClickJump(button, EventType)
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
function lightGuardianRankNode:btnClickRankAward(button, EventType)
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
function lightGuardianRankNode:createScrollSingle(parent, data)
	local single = self.nodeRankSingle:clone()
	return include("commonRankingSingle").new(single)
end
function lightGuardianRankNode:refreshScrollSingle(parent, data, otherData)
	parent:initData(data, otherData)
	SoraDGetChildByName(parent, "Panel_touch"):setVisible(parent:getTag() % 2 ~= 0)
end
function lightGuardianRankNode:btnMoreRewardClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		_ENV = nil
		;(nil).awardList = lightGuardianRead.getRankReward()
		uiManager:show("comRankAward", nil)
	end
end
function lightGuardianRankNode:btnJumpClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
	end
end
function lightGuardianRankNode:scrollMoveFun()
	local scrollInner = self.scroll:getInnerContainer()
	local offsetY = scrollInner:getPositionY()
	if offsetY > scrollInner:getContentSize().height - self.scroll:getContentSize().height + self.heightEnableNotice then
		self.fromLoadText = true
		if self.hasMore then
			self.textNotice:setString(i18n("common_text_084"))
		end
	end
end
function lightGuardianRankNode:scrollBottomFun()
	if self.fromLoadText then
		if self.hasMore then
			self.textNotice:setString(i18n("common_text_089"))
			self:requestMore()
		end
		self.fromLoadText = false
	end
end
function lightGuardianRankNode:requestMore()
	lightGuardianCtrl = nil
	;(nil).iBegin = self.iBegin
	;(nil).nCount = ONE_NUM
	lightGuardianCtrl:reqRadianceGuardianRank(nil)
end
function lightGuardianRankNode:serverMessageGetLordInfo(target, data)
	SoraDCloseLoading(self)
	if data and data.lord then
		SoraDOpenLordView(data.lord)
	end
end
return lightGuardianRankNode
