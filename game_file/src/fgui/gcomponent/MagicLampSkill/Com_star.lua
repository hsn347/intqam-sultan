local baseComponent = require("fgui.base.baseComponent")
local Com_star = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MagicLampSkill/Com_stars1", Com_star)
fgui.register_extension("ui://MagicLampSkill/Com_stars2", Com_star)
fgui.register_extension("ui://MagicLampSkill/Com_stars3", Com_star)
function Com_star:onInit()
	self.fields.mv_xxjj:setVisible(false)
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function Com_star:onShow()
end
function Com_star:initData(num, max)
	self.num = num
	self.max = max or self.max
	self.controllers.c_max:setSelectedIndex(self.max - 1)
	for i = 1, self.max do
		self.fields["star_" .. i]:setStar(i <= self.num)
	end
	if self.hasEffect then
		self.hasEffect = false
		self.fields.mv_xxjj:setVisible(false)
		self.fields.mv_xxjj:setPlaying(false)
	end
end
function Com_star:updateStar(num)
	if self.num ~= num and 0 < num then
		self:showEffect(num)
	else
		self:initData(num)
	end
end
function Com_star:showEffect(num)
	self.fields.mv_xxjj:setVisible(true)
	local index = math.min(6, num)
	local Image_star = self.fields["star_" .. index]
	if Image_star then
		local pos = cc.p(Image_star:getPositionX() - 69, Image_star:getPositionY() - 67)
		self.fields.mv_xxjj:setPosition(pos)
		self.fields.mv_xxjj:setAllFrameNameOnce("dh_sdsl_xxjj_%02d.png", 1)
		self.fields.mv_xxjj:setPlaying(true)
		self.hasEffect = true
		self.fields.mv_xxjj:setPlaySettings(0, -1, 1, -1, function()
			self.hasEffect = false
			self:initData(num)
			self.fields.mv_xxjj:setVisible(false)
		end)
	end
end
return Com_star
