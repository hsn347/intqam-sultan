local baseComponent = require("fgui.base.baseComponent")
local Btn_legendKingManager = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_legendKingManager", Btn_legendKingManager)
function Btn_legendKingManager:onInit()
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_legendKingManager:onShow()
end
function Btn_legendKingManager:onBtnClick()
	SoraDPlaySound()
	local legendaryKingView = SoraDCreatePanel("legendaryKingView")
	legendaryKingView:show()
	_ENV = nil
	;(nil).viewType = 2
	legendaryKingView:init(nil)
end
return Btn_legendKingManager
