local heroTrialCommon = include("heroTrialCommon")
local heroTrialltCtrl = include("heroTrialltCtrl")
local htMapMgr = include("htMapMgr")
local htBattleMgr = include("htBattleMgr")
local baseComponent = require("fgui.base.baseComponent")
local Com_gateEntity = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://heroTrial/Com_gateEntity", Com_gateEntity)
function Com_gateEntity:onInit()
	self.fields.lab_win:setIcon(SoraDFIsRA() and "icon_herotrial_victory_arab.png" or "icon_herotrial_victory_en.png")
	self:addClickListener(handler(self, self.btnClick))
end
function Com_gateEntity:onShow()
	self.curState = 1
	self.showIndex = 0
end
function Com_gateEntity:updateState()
	self.curStageId = htBattleMgr.trialStatus and htBattleMgr.curTrialMap:getMapID() == self.mapId and htBattleMgr.curTrialMap:getLastStage() or tonumber(self.mapId .. "01")
	if self.stageId > self.curStageId then
		self.curState = 1
	else
		self.curState = 2
	end
	self.showIndex = 0
	if self.curState == 2 then
		if self.stageId < self.curStageId then
			self.curState = 4
			self.showIndex = 2
		elseif self.stageId == self.curStageId then
			self.curState = 3
			self.showIndex = 1
		end
	end
	self.controllers.c1:setSelectedIndex(self.showIndex)
	local num = heroTrialCommon.convertLevelToNum(self.stageId)
	htBattleMgr = nil
	;(nil).level = num
	self.fields.Text_lv:setString(i18n("common_text_1721", nil))
	local stageBuildType = heroTrialltCtrl.getStageBuildTypeOfStage(self.stageId)
	local target
	if stageBuildType[1] == 1 then
		target = worldMapDefine.createCastleWithLevel(stageBuildType[2])
		target:setScale(0.6)
	else
		target = worldMapDefine.createMonsterWithLevel(stageBuildType[2], self.curState == 4)
	end
	self.fields.target:clearContent()
	self.fields.target:setContent(target)
end
function Com_gateEntity:getStageId()
	return self.stageId
end
function Com_gateEntity:initData(mapId, stageId)
	self.mapId = mapId
	self.stageId = stageId
	self.curStageId = htBattleMgr.trialStatus and htBattleMgr.curTrialMap:getMapID() == self.mapId and htBattleMgr.curTrialMap:getLastStage() or tonumber(self.mapId .. "01")
	self:updateState()
end
function Com_gateEntity:btnClick()
	SoraDPlaySound()
	if self.stageId < self.curStageId then
		return
	end
	local canAttack, defendSoldiers
	if self.stageId == self.curStageId and not htBattleMgr.autoStatus then
		canAttack = true
		if heroTrialCommon.isTrialStarted(self.mapId) then
			defendSoldiers = htBattleMgr.curTrialMap:getDefendingSoldiers()
		else
			defendSoldiers = heroTrialltCtrl.getDefendingSoldiersOfStage(self.stageId)
		end
	else
		canAttack = false
		defendSoldiers = heroTrialltCtrl.getDefendingSoldiersOfStage(self.stageId)
	end
	local stageBuildType = heroTrialltCtrl.getStageBuildTypeOfStage(self.stageId)
	local bustName = "icon_herotrial_monster_01.png"
	if heroTrialCommon.convertLevelToNum(self.stageId) % 10 == 0 then
		bustName = "icon_herotrial_monster_02.png"
	end
	if stageBuildType[1] == 2 then
		local cfg = worldMapDefine.getMonsterCfgByLevel(stageBuildType[2])
		bustName = cfg.npcImage
	end
	SoraDPlaySound()
	_ENV = nil
	;(nil).canAttack = canAttack
	;(nil).enemyData = defendSoldiers
	;(nil).levelId = self.stageId
	;(nil).bustName = bustName
	;(nil).beginTile = cc.p(0, 0)
	;(nil).endTile = cc.p(0, 0)
	;(nil).mapId = self.mapId
	uiManager:show("heroTrialLevelInfo", nil)
end
return Com_gateEntity
