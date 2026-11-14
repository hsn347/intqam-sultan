local armyDesRead = include("armyDesRead")
local armyLogic = include("armyLogic")
local baseComponent = require("fgui.base.baseComponent")
local Com_own = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://soldiersCampView/Com_own", Com_own)
function Com_own:onInit()
	self.fields.Button_dissolve:addClickListener(handler(self, self.btnClick))
	self.isWarForbid = worldMapDefine.isInWarForbidSoldier(true)
	if self.isWarForbid then
		self.fields.Button_dissolve:setEnabled(false)
	end
	self:fixChildrenPos()
end
function Com_own:onShow()
end
function Com_own:initData(num, soldierType, armyid)
	self.soldierType = soldierType
	self.armyid = armyid
	_ENV = nil
	;(nil).num = string.formatnumberthousands(num)
	self.fields.Text_own:setString(i18n("common_text_531", nil))
	self.fields.Button_dissolve:setVisible(0 < num and not self.isWarForbid and serviceFunctions.getArmyViewLev(self.armyid) < 110)
end
function Com_own:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).armyID = self.armyid
	;(nil).trainType = self.soldierType
	uiManager:show("dissolveSoldiersView", nil)
end
return Com_own
