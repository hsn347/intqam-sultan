local baseComponent = require("fgui.base.baseComponent")
local Com_moveBuild = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ManorCity/Com_moveBuild", Com_moveBuild)
function Com_moveBuild:onInit()
	_ENV = nil
	;(nil)[self.fields.arrow_rb] = cc.p(1, 1)
	;(nil)[self.fields.arrow_rt] = cc.p(1, -1)
	;(nil)[self.fields.arrow_lb] = cc.p(-1, 1)
	self.dirConfig, (nil)[self.fields.arrow_lt] = nil, cc.p(-1, -1)
end
function Com_moveBuild:onShow()
end
function Com_moveBuild:initSelectedData(instance, pos, canMove)
	self.instance = instance
	if canMove == false then
		for arrow, _ in pairs(self.dirConfig) do
			arrow:stopAllActions()
			arrow:setVisible(false)
			arrow:setOpacity(0)
		end
		self.instance:playAppearEffect()
		return
	end
	local size = instance:getHoldSize()
	local _ENV, _ENV, arrowScale = nil, pairs(self.dirConfig)
	;(nil)[self.fields.arrow_lt] = cc.p(-60, -30)
	_ENV, pairs(self.dirConfig)[3101], (nil)[self.fields.arrow_rt] = nil, nil, cc.p(60, -30)
	;(nil)[self.fields.arrow_lt] = cc.p(0, -60)
	_ENV, pairs(self.dirConfig)[3102], (nil)[self.fields.arrow_rt] = nil, nil, cc.p(40, -20)
	;(nil)[self.fields.arrow_lt] = cc.p(-60, -30)
	pairs(self.dirConfig)[3103], (nil)[self.fields.arrow_rt] = nil, cc.p(40, -20)
	local config = pairs(self.dirConfig)
	local buildID = instance:getBuildID()
	for arrow, dir in pairs(self.dirConfig) do
		local offset = config[buildID] and config[buildID][arrow] or cc.p(0, 0)
		arrow:setVisible(true)
		arrow:setPosition(pos.x * dir.x + offset.x, pos.y * dir.y + offset.y)
		arrow:setScale(arrowScale)
	end
	self:playAppearEffect()
end
function Com_moveBuild:playAppearEffect()
	local offset = cc.p(4, 4)
	local playOnce = false
	for arrow, dir in pairs(self.dirConfig) do
		arrow:stopAllActions()
		arrow:setOpacity(0)
		_UPVALUE1_ = nil
		_UPVALUE2_ = nil
		;(nil)[1] = ffa.moveBy(0.13333333333333333, offset.x * dir.x, offset.y * dir.y)
		;(nil)[2] = ffa.moveBy(0.26666666666666666, offset.x * -dir.x, offset.y * -dir.y)
		;(nil)[3] = ffa.callFunc(function()
			if not playOnce then
				self:playRepeatEffect()
			end
		end)
		;(nil)[4] = ffa.callFunc(function()
			if not playOnce then
				self:playRepeatEffect()
			end
		end)
		;(nil)[5] = ffa.callFunc(function()
			if not playOnce then
				self:playRepeatEffect()
			end
		end)
		;(nil)[6] = ffa.callFunc(function()
			if not playOnce then
				self:playRepeatEffect()
			end
		end)
		;(nil)[1] = ffa.fadeIn(0.1)
		;(nil)[2] = ffa.seq(nil)
		;(nil)[3] = ffa.seq(nil)
		;(nil)[4] = ffa.seq(nil)
		;(nil)[5] = ffa.seq(nil)
		;(nil)[6] = ffa.seq(nil)
		;(nil)[7] = ffa.seq(nil)
		;(nil)[8] = ffa.seq(nil)
		;(nil)[9] = ffa.seq(nil)
		arrow:runAction(ffa.spawn(nil))
	end
	self.instance:playAppearEffect()
end
function Com_moveBuild:playRepeatEffect()
	local offset = cc.p(4, 4)
	for arrow, dir in pairs(self.dirConfig) do
		arrow:stopAllActions()
		_UPVALUE1_ = nil
		;(nil)[1] = ffa.moveBy(0.3333333333333333, offset.x * dir.x, offset.y * dir.y)
		;(nil)[2] = ffa.moveBy(0.26666666666666666, offset.x * -dir.x, offset.y * -dir.y)
		;(nil)[3] = ffa.moveBy(0.26666666666666666, offset.x * -dir.x, offset.y * -dir.y)
		;(nil)[4] = ffa.moveBy(0.26666666666666666, offset.x * -dir.x, offset.y * -dir.y)
		;(nil)[5] = ffa.moveBy(0.26666666666666666, offset.x * -dir.x, offset.y * -dir.y)
		;(nil)[6] = ffa.moveBy(0.26666666666666666, offset.x * -dir.x, offset.y * -dir.y)
		arrow:runAction(ffa.repeatForever(ffa.seq(nil)))
	end
end
return Com_moveBuild
