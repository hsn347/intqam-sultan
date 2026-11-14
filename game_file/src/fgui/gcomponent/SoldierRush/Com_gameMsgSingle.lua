local baseComponent = require("fgui.base.baseComponent")
local Com_gameMsgSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SoldierRush/Com_gameMsgSingle", Com_gameMsgSingle)
function Com_gameMsgSingle:onInit()
	self:fixChildrenPos()
end
function Com_gameMsgSingle:onShow()
end
function Com_gameMsgSingle:initData(data, cIndex, index)
	self.fields.bg:setVisible(index % 2 == 0)
	self.controllers.c1:setSelectedIndex(cIndex)
	self.fields.model:setIcon(data.OwnLook)
	_ENV = nil
	;(nil).lv = data.Level
	self.fields.model:setTitle(i18n("common_text_100", nil))
	if cIndex == 0 then
		self.fields.Text_limit:setString(data.ArmyLimit)
		self.fields.Text_cd:setString(data.UpgradeCD == 0 and "--" or data.UpgradeCD)
		self.fields.Text_cost:setString(data.UpgradeCost == 0 and "--" or data.UpgradeCost)
	end
	if cIndex == 1 then
		self.fields.Text_range:setString(data.AtkRange * 30)
		self.fields.Text_speed:setString(data.AtkSpeed / 1000)
		self.fields.Text_cd1:setString(data.UpgradeCD == 0 and "--" or data.UpgradeCD)
		self.fields.Text_cost1:setString(data.UpgradeCost == 0 and "--" or data.UpgradeCost)
	end
	if cIndex == 2 then
		self.fields.Text_atk:setString(data.BuildBuff[2] / 10 .. "%")
		self.fields.Text_hp:setString(data.BuildBuff[4] / 10 .. "%")
		self.fields.Text_cd1:setString(data.UpgradeCD == 0 and "--" or data.UpgradeCD)
		self.fields.Text_cost1:setString(data.UpgradeCost == 0 and "--" or data.UpgradeCost)
	end
	if cIndex == 3 then
		self.fields.Text_castleLv:setString(data.CastleLv)
		self.fields.Text_armyLv:setString(data.Level)
		self.fields.Text_armyAtk:setString(data.Hp)
		self.fields.Text_armyHp:setString(data.Atk)
	end
end
return Com_gameMsgSingle
