local soldierRushRead = include("soldierRushRead")
local soldierRushCtrl = SoraDGetCtrl("soldierRushCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_armyGroup = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SoldierRush/Com_armyGroup", Com_armyGroup)
function Com_armyGroup:onInit()
	self.fields.mv_beAtk:setVisible(false)
	self.fields.mv_beAtk:setAllFrameName("dh_bcxt_shouji_%.2d.png", 1)
	self.posArray, _UPVALUE0_ = self.fields.mv_beAtk.setAllFrameName, self.fields.mv_beAtk.setAllFrameName
end
function Com_armyGroup:onShow()
end
function Com_armyGroup:setGroupCfg(index, dir, isFlipX, force, num)
	self.controllers.c1:setSelectedIndex(index)
	self.num = num
	local npcHead = soldierRushRead.getArmyModel(force, soldierRushCtrl:getCurBattleID())
	for i = 1, 8 do
		self.fields["n" .. i]:setScaleX(isFlipX and -0.55 or 0.55)
		local frames = display.newFrames(npcHead .. "_yd_" .. dir .. "_%.2d.png", 1, 8)
		self.fields["n" .. i]:setAnimation(display.newAnimation(frames, 1.0 / #frames))
		self.fields["n" .. i]:setVisible(i <= self.num)
		self.posArray[i] = self.fields["n" .. i]:getPosition()
	end
	self:outAct()
end
function Com_armyGroup:outAct()
	for i = 1, 8 do
		self.fields["n" .. i]:setPosition(50, 50)
		self.fields["n" .. i]:setAlpha(0)
		_UPVALUE1_ = 50
		;(50)[1] = ffa.fadeIn(0.5)
		;(50)[2] = ffa.moveTo(0.5, self.posArray[i].x, self.posArray[i].y)
		;(50)[3] = ffa.moveTo(0.5, self.posArray[i].x, self.posArray[i].y)
		;(50)[4] = ffa.moveTo(0.5, self.posArray[i].x, self.posArray[i].y)
		;(50)[5] = ffa.moveTo(0.5, self.posArray[i].x, self.posArray[i].y)
		self.fields["n" .. i]:runAction(ffa.spawn(50))
	end
end
function Com_armyGroup:inAct(time)
	for i = 1, 8 do
		_UPVALUE1_ = nil
		_UPVALUE1_ = nil
		;(nil)[1] = ffa.moveTo(0.5, 50, 50)
		;(nil)[2] = ffa.fadeOut(0.5)
		;(nil)[3] = ffa.fadeOut(0.5)
		;(nil)[4] = ffa.fadeOut(0.5)
		;(nil)[1] = ffa.delay(time - 0.5)
		;(nil)[2] = ffa.spawn(nil)
		;(nil)[3] = ffa.spawn(nil)
		;(nil)[4] = ffa.spawn(nil)
		;(nil)[5] = ffa.spawn(nil)
		;(nil)[6] = ffa.spawn(nil)
		;(nil)[7] = ffa.spawn(nil)
		self.fields["n" .. i]:runAction(ffa.seq(nil))
	end
end
function Com_armyGroup:setArmyNum(num, index)
	self.num = num
	self.fields["n" .. index]:setVisible(false)
end
function Com_armyGroup:getArmy(index)
	return self.fields["n" .. index]
end
function Com_armyGroup:showBeAtk(index)
	self.fields.mv_beAtk:setVisible(true)
	self.fields.mv_beAtk:setPosition(self.fields["n" .. index]:getPositionX(), self.fields["n" .. index]:getPositionY())
	self.fields.mv_beAtk:setPlaySettings(0, -1, 1, -1, function()
		self.fields.mv_beAtk:setVisible(false)
	end)
end
function Com_armyGroup:pause()
	for i = 1, 8 do
		self.fields["n" .. i]:setPlaying(false)
		self.fields["n" .. i]:getActionManager():pauseTarget(self.fields["n" .. i])
	end
	self.fields.mv_beAtk:setPlaying(false)
end
function Com_armyGroup:resume()
	for i = 1, 8 do
		self.fields["n" .. i]:setPlaying(true)
		self.fields["n" .. i]:getActionManager():resumeTarget(self.fields["n" .. i])
	end
	self.fields.mv_beAtk:setPlaying(true)
end
return Com_armyGroup
