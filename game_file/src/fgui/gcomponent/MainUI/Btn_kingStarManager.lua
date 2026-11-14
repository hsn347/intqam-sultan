local baseComponent = require("fgui.base.baseComponent")
local Btn_kingStarManager = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_kingStarManager", Btn_kingStarManager)
function Btn_kingStarManager:onInit()
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_kingStarManager:onShow()
end
function Btn_kingStarManager:initData(data)
	self.activityID = data.activityID
end
function Btn_kingStarManager:onBtnClick()
	SoraDPlaySound()
	print("self.activityID====", self.activityID)
	_ENV = nil
	;(nil).viewType = 2
	;(nil).activityID = self.activityID
	uiManager:show("KingStarBattle", nil)
end
return Btn_kingStarManager
