local soldierRushRead = include("soldierRushRead")
local soldierRushCtrl = SoraDGetCtrl("soldierRushCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Bar_rush = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SoldierRush/Bar_rush", Bar_rush)
function Bar_rush:onInit()
	self.width = 488
	self.minVal = 0.05
end
function Bar_rush:onShow()
end
function Bar_rush:initForceNum(num)
	self.forceCount = num
end
function Bar_rush:initData()
	local num4 = soldierRushCtrl:getArmyNumByForce(4)
	self.fields.icon_enemy2:setVisible(self.forceCount == 3)
	self.fields.lab_enemy2:setVisible(self.forceCount == 3)
	local num1 = soldierRushCtrl:getArmyNumByForce(1)
	local num3 = soldierRushCtrl:getArmyNumByForce(3)
	local totalArmy = num1 + num3 + num4
	if self.forceCount == 3 then
		local percent_1 = math.max(math.min(num1 / totalArmy * (1 - self.minVal), 1 - self.minVal * 2), self.minVal)
		self.fields.icon_self:setWidth(percent_1 * self.width)
		self.fields.lab_self:setPositionX(self.fields.icon_self:getPositionX() + self.fields.icon_self:getWidth() / 2)
		local atk1, hp1 = soldierRushCtrl:getArmyBuffByForce(1)
		soldierRushCtrl = nil
		;(nil).Atk = atk1 / 10 .. "%"
		;(nil).Hp = hp1 / 10 .. "%"
		self.fields.lab_self:initData(num1, nil)
		local percent_3 = math.max(math.min(num3 / totalArmy * (1 - self.minVal), 1 - self.minVal * 2), self.minVal)
		self.fields.icon_enemy1:setWidth(percent_3 * self.width)
		self.fields.lab_enemy1:setPositionX(self.fields.icon_enemy1:getPositionX() - self.fields.icon_enemy1:getWidth() / 2)
		local atk3, hp3 = soldierRushCtrl:getArmyBuffByForce(3)
		soldierRushCtrl = nil
		;(nil).Atk = atk3 / 10 .. "%"
		;(nil).Hp = hp3 / 10 .. "%"
		self.fields.lab_enemy1:initData(num3, nil)
		local percent_4 = math.max(1 - percent_1 - percent_3, self.minVal)
		self.fields.icon_enemy2:setPositionX(self.fields.icon_self:getPositionX() + self.fields.icon_self:getWidth())
		self.fields.icon_enemy2:setWidth(percent_4 * self.width)
		self.fields.lab_enemy2:setPositionX(self.fields.icon_enemy2:getPositionX() + self.fields.icon_enemy2:getWidth() / 2)
		local atk4, hp4 = soldierRushCtrl:getArmyBuffByForce(4)
		soldierRushCtrl = nil
		;(nil).Atk = atk4 / 10 .. "%"
		;(nil).Hp = hp4 / 10 .. "%"
		self.fields.lab_enemy2:initData(num4, nil)
	else
		local percent_1 = math.max(math.min(num1 / totalArmy, 1 - self.minVal), self.minVal)
		self.fields.icon_self:setWidth(percent_1 * self.width)
		self.fields.lab_self:setPositionX(self.fields.icon_self:getPositionX() + self.fields.icon_self:getWidth() / 2)
		local atk1, hp1 = soldierRushCtrl:getArmyBuffByForce(1)
		soldierRushCtrl = math.max(1 - percent_1 - percent_3, self.minVal)
		math.max(1 - percent_1 - percent_3, self.minVal).Atk = atk1 / 10 .. "%"
		math.max(1 - percent_1 - percent_3, self.minVal).Hp = hp1 / 10 .. "%"
		self.fields.lab_self:initData(num1, (math.max(1 - percent_1 - percent_3, self.minVal)))
		local percent_3 = math.max(1 - percent_1, self.minVal)
		self.fields.icon_enemy1:setWidth(percent_3 * self.width)
		self.fields.lab_enemy1:setPositionX(self.fields.icon_enemy1:getPositionX() - self.fields.icon_enemy1:getWidth() / 2)
		local atk3, hp3 = soldierRushCtrl:getArmyBuffByForce(3)
		soldierRushCtrl = self.fields.lab_enemy2.initData
		self.fields.lab_enemy2.initData.Atk = atk3 / 10 .. "%"
		self.fields.lab_enemy2.initData.Hp = hp3 / 10 .. "%"
		self.fields.lab_enemy1:initData(num3, self.fields.lab_enemy2.initData)
	end
end
return Bar_rush
