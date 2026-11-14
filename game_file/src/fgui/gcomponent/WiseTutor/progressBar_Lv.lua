local baseComponent = require("fgui.base.baseComponent")
local progressBar_Lv = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WiseTutor/progressBar_Lv", progressBar_Lv)
function progressBar_Lv:onInit()
end
function progressBar_Lv:onShow()
end
function progressBar_Lv:setValue(value, max)
	if max == 0 then
		fgui.GProgressBar.setValue(self.fields.progress, 1)
		self.fields.progress:setMax(1)
		self.fields.title:setString("max")
	else
		fgui.GProgressBar.setValue(self.fields.progress, value)
		self.fields.progress:setMax(max)
		self.fields.title:setString(string.format("%d/%d", value, max))
	end
end
return progressBar_Lv
