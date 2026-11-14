local activity_9001661_Ctrl = SoraDGetCtrl("activity_9001661_Ctrl")
local activity_9001661_Read = include("activity_9001661_Read")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001661_RankPanel = class("Activity_9001661_RankPanel", baseFguiPanel)
function Activity_9001661_RankPanel:ctor(...)
	Activity_9001661_RankPanel.super.ctor(self, ...)
	print("Activity_9001661_RankPanel:ctor", self.viewName)
end
function Activity_9001661_RankPanel:onInit()
	print("=======Activity_9001661_RankPanel:onInit")
	self.selfUid = SoraDGetPlayerID()
	self.tag = 1
	self.fields.Com_title:initData(i18n("bubble_farm_text19"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	local _fields = fguiHelper.get_fields(self.fields.Com_rankTitle)
	_fields.Text_rank:setString(i18n("common_text_2193"))
	_fields.Text_name:setString(i18n("hero_text_93"))
	_fields.Text_count:setString(i18n("bubble_farm_text20"))
	self.fields.Com_rankTitle:fixChildrenPos()
	self.fields.List_rank:setItemRenderer(handler(self, self.onRankItemRenderer))
	self.fields.List_rank:setVirtual()
	self.fields.Text_noData:setString(i18n("herobattle_text_05"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onRewardItemRenderer))
	self.fields.List_reward:setVirtual()
end
function Activity_9001661_RankPanel:onShow()
	print("=======Activity_9001661_RankPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	_ENV, self.tag[1], (nil).title = nil, nil, i18n("Nebulaking_title_06")
	;(nil).tabsetArray, self.tag[2], (nil).title = self.tag, nil, i18n("common_text_1875")
	;(nil).callback = handler(self, self.onClickTab)
	self.fields.com_Tab:initView(nil)
end
function Activity_9001661_RankPanel:onRankItemRenderer(index, obj)
	local data = self.rankInfo[index + 1]
	self:updateRankSingle(obj, data)
end
function Activity_9001661_RankPanel:onRewardItemRenderer(index, obj)
	local data = self.rewards[index + 1]
	_ENV = nil
	;(nil).rank = data.Ranking
	_UPVALUE2_ = nil
	;(nil)[1] = "id"
	;(nil)[2] = "count"
	;(nil).rewards = serviceFunctions.tableFormat(data.Award, nil)
	obj:initData(nil)
end
function Activity_9001661_RankPanel:onClickTab(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	if self.tag == 1 then
		activity_9001661_Ctrl:reqBubbleGrangeRank()
	else
		self.rewards = activity_9001661_Read.getFarmRankConfig()
		self.fields.List_reward:setNumItems(#self.rewards)
	end
end
function Activity_9001661_RankPanel:updateRankSingle(obj, data)
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
	_fields.Text_score:setString(data.lv)
	if data.time and data.time > 0 then
		_fields.Text_time:setString(os.date("!%m-%d %H:%M:%S", data.time))
	else
		_fields.Text_time:setString("")
	end
	if not data.isOwnRank and data.uid == self.selfUid then
		_controllers.c_self:setSelectedIndex(1)
	else
		_controllers.c_self:setSelectedIndex(0)
	end
end
function Activity_9001661_RankPanel:onMsgUpdateData(target, event)
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
			data.lv = selfInfo.lv
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
function Activity_9001661_RankPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("bubble_farm_rule3")
	uiManager:show("RuleView", nil)
end
return Activity_9001661_RankPanel
