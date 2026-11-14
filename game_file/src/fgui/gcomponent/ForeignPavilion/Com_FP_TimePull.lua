local baseComponent = require("fgui.base.baseComponent")
local Com_FP_TimePull = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ForeignPavilion/Com_FP_TimePull", Com_FP_TimePull)
fgui.register_extension("ui://SoldierRush/Com_FP_TimePull", Com_FP_TimePull)
fgui.register_extension("ui://Activity_9001703/Com_FP_TimePull", Com_FP_TimePull)
function Com_FP_TimePull:onInit()
end
function Com_FP_TimePull:onShow()
end
function Com_FP_TimePull:startGame(param)
	self.timeEndCallback = param.callback
	self.timeCount = param.countTime or 3
	self.initScale = param.initScale or 2
	self.toScale = param.toScale or 1
	self:setVisible(true)
	self:updateStartTime()
	function self.timeCallback()
		self:updateStartTime()
	end
	self:onGameStart()
end
function Com_FP_TimePull:onGameStart()
	self.controllers.c1:setSelectedIndex(1)
	self.fields.text_time:setURL("frame_ytlds_dja_0" .. self.timeCount .. ".png")
	self:onTimeSec()
end
function Com_FP_TimePull:updateStartTime()
	self.fields.text_time:setAlpha(1)
	self.fields.text_time:setURL("frame_ytlds_dja_0" .. self.timeCount .. ".png")
	self.fields.text_time:setScale(self.initScale)
	_ENV = self.timeCount
	self.timeCount[1] = ffa.scaleTo(0.3, self.toScale)
	self.timeCount[2] = ffa.scaleTo(0.3, self.toScale)
	self.timeCount[3] = ffa.scaleTo(0.3, self.toScale)
	self.fields.text_time:runAction(ffa.seq(self.timeCount))
end
function Com_FP_TimePull:onTimeSec()
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
				self:setVisible(false)
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
				self:setVisible(false)
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
return Com_FP_TimePull
