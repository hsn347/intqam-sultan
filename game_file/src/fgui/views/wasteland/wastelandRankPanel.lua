local WAA = require_data("wasteland_alliance_award", true).data
local wastelandCtrl = SoraDGetCtrl("wastelandCtrl")
local allianceDesRead = include("allianceDesRead")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local wastelandRankPanel = class("wastelandRankPanel", baseFguiPanel)
function wastelandRankPanel:ctor(...)
	self.super.ctor(self, ...)
	print("wastelandRankPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.WASTELAND
end
function wastelandRankPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "wasteland"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
	end
	return self._packageList
end
function wastelandRankPanel:onInit()
	print("=======wastelandRankPanel:onInit")
	self.defaultClick = self.proxy:getDefaultClick()
	self.fields.Panel_bg:setTitle(i18n("common_text_3054"))
	_ENV = i18n("common_text_3054")
	_ENV, _ENV, i18n("common_text_3054").defaultClick = i18n("common_text_3054")
	_ENV, self.defaultClick[1], i18n("common_text_3054").title = i18n("common_text_3054")
	i18n("common_text_3054").tabsetArray, self.defaultClick[2], i18n("common_text_3054").title = self.defaultClick, i18n("common_text_3054")
	i18n("common_text_3054").callback = handler(self, self.onClickTabBtn)
	self.fields.Panel_tabList:initView(i18n("common_text_3054"))
	local Com_rankTitle = self.fields.Com_rankTitle
	Com_rankTitle:fixChildrenPos()
	Com_rankTitle:getChild("Text_rank"):setString(i18n("common_text_3154"))
	Com_rankTitle:getChild("Text_alliance"):setString(i18n("common_text_069"))
	Com_rankTitle:getChild("Text_scroe"):setString(i18n("common_text_3156"))
	local List_rank = self.fields.List_rank
	List_rank:setVirtual()
	List_rank:setItemRenderer(handler(self, self.onRankItemRenderer))
	List_rank:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.onPullUpRelease))
	local index = allianceMgr:hasJoinAlliance() and 0 or 1
	self.controllers.c_hasAlliance:setSelectedIndex(index)
	self.fields.Text_noData:setString(i18n("herobattle_text_05"))
	local Com_myInfo = self.fields.Com_myInfo
	Com_myInfo:getController("c_type"):setSelectedIndex(1)
	Com_myInfo:addClickListener(function(...)
		print("==click Com_myInfo==")
		local rank = self.myInfo.rank
		if rank and 0 < rank and rank < self.iBegin then
			self.fields.List_rank:scrollToView(rank - 1, true, true)
		end
	end)
	self.fields.Text_reward:setString(i18n("Smelt_text_42"))
	local List_reward = self.fields.List_reward
	List_reward:setItemRenderer(handler(self, self.onRewardItemRenderer))
	local group = activityShowCtrl:getParamClassType(self.activityID)
	local _ENV, ret = activityShowCtrl, activityShowCtrl
	for i, v in ipairs(WAA) do
		if v.group == group then
			table.insert(ret, v)
		end
	end
	self.rewardList = ret
	List_reward:setNumItems(#self.rewardList)
end
function wastelandRankPanel:onShow()
	print("=======wastelandRankPanel:onShow")
	self.iBegin = 1
	self.rankList, _ENV, self.myInfo, _ENV, self.nCount = print, print, print, print, 20
	self.hasMore = true
	wastelandCtrl:reqAllianceScoreRank(self.iBegin, self.nCount)
end
function wastelandRankPanel:onHide(...)
	if self.curTabIndex and self.curTabIndex ~= self.defaultClick then
		self.proxy:setDefaultClick(self.curTabIndex)
	end
end
function wastelandRankPanel:onPullUpRelease(...)
	if self.hasMore then
		wastelandCtrl:reqAllianceScoreRank(self.iBegin, self.nCount)
	end
end
function wastelandRankPanel:onClickTabBtn(index)
	self.curTabIndex = index
	self.controllers.c_type:setSelectedIndex(index - 1)
end
function wastelandRankPanel:onRankItemRenderer(index, obj)
	local rank = index + 1
	local data = self.rankList[rank]
	self:refreshRankSingle(obj, rank, data)
end
function wastelandRankPanel:refreshRankSingle(obj, rank, data)
	if not obj.isInit then
		obj.isInit = true
		obj:fixChildrenPos()
	end
	local c_top3 = obj:getController("c_top3")
	local Load_bg = obj:getChild("Load_bg")
	if 0 < rank and rank <= 3 then
		c_top3:setSelectedIndex(0)
		local Load_rank = obj:getChild("Load_rank")
		Load_rank:setURL(string.format("icon_ranking_%d.png", rank))
		Load_bg:setURL(string.format("frame_alliance_pank_%02d.png", rank))
	else
		c_top3:setSelectedIndex(1)
		local Text_rank = obj:getChild("Text_rank")
		if 0 < rank and rank <= 150 then
			Text_rank:setString(tostring(rank))
		else
			Text_rank:setString(i18n("herobattle_text_05"))
		end
		Load_bg:setURL("frame_alliance_pank_04.png")
	end
	if data.aid == self.myInfo.aid then
		Load_bg:setURL("frame_alliance_pank_05.png")
	end
	obj:getChild("Load_flag"):setURL(allianceDesRead.getFlagIcon(data.allianceFlag))
	_ENV = allianceDesRead.getFlagIcon(data.allianceFlag)
	allianceDesRead.getFlagIcon(data.allianceFlag).abbr = data.allianceAbbr
	allianceDesRead.getFlagIcon(data.allianceFlag).name = data.allianceName
	obj:getChild("Text_alliance"):setString(i18n("common_text_186", allianceDesRead.getFlagIcon(data.allianceFlag)))
	obj:getChild("Text_score"):setString(string.formatnumberthousands(data.score))
end
function wastelandRankPanel:onRewardItemRenderer(index, obj)
	if not obj.isInit then
		obj.isInit = true
		obj:fixChildrenPos()
	end
	local data = self.rewardList[index + 1]
	local ranks = data.type
	local c_top3 = obj:getController("c_top3")
	local rankBegin, rankEnd = ranks[1], ranks[2]
	if rankBegin <= 3 then
		c_top3:setSelectedIndex(0)
		local Load_rank = obj:getChild("Load_rank")
		Load_rank:setURL(string.format("icon_ranking_%d.png", rankBegin))
	else
		c_top3:setSelectedIndex(1)
		local Text_rank = obj:getChild("Text_rank")
		if rankBegin == rankEnd then
			Text_rank:setString(tostring(rankBegin))
		else
			Text_rank:setString(string.format("%d-%d", rankBegin, rankEnd))
		end
	end
	local List_item = obj:getChild("List_item")
	_UPVALUE2_ = string.format("%d-%d", rankBegin, rankEnd)
	string.format("%d-%d", rankBegin, rankEnd)[1] = "id"
	string.format("%d-%d", rankBegin, rankEnd)[2] = "count"
	local rewards = serviceFunctions.tableFormat(data.reward, string.format("%d-%d", rankBegin, rankEnd))
	List_item:setItemRenderer(function(index, obj)
		local item = rewards[index + 1]
		obj:initData(item.id, item.count)
	end)
	local space = 8
	local listH = math.ceil(#rewards / 5) * (70 + space) - space
	List_item:setContentSize(cc.size(410, listH))
	List_item:setNumItems(#rewards)
	List_item:scrollToView(0)
end
function wastelandRankPanel:refreshRankData(target, event)
	if self.iBegin == 1 then
		if not event.rspdata.myInfo then
			local allianceMgr, myInfo = event.rspdata.myInfo, event.rspdata.myInfo
		end
		allianceMgr = nil
		;(nil).allianceAbbr = allianceMgr:getAllianceProperty("abbr")
		;(nil).allianceName = allianceMgr:getAllianceProperty("name")
		local (nil).allianceFlag, data = allianceMgr:getAllianceProperty("flag"), nil
		if myInfo then
			data.score = myInfo.score or 0
			self.myInfo = myInfo
		end
		self:refreshRankSingle(self.fields.Com_myInfo, myInfo.rank or 0, data)
	end
	local rankList = event.rspdata.rankList
	table.insertto(self.rankList, rankList)
	local addCount = #rankList
	self.iBegin = self.iBegin + addCount
	if addCount < self.nCount then
		self.hasMore = false
	end
	self.fields.List_rank:setNumItems(#self.rankList)
	if 0 < #self.rankList then
		self.controllers.c_hasData:setSelectedIndex(0)
	else
		self.controllers.c_hasData:setSelectedIndex(1)
	end
end
return wastelandRankPanel
