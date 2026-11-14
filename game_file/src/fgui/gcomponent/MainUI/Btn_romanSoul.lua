local baseComponent = require("fgui.base.baseComponent")
local Btn_romanSoul = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_romanSoul", Btn_romanSoul)
function Btn_romanSoul:onInit()
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_romanSoul:onShow()
end
function Btn_romanSoul:onBtnClick()
	SoraDPlaySound()
	uiManager:show("watchTowerSoulView")
	_ENV = uiManager
	uiManager.msg = "MESSAGE_MAINCITYVIEW_LEAVE_MOVE_MODE"
	SoraDSendMessage(uiManager)
end
return Btn_romanSoul
