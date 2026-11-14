local allianceStrongholdMineRead = include("allianceStrongholdMineRead")
local worldStrongPointMonsterView = class("worldStrongPointMonsterView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldStrongPointMonsterView")
	end
	return target
end)
_ENV, _ENV = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldStrongPointMonsterView")
	end
	return target
end, "worldStrongPointMonsterView"
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldStrongPointMonsterView")
	end
	return target
end).icon = "icon_boss_01.png"
_ENV, ("worldStrongPointMonsterView")[1], (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldStrongPointMonsterView")
	end
	return target
end).color = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldStrongPointMonsterView")
	end
	return target
end, function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldStrongPointMonsterView")
	end
	return target
end, cc.c3b(152, 251, 87)
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldStrongPointMonsterView")
	end
	return target
end).icon = "icon_boss_02.png"
_ENV, ("worldStrongPointMonsterView")[2], (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldStrongPointMonsterView")
	end
	return target
end).color = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldStrongPointMonsterView")
	end
	return target
end, function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldStrongPointMonsterView")
	end
	return target
end, cc.c3b(97, 171, 255)
;(function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldStrongPointMonsterView")
	end
	return target
end).icon = "icon_boss_03.png"
;("worldStrongPointMonsterView")[3], (function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldStrongPointMonsterView")
	end
	return target
end).color = function(target)
	if target == nil then
		return SoraDCreateTouchPanel("worldStrongPointMonsterView")
	end
	return target
end, cc.c3b(221, 121, 254)
local gwCfg = "worldStrongPointMonsterView"
function worldStrongPointMonsterView:ctor()
	self.tbBossArray, _ENV = nil, nil
	self.choose = 0
	self.isChooseBoss = false
	self.Button_close = SoraDGetChildByName(self, "Top_Button_close")
	self.Button_close:addTouchEventListener(handler(self, self.closeSelf))
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	self.frame_bossBg = SoraDGetChildByName(self, "frame_bossBg")
	self.frame_gh = SoraDGetChildByName(self, "frame_gh")
	self.icon_boss = SoraDGetChildByName(self, "icon_boss")
	self.Text_bossName = SoraDGetChildByName(self, "Text_bossName")
	self.Button_help = SoraDGetChildByName(self, "Button_help")
	self.Button_help:addTouchEventListener(handler(self, self.btnHelpClick))
	self.Button_boss = SoraDGetChildByName(self, "Button_boss")
	self.Button_boss:addTouchEventListener(handler(self, self.btnBossClick))
	self.LoadingBar_pro = SoraDGetChildByName(self, "LoadingBar_pro")
	self.Text_progress = SoraDGetChildByName(self, "Text_progress")
	self.Text_progress:enableShadow(cc.c3b(0, 0, 0), cc.size(1, -1))
	self.Node_tip = SoraDGetChildByName(self, "Node_tip")
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("alliance_stronghold_text_112"))
	self.Node_time = SoraDGetChildByName(self, "Node_time")
	self.Text_time = SoraDGetChildByName(self, "Text_time")
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.frame_killed = SoraDGetChildByName(self, "frame_killed")
	for i = 1, 3 do
		self.tbBossArray[i] = SoraDGetExtendChildFromCCSByName(self, "CCS_worldStrongPointSingle_" .. i)
		self.tbBossArray[i]:setHandle(function(index)
			self.choose = index
			self.isChooseBoss = false
			self:updateSingles()
		end)
	end
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	self.Text_des:setString(i18n("alliance_stronghold_text_058"))
	self.Text_atkLeft = SoraDGetChildByName(self, "Text_atkLeft")
	self.Text_atkLeft = SoraDCreateTimerLabel(self, self.Text_atkLeft)
	self.Text_atk = SoraDGetChildByName(self, "Text_atk")
	SoraDChangeTextToHtml(self.Text_atk)
	self.Button_attack = SoraDGetChildByName(self, "Button_attack")
	self.Button_attack:addTouchEventListener(handler(self, self.btnAttackClick))
	self.Button_attack:setVisible(false)
	self.Node_select = SoraDGetChildByName(self, "Node_select")
	self.Text_select = SoraDGetChildByName(self, "Text_select")
	self.Text_select:setString(i18n("alliance_stronghold_text_113"))
	self.Panel_1 = SoraDGetChildByName(self, "Panel_1")
	self.Node_1 = SoraDGetChildByName(self, "Node_1")
	self.Panel_2 = SoraDGetChildByName(self, "Panel_2")
	self.Panel_2:setTouchEnabled(false)
	self.Panel_1:addTouchEventListener(handler(self, self.btnDetailsClick))
	self.Text_details = SoraDGetChildByName(self, "Text_details")
	self.Text_details:setString(i18n("wasteland_text_021"))
	self.Panel_2:setContentSize(cc.size(0, 2))
	SoraDToCenter(self.Node_1, 0, not SoraDFIsRA())
	self.Panel_2:setContentSize(cc.size(self.Text_details:getContentSize().width, 2))
	self.Panel_2:setPositionX(self.Text_details:getPositionX())
	self:suitView()
end
function worldStrongPointMonsterView:suitView()
	if display.height <= 960 then
		self.Center_Node:setScale(0.85)
	end
end
function worldStrongPointMonsterView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_WORLDMAPHOLD_UPDATE", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_GOTO_FOREG_BACK_GROUD", function(...)
		self:removeFromParent()
	end)
end
function worldStrongPointMonsterView:updateData(target, data)
	if data.instance.tilePoint.x == self.data.tilePoint.x and data.instance.tilePoint.y == self.data.tilePoint.y then
		self:initData(data.instance, self.dispatchData)
	end
end
function worldStrongPointMonsterView:isKilled(ret)
	if ret then
		SoraDCreateGraySprite(self.frame_bossBg)
		SoraDCreateGraySprite(self.icon_boss)
	else
		SoraDNormalSprite(self.frame_bossBg)
		SoraDNormalSprite(self.icon_boss)
	end
	self.frame_killed:setVisible(ret)
end
function worldStrongPointMonsterView:initData(data, dispatchData)
	self.data = data
	self.dispatchData = dispatchData
	self.icon_boss:setSpriteFrame(allianceStrongholdMineRead.getHoldLeaderIcon(self.data.objId))
	self.Text_bossName:setString(i18n("alliance_stronghold_text_049"))
	if self.data.npc then
		self:setRecoverTime()
		self.LoadingBar_pro:setPercent(self.data.npc.leaderNpcLeftLife)
		self.Text_progress:setString(self.data.npc.leaderNpcLeftLife .. "%")
		self:isKilled(self.data.npc.leaderNpcLeftLife <= 0)
	else
		self.Node_tip:setVisible(false)
		self.LoadingBar_pro:setPercent(0)
		self.Text_progress:setString("0%")
		self:isKilled(true)
	end
	local leftAttackCount = self.dispatchData.leftAttackNpcCount or 0
	local maxAttackCount = include("constantRead").getConstValue("ALIANCE_STRONGHOLD_ATTACK_BOSS_ORDER")
	self.isCanAttack = 0 < leftAttackCount
	self.Button_attack:setBright(self.isCanAttack)
	allianceStrongholdMineRead = i18n("alliance_stronghold_text_049")
	i18n("alliance_stronghold_text_049").var1 = leftAttackCount
	allianceStrongholdMineRead, allianceStrongholdMineRead, i18n("alliance_stronghold_text_049").var2 = i18n("alliance_stronghold_text_049")
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
function worldStrongPointMonsterView:setRecoverTime()
	if self.data.npc.beginAttackTime and self.data.npc.beginAttackTime + allianceStrongholdMineRead.getBosstime(self.data.objId) > serviceFunctions.systemTime() then
		self.Node_tip:setVisible(true)
		self.Text_time:beginTime(self.data.npc.beginAttackTime + allianceStrongholdMineRead.getBosstime(self.data.objId) - serviceFunctions.systemTime())
		SoraDToCenter(self.Node_time)
	else
		self.Node_tip:setVisible(false)
	end
end
function worldStrongPointMonsterView:updateSingles()
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
	self.Node_select:setVisible(not (0 < self.choose) and not self.isChooseBoss)
	self.frame_gh:setVisible(self.isChooseBoss)
end
function worldStrongPointMonsterView:btnHelpClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = "alliance_stronghold_text_047"
		;("alliance_stronghold_text_047").title = i18n("common_text_001")
		;("alliance_stronghold_text_047").align = SoraDFLabelR()
		SoraDShowHelpMsgTip(i18n("alliance_stronghold_text_047"), "alliance_stronghold_text_047")
	end
end
function worldStrongPointMonsterView:closeSelf(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:removeFromParent()
	end
end
function worldStrongPointMonsterView:btnBossClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.isChooseBoss = not self.isChooseBoss
		self.choose = self.isChooseBoss and 0 or self.choose
		self:updateSingles()
	end
end
function worldStrongPointMonsterView:btnAttackClick(button, event)
	if event == ccui.TouchEventType.ended then
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
end
function worldStrongPointMonsterView:btnDetailsClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).id = self.data.objId
		uiManager:show("DetailsOfTheMonster", nil)
	end
end
return worldStrongPointMonsterView
