local soldierRushRead = include("soldierRushRead")
local soldierRushCtrl = SoraDGetCtrl("soldierRushCtrl")
local technologyCtrl = SoraDGetCtrl("technologyCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_operate = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://SoldierRush/Btn_operate", Btn_operate)
function Btn_operate:onInit()
	self.cost = 0
	self:addClickListener(handler(self, self.onClick))
end
function Btn_operate:onShow()
end
function Btn_operate:initData(index, bid, gateID)
	self.bid = bid
	self.buildInfo = soldierRushCtrl:getBuildInfo(self.bid)
	if not self.buildInfo then
		return
	end
	local buildCfg = soldierRushRead.getBuildCfgByTypeAndLv(self.buildInfo.bType, self.buildInfo.lv)
	self.controllers.c1:setSelectedIndex(index - 1)
	self.index = index
	local changeReduce = technologyCtrl:getTechnologyPower(gTechnologyType.SOLDIER_RUSH_SWITCH_BUILD_REDUCE_COST_RESOURCE) or 0
	if index == 1 then
		local lvCfg = soldierRushRead.getLevelCfg(gateID)
		print("self.buildInfo.armyNum,buildCfg.UpgradeCost====", self.buildInfo.armyNum, buildCfg.UpgradeCost, self:isNotInCD())
		if self.buildInfo.lv < lvCfg.BuildLvLimit and self.buildInfo.armyNum >= buildCfg.UpgradeCost and self:isNotInCD() then
			self.controllers.c3:setSelectedIndex(0)
		else
			self.controllers.c3:setSelectedIndex(1)
		end
		print("self.buildInfo.lv,lvCfg.BuildLvLimit====", self.buildInfo.lv, lvCfg.BuildLvLimit)
		self.controllers.c2:setSelectedIndex(self.buildInfo.lv < lvCfg.BuildLvLimit and 0 or 1)
		self.fields.Text_lv:setString(buildCfg.UpgradeCost)
	elseif index == 4 then
		local cost = soldierRushRead.getConstantVal("Build_Change_Consum3")
		self.cost = cost - changeReduce
		self.fields.Text_lv:setString(self.cost)
		self.controllers.c3:setSelectedIndex(self:isNotInCD() and self.buildInfo.bType ~= 3 and self.buildInfo.armyNum >= self.cost and 0 or 1)
		self.controllers.c2:setSelectedIndex(self.buildInfo.bType == 3 and 1 or 0)
		self.toType = 3
	elseif index == 3 then
		local cost = soldierRushRead.getConstantVal("Build_Change_Consum2")
		self.cost = cost - changeReduce
		self.fields.Text_lv:setString(self.cost)
		self.controllers.c3:setSelectedIndex(self:isNotInCD() and self.buildInfo.bType ~= 2 and self.buildInfo.armyNum >= self.cost and 0 or 1)
		self.controllers.c2:setSelectedIndex(self.buildInfo.bType == 2 and 1 or 0)
		self.toType = 2
	elseif index == 2 then
		local cost = soldierRushRead.getConstantVal("Build_Change_Consum1")
		self.cost = cost - changeReduce
		self.fields.Text_lv:setString(self.cost)
		self.controllers.c3:setSelectedIndex(self:isNotInCD() and self.buildInfo.bType ~= 1 and self.buildInfo.armyNum >= self.cost and 0 or 1)
		self.controllers.c2:setSelectedIndex(self.buildInfo.bType == 1 and 1 or 0)
		self.toType = 1
	end
end
function Btn_operate:isNotInCD()
	return self.buildInfo.upgradeCD == 0 and self.buildInfo.changeCD == 0
end
function Btn_operate:onClick()
	SoraDPlaySound()
	if self.controllers.c3:getSelectedIndex() == 0 then
		if self.index == 1 then
			_ENV = self.controllers.c3
			self.controllers.c3.msg = "MESSAGE_SOLDIERRUSH_UI_BUILD_UPGRADE"
			self.controllers.c3.bid = self.bid
			SoraDSendMessage(self.controllers.c3)
		else
			_ENV = self.controllers.c3
			self.controllers.c3.msg = "MESSAGE_SOLDIERRUSH_UI_BUILD_CHANGE"
			self.controllers.c3.bid = self.bid
			self.controllers.c3.cost = self.cost
			self.controllers.c3.toBtype = self.toType
			SoraDSendMessage(self.controllers.c3)
		end
		_ENV = self.controllers.c3
		self.controllers.c3.msg = "MESSAGE_SOLDIERRUSH_UI_BUILD_MENU"
		self.controllers.c3.bid = self.bid
		self.controllers.c3.isOpen = false
		SoraDSendMessage(self.controllers.c3)
	end
end
return Btn_operate
