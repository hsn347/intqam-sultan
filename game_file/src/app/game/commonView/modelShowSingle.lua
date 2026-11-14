local modelShowSingle = class("modelShowSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("modelShowSingle")
	end
	return target
end)
local ANIMATION_SPEED = 0.7
local ANIMAL_SCALE = 3.6
function modelShowSingle:ctor()
	self.touchPanel = SoraDGetChildByName(self, "Panel_petTouch")
	self.touchPanel:addTouchEventListener(handler(self, self.onLayoutTouch))
	self.sprite3DAnimal = nil
	self.baseYAngle = -40
	self.curYAngle = self.baseYAngle
	self.otherAction = false
	self.isMoved = false
	self.isCanMove = true
	self.isForceOrthographic = true
	self.petRootNode = display.newNode()
	self.petRootNode:addTo(self)
	self.petRootNode.subModels, _ENV = self.petRootNode, self.petRootNode
end
function modelShowSingle:setColor(color)
	if self.sprite3DAnimal then
		self.sprite3DAnimal:setColor(color)
	end
	self.color = color
end
function modelShowSingle:touchAction()
	if self.sprite3DAnimal and self.petCfg.touchAction then
		self:playAnimationAndToDefault(self.petCfg.touchAction)
	end
end
function modelShowSingle:openMoveTouch(state)
	self.isCanMove = state
	self.touchPanel:setSwallowTouches(not state)
end
function modelShowSingle:setTouchSize(size)
	self.touchPanel:setContentSize(size)
end
function modelShowSingle:setTouchPanelTouchEnabled(enabled)
	self.touchPanel:setTouchEnabled(enabled or false)
end
function modelShowSingle:onLayoutTouch(target, event)
	if event == ccui.TouchEventType.ended then
		self.curYAngle = self.petRootNode:getRotation3D().y
		if not self.isMoved and not self.otherAction then
			self:touchAction()
			_UPVALUE1_ = nil
			;(nil)[1] = cca.delay(5)
			;(nil)[2] = cca.callFunc(function(...)
				self.otherAction = false
			end)
			;(nil)[3] = cca.callFunc(function(...)
				self.otherAction = false
			end)
			;(nil)[4] = cca.callFunc(function(...)
				self.otherAction = false
			end)
			self.touchPanel:runAction(cca.seq(nil))
			self.otherAction = true
		end
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = math.abs(touchmovePoint.x - touchBeganPoint.x)
		local degree = distance / 320 * 270
		if touchmovePoint.x - touchBeganPoint.x < 0 then
			degree = -degree
		end
		if math.abs(degree) > 1 and self.isCanMove and self.sprite3DAnimal then
			_ENV = cca.seq(nil)
			cca.seq(nil).x = 0
			cca.seq(nil).y = self.curYAngle + degree
			cca.seq(nil).z = 0
			self.petRootNode:setRotation3D(cca.seq(nil))
		end
		if distance > TOUCH_MOVED_ERROR_VALUE then
			self.isMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.curYAngle = self.petRootNode:getRotation3D().y
		self.isMoved = false
	elseif event == ccui.TouchEventType.began then
		self.isMoved = false
	end
end
function modelShowSingle:loadShaderForSprite(sprite3D, shaderName, shaderParam, subMesh)
	shaderName = shaderName or "3dColorTexAlphaCutout"
	local meshs = sprite3D:getMeshes()
	local shader = self:getOrCreateByShaderName(shaderName)
	local state = cc.GLProgramState:create(shader)
	for _, mesh in ipairs(meshs) do
		SoraDSetProgramStateParam(shader, state, shaderParam, mesh)
	end
	if not subMesh then
		sprite3D:setGLProgramState(state)
	else
		sprite3D:setGLProgramStateForMesh(state, subMesh)
	end
end
function modelShowSingle:getOrCreateByShaderName(shaderName)
	local petDesRead = include("petDesRead")
	return petDesRead.getOrCreateByShaderName(shaderName)
end
function modelShowSingle:loadAnimation(sprite3D, cfg, animationName, isOnce, handle)
	local animation = cc.Animation3D:create(cfg.file)
	if nil ~= animation then
		local animate = cc.Animate3D:createWithFrames(animation, cfg[animationName].startFrame, cfg[animationName].endFrame)
		animate:setSpeed(self.petCfg.speed or ANIMATION_SPEED)
		sprite3D:stopAllActions()
		if isOnce then
			if handle then
				ANIMATION_SPEED = cfg[animationName].endFrame
				cfg[animationName].endFrame[1] = animate
				cfg[animationName].endFrame[2] = cca.callFunc(function(...)
					handle()
				end)
				cfg[animationName].endFrame[3] = cca.callFunc(function(...)
					handle()
				end)
				self.sprite3DAnimal:runAction(cca.seq(cfg[animationName].endFrame))
			else
				sprite3D:runAction(animate)
			end
		else
			sprite3D:runAction(cc.RepeatForever:create(animate))
		end
	end
end
function modelShowSingle:resetData()
	self.sprite3DAnimal:removeFromParent()
	self.sprite3DAnimal = nil
	self.curYAngle = self.baseYAngle
	self.otherAction = false
	self.touchPanel:stopAllActions()
	for _, v in pairs(self.petRootNode.subModels) do
		if v and not tolua.isnull(v) then
			v:removeFromParent()
		end
	end
	self.petRootNode.subModels, _ENV = pairs(self.petRootNode.subModels)
end
function modelShowSingle:initData(data)
	if self.petCfg ~= data and self.sprite3DAnimal then
		self:resetData()
	end
	self.petCfg = data
	if not self.petCfg then
		return
	end
	self.touchPanel:setTouchEnabled(not not self.petCfg.touchEnabled)
	if self.sprite3DAnimal == nil then
		self.actState = 0
		print("petCfg.file = ", self.petCfg.file)
		local sprite = cc.Sprite3D:create(self.petCfg.file)
		if not sprite then
			print("load sprite3D error", self.petCfg.file)
			return
		end
		if self.petCfg.scale then
			sprite:setScale(self.petCfg.scale)
		else
			sprite:setScale(ANIMAL_SCALE)
		end
		_ENV = ANIMAL_SCALE
		ANIMAL_SCALE.x = 0
		ANIMAL_SCALE.y = self.curYAngle
		ANIMAL_SCALE.z = 0
		self.petRootNode:setRotation3D(ANIMAL_SCALE)
		sprite:setPosition(cc.p(self.petCfg.posX or 0, -sprite:getContentSize().height * 2 + (self.petCfg.posY or 0)))
		sprite:addTo(self.petRootNode, 0)
		sprite:setName("3d_pet")
		self.sprite3DAnimal = sprite
		self:loadShaderForSprite(self.sprite3DAnimal, self.petCfg.shader, self.petCfg.shaderParam)
		if self.petCfg.subShaders and next(self.petCfg.subShaders) ~= nil then
			for k, v in pairs(self.petCfg.subShaders) do
				self:loadShaderForSprite(sprite, v.shader, v.shaderParam, k)
			end
		end
		sprite:setCullFaceEnabled(false)
		if self.petRootNode.subModels == nil then
			self.petRootNode.subModels, _ENV = sprite, sprite
		end
		if self.petCfg.subModels and next(self.petCfg.subModels) ~= nil then
			for k, v in pairs(self.petCfg.subModels) do
				local sprite = cc.Sprite3D:create(v.file)
				if v.scale then
					sprite:setScale(v.scale)
				else
					sprite:setScale(ANIMAL_SCALE)
				end
				sprite:setPosition(cc.p(v.posX or 0, v.posY))
				sprite:addTo(self.petRootNode)
				sprite:setName("3d_pet")
				self:loadShaderForSprite(sprite, v.shader, v.shaderParam)
				self.petRootNode.subModels[k] = sprite
			end
		end
		self:setIsForceOrthographic(self.isForceOrthographic)
		sprite:setUsingLocalTransparentLayer(true)
	end
	self:playDefaultAnimation()
end
function modelShowSingle:playDefaultAnimation()
	if self.sprite3DAnimal ~= nil and self.petCfg.defaultAnimation then
		self:playAnimation(self.petCfg.defaultAnimation)
	end
end
function modelShowSingle:playAnimationAndToDefault(name)
	self:playAnimation(name, true, function()
		self:playDefaultAnimation()
	end)
end
function modelShowSingle:playAnimation(name, onece, handle)
	self:loadAnimation(self.sprite3DAnimal, self.petCfg, name, onece, handle)
	if self.petCfg.subModels and next(self.petCfg.subModels) ~= nil then
		for k, v in pairs(self.petCfg.subModels) do
			if self.petRootNode.subModels[k] then
				self:loadAnimation(self.petRootNode.subModels[k], v, name, onece, handle)
			end
		end
	end
end
function modelShowSingle:setSpriteRelativeScale(relativeScale, deltaH)
	print("setSpriteRelativeScale = ", relativeScale, deltaH)
	if self.sprite3DAnimal == nil then
		print("没找到---")
		return
	end
	if self.petCfg.scale then
		print("最终比例 = ", self.petCfg.scale * relativeScale)
		self.sprite3DAnimal:setScale(self.petCfg.scale * relativeScale)
	else
		print("最终比例默认 = ", ANIMAL_SCALE * relativeScale)
		self.sprite3DAnimal:setScale(ANIMAL_SCALE * relativeScale)
	end
end
function modelShowSingle:getIsForceOrthographic()
	return self.isForceOrthographic
end
function modelShowSingle:setIsForceOrthographic(isForceOrthographic)
	self.isForceOrthographic = isForceOrthographic
	if self.sprite3DAnimal and self.sprite3DAnimal.setIsForceOrthographic then
		self.sprite3DAnimal:setIsForceOrthographic(isForceOrthographic)
	end
	for _, v in ipairs(self.petRootNode.subModels) do
		if v and v.setIsForceOrthographic then
			v:setIsForceOrthographic(isForceOrthographic)
		end
	end
end
return modelShowSingle
