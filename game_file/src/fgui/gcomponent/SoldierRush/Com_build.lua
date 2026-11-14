local soldierRushRead = include("soldierRushRead")
local soldierRushCtrl = SoraDGetCtrl("soldierRushCtrl")
local LONG_PRESS_TIME = 0.1
local AI_SEARCH_RANGE = 240
local baseComponent = require("fgui.base.baseComponent")
local Com_build = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SoldierRush/Com_build", Com_build)
function Com_build:onInit()
	self.time = 0
	self.armyNum = 0
	self.upgradeCD = 0
	self.isDoUpgrade = false
	self.isInterrupt_upgrade = false
	self.changeCD = 0
	self.isInterrupt_change = false
	self.status = 0
	self.lv = 1
	self.offset = 30
	self.isLong = false
	self.deltaAdd = 0
	self.fields.com_helpme:setVisible(false)
	self.fields.icon_up:setVisible(false)
	self.fields.lab_cost:setVisible(false)
	self.fields.text_add:setVisible(false)
	self.fields.choose:setVisible(false)
	self.fields.mv_uping1:setVisible(false)
	self.fields.mv_uping1:setAllFrameName("dh_Tex_XL_bcxt04_%03d.png", 0)
	self.fields.mv_uping2:setVisible(false)
	self.fields.mv_uping2:setAllFrameName("dh_Tex_XL_bcxt0402_%03d.png", 0)
	self.fields.mv_doneup2:setVisible(false)
	self.fields.mv_doneup2:setAllFrameName("dh_Tex_XL_bcxt0502_%03d.png", 1)
	self.fields.mv_doneup1:setVisible(false)
	self.fields.mv_doneup1:setAllFrameName("dh_Tex_XL_bcxt0501_%03d.png", 1)
	_UPVALUE9_ = self.fields.mv_doneup1.setAllFrameName
	self.fields.mv_doneup1.setAllFrameName[1] = "mv_fire_jt1"
	self.fields.mv_doneup1.setAllFrameName[2] = "mv_fire_jt2"
	self.fields.mv_doneup1.setAllFrameName[3] = "mv_fire_jt3"
	self.fields.mv_doneup1.setAllFrameName[4] = "mv_fire_zy1"
	self.fields.mv_doneup1.setAllFrameName[5] = "mv_fire_zy2"
	self.fields.mv_doneup1.setAllFrameName[6] = "mv_fire_zy3"
	self.fields.mv_doneup1.setAllFrameName[7] = "mv_fire_by1"
	self.fields.mv_doneup1.setAllFrameName[8] = "mv_fire_by2"
	local self.fields.mv_doneup1.setAllFrameName[9], mvNameCfg = "mv_fire_by3", self.fields.mv_doneup1.setAllFrameName
	for k, v in ipairs(mvNameCfg) do
		self.fields[v]:setVisible(false)
		self.fields[v]:setAllFrameName("dh_Tex_XL_bcxt06_%03d.png", 2)
	end
	self.fields.mv_th1:setVisible(false)
	self.fields.mv_th1:setAllFrameName("dh_Tex_XL_bcxt0802_%03d.png", 1)
	self.fields.mv_th2:setVisible(false)
	self.fields.mv_th2:setAllFrameName("dh_Tex_XL_bcxt0803_%03d.png", 1)
	self.fields.mv_th3:setVisible(false)
	self.fields.mv_th3:setAllFrameName("dh_Tex_XL_bcxt0801_%03d.png", 1)
	self.fields.mv_shoot1:setVisible(false)
	self.fields.mv_shoot1:setAllFrameName("dh_Tex_XL_bcxt1201_%03d.png", 8)
	self.fields.mv_shoot2:setVisible(false)
	self.fields.mv_shoot2:setAllFrameName("dh_bcxt_jian_%.2d.png", 1)
	self.fields.mv_idle:setVisible(false)
	self.fields.mv_idle:setAllFrameName("dh_bc_gq_%02d.png", 1)
	self.fields.mv_zl1:setVisible(false)
	self.fields.mv_zl1:setAllFrameName("dh_Tex_XL_bcxt0701_%03d.png", 1)
	self.fields.mv_zl2:setVisible(false)
	self.fields.mv_zl2:setAllFrameName("dh_Tex_XL_bcxt0702_%03d.png", 1)
	self.fields.mv_zl3:setVisible(false)
	self.fields.mv_zl3:setAllFrameName("dh_Tex_XL_bcxt0703_%03d.png", 1)
	self.fields.mv_zl4:setVisible(false)
	self.fields.mv_zl4:setAllFrameName("dh_Tex_XL_bcxt0704_%03d.png", 1)
	self.fields.lab_lv:setGroupID(5)
	self.fields.lab_lv:setGroupAuto(true)
	self.fields.guide:setGroupID(5)
	self.fields.guide:setGroupAuto(true)
	self.fields.choose:setGroupID(5)
	self.fields.choose:setGroupAuto(true)
	self:addClickListener(handler(self, self.onClick))
	self:addEventListener(fgui.UIEventType.TouchBegin, function(context)
		context:captureTouch()
		self.t_bTime = os.clock()
		self.isLong = false
		self.selectBid = self.bid
	end)
	self:addEventListener(fgui.UIEventType.TouchMove, function(context)
		local cur_Time = os.clock()
		if cur_Time - self.t_bTime <= LONG_PRESS_TIME then
			return
		end
		self.isLong = true
		if self.force == 1 and self.selectBid then
			self.toPos = context:getInput():getPosition()
			self.fields.guide:setVisible(false)
			_ENV = self.fields.guide
			self.fields.guide.msg = "MESSAGE_SOLDIERRUSH_UI_ARROW"
			self.fields.guide.bid = self.selectBid
			self.fields.guide.toPos = self.toPos
			SoraDSendMessage(self.fields.guide)
		end
	end)
	self:addEventListener(fgui.UIEventType.TouchEnd, function(context)
		if self.isLong then
			self = nil
			;(nil).msg = "MESSAGE_SOLDIERRUSH_UI_ARROW"
			SoraDSendMessage(nil)
		end
		if self.isLong and self.force == 1 and self.selectBid and self.toPos then
			local toBid = soldierRushCtrl:getBuildByPos(self.toPos)
			if toBid then
				local disPro = soldierRushCtrl:getDispatchPro()
				self:disPatchArmy(self.selectBid, self.force, toBid, disPro)
			else
				self.selectBid = nil
			end
		end
	end)
end
function Com_build:disPatchArmy(bid, force, toBid, disPro)
	print("bid,force,toBid,disPro====", bid, force, toBid, disPro)
	if toBid and bid ~= toBid then
		local disptch_num = math.floor(self.armyNum * disPro)
		if disptch_num <= 0 and self.armyNum > 0 then
			disptch_num = self.armyNum
		end
		local curArmyNum = self.armyNum
		if 0 < disptch_num then
			if disptch_num <= 8 then
				_ENV = force
				force.msg = "MESSAGE_SOLDIERRUSH_UI_DISPATCH_ARMY"
				force.bid = bid
				force.toBid = toBid
				force.force = force
				force.num = disptch_num
				force.gIndex = 1
				SoraDSendMessage(force)
				self.armyNum = self.armyNum - disptch_num
				self:setArmyNum(self.armyNum)
				_ENV = disPro
				disPro.armyNum = self.armyNum
				self:updateBuild(bid, disPro)
				self.selectBid = nil
				if force == 1 then
					SoraDPlaySound("innerbuildsound", 118)
				else
					SoraDPlaySound("innerbuildsound", 205)
				end
			else
				local selectBid = bid
				self.selectBid = nil
				local targetNum = disptch_num
				print("派兵========", targetNum)
				self.armyNum = self.armyNum - disptch_num
				_ENV = nil
				;(nil).armyNum = self.armyNum
				self:updateBuild(selectBid, nil)
				soldierRushCtrl:setDispatchStatus(force)
				if force == 1 then
					SoraDPlaySound("innerbuildsound", 118)
				else
					SoraDPlaySound("innerbuildsound", 205)
				end
				local gIndex = 1
				while 0 < targetNum do
					local dispatchNum = math.min(8, targetNum)
					_ENV = targetNum
					targetNum.msg = "MESSAGE_SOLDIERRUSH_UI_DISPATCH_ARMY"
					targetNum.bid = selectBid
					targetNum.toBid = toBid
					targetNum.force = force
					targetNum.num = dispatchNum
					targetNum.gIndex = gIndex
					SoraDSendMessage(targetNum)
					targetNum = math.max(0, targetNum - 8)
					gIndex = gIndex + 1
				end
			end
		else
			self.selectBid = nil
		end
	end
end
function Com_build:onShow()
end
function Com_build:getTopLv()
	return self.fields.lab_lv
end
function Com_build:pauseEffect()
	for k, v in ipairs(self:getChildren()) do
		if string.find(v:getName(), "mv_") then
			v:setPlaying(false)
		end
	end
	self.transitions.t0:stop()
	self:getActionManager():pauseTarget(self)
end
function Com_build:resumeEffect()
	for k, v in ipairs(self:getChildren()) do
		if string.find(v:getName(), "mv_") then
			v:setPlaying(true)
		end
	end
	self.transitions.t0:play(-1, 0)
	self:getActionManager():resumeTarget(self)
end
function Com_build:showEffectUpgrading(ret)
	self.fields.mv_uping1:setVisible(ret)
	self.fields.mv_uping2:setVisible(ret)
end
function Com_build:showEffectDoneUpgrade(ret)
	self.fields.mv_doneup2:setVisible(ret)
	self.fields.mv_doneup2:setPlaySettings(0, -1, 1, -1, function()
		self.fields.mv_doneup2:setVisible(false)
	end)
	self.fields.mv_doneup1:setVisible(ret)
	self.fields.mv_doneup1:setPlaySettings(0, -1, 1, -1, function()
		self.fields.mv_doneup1:setVisible(false)
	end)
end
function Com_build:showEffectBeAttack(ret)
	self.controllers.c2:setSelectedIndex(ret and self.bType or 0)
	_UPVALUE9_ = self.controllers.c2.setSelectedIndex
	self.controllers.c2.setSelectedIndex[1] = "mv_fire_jt1"
	self.controllers.c2.setSelectedIndex[2] = "mv_fire_jt2"
	self.controllers.c2.setSelectedIndex[3] = "mv_fire_jt3"
	self.controllers.c2.setSelectedIndex[4] = "mv_fire_zy1"
	self.controllers.c2.setSelectedIndex[5] = "mv_fire_zy2"
	self.controllers.c2.setSelectedIndex[6] = "mv_fire_zy3"
	self.controllers.c2.setSelectedIndex[7] = "mv_fire_by1"
	self.controllers.c2.setSelectedIndex[8] = "mv_fire_by2"
	local self.controllers.c2.setSelectedIndex[9], mvNameCfg = "mv_fire_by3", self.controllers.c2.setSelectedIndex
	for k, v in ipairs(mvNameCfg) do
		self.fields[v]:setVisible(ret)
	end
end
function Com_build:showEffectReplace(ret)
	self.fields.mv_th1:setVisible(ret)
	self.fields.mv_th2:setVisible(ret)
	self.fields.mv_th3:setVisible(ret)
	if ret then
		self.fields.mv_th1:setPlaySettings(0, -1, 1, -1, function()
			self.fields.mv_th1:setVisible(false)
		end)
		self.fields.mv_th2:setPlaySettings(0, -1, 1, -1, function()
			self.fields.mv_th2:setVisible(false)
		end)
		self.fields.mv_th3:setPlaySettings(0, -1, 1, -1, function()
			self.fields.mv_th3:setVisible(false)
		end)
	end
end
function Com_build:showEffectBeOccupy()
	self.fields.mv_zl1:setVisible(true)
	self.fields.mv_zl1:setPlaySettings(0, -1, 1, -1, function()
		self.fields.mv_zl1:setVisible(false)
	end)
	self.fields.mv_zl2:setVisible(true)
	self.fields.mv_zl2:setPlaySettings(0, -1, 1, -1, function()
		self.fields.mv_zl2:setVisible(false)
	end)
	self.fields.mv_zl3:setVisible(true)
	self.fields.mv_zl3:setPlaySettings(0, -1, 1, -1, function()
		self.fields.mv_zl3:setVisible(false)
	end)
	self.fields.mv_zl4:setVisible(true)
	self.fields.mv_zl4:setPlaySettings(0, -1, 1, -1, function()
		self.fields.mv_zl4:setVisible(false)
	end)
end
function Com_build:showEffectTowerShoot(obj)
	self.fields.mv_shoot2:stopAllActions()
	self.fields.mv_shoot2:setVisible(false)
	self.fields.mv_shoot2:setPosition(70, 46)
	local pos1 = self:localToGlobal(cc.p(60, 60))
	local pos2 = obj:localToGlobal(cc.p(0, 0))
	local rotation = SoraDGetAngleByPos(pos1, pos2) + 180
	local toPos = self:globalToLocal(pos2)
	self.fields.mv_shoot1:setRotation(rotation)
	self.fields.mv_shoot1:setVisible(true)
	self.fields.mv_shoot1:setPlaySettings(0, -1, 1, -1, function()
		self.fields.mv_shoot1:setVisible(false)
	end)
	self.fields.mv_shoot2:setRotation(rotation)
	self.fields.mv_shoot2:setVisible(true)
	self.fields.mv_shoot2:setPlaySettings(0, -1, 1)
	SoraDPlaySound("epicWar", 3)
	_UPVALUE1_ = -1
	;(-1)[1] = ffa.moveTo(0.1, toPos.x, toPos.y)
	;(-1)[2] = ffa.callFunc(function()
		self.fields.mv_shoot2:setVisible(false)
		self.fields.mv_shoot2:setPosition(70, 46)
	end)
	;(-1)[3] = ffa.callFunc(function()
		self.fields.mv_shoot2:setVisible(false)
		self.fields.mv_shoot2:setPosition(70, 46)
	end)
	;(-1)[4] = ffa.callFunc(function()
		self.fields.mv_shoot2:setVisible(false)
		self.fields.mv_shoot2:setPosition(70, 46)
	end)
	self.fields.mv_shoot2:runAction(ffa.seq(-1))
end
function Com_build:showEffectIdle()
	self.fields.mv_idle:setVisible(true)
	self.fields.mv_idle:setPlaySettings(0, -1, 3, -1, function()
		self.fields.mv_idle:setVisible(false)
	end)
end
function Com_build:showEffectSoul(force, num)
	math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
	num = math.min(num, 3)
	for i = 1, num do
		do
			local soul = fgui.UIPackage:createObjectFromURL("ui://SoldierRush/Com_soul")
			soul:setIcon(soldierRushRead.getArmySoul(force))
			soul:addTo(self, 999)
			soul:setPosition(math.random(140, 760) / 10, math.random(250, 380) / 10)
			soul:setAlpha(0)
			soldierRushRead = math.random(250, 380) / 10
			soldierRushRead = 380
			_UPVALUE2_ = soldierRushRead.getArmySoul(force)
			soldierRushRead.getArmySoul(force)[1] = ffa.fadeIn(0.3)
			soldierRushRead.getArmySoul(force)[2] = ffa.delay(0.4)
			soldierRushRead.getArmySoul(force)[3] = ffa.fadeOut(0.3)
			soldierRushRead.getArmySoul(force)[4] = ffa.fadeOut(0.3)
			;(380)[1] = ffa.seq(soldierRushRead.getArmySoul(force))
			;(380)[2] = ffa.moveBy(1, 0, -60)
			;(380)[3] = ffa.moveBy(1, 0, -60)
			;(380)[4] = ffa.moveBy(1, 0, -60)
			;(380)[5] = ffa.moveBy(1, 0, -60)
			;(380)[6] = ffa.moveBy(1, 0, -60)
			;(math.random(250, 380) / 10)[1] = ffa.spawn(380)
			;(math.random(250, 380) / 10)[2] = ffa.callFunc(function()
				soul:removeFromParent()
			end)
			;(math.random(250, 380) / 10)[3] = ffa.callFunc(function()
				soul:removeFromParent()
			end)
			;(math.random(250, 380) / 10)[4] = ffa.callFunc(function()
				soul:removeFromParent()
			end)
			;(math.random(250, 380) / 10)[5] = ffa.callFunc(function()
				soul:removeFromParent()
			end)
			;(math.random(250, 380) / 10)[6] = ffa.callFunc(function()
				soul:removeFromParent()
			end)
			;(math.random(250, 380) / 10)[7] = ffa.callFunc(function()
				soul:removeFromParent()
			end)
			;(math.random(250, 380) / 10)[8] = ffa.callFunc(function()
				soul:removeFromParent()
			end)
			soul:runAction(ffa.seq(math.random(250, 380) / 10))
		end
	end
end
function Com_build:setChooseVisible(ret)
	self.fields.choose:setVisible(ret)
end
function Com_build:reset()
	self.time = 0
	self.status = 0
	self.deltaAdd = 0
	self.upgradeCD = 0
	self.isDoUpgrade = false
	self.isInterrupt_upgrade = true
	self.changeCD = 0
	self.isInterrupt_change = true
	self:hideAllEffect()
end
function Com_build:update()
	self.time = self.time + 1
	self:updateArmy()
	self:checkLvUp()
	self:checkStatus()
	self:checkHelp()
	if self.isDoUpgrade then
		self.upgradeCD = math.max(0, self.upgradeCD - 1)
		if self.upgradeCD == 0 then
			self:doneUpgrade()
		end
	end
	self:checkAIEvent()
	_ENV = nil
	;(nil).upgradeCD = self.upgradeCD
	;(nil).changeCD = self.changeCD
	;(nil).bType = self.bType
	;(nil).armyNum = self.armyNum
	;(nil).force = self.force
	;(nil).lv = self.lv
	;(nil).status = self.status
	self:updateBuild(self.bid, nil)
end
function Com_build:updateArmy()
	local buildCfg = soldierRushRead.getBuildCfgByTypeAndLv(self.bType, self.lv)
	local maxLimit = buildCfg.ArmyLimit
	if self.force == 2 and self.midLimit then
		maxLimit = self.midLimit
	end
	if next(buildCfg.AddArmy) and maxLimit > self.armyNum then
		self.deltaAdd = self.deltaAdd + buildCfg.AddArmy[1] * 1000 / buildCfg.AddArmy[2]
		if self.deltaAdd >= 1 then
			self.armyNum = math.min(math.floor(self.armyNum + self.deltaAdd), maxLimit)
			self.deltaAdd = self.deltaAdd - math.floor(self.deltaAdd)
		end
	end
	self:setArmyNum(self.armyNum)
end
function Com_build:upgrade(cost, cd)
	self.isInterrupt_upgrade = false
	self.armyNum = self.armyNum - cost
	_UPVALUE0_ = nil
	;(nil).armyNum = self.armyNum
	self:updateBuild(self.bid, nil)
	self:doCostAction(cost)
	self:showEffectUpgrading(true)
	self.upgradeCD = cd
	self.isDoUpgrade = true
end
function Com_build:doCostAction(num)
	self.fields.lab_cost:setString(-num)
	self.fields.lab_cost:setVisible(true)
	self.fields.lab_cost:setAlpha(1)
	_UPVALUE2_ = nil
	;(nil)[1] = ffa.moveTo(1.2, self.fields.lab_cost:getPositionX(), self.fields.lab_lv:getPositionY() + 25)
	;(nil)[2] = ffa.fadeOut(0.5)
	;(nil)[3] = ffa.callFunc(function()
		self.fields.lab_cost:setVisible(false)
		self.fields.lab_cost:setPosition(self.fields.lab_cost:getPositionX(), self.fields.lab_lv:getPositionY())
	end)
	;(nil)[4] = ffa.callFunc(function()
		self.fields.lab_cost:setVisible(false)
		self.fields.lab_cost:setPosition(self.fields.lab_cost:getPositionX(), self.fields.lab_lv:getPositionY())
	end)
	;(nil)[5] = ffa.callFunc(function()
		self.fields.lab_cost:setVisible(false)
		self.fields.lab_cost:setPosition(self.fields.lab_cost:getPositionX(), self.fields.lab_lv:getPositionY())
	end)
	self.fields.lab_cost:runAction(ffa.seq(nil))
end
function Com_build:doAddAction(num)
	if num == 0 then
		return
	end
	local str = num
	if 0 < num then
		str = "+" .. num
	end
	self.fields.text_add:setString(str)
	self.fields.text_add:setVisible(true)
	self.fields.text_add:setAlpha(1)
	_UPVALUE2_ = nil
	;(nil)[1] = ffa.moveTo(1.2, self.fields.text_add:getPositionX(), self.fields.lab_lv:getPositionY() - 25)
	;(nil)[2] = ffa.fadeOut(0.5)
	;(nil)[3] = ffa.callFunc(function()
		self.fields.text_add:setVisible(false)
		self.fields.text_add:setPosition(self.fields.text_add:getPositionX(), self.fields.lab_lv:getPositionY())
	end)
	;(nil)[4] = ffa.callFunc(function()
		self.fields.text_add:setVisible(false)
		self.fields.text_add:setPosition(self.fields.text_add:getPositionX(), self.fields.lab_lv:getPositionY())
	end)
	;(nil)[5] = ffa.callFunc(function()
		self.fields.text_add:setVisible(false)
		self.fields.text_add:setPosition(self.fields.text_add:getPositionX(), self.fields.lab_lv:getPositionY())
	end)
	self.fields.text_add:runAction(ffa.seq(nil))
end
function Com_build:doneUpgrade()
	if self.isInterrupt_upgrade then
		return
	end
	SoraDPlaySound("innercontrol", 1)
	self.upgradeCD = 0
	self.isDoUpgrade = false
	local buildCfg1 = soldierRushRead.getBuildCfgByTypeAndLv(self.bType, self.lv)
	self.lv = math.min(self.lv + 1, 5)
	local buildCfg2 = soldierRushRead.getBuildCfgByTypeAndLv(self.bType, self.lv)
	_ENV = nil
	;(nil).lv = self.lv
	self:updateBuild(self.bid, nil)
	self:updateView()
	self:doAddAction(buildCfg2.ArmyLimit - buildCfg1.ArmyLimit)
	self:showEffectUpgrading(false)
	self:showEffectDoneUpgrade(true)
	_ENV = self
	self.msg = "MESSAGE_SOLDIERRUSH_UI_GUIDE_UPGRADE"
	SoraDSendMessage(self)
end
function Com_build:change(cost, cd)
	self.isInterrupt_change = false
	self.changeCD = cd
	self.armyNum = self.armyNum - cost
	_UPVALUE0_ = nil
	;(nil).armyNum = self.armyNum
	self:updateBuild(self.bid, nil)
	self:doCostAction(cost)
	self:showEffectUpgrading(true)
end
function Com_build:doneChange(toBtype)
	if self.isInterrupt_change then
		return
	end
	SoraDPlaySound("innercontrol", 1)
	self.changeCD = 0
	self.deltaAdd = 0
	self.lv = 1
	self.bType = toBtype
	_ENV = nil
	;(nil).lv = self.lv
	;(nil).bType = self.bType
	self:updateBuild(self.bid, nil)
	self:showEffectUpgrading(false)
	self:showEffectReplace(true)
	self:updateView()
end
function Com_build:distanceInRange(obj1, obj2, range)
	local pos1 = obj1:localToGlobal(cc.p(60, 72))
	local pos2 = obj2:localToGlobal(cc.p(0, 0))
	local a = range
	local b = 0.525 * range
	if (pos2.x - pos1.x) * (pos2.x - pos1.x) / (a * a) + (pos2.y - pos1.y) * (pos2.y - pos1.y) / (b * b) <= 1 then
		return true
	end
	return false
end
function Com_build:towerAttack()
	if self.bType == 2 then
		self:stopAllActions()
		local buildCfg = soldierRushRead.getBuildCfgByTypeAndLv(self.bType, self.lv)
		_ENV = nil
		;(nil)[1] = ffa.callFunc(function()
			local armyQueue = soldierRushCtrl:getAttackQueue(self.force)
			if 0 < #armyQueue then
				local isKill = false
				for k, v in ipairs(armyQueue) do
					if not tolua.isnull(v) and v:isVisible() and 0 < v.num then
						for i = 1, 8 do
							local army = v:getArmy(i)
							if army:isVisible() then
								local isIn = self:distanceInRange(self, army, buildCfg.AtkRange * self.offset)
								if isIn then
									isKill = true
									self:showEffectTowerShoot(army)
									v:showBeAtk(i)
									v.num = math.max(0, v.num - 1)
									print("剩余士兵数量======", v.num)
									print("射击间隔", buildCfg.AtkSpeed / 1000)
									v:setArmyNum(v.num, i)
									if 0 >= v.num then
										v:setVisible(false)
										soldierRushCtrl:delDispatchStatus(v.force)
									end
									break
								end
							end
						end
						if isKill then
							break
						end
					end
				end
			end
		end)
		;(nil)[2] = ffa.delay(buildCfg.AtkSpeed / 1000)
		;(nil)[3] = ffa.delay(buildCfg.AtkSpeed / 1000)
		local action = ffa.repeatForever((ffa.seq(nil)))
		self:runAction(action)
	else
		self:stopAllActions()
	end
end
function Com_build:updateView()
	local buildPng
	local buildCfg = soldierRushRead.getBuildCfgByTypeAndLv(self.bType, self.lv)
	self.fields.range:setVisible(false)
	local color = cc.c3b(255, 255, 255)
	if self.force == 1 then
		buildPng = buildCfg.OwnLook
		self.controllers.c1:setSelectedIndex(0)
		color = cc.c3b(126, 200, 66)
	elseif self.force == 2 then
		buildPng = buildCfg.NeutralLook
		self.controllers.c1:setSelectedIndex(2)
	elseif self.force == 3 then
		buildPng = buildCfg.EnemyLook1
		self.controllers.c1:setSelectedIndex(1)
		color = cc.c3b(223, 26, 38)
	elseif self.force == 4 then
		buildPng = buildCfg.EnemyLook2
		self.controllers.c1:setSelectedIndex(1)
	end
	self.fields.range:setVisible(self.bType == 2)
	self.fields.range:setColor(color)
	if self.bType == 2 then
		local buildCfg = soldierRushRead.getBuildCfgByTypeAndLv(self.bType, self.lv)
		self.fields.range:setWidth(buildCfg.AtkRange * self.offset * 2)
		self.fields.range:setHeight(buildCfg.AtkRange * self.offset * 0.525 * 2)
		self.fields.range:setGroupID(1)
		self.fields.range:setGroupAuto(true)
	end
	self:towerAttack()
	self.fields.icon:setSpriteFrame(buildPng)
end
function Com_build:hideAllEffect()
	self.fields.mv_uping1:setVisible(false)
	self.fields.mv_uping2:setVisible(false)
	self.fields.mv_doneup2:setVisible(false)
	self.fields.mv_doneup1:setVisible(false)
	_UPVALUE9_ = self.fields.mv_doneup1.setVisible
	self.fields.mv_doneup1.setVisible[1] = "mv_fire_jt1"
	self.fields.mv_doneup1.setVisible[2] = "mv_fire_jt2"
	self.fields.mv_doneup1.setVisible[3] = "mv_fire_jt3"
	self.fields.mv_doneup1.setVisible[4] = "mv_fire_zy1"
	self.fields.mv_doneup1.setVisible[5] = "mv_fire_zy2"
	self.fields.mv_doneup1.setVisible[6] = "mv_fire_zy3"
	self.fields.mv_doneup1.setVisible[7] = "mv_fire_by1"
	self.fields.mv_doneup1.setVisible[8] = "mv_fire_by2"
	local self.fields.mv_doneup1.setVisible[9], mvNameCfg = "mv_fire_by3", self.fields.mv_doneup1.setVisible
	for k, v in ipairs(mvNameCfg) do
		self.fields[v]:setVisible(false)
	end
	self.fields.mv_th1:setVisible(false)
	self.fields.mv_th2:setVisible(false)
	self.fields.mv_th3:setVisible(false)
	self.fields.mv_shoot1:setVisible(false)
	self.fields.mv_shoot2:setVisible(false)
	self.fields.mv_idle:setVisible(false)
	self.fields.mv_zl1:setVisible(false)
	self.fields.mv_zl2:setVisible(false)
	self.fields.mv_zl3:setVisible(false)
	self.fields.mv_zl4:setVisible(false)
end
function Com_build:initData(data, gateID)
	self.data = data
	self.gateID = gateID
	self.bid = self.data.bid
	self.force = self.data.force
	self.bType = self.data.bType
	self.lv = self.data.initLv
	self.x = self.data.x
	self.y = self.data.y
	self.armyNum = self.data.initArmy
	self.centerPos = self:localToScreen(cc.p(114, 145))
	self.lvCfg = soldierRushRead.getLevelCfg(self.gateID)
	self:hideAllEffect()
	if self.force == 1 then
		self.fields.guide:setVisible(true)
		self:checkLvUp()
		self:setArmyNum(self.armyNum)
		self:showEffectIdle()
	elseif self.force == 2 then
		self:setArmyNum(self.armyNum)
		self.midLimit = self.data.initArmy
	elseif self.force == 3 then
		self:setArmyNum(self.armyNum, true)
		self.fields.lab_lv:setAlpha(1)
		if self.lvCfg.ShowEnemySoldier == 1 then
			self.fields.lab_lv:runAction(ffa.fadeOut(3))
		end
	elseif self.force == 4 then
		self:setArmyNum(self.armyNum, true)
		self.fields.lab_lv:setAlpha(1)
		if self.lvCfg.ShowEnemySoldier == 1 then
			self.fields.lab_lv:runAction(ffa.fadeOut(3))
		end
	end
	self:updateView()
end
function Com_build:checkLvUp()
	local buildCfg = soldierRushRead.getBuildCfgByTypeAndLv(self.bType, self.lv)
	self.fields.icon_up:setVisible(self.force == 1 and self.armyNum >= buildCfg.UpgradeCost and self.lv < self.lvCfg.BuildLvLimit and self.upgradeCD == 0 and self.changeCD == 0)
end
function Com_build:checkHelp()
	self.fields.com_helpme:setVisible(self.force == 1 and self.status ~= 0)
end
function Com_build:checkStatus()
	local status = 0
	if self.force == 1 then
		local num = 0
		for k, v in ipairs(soldierRushCtrl:getEnemyQueue()) do
			if v.toBid and v.toBid == self.bid then
				if self.status == 0 then
					status = 1
				end
				num = num + 1
				break
			end
		end
		if num == 0 then
			status = 0
		end
		self:setStatus(status)
	else
		local num = 0
		for k, v in ipairs(soldierRushCtrl:getArmyQueue()) do
			if v.toBid and v.toBid == self.bid then
				if self.status == 0 then
					status = 1
				end
				num = num + 1
				break
			end
		end
		if num == 0 then
			status = 0
		end
		self:setStatus(status)
	end
end
function Com_build:setStatus(status, isChangeForce)
	self.status = status
	self:showEffectBeAttack(self.status == 2)
	if self.status == 2 then
		if isChangeForce then
			self:showEffectUpgrading(false)
			self:showEffectDoneUpgrade(false)
			self:showEffectReplace(false)
		end
		if self.upgradeCD > 0 then
			self.isInterrupt_upgrade = true
			self.upgradeCD = 0
			self.isDoUpgrade = false
			self:showEffectUpgrading(false)
		end
	end
end
function Com_build:setArmyNum(num, isInit)
	local buildCfg = soldierRushRead.getBuildCfgByTypeAndLv(self.bType, self.lv)
	self.fields.lab_lv:setNum(num, buildCfg.ArmyLimit)
	if not isInit then
		if self.lvCfg.ShowEnemySoldier == 1 and (self.force == 3 or self.force == 4) then
			self.fields.lab_lv:setAlpha(0)
		else
			self.fields.lab_lv:setAlpha(1)
		end
	end
end
function Com_build:event(bid, force, num)
	if num <= 0 then
		return
	end
	if force == self.force then
		local buildCfg = soldierRushRead.getBuildCfgByTypeAndLv(self.bType, self.lv)
		self.armyNum = math.min(self.armyNum + num, soldierRushRead.getConstantVal("Build_Army_Limit"))
		soldierRushRead = soldierRushRead.getConstantVal("Build_Army_Limit")
		soldierRushRead.getConstantVal("Build_Army_Limit").armyNum = self.armyNum
		self:updateBuild(bid, soldierRushRead.getConstantVal("Build_Army_Limit"))
		self:setArmyNum(self.armyNum)
		self:checkLvUp()
	else
		if 0 < self.armyNum then
			local armyCfg = soldierRushRead.getArmyConfig(self.force, self.gateID)
			local myArmyCfg = soldierRushRead.getArmyConfig(force, self.gateID)
			local atk1, hp1 = soldierRushCtrl:getArmyBuffByForce(self.force)
			local atk2, hp2 = soldierRushCtrl:getArmyBuffByForce(force)
			local myAtk = myArmyCfg.Atk
			local myHp = myArmyCfg.Hp
			local heAtk = armyCfg.Atk
			local heHp = armyCfg.Hp
			print("攻击方原攻击 血量=======", myAtk, myHp)
			print("防守方原攻击 血量=======", heAtk, heHp)
			local suppress = 0
			local debuff = 1
			if armyCfg.Level > myArmyCfg.Level then
				suppress = armyCfg.Level - myArmyCfg.Level
				debuff = soldierRushRead.getCoefficientVal(suppress)
				myAtk = myAtk * debuff
				myHp = myHp * debuff
			elseif armyCfg.Level < myArmyCfg.Level then
				suppress = myArmyCfg.Level - armyCfg.Level
				debuff = soldierRushRead.getCoefficientVal(suppress)
				heAtk = heAtk * debuff
				heHp = heHp * debuff
			end
			print("压制判断=========", armyCfg.Level, myArmyCfg.Level, suppress, debuff)
			print("压制处理后 攻击方原攻击 血量=======", myAtk, myHp)
			print("压制处理后 防守方原攻击 血量=======", heAtk, heHp)
			local defend_atk = self.armyNum * heAtk * (1 + atk1 / 1000)
			local defend_hp = self.armyNum * heHp * (1 + hp1 / 1000)
			local my_atk = num * myAtk * (1 + atk2 / 1000)
			local my_hp = num * myHp * (1 + hp2 / 1000)
			print("防守方数量 攻击 血量===", self.armyNum, defend_atk, defend_hp)
			print("攻击方数量 攻击 血量===", num, my_atk, my_hp)
			if defend_hp < my_atk then
				local leftNum = math.floor((my_hp - defend_atk) / myArmyCfg.Hp)
				self:beOccupy(force, leftNum)
				self:showEffectSoul(force, math.floor(my_hp - defend_atk))
				self:showEffectSoul(self.force, self.armyNum)
				self:setStatus(2, true)
			else
				print("防守方损失====", math.ceil(my_atk / armyCfg.Hp), math.ceil(my_atk / armyCfg.Hp) * armyCfg.Hp)
				self.armyNum = math.max(0, self.armyNum - math.ceil(my_atk / armyCfg.Hp))
				soldierRushRead = math.ceil(my_atk / armyCfg.Hp)
				math.ceil(my_atk / armyCfg.Hp).armyNum = self.armyNum
				self:updateBuild(bid, (math.ceil(my_atk / armyCfg.Hp)))
				self:setArmyNum(self.armyNum)
				self:showEffectSoul(force, math.floor(my_hp))
				self:showEffectSoul(self.force, math.floor(num * myAtk * (1 + atk2 / 1000)))
				self:setStatus(2)
			end
		else
			self:beOccupy(force, num)
			self:setStatus(2, true)
		end
		SoraDPlaySound("worldmap", 3)
	end
	soldierRushCtrl:delDispatchStatus(force)
end
function Com_build:beOccupy(force, num)
	self.deltaAdd = 0
	self.force = force
	self.lv = math.max(1, self.lv - soldierRushRead.getConstantVal("Reduce_Build_Lv"))
	local buildCfg = soldierRushRead.getBuildCfgByTypeAndLv(self.bType, self.lv)
	self.armyNum = num
	if self.force == 1 then
		self:doAddAction(buildCfg.ArmyLimit)
	end
	if 0 < self.changeCD then
		self.isInterrupt_change = true
		self.changeCD = 0
	end
	_ENV = "Reduce_Build_Lv"
	;("Reduce_Build_Lv").armyNum = self.armyNum
	;("Reduce_Build_Lv").force = self.force
	;("Reduce_Build_Lv").lv = self.lv
	self:updateBuild(self.bid, "Reduce_Build_Lv")
	self:showEffectBeOccupy()
	self:updateView()
	self:setArmyNum(self.armyNum)
	self.fields.guide:setVisible(false)
	_ENV = self.fields.guide
	self.fields.guide.msg = "MESSAGE_SOLDIERRUSH_UI_BUILD_MENU"
	SoraDSendMessage(self.fields.guide)
	_ENV = self.fields.guide
	self.fields.guide.msg = "MESSAGE_SOLDIERRUSH_UI_GUIDE_OCCUPY"
	self.fields.guide.bid = self.bid
	SoraDSendMessage(self.fields.guide)
end
function Com_build:onClick()
	SoraDPlaySound()
	if self.isLong then
		self.isLong = false
		return
	end
	if self.force == 1 then
		_ENV = nil
		;(nil).msg = "MESSAGE_SOLDIERRUSH_UI_HIDE_MINE_GUIDE"
		SoraDSendMessage(nil)
		if self:isNotInCD() then
			_ENV = self
			self.msg = "MESSAGE_SOLDIERRUSH_UI_BUILD_MENU"
			self.bid = self.bid
			self.isOpen = true
			SoraDSendMessage(self)
		else
			SoraDPlaySound("innerbuildsound", 204)
		end
	end
end
function Com_build:hideGuideArrow()
	self.fields.guide:setVisible(false)
end
function Com_build:isNotInCD()
	return self.upgradeCD == 0 and self.changeCD == 0
end
function Com_build:updateBuild(bid, param)
	local buildInfo = soldierRushCtrl:getBuildInfo(bid)
	if buildInfo then
		for key, val in pairs(param) do
			buildInfo[key] = val
		end
		soldierRushCtrl:setBuildInfo(bid, buildInfo)
	end
end
function Com_build:checkAIEvent()
	local _ENV, aiCfg
	if self.force == 3 then
		aiCfg = self.lvCfg.EnemyAi1
	elseif self.force == 4 then
		aiCfg = self.lvCfg.EnemyAi2
	end
	if next(aiCfg) then
		for k, v in ipairs(aiCfg) do
			local event = math.floor(v / 100)
			self["eventAI_" .. event](self, v)
		end
	end
end
function Com_build:eventAI_1(event)
	local aiCfg = soldierRushRead.getAiCfg(event)
	if self.time % aiCfg.IntervalTime == 0 and self.time >= aiCfg.StartTime then
		local buildCfg = soldierRushRead.getBuildCfgByTypeAndLv(self.bType, self.lv)
		if self.lv < self.lvCfg.BuildLvLimit and self.armyNum >= buildCfg.UpgradeCost and self:isNotInCD() then
			soldierRushRead = self
			self.msg = "MESSAGE_SOLDIERRUSH_UI_BUILD_UPGRADE"
			self.bid = self.bid
			SoraDSendMessage(self)
		end
	end
end
function Com_build:eventAI_2(event)
	local aiCfg = soldierRushRead.getAiCfg(event)
	if self.time % aiCfg.IntervalTime == 0 and self.time >= aiCfg.StartTime then
		local soldierRushRead, bList = self.time, self.time
		local canDispatchNum = math.floor(self.armyNum * (aiCfg.ActionPara / 1000))
		if canDispatchNum == 0 and 0 < self.armyNum then
			canDispatchNum = self.armyNum
		end
		for k, v in ipairs(soldierRushCtrl:getBuildList()) do
			if v.force ~= self.force and v.bid ~= self.bid then
				local dis = math.sqrt((v.x - self.x) * (v.x - self.x) + (v.y - self.y) * (v.y - self.y))
				local armyCfg = soldierRushRead.getArmyConfig(v.force, self.gateID)
				local atk1, hp1 = soldierRushCtrl:getArmyBuffByForce(v.force)
				local myArmyCfg = soldierRushRead.getArmyConfig(self.force, self.gateID)
				local atk2, hp2 = soldierRushCtrl:getArmyBuffByForce(self.force)
				local cost = v.armyNum * armyCfg.Atk * (1 + atk1 / 1000)
				local isCanOCP = v.armyNum * armyCfg.Hp * (1 + hp1 / 1000) < canDispatchNum * myArmyCfg.Atk * (1 + atk2 / 1000) and cost < canDispatchNum * myArmyCfg.Hp * (1 + hp2 / 1000)
				local score = dis * cost
				if dis * self.offset <= AI_SEARCH_RANGE and isCanOCP then
					soldierRushRead = soldierRushCtrl:getBuildList()
					soldierRushCtrl:getBuildList().bid = k
					soldierRushCtrl:getBuildList().score = score
					soldierRushCtrl:getBuildList().isCanOCP = isCanOCP
					table.insert(bList, soldierRushCtrl:getBuildList())
				end
			end
		end
		if 0 < #bList and 0 < canDispatchNum then
			table.sort(bList, function(a, b)
				return a.score < b.score
			end)
			local disPro = aiCfg.ActionPara / 1000
			local toBid = bList[1].bid
			local curLunchArmyNum = soldierRushCtrl:getEnemyQueueNumToBid(self.force, toBid)
			if curLunchArmyNum < aiCfg.ActionLimit then
				self:disPatchArmy(self.bid, self.force, toBid, disPro)
			end
		end
	end
end
function Com_build:eventAI_3(event)
	local aiCfg = soldierRushRead.getAiCfg(event)
	if self.time % aiCfg.IntervalTime == 0 and self.time >= aiCfg.StartTime then
		local soldierRushRead, bList = self.time, self.time
		for k, v in ipairs(soldierRushCtrl:getBuildList()) do
			if v.force == self.force then
				soldierRushRead = soldierRushCtrl:getBuildList()
				soldierRushCtrl:getBuildList().bid = k
				soldierRushCtrl:getBuildList().num = v.armyNum
				table.insert(bList, soldierRushCtrl:getBuildList())
			end
		end
		if 1 < #bList then
			table.sort(bList, function(a, b)
				return a.num < b.num
			end)
			local disPro = aiCfg.ActionPara / 1000
			local toBid = bList[1].bid
			local maBid = bList[#bList].bid
			local curLunchArmyNum = soldierRushCtrl:getEnemyQueueNum(self.force)
			if maBid == self.bid and curLunchArmyNum < aiCfg.ActionLimit then
				self:disPatchArmy(self.bid, self.force, toBid, disPro)
			end
		end
	end
end
return Com_build
