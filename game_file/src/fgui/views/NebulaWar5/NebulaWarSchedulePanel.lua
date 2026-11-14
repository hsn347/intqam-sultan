local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local nebulaWarRead = include("nebulaWarRead")
local nebulaWarUtil = include("nebulaWarUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaWarSchedulePanel = class("NebulaWarSchedulePanel", baseFguiPanel)
function NebulaWarSchedulePanel:ctor(...)
	self.isLRU = true
	NebulaWarSchedulePanel.super.ctor(self, ...)
	print("NebulaWarSchedulePanel:ctor", self.viewName)
end
function NebulaWarSchedulePanel:onInit()
	print("=======NebulaWarSchedulePanel:onInit")
	self.fields.Com_title:initData(i18n("nebula_war_text_0635"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function NebulaWarSchedulePanel:onClickHelp()
	SoraDPlaySound()
	uiManager:show("NebulaWarScheduleFAQ")
end
function NebulaWarSchedulePanel:endShow()
	print("=======NebulaWarSchedulePanel:endShow")
	self.curRound = nebulaWarUtil.getScheduleRound()
	local _ENV, tabsetArray = nebulaWarUtil.getScheduleRound(), nebulaWarUtil.getScheduleRound()
	for round = 1, 4 do
		_ENV = nil
		;(nil).title = nebulaWarRead.getRoundName(round)
		;(nil).isGrayed = round > self.curRound
		table.insert(tabsetArray, nil)
	end
	_ENV = (for index)
	;(1).defaultClick = self.curRound
	;(1).tabsetArray = tabsetArray
	local (1).callback, param = handler(self, self.onClickTab), 1
	self.fields.Com_title:initTab(param)
end
function NebulaWarSchedulePanel:onClickTab(tag)
	print("==NebulaWarSchedulePanel:onClickTab==", tag)
	if tag > self.curRound then
		SoraDShowMsgTip(i18n("nebula_war_text_0636"))
		self.fields.Com_title:setTabIndex(self.showRound)
		return
	end
	self.showRound = tag
	local roundAgainst = nebulaActivityCtrl:getRoundAgainst(self.showRound)
	self.groupIdList = roundAgainst
	self.fields.List:setNumItems(math.floor(#self.groupIdList / 2))
end
function NebulaWarSchedulePanel:onItemRenderer(index, obj)
	local _fields = fguiHelper.get_fields(obj)
	local groupId1 = self.groupIdList[index * 2 + 1]
	_fields.Com_group1:initData(groupId1, self.showRound)
	local groupId2 = self.groupIdList[index * 2 + 2]
	_fields.Com_group2:initData(groupId2, self.showRound)
	local state = 1
	if self.curRound > self.showRound then
		state = 3
	elseif self.curRound < self.showRound then
		state = 1
	elseif nebulaWarUtil.checkShowEnterBtn() then
		state = 2
	elseif nebulaWarUtil.checkIsInWarReady() then
		state = 1
	else
		state = 3
	end
	_ENV = nebulaWarUtil.checkIsInWarReady()
	nebulaWarUtil.checkIsInWarReady()[1] = i18n("build_colossus_11")
	nebulaWarUtil.checkIsInWarReady()[2] = i18n("activity_text_05")
	local nebulaWarUtil.checkIsInWarReady()[3], config = i18n("hero_appoint_22"), nebulaWarUtil.checkIsInWarReady()
	_fields.Text_state:setString(config[state])
	obj:getController("state"):setSelectedIndex(state - 1)
end
return NebulaWarSchedulePanel
