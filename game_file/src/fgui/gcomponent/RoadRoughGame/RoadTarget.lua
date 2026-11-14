local foreignPavilionRead = include("foreignPavilionRead")
local baseComponent = require("fgui.base.baseComponent")
local RoadTarget = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoadRoughGame/RoadTarget", RoadTarget)
function RoadTarget:onInit()
	self.info, _UPVALUE0_ = nil, nil
end
function RoadTarget:onShow()
end
function RoadTarget:setTagetInfo(info)
	self.info = info
	if self.info.npcBlood then
		self:setBlood(self.info.npcBlood, self.info.npcType)
	else
		self:setBlood(0)
	end
	if self.info.npcModel then
		if self.info.npcModel == "hero" then
			_UPVALUE0_ = 0
			self:playYDMovie(0)
		else
			self:playDJMovie()
		end
	end
end
function RoadTarget:playDJMovie()
	local framesNpc = display.newFrames(self.info.npcModel .. "_dj_ws_%.2d.png", 1, 8)
	local animationNpc = display.newAnimation(framesNpc, 1.0 / #framesNpc)
	self.fields.movie:setAnimation(animationNpc)
	local cfg = foreignPavilionRead.getNpcModelCfg(self.info.npcModel)
	if cfg then
		self.fields.movie:setScale(cfg.scale)
		self.fields.movie:setPosition(cfg.offset)
	end
end
function RoadTarget:playGJMovie(dirCfg)
	local dir = dirCfg.dir or "ws"
	local isFX = dirCfg.isFX or false
	local framesNpc = display.newFrames(self.info.npcModel .. "_gj_" .. dir .. "_%.2d.png", 1, 8)
	local animationNpc = display.newAnimation(framesNpc, 1.0 / #framesNpc)
	self.fields.movie:setAnimation(animationNpc)
	local cfg = foreignPavilionRead.getNpcModelCfg(self.info.npcModel)
	if cfg then
		self.fields.movie:setScale(cfg.scale)
		self.fields.movie:setPosition(cfg.offset)
	end
	self.fields.movie:setFlip(isFX and 1 or 0)
end
function RoadTarget:playYDMovie(dirCfg)
	local dir = dirCfg.dir or "ws"
	local isFX = dirCfg.isFX or false
	local framesNpc = display.newFrames(self.info.npcModel .. "_yd_" .. dir .. "_%.2d.png", 1, 8)
	local animationNpc = display.newAnimation(framesNpc, 1.0 / #framesNpc)
	self.fields.movie:setAnimation(animationNpc)
	local cfg = foreignPavilionRead.getNpcModelCfg(self.info.npcModel)
	if cfg then
		self.fields.movie:setScale(cfg.scale)
		self.fields.movie:setPosition(cfg.offset)
	end
	self.fields.movie:setFlip(isFX and 1 or 0)
end
function RoadTarget:playSWMovie()
	_UPVALUE2_ = nil
	;(nil)[1] = ffa.callFunc(function()
		local framesNpc = display.newFrames(self.info.npcModel .. "_sw_ws_%.2d.png", 1, 8)
		local animationNpc = display.newAnimation(framesNpc, 1.0 / #framesNpc)
		self.fields.movie:setAnimation(animationNpc)
		self.fields.movie:setPlaySettings(0, -1, 1, -1)
		local cfg = foreignPavilionRead.getNpcModelCfg(self.info.npcModel)
		if cfg then
			self.fields.movie:setScale(cfg.scale)
			self.fields.movie:setPosition(cfg.offset)
		end
		self.fields.bar:tweenValue(0, 0.5)
	end)
	;(nil)[2] = ffa.delay(1.0)
	;(nil)[3] = ffa.callFunc(function()
		self.info.blood = 0
		self:setVisible(false)
	end)
	;(nil)[4] = ffa.callFunc(function()
		self.info.blood = 0
		self:setVisible(false)
	end)
	self:runAction(ffa.seq(nil))
end
function RoadTarget:addBlood(blood)
	print("RoadTarget:addBlood=======", blood, self.info.x, self.info.y)
	self.info.blood = self.info.blood + blood
	self.fields.bar:setMax(self.info.blood)
	self.fields.bar:addBloodShow()
	self.fields.bar:tweenValue(self.info.blood, 0.5)
end
function RoadTarget:setBlood(blood, npcType)
	print("RoadTarget:setBlood=======", blood, self.info.x, self.info.y)
	self.info.blood = blood
	self.fields.bar:setMax(blood)
	self.fields.bar:setValue(blood)
	self.fields.bar:setVisible(0 < blood)
	self.fields.bar:setBarColor(npcType)
end
function RoadTarget:getBlood()
	return self.info.blood or 0
end
function RoadTarget:getX()
	return self.info.x
end
function RoadTarget:getY()
	return self.info.y
end
function RoadTarget:setXY(x, y)
	self.info.x = x
	self.info.y = y
end
return RoadTarget
