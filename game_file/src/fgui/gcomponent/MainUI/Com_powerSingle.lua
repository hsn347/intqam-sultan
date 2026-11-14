local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_powerSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/Com_powerSingle", Com_powerSingle)
function Com_powerSingle:onInit()
	self:fixChildrenPos()
end
function Com_powerSingle:onShow()
end
function Com_powerSingle:initData(data, index)
	local tablePlayerInfo = lordInfoCtrl:getLordInfo()
	self.fields.Image_base:setVisible(index % 2 == 0)
	self.fields.Text_name:setString(data.title)
	self.fields.Text_value:setString(string.formatnumberthousands(tablePlayerInfo.fcInfo[data.key] or 0))
end
return Com_powerSingle
