local activity_9001688_Read = include("activity_9001688_Read")
local activity_9001688_Ctrl = SoraDGetCtrl("activity_9001688_Ctrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001688_RankPanel = class("Activity_9001688_RankPanel", baseFguiPanel)
function Activity_9001688_RankPanel:ctor(...)
	self.isLRU = true
	Activity_9001688_RankPanel.super.ctor(self, ...)
	print("Activity_9001688_RankPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.DAILY_SALUTE
end
function Activity_9001688_RankPanel:onInit()
	print("=======Activity_9001688_RankPanel:onInit")
	self.fields.Com_bg:setGradientColor()
	self.fields.Com_title:initData(i18n("common_text_851"), handler(self, self.onClickClose))
	self.fields.Text_rank:setString(i18n("common_text_2193"))
	self.fields.Text_name:setString(i18n("common_text_3155"))
	self.fields.Text_score:setString(i18n("daily_salute_text25"))
	self.fields.Text_noData:setString(i18n("common_text_927"))
	self.fields.List_award:setVirtual()
	self.fields.List_award:setItemRenderer(handler(self, self.onRewardRenderer))
	self.fields.List_rank:setVirtual()
	self.fields.List_rank:setItemRenderer(handler(self, self.onRankRenderer))
	self.fields.List_rank:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.onPullUpRelease))
	self.fields.Text_rank:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Text_score:fixPos()
end
function Activity_9001688_RankPanel:onRewardRenderer(index, obj)
	obj:initData(self.rankCfg[index + 1])
end
function Activity_9001688_RankPanel:onRankRenderer(index, obj)
	_UPVALUE0_ = index + 1
	;(index + 1).rank = index + 1
	obj:initData(self.rankList[index + 1], index + 1)
end
function Activity_9001688_RankPanel:endShow()
	print("=======Activity_9001688_RankPanel:endShow")
	self.tag = 1
	self.rankCount = 50
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("daily_salute_text15")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("daily_salute_text20")
	;(nil).tabsetArray, self.tag[2], (nil).tag = self.tag, nil, 2
	;(nil).callback = handler(self, self.onTabClick)
	self.fields.Com_title:initTab(nil)
end
function Activity_9001688_RankPanel:onTabClick(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	self:initView()
end
function Activity_9001688_RankPanel:initView()
	if self.tag == 1 then
		self.rankList, activity_9001688_Ctrl, self.rankIndex = self.tag, self.tag, 1
		activity_9001688_Ctrl:reqRank(self.rankIndex, self.rankCount)
		SoraDShowLoading(self)
	elseif self.tag == 2 then
		self.rankCfg = activity_9001688_Read.getRankCfg()
		self.fields.List_award:setNumItems(#self.rankCfg)
	end
end
function Activity_9001688_RankPanel:onPullUpRelease()
	if not self.isEndless then
		activity_9001688_Ctrl:reqRank(self.rankIndex, self.rankCount)
	end
end
function Activity_9001688_RankPanel:rankBack(target, data)
	SoraDCloseLoading(self)
	self.isEndless = #data.rank < self.rankCount
	for k, v in ipairs(data.rank) do
		table.insert(self.rankList, v)
		v.rank = #self.rankList
	end
	self.fields.List_rank:setNumItems(#self.rankList)
	self.fields.Text_noData:setVisible(#self.rankList == 0)
	self.rankIndex = #self.rankList + 1
	if data.myInfo then
		self.myInfo = data.myInfo
	end
	if not self.myInfo then
		local base = lordInfoCtrl:getBaseInfo()
		_ENV = lordInfoCtrl
		lordInfoCtrl.allianceAbbr = allianceMgr:getAllianceProperty("abbr")
		lordInfoCtrl.avatar = base.avatar
		lordInfoCtrl.headid = base.imageId
		lordInfoCtrl.name = base.nickName
		lordInfoCtrl.rank = 0
		lordInfoCtrl.score = 0
		self.myInfo, lordInfoCtrl.uid = lordInfoCtrl, SoraDGetPlayerID()
	end
	self.fields.Com_ownRank:initData(self.myInfo)
end
return Activity_9001688_RankPanel
