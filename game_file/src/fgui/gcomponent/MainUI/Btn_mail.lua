local funUnlockRead = include("funUnlockRead")
local baseComponent = require("fgui.base.baseComponent")
local Btn_mail = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_mail", Btn_mail)
function Btn_mail:onInit()
	self.unlockKey = gFunBuildKey.MAIL
	self.fields.title:setString(i18n("mail_text_25"))
	self:addClickListener(handler(self, self.onBtnClick))
	self.fields.lab_red:setVisible(false)
end
function Btn_mail:onShow()
end
function Btn_mail:setRed(num)
	self.fields.lab_red:setTitle(num)
	self.fields.lab_red:setVisible(0 < num)
end
function Btn_mail:onBtnClick()
	if self.isEmpty then
		return
	end
	local unlockLv = funUnlockRead.getUnlockLevel(self.unlockKey)
	if unlockLv <= SoraDGetCastleLv() then
		SoraDPlaySound("uicontrol", 30)
		local mailView = SoraDCreatePanel("mailView")
		mailView:show()
		mailView:initWithData(nil)
	else
		SoraDPlaySound("uicontrol", 20)
		funUnlockRead = nil
		;(nil).name = i18n("mail_text_25")
		;(nil).lv = unlockLv
		SoraDShowMsgTip(i18n("common_text_2122", nil))
	end
end
function Btn_mail:setStatus()
	local unlockLv = funUnlockRead.getUnlockLevel(self.unlockKey)
	self.controllers.c1:setSelectedIndex(unlockLv <= SoraDGetCastleLv() and 0 or 1)
end
function Btn_mail:isEmptyModel(ret)
	self.isEmpty = ret
	if self.isEmpty then
		self.fields.lab_red:setVisible(false)
	end
end
return Btn_mail
