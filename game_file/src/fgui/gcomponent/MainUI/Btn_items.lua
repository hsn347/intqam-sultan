local funUnlockRead = include("funUnlockRead")
local baseComponent = require("fgui.base.baseComponent")
local Btn_items = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_items", Btn_items)
function Btn_items:onInit()
	self.unlockKey = gFunBuildKey.BAG
	self.fields.title:setString(i18n("common_text_308"))
	self:addClickListener(handler(self, self.onBtnClick))
	self.fields.new:setVisible(false)
	self.fields.lab_red:setVisible(false)
end
function Btn_items:onShow()
end
function Btn_items:setRed(num)
	self.fields.lab_red:setTitle(num)
	self.fields.lab_red:setVisible(0 < num)
end
function Btn_items:setNewVisible(ret)
	self.fields.new:setVisible(ret)
end
function Btn_items:isShowDiscount(ret)
	self.controllers.c1:setSelectedIndex(ret and 1 or 0)
end
function Btn_items:onBtnClick()
	if self.isEmpty then
		return
	end
	local unlockLv = funUnlockRead.getUnlockLevel(self.unlockKey)
	if unlockLv <= SoraDGetCastleLv() then
		SoraDPlaySound("uicontrol", 14)
		uiManager:show("bagView")
	else
		SoraDPlaySound("uicontrol", 20)
		funUnlockRead = nil
		;(nil).name = i18n("common_text_308")
		;(nil).lv = unlockLv
		SoraDShowMsgTip(i18n("common_text_2122", nil))
	end
end
function Btn_items:setStatus()
	local unlockLv = funUnlockRead.getUnlockLevel(self.unlockKey)
	self.controllers.c2:setSelectedIndex(unlockLv <= SoraDGetCastleLv() and 0 or 1)
end
function Btn_items:isEmptyModel(ret)
	self.isEmpty = ret
	if self.isEmpty then
		self.fields.lab_red:setVisible(false)
	end
end
return Btn_items
