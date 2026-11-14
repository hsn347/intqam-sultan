local commonEllipseBar = class("commonEllipseBar", function(target)
	if "userdata" == type(target) then
		return target
	else
		return SoraDCreateBasePanel("commonEllipseBar")
	end
end)
function commonEllipseBar:ctor()
	self.radius = 280
	self.dir = 1
	self.frame_base = SoraDGetChildByName(self, "frame_base")
	self.Node_bar = SoraDGetChildByName(self, "Node_bar")
	self.radius = self.frame_base:getContentSize().width
	self.nodeClip = SoraDGetChildByName(self, "Node_clipping")
	print("skfwjkehekfjwe", self.nodeClip)
	_ENV = "skfwjkehekfjwe"
	;("skfwjkehekfjwe").radius = self.radius
	local shapNode = display.newDrawSolidFan("skfwjkehekfjwe")
	self.cliperNode = cc.ClippingNode:create()
	self.cliperNode:setStencil(shapNode)
	self.cliperNode:setInverted(false)
	self.cliperNode:addTo(self.nodeClip)
	self.Node_effect = SoraDGetChildByName(self, "Node_effect")
	self.Node_effect:setLocalZOrder(1)
	self.Node_light = SoraDGetChildByName(self, "Node_light")
	SoraDMixtureGLONE(SoraDGetChildByName(self.Node_light, "dh_xueyuanyjf_light"))
	self:setFrameBar()
	self:set3DRotation()
	self:setDir(SoraDFIsRA() and 0 or 1)
end
function commonEllipseBar:setNodeEffectVisible(ret)
	self.Node_effect:setVisible(ret)
end
function commonEllipseBar:setFrameBarBase(base)
	local base = base or "frame_xy_jd_02.png"
	self.frame_base:setSpriteFrame(base)
end
function commonEllipseBar:setFrameBar(bar)
	local bar = bar or "frame_xy_jd_01.png"
	if not self.frame_bar then
		self.frame_bar = display.newSprite("#" .. bar)
		self.frame_bar:setPosition(0, 0)
		self.frame_bar:addTo(self.cliperNode, 0)
	else
		self.frame_bar:setSpriteFrame(bar)
	end
end
function commonEllipseBar:setFrameAnimation(frame, format, bIndex, eIndex)
	local frame = frame or "dh_xueyuanyjf1_00.png"
	local format = format or "dh_xueyuanyjf1_%.2d.png"
	local bIndex = bIndex or 0
	local eIndex = eIndex or 14
	local frames = display.newFrames(format, bIndex, eIndex)
	local animation = display.newAnimation(frames, 1.2 / #frames)
	self.animation_barL = display.newSprite("#" .. frame)
	self.animation_barL:setScale(2.0)
	self.animation_barL:setAnchorPoint(cc.p(1, 0))
	self.animation_barL:setPosition(0, -280)
	SoraDMixtureGLONE(self.animation_barL)
	self.animation_barL:playAnimationForever(animation)
	self.animation_barL:addTo(self.cliperNode, 1)
	self.animation_barR = display.newSprite("#" .. frame)
	self.animation_barR:setScale(2.0)
	self.animation_barR:setFlippedX(true)
	self.animation_barR:setAnchorPoint(cc.p(0, 0))
	self.animation_barR:setPosition(0, -280)
	SoraDMixtureGLONE(self.animation_barR)
	self.animation_barR:playAnimationForever(animation)
	self.animation_barR:addTo(self.cliperNode, 1)
end
function commonEllipseBar:setPercent(percent)
	local percent = math.min(math.max(percent, 0), 100)
	_ENV = math.max(percent, 0)
	math.max(percent, 0).radius = self.radius
	math.max(percent, 0).from = math.rad(90)
	math.max(percent, 0).angle = math.rad(percent * 3.6)
	math.max(percent, 0).segments = math.max(32, math.floor(1800 * percent / 100))
	local math.max(percent, 0).color, params = cc.c4f(0, 1, 0, 1), math.max(percent, 0)
	local shapNode = display.newDrawSolidFan(params)
	self.cliperNode:setStencil(shapNode)
	self.Node_effect:setRotation(self.dir == 1 and 180 - 360 * percent / 100 or 360 * percent / 100 - 180)
	self.Node_light:setPositionY(-math.abs(percent - 50) + 50 - self.radius)
	local scale = math.max(0, -math.abs(percent - 50) + 40) / 50
	self.Node_light:setScaleX(self.dir == 1 and scale or -scale)
	self.Node_light:setScaleY(scale)
end
function commonEllipseBar:setRadius(radius)
	self.radius = radius
	self:setPercent(0)
end
function commonEllipseBar:setDir(dir)
	self.dir = dir
	self.frame_base:setScaleX(self.dir == 1 and 1 or -1)
	self.Node_bar:setScaleX(self.dir == 1 and 1 or -1)
end
function commonEllipseBar:set3DRotation(rotation)
	_UPVALUE0_ = nil
	;(nil).x = 73
	;(nil).y = 0
	local (nil).z, rotation = 0, rotation or nil
	self:setRotation3D(rotation)
end
return commonEllipseBar
