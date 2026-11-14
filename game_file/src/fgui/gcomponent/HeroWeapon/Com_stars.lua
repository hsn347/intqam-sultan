local baseComponent = require("fgui.base.baseComponent")
local Com_stars = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://HeroWeapon/Com_stars", Com_stars)
fgui.register_extension("ui://HeroWeapon/Com_starsx", Com_stars)
function Com_stars:onInit()
	if self.fields.mv_lg then
		self.fields.mv_lg:setAllFrameName("G_heroweapon_jj_02_%.2d.png", 1)
		self.fields.mv_lg:setVisible(false)
		self.fields.mv_lg:setScaleX(SoraDFIsRA() and 1 or -1)
	end
	if self.fields.mv_bz then
		self.fields.mv_bz:setAllFrameName("G_heroweapon_jj_03_%.2d.png", 1)
		self.fields.mv_bz:setVisible(false)
	end
	self:fixChildrenPos()
end
function Com_stars:onShow()
end
function Com_stars:setStage(stage)
	self.stage = stage and math.min(stage, 5) or 5
	self.controllers.c1:setSelectedIndex(self.stage)
end
function Com_stars:playUpStageAni(stage)
	if 0 < stage then
		if self.fields.mv_lg then
			self.fields.mv_lg:setVisible(true)
			self.fields.mv_lg:setPlaySettings(0, -1, 1, -1, function()
				self.fields.mv_lg:setVisible(false)
			end)
		end
		if self.fields.mv_bz then
			local star = self.fields["n" .. stage - 1]
			_UPVALUE1_ = 1
			;(1)[1] = ffa.scaleTo(0.15, 1.3, 1.3)
			;(1)[2] = ffa.scaleTo(0.1, 1, 1)
			;(1)[3] = ffa.scaleTo(0.1, 1, 1)
			;(1)[4] = ffa.scaleTo(0.1, 1, 1)
			;(1)[5] = ffa.scaleTo(0.1, 1, 1)
			star:runAction(ffa.seq(1))
			self.fields.mv_bz:setPositionX(star:getPositionX())
			self.fields.mv_bz:setVisible(true)
			self.fields.mv_bz:setPlaySettings(0, -1, 1, -1, function()
				self.fields.mv_bz:setVisible(false)
			end)
		end
	end
end
return Com_stars
