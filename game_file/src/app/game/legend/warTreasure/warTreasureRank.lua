local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local publicRead = include("publicRead")
local warTreasureCtrl = SoraDGetCtrl("warTreasureCtrl")
local warTreasureRank = class("warTreasureRank", function(target)
	return target or SoraDCreateTouchPanel("warTreasureRank")
end)
function warTreasureRank:ctor()
	_UPVALUE3_ = nil
	self.ocxNum, (nil)[1] = nil, "icon_ranking_1.png"
	self.ocxNum, (nil)[2] = nil, "icon_ranking_2.png"
	self.ocxNum, (nil)[3] = nil, "icon_ranking_3.png"
	self.itemID = 827101
	self.itemSize = cc.size(536, 100)
	self.popBox = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.popBox:setTitleName(i18n("warSecrit_title_02"))
	self.singleNode = SoraDGetChildByName(self, "Node_Rank")
	self.scroll = SoraDGetChildByName(self, "ScrollView_item")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createSingle))
	self.Text_noRecrod = SoraDGetChildByName(self, "Text_noRecrod")
	self.ranTitle = SoraDGetChildByName(self, "Text_Rank")
	self.nameTitle = SoraDGetChildByName(self, "Text_Name")
	self.numTitle = SoraDGetChildByName(self, "Text_Point")
	self.ccs_tab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX")
	self.ccs_tab:setContentSize(cc.size(538, 56))
	self.ccs_tab:setNewStyle()
	_ENV = cc.size(538, 56)
	_ENV, _ENV, cc.size(538, 56).tabNum = cc.size(538, 56)
	cc.size(538, 56).title = i18n("warSecrit_title_03")
	cc.size(538, 56).handle = handler(self, self.btnClickTab)
	_ENV, cc.size(538, 56)[1], cc.size(538, 56).tag = cc.size(538, 56)
	cc.size(538, 56).title = i18n("warSecrit_title_04")
	cc.size(538, 56)[2], cc.size(538, 56).handle = cc.size(538, 56)
	cc.size(538, 56).tabsetArray, cc.size(538, 56).tag = cc.size(538, 56)
	self.ccs_tab:initView(cc.size(538, 56))
	self.nodeMyLord = SoraDGetChildByName(self, "Node_Lord")
	self.txtMyInt = SoraDGetChildByName(self.nodeMyLord, "Text_myNum")
	self.txtMyRank = SoraDGetChildByName(self.nodeMyLord, "Text_myRank")
	self.spMyRank = SoraDGetChildByName(self.nodeMyLord, "Sprite_myRank")
	self.itemIcon = SoraDGetChildByName(self.nodeMyLord, "item_Icon")
	self.Text_myName = SoraDGetChildByName(self.nodeMyLord, "Text_myName")
	self.btnJumpToSelf = SoraDGetChildByName(self, "Button_jump")
	self.btnJumpToSelf:addTouchEventListener(handler(self, self.btnClickJump))
	self.ranTitle:setString(i18n("common_text_2193"))
	self.nameTitle:setString(i18n("rides_title_03"))
	self.Text_noRecrod:setString(i18n("god_beast_text_16"))
end
function warTreasureRank:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_LORDINFO_BY_UID", handler(self, self.serverMessageGetLordInfo))
	SoraDAddMessage(self, "MESSAGE_WAR_TREASURE_REFRESH", handler(self, self.updataDataRank))
end
function warTreasureRank:createSingle(info, index)
	local single = self.singleNode:clone()
	return include("commonRankingSingle").new(single)
end
function warTreasureRank:updataDataRank(target, data)
	if data.subMsg == "rankDonateList" then
		SoraDCloseLoading(self)
		if not data.rankList.rankList then
			_ENV = data.rankList.rankList
		end
		self.rankInfo = data.rankList.rankList
		if not data.rankList.myInfo then
			_ENV = data.rankList.myInfo
		end
		self.myRankInfo = data.rankList.myInfo
		self.rank = self.myRankInfo.rank or 0
		self.myScore = self.myRankInfo.num or 0
		self:initMyRank()
		local _ENV, tmp = self.initMyRank, self.initMyRank
		for i, v in ipairs(self.rankInfo) do
			_ENV = nil
			;(nil).model = 1
			;(nil).nameShowType = 1
			;(nil).btnClickType = 3
			_ENV, (nil).notToCenter = nil, true
			;(nil).uid = v.uid
			;(nil).iconID = v.imageId
			;(nil).avatar = v.avatar
			;(nil).player, (nil).aid = nil, v.aid
			if v.allianceAbb then
				_ENV = nil
				;(nil).abbr = v.allianceAbb
				;(nil).name = v.name
				if i18n("common_text_186", nil) then
					goto lbl_67
				end
			end
			::lbl_67::
			;(nil).lineOneName = v.name
			;(nil).rank = i
			;(nil).score = v.num
			;(nil).iconScale = 0.4
			;(nil).icon = publicRead.getIcon(self.itemID)
			local (nil).selfRank, singleData = self.rank, nil
			table.insert(tmp, singleData)
		end
		if self.rankInfo and next(self.rankInfo) then
			self.scroll:setVisible(true)
			_ENV = nil
			;(nil).scroll = self.scroll
			;(nil).view = self
			self.scroll:updateScrollView(cc.size(536, 90), tmp, 1, nil)
			self.scroll:jumpToTop()
			self.Text_noRecrod:setVisible(false)
		else
			self.scroll:setVisible(false)
			self.Text_noRecrod:setVisible(true)
		end
	end
end
function warTreasureRank:initMyRank()
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
	if lordInfo.abbr ~= "" then
		_ENV = nil
		;(nil).abbr = lordInfo.abbr
		;(nil).name = lordInfo.base.nickName
		if i18n("common_text_186", nil) then
			goto lbl_23
		end
	end
	::lbl_23::
	self.Text_myName:setString(lordInfo.base.nickName)
	self.itemIcon:loadTexture(publicRead.getIcon(self.itemID), ccui.TextureResType.plistType)
	self.nodeMyLord:setVisible(true)
	switchNum(self.rank)
	if self.rank <= 0 then
		self.txtMyRank:setString(i18n("common_text_827"))
		SoraDGetAutoHeightLabel(self.txtMyRank, 92)
	end
	self.txtMyInt:setString(string.formatnumberthousands(self.myScore))
end
function warTreasureRank:btnClickJump(button, EventType)
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
function warTreasureRank:setDefaultClick(type)
	self.itemID = type
	print("warTreasureRank:setDefaultClick", type)
	self.ccs_tab:setDefaultClick(tonumber(type) == 827101 and 1 or 2)
end
function warTreasureRank:btnClickTab(tag, name)
	self.itemID = tag == 1 and 827101 or 827201
	self.numTitle:setString(i18n(tag == 1 and "warSecrit_text_06" or "warSecrit_text_12"))
	_ENV = i18n(tag == 1 and "warSecrit_text_06" or "warSecrit_text_12")
	i18n(tag == 1 and "warSecrit_text_06" or "warSecrit_text_12").type = tag
	i18n(tag == 1 and "warSecrit_text_06" or "warSecrit_text_12").iBegin = 1
	i18n(tag == 1 and "warSecrit_text_06" or "warSecrit_text_12").nCount = 50
	warTreasureCtrl:reqWarTreasureDonateRank(i18n(tag == 1 and "warSecrit_text_06" or "warSecrit_text_12"))
end
function warTreasureRank:serverMessageGetLordInfo(target, data)
	SoraDCloseLoading(self)
	if data and data.lord then
		SoraDOpenLordView(data.lord)
	end
end
return warTreasureRank
