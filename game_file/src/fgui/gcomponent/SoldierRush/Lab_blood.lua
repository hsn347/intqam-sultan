local baseComponent = require("fgui.base.baseComponent")
local Lab_blood = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://SoldierRush/Lab_blood", Lab_blood)
function Lab_blood:onInit()
	self:fixChildrenPos()
end
function Lab_blood:onShow()
	self.controllers.c1:setSelectedIndex(0)
end
function Lab_blood:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SOLDIERRUSH_UI_ATTR_SHOW", handler(self, self.setAttrShow))
end
function Lab_blood:setAttrShow(target, data)
	self.controllers.c1:setSelectedIndex(data.isShow and 1 or 0)
end
function Lab_blood:initData(armyCount, cfgData)
	self.fields.title:setString(armyCount)
	self.fields.Text_atk:setString("+" .. cfgData.Atk)
	self.fields.Text_hp:setString("+" .. cfgData.Hp)
end
return Lab_blood
