local allianceActiveltCtrl = include("allianceActiveltCtrl")
local allianceActiveCtrl = SoraDGetCtrl("allianceActiveCtrl")
local allianceActiveRankView = class("allianceActiveRankView", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("allianceActiveRankView")
end)
function allianceActiveRankView:ctor(properties)
	self.isAllianceRank = true
	self.node = SoraDGetChildByName(self, "Center_Node")
	self.nodeCommonPopBox = SoraDGetExtendChildFromCCSByName(self.node, "CCS_commonPopBox_bg")
	self.nodeCommonPopBox:setTitleName(i18n("alliance_active_text_001"))
	self.btnMemberTab = SoraDGetChildByName(self, "Button_1")
	self.btnAllianceTab = SoraDGetChildByName(self, "Button_2")
	self.textMember = SoraDGetChildByName(self, "Text_Single")
	self.textAlliance = SoraDGetChildByName(self, "Text_Season")
	self.textAlliance:setString(i18n("common_text_069"))
	self.textMember:setString(i18n("pyramid_btn_35"))
	self.btnAllianceTab:setTag(2)
	self.btnMemberTab:setTag(1)
	self.btnAllianceTab:addTouchEventListener(handler(self, self.btnChooseType))
	self.btnMemberTab:addTouchEventListener(handler(self, self.btnChooseType))
	self.nodeCommonTabBtnEX = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_2")
	self.nodeCommonTabBtnEX:setContentSize(cc.size(530, 56))
	self.nodeCommonTabBtnEX:setNewStyle(true)
	self.nodeInfo = SoraDGetChildByName(self.node, "Image_info")
	self.textName = SoraDGetChildByName(self.nodeInfo, "Text_name")
	self.textName:setString(i18n("common_text_264"))
	self.textScore = SoraDGetChildByName(self.nodeInfo, "Text_score")
	self.textScore:setString(i18n("alliance_active_text_005"))
	self.textRank = SoraDGetChildByName(self.nodeInfo, "Text_rank")
	self.textRank:setString(i18n("common_text_2193"))
	self.scrollRank = SoraDGetChildByName(self.node, "ScrollView_rank")
	self.scrollRank = include("commonAutoScrollList").new(self.scrollRank)
	self.scrollRank:setSingleCCS("allianceActiveRankSingle")
	self.textNoRecrod = SoraDGetChildByName(self.node, "Text_noRecrod")
	self.textNoRecrod:setString(i18n("herobattle_text_05"))
	self.nodeRank = SoraDGetChildByName(self, "Node_my")
	self.textMyRank = SoraDGetChildByName(self.nodeRank, "Text_Rank")
	self.textMyNum = SoraDGetChildByName(self.nodeRank, "Text_Num")
	self.textMyName = SoraDGetChildByName(self.nodeRank, "Text_Name")
	self.spriteMyRank = SoraDGetChildByName(self.nodeRank, "Sprite_myRank")
	self.nodeFlag = SoraDGetChildByName(self.nodeRank, "Node_flag")
	self.imageHead = SoraDGetChildByName(self.nodeRank, "Image_Head")
	self.rewardBox = SoraDGetChildByName(self, "Node_RewardBox")
	self.btnPrice = SoraDGetChildByName(self.rewardBox, "Button_price")
	self.btnPrice:addTouchEventListener(handler(self, self.btnPriceClick))
	self.textTips = SoraDGetChildByName(self.rewardBox, "Text_Tips")
	self.textTipsBg = SoraDGetChildByName(self.rewardBox, "Image_TextBg")
	if self:getPanelOffsetHeight() < 940 then
		self.node:setScale(0.9)
	end
	self:initData()
end
function allianceActiveRankView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_ACTIVE_RANK_UPDATE", handler(self, self.updateRank))
end
function allianceActiveRankView:initData(target, data)
	self:btnChooseType(self.btnAllianceTab, ccui.TouchEventType.ended, true)
end
function allianceActiveRankView:btnChooseType(target, eventType, isTest)
	if eventType == ccui.TouchEventType.ended then
		local isAllianceRank = target:getTag() == 2
		if not isTest and self.isAllianceRank == isAllianceRank then
			return
		end
		if not isTest then
			SoraDPlaySound()
		end
		self.isAllianceRank = isAllianceRank
		self.textMember:setColor(not self.isAllianceRank and cc.c3b(255, 200, 100) or cc.c3b(100, 80, 40))
		self.textAlliance:setColor(self.isAllianceRank and cc.c3b(255, 200, 100) or cc.c3b(100, 80, 40))
		self.btnMemberTab:setColor(not self.isAllianceRank and cc.c3b(255, 255, 255) or cc.c3b(120, 120, 120))
		self.btnAllianceTab:setColor(self.isAllianceRank and cc.c3b(255, 255, 255) or cc.c3b(120, 120, 120))
		local _ENV, param = self.btnAllianceTab.setColor, self.btnAllianceTab.setColor
		if self.isAllianceRank then
			_ENV = self.isAllianceRank
			self.isAllianceRank.tabNum = 2
			_ENV, _ENV, self.isAllianceRank.defaultClick = 120, self.isAllianceRank and cc.c3b(255, 255, 255) or cc.c3b(120, 120, 120), 1
			;(120).title = i18n("alliance_active_text_004")
			;(120).handle = handler(self, self.btnTabClick)
			;(120).tag = 1
			_ENV, (self.isAllianceRank and cc.c3b(255, 255, 255) or cc.c3b(120, 120, 120))[1], (120).fontSize = 120, 120, 20
			;(120).title = i18n("alliance_active_text_003")
			;(120).handle = handler(self, self.btnTabClick)
			;(120).tag = 2
			param, self.isAllianceRank.tabsetArray, (self.isAllianceRank and cc.c3b(255, 255, 255) or cc.c3b(120, 120, 120))[2], (120).fontSize = self.isAllianceRank, self.isAllianceRank and cc.c3b(255, 255, 255) or cc.c3b(120, 120, 120), 120, 20
			self:btnTabClick(1)
		else
			_ENV = self.btnTabClick
			self.btnTabClick.tabNum = 3
			_ENV, _ENV, self.btnTabClick.defaultClick = 1, self, 3
			;(1).title = i18n("alliance_active_text_004")
			;(1).handle = handler(self, self.btnTabClick)
			;(1).tag = 3
			_ENV, self[1], (1).fontSize = 1, 1, 20
			;(1).title = i18n("alliance_active_text_003")
			;(1).handle = handler(self, self.btnTabClick)
			;(1).tag = 2
			_ENV, self[2], (1).fontSize = 1, 1, 20
			;(1).title = i18n("alliance_active_text_002")
			;(1).handle = handler(self, self.btnTabClick)
			;(1).tag = 1
			param, self.btnTabClick.tabsetArray, self[3], (1).fontSize = self.btnTabClick, self, 1, 20
			self:btnTabClick(3)
		end
		self.nodeCommonTabBtnEX:initView(param)
	end
end
function allianceActiveRankView:btnTabClick(tag, name)
	self.rIndex = tag
	self:reqRank()
	self.rewardBox:setVisible(self.isAllianceRank and self.rIndex == 2 or not self.isAllianceRank and self.rIndex < 3)
	if not self.isAllianceRank and self.rIndex < 3 then
		self.textTipsBg:setVisible(true)
		self.textTips:setVisible(true)
		self.textTips:ignoreContentAdaptWithSize(true)
		self.textTips:setTextAreaSize(cc.size(0, 0))
		if self.rIndex == 1 then
			_ENV = cc.size(0, 0)
			cc.size(0, 0).num = include("constantRead").getConstValue("ALLIANCE_DAYREWARD_RANK")
			self.textTips:setString(i18n("alliance_active_text_007", cc.size(0, 0)))
		else
			_ENV = i18n("alliance_active_text_007", cc.size(0, 0))
			i18n("alliance_active_text_007", cc.size(0, 0)).num = include("constantRead").getConstValue("ALLIANCE_WEEKREWARD_RANK")
			self.textTips:setString(i18n("alliance_active_text_009", i18n("alliance_active_text_007", cc.size(0, 0))))
		end
		local width = self.textTips:getContentSize().width + 15
		local height = 23
		if 485 <= width then
			width = 485
			height = SoraDGetAutoHeightLabel(self.textTips, 470)
		end
		self.textTipsBg:setContentSize(cc.size(width, height + 14))
	else
		self.textTipsBg:setVisible(false)
		self.textTips:setVisible(false)
	end
end
function allianceActiveRankView:btnPriceClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.isAllianceRank and self.rIndex == 2 then
			SoraDCreatePanel("allianceActiveRandRewardView"):show()
		elseif self.rIndex < 3 then
			_ENV = nil
			;(nil).title = i18n(self.rIndex == 1 and "alliance_active_text_006" or "alliance_active_text_008")
			;(nil).awardList = allianceActiveltCtrl.getActiveMemberRankAward(self.rIndex)
			uiManager:show("CommonRankStageView", nil)
		end
	end
end
function allianceActiveRankView:updateRank(target, data)
	SoraDCloseLoading(self)
	if data.isAllianceRank ~= self.isAllianceRank then
		return
	end
	if not data.rankData.rankInfo then
		local _ENV, rankInfo = data.rankData.rankInfo, data.rankData.rankInfo
	end
	if not data.rankData.selfInfo then
		local _ENV, selfInfo = data.rankData.selfInfo, data.rankData.selfInfo
	end
	_ENV = nil
	;(nil).scroll = self.scrollRank
	;(nil).view = self
	self.scrollRank:updateScrollView(cc.size(640, 100), rankInfo, 1, nil)
	self.textNoRecrod:setVisible(#rankInfo <= 0)
	if next(selfInfo) then
		self.textMyNum:setString(string.formatnumberthousands(selfInfo.point))
		_ENV = string.formatnumberthousands(selfInfo.point)
		string.formatnumberthousands(selfInfo.point).abbr = selfInfo.allianceAbbr
		string.formatnumberthousands(selfInfo.point).name = selfInfo.allianceName
		_ENV = selfInfo.allianceName
		selfInfo.allianceName.name = selfInfo.leaderName
		self.textMyName:setString(i18n("common_text_186", string.formatnumberthousands(selfInfo.point)) .. i18n("common_text_926", selfInfo.allianceName))
		local isTop3 = selfInfo.rank <= RANK_TOP_SPECIAL and 0 < selfInfo.rank
		self.spriteMyRank:setVisible(isTop3)
		self.textMyRank:setVisible(not isTop3)
		if isTop3 then
			self.spriteMyRank:setSpriteFrame(string.format("icon_ranking_%d.png", selfInfo.rank))
		else
			self.textMyRank:setString(0 < selfInfo.rank and selfInfo.rank or i18n("common_text_827"))
		end
		if self.isAllianceRank then
			self.nodeFlag:setVisible(true)
			self.imageHead:setVisible(false)
			self.nodeFlag:removeAllChildren()
			local flag = SoraDGetAllianceFlagByFid(selfInfo.flag or 1)
			flag:addTo(self.nodeFlag)
		else
			self.nodeFlag:setVisible(false)
			self.imageHead:setVisible(true)
			self.textMyName:setString(selfInfo.nickName)
			SoraDGetHeadFromManager(self.imageHead, selfInfo.iconID, selfInfo.avatar or "")
		end
	end
	self.scrollRank:jumpToTop()
end
function allianceActiveRankView:reqRank()
	SoraDShowLoading(self)
	if self.isAllianceRank then
		allianceActiveCtrl:getRank(self.rIndex)
	else
		allianceActiveCtrl:getMemberRank(self.rIndex)
	end
end
return allianceActiveRankView
