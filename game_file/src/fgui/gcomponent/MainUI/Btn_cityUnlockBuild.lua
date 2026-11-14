local baseComponent = require("fgui.base.baseComponent")
local Btn_cityUnlockBuild = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_cityUnlockBuild", Btn_cityUnlockBuild)
function Btn_cityUnlockBuild:onInit()
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_cityUnlockBuild:onShow()
end
function Btn_cityUnlockBuild:setTitle(str)
	self.fields.title:setString(str)
end
function Btn_cityUnlockBuild:setIcon(png)
	self.fields.icon:setSpriteFrame(png)
end
function Btn_cityUnlockBuild:onBtnClick()
	SoraDPlaySound()
	local funUnlockRead = include("funUnlockRead")
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.FUN_OPEN_PREVIEW)
	if unlockLv <= SoraDGetCastleLv() then
		_ENV = nil
		;(nil).showType = 1
		uiManager:show("CityUpgradeUnlock", nil)
	end
end
return Btn_cityUnlockBuild
