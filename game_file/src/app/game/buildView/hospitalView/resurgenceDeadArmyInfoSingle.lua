local ResurgenceDeadArmyInfoSingle = class("resurgenceDeadArmyInfoSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("resurgenceDeadArmyInfoSingle")
	end
	return target
end)
function ResurgenceDeadArmyInfoSingle:ctor()
	self:setAnchorPoint(cc.p(0, 0))
	self.layout_content = SoraDGetChildByName(self, "layout_content")
	if self.layout_content then
		self.layout_content:setSwallowTouches(false)
	end
	self.sprite_fuhuo = SoraDGetChildByName(self, "sprite_fuhuo")
	self.labelFuhuo = SoraDGetChildByName(self, "text_fuhuo")
	self.labelDead = SoraDGetChildByName(self, "text_dead")
	self.nodeArmy = SoraDGetExtendChildFromCCSByName(self, "CCS_commonArmySingle_node")
end
function ResurgenceDeadArmyInfoSingle:initData(army, fromSpring)
	self.labelDead:setString(string.formatnumberthousands(army.dead))
	_G.SoraDSetTextWidthHeight(self.labelDead, cc.size(200, 60))
	self.labelFuhuo:setString(string.formatnumberthousands(army.wait))
	_G.SoraDSetTextWidthHeight(self.labelFuhuo, cc.size(100, 60))
	_ENV = cc.size(100, 60)
	cc.size(100, 60).id = army.id
	self.nodeArmy:initData(cc.size(100, 60))
	self.sprite_fuhuo:setSpriteFrame(fromSpring and "btn_life_water.png" or "btn_rechareactivity_27.png")
	self.sprite_fuhuo:setScale(fromSpring and 0.5 or 0.3)
end
return ResurgenceDeadArmyInfoSingle
