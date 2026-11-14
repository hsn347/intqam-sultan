local baseComponent = require("fgui.base.baseComponent")
local Lab_spTitle = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://Chaser/Lab_spTitle", Lab_spTitle)
function Lab_spTitle:onInit()
	self.fields.btn_detail:addClickListener(handler(self, self.onDetailClick))
	self.fields.btn_detail:fixPos()
end
function Lab_spTitle:onShow()
end
function Lab_spTitle:initData(title, isReview, rid)
	self.rid = rid
	self.controllers.c1:setSelectedIndex(isReview and 1 or 0)
	self.fields.title:setString(title)
	self.fields.title:fixPos()
end
function Lab_spTitle:onDetailClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).rid = self.rid
	uiManager:show("RuneRamTipPop", nil)
end
return Lab_spTitle
