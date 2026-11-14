local activity_9001642_Read = include("activity_9001642_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001642_awardPanel = class("Activity_9001642_awardPanel", baseFguiPanel)
function Activity_9001642_awardPanel:ctor(...)
	Activity_9001642_awardPanel.super.ctor(self, ...)
	print("Activity_9001642_awardPanel:ctor", self.viewName)
end
function Activity_9001642_awardPanel:onInit()
	print("=======Activity_9001642_awardPanel:onInit")
	self.activityID = gActivityTimeActivityID.PHOENIX_CHALLENGE
	self.classType = SoraDGetActivityClassType(self.activityID)
	self.tag = 1
	self.fields.Com_title:initData(i18n("pray_text_11"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Text_tip:setString(i18n("Phonex_Challenge_text_14"))
	self.fields.List:setItemRenderer(handler(self, self.onStageRenderer))
end
function Activity_9001642_awardPanel:onStageRenderer(index, obj)
	obj:initData(self.stageList[index + 1], index + 1, self.tag)
end
function Activity_9001642_awardPanel:onShow()
	print("=======Activity_9001642_awardPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, self.tag, self.tag
	;(nil).title = i18n("accompany_peer_text_06")
	_ENV, self.tag[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("king_tri_text_18")
	_ENV, self.tag[2], (nil).tag = nil, nil, 2
	;(nil).title = i18n("common_text_2194")
	;(nil).tabsetArray, self.tag[3], (nil).tag = self.tag, nil, 3
	;(nil).callback = handler(self, self.onTabClick)
	self.fields.Com_tab:initView(nil)
end
function Activity_9001642_awardPanel:onTabClick(tag)
	self.tag = tag
	self.controllers.c1:setSelectedIndex(self.tag - 1)
	if self.tag == 1 then
	elseif self.tag == 2 then
		self.stageList = activity_9001642_Read.getStageCfg(self.classType)
		self.fields.List:setNumItems(#self.stageList)
		self.fields.List:jumpToTop()
	elseif self.tag == 3 then
		self.stageList = activity_9001642_Read.getRankCfg(self.classType)
		self.fields.List:setNumItems(#self.stageList)
		self.fields.List:jumpToTop()
	end
end
function Activity_9001642_awardPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Phonex_Challenge_text_12")
	uiManager:show("RuleView", nil)
end
return Activity_9001642_awardPanel
