_ENV = nil
_ENV = nil
;(nil).bg = cc.c3b(255, 255, 255)
;(nil)[gHeroQuality.WHITE], (nil).sp = nil, cc.c3b(255, 255, 255)
_ENV = nil
;(nil).bg = cc.c3b(59, 191, 59)
;(nil)[gHeroQuality.GREEN], (nil).sp = nil, cc.c3b(166, 255, 166)
_ENV = nil
;(nil).bg = cc.c3b(65, 161, 255)
;(nil)[gHeroQuality.BLUE], (nil).sp = nil, cc.c3b(149, 225, 255)
_ENV = nil
;(nil).bg = cc.c3b(115, 108, 255)
;(nil)[gHeroQuality.PURPLE], (nil).sp = nil, cc.c3b(197, 163, 255)
_ENV = nil
;(nil).bg = cc.c3b(220, 124, 75)
;(nil)[gHeroQuality.ORANGE], (nil).sp = nil, cc.c3b(255, 165, 0)
local gHeroColor
local heroEffectQuality = class("heroEffectQuality", function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroEffect_quality")
	end
	return target
end)
function heroEffectQuality:ctor()
	self.bg = SoraDGetChildByName(self, "dh_yingxiongpz_bg")
	self.sp = SoraDGetChildByName(self, "dh_yingxiongpz")
	SoraDMixtureGLONE(self.bg)
	self:loadAction()
end
function heroEffectQuality:loadAction()
	local ret = _G.SoraDIsFileExistByKey("heroQuality")
	if ret then
		_ENV, _UPVALUE1_ = nil, "heroQuality"
		;(nil).name = "Common/heroQuality"
		;(nil).key = "heroQuality"
		local ("heroQuality")[1], imgArray = nil, "heroQuality"
		self:loadImages(imgArray, function()
			print("加载资源完成===")
			SoraDCreatAnimation("heroEffect_quality", self)
		end)
	end
end
function heroEffectQuality:initData(quality)
	quality = gHeroQuality.WHITE
	self.bg:setColor(gHeroColor[quality].bg)
	self.sp:setColor(gHeroColor[quality].sp)
end
return heroEffectQuality
