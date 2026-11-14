local soldierRushRead = include("soldierRushRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_armyLvTip = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SoldierRush/Com_armyLvTip", Com_armyLvTip)
function Com_armyLvTip:onInit()
end
function Com_armyLvTip:onShow()
end
function Com_armyLvTip:initData(enemyLv, myArmyLv, status)
	self.fields.n1:setString(i18n("soldier_rush_text_41") .. enemyLv)
	self.fields.n2:setString(i18n("soldier_rush_text_42") .. myArmyLv)
	if status == 0 then
		self.fields.n3:setString(i18n("soldier_rush_text_43"))
	else
		self.fields.n3:setVisible(myArmyLv > SoraDGetCastleLv())
		_ENV = i18n("soldier_rush_text_43")
		i18n("soldier_rush_text_43").num1 = soldierRushRead.getCastleLv(enemyLv)
		i18n("soldier_rush_text_43").num2 = enemyLv
		self.fields.n3:setString(i18n("soldier_rush_text_44", i18n("soldier_rush_text_43")))
	end
end
return Com_armyLvTip
