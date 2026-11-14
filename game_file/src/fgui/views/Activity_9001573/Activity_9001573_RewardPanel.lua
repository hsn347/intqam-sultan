local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001573_RewardPanel = class("Activity_9001573_RewardPanel", baseFguiPanel)
local activity_9001573_Read = include("activity_9001573_Read")
local activity_9001573_Ctrl = SoraDGetCtrl("activity_9001573_Ctrl")
_ENV = "activity_9001573_Ctrl"
;("activity_9001573_Ctrl").personPoint = 1
;("activity_9001573_Ctrl").pointRank = 2
;("activity_9001573_Ctrl").serverReward = 3
local ("activity_9001573_Ctrl").personLucky, viewType = 4, "activity_9001573_Ctrl"
function Activity_9001573_RewardPanel:ctor(...)
	Activity_9001573_RewardPanel.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001573_RewardPanel:ctor", self.viewName)
end
function Activity_9001573_RewardPanel:onInit()
	print("=======Activity_9001573_RewardPanel:onInit")
	_ENV, self.curType = viewType.personPoint, viewType.personPoint
	_ENV = nil
	;(nil).title = i18n("common_text_1232")
	viewType.personPoint[viewType.personPoint], (nil).tag = nil, viewType.personPoint
	_ENV = nil
	;(nil).title = i18n("Celestial_defense_text_025")
	viewType.personPoint[viewType.pointRank], (nil).tag = nil, viewType.pointRank
	_ENV = nil
	;(nil).title = i18n("build_colossus_04")
	viewType.personPoint[viewType.serverReward], (nil).tag = nil, viewType.serverReward
	_ENV = nil
	;(nil).title = i18n("god_beast_text_07")
	viewType.personPoint[viewType.personLucky], (nil).tag = nil, viewType.personLucky
	local tabsetArray = viewType.personPoint
	_ENV = viewType.personLucky
	viewType.personLucky.callback = handler(self, self.btnTabClick)
	viewType.personLucky.defaultClick = self.curType
	viewType.personLucky.tabsetArray = tabsetArray
	self.fields.com_TabW:initView(viewType.personLucky)
	self.fields.Panel_bg:setTitle(i18n("pray_text_11"))
	self.fields.list_pointRank:setItemRenderer(handler(self, self.onPointRankRederer))
	self.fields.list_serverReward:setItemRenderer(handler(self, self.onServerRewardRederer))
	self.fields.list_personLucky:setItemRenderer(handler(self, self.onPersonLuckyRederer))
end
function Activity_9001573_RewardPanel:onShow()
	print("=======Activity_9001573_RewardPanel:onShow")
end
function Activity_9001573_RewardPanel:btnTabClick(tag, name)
	self.curType = tag
	self:initData()
end
function Activity_9001573_RewardPanel:initData()
	local desStr = ""
	if self.curType == viewType.personPoint then
		self.controllers.c1:setSelectedIndex(0)
		desStr = i18n("Celestial_defense_text_028")
		viewType = nil
		;(nil).num = activity_9001573_Ctrl:getMyPoint()
		self.fields.txt_pointDes:setString(i18n("Celestial_defense_text_026", nil))
	elseif self.curType == viewType.pointRank then
		self.controllers.c1:setSelectedIndex(1)
		self.pointRankRewards = activity_9001573_Read.getRewardsByType(2)
		self.fields.list_pointRank:setNumItems(#self.pointRankRewards)
		desStr = i18n("god_beast_text_11")
	elseif self.curType == viewType.serverReward then
		self.controllers.c1:setSelectedIndex(2)
		self.serverRewards = activity_9001573_Read.getRewardsByType(3)
		self.fields.list_serverReward:setNumItems(#self.serverRewards)
		desStr = i18n("Celestial_defense_text_029")
	elseif self.curType == viewType.personLucky then
		self.controllers.c1:setSelectedIndex(3)
		self.personLuckyRewards, viewType = self.controllers.c1.setSelectedIndex, self.controllers.c1.setSelectedIndex
		local rewards1 = activity_9001573_Read.getRewardsByType(4)
		local rewards2 = activity_9001573_Read.getRewardsByType(5)
		for i, v in ipairs(rewards1) do
			table.insert(self.personLuckyRewards, v)
		end
		for i, v in ipairs(rewards2) do
			table.insert(self.personLuckyRewards, v)
		end
		self.fields.list_personLucky:setNumItems(#self.personLuckyRewards)
		desStr = i18n("Celestial_defense_text_030")
	end
	self.fields.tips:setString(desStr)
end
function Activity_9001573_RewardPanel:onPointRankRederer(index, target)
	target:initData(self.pointRankRewards[index + 1])
end
function Activity_9001573_RewardPanel:onServerRewardRederer(index, target)
	target:initData(self.serverRewards[index + 1])
end
function Activity_9001573_RewardPanel:onPersonLuckyRederer(index, target)
	target:initData(self.personLuckyRewards[index + 1])
end
return Activity_9001573_RewardPanel
