local activityCommonBubbleRead = include("activityCommonBubbleRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_bubble = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001638/Com_bubble", Com_bubble)
fgui.register_extension("ui://Activity_9001638/Com_bubble2", Com_bubble)
fgui.register_extension("ui://Activity_9001638/Com_bubble_9001693", Com_bubble)
function Com_bubble:onInit()
	self.colorType = 1
	self.dir = cc.p(0, 0)
	self.speed = 1100
	self.isSelect = false
	self.isConnect = false
	self.tilePos = cc.p(0, 0)
	if self.fields.mv_boom01 then
		self.fields.mv_boom01:setPlaySettings(0, -1, 1, -1, function()
			self.fields.mv_boom01:setVisible(false)
		end)
	end
	if self.fields.mv_boom02 then
		self.fields.mv_boom02:setPlaySettings(0, -1, 1, -1, function()
			self.fields.mv_boom02:setVisible(false)
		end)
	end
end
function Com_bubble:onShow()
end
function Com_bubble:setAllFrameName(...)
	if self.fields.mv_boom01 then
		self.fields.mv_boom01:setAllFrameName("G_9001638_boom01_%02d.png", 1)
	end
	if self.fields.mv_boom02 then
		self.fields.mv_boom02:setAllFrameName("G_9001638_boom02_%02d.png", 1)
	end
end
function Com_bubble:initActivityID(activityID)
	self.activityID = activityID
end
function Com_bubble:setDir(dir)
	self.dir = dir
end
function Com_bubble:getDir(...)
	return self.dir
end
function Com_bubble:getSpeed(...)
	return self.speed
end
function Com_bubble:reset(...)
	self:setIsSelect(false)
	self:setIsConnect(false)
end
function Com_bubble:initData(data)
	self:setColorType(data.colorType)
	self.tilePos = cc.p(data.x, data.y)
end
function Com_bubble:setColorType(colorType)
	self.colorType = colorType
	local imageName = activityCommonBubbleRead.getBallImageName(colorType, self.activityID)
	self.fields.icon:setURL(imageName)
end
function Com_bubble:getColorType(...)
	return self.colorType
end
function Com_bubble:checkSameColor(colorType)
	return self.colorType == colorType
end
function Com_bubble:getTilePos(...)
	return self.tilePos
end
function Com_bubble:setIsSelect(isSelect)
	self.isSelect = isSelect
end
function Com_bubble:getIsSelect(...)
	return self.isSelect
end
function Com_bubble:setIsConnect(isConnect)
	self.isConnect = isConnect
end
function Com_bubble:getIsConnect(...)
	return self.isConnect
end
function Com_bubble:doDieingAnimation(...)
	local time = 0.75
	if self:getIsSelect() then
		self.controllers.c_effect:setSelectedIndex(1)
		_UPVALUE3_ = self.controllers.c_effect.setSelectedIndex
		self.controllers.c_effect.setSelectedIndex[1] = cc.c3b(255, 157, 42)
		self.controllers.c_effect.setSelectedIndex[2] = cc.c3b(255, 0, 0)
		self.controllers.c_effect.setSelectedIndex[3] = cc.c3b(124, 19, 254)
		self.controllers.c_effect.setSelectedIndex[4] = cc.c3b(0, 108, 230)
		self.controllers.c_effect.setSelectedIndex[5] = cc.c3b(0, 108, 230)
		self.controllers.c_effect.setSelectedIndex[6] = cc.c3b(0, 108, 230)
		self.controllers.c_effect.setSelectedIndex[7] = cc.c3b(0, 108, 230)
		self.controllers.c_effect.setSelectedIndex[8] = cc.c3b(0, 108, 230)
		local self.controllers.c_effect.setSelectedIndex[9], config = cc.c3b(0, 108, 230)
		local color = config[self.colorType]
		self.fields.mv_boom01:setColor(color)
		_UPVALUE1_ = cc.c3b(0, 108, 230)
		cc.c3b(0, 108, 230)[1] = ffa.delay(time)
		cc.c3b(0, 108, 230)[2] = ffa.callFunc(function()
			self:finishedAfterDead()
		end)
		cc.c3b(0, 108, 230)[3] = ffa.callFunc(function()
			self:finishedAfterDead()
		end)
		cc.c3b(0, 108, 230)[4] = ffa.callFunc(function()
			self:finishedAfterDead()
		end)
		self:runAction(ffa.seq(cc.c3b(0, 108, 230)))
	elseif not self:getIsConnect() then
		_UPVALUE1_ = self
		_UPVALUE1_ = ffa.seq(cc.c3b(0, 108, 230))
		ffa.seq(cc.c3b(0, 108, 230))[1] = ffa.moveBy(time, 0, 500)
		ffa.seq(cc.c3b(0, 108, 230))[2] = ffa.fadeOut(time)
		ffa.seq(cc.c3b(0, 108, 230))[3] = ffa.fadeOut(time)
		ffa.seq(cc.c3b(0, 108, 230))[4] = ffa.fadeOut(time)
		self[1] = ffa.spawn(ffa.seq(cc.c3b(0, 108, 230)))
		self[2] = ffa.callFunc(function()
			self:finishedAfterDead()
		end)
		self[3] = ffa.callFunc(function()
			self:finishedAfterDead()
		end)
		self[4] = ffa.callFunc(function()
			self:finishedAfterDead()
		end)
		self[5] = ffa.callFunc(function()
			self:finishedAfterDead()
		end)
		self[6] = ffa.callFunc(function()
			self:finishedAfterDead()
		end)
		self:runAction(ffa.seq(self))
	end
end
function Com_bubble:finishedAfterDead()
	self:removeFromParent()
end
function Com_bubble:getColor(...)
	return self:getColorType()
end
function Com_bubble:isDie(...)
	return false
end
return Com_bubble
