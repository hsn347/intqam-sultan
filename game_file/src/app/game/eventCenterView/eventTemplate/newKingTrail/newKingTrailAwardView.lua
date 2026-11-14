local newKingTrailRead = include("newKingTrailRead")
local newKingTrailCtrl = SoraDGetCtrl("newKingTrailCtrl")
local newKingTrailAwardView = class("newKingTrailAwardView", function(target)
	return target or SoraDCreateTouchPanel("newKingTrailAwardView")
end)
function newKingTrailAwardView:ctor()
	self.tableItemsSel, newKingTrailCtrl, self.tableItemsSpare, newKingTrailCtrl, self.selectDay = newKingTrailCtrl:getNowStage(), newKingTrailCtrl:getNowStage(), newKingTrailCtrl:getNowStage(), newKingTrailCtrl:getNowStage(), newKingTrailCtrl:getNowStage()
	self.scrollSingle = SoraDGetChildByName(self, "Node_single")
	self.boxBg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.textTip = SoraDGetChildByName(self, "Text_tip")
	self.textTip:setString(i18n("king_tri_text_15"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_content")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createAwardSingle))
	self.btnTab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_RankAward")
	self.btnTab:setContentSize(cc.size(570, 48))
	local tabLeft, tebRight
	newKingTrailCtrl = cc.size(570, 48)
	cc.size(570, 48).tabNum = 2
	newKingTrailCtrl, newKingTrailCtrl, cc.size(570, 48).defaultClick = cc.size(570, 48)
	cc.size(570, 48).title = i18n("king_tri_text_13")
	cc.size(570, 48).handle = handler(self, self.refreshScroll)
	cc.size(570, 48).fontSize = 20
	cc.size(570, 48).tag = self.selectDay
	newKingTrailCtrl, cc.size(570, 48)[1], cc.size(570, 48).name = cc.size(570, 48)
	cc.size(570, 48).title = i18n("king_tri_text_14")
	cc.size(570, 48).handle = handler(self, self.refreshScroll)
	cc.size(570, 48).fontSize = 20
	cc.size(570, 48).tag = 999
	cc.size(570, 48).tabsetArray, cc.size(570, 48)[2], cc.size(570, 48).name = cc.size(570, 48)
	local data = cc.size(570, 48)
	if self.selectDay == 6 then
		newKingTrailCtrl = handler(self, self.refreshScroll)
		newKingTrailCtrl, newKingTrailCtrl, handler(self, self.refreshScroll).tabNum = self.refreshScroll, self, 1
		self.refreshScroll.title = i18n("king_tri_text_14")
		self.refreshScroll.handle = handler(self, self.refreshScroll)
		self.refreshScroll.fontSize = 20
		self.refreshScroll.tag = 999
		handler(self, self.refreshScroll).tabsetArray, self[1], self.refreshScroll.name = self, self.refreshScroll, tebRight
		self.btnTab:initView((handler(self, self.refreshScroll)))
	else
		self.btnTab:initView(data)
	end
end
function newKingTrailAwardView:createAwardSingle()
	local single = self.scrollSingle:clone()
	return include("newKingTrailAwardSingle").new(single)
end
function newKingTrailAwardView:initScroll()
	local rewardData = newKingTrailRead.getRankReward(self.selectDay)
	newKingTrailRead = nil
	;(nil).view = self
	self.scroll:updateScrollView(cc.size(552, 155), rewardData, 1, nil)
end
function newKingTrailAwardView:refreshScroll(tag, name)
	self.selectDay = tag
	self:initScroll()
end
return newKingTrailAwardView
