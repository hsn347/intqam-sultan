local baseComponent = require("fgui.base.baseComponent")
local Btn_wallBurnning = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_wallBurnning", Btn_wallBurnning)
function Btn_wallBurnning:onInit()
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_wallBurnning:onShow()
end
function Btn_wallBurnning:setShowType(sType)
	self.controllers.c1:setSelectedIndex(sType)
end
function Btn_wallBurnning:onBtnClick()
	SoraDPlaySound()
	uiManager:show("defendView")
	_ENV = uiManager
	uiManager.msg = "MESSAGE_MAINCITYVIEW_LEAVE_MOVE_MODE"
	SoraDSendMessage(uiManager)
end
return Btn_wallBurnning
