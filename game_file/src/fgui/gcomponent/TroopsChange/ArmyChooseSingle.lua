local armyCtrl = SoraDGetCtrl("armyCtrl")
local armyDesRead = include("armyDesRead")
local baseComponent = require("fgui.base.baseComponent")
local ArmyChooseSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://TroopsChange/ArmyChooseSingle", ArmyChooseSingle)
function ArmyChooseSingle:onInit()
	self:fixChildrenPos()
	self.fields.btn_Choose:setTitle(i18n("treasure_crystal_btn_02"))
	self.fields.btn_Choose:addClickListener(handler(self, self.onClickChoose))
end
function ArmyChooseSingle:initData(armyId, needNum, handle)
	print(armyId, "armyId")
	self.controllers.c1:setSelectedIndex(1)
	self.armyId = armyId
	self.handle = handle
	self.needNum = needNum
	self.ownCount = armyCtrl:getArmyCount(armyId, ARMY_OPTYPE.NORMAL_ARMY)
	self.controllers.c2:setSelectedIndex(self.ownCount < self.needNum and 1 or 0)
	_ENV = nil
	;(nil).count = string.formatnumberthousands(self.ownCount)
	self.fields.text_Num:setString(i18n("common_text_3875", nil))
	self.fields.text_Name:setString(armyDesRead.getName(armyId))
	self.fields.icon:setURL(armyDesRead.getIcon(armyId))
	self.fields.btn_Choose:setGrayed(self.ownCount < self.needNum)
	_ENV = armyDesRead.getIcon(armyId)
	armyDesRead.getIcon(armyId).num = string.formatnumberthousands(self.needNum)
	self.fields.text_NoEnough:setString(i18n("armyExchange_text_046", armyDesRead.getIcon(armyId)))
end
function ArmyChooseSingle:initTargetData(armyId, handle)
	self.controllers.c1:setSelectedIndex(0)
	self.armyId = armyId
	self.fields.iconLevel:setURL(armyDesRead.getLvImg(armyId))
	self.fields.text_Name:setString(armyDesRead.getName(self.armyId))
	self.fields.icon:setURL(armyDesRead.getIcon(self.armyId))
	self.ownCount = 1
	self.needNum = 1
	self.handle = handle
end
function ArmyChooseSingle:onClickChoose()
	SoraDPlaySound()
	if self.ownCount < self.needNum then
		SoraDShowMsgTip(i18n("armyExchange_text_010"))
		return
	end
	if self.handle then
		self.handle(self.armyId)
	end
end
return ArmyChooseSingle
