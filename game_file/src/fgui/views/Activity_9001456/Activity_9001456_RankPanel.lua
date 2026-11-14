local activity_9001456_Ctrl = SoraDGetCtrl("activity_9001456_Ctrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local allianceDesRead = include("allianceDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001456_RankPanel = class("Activity_9001456_RankPanel", baseFguiPanel)
function Activity_9001456_RankPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001456_RankPanel:ctor", self.viewName)
	self.myInfo, _ENV = print, print
end
function Activity_9001456_RankPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function Activity_9001456_RankPanel:onInit()
	print("=======Activity_9001456_RankPanel:onInit")
	self.fields.Com_title:initData(i18n("Endless_trial_text_04"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.List_rank:setVirtual()
	self.fields.List_rank:setItemRenderer(handler(self, self.onRankItemRenderer))
	self.fields.Text_noData:setString(i18n("herobattle_text_05"))
	self.fields.Text_noAlliance:setString(i18n("pyramid_text_02"))
	self.fields.Text_tip:setString(i18n("Snowman_Activity_06"))
end
function Activity_9001456_RankPanel:onShow()
	print("=======Activity_9001456_RankPanel:onShow")
	activity_9001456_Ctrl:reqRankList()
	SoraDShowLoading(self:displayObject())
end
function Activity_9001456_RankPanel:onClickHelp(...)
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("common_text_828"))
end
function Activity_9001456_RankPanel:onRankItemRenderer(index, obj)
	local rank = index + 1
	local data = self.rankList[rank]
	self:refreshRankSingle(obj, rank, data)
end
function Activity_9001456_RankPanel:refreshRankSingle(obj, rank, data)
	if not obj.fields then
		obj.fields = fguiHelper.get_fields(obj)
		obj.controllers = fguiHelper.get_controllers(obj)
		obj:fixChildrenPos()
		obj.fields.Load_bg:fix()
	end
	self:refreshRankIcon(obj, rank, data)
	self:refreshRankBg(obj, rank, data)
	self:refreshRankInfo(obj, rank, data)
	local rewards = activity_9001456_Ctrl:getRankReward(rank)
	obj.fields.List_rewards:setItemRenderer(function(_index, _object)
		local reward = rewards[_index + 1]
		_object:initData(reward.id, reward.count)
	end)
	obj.fields.List_rewards:setNumItems(#rewards)
end
function Activity_9001456_RankPanel:refreshRankIcon(obj, rank, data)
	if 0 < rank and rank <= 3 then
		obj.controllers.c_top3:setSelectedIndex(0)
		obj.fields.Load_rank:setURL(string.format("icon_ranking_%d.png", rank))
	else
		obj.controllers.c_top3:setSelectedIndex(1)
		if 0 < rank and rank <= 150 then
			obj.fields.Text_rank:setString(tostring(rank))
		else
			obj.fields.Text_rank:setString(i18n("herobattle_text_05"))
		end
	end
end
function Activity_9001456_RankPanel:refreshRankBg(obj, rank, data)
	if 0 < rank and rank <= 3 then
		obj.fields.Load_bg:setURL(string.format("frame_alliance_pank_%02d.png", rank))
	else
		obj.fields.Load_bg:setURL("frame_alliance_pank_04.png")
	end
	if data.aid == self.myInfo.aid then
		obj.fields.Load_bg:setURL("frame_alliance_pank_05.png")
	end
end
function Activity_9001456_RankPanel:refreshRankInfo(obj, rank, data)
	obj.fields.Load_flag:setURL(allianceDesRead.getFlagIcon(data.flag))
	obj.fields.Text_score:setString(data.score)
	allianceDesRead = allianceDesRead.getFlagIcon(data.flag)
	allianceDesRead.getFlagIcon(data.flag).abbr = data.abbr
	allianceDesRead.getFlagIcon(data.flag).name = data.name
	obj.fields.Text_name:setString(i18n("common_text_186", allianceDesRead.getFlagIcon(data.flag)))
end
function Activity_9001456_RankPanel:refreshRankSelf(obj, rank, data)
	if not obj.fields then
		obj.fields = fguiHelper.get_fields(obj)
		obj.controllers = fguiHelper.get_controllers(obj)
		obj:fixChildrenPos()
	end
	self:refreshRankIcon(obj, rank, data)
	self:refreshRankInfo(obj, rank, data)
end
function Activity_9001456_RankPanel:updateRank(rspdata)
	self.rankList = rspdata.list
	if allianceMgr:hasJoinAlliance() then
		self.fields.Text_noAlliance:setVisible(false)
		self.fields.Com_rankSelf:setVisible(true)
		allianceMgr = self.fields.Com_rankSelf.setVisible
		self.fields.Com_rankSelf.setVisible.abbr = allianceMgr:getAllianceProperty("abbr")
		self.fields.Com_rankSelf.setVisible.aid = allianceMgr:getOwnAid()
		self.fields.Com_rankSelf.setVisible.flag = allianceMgr:getAllianceProperty("flag")
		self.fields.Com_rankSelf.setVisible.name = allianceMgr:getAllianceProperty("name")
		self.fields.Com_rankSelf.setVisible.rank = rspdata.rank or 0
		self.myInfo, self.fields.Com_rankSelf.setVisible.score = self.fields.Com_rankSelf.setVisible, rspdata.selfScore and math.floor(rspdata.selfScore) or 0
		self:refreshRankSelf(self.fields.Com_rankSelf, self.myInfo.rank, self.myInfo)
	else
		self.fields.Text_noAlliance:setVisible(true)
		self.fields.Com_rankSelf:setVisible(false)
	end
	self.fields.List_rank:setNumItems(#self.rankList)
	self.fields.Text_noData:setVisible(#self.rankList == 0)
end
return Activity_9001456_RankPanel
