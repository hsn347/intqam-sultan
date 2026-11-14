local epicBattleDef = include("epicBattleDef")
local epicBattleMapPlayer = class("epicBattleMapPlayer", function(target)
	if target == nil then
		return SoraDCreateBasePanel("epicBattleMapPlayer")
	end
	return target
end)
function epicBattleMapPlayer:ctor()
	self.dirArray, _ENV, self.armyPos, _ENV, self.armyArray, _ENV = nil, nil, nil, nil, nil, nil
	self.icon_xf = SoraDGetChildByName(self, "icon_xf")
	self.icon_xf:setGroupID(epicBattleDef.groupIDDef.GROUP_XF)
	epicBattleDef = self.icon_xf
	self.icon_xf[1] = cca.moveBy(1.0, 0, 5)
	self.icon_xf[2] = cca.moveBy(1.0, 0, -5)
	self.icon_xf[3] = cca.moveBy(1.0, 0, -5)
	self.icon_xf[4] = cca.moveBy(1.0, 0, -5)
	self.icon_xf[5] = cca.moveBy(1.0, 0, -5)
	self.icon_xf[6] = cca.moveBy(1.0, 0, -5)
	self.icon_xf[7] = cca.moveBy(1.0, 0, -5)
	self.icon_xf[8] = cca.moveBy(1.0, 0, -5)
	local seq = cca.seq(self.icon_xf)
	self.icon_xf:runAction(cc.RepeatForever:create(seq))
	for i = 1, 9 do
		self.armyArray[i] = SoraDGetChildByName(self, "bubing_" .. i)
		_ENV = SoraDGetChildByName(self, "bubing_" .. i)
		SoraDGetChildByName(self, "bubing_" .. i).x = self.armyArray[i]:getPositionX()
		self.armyPos[i], SoraDGetChildByName(self, "bubing_" .. i).y = SoraDGetChildByName(self, "bubing_" .. i), self.armyArray[i]:getPositionY()
	end
	self.Node_dir = SoraDGetChildByName(self, "Node_dir")
	self.dirArray[epicBattleDef.epicPlayerDirDef.wn] = SoraDGetChildByName(self.Node_dir, "frame_arrow_lu")
	self.dirArray[epicBattleDef.epicPlayerDirDef.ws] = SoraDGetChildByName(self.Node_dir, "frame_arrow_ld")
	self.dirArray[epicBattleDef.epicPlayerDirDef.en] = SoraDGetChildByName(self.Node_dir, "frame_arrow_ru")
	self.dirArray[epicBattleDef.epicPlayerDirDef.es] = SoraDGetChildByName(self.Node_dir, "frame_arrow_rd")
	for k, v in pairs(self.dirArray) do
		v:stopAllActions()
		_ENV = self.armyArray[i]
		self.armyArray[i].beginOpacity = 0.5
		self.armyArray[i].endOpacity = 1.0
		SoraDFadeINOUT(v, self.armyArray[i])
		v:setGroupID(epicBattleDef.groupIDDef.GROUP_DIR)
	end
end
function epicBattleMapPlayer:setDirShow(param)
	for _, v in pairs(self.dirArray) do
		v:setVisible(false)
	end
	for k, v in pairs(param) do
		self.dirArray[v]:setVisible(true)
	end
end
function epicBattleMapPlayer:runDirAnimation(dir)
	dir = dir or epicBattleDef.epicPlayerDirDef.ws
	if dir == epicBattleDef.epicPlayerDirDef.wn then
		self:setWnAnimation()
	elseif dir == epicBattleDef.epicPlayerDirDef.ws then
		self:setWsAnimation()
	elseif dir == epicBattleDef.epicPlayerDirDef.en then
		self:setEnAnimation()
	elseif dir == epicBattleDef.epicPlayerDirDef.es then
		self:setEsAnimation()
	end
end
function epicBattleMapPlayer:runDirFightAnimation(dir)
	dir = dir or epicBattleDef.epicPlayerDirDef.ws
	if dir == epicBattleDef.epicPlayerDirDef.wn then
		self:setWnFightAnimation()
	elseif dir == epicBattleDef.epicPlayerDirDef.ws then
		self:setWsFightAnimation()
	elseif dir == epicBattleDef.epicPlayerDirDef.en then
		self:setEnFightAnimation()
	elseif dir == epicBattleDef.epicPlayerDirDef.es then
		self:setEsFightAnimation()
	end
end
function epicBattleMapPlayer:spreadout(dir)
	self.icon_xf:setVisible(false)
	self.Node_dir:setVisible(false)
	local _r = 70
	local _angle = 360 / (#self.armyArray * 2)
	for k, v in ipairs(self.armyArray) do
		local _rad = math.rad(-_angle * (k - 1))
		if dir == epicBattleDef.epicPlayerFightDirDef.right then
			_rad = math.rad(_angle * (k - 1))
		end
		local _posX = _r * math.sin(_rad)
		local _posY = _r * math.cos(_rad)
		_ENV = nil
		;(nil)[1] = cca.moveTo(1, _posX, _posY)
		;(nil)[2] = cca.moveTo(1, _posX, _posY)
		;(nil)[3] = cca.moveTo(1, _posX, _posY)
		;(nil)[4] = cca.moveTo(1, _posX, _posY)
		local seq = cca.seq(nil)
		v:runAction(seq)
	end
end
function epicBattleMapPlayer:linedup(dir)
	dir = dir or epicBattleDef.epicPlayerDirDef.ws
	local isFlipX = false
	local cacheName = "bubingwn"
	if dir == epicBattleDef.epicPlayerDirDef.wn then
		isFlipX = false
		cacheName = "bubingwn"
	elseif dir == epicBattleDef.epicPlayerDirDef.ws then
		isFlipX = false
		cacheName = "bubingws"
	elseif dir == epicBattleDef.epicPlayerDirDef.en then
		isFlipX = true
		cacheName = "bubingwn"
	elseif dir == epicBattleDef.epicPlayerDirDef.es then
		isFlipX = true
		cacheName = "bubingws"
	end
	local animation = display.getAnimationCache(cacheName)
	for k, v in ipairs(self.armyArray) do
		v:stopAllActions()
		v:setFlippedX(isFlipX)
		if animation then
			v:playAnimationForever(animation)
		end
		v:runAction(cca.moveTo(1, self.armyPos[k].x, self.armyPos[k].y))
	end
	self.icon_xf:setVisible(true)
	self.Node_dir:setVisible(true)
end
function epicBattleMapPlayer:setWnFightAnimation()
	local animation = display.getAnimationCache("bubinggjwn")
	for _, v in ipairs(self.armyArray) do
		v:stopAllActions()
		v:setFlippedX(false)
		if animation then
			v:playAnimationForever(animation)
		end
	end
end
function epicBattleMapPlayer:setWsFightAnimation()
	local animation = display.getAnimationCache("bubinggjws")
	for _, v in ipairs(self.armyArray) do
		v:stopAllActions()
		v:setFlippedX(false)
		if animation then
			v:playAnimationForever(animation)
		end
	end
end
function epicBattleMapPlayer:setEnFightAnimation()
	local animation = display.getAnimationCache("bubinggjwn")
	for _, v in ipairs(self.armyArray) do
		v:stopAllActions()
		v:setFlippedX(true)
		if animation then
			v:playAnimationForever(animation)
		end
	end
end
function epicBattleMapPlayer:setEsFightAnimation()
	local animation = display.getAnimationCache("bubinggjws")
	for _, v in ipairs(self.armyArray) do
		v:stopAllActions()
		v:setFlippedX(true)
		if animation then
			v:playAnimationForever(animation)
		end
	end
end
function epicBattleMapPlayer:setWnAnimation()
	local animation = display.getAnimationCache("bubingwn")
	for _, v in ipairs(self.armyArray) do
		v:stopAllActions()
		v:setFlippedX(false)
		if animation then
			v:playAnimationForever(animation)
		end
	end
end
function epicBattleMapPlayer:setWsAnimation()
	local animation = display.getAnimationCache("bubingws")
	for _, v in ipairs(self.armyArray) do
		v:stopAllActions()
		v:setFlippedX(false)
		if animation then
			v:playAnimationForever(animation)
		end
	end
end
function epicBattleMapPlayer:setEnAnimation()
	local animation = display.getAnimationCache("bubingwn")
	for _, v in ipairs(self.armyArray) do
		v:stopAllActions()
		v:setFlippedX(true)
		if animation then
			v:playAnimationForever(animation)
		end
	end
end
function epicBattleMapPlayer:setEsAnimation()
	local animation = display.getAnimationCache("bubingws")
	for _, v in ipairs(self.armyArray) do
		v:stopAllActions()
		v:setFlippedX(true)
		if animation then
			v:playAnimationForever(animation)
		end
	end
end
return epicBattleMapPlayer
