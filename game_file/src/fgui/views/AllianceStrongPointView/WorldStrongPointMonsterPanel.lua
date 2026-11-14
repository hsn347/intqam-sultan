local allianceStrongholdMineRead = include("allianceStrongholdMineRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WorldStrongPointMonsterPanel = class("WorldStrongPointMonsterPanel", baseFguiPanel)
function WorldStrongPointMonsterPanel:ctor(...)
	WorldStrongPointMonsterPanel.super.ctor(self, ...)
	print("WorldStrongPointMonsterPanel:ctor", self.viewName)
end
function WorldStrongPointMonsterPanel:onInit()
	print("=======WorldStrongPointMonsterPanel:onInit")
	self.tbBossArray, _ENV = print, print
	self.choose = 0
	self.isChooseBoss = false
	self.frame_bossBg = self.fields.frame_bossBg
	self.frame_gh = self.fields.frame_gh
	self.icon_boss = self.fields.icon_boss
	self.Text_bossName = self.fields.Text_bossName
	self.Button_help = self.fields.Button_help
	self.Button_help:addClickListener(handler(self, self.btnHelpClick))
	self.Button_boss = self.fields.Button_boss
	self.Button_boss:addClickListener(handler(self, self.btnBossClick))
	self.LoadingBar_pro = self.fields.bar
	self.Text_progress = self.fields.bar:getChild("title")
	self.Node_tip = self.fields.Node_tip
	self.Text_tip = self.fields.Text_tip
	self.Text_tip:setString(i18n("alliance_stronghold_text_112"))
	self.Text_time = self.fields.Text_time
	self.frame_killed = self.fields.frame_killed
	for i = 1, 3 do
		self.tbBossArray[i] = self.fields["Com_single" .. i]
		self.tbBossArray[i]:setHandle(function(index)
			self.choose = index
			self.isChooseBoss = false
			self:updateSingles()
		end)
	end
	self.Text_des = self.fields.Text_des
	self.Text_des:setString(i18n("alliance_stronghold_text_058"))
	self.Text_atkLeft = SoraDCreateTimerLabel(self, self.fields.Text_atkLeft)
	self.Button_attack = self.fields.Button_attack
	self.Button_attack:addClickListener(handler(self, self.btnAttackClick))
	self.Button_attack:setVisible(false)
	self.Text_atk = self.Button_attack:getChild("title")
	self.Text_select = self.fields.Text_select
	self.Text_select:setString(i18n("alliance_stronghold_text_113"))
	self.Node_details = self.fields.Node_details
	self.Node_details:addClickListener(handler(self, self.btnDetailsClick))
	_ENV = "wasteland_text_021"
	;("wasteland_text_021").u = true
	self.Node_details:setString(SoraDWrapHtmlTagByStyle(i18n("wasteland_text_021"), "wasteland_text_021"))
end
function WorldStrongPointMonsterPanel:onShow()
	print("=======WorldStrongPointMonsterPanel:onShow")
end
function WorldStrongPointMonsterPanel:updateData(target, data)
	if data.instance.tilePoint.x == self.data.tilePoint.x and data.instance.tilePoint.y == self.data.tilePoint.y then
		self:initData(data.instance, self.dispatchData)
	end
end
function WorldStrongPointMonsterPanel:isKilled(ret)
	if ret then
		self.frame_bossBg:setGrayed(true)
		self.icon_boss:setGrayed(true)
	else
		self.frame_bossBg:setGrayed(false)
		self.icon_boss:setGrayed(false)
	end
	self.frame_killed:setVisible(ret)
end
function WorldStrongPointMonsterPanel:initData(data, dispatchData)
	self.data = data
	self.dispatchData = dispatchData
	_ENV = nil
	;(nil).data = data
	;(nil).dispatchData = dispatchData
	dump(nil, "==WorldStrongPointMonsterPanel:initData==", 10)
	self.icon_boss:setURL(allianceStrongholdMineRead.getHoldLeaderIcon(self.data.objId))
	self.Text_bossName:setString(i18n("alliance_stronghold_text_049"))
	if self.data.npc then
		self:setRecoverTime()
		self.LoadingBar_pro:setValue(self.data.npc.leaderNpcLeftLife)
		self.Text_progress:setString(self.data.npc.leaderNpcLeftLife .. "%")
		self:isKilled(self.data.npc.leaderNpcLeftLife <= 0)
	else
		self.Node_tip:setVisible(false)
		self.LoadingBar_pro:setValue(0)
		self.Text_progress:setString("0%")
		self:isKilled(true)
	end
	local leftAttackCount = self.dispatchData.leftAttackNpcCount or 0
	local maxAttackCount = include("constantRead").getConstValue("ALIANCE_STRONGHOLD_ATTACK_BOSS_ORDER")
	self.isCanAttack = 0 < leftAttackCount
	self.Button_attack:setBright(self.isCanAttack)
	_ENV = i18n("alliance_stronghold_text_049")
	i18n("alliance_stronghold_text_049").var1 = leftAttackCount
	_ENV, _ENV, i18n("alliance_stronghold_text_049").var2 = i18n("alliance_stronghold_text_049")
	i18n("alliance_stronghold_text_049").var1, i18n("alliance_stronghold_text_049").color = i18n("alliance_stronghold_text_049")
	self.Text_atk:setString(i18n_html("alliance_stronghold_text_114", i18n("alliance_stronghold_text_049")))
	if leftAttackCount < maxAttackCount and self.dispatchData.attackNpcCountRecoverTime then
		self.Text_atkLeft:setTimeLast(function(time)
			_ENV = nil
			;(nil).time = time
			return i18n("alliance_stronghold_text_115", nil)
		end)
		self.Text_atkLeft:setTimeEndListener(function()
			self.dispatchData.leftAttackNpcCount = maxAttackCount
			self.Text_atkLeft:setVisible(false)
			self.isCanAttack = true
			self.Button_attack:setBright(self.isCanAttack)
			self = nil
			;(nil).var1 = self.dispatchData.leftAttackNpcCount
			self, self, (nil).var2 = nil, maxAttackCount, maxAttackCount
			maxAttackCount.var1, (nil).color = nil, "#FFFFFF"
			self.Text_atk:setString(i18n_html("alliance_stronghold_text_114", nil, maxAttackCount))
		end)
		self.Text_atkLeft:setVisible(true)
		self.Text_atkLeft:beginTime(self.dispatchData.attackNpcCountRecoverTime - serviceFunctions.systemTime())
	end
	self:updateSingles()
end
function WorldStrongPointMonsterPanel:setRecoverTime()
	if self.data.npc.beginAttackTime and self.data.npc.beginAttackTime + allianceStrongholdMineRead.getBosstime(self.data.objId) > serviceFunctions.systemTime() then
		self.Node_tip:setVisible(true)
		self.Text_time:beginTime(self.data.npc.beginAttackTime + allianceStrongholdMineRead.getBosstime(self.data.objId) - serviceFunctions.systemTime())
	else
		self.Node_tip:setVisible(false)
	end
end
function WorldStrongPointMonsterPanel:updateSingles()
	local bossIcons = allianceStrongholdMineRead.getHoldMonsterIcon(self.data.objId)
	local killNums = allianceStrongholdMineRead.getHoldMonsterKillNum(self.data.objId)
	for k, v in ipairs(self.tbBossArray) do
		allianceStrongholdMineRead = nil
		;(nil).bossType = k
		;(nil).curPro = self.data.npc and self.data.npc.normalNpcLifes[k] or 0
		;(nil).total = killNums[k]
		;(nil).icon = bossIcons[k]
		;(nil).isBoss = self.isChooseBoss
		self.tbBossArray[k]:initData(nil)
		self.tbBossArray[k]:isSelected(self.choose == k)
	end
	self.Button_attack:setVisible(0 < self.choose or self.isChooseBoss)
	self.Text_select:setVisible(not (0 < self.choose) and not self.isChooseBoss)
	self.frame_gh:setVisible(self.isChooseBoss)
end
function WorldStrongPointMonsterPanel:btnHelpClick()
	SoraDPlaySound()
	_ENV = "alliance_stronghold_text_047"
	;("alliance_stronghold_text_047").title = i18n("common_text_001")
	;("alliance_stronghold_text_047").align = SoraDFLabelR()
	SoraDShowHelpMsgTip(i18n("alliance_stronghold_text_047"), "alliance_stronghold_text_047")
end
function WorldStrongPointMonsterPanel:btnBossClick()
	SoraDPlaySound()
	self.isChooseBoss = not self.isChooseBoss
	self.choose = self.isChooseBoss and 0 or self.choose
	self:updateSingles()
end
function WorldStrongPointMonsterPanel:btnAttackClick()
	SoraDPlaySound()
	print("点击攻击=======")
	if not self.data.npc then
		SoraDShowMsgTip(i18n("alliance_stronghold_text_123"))
		self:removeFromParent()
		return
	end
	if SoraDEnoughTroops() then
		self.dispatchData.isKillLeaderNpc = self.isChooseBoss
		if not self.isChooseBoss then
			self.dispatchData.killNormalNpcLv = self.choose
		else
			self.dispatchData.killNormalNpcLv = nil
		end
		if self.isChooseBoss and self.data.npc.leaderNpcLeftLife <= 0 then
			SoraDShowMsgTip(i18n("alliance_stronghold_text_116"))
			return
		end
		if self.choose > 0 and 0 >= self.data.npc.normalNpcLifes[self.choose] then
			SoraDShowMsgTip(i18n("alliance_stronghold_text_117"))
			return
		end
		if not self.isCanAttack then
			SoraDShowMsgTip(i18n("alliance_stronghold_text_051"))
			return
		end
		local dispatchPanel = uiManager:show("WorldDispatchArmyView")
		dispatchPanel:initData(self.dispatchData)
		self:removeFromParent()
	end
end
function WorldStrongPointMonsterPanel:btnDetailsClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).id = self.data.objId
	uiManager:show("DetailsOfTheMonster", nil)
end
return WorldStrongPointMonsterPanel
