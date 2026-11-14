local baseComponent = require("fgui.base.baseComponent")
local Com_HPUp = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/Com_HPUp", Com_HPUp)
function Com_HPUp:onInit()
	self.isPlaying = false
	self.isAniSet = false
end
function Com_HPUp:onShow()
end
function Com_HPUp:playAct(style, hp)
	local style = style or 1
	local hp = hp or 5
	print("style,hp===========", style, hp)
	if self.isPlaying then
		return
	end
	if not self.isAniSet then
		self.isAniSet = true
		self.fields.fly:setAllFrameName("dh_Tex_XL_zlts02_%.3d.png", 1)
	end
	self.isPlaying = true
	if style == 1 then
		self.fields.n1:setAlpha(0)
		self.fields.title:setAlpha(0)
		self.controllers.c1:setSelectedIndex(0)
		self.fields.title:setString("-" .. hp)
		self.fields.n1:fixPos()
		self.fields.title:fixPos()
		self.fields.n5:setPositionY(28)
		self.fields.fly:setRotation(145)
		self.fields.fly:setPosition(-display.rwidth / 2 + 45, -display.rheight / 2 + 180)
		self.fields.fly:setPlaySettings(0, -1, 1)
		_UPVALUE3_ = -1
		;(-1)[1] = ffa.moveTo(0.3, 77, 53)
		;(-1)[2] = ffa.callFunc(function()
			self.fields.n1:runAction(ffa.fadeIn(0.3))
			self.fields.title:runAction(ffa.fadeIn(0.3))
			self.fields.n5:runAction(ffa.moveBy(0.3, 0, -90))
		end)
		;(-1)[3] = ffa.delay(0.5)
		;(-1)[4] = ffa.callFunc(function()
			self:setVisible(false)
			self.isPlaying = false
		end)
		;(-1)[5] = ffa.callFunc(function()
			self:setVisible(false)
			self.isPlaying = false
		end)
		self.fields.fly:runAction(ffa.seq(-1))
	elseif style == 2 then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.fly:setRotation(-45)
		self.fields.fly:setPosition(-137, -218)
		self.fields.fly:setPlaySettings(0, -1, 1)
		_UPVALUE2_ = -1
		;(-1)[1] = ffa.moveTo(0.3, -display.rwidth / 2 + 45, -display.rheight / 2 + 180)
		;(-1)[2] = ffa.delay(0.7)
		;(-1)[3] = ffa.callFunc(function()
			self:setVisible(false)
			self.isPlaying = false
		end)
		;(-1)[4] = ffa.callFunc(function()
			self:setVisible(false)
			self.isPlaying = false
		end)
		;(-1)[5] = ffa.callFunc(function()
			self:setVisible(false)
			self.isPlaying = false
		end)
		self.fields.fly:runAction(ffa.seq(-1))
	end
end
return Com_HPUp
