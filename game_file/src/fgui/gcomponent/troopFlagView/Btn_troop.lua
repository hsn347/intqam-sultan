local armyCtrl = SoraDGetCtrl("armyCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_troop = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://troopFlagView/Btn_troop", Btn_troop)
function Btn_troop:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function Btn_troop:onShow()
end
function Btn_troop:initData(tag)
	self.tag = tag
	local tName = armyCtrl:getArmyCompileName(self.tag)
	self.fields.title:setString(tName or self.tag)
end
function Btn_troop:btnClick()
	if self.clickCallback then
		self.clickCallback(self)
	else
		SoraDPlaySound()
		_ENV = nil
		;(nil).troopID = self.tag
		uiManager:show("troopFlagTeams", nil)
	end
end
function Btn_troop:setClickCallback(callback)
	self.clickCallback = callback
end
return Btn_troop
