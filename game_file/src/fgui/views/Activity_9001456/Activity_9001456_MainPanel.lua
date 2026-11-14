local findMonsterCtrl = SoraDGetCtrl("findMonsterCtrl")
local activity_9001456_Ctrl = SoraDGetCtrl("activity_9001456_Ctrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001456_MainPanel = class("Activity_9001456_MainPanel", baseFguiPanel)
function Activity_9001456_MainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001456_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.FIRE_DRAGON_APPEAR_ACTIVITY
end
function Activity_9001456_MainPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function Activity_9001456_MainPanel:onInit()
	print("=======Activity_9001456_MainPanel:onInit")
	local ui = self.fields
	ui.Com_title:initData(i18n("activity_name_9001456"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	ui.Label_time:initCommonActivityTime(self.activityID)
	ui.Button_score:setString(i18n("fierydragon_text_6"))
	ui.Button_score:addClickListener(handler(self, self.onClickBtnScore))
	ui.Button_rank:setString(i18n("common_text_2193"))
	ui.Button_rank:addClickListener(handler(self, self.onClickBtnRank))
	ui.Text_noAlliance:setString(i18n("pyramid_text_02"))
	local fierydragonboss = require_data("fierydragonboss", true).data
	_ENV, _ENV = true, "fierydragonboss"
	;(true).bossType = gBossType.fireDragon1
	;(true).name = "fierydragon_text_2"
	_ENV, ("fierydragonboss")[1], (true).des = true, true, "fierydragon_text_4"
	;(true).bossType = gBossType.fireDragon2
	;(true).name = "fierydragon_text_3"
	;("fierydragonboss")[2], (true).des = true, "fierydragon_text_5"
	local config = "fierydragonboss"
	for _type, v in ipairs(config) do
		local _obj = self.fields["Com_des" .. _type]
		local _ui = fguiHelper.get_fields(_obj)
		_ui.Text_name:setString(i18n(v.name))
		local score = activity_9001456_Ctrl:getBossScore(v.bossType)
		_ENV = i18n(v.name)
		i18n(v.name).num = string.formatnumberthousands(score)
		_ui.Text_des:setString(i18n(v.des, i18n(v.name)))
		_ui.Button_go:setString(i18n("common_text_477"))
		_ui.Button_go:setTag(_type)
		_ui.Button_go:addClickListener(handler(self, self.onClickBtnGo))
	end
	self:refreshInfoText()
end
function Activity_9001456_MainPanel:onShow()
	print("=======Activity_9001456_MainPanel:onShow")
	activity_9001456_Ctrl:reqInit()
end
function Activity_9001456_MainPanel:onClickHelp(...)
	SoraDPlaySound()
	_ENV = "fierydragon_text_1"
	;("fierydragon_text_1").align = SoraDFLabelR()
	SoraDShowHelpMsgTip(i18n("fierydragon_text_1"), "fierydragon_text_1")
end
function Activity_9001456_MainPanel:onClickBtnScore(...)
	SoraDPlaySound()
	uiManager:show("Activity_9001456_Score")
end
function Activity_9001456_MainPanel:onClickBtnRank(...)
	SoraDPlaySound()
	uiManager:show("Activity_9001456_Rank")
end
function Activity_9001456_MainPanel:onClickBtnGo(EventContext)
	local _type = EventContext:getSender():getTag()
	local bossType = _type == 1 and gBossType.fireDragon1 or gBossType.fireDragon2
	findMonsterCtrl:sendSearchMapType(gMapObjTypeDef.mapObjTypeBoss, bossType, nil, 1, 2)
	SoraDShowLoading(self:displayObject())
end
function Activity_9001456_MainPanel:refreshInfoText(...)
	local ui = self.fields
	if allianceMgr:hasJoinAlliance() then
		ui.Text_score:setVisible(true)
		ui.Load_icon:setVisible(true)
		ui.Text_rank:setVisible(true)
		ui.Text_noAlliance:setVisible(false)
		local score = activity_9001456_Ctrl:getAllianceScore()
		allianceMgr = nil
		allianceMgr, allianceMgr, (nil).num = score, string.formatnumberthousands(score), string.formatnumberthousands(score)
		string.formatnumberthousands(score).num, score.color = score, "#FFDF89"
		local scoreStr = i18n_html("common_text_1492", nil, (string.formatnumberthousands(score)))
		ui.Text_score:setString(scoreStr)
		local rank = activity_9001456_Ctrl:getAllianceRank()
		if rank == 0 then
			ui.Text_rank:setString(i18n("common_text_827"))
		else
			allianceMgr = i18n("common_text_827")
			allianceMgr, allianceMgr, i18n("common_text_827").rank = rank, string.formatnumberthousands(rank), string.formatnumberthousands(rank)
			string.formatnumberthousands(rank).rank, rank.color = rank, "#FFDF89"
			local rankStr = i18n_html("common_text_3409", i18n("common_text_827"))
			ui.Text_rank:setString(rankStr)
		end
	else
		ui.Text_score:setVisible(false)
		ui.Load_icon:setVisible(false)
		ui.Text_rank:setVisible(false)
		ui.Text_noAlliance:setVisible(true)
	end
	self:updateReward()
end
function Activity_9001456_MainPanel:updateReward(...)
	local showRed = activity_9001456_Ctrl:checkBtnRewardShowRed()
	self.fields.Button_score:setReddot(showRed)
end
return Activity_9001456_MainPanel
