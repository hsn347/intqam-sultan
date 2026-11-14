local activity_9001738_Read = include("activity_9001738_Read")
local activity_9001738_Ctrl = SoraDGetCtrl("activity_9001738_Ctrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local cloneTable = function(data)
	if type(data) ~= "table" then
		return nil
	end
	local _ENV, ret
	for k, v in pairs(data) do
		ret[k] = v
	end
	return ret
end
local getRank = function(data)
	if type(data) ~= "table" then
		return 0
	end
	return tonumber(data.rank) or 0
end
local normalizeRankList = function(list)
	if type(list) ~= "table" then
		_ENV = type(list)
		return (type(list))
	end
	if 0 < #list then
		return list
	end
	local _ENV, indexedList = #list, #list
	for key, data in pairs(list) do
		if type(data) == "table" then
			_ENV = nil
			;(nil).sortKey = tonumber(key) or getRank(data) or 0
			;(nil).data = data
			table.insert(indexedList, nil)
		end
	end
	table.sort(indexedList, function(a, b)
		return a.sortKey < b.sortKey
	end)
	local _ENV, ret = table.sort, table.sort
	for _, item in ipairs(indexedList) do
		table.insert(ret, item.data)
	end
	return ret
end
local getRankList = function(rankData)
	if type(rankData) ~= "table" then
		_ENV = type(rankData)
		return (type(rankData))
	end
	if type(rankData.rank) ~= "table" then
		_ENV = type(rankData.rank)
		return (type(rankData.rank))
	end
	return normalizeRankList(rankData.rank)
end
local getOwnRankFromData = function(rankData)
	if type(rankData) ~= "table" then
		return nil
	end
	return cloneTable(rankData.myInfo)
end
local buildOwnBaseInfo = function()
	if not (lordInfoCtrl and lordInfoCtrl.getBaseInfo) or not lordInfoCtrl:getBaseInfo() then
		local lordInfoCtrl, baseInfo = lordInfoCtrl:getBaseInfo(), lordInfoCtrl:getBaseInfo()
	end
	local levelId = activity_9001738_Ctrl:getMaxLevelId()
	lordInfoCtrl = activity_9001738_Ctrl
	activity_9001738_Ctrl.uid = SoraDGetPlayerID and SoraDGetPlayerID() or nil
	activity_9001738_Ctrl.name = baseInfo.nickName
	activity_9001738_Ctrl.headid = baseInfo.imageId
	activity_9001738_Ctrl.avatar = baseInfo.avatar
	activity_9001738_Ctrl.levelId = levelId
	local activity_9001738_Ctrl.rank, own = 0, activity_9001738_Ctrl
	if lordInfoCtrl and lordInfoCtrl.getMapSourceKid then
		own.kid = lordInfoCtrl:getMapSourceKid()
	end
	if levelId and 0 < levelId then
		own.costTime = activity_9001738_Ctrl:getClearanceTime(levelId)
	end
	return own
end
local mergeOwnInfo = function(own)
	local baseInfo = buildOwnBaseInfo()
	own, buildOwnBaseInfo = cloneTable(own), cloneTable(own)
	own = cloneTable(own) or nil
	for k, v in pairs(baseInfo) do
		if own[k] == nil or own[k] == "" then
			own[k] = v
		end
	end
	if getRank(own) <= 0 then
		own.rank = 0
	end
	own.isOwnRank = true
	return own
end
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001738_RankPanel = class("Activity_9001738_RankPanel", baseFguiPanel)
function Activity_9001738_RankPanel:ctor(...)
	self.isLRU = true
	Activity_9001738_RankPanel.super.ctor(self, ...)
	print("Activity_9001738_RankPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.GREEN_GRASS_FLIP_ACTIVITY
end
function Activity_9001738_RankPanel:onInit()
	print("=======Activity_9001738_RankPanel:onInit")
	self:fixChildrenPos()
	self.rankCount = 50
	self.rankList, _ENV, self.rankIndex = self.fixChildrenPos, self.fixChildrenPos, 1
	self.fields.List_rank:setItemRenderer(handler(self, self.itemRenderer_List_rank))
	self.fields.List_rank:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.onPullUpRelease))
	self.fields.List_reward:setItemRenderer(handler(self, self.itemRenderer_List_reward))
	self.fields.Com_bg:setGradientColor()
	self.fields.Com_title:initData(i18n("common_text_851"), handler(self, self.onClickClose))
	self:initRankTitle()
	self.fields.Text_noData:setString(i18n("fishingmaster_text_07"))
	_ENV = i18n("fishingmaster_text_07")
	i18n("fishingmaster_text_07").defaultClick = 1
	_ENV, _UPVALUE2_, i18n("fishingmaster_text_07").unDefaultClick = i18n("fishingmaster_text_07")
	i18n("fishingmaster_text_07").title = i18n("common_text_851")
	_ENV, i18n("fishingmaster_text_07").tag = i18n("common_text_851"), 1
	i18n("common_text_851").title = i18n("common_text_2194")
	i18n("common_text_851").tag = 2
	i18n("fishingmaster_text_07").tabsetArray, i18n("fishingmaster_text_07")[1] = i18n("fishingmaster_text_07")
	i18n("fishingmaster_text_07").tabsetArray, i18n("fishingmaster_text_07")[2] = i18n("fishingmaster_text_07")
	i18n("fishingmaster_text_07").callback = handler(self, self.onClickTab)
	self.fields.com_Tab:initView(i18n("fishingmaster_text_07"))
end
function Activity_9001738_RankPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("memory_flip_text_01")
	uiManager:show("RuleView", nil)
end
function Activity_9001738_RankPanel:endShow()
	print("=======Activity_9001738_RankPanel:endShow")
	self.fields.com_Tab:setTabIndex(1, true)
end
function Activity_9001738_RankPanel:initRankTitle()
	self.fields.Com_rankTitle.fields.Text_rank:setString(i18n("common_text_2193"))
	self.fields.Com_rankTitle.fields.Text_name:setString(i18n("common_text_264"))
	self.fields.Com_rankTitle.fields.Text_count:setString(i18n("freekick_master_text_08"))
end
function Activity_9001738_RankPanel:onClickTab(tag)
	self.tag = tag or 1
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	if self.tag == 1 then
		self:requestRank(true)
	else
		self:refreshRewardView()
	end
end
function Activity_9001738_RankPanel:requestRank(isRefresh)
	if self.isRankRequesting then
		return
	end
	if isRefresh then
		self.rankList, activity_9001738_Ctrl, self.rankIndex = self.isRankRequesting, self.isRankRequesting, 1
		self.myInfo = nil
		self.isEndless = false
		self.fields.List_rank:setNumItems(0)
		self.fields.Text_noData:setVisible(false)
	end
	self.isRankRequesting = true
	self.requestRankIndex = self.rankIndex
	activity_9001738_Ctrl:reqRankingMsg(self.rankIndex, self.rankCount)
	SoraDShowLoading(self)
end
function Activity_9001738_RankPanel:onPullUpRelease()
	if self.tag == 1 and not self.isEndless then
		self:requestRank(false)
	end
end
function Activity_9001738_RankPanel:itemRenderer_List_rank(index, obj)
	local data = self.rankList[index + 1]
	obj:initData(data, index + 1)
end
function Activity_9001738_RankPanel:itemRenderer_List_reward(index, obj)
	local data = self.rankRewards[index + 1]
	_UPVALUE0_ = nil
	;(nil).type = "rank"
	obj:initData(data, nil)
end
function Activity_9001738_RankPanel:initData()
	if self.tag == 2 then
		self:refreshRewardView()
	else
		activity_9001738_Ctrl = nil
		;(nil).data = activity_9001738_Ctrl:getRankData()
		self:onRankBack(nil)
	end
end
function Activity_9001738_RankPanel:onRankBack(eventData)
	SoraDCloseLoading(self)
	self.isRankRequesting = false
	if self.tag ~= 1 then
		return
	end
	local rankData = eventData and eventData.data or eventData or activity_9001738_Ctrl:getRankData()
	local pageList = getRankList(rankData)
	if 1 >= (self.requestRankIndex or 1) then
		self.rankList, _ENV = self.requestRankIndex or 1, self.requestRankIndex or 1
	end
	for _, data in ipairs(pageList) do
		if getRank(data) <= 0 then
			data.rank = #self.rankList + 1
		end
		table.insert(self.rankList, data)
	end
	self.isEndless = #pageList < self.rankCount
	self.rankIndex = #self.rankList + 1
	self.fields.List_rank:setNumItems(#self.rankList)
	self.fields.Text_noData:setVisible(#self.rankList <= 0)
	local rspOwnInfo = getOwnRankFromData(rankData)
	if rspOwnInfo and next(rspOwnInfo) then
		self.myInfo = rspOwnInfo
	end
	local ownInfo = mergeOwnInfo(self.myInfo)
	self.myInfo = ownInfo
	self.fields.Com_own:initData(ownInfo, getRank(ownInfo), true)
	self.requestRankIndex = nil
end
function Activity_9001738_RankPanel:refreshRewardView()
	self.rankRewards = activity_9001738_Read.getRankCfg(activity_9001738_Ctrl:getClassType())
	self.fields.List_reward:setNumItems(#self.rankRewards)
	self.fields.Text_noData:setVisible(false)
end
return Activity_9001738_RankPanel
