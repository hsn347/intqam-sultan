local armyDesRead = include("armyDesRead")
local armyLogic = include("armyLogic")
local armyCtrl = SoraDGetCtrl("armyCtrl")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local armyltCtrl = include("armyltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_trainSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://soldiersCampView/Com_trainSingle", Com_trainSingle)
function Com_trainSingle:onInit()
	self:addClickListener(handler(self, self.onClick))
end
function Com_trainSingle:onShow()
end
function Com_trainSingle:initData(data, index, selectIndex)
	self.data = data
	self.index = index
	self.fields.n0:setVisible(self.index == selectIndex)
	self.fields.icon:setSpriteFrame(armyDesRead.getIcon(self.data.armyid))
	local armyType = armyLogic.getArmyTypeByID(self.data.armyid)
	if armyType == gSoldierType.TRAP_TYPE_STONE or armyType == gSoldierType.TRAP_TYPE_ARROW or armyType == gSoldierType.TRAP_TYPE_WOOD then
		self.fields.lv:setSpriteFrame(armyDesRead.getTrapLvImg(self.data.armyid))
		self.fields.icon:setPositionY(32)
	else
		self.fields.lv:setSpriteFrame(armyDesRead.getLvImg(self.data.armyid))
		self.fields.icon:setPositionY(47)
	end
	self.fields.warLv:setVisible(armyDesRead.getWarLv(self.data.armyid) > 0 and self.data.iscantrain)
	self.fields.warLv:setString(armyDesRead.getWarLv(self.data.armyid))
	self.fields.lock:setVisible(not self.data.iscantrain)
	local isPromote = armyCtrl:isCanPromote(self.data.armyid) or armyCtrl:isCanWearWarframe(self.data.armyid)
	local queue = queueCtrl:queryQueue(gQueueTypeDef.prompt_army)
	self.fields.promote:setVisible(isPromote and not queue)
	local ret = false
	if armyltCtrl.isWarframeArmyID(self.data.armyid) then
		local armorSystemRead = include("armorSystemRead")
		local armorId = armorSystemRead:getArmorIdByArmyId(self.data.armyid)
		local cfg = armorSystemRead:getArmorRefSoldierInfo(armorId)
		local armorSystemCtrl = SoraDGetCtrl("armorSystemCtrl")
		local leftPNum = armorSystemCtrl:getMothyPromoteNum()
		local armyNum = armyCtrl:getNormalArmyCount(self.data.armyid)
		ret = cfg.newLv == 13 and 0 < leftPNum and 0 < armyNum and SoraDIsTWarframeOpen(nil, armorId)
	end
	self:setReddot(ret)
end
function Com_trainSingle:onClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_SOLDIER_UI_TRAIN_SELECT"
	;(nil).index = self.index
	SoraDSendMessage(nil)
end
return Com_trainSingle
