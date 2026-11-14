local baseComponent = require("fgui.base.baseComponent")
local Btn_hegemonManager = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_hegemonManager", Btn_hegemonManager)
function Btn_hegemonManager:onInit()
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_hegemonManager:onShow()
end
function Btn_hegemonManager:onBtnClick()
	SoraDPlaySound()
	local legendaryKingView = SoraDCreatePanel("hegemonView")
	legendaryKingView:show()
	local hegemonCtrl = SoraDGetCtrl("hegemonCtrl")
	_ENV = nil
	;(nil).bid = hegemonCtrl:getJoinBid()
	legendaryKingView:init(nil)
end
return Btn_hegemonManager
