local baseComponent = require("fgui.base.baseComponent")
local Com_ML_HatchGet = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://MagicLamp/Com_ML_HatchGet", Com_ML_HatchGet)
function Com_ML_HatchGet:onInit()
	self.fields.btn_go:addClickEventListener(handler(self, self.onGoClick))
	self.fields.btn_go:setTitle(i18n("common_text_477"))
end
function Com_ML_HatchGet:onShow()
end
function Com_ML_HatchGet:setGoCallback(callback, idx)
	self.callback = callback
	self.fields.btn_go:setVisible(self.callback ~= nil)
	self.idx = idx
end
function Com_ML_HatchGet:onGoClick()
	SoraDPlaySound()
	if self.callback then
		self.callback(self.idx)
	end
end
return Com_ML_HatchGet
