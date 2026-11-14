local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local iceWolfCastleCtrl = SoraDGetCtrl("iceWolfCastleCtrl")
local iceWolfCastleRead = include("iceWolfCastleRead")
local basePanel = require("fgui.base.baseFguiPanel")
local iceWolfCastleRankPanel = class("iceWolfCastleRankPanel", basePanel)
function iceWolfCastleRankPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
end
function iceWolfCastleRankPanel:getPackageList()
	if not self._packageList then
		_UPVALUE4_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Activity2112"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function iceWolfCastleRankPanel:onInit()
	self.rankList, _ENV = nil, nil
	self.nCount = 20
	self.rankType = nil
	self.viewType = nil
	self.fields.Panel_bg:setString(i18n("common_text_1875"))
	self.fields.Panel_bg:getChild("text_CloseTips"):setString(i18n("mail_2_text_12"))
	self.fields.rankScroll:setItemRenderer(handler(self, self.onRankItemRenderer))
	self.fields.awardScroll:setItemRenderer(handler(self, self.onAwardItemRenderer))
	self.fields.rankScroll:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.onPullUpRelease))
	self.fields.text_RankName:setString(i18n("common_text_2037"))
	self.fields.text_RankIndex:setString(i18n("common_text_2193"))
	self.fields.text_RankName:fixPos()
	self.fields.text_RankIndex:fixPos()
	self.fields.text_RannkNum:fixPos()
	_ENV = i18n("common_text_2193")
	_ENV, _ENV, i18n("common_text_2193").defaultClick = i18n("common_text_2193")
	i18n("common_text_2193").title = i18n("snowwolf_text_06")
	_ENV, self.proxy.param.type[1], i18n("common_text_2193").tag = i18n("common_text_2193")
	i18n("common_text_2193").title = i18n("snowwolf_text_08")
	i18n("common_text_2193").tabsetArray, self.proxy.param.type[2], i18n("common_text_2193").tag = self.proxy.param.type, i18n("common_text_2193")
	i18n("common_text_2193").callback = handler(self, self.onClickRankTag)
	self.fields.rankTab:initView(i18n("common_text_2193"))
	self.fields.textTips:setString(i18n("temperature_text_06"))
	self.fields.textNoRecord:setString(i18n("common_text_1464"))
end
function iceWolfCastleRankPanel:onShow()
end
function iceWolfCastleRankPanel:onClickRankTag(tag)
	if self.rankType == tag then
		return
	end
	self.rankType = tag
	self.fields.text_RannkNum:setString(i18n(self.rankType == 1 and "snowwolf_text_07" or "snowwolf_text_09"))
	self.viewType = nil
	_ENV = i18n(self.rankType == 1 and "snowwolf_text_07" or "snowwolf_text_09")
	_ENV, _ENV, i18n(self.rankType == 1 and "snowwolf_text_07" or "snowwolf_text_09").defaultClick = i18n(self.rankType == 1 and "snowwolf_text_07" or "snowwolf_text_09")
	i18n(self.rankType == 1 and "snowwolf_text_07" or "snowwolf_text_09").title = i18n("common_text_851")
	_ENV, i18n(self.rankType == 1 and "snowwolf_text_07" or "snowwolf_text_09")[1], i18n(self.rankType == 1 and "snowwolf_text_07" or "snowwolf_text_09").tag = i18n(self.rankType == 1 and "snowwolf_text_07" or "snowwolf_text_09")
	i18n(self.rankType == 1 and "snowwolf_text_07" or "snowwolf_text_09").title = i18n("common_text_1875")
	i18n(self.rankType == 1 and "snowwolf_text_07" or "snowwolf_text_09").tabsetArray, i18n(self.rankType == 1 and "snowwolf_text_07" or "snowwolf_text_09")[2], i18n(self.rankType == 1 and "snowwolf_text_07" or "snowwolf_text_09").tag = i18n(self.rankType == 1 and "snowwolf_text_07" or "snowwolf_text_09")
	i18n(self.rankType == 1 and "snowwolf_text_07" or "snowwolf_text_09").callback = handler(self, self.onClickViewTag)
	self.fields.viewTab:initView(i18n(self.rankType == 1 and "snowwolf_text_07" or "snowwolf_text_09"))
end
function iceWolfCastleRankPanel:onClickViewTag(tag)
	if self.viewType == tag then
		return
	end
	self.viewType = tag
	self.controllers.c1:setSelectedIndex(self.viewType - 1)
	if self.viewType == 1 then
		SoraDShowLoading()
		self.rankList, _ENV, self.iBegin = SoraDShowLoading, SoraDShowLoading, 1
		self.hasMore = true
		self:onPullUpRelease()
	else
		self.fields.textNoRecord:setVisible(false)
		self.awardList = iceWolfCastleRead.getRankAward(self.rankType)
		self.fields.awardScroll:setNumItems(#self.awardList)
		self.fields.awardScroll:jumpToTop()
	end
end
function iceWolfCastleRankPanel:onPullUpRelease(...)
	if self.hasMore then
		iceWolfCastleCtrl = nil
		;(nil).iBegin = self.iBegin
		;(nil).type = self.rankType
		;(nil).nCount = self.nCount
		iceWolfCastleCtrl:reqRamadanShiningCastleActivityRank4(nil)
	end
end
function iceWolfCastleRankPanel:refreshRankData(event)
	if self.iBegin == 1 then
		local lordBaseInfo = lordInfoCtrl:getLordInfo().base
		dump(event.myInfo, "allianceMgr:getAlliance( )")
		lordInfoCtrl = dump
		dump.uid = lordBaseInfo.uid
		dump.name = lordBaseInfo.nickName
		dump.headid = lordBaseInfo.imageId
		dump.avatar = lordBaseInfo.avatar
		local dump.allianceAbb, myInfo = allianceMgr:getAllianceProperty("abbr"), dump
		myInfo.rank = event.myInfo and event.myInfo.rank or 0
		myInfo.num = event.myInfo and event.myInfo.num or 0
		self:updateMyRank(myInfo)
	end
	local rankList = event.rankList
	table.insertto(self.rankList, rankList)
	local addCount = #rankList
	self.iBegin = self.iBegin + addCount
	if addCount < self.nCount then
		self.hasMore = false
	end
	self.fields.rankScroll:setNumItems(#self.rankList)
	if 0 < #self.rankList then
		self.fields.rankScroll:setVisible(true)
		self.fields.textNoRecord:setVisible(false)
	else
		self.fields.rankScroll:setVisible(false)
		self.fields.textNoRecord:setVisible(true)
	end
end
function iceWolfCastleRankPanel:updateMyRank(myInfo)
	if self.viewType == 2 then
		return
	end
	self.fields.com_myRank:initData(myInfo)
end
function iceWolfCastleRankPanel:onRankItemRenderer(index, object)
	_UPVALUE0_ = index + 1
	;(index + 1).index = index + 1
	object:initData(self.rankList[index + 1], index + 1)
end
function iceWolfCastleRankPanel:onAwardItemRenderer(index, object)
	object:initData(self.awardList[index + 1])
end
return iceWolfCastleRankPanel
