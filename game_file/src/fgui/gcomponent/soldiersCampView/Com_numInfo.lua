local armyLogic = include("armyLogic")
local armyDesRead = include("armyDesRead")
local armyltCtrl = include("armyltCtrl")
local armyCtrl = SoraDGetCtrl("armyCtrl")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_numInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://soldiersCampView/Com_numInfo", Com_numInfo)
function Com_numInfo:onInit()
	self.fields.Btn_dissolve:addClickListener(handler(self, self.onClick))
	self.fields.Btn_promote:addClickListener(handler(self, self.onPromoteClick))
	self.fields.Btn_trap:addClickListener(handler(self, self.onTrapClick))
	self.fields.Button_elite:addClickListener(handler(self, self.onEliteClick))
	self.isWarForbid = worldMapDefine.isInWarForbidSoldier(true)
	self:fixChildrenPos()
end
function Com_numInfo:onShow()
end
function Com_numInfo:initData(armyID, bid, trainType)
	self.armyID = armyID
	self.bid = bid
	self.trainType = trainType
	local armyType = armyLogic.getArmyTypeByID(self.armyID)
	if armyType == gSoldierType.SOLDIER_TYPE_ELITE then
		self.controllers.c1:setSelectedIndex(2)
		local retdata = armyLogic.getTrainResCast(self.bid, self.armyID)
		if retdata._costElitePointInfo then
			self.fields.Text_elite:setString(string.formatnumberthousands(retdata._costElitePointInfo.currentElitePoint))
		end
	elseif armyType == gSoldierType.TRAP_TYPE_STONE or armyType == gSoldierType.TRAP_TYPE_ARROW or armyType == gSoldierType.TRAP_TYPE_WOOD then
		self.controllers.c1:setSelectedIndex(1)
		local trapCount = armyCtrl:getTrapTotalCount()
		local trapMax = armyLogic.getTotalTrapCapacity().total
		armyLogic = string.formatnumberthousands(retdata._costElitePointInfo.currentElitePoint)
		string.formatnumberthousands(retdata._costElitePointInfo.currentElitePoint).cur = string.formatnumberthousands(trapCount)
		string.formatnumberthousands(retdata._costElitePointInfo.currentElitePoint).max = string.formatnumberthousands(trapMax)
		self.fields.Text_trap:setString(i18n("common_text_329", string.formatnumberthousands(retdata._costElitePointInfo.currentElitePoint)))
		self.fields.Text_trap:setColor(trapCount >= trapMax and cc.c3b(0, 190, 30) or cc.c3b(255, 255, 255))
	else
		self.controllers.c1:setSelectedIndex(0)
	end
	self.fields.Text_name:setString(armyDesRead.getName(self.armyID))
	if armyCtrl:isCanWearWarframe(self.armyID) then
		self.fields.Btn_promote:setString(i18n("Soldiers_armor_text_26"))
	else
		self.fields.Btn_promote:setString(i18n("arms_promotion_btn_01"))
	end
	self:updatePromote()
	local armyCount = armyCtrl:getArmyCount(self.armyID, ARMY_OPTYPE.ALL_ARMY)
	armyLogic = i18n("arms_promotion_btn_01")
	i18n("arms_promotion_btn_01").num = string.formatnumberthousands(armyCount)
	self.fields.Text_have:setString(i18n("common_text_531", i18n("arms_promotion_btn_01")))
	self.fields.Btn_dissolve:setVisible(0 < armyCount and not self.isWarForbid and serviceFunctions.getArmyViewLev(self.armyID) < 110)
end
function Com_numInfo:getTrapBtn()
	return self.fields.Btn_trap
end
function Com_numInfo:getTarget(name)
	return self.fields[name]
end
function Com_numInfo:updatePromote()
	local isCanPromote = armyCtrl:isCanPromote(self.armyID)
	local promoteQueue = queueCtrl:queryQueue(gQueueTypeDef.prompt_army)
	self.fields.Btn_promote:setVisible(isCanPromote or armyCtrl:isCanWearWarframe(self.armyID))
	local ret = true
	if promoteQueue or self.isWarForbid then
		ret = false
	end
	self.fields.Btn_promote:setBright(ret)
end
function Com_numInfo:onClick()
	SoraDPlaySound()
	if self.isWarForbid then
		worldMapDefine.showWarTips()
		return
	end
	_ENV = nil
	;(nil).armyID = self.armyID
	;(nil).trainType = self.trainType
	uiManager:show("dissolveSoldiersView", nil)
end
function Com_numInfo:getArmorNumTb(armyID)
	local armorSystemRead = include("armorSystemRead")
	local armorSystemCtrl = SoraDGetCtrl("armorSystemCtrl")
	local armorId, armorIdList = armorSystemRead:getArmorIdByArmyId(armyID, true, true)
	local _ENV, armorNumArray = armyID, armyID
	for k, v in ipairs(armorIdList) do
		local armorNum = armorSystemCtrl:getArmorNumByID(v) or 0
		table.insert(armorNumArray, armorNum)
	end
	return armorNumArray
end
function Com_numInfo:onPromoteClick()
	SoraDPlaySound()
	if self.isWarForbid then
		worldMapDefine.showWarTips()
	else
		local promoteQueue = queueCtrl:queryQueue(gQueueTypeDef.prompt_army)
		if not promoteQueue then
			if armyCtrl:isCanWearGilded(self.armyID) then
				local tb = self:getArmorNumTb(self.armyID)
				if tb[2] == 0 and 0 < tb[1] then
					_ENV = self.armyID
					self.armyID.msg = "MESSAGE_SOLDIER_UI_TRAIN_SELECT"
					self.armyID.index = 15
					SoraDSendMessage(self.armyID)
				else
					_ENV = self.armyID
					self.armyID.msg = "MESSAGE_SOLDIER_UI_TRAIN_SELECT"
					self.armyID.index = 16
					SoraDSendMessage(self.armyID)
				end
			elseif armyCtrl:isCanWearWarframe(self.armyID) then
				_ENV = armyCtrl
				armyCtrl.msg = "MESSAGE_SOLDIER_UI_TRAIN_SELECT"
				armyCtrl.index = 15
				SoraDSendMessage(armyCtrl)
			else
				local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
				_ENV = nil
				mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.TROOP_FLAG, nil)
				SoraDRemoveAllPanelFromManager()
			end
		else
			SoraDShowMsgTip(i18n("arms_promotion_text_02"))
		end
	end
end
function Com_numInfo:onTrapClick()
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("common_text_328"))
end
function Com_numInfo:onEliteClick()
	SoraDPlaySound()
	_ENV = "common_text_3233"
	;("common_text_3233").float = SoraDFLabelR()
	SoraDShowHelpMsgTip(i18n("common_text_3233"), "common_text_3233")
end
return Com_numInfo
