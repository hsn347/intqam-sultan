local baseProxy = require("fgui.base.baseProxy")
local TowerDefendProxy = class("TowerDefendProxy", baseProxy)
function TowerDefendProxy:onRegisterEvent()
	print("=======TowerDefendProxy:onRegisterEvent")
	SoraDAddMessage(self, "MESSAGE_TOWER_DEFEND_GAME_START", handler(self, self.gameEntry))
	SoraDAddMessage(self, "MESSAGE_TOWER_DEFEND_GENERATE_TIMER", handler(self, self.generateAMonster))
	SoraDAddMessage(self, "MESSAGE_TOWER_DEFEND_GOLD_TIMER", handler(self, self.goldIncrement))
	SoraDAddMessage(self, "MESSAGE_TOWER_DEFEND_ENERGY_TIMER", handler(self, self.energyIncrement))
	SoraDAddMessage(self, "MESSAGE_TOWER_DEFEND_GAME_FAIL", handler(self, self.gameFail))
	SoraDAddMessage(self, "MESSAGE_TOWER_DEFEND_MAIN_SKILL", handler(self, self.setAttackEffect))
	SoraDAddMessage(self, "MESSAGE_TOWER_DEFEND_MAIN_ATTACK_TIMER", handler(self, self.generateSkillAttackTimer))
	SoraDAddMessage(self, "MESSAGE_TOWER_DEFEND_GOLD_REFRESH", handler(self, self.goldRefresh))
	SoraDAddMessage(self, "MESSAGE_TOWER_DEFEND_CITYWALL_STATE", handler(self, self.cityWallDestroyState))
	SoraDAddMessage(self, "MESSAGE_TOWER_DEFEND_GENERATE_ATTACK", handler(self, self.generateATowerAttack))
	SoraDAddMessage(self, "MESSAGE_TOWER_DEFEND_ENERGY_REFRESH", handler(self, self.energyRefresh))
	SoraDAddMessage(self, "MESSAGE_EXOTIC_PAVILION_GAME_RESULT_CLOSE", handler(self, self.onResultClose))
	SoraDAddMessage(self, "MESSAGE_TOWER_DEFEND_TOWER_CLOSE", handler(self, self.onClickTowerBuildHide))
	SoraDAddMessage(self, "MESSAGE_TOWER_DEFEND_GENERATE_LINE", handler(self, self.generateAAttackLine))
	SoraDAddMessage(self, "MESSAGE_TOWER_DEFEND_READY_END", handler(self, self.countDownAniEnd))
	SoraDAddMessage(self, "MESSAGE_TOWER_DEFEND_DROPCOIN_EFFECT", handler(self, self.generateAGoldDrop))
end
function TowerDefendProxy:generateAGoldDrop(target, retData)
	self.view:generateAGoldDrop(retData)
end
function TowerDefendProxy:countDownAniEnd()
	self.view:countDownAniEnd()
end
function TowerDefendProxy:generateAAttackLine(target, retData)
	self.view:generateAAttackLine(retData)
end
function TowerDefendProxy:onClickTowerBuildHide()
	self.view:onClickTowerBuildHide()
end
function TowerDefendProxy:onResultClose()
	self.view:close()
end
function TowerDefendProxy:energyRefresh(target, retData)
	if self.view then
		self.view:energyRefresh(retData)
	end
end
function TowerDefendProxy:gameEntry(target, retData)
	if self.view then
		self.view:gameEntry()
	end
end
function TowerDefendProxy:generateAMonster(target, retData)
	if self.view then
		self.view:generateMonsterByInterval()
	end
end
function TowerDefendProxy:generateATowerAttack(target, retData)
	if self.view then
		self.view:generateATowerAttack(retData)
	end
end
function TowerDefendProxy:generateSkillAttackTimer(target, retData)
	if self.view then
		self.view:generateSkillAttackTimer()
	end
end
function TowerDefendProxy:setAttackEffect(target, retData)
	if self.view then
		self.view:setAttackEffect()
	end
end
function TowerDefendProxy:goldIncrement(target, retData)
	if self.view then
		self.view:goldIncrement()
	end
end
function TowerDefendProxy:goldRefresh(target, retData)
	if self.view then
		self.view:goldRefresh(retData)
	end
end
function TowerDefendProxy:energyIncrement(target, retData)
	if self.view then
		self.view:energyIncrement()
	end
end
function TowerDefendProxy:gameFail(target, retData)
	if self.view then
		self.view:gameFail(retData)
	end
end
function TowerDefendProxy:cityWallDestroyState(target, retData)
	if self.view then
		self.view:cityWallDestroyState(retData)
	end
end
return TowerDefendProxy
