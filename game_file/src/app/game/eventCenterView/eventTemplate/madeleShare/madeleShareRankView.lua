local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local madeleShareRankView = class("madeleShareRankView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("madeleShareRankView")
	end
	return target
end)
function madeleShareRankView:ctor()
	self.tableSpare, _ENV, self.tableSingle, _ENV, self.tableData, _ENV, self.type = lordRankingsDef.alliancePower, lordRankingsDef.alliancePower, lordRankingsDef.alliancePower, lordRankingsDef.alliancePower, lordRankingsDef.alliancePower, lordRankingsDef.alliancePower, lordRankingsDef.alliancePower
	self.ownPosY = 0
	self.ccs_Title = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle_madele")
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.labelName:setString(i18n("common_text_264"))
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	SoraDGetChildByName(self, "Image_bg"):setFillType(1)
	self.textMyRank = SoraDGetChildByName(self, "Text_myRank")
	self.textMyLordName = SoraDGetChildByName(self, "Text_myLordName")
	self.textMyNum = SoraDGetChildByName(self, "Text_myNum")
	self.textMyName = SoraDGetChildByName(self, "Text_myName")
	self.imageMyHead = SoraDGetChildByName(self, "Image_head")
	self.imageRank = SoraDGetChildByName(self, "Sprite_index")
	self.imageRank:setVisible(false)
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_rankings")
	self.btnShowReward = SoraDGetChildByName(self, "icon_box")
	self.btnShowReward:setTouchEnabled(true)
	self.btnShowReward:setSwallowTouches(true)
	self.btnShowReward:addTouchEventListener(handler(self, self.btnClickReward))
	self.imageBottomBg = SoraDGetChildByName(self, "bottomBg")
	self.imageBottomBg_1 = SoraDGetChildByName(self, "bottomBg_1")
	self.imageBottomBg:addTouchEventListener(handler(self, self.btnJumpClickCallBack))
	self.imageBottomBg_1:addTouchEventListener(handler(self, self.btnJumpClickCallBack))
	SoraDAddMessage(self, "MESSAGE_MADELE_RANKINGS_SUCCESS", function(target, infoData)
		self:receiveRank(infoData.data)
	end)
end
function madeleShareRankView:initData(rankType, classType)
	_ENV, self.type = nil, rankType
	;(nil).sharePoint = classType == 1 and i18n("madeleine_feast_text_10") or i18n("cool_summer_text_02")
	;(nil).happyPoint = classType == 1 and i18n("madeleine_feast_text_12") or i18n("cool_summer_text_04")
	;(nil).shareRank = classType == 1 and i18n("madeleine_feast_text_11") or i18n("cool_summer_text_03")
	local (nil).happyRank, stringTbl = classType == 1 and i18n("madeleine_feast_text_13") or i18n("cool_summer_text_05"), nil
	local _ENV, tableTitle = classType == 1 and i18n("madeleine_feast_text_13") or i18n("cool_summer_text_05"), classType == 1 and i18n("madeleine_feast_text_13") or i18n("cool_summer_text_05")
	tableTitle[gDinnerShareType.SHARE] = stringTbl.shareRank
	tableTitle[gDinnerShareType.HAPPINESS] = stringTbl.happyRank
	self.ccs_Title:setTitle(tableTitle[self.type])
	if self.type == gDinnerShareType.SHARE then
		self.labelDes:setString(stringTbl.sharePoint)
	elseif self.type == gDinnerShareType.HAPPINESS then
		self.labelDes:setString(stringTbl.happyPoint)
	end
	SoraDShowLoading(self)
end
function madeleShareRankView:receiveRank(data)
	self.tableData = data.rankInfo
	self.selfInfo = data.selfInfo
	self.myUid = self.selfInfo.uid
	self.nickName = self.selfInfo.nickName
	self.rank = self.selfInfo.rank
	self:initMyData()
	if table.nums(self.tableData) > 0 then
		self:addScrollView()
	else
		local text = ccui.Text:create(i18n("common_text_927"), "", 20)
		text:addTo(SoraDGetChildByName(self, "Image_bg"))
		text:setPosition(display.cx, display.cy)
	end
	SoraDCloseLoading(self)
end
function madeleShareRankView:addScrollView()
	local scrollInnerNewH = math.max(110 * #self.tableData, self.scroll:getContentSize().height)
	for i, v in ipairs(self.tableData) do
		local single = SoraDCreatePanel("commonRankingSingle")
		single:setScroll(self.scroll)
		single:addTo(self.scroll)
		_ENV = single.addTo
		single.addTo.model = 1
		_ENV, single.addTo.nameShowType = single, 2
		single.uid = v.uid
		single.iconID = v.iconID
		single.addTo.player, single.avatar = single, v.avatar
		if v.allianceAbbr then
			_ENV = nil
			;(nil).abbr = v.allianceAbbr
			;(nil).name = v.nickName
			if i18n("common_text_186", nil) then
				goto lbl_49
			end
		end
		::lbl_49::
		single.addTo.lineOneName = v.nickName
		if v.allianceName then
			_ENV = nil
			;(nil).conten = v.allianceName
			if i18n("common_text_925", nil) then
				goto lbl_64
			end
		end
		::lbl_64::
		single.addTo.lineTwoName = i18n("common_text_826")
		single.addTo.rank = v.rank
		local single.addTo.score, data = v.score, single.addTo
		_ENV = v.allianceName
		v.allianceName.view = self
		v.allianceName.scroll = self.scroll
		single:initData(data, v.allianceName)
		single:setHandle(handler(self, self.onPlayerClick))
		single:setPosition(cc.p(0, scrollInnerNewH - 110 * i))
	end
	self.ownPosY = scrollInnerNewH - 115 * self.rank - 0.5 * self.scroll:getContentSize().height
	self.scroll:setInnerContainerSize(cc.size(640, scrollInnerNewH))
	self.scroll:jumpToTop()
end
function madeleShareRankView:btnJumpClickCallBack(button, EventType)
	if EventType == ccui.TouchEventType.ended then
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
				if self.rank <= 150 and self.rank > 0 then
					self.scroll:scrollToPercentVertical(scrollPercent + 0.5, 0.2, false)
				end
			end)
			;(0.2)[2] = cca.delay(0.3)
			;(0.2)[3] = cca.callFunc(function(...)
				if self.rank <= 150 and self.rank > 0 then
					self.scroll:scrollToPercentVertical(scrollPercent, 0.1, true)
				end
			end)
			;(0.2)[4] = cca.callFunc(function(...)
				if self.rank <= 150 and self.rank > 0 then
					self.scroll:scrollToPercentVertical(scrollPercent, 0.1, true)
				end
			end)
			self:runAction(cca.seq(0.2))
		end
	end
end
function madeleShareRankView:btnClickReward(button, EventType)
	if EventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
	end
end
function madeleShareRankView:onPlayerClick(data)
	if data.rank == self.rank then
		return
	end
	_UPVALUE3_ = data.rank
	data.rank[1] = chatConst.OpId.OpSendEmail
	data.rank[2] = chatConst.OpId.OpViewInfo
	local data.rank[3], menuData = chatConst.OpId.OpShield, data.rank
	local gametop = gModuleMgr.getObject("gametop")
	local cityCtrl = gametop.playertop_:getModule("cityCtrl")
	local curLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
	if curLevel >= CASTLE_LV10_LIMITED then
		table.insert(menuData, chatConst.OpId.OpSendFlower)
	end
	_ENV = nil
	;(nil).playerId = data.player.uid
	;(nil).nickName = data.player.name
	;(nil).allianceAbbr = data.player.allianceName
	SoraDShowPlayerOperatePanel(data.player.name, menuData, nil)
end
function madeleShareRankView:initMyData()
	local abbr = self.selfInfo.allianceAbbr
	if abbr and abbr ~= "" then
		self.textMyName:setString(string.format("(%s)", abbr) .. i18n(self.selfInfo.nickName))
	else
		self.textMyName:setString(self.selfInfo.nickName)
	end
	self.imageMyHead:setVisible(true)
	self.textMyName:setPositionY(50)
	self.textMyLordName:setVisible(false)
	SoraDGetHeadFromManager(self.imageMyHead, self.selfInfo.iconID, self.selfInfo.avatar)
	self.textMyRank:setVisible(true)
	self.imageRank:setVisible(false)
	local isTopThree = self.selfInfo.rank >= 1 and self.selfInfo.rank <= RANK_TOP_SPECIAL
	if isTopThree then
		self.imageRank:setSpriteFrame("icon_ranking_" .. self.selfInfo.rank .. ".png")
		self.textMyRank:setVisible(false)
		self.imageRank:setVisible(true)
	elseif self.selfInfo.rank and self.selfInfo.rank ~= 0 then
		self.textMyRank:setString(string.formatnumberthousands(self.selfInfo.rank))
	else
		self.textMyRank:setString(i18n("common_text_827"))
	end
	self.textMyNum:setString(string.formatnumberthousands(self.selfInfo.score))
end
return madeleShareRankView
