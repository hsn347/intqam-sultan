local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaCompetitionBattlePanel = class("NebulaCompetitionBattlePanel", baseFguiPanel)
local nebulaCompetitionCtrl = SoraDGetCtrl("nebulaCompetitionCtrl")
local nebulaCompetitionRead = include("nebulaCompetitionRead")
function NebulaCompetitionBattlePanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaCompetitionBattlePanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
end
function NebulaCompetitionBattlePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaCompetitionBattlePanel:onInit()
	print("=======NebulaCompetitionBattlePanel:onInit")
	self.fields.Com_title:initData(i18n("Nebula_Competition_text_09"), handler(self, self.onClickClose))
	self.fields.text_final_battle:setString(i18n("Nebula_Competition_text_12"))
	_ENV = i18n("Nebula_Competition_text_12")
	_ENV, _ENV, i18n("Nebula_Competition_text_12").defaultClick = i18n("Nebula_Competition_text_12")
	i18n("Nebula_Competition_text_12").title = i18n("Nebula_Competition_text_10")
	_ENV, i18n("Nebula_Competition_text_12")[1], i18n("Nebula_Competition_text_12").tag = i18n("Nebula_Competition_text_12")
	i18n("Nebula_Competition_text_12").title = i18n("Nebula_Competition_text_11")
	i18n("Nebula_Competition_text_12").tabsetArray, i18n("Nebula_Competition_text_12")[2], i18n("Nebula_Competition_text_12").tag = i18n("Nebula_Competition_text_12")
	i18n("Nebula_Competition_text_12").callback = handler(self, self.onClickTabItem)
	self.fields.Com_tab:initView(i18n("Nebula_Competition_text_12"))
	self.curChooseTab = 1
	self.fields.ani_top:setAllFrameName("dh_xmdk_add_ss_%02d.png", 1)
	self.fields.ani_top:setPlaySettings(0, -1, -1)
	self.fields.list_battle:setItemRenderer(handler(self, self.onBattlesRender))
	self.fields.list_reward:setItemRenderer(handler(self, self.onRewardsRender))
	self.rewardCfgs, _ENV = self.fields.list_reward.setItemRenderer, self.fields.list_reward.setItemRenderer
	local groupId = nebulaCompetitionCtrl:getGroupId()
	local groupCfg = nebulaCompetitionRead.getGroupCfg(groupId)
	self.groupRewardCfg = groupCfg.groupReward
	local rewardCfgs = nebulaCompetitionRead.getCampScore()
	for k, v in pairs(rewardCfgs) do
		for k2, v2 in pairs(self.groupRewardCfg) do
			if v2 == v[1].rewardGroup then
				table.insert(self.rewardCfgs, v)
				break
			end
		end
	end
	table.sort(self.rewardCfgs, function(a, b)
		return a[1].rewardGroup < b[1].rewardGroup
	end)
end
function NebulaCompetitionBattlePanel:onShow()
	print("=======NebulaCompetitionBattlePanel:onShow")
	SoraDGetCtrl("nebulaCompetitionCtrl"):sendReqCampScoreData()
	self:updateView(true)
end
function NebulaCompetitionBattlePanel:updateView(isFirst)
	self.scoreData = nebulaCompetitionCtrl:getCampScoreData()
	if self.scoreData == nil or next(self.scoreData) == nil then
		self.fields.Com_battle:setVisible(false)
		return
	end
	self.controllers.c1:setSelectedIndex(self.curChooseTab == 1 and 0 or 1)
	self.curStage = nebulaCompetitionCtrl:getCurrentStage()
	if nebulaCompetitionCtrl:isActivityCalc() then
		self.curStage = self.curStage + 1
	end
	if self.curChooseTab == 1 then
		self.fields.Com_battle:setVisible(true)
		self.fields.Com_battle:initData(self.scoreData.campScoreData7, 7, self.curStage)
		self.fields.list_battle:setNumItems(6)
		if self.curStage == 7 and isFirst then
			self.fields.list_battle:getScrollPane():setPosY((self.curStage - 1) * 209)
		end
	else
		self.fields.list_reward:setNumItems(#self.rewardCfgs)
	end
end
function NebulaCompetitionBattlePanel:onBattlesRender(index, obj)
	local curIdx = index + 1
	if self.curStage ~= 7 then
		curIdx = index == 0 and self.curStage or (self.curStage + index - 1) % 6 + 1
	end
	print(curIdx, self.curStage, "curIdx")
	obj:initData(self.scoreData["campScoreData" .. curIdx], curIdx, self.curStage)
end
function NebulaCompetitionBattlePanel:onRewardsRender(index, obj)
	local curIdx = 1
	for i, v in ipairs(self.groupRewardCfg) do
		if v == self.rewardCfgs[index + 1][1].rewardGroup then
			curIdx = i
		end
	end
	obj:initData(self.rewardCfgs[index + 1], curIdx)
end
function NebulaCompetitionBattlePanel:onClickTabItem(index)
	local newChooseTab = index
	if index == self.curChooseTab then
		return
	end
	self.curChooseTab = newChooseTab
	self:updateView()
end
return NebulaCompetitionBattlePanel
