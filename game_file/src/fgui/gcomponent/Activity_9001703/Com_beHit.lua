local activity_9001703_Ctrl = SoraDGetCtrl("activity_9001703_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_beHit = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001703/Com_beHit", Com_beHit)
function Com_beHit:onInit()
end
function Com_beHit:onShow()
	self.fields.Prefab:setVisible(false)
	self.fields.PrefabEXP:setVisible(false)
end
function Com_beHit:showHit(isRemove, handler)
	self.fields.Prefab:setVisible(true)
	if isRemove then
		_UPVALUE1_ = nil
		;(nil)[1] = ffa.fadeIn(0.5)
		;(nil)[2] = ffa.callFunc(function()
			if handler then
				handler(self)
			end
		end)
		;(nil)[3] = ffa.callFunc(function()
			if handler then
				handler(self)
			end
		end)
		self:runAction(ffa.seq(nil))
	end
end
function Com_beHit:beHit(isCrit, realVal, isKill, expPos, handler)
	if isKill then
		self:showHit()
		self.fields.PrefabEXP:setVisible(true)
		self.fields.PrefabEXP:setPosition(cc.p(50, 50))
		self.fields.PrefabEXP:stopAllActions()
		local toPos = self:globalToLocal(cc.p(expPos.x + 50, expPos.y + 50))
		_UPVALUE1_ = cc.p(expPos.x + 50, expPos.y + 50)
		cc.p(expPos.x + 50, expPos.y + 50)[1] = ffa.moveTo(1.0, toPos.x, toPos.y)
		cc.p(expPos.x + 50, expPos.y + 50)[2] = ffa.callFunc(function()
			self.fields.PrefabEXP:setVisible(false)
			self.fields.PrefabEXP:setPosition(cc.p(50, 50))
		end)
		cc.p(expPos.x + 50, expPos.y + 50)[3] = ffa.callFunc(function()
			self.fields.PrefabEXP:setVisible(false)
			self.fields.PrefabEXP:setPosition(cc.p(50, 50))
		end)
		cc.p(expPos.x + 50, expPos.y + 50)[4] = ffa.callFunc(function()
			self.fields.PrefabEXP:setVisible(false)
			self.fields.PrefabEXP:setPosition(cc.p(50, 50))
		end)
		cc.p(expPos.x + 50, expPos.y + 50)[5] = ffa.callFunc(function()
			self.fields.PrefabEXP:setVisible(false)
			self.fields.PrefabEXP:setPosition(cc.p(50, 50))
		end)
		cc.p(expPos.x + 50, expPos.y + 50)[6] = ffa.callFunc(function()
			self.fields.PrefabEXP:setVisible(false)
			self.fields.PrefabEXP:setPosition(cc.p(50, 50))
		end)
		cc.p(expPos.x + 50, expPos.y + 50)[7] = ffa.callFunc(function()
			self.fields.PrefabEXP:setVisible(false)
			self.fields.PrefabEXP:setPosition(cc.p(50, 50))
		end)
		cc.p(expPos.x + 50, expPos.y + 50)[8] = ffa.callFunc(function()
			self.fields.PrefabEXP:setVisible(false)
			self.fields.PrefabEXP:setPosition(cc.p(50, 50))
		end)
		cc.p(expPos.x + 50, expPos.y + 50)[9] = ffa.callFunc(function()
			self.fields.PrefabEXP:setVisible(false)
			self.fields.PrefabEXP:setPosition(cc.p(50, 50))
		end)
		cc.p(expPos.x + 50, expPos.y + 50)[10] = ffa.callFunc(function()
			self.fields.PrefabEXP:setVisible(false)
			self.fields.PrefabEXP:setPosition(cc.p(50, 50))
		end)
		self.fields.PrefabEXP:runAction(ffa.seq(cc.p(expPos.x + 50, expPos.y + 50)))
	end
	local target = isCrit and self.fields.Text_bj or self.fields.Text_sj
	target:setString(-realVal)
	local randomX = math.random(0, 100)
	local randomY = math.random(0, 50)
	target:stopAllActions()
	target:setPosition(cc.p(50, 50))
	target:setAlpha(0)
	target:setScale(0.8)
	target:setVisible(true)
	_UPVALUE2_ = cc.p(50, 50)
	_UPVALUE2_ = cc.p(50, 50)
	cc.p(50, 50)[1] = ffa.fadeIn(0.5)
	cc.p(50, 50)[2] = ffa.moveTo(0.5, randomX, randomY)
	cc.p(50, 50)[3] = ffa.scaleTo(0.5, 1, 1)
	cc.p(50, 50)[4] = ffa.scaleTo(0.5, 1, 1)
	cc.p(50, 50)[5] = ffa.scaleTo(0.5, 1, 1)
	cc.p(50, 50)[6] = ffa.scaleTo(0.5, 1, 1)
	cc.p(50, 50)[1] = ffa.spawn(cc.p(50, 50))
	cc.p(50, 50)[2] = ffa.delay(0.5)
	cc.p(50, 50)[3] = ffa.callFunc(function()
		target:setVisible(false)
		target:setPosition(cc.p(50, 50))
		if handler then
			handler(self)
		end
	end)
	cc.p(50, 50)[4] = ffa.callFunc(function()
		target:setVisible(false)
		target:setPosition(cc.p(50, 50))
		if handler then
			handler(self)
		end
	end)
	cc.p(50, 50)[5] = ffa.callFunc(function()
		target:setVisible(false)
		target:setPosition(cc.p(50, 50))
		if handler then
			handler(self)
		end
	end)
	cc.p(50, 50)[6] = ffa.callFunc(function()
		target:setVisible(false)
		target:setPosition(cc.p(50, 50))
		if handler then
			handler(self)
		end
	end)
	cc.p(50, 50)[7] = ffa.callFunc(function()
		target:setVisible(false)
		target:setPosition(cc.p(50, 50))
		if handler then
			handler(self)
		end
	end)
	cc.p(50, 50)[8] = ffa.callFunc(function()
		target:setVisible(false)
		target:setPosition(cc.p(50, 50))
		if handler then
			handler(self)
		end
	end)
	target:runAction(ffa.seq(cc.p(50, 50)))
end
return Com_beHit
