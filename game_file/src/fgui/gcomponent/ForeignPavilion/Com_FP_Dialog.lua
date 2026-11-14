local baseComponent = require("fgui.base.baseComponent")
local Com_FP_Dialog = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ForeignPavilion/Com_FP_Dialog", Com_FP_Dialog)
function Com_FP_Dialog:onInit()
end
function Com_FP_Dialog:onShow()
	self:fitHieghtView()
end
function Com_FP_Dialog:fitHieghtView()
	if display.width / display.height <= 0.5633802816901409 then
		return
	end
	local scale = self.fields.dialog_bg:getWidth() / 640
	self.fields.dialog_bg:setWidth(self.fields.dialog_bg:getWidth() / scale)
	self.fields.text_dialog:setWidth(self.fields.text_dialog:getWidth() / scale)
	dump(self.fields.text_dialog:getPositionX(), "Fklsdflkdfl")
	self.fields.arrow:setPositionX(self.fields.text_dialog:getPositionX() + self.fields.text_dialog:getWidth() / 2 - self.fields.arrow:getWidth() - 30)
end
return Com_FP_Dialog
