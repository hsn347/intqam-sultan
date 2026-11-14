local armyDesRead = include("armyDesRead")
local armyCtrl = SoraDGetCtrl("armyCtrl")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local eliteSoldiersDef = include("eliteSoldiersDef")
local armyLogic = include("armyLogic")
local baseComponent = require("fgui.base.baseComponent")
local Com_troopSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://troopFlagView/Com_troopSingle", Com_troopSingle)
function Com_troopSingle:onInit()
	self.fields.et_1:setAllFrameName("dh_budui1_%.2d.png", 0)
	self.fields.et_3:setAllFrameName("dh_budui1_%.2d.png", 0)
	self.fields.et_5:setAllFrameName("dh_budui1_%.2d.png", 0)
	self.fields.et_2:setAllFrameName("dh_budui1_%.2d.png", 0)
	self.fields.et_4:setAllFrameName("dh_budui2_%.2d.png", 0)
	self:addClickListener(handler(self, self.btnClick))
	self.fields.n5:fixPos()
	self.fields.Text_num:fixPos()
end
function Com_troopSingle:onShow()
end
function Com_troopSingle:initData(data, isTrap)
	self.armyID = data.id
	self.armyNum = data.num
	self.isTrap = isTrap
	self.fields.Com_army:initData(self.armyID)
	local promoteQueue = queueCtrl:queryQueue(gQueueTypeDef.prompt_army)
	self.isCanPromote = not promoteQueue and (armyCtrl:isCanPromote(self.armyID) or armyCtrl:isCanWearWarframe(self.armyID) or armyCtrl:isCanWearGilded(self.armyID))
	self.fields.icon_promote:setVisible(self.isCanPromote)
	local warLv = armyDesRead.getWarLv(self.armyID)
	self.fields.Lab_warLv:setVisible(0 < warLv)
	self.fields.Lab_warLv:setString(warLv)
	self.fields.Sprite_lv:setSpriteFrame(self.isTrap and armyDesRead.getTrapLvImg(self.armyID) or armyDesRead.getLvImg(self.armyID))
	self.fields.Text_num:setString(string.formatnumberthousands(self.armyNum))
	local armyLv = serviceFunctions.getArmyViewLev(self.armyID)
	if (armyLv == 115 or armyLv == 125 or 130 <= armyLv) and not self.isTrap then
		self.controllers.c1:setSelectedIndex(1)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
end
function Com_troopSingle:btnClick()
	SoraDPlaySound()
	local armyBid = armyDesRead.getBuildID(self.armyID)
	local buildCell = cityCtrl:getBuildCellList(armyBid)[1]
	if buildCell then
		local data.armyData, _ENV, _ENV, data = armyBid, armyBid, cityCtrl, cityCtrl
		data.armyData.armyid = self.armyID
		data.bid = armyBid
		data.type = self.isTrap and TRAIN_TYPE.TRAP or TRAIN_TYPE.SOLDIERS
		if self.isCanPromote then
			_ENV = nil
			;(nil).armyData = data.armyData
			uiManager:show("soldiersPromoteDetailView", nil)
		else
			_ENV = nil
			;(nil).armyData = data
			;(nil).showMode = 1
			uiManager:show("soldiersDetailView", nil)
		end
	end
end
return Com_troopSingle
