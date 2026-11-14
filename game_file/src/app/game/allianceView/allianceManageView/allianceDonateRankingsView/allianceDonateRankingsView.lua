local gametop = gModuleMgr.getObject("gametop")
local allianceRank = gametop.playertop_:getModule("allianceRank")
local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
local AllianceDonateRankingsView = class("allianceDonateRankingsView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("allianceDonateRankingsView")
	end
	return target
end)
function AllianceDonateRankingsView:ctor()
	self.tabBtn, _ENV, self.tableSpare, _ENV, self.tableRankData, _ENV = nil, nil, nil, nil, nil, nil
	self.timer = nil
	self.ownRank = 0
	self.ownPosY = 0
	self.curType = gARankType.DAY
	self.nodeTitle = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.nodeTitle:setTitle(i18n("common_text_239"))
	self.tabBtn[gARankType.HISTORY] = SoraDGetChildByName(self, "Button_history")
	self.tabBtn[gARankType.DAY] = SoraDGetChildByName(self, "Button_dayly")
	self.tabBtn[gARankType.WEEK] = SoraDGetChildByName(self, "Button_weekly")
	self.tabBtn[gARankType.HISTORY]:setTitleText(i18n("common_text_262"))
	self.tabBtn[gARankType.DAY]:setTitleText(i18n("common_text_260"))
	self.tabBtn[gARankType.WEEK]:setTitleText(i18n("common_text_261"))
	self.tabBtn[gARankType.HISTORY]:setTitleColor(cc.c3b(144, 132, 97))
	self.tabBtn[gARankType.DAY]:setTitleColor(cc.c3b(144, 132, 97))
	self.tabBtn[gARankType.WEEK]:setTitleColor(cc.c3b(144, 132, 97))
	self.labelName = SoraDGetChildByName(self, "Text_name")
	self.labelDonation = SoraDGetChildByName(self, "Text_donation")
	self.labelHonor = SoraDGetChildByName(self, "Text_honor")
	self.labelRank = SoraDGetChildByName(self, "Text_rank")
	self.labelName:setString(i18n("common_text_264"))
	self.labelDonation:setString(i18n("common_text_265"))
	self.labelHonor:setString(i18n("common_text_266"))
	self.nodeTime = SoraDGetChildByName(self, "Node_time")
	self.labelRefreash = SoraDGetChildByName(self, "Text_refreash")
	self.labelRefreash:setString(i18n("common_text_263"))
	self.imgTime = SoraDGetChildByName(self, "Image_time")
	self.labelTime = SoraDGetChildByName(self, "Text_time")
	self.btnInfo = SoraDGetChildByName(self, "Button_info")
	self.btnJump = SoraDGetChildByName(self, "Button_jump")
	self.btnInfo:setVisible(false)
	self.scroll = SoraDGetChildByName(self, "Top_Size_ScrollView_rank")
	self.btnInfo:addTouchEventListener(handler(self, self.btnInfoClickCallBack))
	self.btnJump:addTouchEventListener(handler(self, self.btnJumpClickCallBack))
	self.tabBtn[gARankType.DAY]:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.tabBtn[gARankType.WEEK]:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.tabBtn[gARankType.HISTORY]:addTouchEventListener(handler(self, self.btnClickCallBack))
	self.curBtn = self.tabBtn[gARankType.DAY]
	self.curBtn:setTitleColor(cc.c3b(255, 245, 176))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_GET_DONATE_RANK_SUCCESS", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_ALLIACNE_MEMBER_UPDATE", handler(self, self.updateData))
	allianceRank:reqDonateRank()
	self:updateRank()
	self:btnClickCallBack(self.curBtn, ccui.TouchEventType.ended, true)
end
function AllianceDonateRankingsView:updateRank()
	_ENV = nil
	;(nil).rank = self.ownRank > 0 and self.ownRank or i18n("common_text_827")
	self.labelRank:setString(i18n("common_text_825", nil))
	if self.curType == gARankType.HISTORY then
		self.labelRank:setPositionX(SoraDFPosX(320, 0))
		self.labelRank:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	else
		self.labelRank:setPositionX(SoraDFPosX(530, 0))
		self.labelRank:setTextHorizontalAlignment(SoraDFLabelR())
	end
end
function AllianceDonateRankingsView:updateData()
	self.tableRankData[gARankType.DAY] = allianceRank:getDonateRank(gARankType.DAY)
	self.tableRankData[gARankType.WEEK] = allianceRank:getDonateRank(gARankType.WEEK)
	self.tableRankData[gARankType.HISTORY] = allianceRank:getDonateRank(gARankType.HISTORY)
	self:updateTabBtn(false)
end
function AllianceDonateRankingsView:reloadScrollView(type)
	if self.tableRankData[type] == nil then
		return
	end
	local scrollH = math.max(self.scroll:getContentSize().height, 115 * #self.tableRankData[type])
	for i, v in ipairs(self.tableRankData[type]) do
		local single = self.tableSpare[i]
		if single == nil then
			single = SoraDCreatePanel("allianceDonateRankingsSingle")
			single:setScroll(self.scroll)
			single:addTo(self.scroll)
			self.tableSpare[i] = single
		end
		single:initData(v, i, self.curType)
		single:setPosition(cc.p(320, scrollH - (i - 1) * 115 - 5))
		single:setVisible(true)
		if v:getProperty("uid") == lordInfoCtrl:getLordInfo().base.uid then
			self.ownRank = i
			self:updateRank()
		end
	end
	if #self.tableRankData[type] < #self.tableSpare then
		for i = #self.tableRankData[type] + 1, #self.tableSpare do
			if self.tableSpare[i] then
				self.tableSpare[i]:setVisible(false)
			end
		end
	end
	self.scroll:setInnerContainerSize(cc.size(640, scrollH))
	self.ownPosY = scrollH - 115 * self.ownRank - 0.5 * self.scroll:getContentSize().height
	self.scroll:jumpToTop()
end
function AllianceDonateRankingsView:showQueue()
	self.nodeTime:setVisible(true)
	if self.timer == nil then
		self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
		self:openTimeUp()
	end
end
function AllianceDonateRankingsView:openTimeUp(dt)
	local leftTime = 0
	if self.curType == gARankType.WEEK then
		leftTime = allianceRank:getWeekRankLeftTime()
	elseif self.curType == gARankType.DAY then
		leftTime = allianceRank:getDayRankLeftTime()
	end
	self.labelTime:setString(SoraDConvertSecondToString(leftTime))
	if leftTime <= 0 then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
		allianceRank:reqDonateRank()
	end
end
function AllianceDonateRankingsView:updateTabBtn(tabOpen)
	self.curBtn:setTouchEnabled(tabOpen)
	self.curBtn:setBright(not tabOpen)
	self.curBtn:setTitleColor(tabOpen and cc.c3b(144, 132, 97) or cc.c3b(255, 245, 176))
	if not tabOpen then
		for i, v in ipairs(self.tabBtn) do
			if v == self.curBtn then
				self.curType = i
				self:reloadScrollView(i)
				if i ~= gARankType.HISTORY then
					self:showQueue()
				end
			else
				v:setTouchEnabled(not tabOpen)
				v:setBright(tabOpen)
				v:setTitleColor(not tabOpen and cc.c3b(144, 132, 97) or cc.c3b(255, 245, 176))
			end
		end
	else
		for i, v in ipairs(self.tableSpare) do
			if v then
				v:setVisible(false)
			end
		end
		self.nodeTime:setVisible(false)
		if self.timer then
			SoraDManagerRemoveTimer(self, self.timer)
			self.timer = nil
		end
	end
end
function AllianceDonateRankingsView:btnInfoClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowMsgBox(i18n("common_text_1676"), i18n("common_text_054"))
	end
end
function AllianceDonateRankingsView:btnJumpClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		self.labelRank:setScale(1.0)
		SoraDPlaySound()
		self:stopAllActions()
		local scrollPercent = 100 * (1 - self.ownPosY / (self.scroll:getInnerContainerSize().height - self.scroll:getContentSize().height))
		scrollPercent = math.min(100, math.max(0, scrollPercent))
		local scrollH = self.scroll:getContentSize().height
		if math.abs(self.ownPosY + self.scroll:getInnerContainer():getPositionY()) < 0.5 * scrollH then
			self.scroll:scrollToPercentVertical(scrollPercent, 0.2, true)
		else
			_UPVALUE2_ = 0.2
			;(0.2)[1] = cca.callFunc(function(...)
				self.scroll:scrollToPercentVertical(scrollPercent + 0.5, 0.2, false)
			end)
			;(0.2)[2] = cca.delay(0.3)
			;(0.2)[3] = cca.callFunc(function(...)
				self.scroll:scrollToPercentVertical(scrollPercent, 0.1, true)
			end)
			;(0.2)[4] = cca.callFunc(function(...)
				self.scroll:scrollToPercentVertical(scrollPercent, 0.1, true)
			end)
			self:runAction(cca.seq(0.2))
		end
	elseif type == ccui.TouchEventType.began then
		self.labelRank:setScale(1.1)
	elseif type == ccui.TouchEventType.canceled then
		self.labelRank:setScale(1.0)
	end
end
function AllianceDonateRankingsView:btnClickCallBack(button, type, isTest)
	if type == ccui.TouchEventType.ended then
		if not isTest then
			SoraDPlaySound()
		end
		self:updateTabBtn(true)
		self.curBtn = button
		self:updateTabBtn(false)
		self.btnInfo:setVisible(self.curBtn == self.tabBtn[gARankType.WEEK])
	end
end
return AllianceDonateRankingsView
