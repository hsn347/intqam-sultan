local funUnlockRead = include("funUnlockRead")
local baseComponent = require("fgui.base.baseComponent")
local Btn_hero = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_hero", Btn_hero)
function Btn_hero:onInit()
	self.unlockKey = gFunBuildKey.HERO
	self.fields.title:setString(i18n("common_name_01"))
	self:addClickListener(handler(self, self.onBtnClick))
	self.fields.lab_red:setVisible(false)
end
function Btn_hero:onShow()
end
function Btn_hero:setRed(num)
	self.fields.lab_red:setTitle(num)
	self.fields.lab_red:setVisible(0 < num)
end
function Btn_hero:onBtnClick()
	if self.isEmpty then
		print("Btn_hero:onBtnClick isEmpty")
		return
	end
	local unlockLv = funUnlockRead.getUnlockLevel(self.unlockKey)
	if unlockLv <= SoraDGetCastleLv() then
		SoraDPlaySound("buildopsound", "OpWish")
		uiManager:show("newHeroListView")
	else
		SoraDPlaySound("uicontrol", 20)
		_ENV = nil
		;(nil).name = i18n("common_name_01")
		;(nil).lv = unlockLv
		SoraDShowMsgTip(i18n("common_text_2122", nil))
	end
end
function Btn_hero:setStatus()
	local unlockLv = funUnlockRead.getUnlockLevel(self.unlockKey)
	self.controllers.c1:setSelectedIndex(unlockLv <= SoraDGetCastleLv() and 0 or 1)
end
function Btn_hero:isEmptyModel(ret)
	self.isEmpty = ret
	if self.isEmpty then
		self.fields.lab_red:setVisible(false)
	end
end
return Btn_hero
