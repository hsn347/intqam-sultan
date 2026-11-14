local armyDesRead = include("armyDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_armySingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://StarEnergyCube/Com_armySingle", Com_armySingle)
function Com_armySingle:onInit()
	self:fixChildrenPos()
end
function Com_armySingle:initData(index, v)
	self.fields.Text_cellName:setString(armyDesRead.getName(v.id))
	self.fields.Text_cellNum:setString(string.formatnumberthousands(v.num))
	self.fields.Com_army:initData(v.id)
end
function Com_armySingle:onShow()
end
return Com_armySingle
