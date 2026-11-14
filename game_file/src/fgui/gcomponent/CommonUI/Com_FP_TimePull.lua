local baseComponent = require("fgui.base.baseComponent")
local Com_FP_TimePull = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonUI/Com_FP_TimePull", Com_FP_TimePull)
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
	self.fields.text_time:setURL(string.format("frame_ytlds_dja_%.2d.png", self.timeCount))
	self:onTimeSec()
end
function Com_FP_TimePull:updateStartTime()
	self.fields.text_time:setAlpha(1)
	self.fields.text_time:setURL(string.format("frame_ytlds_dja_%.2d.png", self.timeCount))
	self.fields.text_time:setScale(self.initScale)
	_ENV = string.format("frame_ytlds_dja_%.2d.png", self.timeCount)
	string.format("frame_ytlds_dja_%.2d.png", self.timeCount)[1] = ffa.scaleTo(0.3, self.toScale)
	string.format("frame_ytlds_dja_%.2d.png", self.timeCount)[2] = ffa.scaleTo(0.3, self.toScale)
	string.format("frame_ytlds_dja_%.2d.png", self.timeCount)[3] = ffa.scaleTo(0.3, self.toScale)
	self.fields.text_time:runAction(ffa.seq(string.format("frame_ytlds_dja_%.2d.png", self.timeCount)))
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
