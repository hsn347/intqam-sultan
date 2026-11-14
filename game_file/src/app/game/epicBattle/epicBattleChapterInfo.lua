local gametop = gModuleMgr.getObject("gametop")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local epicBattleChapterInfo = class("epicBattleChapterInfo", function(target)
	if target == nil then
		return SoraDCreateBasePanel("epicBattleChapterInfo")
	end
	return target
end)
function epicBattleChapterInfo:ctor()
	self.data, _ENV = nil, nil
	self.Node_lock = SoraDGetChildByName(self, "Node_lock")
	self.Node_unlock = SoraDGetChildByName(self, "Node_unlock")
	self.lockName = SoraDGetChildByName(self.Node_lock, "Text_name")
	self.lockName_shadow = SoraDGetChildByName(self.Node_lock, "Text_name_shadow")
	self.unlockName = SoraDGetChildByName(self.Node_unlock, "Text_name")
	self.unlockName_shadow = SoraDGetChildByName(self.Node_unlock, "Text_name_shadow")
	self.dh_shangpinsg = SoraDGetChildByName(self.Node_unlock, "dh_shangpinsg")
	SoraDMixtureGLONE(self.dh_shangpinsg)
	self.dh_xuanzdt = SoraDGetChildByName(self.Node_unlock, "dh_xuanzdt")
	SoraDMixtureGLONE(self.dh_xuanzdt)
	self:setEffectVisible(false)
end
function epicBattleChapterInfo:setEffectVisible(ret)
	local Particle_1 = SoraDGetChildByName(self.Node_unlock, "Particle_1")
	self.dh_shangpinsg:setVisible(ret)
	self.dh_xuanzdt:setVisible(ret)
	Particle_1:setVisible(ret)
	if ret then
		self.dh_shangpinsg:stopAllActions()
		self.dh_shangpinsg:setPositionX(-75)
		self.dh_shangpinsg:setOpacity(0)
		_UPVALUE4_ = self.dh_shangpinsg
		_UPVALUE1_ = nil
		;(nil)[1] = cca.moveTo(0.21666666666666667, -20, 0)
		;(nil)[2] = cca.fadeTo(0.21666666666666667, 1)
		;(nil)[3] = cca.fadeTo(0.21666666666666667, 1)
		;(nil)[4] = cca.fadeTo(0.21666666666666667, 1)
		;(nil)[5] = cca.fadeTo(0.21666666666666667, 1)
		;(nil)[6] = cca.fadeTo(0.21666666666666667, 1)
		_UPVALUE1_ = 17
		;(17)[1] = cca.moveTo(0.21666666666666667, 75, 0)
		;(17)[2] = cca.fadeTo(0.21666666666666667, 0)
		;(17)[3] = cca.fadeTo(0.21666666666666667, 0)
		;(17)[4] = cca.fadeTo(0.21666666666666667, 0)
		self.dh_shangpinsg[1] = cca.callFunc(function()
			self.dh_shangpinsg:setPositionX(-75)
			self.dh_shangpinsg:setOpacity(0)
		end)
		self.dh_shangpinsg[2] = cca.spawn(nil)
		self.dh_shangpinsg[3] = cca.moveTo(0.15, 17, 0)
		self.dh_shangpinsg[4] = cca.spawn(17)
		self.dh_shangpinsg[5] = cca.delay(2)
		self.dh_shangpinsg[6] = cca.delay(2)
		self.dh_shangpinsg[7] = cca.delay(2)
		self.dh_shangpinsg[8] = cca.delay(2)
		self.dh_shangpinsg[9] = cca.delay(2)
		local seq = cca.seq(self.dh_shangpinsg)
		self.dh_shangpinsg:runAction(cc.RepeatForever:create(seq))
		self.dh_xuanzdt:stopAllActions()
		_ENV = cc.RepeatForever:create(seq)
		cc.RepeatForever:create(seq).fadeIn = 0.6
		cc.RepeatForever:create(seq).fadeOut = 0.6
		cc.RepeatForever:create(seq).delay = 0
		cc.RepeatForever:create(seq).beginOpacity = 1
		cc.RepeatForever:create(seq).endOpacity = 0.3
		SoraDFadeINOUT(self.dh_xuanzdt, cc.RepeatForever:create(seq))
		Particle_1:resetSystem()
	else
		self.dh_shangpinsg:stopAllActions()
		self.dh_xuanzdt:stopAllActions()
		Particle_1:stopSystem()
	end
end
function epicBattleChapterInfo:initData(data)
	self.data = data
	if self.data and next(self.data) then
		self.lockName:setString(self.data.Chaptername)
		self.lockName_shadow:setString(self.data.Chaptername)
		self.unlockName:setString(self.data.Chaptername)
		self.unlockName_shadow:setString(self.data.Chaptername)
		self.unlockName:enableShadow(cc.c3b(0, 0, 0), cc.size(3, -3), 20)
		self.Node_lock:setVisible(not self.data.isUnlock)
		self.Node_unlock:setVisible(self.data.isUnlock)
	end
end
return epicBattleChapterInfo
