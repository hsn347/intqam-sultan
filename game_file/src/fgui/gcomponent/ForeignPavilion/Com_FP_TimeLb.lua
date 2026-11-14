local baseComponent = require("fgui.base.baseComponent")
local Com_FP_TimeLb = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ForeignPavilion/Com_FP_TimeLb", Com_FP_TimeLb)
function Com_FP_TimeLb:onInit()
end
function Com_FP_TimeLb:onShow()
end
function Com_FP_TimeLb:setString(time)
	self.fields.text_time:setString(countTime)
end
function Com_FP_TimeLb:startGame(countTime, callback)
	self.timeEndCallback = callback
	self.timeCount = countTime
	self:setVisible(true)
	function self.timeCallback()
		self.fields.text_time:setString(self.timeCount)
	end
	self.fields.text_time:setString(self.timeCount)
	self:onTimeSec()
end
function Com_FP_TimeLb:onTimeSec()
	self:stopActionByTag(99)
	_UPVALUE1_ = self
	self[1] = ffa.delay(1)
	self[2] = ffa.callFunc(function()
		self.timeCount = self.timeCount - 1
		if self.timeCallback then
			self.timeCallback()
		end
		if self.timeCount <= 0 then
			if self.timeEndCallback then
				self.timeEndCallback()
				self.timeEndCallback = nil
			end
			return
		end
		self:onTimeSec()
	end)
	self[3] = ffa.callFunc(function()
		self.timeCount = self.timeCount - 1
		if self.timeCallback then
			self.timeCallback()
		end
		if self.timeCount <= 0 then
			if self.timeEndCallback then
				self.timeEndCallback()
				self.timeEndCallback = nil
			end
			return
		end
		self:onTimeSec()
	end)
	local action = ffa.seq(self)
	action:setTag(99)
	self:runAction(action)
end
function Com_FP_TimeLb:removeTime()
	self:stopActionByTag(99)
end
return Com_FP_TimeLb
