local armyDesRead = include("armyDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_guardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://heroTrial/Com_guardSingle", Com_guardSingle)
function Com_guardSingle:onInit()
	self:fixChildrenPos()
end
function Com_guardSingle:onShow()
end
function Com_guardSingle:initData(data)
	self.fields.icon:setSpriteFrame(armyDesRead.getIcon(data.id))
	self.fields.lv:setSpriteFrame(armyDesRead.getLvImg(data.id))
	self.fields.Text_num:setString(data.num)
end
return Com_guardSingle
