local foreignPavilionRead = include("foreignPavilionRead")
local baseComponent = require("fgui.base.baseComponent")
local RoadRoughSpace = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://RoadRoughGame/RoadRoughSpace", RoadRoughSpace)
function RoadRoughSpace:onInit()
	self:addClickListener(handler(self, self.onClick))
end
function RoadRoughSpace:onShow()
	_UPVALUE4_ = nil
	self.arrows, (nil)[1] = nil, self.fields.lb
	self.arrows, (nil)[2] = nil, self.fields.rb
	self.arrows, (nil)[3] = nil, self.fields.rt
	self.arrows, (nil)[4] = nil, self.fields.lt
end
function RoadRoughSpace:setIndex(x, y)
	self.x = x
	self.y = y
end
function RoadRoughSpace:hideMove()
	self.fields.color:stopAllActions()
	self.fields.color:setAlpha(0)
	self:setTouchEnabled(false)
	self.fields.lt:setVisible(false)
	self.fields.rb:setVisible(false)
	self.fields.lb:setVisible(false)
	self.fields.rt:setVisible(false)
end
function RoadRoughSpace:showMove(x, y)
	self:setTouchEnabled(true)
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.fadeTo(0.75, 0.5)
	;(nil)[2] = ffa.fadeTo(0.75, 1)
	;(nil)[3] = ffa.fadeTo(0.75, 1)
	;(nil)[4] = ffa.fadeTo(0.75, 1)
	self.fields.color:runAction(ffa.repeatForever(ffa.seq(nil)))
	local curArrow
	_UPVALUE4_ = ffa.repeatForever(ffa.seq(nil))
	ffa.repeatForever(ffa.seq(nil))[1] = x
	ffa.repeatForever(ffa.seq(nil))[2] = y
	ffa.repeatForever(ffa.seq(nil))[3] = self.x
	ffa.repeatForever(ffa.seq(nil))[4] = self.y
	dump(ffa.repeatForever(ffa.seq(nil)))
	if x == self.x and y == self.y - 1 then
		curArrow = self.fields.lt
	end
	if x == self.x and y == self.y + 1 then
		curArrow = self.fields.rb
	end
	if x == self.x - 1 and y == self.y then
		curArrow = self.fields.rt
	end
	if x == self.x + 1 and y == self.y then
		curArrow = self.fields.lb
	end
	curArrow:setVisible(true)
	curArrow:setAllFrameName("dh_ljbp_jt_%02d.png", 1)
	curArrow:setPlaySettings(0, -1, -1)
end
function RoadRoughSpace:onClick()
	SoraDPlaySound()
	print("Btn_space:onClick=====")
	_ENV = "Btn_space:onClick====="
	;("Btn_space:onClick=====").msg = "MESSAGE_ROADROUGH_MOVE_ACT"
	;("Btn_space:onClick=====").x = self.x
	;("Btn_space:onClick=====").y = self.y
	SoraDSendMessage("Btn_space:onClick=====")
end
return RoadRoughSpace
