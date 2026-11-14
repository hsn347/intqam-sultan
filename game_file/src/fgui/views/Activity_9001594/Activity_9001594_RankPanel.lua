local gametop = gModuleMgr.getObject("gametop")
local activity_9001594_Ctrl = SoraDGetCtrl("activity_9001594_Ctrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local activity_9001594_Read = include("activity_9001594_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001594_RankPanel = class("Activity_9001594_RankPanel", baseFguiPanel)
function Activity_9001594_RankPanel:ctor(...)
	Activity_9001594_RankPanel.super.ctor(self, ...)
	print("Activity_9001594_RankPanel:ctor", self.viewName)
	self.selfUid = gametop.playertop_:getPlayerID() or 0
end
function Activity_9001594_RankPanel:onInit()
	print("=======Activity_9001594_RankPanel:onInit")
	self.fields.Com_title:initData(i18n("datepalm_tree_text51"), handler(self, self.onClickClose))
	local _fields = fguiHelper.get_fields(self.fields.Com_rankTitle)
	_fields.Text_rank:setString(i18n("common_text_2193"))
	_fields.Text_name:setString(i18n("hero_text_93"))
	_fields.Text_count:setString(i18n("datepalm_tree_text52"))
	self.fields.List_rank:setItemRenderer(handler(self, self.onRankItemRenderer))
	self.fields.List_rank:setVirtual()
	self.fields.Text_noData:setString(i18n("herobattle_text_05"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onRewardItemRenderer))
	self.fields.List_reward:setVirtual()
	if not SoraDFIsRA() then
		self.fields.Com_rankTitle:fixChildrenPos()
	end
	_ENV = handler(self, self.onRewardItemRenderer)
	_ENV, _ENV, handler(self, self.onRewardItemRenderer).defaultClick = handler(self, self.onRewardItemRenderer)
	_ENV, handler(self, self.onRewardItemRenderer)[1], handler(self, self.onRewardItemRenderer).title = handler(self, self.onRewardItemRenderer)
	handler(self, self.onRewardItemRenderer).tabsetArray, handler(self, self.onRewardItemRenderer)[2], handler(self, self.onRewardItemRenderer).title = handler(self, self.onRewardItemRenderer)
	handler(self, self.onRewardItemRenderer).callback = handler(self, self.onClickTab)
	self.fields.com_Tab:initView(handler(self, self.onRewardItemRenderer))
end
function Activity_9001594_RankPanel:onShow()
	print("=======Activity_9001594_RankPanel:onShow")
	self.rewards = activity_9001594_Read.getTreeRankConfig()
	self.fields.List_reward:setNumItems(#self.rewards)
	activity_9001594_Ctrl:reqRank()
end
function Activity_9001594_RankPanel:onClickTab(tag)
	print("==Activity_9001594_RankPanel:onClickTab==", tag)
	self.controllers.c1:setSelectedIndex(tag - 1)
end
function Activity_9001594_RankPanel:onRewardItemRenderer(index, obj)
	local data = self.rewards[index + 1]
	_ENV = nil
	;(nil).rank = data.Ranking
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	;(nil).rewards = serviceFunctions.tableFormat(data.Award, nil)
	obj:initData(nil)
end
function Activity_9001594_RankPanel:onRankItemRenderer(index, obj)
	local data = self.rankInfo[index + 1]
	self:updateRankSingle(obj, data)
end
function Activity_9001594_RankPanel:updateRankSingle(obj, data)
	if not obj._fields then
		obj._fields = fguiHelper.get_fields(obj)
		obj._controllers = fguiHelper.get_controllers(obj)
		if not SoraDFIsRA() then
			obj:fixChildrenPos()
		end
	end
	local _fields = obj._fields
	local _controllers = obj._controllers
	_ENV = nil
	;(nil).rank = data.rank
	;(nil).uid = data.uid
	;(nil).isOwnRank = data.isOwnRank
	_fields.Com_rankBase:initRankBaseData(nil)
	_fields.Com_head:setHeadSprite(data.iconID, data.avatar)
	_fields.Com_head:setPlayerID(data.uid)
	local nameStr = textParser.formatPlayerName(data.abbr, data.nickName)
	_fields.Text_name:setString(nameStr)
	_fields.Text_score:setString(string.formatnumberthousands(data.count or 0))
	local time = checkint(data.time)
	if time and 0 < time then
		_fields.Text_time:setString(os.date("!%m-%d %H:%M:%S", time))
	else
		_fields.Text_time:setString("")
	end
	if not data.isOwnRank and data.uid == self.selfUid then
		_controllers.c_self:setSelectedIndex(1)
	else
		_controllers.c_self:setSelectedIndex(0)
	end
end
function Activity_9001594_RankPanel:onMsgUpdateData(target, event)
	local key = event.key
	if key == "rank" then
		if not event.rspdata then
			local lordInfoCtrl, rspdata = event.rspdata, event.rspdata
		end
		local lordInfo = lordInfoCtrl:getLordInfo()
		lordInfoCtrl = lordInfoCtrl
		lordInfoCtrl.isOwnRank = true
		lordInfoCtrl.abbr = lordInfo.abbr
		local lordInfoCtrl.nickName, data = lordInfo.base.nickName, lordInfoCtrl
		local selfInfo = rspdata.selfInfo
		if selfInfo then
			data.rank = selfInfo.rank
			data.count = selfInfo.count
			data.time = selfInfo.time
		end
		self:updateRankSingle(self.fields.Com_own, data)
		if not rspdata.rankInfo then
			lordInfoCtrl = rspdata.rankInfo
		end
		self.rankInfo = rspdata.rankInfo
		self.fields.List_rank:setNumItems(#self.rankInfo)
		self.fields.Text_noData:setVisible(#self.rankInfo <= 0)
	end
end
return Activity_9001594_RankPanel
