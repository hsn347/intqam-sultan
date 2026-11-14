local soldierRushRead = include("soldierRushRead")
local soldierRushCtrl = SoraDGetCtrl("soldierRushCtrl")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local newPlayerTaskCtrl = SoraDGetCtrl("newPlayerTaskCtrl")
local buildDescribeRead = include("buildDescribeRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SoldierRushGateInfoPanel = class("SoldierRushGateInfoPanel", baseFguiPanel)
function SoldierRushGateInfoPanel:ctor(...)
	self.super.ctor(self, ...)
	print("SoldierRushGateInfoPanel:ctor", self.viewName)
end
function SoldierRushGateInfoPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function SoldierRushGateInfoPanel:onInit()
	print("=======SoldierRushGateInfoPanel:onInit")
	self.chapter = self.param.chapter
	self.gate = self.param.gate
	self.id = self.param.id
	self.fields.Text_skill:setString(i18n("soldier_rush_text_08"))
	_ENV = i18n("soldier_rush_text_08")
	i18n("soldier_rush_text_08").var1 = self.chapter
	i18n("soldier_rush_text_08").var2 = self.gate
	self.fields.Panel_bg:setString(i18n("%{var1}-%{var2}", i18n("soldier_rush_text_08")))
	self.fields.Text_target:setString(i18n("soldier_rush_text_10"))
	self.fields.Text_reward:setString(i18n("soldier_rush_text_11"))
	self.fields.List_skill:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_target:setItemRenderer(handler(self, self.onTargetRenderer))
	self.fields.List_award:setItemRenderer(handler(self, self.onRewardRenderer))
	self.fields.Btn_quest:addClickListener(handler(self, self.onTipClick))
	self.fields.Btn_attack:setString(i18n("arena_btn_04"))
	self.fields.Btn_attack:addClickListener(handler(self, self.onAttackClick))
	self.fields.Btn_go:setString(i18n("common_text_477"))
	self.fields.Btn_go:setVisible(false)
	self.fields.Btn_go:addClickListener(handler(self, self.onGoClick))
	self.fields.Com_tip:setVisible(false)
	self:addEventListener(fgui.UIEventType.TouchEnd, function()
		_ENV = nil
		;(nil).msg = "MESSAGE_SOLDIERRUSH_UI_GATE_ARMYLV_INFO"
		SoraDSendMessage(nil)
	end)
	self.fields.n15:fixPos()
	self.fields.Text_skill:fixPos()
	self.fields.Text_tip:fixPos()
	self.fields.Btn_quest:fixPos()
	self.fields.Text_unlockTip:fixPos()
	self.fields.Btn_go:fixPos()
end
function SoldierRushGateInfoPanel:onItemRenderer(index, obj)
	obj:setData(self.enemySkill[index + 1])
end
function SoldierRushGateInfoPanel:onTargetRenderer(index, obj)
	obj:initData(self.conditionList[index + 1], self.id, true)
end
function SoldierRushGateInfoPanel:onRewardRenderer(index, obj)
	local data = self.rewardList[index + 1]
	obj:initData(data.id, data.count)
end
function SoldierRushGateInfoPanel:showArmyInfo(target, data)
	if data.isShow then
		self.fields.Com_tip:setVisible(true)
	else
		self.fields.Com_tip:setVisible(false)
	end
end
function SoldierRushGateInfoPanel:onShow()
	print("=======SoldierRushGateInfoPanel:onShow")
	local lvCfg = soldierRushRead.getLevelCfg(self.id)
	if next(lvCfg.EnemyGetSkill) then
		self.controllers.c1:setSelectedIndex(0)
		cityCtrl = 0
		;(0)[1] = "id"
		;(0)[2] = "lv"
		self.enemySkill = serviceFunctions.tableFormat(lvCfg.EnemyGetSkill, 0)
		self.fields.List_skill:setNumItems(#self.enemySkill)
	else
		self.controllers.c1:setSelectedIndex(1)
	end
	self.conditionList = soldierRushRead.getLevelStarCfg(self.id)
	self.fields.List_target:setNumItems(#self.conditionList)
	cityCtrl = #self.conditionList
	;(#self.conditionList)[1] = "id"
	;(#self.conditionList)[2] = "count"
	self.rewardList = serviceFunctions.tableFormat(lvCfg.LevelReward, #self.conditionList)
	self.fields.List_award:setNumItems(#self.rewardList)
	local extraLv = soldierRushRead.getConstantVal("Soldier_Lv_Constant")
	local enemyLv = lvCfg.EnemySoldierLv
	local myArmyLv = soldierRushRead.getArmyLv()
	local limitLv = lvCfg.SoldierLvLimit
	local status = myArmyLv >= limitLv and 0 or 1
	print("myArmyLv,limitLv,status===", myArmyLv, limitLv, status)
	myArmyLv = math.min(myArmyLv, limitLv)
	print("myArmyLv,enemyLv====", myArmyLv, enemyLv, extraLv)
	if myArmyLv <= enemyLv - extraLv then
		self.fields.Text_tip:setString(i18n("report_tip_04"))
		self.fields.Text_tip:setColor(cc.c3b(224, 43, 43))
	end
	if enemyLv < myArmyLv then
		self.fields.Text_tip:setString(i18n("report_tip_02"))
		self.fields.Text_tip:setColor(cc.c3b(112, 199, 35))
	end
	if myArmyLv < enemyLv + extraLv and myArmyLv > enemyLv - extraLv then
		self.fields.Text_tip:setString(i18n("report_tip_03"))
		self.fields.Text_tip:setColor(cc.c3b(255, 212, 62))
	end
	self.fields.Com_tip:initData(enemyLv, myArmyLv, status)
	local unStr = ""
	local bid = lvCfg.UnlockBuildLv[1]
	self.bid = bid
	local needLv = lvCfg.UnlockBuildLv[2]
	local myBuildLv = cityCtrl:getBuildMaxLv(bid)
	if needLv > myBuildLv then
		_ENV = cc.c3b(255, 212, 62)
		cc.c3b(255, 212, 62).name = buildDescribeRead.getName(bid)
		cc.c3b(255, 212, 62).num = needLv
		unStr = i18n("common_text_2931") .. ":" .. i18n("soldier_rush_text_12", cc.c3b(255, 212, 62))
		self.fields.Btn_go:setVisible(true)
	end
	local needChapter = lvCfg.UnlockChapter
	local curChapterID = newPlayerTaskCtrl:getCurChapterID()
	if 0 < curChapterID and needChapter > curChapterID then
		_ENV = cc.c3b(255, 212, 62)
		cc.c3b(255, 212, 62).num = needChapter
		unStr = unStr .. "\n" .. i18n("common_text_2931") .. ":" .. i18n("soldier_rush_text_19", cc.c3b(255, 212, 62))
	end
	if unStr == "" then
		self.controllers.c2:setSelectedIndex(0)
	else
		self.controllers.c2:setSelectedIndex(1)
		self.fields.Text_unlockTip:setString(unStr)
	end
end
function SoldierRushGateInfoPanel:onTipClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_SOLDIERRUSH_UI_GATE_ARMYLV_INFO"
	;(nil).isShow = true
	SoraDSendMessage(nil)
end
function SoldierRushGateInfoPanel:onAttackClick()
	SoraDPlaySound()
	soldierRushCtrl:setCurBattleID(self.id)
	_ENV = nil
	;(nil).id = self.id
	;(nil).chapter = self.chapter
	;(nil).gate = self.gate
	uiManager:show("SoldierRushMap", nil)
	self:close()
end
function SoldierRushGateInfoPanel:onGoClick()
	SoraDPlaySound()
	if self.bid then
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		_ENV = nil
		;(nil).bid = self.bid
		mildGuideManager:starToUpgradeStar(nil)
		SoraDRemoveAllPanelFromManager()
	end
end
function SoldierRushGateInfoPanel:gameGuide_getTarget(itemName, parameters)
	return self.fields[itemName]
end
return SoldierRushGateInfoPanel
