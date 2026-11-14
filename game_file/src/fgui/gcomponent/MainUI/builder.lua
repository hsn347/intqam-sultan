local baseComponent = require("fgui.base.baseComponent")
local builder = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/builder", builder)
function builder:onInit()
	self.fields.frame_main_building:setVisible(false)
	self.controllers.c3:setSelectedIndex(SoraDFIsRA() and 0 or 1)
end
function builder:onShow()
end
function builder:setBuild(buildID)
	local buildDescribe = include("buildDescribeRead")
	local buildName = buildDescribe.getIcon(buildID)
	if buildID == BUILDID.STAR_BRAVE_STATUE then
		self.fields.Sprite_build:setScaleX(-0.6)
	else
		self.fields.Sprite_build:setScaleX(0.5)
	end
	self.fields.Sprite_build:setSpriteFrame(buildName)
end
function builder:setControl1Index(index)
	self.controllers.c1:setSelectedIndex(index)
	self.controlIndex1 = index
end
function builder:setControl2Index(index)
	self.controllers.c2:setSelectedIndex(index)
	self.fields.Sprite_hammer:setVisible(index == 0)
end
function builder:getControl2Index()
	return self.controllers.c2:getSelectedIndex()
end
function builder:resetScale()
	self:setScale(1)
end
function builder:correctAnimation(isFree, isNoramlQueue)
	if self.controlIndex1 == 0 or self.controlIndex1 == 1 then
		isNoramlQueue = true
	end
	self.transitions.t0:stop()
	self.fields.Sprite_build:setVisible(false)
	if isNoramlQueue then
		self.fields.Sprite_hammer:setVisible(true)
	else
		self.fields.Sprite_lamp:setVisible(true)
	end
	self.fields.frame_main_building:setVisible(false)
	self.fields.Sprite_bar:setVisible(true)
	self:setControl2Index(isFree and 2 or 0)
end
function builder:isGoldBuilder()
	return self.controllers.c1:getSelectedIndex() == 1
end
function builder:setGoldBuilderParticle(isShow)
	if self.controllers.c1:getSelectedIndex() == 1 then
		self.fields.Particle_gold_1:setVisible(isShow)
		self.fields.Particle_gold_2:setVisible(isShow)
	end
end
function builder:setPercent(value)
	self.fields.Sprite_bar:setFillAmount(value)
end
function builder:runFlipAni(isNoramlQueue)
	if self.controlIndex1 == 0 or self.controlIndex1 == 1 then
		isNoramlQueue = true
	end
	_UPVALUE11_ = nil
	;(nil)[1] = ffa.scaleTo(0.5, 0, 1)
	;(nil)[2] = ffa.callFunc(function()
		self.fields.Sprite_build:setVisible(false)
		if isNoramlQueue then
			self.fields.Sprite_hammer:setVisible(true)
		else
			self.fields.Sprite_lamp:setVisible(true)
		end
		self.fields.Sprite_bar:setVisible(true)
		self.fields.frame_main_building:setVisible(true)
	end)
	;(nil)[3] = ffa.delay(0.15)
	;(nil)[4] = ffa.callFunc(function()
		self.fields.frame_main_building:setVisible(false)
	end)
	;(nil)[5] = ffa.scaleTo(0.5, 1)
	;(nil)[6] = ffa.delay(10)
	;(nil)[7] = ffa.scaleTo(0.5, 0, 1)
	;(nil)[8] = ffa.callFunc(function()
		self.fields.Sprite_build:setVisible(true)
		if isNoramlQueue then
			self.fields.Sprite_hammer:setVisible(false)
		else
			self.fields.Sprite_lamp:setVisible(false)
		end
		self.fields.Sprite_bar:setVisible(false)
		self.fields.frame_main_building:setVisible(true)
	end)
	;(nil)[9] = ffa.delay(0.15)
	;(nil)[10] = ffa.callFunc(function()
		self.fields.frame_main_building:setVisible(false)
	end)
	;(nil)[11] = ffa.scaleTo(0.5, -1, 1)
	;(nil)[12] = ffa.delay(10)
	;(nil)[13] = ffa.delay(10)
	;(nil)[14] = ffa.delay(10)
	local sequence_ex = ffa.seq(nil)
	self:stopAllActions()
	self:runAction(ffa.repeatForever(sequence_ex))
end
function builder:runHammerAni()
	self.transitions.t0:play(-1, 0)
end
function builder:setQueueType(queueType)
	self.queueType = queueType
	if self.queueType == gQueueTypeDef.garden_technology then
		self.fields.Sprite_hammer:setURL("icon_building_research.png")
		self.fields.Sprite_hammer:setScale(0.7)
	end
end
function builder:setGardenBuild(id)
	if self.queueType == gQueueTypeDef.garden_build_upgrade then
		local manorCityRead = include("manorCityRead")
		local buildImage = manorCityRead.getBuildSmallImage(id)
		self.fields.Sprite_build:setURL(buildImage)
		self.fields.Sprite_build:setScale(0.4)
		self.fields.Sprite_build:setPositionY(20)
	elseif self.queueType == gQueueTypeDef.garden_technology then
		local manorTechRead = include("manorTechRead")
		local cfg = manorTechRead.getTechShowCfg(id)
		self.fields.Sprite_build:setURL(cfg.techIcon)
	end
end
return builder
