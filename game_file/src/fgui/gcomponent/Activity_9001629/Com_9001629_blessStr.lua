local baseComponent = require("fgui.base.baseComponent")
local Com_9001629_blessStr = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://Activity_9001629/Com_9001629_blessStr", Com_9001629_blessStr)
function Com_9001629_blessStr:onInit()
	self:addClickEventListener(handler(self, self.onClick))
end
function Com_9001629_blessStr:onShow()
end
function Com_9001629_blessStr:initData(cfg, idx)
	self.fields.title:setString(i18n(cfg.text))
	self.idx = idx
end
function Com_9001629_blessStr:setIsSelectedText(isSelected)
	dump(isSelected, "isSelected")
	self.isSelectedText = isSelected
	self.controllers.c1:setSelectedIndex(self.isSelectedText and 1 or 0)
end
function Com_9001629_blessStr:setClickCallback(callback)
	self.callback = callback
end
function Com_9001629_blessStr:onClick()
	SoraDPlaySound()
	if self.callback then
		self.callback(self, self.idx)
	end
end
return Com_9001629_blessStr
