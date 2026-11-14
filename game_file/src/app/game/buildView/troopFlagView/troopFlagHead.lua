local TroopFlagHead = class("troopFlagHead", function(target)
	if target == nil then
		return SoraDCreateBasePanel("troopFlagHead")
	end
	return target
end)
function TroopFlagHead:ctor()
	self.txtTroop = SoraDGetChildByName(self, "Text_totalTroop")
	self.txtMarching = SoraDGetChildByName(self, "Text_totalMarching")
	self.txtUpkeep = SoraDGetChildByName(self, "Text_totalUpkeep")
	self.txtCapacity = SoraDGetChildByName(self, "Text_trapCapacity")
	self.txtWounded = SoraDGetChildByName(self, "Text_wounded")
	self.imgHead = SoraDGetChildByName(self, "Image_head")
	self.nodeArmy = SoraDGetChildByName(self, "Node_army")
	self.nodeTrap = SoraDGetChildByName(self, "Node_trap")
	SoraDGetChildByName(self, "Text_5_0"):setString(i18n("common_text_587"))
	SoraDGetChildByName(self, "Text_3_0"):setString(i18n("common_text_586"))
	SoraDGetChildByName(self, "Text_2_0"):setString(i18n("common_text_585"))
	SoraDGetChildByName(self, "Text_1_0"):setString(i18n("common_text_1507"))
	SoraDGetChildByName(self, "Text_4_0"):setString(i18n("common_text_1508"))
	self.imgHead:ignoreContentAdaptWithSize(true)
end
function TroopFlagHead:initData(isTrap)
	if isTrap then
		local gametop = gModuleMgr.getObject("gametop")
		local armyCtrl = gametop.playertop_:getModule("armyCtrl")
		local armyLogic = include("armyLogic")
		self.txtCapacity:setString(string.formatnumberthousands(armyCtrl:getTrapTotalCount()) .. "/" .. string.formatnumberthousands(armyLogic.getTotalTrapCapacity().total))
		self.nodeArmy:setVisible(false)
		self.imgHead:setContentSize(cc.size(620, 50))
	else
		local gametop = gModuleMgr.getObject("gametop")
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		local armyCtrl = gametop.playertop_:getModule("armyCtrl")
		local armyLogic = include("armyLogic")
		local buildLogic = include("buildLogic")
		local totalTroop = buildLogic.getExpQueueCount().total
		local outSideTroop = kingdomMapCtrl:isHasQueue()
		self.txtTroop:setString(string.formatnumberthousands(armyCtrl:getTotalArmyCount()))
		self.txtMarching:setString(outSideTroop .. "/" .. totalTroop)
		local costfood = armyCtrl:getTotalArmyCostFood()
		local costFoodString = ""
		if costfood ~= 0 and costfood < 1000 then
			costFoodString = string.format("%.1f", costfood)
		else
			costFoodString = string.formatnumberthousands(costfood)
		end
		self.txtUpkeep:setString(costFoodString .. "/h")
		self.txtWounded:setString(string.formatnumberthousands(armyCtrl:getTotalWoundedArmyCount()) .. "/" .. string.formatnumberthousands(armyLogic.getHostpitalMaxCapacity().total))
		self.nodeTrap:setVisible(false)
	end
end
function TroopFlagHead:getMeHeight()
	return self.imgHead:getContentSize().height + 20
end
return TroopFlagHead
