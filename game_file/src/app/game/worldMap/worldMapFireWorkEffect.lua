local worldMapFireWorkEffect = class("worldMapFireWorkEffect", function()
	return cc.Node:create()
end)
function worldMapFireWorkEffect:ctor(effectType)
	_ENV, _UPVALUE2_, self.effectPool, _ENV, self.effectType = nil, effectType or worldMapCastleEffectID.Flowery_Firework, effectType or worldMapCastleEffectID.Flowery_Firework, effectType or worldMapCastleEffectID.Flowery_Firework, effectType or worldMapCastleEffectID.Flowery_Firework
	;(nil).p1 = "et_tongyongchengse_01.plist"
	;(nil).p2 = "et_sschengse_02.plist"
	;(nil).p3 = "et_sschengse_03.plist"
	;(nil).p4 = "et_sschengse_01.plist"
	_ENV, (nil).image = nil, "#dh_tongyongchengse_011.png"
	;(nil).p1 = "et_tongyonglanse_01.plist"
	;(nil).p2 = "et_sslanse_02.plist"
	;(nil).p3 = "et_sslanse_03.plist"
	;(nil).p4 = "et_sslanse_01.plist"
	;(nil).image = "#dh_tongyonglanse_011.png"
	_ENV, _UPVALUE3_, self.doubleConfigList, (effectType or worldMapCastleEffectID.Flowery_Firework)[1] = nil, effectType or worldMapCastleEffectID.Flowery_Firework, effectType or worldMapCastleEffectID.Flowery_Firework
	_ENV, _UPVALUE3_, self.doubleConfigList, (effectType or worldMapCastleEffectID.Flowery_Firework)[2] = nil, effectType or worldMapCastleEffectID.Flowery_Firework, effectType or worldMapCastleEffectID.Flowery_Firework
	;(nil).p0 = "et_tongyongzise_01.plist"
	;(nil).p1 = "et_1year_01.plist"
	;(nil).p2 = "et_1year_02.plist"
	;(nil).p3 = "et_1year_03.plist"
	;(nil).p4 = "et_1year_04.plist"
	;(nil).p5 = "et_1year_05.plist"
	;(nil).p6 = "et_1year_06.plist"
	;(nil).p7 = "et_1year_07.plist"
	_ENV, (nil).image = nil, "#dh_tongyongzise_011.png"
	;(nil).p0 = "et_tongyongchengse_01.plist"
	;(nil).p1 = "et_1year_01.plist"
	;(nil).p2 = "et_1year_02.plist"
	;(nil).p3 = "et_1year_03_01.plist"
	;(nil).p4 = "et_1year_04.plist"
	;(nil).p5 = "et_1year_05.plist"
	;(nil).p6 = "et_1year_06.plist"
	;(nil).p7 = "et_1year_07.plist"
	_ENV, (nil).image = nil, "#dh_tongyongchengse_011.png"
	;(nil).p0 = "et_tongyonglanse_01.plist"
	;(nil).p1 = "et_1year_01.plist"
	;(nil).p2 = "et_1year_02.plist"
	;(nil).p3 = "et_1year_03_02.plist"
	;(nil).p4 = "et_1year_04.plist"
	;(nil).p5 = "et_1year_05.plist"
	;(nil).p6 = "et_1year_06.plist"
	;(nil).p7 = "et_1year_07.plist"
	;(nil).image = "#dh_tongyonglanse_011.png"
	self.newYearConfig, (effectType or worldMapCastleEffectID.Flowery_Firework)[1] = effectType or worldMapCastleEffectID.Flowery_Firework
	self.newYearConfig, (effectType or worldMapCastleEffectID.Flowery_Firework)[2] = effectType or worldMapCastleEffectID.Flowery_Firework
	self.newYearConfig, (effectType or worldMapCastleEffectID.Flowery_Firework)[3] = effectType or worldMapCastleEffectID.Flowery_Firework
	if self.effectType == worldMapCastleEffectID.Flowery_Firework then
		self.config = self.doubleConfigList[math.random(#self.doubleConfigList)]
	elseif self.effectType == worldMapCastleEffectID.Festival_Firework then
		self.config = self.newYearConfig[math.random(#self.newYearConfig)]
	end
	self:setNodeEventEnabled(true)
end
function worldMapFireWorkEffect:createNewYearFireWorkSub1(config)
	local node = table.remove(self.effectPool)
	if not node then
		_UPVALUE3_ = self.effectPool
		self.effectPool[1] = "dh_tongyongzise_011.png"
		self.effectPool[2] = "dh_tongyonglanse_011.png"
		local self.effectPool[3], list = "dh_tongyongchengse_011.png", self.effectPool
		local path = "Particle/"
		local image = list[math.random(#list)]
		node = cc.Node:create()
		_ENV = cc.Node
		_ENV, cc.Node.plist = path .. config.p1, path .. config.p1
		;(path .. config.p1).x = 0
		_ENV, cc.Node.pos, (path .. config.p1).y = path .. config.p1, path .. config.p1, 0
		;(path .. config.p1).x = 1.3
		cc.Node.scale, (path .. config.p1).y = path .. config.p1, 2
		cc.Node.rotate = 180
		node.p1 = util.createParticle(cc.Node)
		_ENV = cc.Node
		_ENV, cc.Node.plist = path .. config.p2, path .. config.p2
		;(path .. config.p2).x = 0
		_ENV, cc.Node.pos, (path .. config.p2).y = path .. config.p2, path .. config.p2, 40
		;(path .. config.p2).x = 1.3
		cc.Node.scale, (path .. config.p2).y = path .. config.p2, 1.3
		node.p2 = util.createParticle(cc.Node)
		_ENV = cc.Node
		_ENV, cc.Node.plist = path .. config.p7, path .. config.p7
		;(path .. config.p7).x = 0
		_ENV, cc.Node.pos, (path .. config.p7).y = path .. config.p7, path .. config.p7, 40
		;(path .. config.p7).x = 1.5
		cc.Node.scale, (path .. config.p7).y = path .. config.p7, 1.5
		node.p7 = util.createParticle(cc.Node)
		node.tail = cc.MotionStreak:create(0.6, 1, 130, cc.c3b(255, 255, 255), path .. image)
		node.p1:setPositionType(cc.POSITION_TYPE_FREE)
		node.p2:stopSystem()
		node.p7:stopSystem()
		node:addChild(node.p1)
		node:addChild(node.p2)
		node:addChild(node.p7)
		node:addChild(node.tail)
		self:addChild(node, 1)
		function node.play()
			local symbol = math.random(100) > 60 and 1 or -1
			node.originPos = cc.p(math.random(30) * symbol, 0)
			node:setPosition(node.originPos)
			local targetPos = cc.p(math.random(-50, 50), math.random(250, 330))
			local basePos = cc.p(0, 0)
			local controlPos = cc.p(0, 0)
			local r = math.random(50, 300)
			local centerPos = cc.p((basePos.x + targetPos.x) / 2, (basePos.y + targetPos.y) / 2)
			local radian = cc.pToAngleSelf(cc.pSub(targetPos, basePos)) + math.pi / 2 * symbol
			controlPos.x = centerPos.x + r * math.cos(radian)
			_UPVALUE3_, controlPos.y = centerPos.y + r * math.sin(radian), centerPos.y + r * math.sin(radian)
			;(centerPos.y + r * math.sin(radian))[1] = basePos
			;(centerPos.y + r * math.sin(radian))[2] = controlPos
			local (centerPos.y + r * math.sin(radian))[3], bezierArray = targetPos, centerPos.y + r * math.sin(radian)
			local particle = cca.callFunc(function()
				node.p2:setPosition(targetPos)
				node.p7:setPosition(targetPos)
				node.p2:setVisible(true)
				node.p2:resetSystem()
				node.p7:setVisible(true)
				node.p7:resetSystem()
				node.p1:stopSystem()
			end)
			local hideTail = cca.callFunc(function()
				node.tail:setVisible(false)
			end)
			local finish = cca.callFunc(function()
				table.insert(self.effectPool, node)
				node.finish = true
			end)
			_UPVALUE6_ = cc.pSub(targetPos, basePos)
			cc.pSub(targetPos, basePos)[1] = cc.BezierTo:create(1, bezierArray)
			cc.pSub(targetPos, basePos)[2] = particle
			cc.pSub(targetPos, basePos)[3] = cca.delay(0.1)
			cc.pSub(targetPos, basePos)[4] = hideTail
			cc.pSub(targetPos, basePos)[5] = cca.delay(2)
			cc.pSub(targetPos, basePos)[6] = finish
			local action = cca.seq(cc.pSub(targetPos, basePos))
			node.p1:runAction(action)
			node.tail:runAction(cc.BezierTo:create(1, bezierArray))
		end
		function node.reset()
			node.finish = false
			local basePos = cc.p(0, 0)
			node.p2:setPosition(basePos)
			node.p7:setPosition(basePos)
			node.p1:setPosition(basePos)
			node.tail:setPosition(basePos)
			node.p2:setVisible(false)
			node.p2:stopSystem()
			node.p7:setVisible(false)
			node.p7:stopSystem()
			node.p1:setVisible(true)
			node.p1:resetSystem()
			node.tail:setVisible(true)
			node.tail:reset()
		end
	else
		node.reset()
	end
	node.play()
	return node
end
function worldMapFireWorkEffect:createNewYearFireWorkSub(config)
	local node = table.remove(self.effectPool)
	if not node then
		local path = "Particle/"
		node = cc.Node:create()
		_ENV = cc.Node
		_ENV, cc.Node.plist = path .. config.p1, path .. config.p1
		;(path .. config.p1).x = 0
		_ENV, cc.Node.pos, (path .. config.p1).y = path .. config.p1, path .. config.p1, 30
		;(path .. config.p1).x = 1.3
		cc.Node.scale, (path .. config.p1).y = path .. config.p1, 2
		cc.Node.rotate = 180
		node.p1 = util.createParticle(cc.Node)
		_ENV = cc.Node
		_ENV, cc.Node.plist = path .. config.p2, path .. config.p2
		;(path .. config.p2).x = 0
		_ENV, cc.Node.pos, (path .. config.p2).y = path .. config.p2, path .. config.p2, 40
		;(path .. config.p2).x = 1.3
		cc.Node.scale, (path .. config.p2).y = path .. config.p2, 1.3
		node.p2 = util.createParticle(cc.Node)
		_ENV = cc.Node
		_ENV, cc.Node.plist = path .. config.p7, path .. config.p7
		;(path .. config.p7).x = 0
		_ENV, cc.Node.pos, (path .. config.p7).y = path .. config.p7, path .. config.p7, 40
		;(path .. config.p7).x = 1.5
		cc.Node.scale, (path .. config.p7).y = path .. config.p7, 1.5
		node.p7 = util.createParticle(cc.Node)
		node.sprite = display.newSprite(config.image)
		node.sprite:setScaleY(1.3)
		node.p2:stopSystem()
		node.p7:stopSystem()
		node:addChild(node.sprite)
		node:addChild(node.p1)
		node:addChild(node.p2)
		node:addChild(node.p7)
		self:addChild(node, 1)
		function node.play()
			local symbol = math.random(100) > 70 and 1 or -1
			node.originPos = cc.p(math.random(30) * symbol, 0)
			node:setPosition(node.originPos)
			local r = 300
			local angle = math.random(-20, 20)
			local radian = (90 - angle) * math.pi / 180
			local x = math.cos(radian) * r
			local y = math.sin(radian) * r
			local px = math.cos(radian) * 30
			local py = math.sin(radian) * 30
			node.sprite:setRotation(angle)
			node.p1:setRotation(180 + angle)
			node.p1:setPosition(cc.p(px, py))
			local move = cca.moveBy(0.5, cc.p(x, y))
			local particle = cca.callFunc(function()
				node.p2:setVisible(true)
				node.p2:resetSystem()
				node.p7:setVisible(true)
				node.p7:resetSystem()
				node.p1:stopSystem()
				node.sprite:setVisible(false)
			end)
			local finish = cca.callFunc(function()
				table.insert(self.effectPool, node)
				node.finish = true
			end)
			_UPVALUE4_ = cc.p(x, y)
			cc.p(x, y)[1] = move
			cc.p(x, y)[2] = particle
			cc.p(x, y)[3] = cca.delay(2)
			cc.p(x, y)[4] = finish
			local action = cca.seq(cc.p(x, y))
			node:runAction(action)
		end
		function node.reset()
			node.finish = false
			node.p2:setVisible(false)
			node.p2:stopSystem()
			node.p7:setVisible(false)
			node.p7:stopSystem()
			node.p1:setVisible(true)
			node.p1:resetSystem()
			node.sprite:setVisible(true)
			node:setPosition(node.originPos)
		end
	else
		node.reset()
	end
	node.play()
	return node
end
function worldMapFireWorkEffect:createNewYearFireWork(config)
	local node = table.remove(self.effectPool)
	if not node then
		local path = "Particle/"
		node = cc.Node:create()
		local random = math.random(80, 150) / 100
		node:setScale(random)
		_ENV = node
		_ENV, node.plist = path .. config.p0, path .. config.p0
		;(path .. config.p0).x = 0
		_ENV, node.pos, (path .. config.p0).y = path .. config.p0, path .. config.p0, 30
		;(path .. config.p0).x = 1.3
		node.scale, (path .. config.p0).y = path .. config.p0, 2
		node.rotate = 180
		node.p0 = util.createParticle(node)
		_ENV = node
		_ENV, node.plist = path .. config.p1, path .. config.p1
		;(path .. config.p1).x = 0
		_ENV, node.pos, (path .. config.p1).y = path .. config.p1, path .. config.p1, 30
		;(path .. config.p1).x = 1.23
		node.scale, (path .. config.p1).y = path .. config.p1, 1.23
		node.p1 = util.createParticle(node)
		_ENV = node
		_ENV, node.plist = path .. config.p2, path .. config.p2
		;(path .. config.p2).x = 0
		_ENV, node.pos, (path .. config.p2).y = path .. config.p2, path .. config.p2, 40
		;(path .. config.p2).x = 1.42
		node.scale, (path .. config.p2).y = path .. config.p2, 1.42
		node.p2 = util.createParticle(node)
		_ENV = node
		_ENV, node.plist = path .. config.p3, path .. config.p3
		;(path .. config.p3).x = 0
		_ENV, node.pos, (path .. config.p3).y = path .. config.p3, path .. config.p3, 40
		;(path .. config.p3).x = 2.65
		node.scale, (path .. config.p3).y = path .. config.p3, 2.65
		node.p3 = util.createParticle(node)
		_ENV = node
		_ENV, node.plist = path .. config.p4, path .. config.p4
		;(path .. config.p4).x = 0
		_ENV, node.pos, (path .. config.p4).y = path .. config.p4, path .. config.p4, 40
		;(path .. config.p4).x = 1.46
		node.scale, (path .. config.p4).y = path .. config.p4, 1.46
		node.p4 = util.createParticle(node)
		_ENV = node
		_ENV, node.plist = path .. config.p5, path .. config.p5
		;(path .. config.p5).x = 0
		_ENV, node.pos, (path .. config.p5).y = path .. config.p5, path .. config.p5, 40
		;(path .. config.p5).x = 2.8
		node.scale, (path .. config.p5).y = path .. config.p5, 2.8
		node.p5 = util.createParticle(node)
		_ENV = node
		_ENV, node.plist = path .. config.p6, path .. config.p6
		;(path .. config.p6).x = 0
		_ENV, node.pos, (path .. config.p6).y = path .. config.p6, path .. config.p6, 40
		;(path .. config.p6).x = 1.49
		node.scale, (path .. config.p6).y = path .. config.p6, 1.49
		node.rotate = 92
		node.p6 = util.createParticle(node)
		_ENV = node
		_ENV, node.plist = path .. config.p7, path .. config.p7
		;(path .. config.p7).x = 0
		_ENV, node.pos, (path .. config.p7).y = path .. config.p7, path .. config.p7, 40
		;(path .. config.p7).x = 1.23
		node.scale, (path .. config.p7).y = path .. config.p7, 1.23
		node.p7 = util.createParticle(node)
		node.sprite = display.newSprite(config.image)
		node.sprite:setRotation(180)
		node.p0:stopSystem()
		node.p1:stopSystem()
		node.p2:stopSystem()
		node.p3:stopSystem()
		node.p4:stopSystem()
		node.p5:stopSystem()
		node.p6:stopSystem()
		node.p7:stopSystem()
		node:addChild(node.sprite)
		node:addChild(node.p0)
		node:addChild(node.p1)
		node:addChild(node.p2)
		node:addChild(node.p3)
		node:addChild(node.p4)
		node:addChild(node.p5)
		node:addChild(node.p6)
		node:addChild(node.p7)
		self:addChild(node)
		function node.play()
			node.originPos = cc.p(math.random(-80, 80), math.random(0, 50))
			node:setPosition(node.originPos)
			local r = math.random(120, 150)
			local angle = math.random(-20, 20)
			local radian = (90 - angle) * math.pi / 180
			local x = math.cos(radian) * r
			local y = math.sin(radian) * r
			local px = math.cos(radian) * 30
			local py = math.sin(radian) * 30
			node.sprite:setRotation(angle + 180)
			node.p0:setRotation(180 + angle)
			node.p0:setPosition(cc.p(px, py))
			local move = cca.moveBy(0.5, cc.p(x, y))
			local particle = cca.callFunc(function()
				node.p1:setVisible(true)
				node.p1:resetSystem()
				node.p2:setVisible(true)
				node.p2:resetSystem()
				node.p3:setVisible(true)
				node.p3:resetSystem()
				node.p4:setVisible(true)
				node.p4:resetSystem()
				node.p5:setVisible(true)
				node.p5:resetSystem()
				node.p6:setVisible(true)
				node.p6:resetSystem()
				node.p7:setVisible(true)
				node.p7:resetSystem()
				local elapsed = 0
				node.timer = SoradCreateTimer(node, function(dt)
				end, true)
				node.p0:stopSystem()
				node.sprite:setVisible(false)
			end)
			local finish = cca.callFunc(function()
				SoraDManagerRemoveTimer(node, node.timer)
				table.insert(self.effectPool, node)
				node.finish = true
			end)
			_UPVALUE4_ = cc.p(x, y)
			cc.p(x, y)[1] = move
			cc.p(x, y)[2] = particle
			cc.p(x, y)[3] = cca.delay(math.random(120, 180) / 100)
			cc.p(x, y)[4] = finish
			local action = cca.seq(cc.p(x, y))
			node:runAction(action)
		end
		function node.reset()
			node.finish = false
			node.p1:setVisible(false)
			node.p1:stopSystem()
			node.p2:setVisible(false)
			node.p2:stopSystem()
			node.p3:setVisible(false)
			node.p3:stopSystem()
			node.p4:setVisible(false)
			node.p4:stopSystem()
			node.p5:setVisible(false)
			node.p5:stopSystem()
			node.p6:setVisible(false)
			node.p6:stopSystem()
			node.p7:setVisible(false)
			node.p7:stopSystem()
			node.p0:setVisible(true)
			node.p0:resetSystem()
			node.sprite:setVisible(true)
			node:setPosition(node.originPos)
		end
	else
		node.reset()
	end
	node.play()
	return node
end
function worldMapFireWorkEffect:createDoubleFirework(config)
	local node = table.remove(self.effectPool)
	if not node then
		local path = "Particle/"
		node = cc.Node:create()
		_ENV = cc.Node
		_ENV, cc.Node.plist = path .. config.p1, path .. config.p1
		;(path .. config.p1).x = 0
		_ENV, cc.Node.pos, (path .. config.p1).y = path .. config.p1, path .. config.p1, 30
		;(path .. config.p1).x = 1.3
		cc.Node.scale, (path .. config.p1).y = path .. config.p1, 2
		cc.Node.rotate = 180
		node.p1 = util.createParticle(cc.Node)
		_ENV = cc.Node
		_ENV, cc.Node.plist = path .. config.p2, path .. config.p2
		;(path .. config.p2).x = 0
		_ENV, cc.Node.pos, (path .. config.p2).y = path .. config.p2, path .. config.p2, 40
		;(path .. config.p2).x = 1.5
		cc.Node.scale, (path .. config.p2).y = path .. config.p2, 1.5
		node.p2 = util.createParticle(cc.Node)
		_ENV = cc.Node
		_ENV, cc.Node.plist = path .. config.p3, path .. config.p3
		;(path .. config.p3).x = 0
		_ENV, cc.Node.pos, (path .. config.p3).y = path .. config.p3, path .. config.p3, 40
		;(path .. config.p3).x = 1.5
		cc.Node.scale, (path .. config.p3).y = path .. config.p3, 1.5
		node.p3 = util.createParticle(cc.Node)
		_ENV = cc.Node
		_ENV, cc.Node.plist = path .. config.p4, path .. config.p4
		;(path .. config.p4).x = 0
		_ENV, cc.Node.pos, (path .. config.p4).y = path .. config.p4, path .. config.p4, 40
		;(path .. config.p4).x = 4
		cc.Node.scale, (path .. config.p4).y = path .. config.p4, 4
		node.p4 = util.createParticle(cc.Node)
		node.sprite = display.newSprite(config.image)
		node.sprite:setScale(0.75)
		node.p2:stopSystem()
		node.p3:stopSystem()
		node.p4:stopSystem()
		node:addChild(node.sprite)
		node:addChild(node.p1)
		node:addChild(node.p2)
		node:addChild(node.p3)
		node:addChild(node.p4)
		self:addChild(node)
		function node.play()
			local symbol = math.random(100) > 70 and 1 or -1
			node.originPos = cc.p(math.random(30) * symbol, 0)
			node:setPosition(node.originPos)
			local r = math.random(120, 150)
			local angle = math.random(-20, 20)
			local radian = (90 - angle) * math.pi / 180
			local x = math.cos(radian) * r
			local y = math.sin(radian) * r
			local px = math.cos(radian) * 30
			local py = math.sin(radian) * 30
			node.sprite:setRotation(angle + 180)
			node.p1:setRotation(180 + angle)
			node.p1:setPosition(cc.p(px, py))
			local move = cca.moveBy(0.5, cc.p(x, y))
			local particle = cca.callFunc(function()
				node.p2:setVisible(true)
				node.p2:resetSystem()
				node.p3:setVisible(true)
				node.p3:resetSystem()
				node.p4:setVisible(true)
				node.p4:resetSystem()
				node.p1:stopSystem()
				node.sprite:setVisible(false)
			end)
			local finish = cca.callFunc(function()
				table.insert(self.effectPool, node)
				node.finish = true
			end)
			_UPVALUE4_ = cc.p(x, y)
			cc.p(x, y)[1] = move
			cc.p(x, y)[2] = particle
			cc.p(x, y)[3] = cca.delay(1)
			cc.p(x, y)[4] = finish
			local action = cca.seq(cc.p(x, y))
			node:runAction(action)
		end
		function node.reset()
			node.finish = false
			node.p2:setVisible(false)
			node.p2:stopSystem()
			node.p3:setVisible(false)
			node.p3:stopSystem()
			node.p4:setVisible(false)
			node.p4:stopSystem()
			node.p1:setVisible(true)
			node.p1:resetSystem()
			node.sprite:setVisible(true)
			node:setPosition(node.originPos)
		end
	else
		node.reset()
	end
	node.play()
	return node
end
function worldMapFireWorkEffect:playDoubleFirework()
	self:createDoubleFirework(self.doubleConfigList[math.random(#self.doubleConfigList)])
	self:createDoubleFirework(self.doubleConfigList[math.random(#self.doubleConfigList)])
	local elapsed = 0
	local mainRand = 0.1
	local rand = 1
	SoradCreateTimer(self, function(dt)
		if elapsed > rand then
			self:createDoubleFirework(self.doubleConfigList[math.random(#self.doubleConfigList)])
			self:createDoubleFirework(self.doubleConfigList[math.random(#self.doubleConfigList)])
		end
	end, true)
end
function worldMapFireWorkEffect:playNewYearFirework()
	self:createNewYearFireWork(self.newYearConfig[math.random(#self.newYearConfig)])
	local elapsed = 0
	local rand = math.random(80, 180) / 100
	SoradCreateTimer(self, function(dt)
		if elapsed > rand then
			self:createNewYearFireWork(self.newYearConfig[math.random(#self.newYearConfig)])
		end
	end, true)
end
function worldMapFireWorkEffect:playVictoryFirework(...)
	self:createVictoryFirework()
	local elapsed = 0
	local rand = math.random(150, 300) / 100
	SoradCreateTimer(self, function(dt)
		if elapsed > rand then
			self:createVictoryFirework()
		end
	end, true)
end
function worldMapFireWorkEffect:createVictoryFirework(...)
	local baseNode = table.remove(self.effectPool)
	if not baseNode then
		baseNode = display.newNode()
		self:addChild(baseNode)
		local node = SoraDCreatAnimationEx("yanhua1", nil, false)
		baseNode:addChild(node)
		baseNode.node = node
		local nextNode = SoraDCreatAnimationEx("yanhua", nil, false)
		baseNode.nextNode = nextNode
		baseNode:addChild(nextNode)
		baseNode.p1 = SoraDGetChildByName(node, "Particle_3_0")
		baseNode.p2 = SoraDGetChildByName(nextNode, "Particle_2")
		baseNode.p3 = SoraDGetChildByName(nextNode, "Particle_8")
		baseNode.p4 = SoraDGetChildByName(nextNode, "Particle_9")
		baseNode.p5 = SoraDGetChildByName(nextNode, "Particle_10")
		baseNode.p6 = SoraDGetChildByName(nextNode, "Particle_12")
		baseNode.p7 = SoraDGetChildByName(nextNode, "Particle_13")
		baseNode.s1 = SoraDGetChildByName(nextNode, "Sprite_3")
		function baseNode.play()
			local symbol = math.random(100) > 70 and 1 or -1
			local originPos = cc.p(math.random(30) * symbol, 30)
			baseNode.originPos = originPos
			baseNode.node:setPosition(originPos)
			local r = math.random(135, 150)
			local angle = math.random(-20, 20)
			local radian = (90 - angle) * math.pi / 180
			local x = math.cos(radian) * r
			local y = math.sin(radian) * r
			local px = math.cos(radian) * 100
			local py = math.sin(radian) * 100
			baseNode.node:setRotation(angle)
			baseNode.nextNode:setRotation(angle)
			baseNode.nextNode:setPosition(cc.p(originPos.x + x - px, originPos.y + y - py))
			baseNode.p2:stopSystem()
			baseNode.p3:stopSystem()
			baseNode.p4:stopSystem()
			baseNode.p5:stopSystem()
			baseNode.p6:stopSystem()
			baseNode.p7:stopSystem()
			baseNode.s1:setVisible(false)
			baseNode.p1:resetSystem()
			local move = cca.moveBy(0.4, cc.p(x, y))
			local particle = cca.callFunc(function()
				baseNode.node:setVisible(false)
				baseNode.p2:resetSystem()
				baseNode.p3:resetSystem()
				baseNode.p4:resetSystem()
				baseNode.p5:resetSystem()
				baseNode.p6:resetSystem()
				baseNode.p7:resetSystem()
				baseNode.s1:setVisible(true)
				local action = baseNode.nextNode.action
				if action and tolua.cast(action, "cc.Action") then
					action:gotoFrameAndPlay(0, false)
				end
			end)
			local finish = cca.callFunc(function()
				baseNode:setVisible(false)
				table.insert(self.effectPool, baseNode)
			end)
			_UPVALUE4_ = cc.p(x, y)
			cc.p(x, y)[1] = move
			cc.p(x, y)[2] = particle
			cc.p(x, y)[3] = cca.delay(2)
			cc.p(x, y)[4] = finish
			local action = cca.seq(cc.p(x, y))
			baseNode:runAction(action)
		end
		function baseNode.reset()
			baseNode:setVisible(true)
			baseNode:setPosition(cc.p(0, 0))
			baseNode.node:setVisible(true)
		end
	else
		baseNode.reset()
	end
	baseNode.play()
	return baseNode
end
function worldMapFireWorkEffect:playNewYearFirework_2020()
	self:createNewYearFireWorkSub_2020()
end
function worldMapFireWorkEffect:createNewYearFireWorkSub_2020()
	local baseNode = table.remove(self.effectPool)
	if not baseNode then
		baseNode = display.newNode()
		self:addChild(baseNode)
		local node = SoraDCreatAnimationEx("yanhua_2020", nil, true)
		SoraDMixtureGLONEByParent(node)
		baseNode:addChild(node)
		node:setPosition(0, 30)
		baseNode.node = node
		baseNode.s1 = SoraDGetChildByName(node, "dh_Tex_2020_001_01")
		baseNode.s1:setOpacity(0)
		_UPVALUE1_ = 30
		;(30)[1] = cca.delay(0.3333333333333333)
		;(30)[2] = cca.fadeTo(0.5, 1)
		;(30)[3] = cca.fadeTo(0.5, 1)
		;(30)[4] = cca.fadeTo(0.5, 1)
		baseNode.s1:runAction(cca.seq(30))
		baseNode:setGroupID(150)
		baseNode:setGroupAuto(true)
		table.insert(self.effectPool, baseNode)
		function baseNode.reset()
			baseNode:setVisible(true)
			baseNode.node:setVisible(true)
		end
	else
		baseNode.reset()
	end
	return baseNode
end
function worldMapFireWorkEffect:playNewYearFirework_2022()
	self:createNewYearFireWorkSub_2022()
end
function worldMapFireWorkEffect:createNewYearFireWorkSub_2022()
	local baseNode = table.remove(self.effectPool)
	if not baseNode then
		baseNode = display.newNode()
		self:addChild(baseNode)
		local node = SoraDCreatAnimationEx("yanhua_2022", nil, true)
		SoraDMixtureGLONEByParent(node)
		baseNode:addChild(node)
		node:setPosition(0, 330)
		baseNode.node = node
		baseNode.s2 = SoraDGetChildByName(node, "Sprite_5")
		local frames2 = display.newFrames("dh_xn_xh_%.2d.png", 1, 30)
		local animation2 = display.newAnimation(frames2, 2.0 / #frames2)
		baseNode.s2:setOpacity(0)
		baseNode.s2:playAnimationForever(animation2)
		_UPVALUE1_ = nil
		;(nil)[1] = cca.delay(0.34)
		;(nil)[2] = cca.fadeIn(0.6)
		;(nil)[3] = cca.fadeIn(0.6)
		;(nil)[4] = cca.fadeIn(0.6)
		;(nil)[5] = cca.fadeIn(0.6)
		baseNode.s2:runAction(cca.seq(nil))
		baseNode.s1 = SoraDGetChildByName(node, "Sprite_1")
		local frames1 = display.newFrames("dh_xn_cx_%.2d.png", 1, 20)
		local animation1 = display.newAnimation(frames1, 1.2 / #frames1)
		baseNode.s1:playAnimationOnce(animation1)
		_UPVALUE1_ = cca.seq(nil)
		cca.seq(nil)[1] = cca.delay(0.54)
		cca.seq(nil)[2] = cca.fadeOut(0.4)
		cca.seq(nil)[3] = cca.fadeOut(0.4)
		baseNode.s1:runAction(cca.seq(cca.seq(nil)))
		baseNode:setGroupID(150)
		baseNode:setGroupAuto(true)
		table.insert(self.effectPool, baseNode)
		function baseNode.reset()
			baseNode:setVisible(true)
			baseNode.node:setVisible(true)
		end
	else
		baseNode.reset()
	end
	return baseNode
end
function worldMapFireWorkEffect:playFirewworkCelebration()
	self:createFirewworkCelebration()
end
function worldMapFireWorkEffect:createFirewworkCelebration()
	local baseNode = table.remove(self.effectPool)
	if not baseNode then
		baseNode = display.newNode()
		self:addChild(baseNode)
		local node = SoraDCreatAnimationEx("yanhua_celebration", nil, true)
		SoraDMixtureGLONEByParent(node)
		baseNode:addChild(node)
		node:setPosition(-30, 80)
		baseNode.node = node
		baseNode:setGroupID(150)
		baseNode:setGroupAuto(true)
		table.insert(self.effectPool, baseNode)
		function baseNode.reset()
			baseNode:setVisible(true)
			baseNode.node:setVisible(true)
		end
	else
		baseNode.reset()
	end
	return baseNode
end
function worldMapFireWorkEffect:play()
	math.randomseed(tostring(os.time()):reverse():sub(1, 7))
	if self.effectType == worldMapCastleEffectID.Flowery_Firework then
		self:playDoubleFirework()
	elseif self.effectType == worldMapCastleEffectID.Festival_Firework then
		self:playNewYearFirework()
	elseif self.effectType == worldMapCastleEffectID.Victory_Firework then
		self:playVictoryFirework()
	elseif self.effectType == worldMapCastleEffectID.NewYear_FireWork_2020 then
		self:playNewYearFirework_2020()
	elseif self.effectType == worldMapCastleEffectID.NewYear_FireWork_2022 then
		self:playNewYearFirework_2022()
	elseif self.effectType == worldMapCastleEffectID.FirewWork_Ceremony then
		self:playFirewworkCelebration()
	end
end
function worldMapFireWorkEffect:stop()
	SoraDManagerRemoveTimerByTarget(self)
	SoradCreateTimer(self, function()
		local children = self:getChildren()
		local finish = true
		for i, child in ipairs(children) do
			if not child.finish then
				finish = false
			end
		end
		if finish then
			self:removeFromParent()
		end
	end)
end
function worldMapFireWorkEffect:onExit()
	local children = self:getChildren()
	for i, child in ipairs(children) do
		SoraDManagerRemoveTimerByTarget(child)
	end
	SoraDManagerRemoveTimerByTarget(self)
end
return worldMapFireWorkEffect
