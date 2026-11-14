local baseComponent = require("fgui.base.baseComponent")
local Btn_watchTower = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_watchTower", Btn_watchTower)
function Btn_watchTower:onInit()
	self.warType = gKingdomClassType.normal
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_watchTower:onShow()
end
function Btn_watchTower:setShowType(sType)
	self.controllers.c1:setSelectedIndex(sType)
end
function Btn_watchTower:onBtnClick()
	SoraDPlaySound()
	if self.warType == gKingdomClassType.roaringFlame then
		uiManager:show("RoaringFlameWarBeAttack")
	else
		uiManager:show("WatchTowerView")
	end
	_ENV = uiManager
	uiManager.msg = "MESSAGE_MAINCITYVIEW_LEAVE_MOVE_MODE"
	SoraDSendMessage(uiManager)
end
function Btn_watchTower:setWarType(warType)
	self.warType = warType
end
return Btn_watchTower
