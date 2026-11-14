local specializationRead = include("specializationRead")
local masteryStarSingle = class("masteryStarSingle", function(target)
	if target == nil then
		return SoraDCreatAnimation("xxlevel")
	end
	return target
end)
function masteryStarSingle:ctor()
	self.lev = 0
	self:initWidget()
end
function masteryStarSingle:initWidget(...)
	self.spriteStar = SoraDGetChildByName(self, "Sprite_18")
	self.Sprite_1 = SoraDGetChildByName(self, "Sprite_1")
	self.Sprite_2 = SoraDGetChildByName(self, "dh_zhuanjingxxx_01_19")
	self.Sprite_3 = SoraDGetChildByName(self, "Glow_090_csd_1")
	self.Sprite_4 = SoraDGetChildByName(self, "Particle_4")
	_ENV = self
	self.text = "15"
	self.color = display.COLOR_BLACK
	self.size = 18
	local labelShadow = display.newTTFLabel(self)
	labelShadow:addTo(self)
	labelShadow:setPosition(cc.p(1, -2))
	labelShadow:setOpacity(178.5)
	self.labelShadow = labelShadow
	_ENV = labelShadow
	labelShadow.text = "15"
	labelShadow.color = display.COLOR_WHITE
	labelShadow.size = 18
	local labelStar = display.newTTFLabel(labelShadow)
	labelStar:addTo(self)
	labelStar:setPosition(cc.p(0, 0))
	self.labelStar = labelStar
	SoraDMixtureGLONE(self.Sprite_2)
	SoraDMixtureGLONE(self.Sprite_3)
end
function masteryStarSingle:initData(data)
	if data.lev then
		self.labelShadow:setString(data.lev)
		self.labelStar:setString(data.lev)
		local iconName = specializationRead.getStartIcon(data.lev)
		self.spriteStar:setSpriteFrame(iconName)
		self.lev = data.lev
		self:showEffect()
	end
	if data.scale then
		self.spriteStar:setScale(data.scale)
		self.Sprite_1:setScale(data.scale)
		self.Sprite_2:setScale(data.scale)
	end
end
function masteryStarSingle:hideEffect(...)
	_UPVALUE4_ = nil
	;(nil)[1] = self.Sprite_1
	;(nil)[2] = self.Sprite_2
	;(nil)[3] = self.Sprite_3
	;(nil)[4] = self.Sprite_4
	for i, v in ipairs(nil) do
		v:setVisible(false)
	end
end
function masteryStarSingle:showEffect(...)
	if self.lev == 20 then
		_UPVALUE4_ = nil
		;(nil)[1] = self.Sprite_1
		;(nil)[2] = self.Sprite_2
		;(nil)[3] = self.Sprite_3
		;(nil)[4] = self.Sprite_4
		for i, v in ipairs(nil) do
			v:setVisible(true)
		end
	else
		self:hideEffect()
	end
end
return masteryStarSingle
