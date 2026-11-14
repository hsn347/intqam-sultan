local activity_9001702_Read = include("activity_9001702_Read")
local activity_9001702_Ctrl = SoraDGetCtrl("activity_9001702_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001702_RewardPanel = class("Activity_9001702_RewardPanel", baseFguiPanel)
function Activity_9001702_RewardPanel:ctor(...)
	self.isLRU = true
	Activity_9001702_RewardPanel.super.ctor(self, ...)
	print("Activity_9001702_RewardPanel:ctor", self.viewName)
end
function Activity_9001702_RewardPanel:onInit()
	print("=======Activity_9001702_RewardPanel:onInit")
	self.fields.Panel_bg:setString(i18n("soldier_rush_text_11"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onRewardItemRenderer))
	self.fields.List_record:setItemRenderer(handler(self, self.onRecordItemRenderer))
	self.fields.Text_noData:setString(i18n("god_beast_text_16"))
end
function Activity_9001702_RewardPanel:endShow()
	print("=======Activity_9001702_RewardPanel:endShow")
	local isStage0 = activity_9001702_Ctrl:checkDoStage0()
	_ENV = activity_9001702_Ctrl
	_ENV, _ENV, activity_9001702_Ctrl.defaultClick = nil, isStage0 and 1 or 2, isStage0 and 1 or 2
	_ENV, (isStage0 and 1 or 2)[1], (nil).title = nil, nil, i18n("Eidal_celebration_text_18")
	activity_9001702_Ctrl.tabsetArray, (isStage0 and 1 or 2)[2], (nil).title = isStage0 and 1 or 2, nil, i18n("Eidal_celebration_text_19")
	local activity_9001702_Ctrl.callback, param = handler(self, self.onClickTab), activity_9001702_Ctrl
	self.fields.com_TabW:initView(param)
end
function Activity_9001702_RewardPanel:onClickTab(tag)
	self.curTag = tag
	self.controllers.viewType:setSelectedIndex(tag - 1)
	if tag == 1 then
		self.fields.List_reward:setNumItems(4)
		self.fields.Text_noData:setVisible(false)
	else
		activity_9001702_Ctrl:reqWinnerRecord()
	end
end
function Activity_9001702_RewardPanel:onRewardItemRenderer(index, obj)
	local c1 = obj:getController("c1")
	c1:setSelectedIndex(index)
	local _fields = fguiHelper.get_fields(obj)
	if index == 0 then
		_fields.Text_value:setString(i18n("Eidal_celebration_text_21"))
	else
		local drawWeight = activity_9001702_Read.getDrawCfgWeight(index)
		_fields.Text_value:setString(drawWeight / 10 .. "%")
	end
	local levelStr = activity_9001702_Read.getLevelStr(index)
	_fields.Text_title:setString(levelStr)
	local _ENV, drawReward = _fields.Text_title.setString, _fields.Text_title.setString
	if index == 0 then
		drawReward = activity_9001702_Read.getDrawReward()
	else
		drawReward = activity_9001702_Read.getDrawCfgReward(index)
	end
	_fields.List:setItemRenderer(function(_index, _obj)
		local data = drawReward[_index + 1]
		_obj:initData(data.id, data.count)
	end)
	_fields.List:setNumItems(#drawReward)
	if not SoraDFIsRA() then
		_fields.Text_title:fixPos()
		_fields.Text_value:fixPos()
	end
end
function Activity_9001702_RewardPanel:onRecordItemRenderer(index, obj)
	local data = self.winnerRecords[index + 1]
	local _fields = fguiHelper.get_fields(obj)
	local titleStr = i18n("Eidal_celebration_text_20") .. "(" .. data.luckNumber .. ")"
	_fields.Text_title:setString(titleStr)
	_fields.Text_date:setString(os.date("!%m-%d", data.time - 86400))
	_fields.Com_head:setHeadSprite(data.headid, data.avatar or "")
	_fields.Text_player:setString(data.playerName)
	local allianceName = data.allianceName or i18n("pyramid_text_02")
	local allianceStr = allianceName
	_fields.Text_alliance:setString(allianceStr)
	local drawReward = activity_9001702_Read.getDrawReward()
	_fields.List:setItemRenderer(function(_index, _obj)
		local data = drawReward[_index + 1]
		_obj:initData(data.id, data.count)
	end)
	_fields.List:setNumItems(#drawReward)
	if not SoraDFIsRA() then
		obj:fixChildrenPos()
	end
end
function Activity_9001702_RewardPanel:onMsgUpdate(target, event)
	local subMsg = event.subMsg
	if subMsg == "winnerRecord" then
		if not event.rspdata then
			_UPVALUE0_ = event.rspdata
		end
		self.winnerRecords = event.rspdata
		self.fields.List_record:setNumItems(#self.winnerRecords)
		self.fields.Text_noData:setVisible(#self.winnerRecords <= 0)
	end
end
return Activity_9001702_RewardPanel
