local baseComponent = require("fgui.base.baseComponent")
local Com_flag = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/Com_flag", Com_flag)
function Com_flag:onInit()
	self.fields.Sprite_class:fixPos()
end
function Com_flag:onShow()
end
function Com_flag:setClassVisible(ret)
	self.fields.Sprite_class:setVisible(ret)
end
function Com_flag:setClassIcon(png)
	self.fields.Sprite_class:setSpriteFrame(png)
end
function Com_flag:setFlagIcon(png)
	self.fields.Sprite_flag:setSpriteFrame(png)
end
function Com_flag:isShowArmyNum(ret)
	self.controllers.c1:setSelectedIndex(ret and 1 or 0)
end
function Com_flag:setArmyNum(num)
	self.fields.Text_armyCount:setString(SoraDConvertNumberWithUnit(num))
end
return Com_flag
