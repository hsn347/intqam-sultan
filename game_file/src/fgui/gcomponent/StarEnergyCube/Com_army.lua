local armyDesRead = include("armyDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_army = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://StarEnergyCube/Com_army", Com_army)
function Com_army:onInit()
end
function Com_army:initData(id)
	self.fields.Load_cellHead:setURL(armyDesRead.getIcon(id))
	self.fields.Load_cellLevel:setURL(armyDesRead.getLvImg(id))
	self.fields.Text_cellTxtWarLv:setVisible(armyDesRead.getWarLv(id) > 0)
	self.fields.Text_cellTxtWarLv:setString(armyDesRead.getWarLv(id))
	self.fields.Image_cellWarLv:setVisible(armyDesRead.getWarLv(id) > 0)
end
function Com_army:onShow()
end
return Com_army
