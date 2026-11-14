local baseComponent = require("fgui.base.baseComponent")
local Com_helpSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001128/Com_helpSingle", Com_helpSingle)
function Com_helpSingle:onInit()
	self.fields.Text_discount:fixPos()
	self.fields.Text_bless:fixPos()
end
function Com_helpSingle:onShow()
end
function Com_helpSingle:initData(data, index)
	self.fields.bg:setVisible(index % 2 == 1)
	self.fields.Text_bless:setString(data.bless)
	self.fields.Text_discount:setString(data.discount)
end
return Com_helpSingle
