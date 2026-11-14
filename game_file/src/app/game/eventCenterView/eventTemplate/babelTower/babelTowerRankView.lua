local constantRead = include("constantRead")
local babelTowerCtrl = SoraDGetCtrl("babelTowerCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local babelTowerRead = gModuleMgr.sharedMgr("babelTowerRead")
local babelTowerRankView = class("babelTowerRankView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateBasePanel(target)
	end
	return target or SoraDCreateBasePanel("babelTowerRankView")
end)
function babelTowerRankView:onEnterPanel()
	SoraDShowLoading(self)
	babelTowerCtrl:reqTowerRank()
end
function babelTowerRankView:ctor(properties)
	_UPVALUE3_ = nil
	self.ocxNum, (nil)[1] = nil, "icon_ranking_1.png"
	self.ocxNum, (nil)[2] = nil, "icon_ranking_2.png"
	self.ocxNum, (nil)[3] = nil, "icon_ranking_3.png"
	self.nodeMyLord = SoraDGetChildByName(self, "Node_Lord")
	self.imgMyLord = SoraDGetChildByName(self, "Image_myHead")
	self.spMyRank = SoraDGetChildByName(self, "Sprite_myRank")
	self.textMyRank = SoraDGetChildByName(self, "Text_myRank")
	self.textMyNum = SoraDGetChildByName(self, "Text_myNum")
	self.textMyTime = SoraDGetChildByName(self, "Text_myTime")
	self.textMyName = SoraDGetChildByName(self, "Text_myName")
	self.btnJump = SoraDGetChildByName(self, "Button_jump")
	self.btnJump:addTouchEventListener(handler(self, self.btnJumpClick))
	self.btnMoreReward = SoraDGetChildByName(self, "btn_moreReward")
	self.btnMoreReward:addTouchEventListener(handler(self, self.btnMoreRewardClick))
	self.textRankReward = SoraDGetChildByName(self, "Text_RankReward")
	self.textTime = SoraDGetChildByName(self, "Text_Time")
	self.textFloor = SoraDGetChildByName(self, "Text_Floor")
	self.textRank = SoraDGetChildByName(self, "Text_Rank")
	self.textName = SoraDGetChildByName(self, "Text_Name")
	self.scrollRank = SoraDGetChildByName(self, "Size_ScrollView_rank")
	self.scrollRank = include("commonAutoScrollList").new(self.scrollRank)
	self.scrollRank:setSingleCCS("babelTowerRankSingle")
	self.scrollRank:setSingleRefresh(handler(self, self.refreshScrollSingle))
	self.textNotice = SoraDGetChildByName(self.scrollRank, "Text_notice")
	self.textTips = SoraDChangeTextToHtml(SoraDGetChildByName(self, "Text_Tips"))
	_ENV = SoraDGetChildByName(self, "Text_Tips")
	SoraDGetChildByName(self, "Text_Tips").var = include("constantRead").getConstValue("TONGTIAN_TOWER_RANK_MIN_FLOOR")
	self.textTips:setString(i18n_html("Promise_Summit_text_46", SoraDGetChildByName(self, "Text_Tips")))
	self.nodeCommonFramTitle = SoraDGetExtendChildFromCCSByName(self, "Top_CCS_commonFramTitle")
	self.nodeCommonFramTitle:setTitle(i18n("common_text_851"))
	self.textRankReward:setString(i18n("common_text_2194"))
	self.textTime:setString(i18n("Promise_Summit_text_04"))
	SoraDSetTextWidthHeight(self.textTime, cc.size(140, 24))
	self.textFloor:setString(i18n("Promise_Summit_text_03"))
	SoraDSetTextWidthHeight(self.textFloor, cc.size(140, 24))
	self.textRank:setString(i18n("common_text_2193"))
	self.textName:setString(i18n("common_text_3155"))
end
function babelTowerRankView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
	SoraDAddMessage(self, "MESSAGE_BABEL_TOWER_REFRESH", handler(self, self.updataScrollData))
end
function babelTowerRankView:updataScrollData(target, data)
	if data.subMsg == "rank" then
		SoraDCloseLoading(self)
		if not data.infoData.userRank then
			_ENV = data.infoData.userRank
		end
		self.selfRankInfo = data.infoData.userRank
		if not data.infoData.rankList then
			_ENV = data.infoData.rankList
		end
		self.rankInfo = data.infoData.rankList
		self.rank = self.selfRankInfo.rankIndex or 0
		dump(data.infoData, "rank.infoData", 10)
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
			if v.aname then
				_ENV = nil
				;(nil).abbr = v.aname
				;(nil).name = v.name
				if i18n("common_text_186", nil) then
					goto lbl_63
				end
			end
			::lbl_63::
			;(nil).lineOneName = v.name
			;(nil).rank = i
			;(nil).score = v.floor
			;(nil).selfRank = self.rank
			local (nil).time, singleData = v.time, nil
			table.insert(tmp, singleData)
		end
		_ENV = nil
		;(nil).scroll = self.scrollRank
		;(nil).view = self
		self.scrollRank:updateScrollView(cc.size(640, 112), tmp, 1, nil)
		self.scrollRank:jumpToTop()
	end
end
local MAX_RANK = 100
function babelTowerRankView:initMyRank()
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
	self.textMyName:setString(lordInfo.base.nickName)
	if self.rank <= 0 then
		switchNum(0)
		self.textMyRank:setString(i18n("common_text_827"))
		SoraDGetAutoHeightLabel(self.textMyRank, 92)
		self.textMyTime:setVisible(false)
		local floor = self.selfRankInfo.floor or 0
		if floor == 0 then
			self.textMyRank:setString("—")
		end
		self.textMyNum:setString(floor)
		if self.selfRankInfo.time then
			self.textMyTime:setVisible(true)
			self.textMyTime:setString(os.date("!%Y-%m-%d %H:%M:%S", self.selfRankInfo.time))
		end
	else
		self.textMyTime:setVisible(true)
		switchNum(self.rank)
		local floor = self.rankInfo[tonumber(self.rank)].floor or 0
		self.textMyNum:setString(floor)
		self.textMyTime:setString(os.date("!%Y-%m-%d %H:%M:%S", self.rankInfo[tonumber(self.rank)].time))
	end
end
function babelTowerRankView:refreshScrollSingle(single, data, otherData)
	single:initData_imp(data, otherData)
end
function babelTowerRankView:btnJumpClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		self:stopAllActions()
		SoraDPlaySound()
		self.ownPosY = self.scrollRank:getInnerContainerSize().height - 112 * self.rank - 0.5 * self.scrollRank:getContentSize().height
		local scrollPercent = 100 * (1 - self.ownPosY / (self.scrollRank:getInnerContainerSize().height - self.scrollRank:getContentSize().height))
		scrollPercent = math.min(100, math.max(0, scrollPercent))
		local scrollH = self.scrollRank:getContentSize().height
		if math.abs(self.ownPosY + self.scrollRank:getInnerContainer():getPositionY()) < 0.5 * scrollH then
			self.scrollRank:scrollToPercentVertical(scrollPercent, 0.2, true)
		else
			_UPVALUE2_ = 0.2
			;(0.2)[1] = cca.callFunc(function(...)
				if self.rank <= 100 and self.rank > 0 then
					self.scrollRank:scrollToPercentVertical(scrollPercent + 0.5, 0.2, false)
				end
			end)
			;(0.2)[2] = cca.delay(0.3)
			;(0.2)[3] = cca.callFunc(function(...)
				if self.rank <= 100 and self.rank > 0 then
					self.scrollRank:scrollToPercentVertical(scrollPercent, 0.1, true)
				end
			end)
			;(0.2)[4] = cca.callFunc(function(...)
				if self.rank <= 100 and self.rank > 0 then
					self.scrollRank:scrollToPercentVertical(scrollPercent, 0.1, true)
				end
			end)
			self:runAction(cca.seq(0.2))
		end
	end
end
function babelTowerRankView:btnMoreRewardClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local tag = target:getTag()
		local panel = SoraDCreatePanel("commonRankAwardView")
		panel:setDownTip(i18n("Promise_Summit_text_47"))
		panel:initData(babelTowerRead:getRankReward())
		panel:show()
	end
end
function babelTowerRankView:serverMessageGetLordInfo(target, data)
	SoraDCloseLoading(self)
	if data and data.lord then
		SoraDOpenLordView(data.lord)
	end
end
return babelTowerRankView
