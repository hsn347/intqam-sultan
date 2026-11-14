local activity_9001735_Read = include("activity_9001735_Read")
local activity_9001735_Ctrl = SoraDGetCtrl("activity_9001735_Ctrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001735_RankPanel = class("Activity_9001735_RankPanel", baseFguiPanel)
function Activity_9001735_RankPanel:ctor(...)
	self.isLRU = true
	Activity_9001735_RankPanel.super.ctor(self, ...)
	print("Activity_9001735_RankPanel:ctor", self.viewName)
end
function Activity_9001735_RankPanel:onInit()
	print("=======Activity_9001735_RankPanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_851"), handler(self, self.onClickClose))
	self.fields.Text_noData:setString(i18n("fishingmaster_text_07"))
	self.fields.Text_noData:setVisible(false)
	self.fields.List_rank:setVirtual()
	self.fields.List_rank:setItemRenderer(handler(self, self.onRankItemRenderer))
	self.fields.List_rank:addEventListener(fgui.UIEventType.PullUpRelease, handler(self, self.onPullUpRelease))
	self.fields.List_reward:setVirtual()
	self.fields.List_reward:setItemRenderer(handler(self, self.onRewardItemRenderer))
	self.fields.Text_rank:setString(i18n("common_text_2193"))
	self.fields.Text_name:setString(i18n("common_text_264"))
	self.fields.Text_count:setString(i18n("freekick_master_text_08"))
	self.fields.Text_rank:fixPos()
	self.fields.Text_name:fixPos()
	self.fields.Text_count:fixPos()
end
function Activity_9001735_RankPanel:endShow()
	print("=======Activity_9001735_RankPanel:endShow")
	self.tabIndex = 0
	self.isInit = true
	self.rewardList, _ENV, self.rankList, _ENV, self.rankCount = print, print, print, print, 50
	self.selfRank = 0
	self.selfScore = 0
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tabIndex, self.tabIndex
	;(nil).title = i18n("common_text_851")
	_ENV, self.tabIndex[1], (nil).tag = nil, nil, 0
	;(nil).title = i18n("common_text_2194")
	;(nil).tabsetArray, self.tabIndex[2], (nil).tag = self.tabIndex, nil, 1
	;(nil).callback = handler(self, self.onClickTab)
	self.fields.com_Tab:initView(nil)
end
function Activity_9001735_RankPanel:onClickTab(tag)
	self.tabIndex = tag
	self.controllers.c1:setSelectedIndex(self.tabIndex)
	self:updateUI()
end
function Activity_9001735_RankPanel:updateUI()
	if self.tabIndex == 0 then
		if self.isInit then
			self.isInit = false
			self.rankList, activity_9001735_Ctrl, self.rankIndex = self.isInit, self.isInit, 1
			activity_9001735_Ctrl:reqRanking(self.rankIndex, self.rankCount)
			SoraDShowLoading(self)
		else
			self:updateRankView()
		end
	elseif self.tabIndex == 1 then
		self.fields.Text_noData:setVisible(false)
		self.rewardList = activity_9001735_Read.getRankCfg()
		self.fields.List_reward:setNumItems(#self.rewardList)
	end
end
function Activity_9001735_RankPanel:onPullUpRelease()
	if not self.isEndless then
		activity_9001735_Ctrl:reqRanking(self.rankIndex, self.rankCount)
	end
end
function Activity_9001735_RankPanel:rankMsgBack(target, data)
	SoraDCloseLoading(self)
	if not data.rspdata.rank then
		local _ENV, rank = data.rspdata.rank, data.rspdata.rank
	end
	self.isEndless = #rank < self.rankCount
	for _, v in ipairs(rank) do
		table.insert(self.rankList, v)
		v.rank = #self.rankList
	end
	self.rankIndex = #self.rankList + 1
	if data.rspdata.myInfo then
		self.myInfo = data.rspdata.myInfo
	end
	self:updateRankView()
end
function Activity_9001735_RankPanel:updateRankView()
	self.fields.List_rank:setNumItems(#self.rankList)
	self.fields.Text_noData:setVisible(#self.rankList == 0)
	if self.myInfo then
		local base = lordInfoCtrl:getBaseInfo()
		_UPVALUE4_ = lordInfoCtrl
		_UPVALUE4_, lordInfoCtrl[1] = "avatar", "avatar"
		_UPVALUE4_, lordInfoCtrl[2] = "avatar", "headid"
		_UPVALUE4_, lordInfoCtrl[3] = "avatar", "kid"
		local _UPVALUE4_, lordInfoCtrl[4], addParam = "avatar", "name", lordInfoCtrl
		;("avatar")[1] = "avatar"
		;("avatar")[2] = "imageId"
		;("avatar")[3] = "kid"
		local ("avatar")[4], baseKey = "nickName", "avatar"
		for i, v in ipairs(addParam) do
			if not self.myInfo[v] then
				self.myInfo[v] = base[baseKey[i]]
			end
		end
		self.fields.Com_self:initData(self.myInfo, true)
	end
end
function Activity_9001735_RankPanel:onRankItemRenderer(index, obj)
	obj:initData(self.rankList[index + 1])
end
function Activity_9001735_RankPanel:onRewardItemRenderer(index, obj)
	obj:initData(self.rewardList[index + 1])
end
return Activity_9001735_RankPanel
