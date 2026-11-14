local baseComponent = require("fgui.base.baseComponent")
local ButtonBox = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ThirtyDaySign2021/ButtonBox", ButtonBox)
fgui.register_extension("ui://Anniversary2022/ButtonBox", ButtonBox)
fgui.register_extension("ui://RamadanSign2023/ButtonBox", ButtonBox)
function ButtonBox:onInit()
	if self.fields.ani then
		self.fields.ani:setAllFrameName("dh_liuzhounqd1_%.2d.png", 1)
		self.fields.ani:setBlendFunc(gl.ONE, gl.ONE)
	end
end
function ButtonBox:setState(index)
	self.controllers.state:setSelectedIndex(index)
end
function ButtonBox:onShow()
end
return ButtonBox
