local baseComponent = require("fgui.base.baseComponent")
local Btn_troop = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://CityWallView/Btn_troop", Btn_troop)
local armyCtrl = SoraDGetCtrl("armyCtrl")
function Btn_troop:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function Btn_troop:onShow()
end
function Btn_troop:initData(index, curIndex)
	self.index = index
	self.fields.select:setVisible(self.index == curIndex)
	self.fields.title:setString(armyCtrl:getDefendCompileName(index))
end
function Btn_troop:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_UI_CITYWALL_TEAM_SELECT"
	;(nil).index = self.index
	SoraDSendMessage(nil)
end
return Btn_troop
