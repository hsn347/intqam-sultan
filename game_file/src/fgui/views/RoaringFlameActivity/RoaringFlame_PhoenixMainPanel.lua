local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local roaringFlameWarUtil = include("roaringFlameWarUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlame_PhoenixMainPanel = class("RoaringFlame_PhoenixMainPanel", baseFguiPanel)
function RoaringFlame_PhoenixMainPanel:ctor(...)
	self.isLRU = true
	RoaringFlame_PhoenixMainPanel.super.ctor(self, ...)
	print("RoaringFlame_PhoenixMainPanel:ctor", self.viewName)
end
function RoaringFlame_PhoenixMainPanel:onInit()
	print("=======RoaringFlame_PhoenixMainPanel:onInit")
	fguiHelper.SoraDSetComFields(self)
	self.fields.Com_title:initData(i18n("flames_dunes_text119"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Text_tip:setString(i18n("flames_dunes_text122"))
	self.fields.Text_exTip:setString(i18n("flames_dunes_text341"))
	self.fields.Btn_reward:setString(i18n("soldier_rush_text_11"))
	self.fields.Btn_reward:addClickListener(handler(self, self.btnRewardClick))
	self.fields.Btn_rank:setString(i18n("pyramid_btn_29"))
	self.fields.Btn_rank:addClickListener(handler(self, self.btnRankClick))
	self.fields.Button_go:setString(i18n("common_text_477"))
	self.fields.Button_go:addClickListener(handler(self, self.btnGoClick))
	self.fields.List_attack:setItemRenderer(handler(self, self.onAttackRenderer))
	self.fields.List_lv:setItemRenderer(handler(self, self.onLvRenderer))
end
function RoaringFlame_PhoenixMainPanel:onAttackRenderer(index, obj)
	obj:initData(self.rewardAttackList[index + 1].id, self.rewardAttackList[index + 1].count)
end
function RoaringFlame_PhoenixMainPanel:onLvRenderer(index, obj)
	obj:initData(self.rewardLvList[index + 1].id, self.rewardLvList[index + 1].count)
end
function RoaringFlame_PhoenixMainPanel:endShow()
	print("=======RoaringFlame_PhoenixMainPanel:endShow")
	roaringFlameWarCtrl:reqPhoenixList()
	SoraDShowLoading(self)
end
function RoaringFlame_PhoenixMainPanel:initView(target, data)
	SoraDCloseLoading(self)
	if not roaringFlameWarCtrl:getPhoenixData() then
		local _ENV, phoenixData = roaringFlameWarCtrl:getPhoenixData(), roaringFlameWarCtrl:getPhoenixData()
	end
	local attackCount = phoenixData.attackCount or 0
	if not phoenixData.lvMap then
		local _ENV, lvMap = phoenixData.lvMap, phoenixData.lvMap
	end
	local attackTaskCfg = roaringFlameWarRead.getPhoenixTaskCfg(2)
	local attackTaskIndex = #attackTaskCfg
	for k, v in ipairs(attackTaskCfg) do
		if attackCount < v.aim then
			attackTaskIndex = k
			break
		end
	end
	local cfg = attackTaskCfg[attackTaskIndex]
	local isAttackDone = attackTaskIndex >= #attackTaskCfg
	if isAttackDone then
		_ENV = nil
		;(nil).task = fguiHelper.getColorString("#E2AF27", i18n("flames_dunes_text124"))
		self.fields.Text_attack:setString(i18n("flames_dunes_text121", nil))
	else
		_ENV = i18n("flames_dunes_text121", nil)
		i18n("flames_dunes_text121", nil).val = fguiHelper.getColorString("#E2AF27", cfg.aim)
		self.fields.Text_attack:setString(i18n(cfg.des, i18n("flames_dunes_text121", nil)))
	end
	self.rewardAttackList = cfg.rewards
	self.fields.List_attack:setNumItems(#self.rewardAttackList)
	local lvTaskCfg = roaringFlameWarRead.getPhoenixTaskCfg(3)
	local lvTaskIndex = #lvTaskCfg
	for k, v in ipairs(attackTaskCfg) do
		if not lvMap[tostring(v.aim)] then
			lvTaskIndex = k
			break
		end
	end
	local lvCfg = lvTaskCfg[lvTaskIndex]
	local isLvDone = lvTaskIndex >= #lvTaskCfg
	if isLvDone then
		_ENV = v.aim
		v.aim.task = fguiHelper.getColorString("#E2AF27", i18n("flames_dunes_text125"))
		self.fields.Text_lv:setString(i18n("flames_dunes_text121", v.aim))
	else
		_ENV = i18n("flames_dunes_text121", v.aim)
		i18n("flames_dunes_text121", v.aim).val = fguiHelper.getColorString("#E2AF27", lvCfg.aim)
		self.fields.Text_lv:setString(i18n(lvCfg.des, i18n("flames_dunes_text121", v.aim)))
	end
	self.rewardLvList = lvCfg.rewards
	self.fields.List_lv:setNumItems(#self.rewardLvList)
	local taskRedNum = roaringFlameWarCtrl:getPhoenixTaskRedNum()
	self.fields.Btn_reward:setReddot(0 < taskRedNum, taskRedNum)
end
function RoaringFlame_PhoenixMainPanel:btnRewardClick()
	SoraDPlaySound()
	uiManager:show("RoaringFlame_PhoenixReward")
end
function RoaringFlame_PhoenixMainPanel:btnRankClick()
	SoraDPlaySound()
	local curState = roaringFlameWarCtrl:getCurState()
	local isEnable = curState >= ROARING_FLAME_WAR_STATE.BATTLE
	if not isEnable then
		SoraDShowMsgTip(i18n("flames_dunes_text291"))
		return
	end
	_ENV = i18n("flames_dunes_text291")
	i18n("flames_dunes_text291").tag = 3
	i18n("flames_dunes_text291").extype = 2
	uiManager:show("RoaringFlame_Rank", i18n("flames_dunes_text291"))
end
function RoaringFlame_PhoenixMainPanel:btnGoClick()
	SoraDPlaySound()
	if not worldMapDefine.isInRoaringFlame() then
		SoraDShowMsgTip(i18n("brightWar_text_79"))
		return
	end
	if roaringFlameWarCtrl:checkInWarStatus() then
		SoraDShowMsgTip(i18n("flames_dunes_text242"))
		return
	end
	local subType = gWorldTypeServerDef.subTypeRoaringFlameWarPhoenix
	local ret = roaringFlameWarUtil.searchRoaringFlameWarBuild(subType, true)
	if not ret then
		SoraDShowMsgTip(i18n("flames_dunes_text123"))
		return
	else
		SoraDRemoveAllPanelFromManager()
	end
end
function RoaringFlame_PhoenixMainPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).title = i18n("flames_dunes_second_rule17")
	;(nil).content = i18n("flames_dunes_second_rule18")
	uiManager:show("RuleView", nil)
end
return RoaringFlame_PhoenixMainPanel
