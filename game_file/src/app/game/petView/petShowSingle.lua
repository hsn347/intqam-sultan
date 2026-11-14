local petDesRead = include("petDesRead")
local PetShowSingle = class("petShowSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("petShowSingle")
	end
	return target
end)
local ANIMATION_SPEED = 0.7
local ANIMAL_SCALE = 3.6
function PetShowSingle:ctor()
	self.touchPanel = SoraDGetChildByName(self, "Panel_petTouch")
	self.touchPanel:addTouchEventListener(handler(self, self.onLayoutTouch))
	self.btnUpdate = SoraDGetChildByName(self, "Button_update")
	self.labelUpdate = SoraDGetChildByName(self, "Text_update")
	self.imgSketch = SoraDGetChildByName(self, "Img_sketch")
	self.nodeDownload = SoraDGetChildByName(self, "node_download")
	self.text_download_tip = SoraDGetChildByName(self, "text_download_tip")
	self.btnUpdate:setVisible(false)
	self.btnUpdate:setTitleText(i18n("common_text_900"))
	self.sprite3DAnimal = nil
	self.baseYAngle = -40
	self.curYAngle = self.baseYAngle
	self.curPid = 0
	self.curRank = 0
	self.otherAction = false
	self.isMoved = false
	self.isCanMove = true
	self.isForceOrthographic = true
	self.inView = false
	self:setTag(1)
	self.petRootNode = display.newNode()
	self.petRootNode:setZ(250)
	self.petRootNode:setName("petRootNode")
	self.petRootNode:addTo(self)
	self.petRootNode.subModels, _ENV = self.petRootNode, self.petRootNode
	self.btnUpdate:addTouchEventListener(handler(self, self.updateClick))
	self.actState = 0
end
function PetShowSingle:onEnterPanel()
	if gPetZ == nil then
		gPetZ = 800
	else
		gPetZ = gPetZ - 50
	end
	self.petRootNode:setZ(gPetZ)
	print("PetShowSingle:onEnterPanel()")
end
function PetShowSingle:onExitPanel()
	if gPetZ == nil then
		gPetZ = 800
	else
		gPetZ = gPetZ + 50
	end
	print("PetShowSingle:onExitPanel()")
end
function PetShowSingle:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_OPTION_SHARE_BTN_UPDATE", handler(self, self.updateShareButton))
end
function PetShowSingle:updateShareButton(target, data)
	if data and data.otherPic ~= nil then
		if data.otherPic then
			self:showPUEffect()
		else
			self:hidePUEffect()
		end
	end
end
function PetShowSingle:setIsView(inView)
	self.inView = inView
end
function PetShowSingle:setSpriteScale(sprite)
	local scale
	if self.inView and self.petCfg.scaleView then
		scale = self.petCfg.scaleView
	elseif self.petCfg.scale then
		scale = self.petCfg.scale
	else
		scale = ANIMAL_SCALE
	end
	print(scale, "scale")
	sprite:setScale(scale)
end
function PetShowSingle:setColor(color)
	if self.sprite3DAnimal then
		self.sprite3DAnimal:setColor(color)
	end
	self.color = color
end
function PetShowSingle:touchAction(needProtected, protectTime)
	if self.sprite3DAnimal then
		self.sprite3DAnimal:setAnimationCompleteCallback("show", function()
			self.sprite3DAnimal:play("idle")
		end)
		self.sprite3DAnimal:play("show")
		SoraDPlaySound("petSound", self.petCfg.sound)
	end
end
function PetShowSingle:getActState()
	return self.actState
end
function PetShowSingle:hidePUEffect()
end
function PetShowSingle:showPUEffect()
end
function PetShowSingle:openMoveTouch(state)
	self.isCanMove = state
	self.touchPanel:setSwallowTouches(not state)
end
function PetShowSingle:onLayoutTouch(target, event)
	print("PetShowSingle:onLayoutTouch", event, self.isMoved, self.otherAction)
	if event == ccui.TouchEventType.ended then
		self.curYAngle = self.petRootNode:getRotation3D().y
		if not self.isMoved and not self.otherAction then
			self:touchAction()
			_UPVALUE1_ = self.isMoved
			self.isMoved[1] = cca.delay(5)
			self.isMoved[2] = cca.callFunc(function(...)
				self.otherAction = false
			end)
			self.isMoved[3] = cca.callFunc(function(...)
				self.otherAction = false
			end)
			self.isMoved[4] = cca.callFunc(function(...)
				self.otherAction = false
			end)
			self.touchPanel:runAction(cca.seq(self.isMoved))
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
			_ENV = cca.seq(self.isMoved)
			cca.seq(self.isMoved).x = 0
			cca.seq(self.isMoved).y = self.curYAngle + degree
			cca.seq(self.isMoved).z = 0
			self.petRootNode:setRotation3D(cca.seq(self.isMoved))
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
function PetShowSingle:updateClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDGoToAppStore()
	end
end
function PetShowSingle:setTouchSize(size)
	self.touchPanel:setContentSize(size)
end
function PetShowSingle:getOrCreateByShaderName(shaderName)
	return petDesRead.getOrCreateByShaderName(shaderName)
end
function PetShowSingle:loadAnimation(sprite3D, cfg, animationName, isOnce)
	self.sprite3DAnimal:play(animationName)
end
function PetShowSingle:initData(data)
	local pid = data.pid or data.petid
	local rank = data.rank
	local needRefreshAnim = false
	if data.forceRefreshAnim then
		needRefreshAnim = data.forceRefreshAnim
	end
	self.isShowPu = data.isShowPu
	if self.isShowPu == nil then
		self.isShowPu = true
	end
	self.petCfg = petDesRead.getPetCfg(pid, rank)
	if not self.petCfg then
		self.btnUpdate:setVisible(true)
		self.touchPanel:setTouchEnabled(false)
		if self.sprite3DAnimal then
			self.sprite3DAnimal:removeFromParent()
			self.sprite3DAnimal = nil
		end
		petDesRead = nil
		;(nil).des = petDesRead.getName(pid)
		self.labelUpdate:setString(i18n("common_text_1437", nil))
		self.nodeDownload:setVisible(false)
		return
	end
	self.touchPanel:setTouchEnabled(true)
	self.btnUpdate:setVisible(false)
	if (self.curPid ~= pid or self.curRank ~= rank) and self.sprite3DAnimal then
		self.sprite3DAnimal:removeFromParent()
		self.sprite3DAnimal = nil
		if self.curPid ~= pid then
			self.curYAngle = self.baseYAngle
		end
		self.otherAction = false
		self.touchPanel:stopAllActions()
		for k, v in pairs(self.petRootNode.subModels) do
			if v and not tolua.isnull(v) then
				v:removeFromParent()
			end
		end
		self.petRootNode.subModels, petDesRead = pairs(self.petRootNode.subModels)
	end
	if self.sprite3DAnimal == nil then
		self.actState = 0
		local sprite = cc.Sprite3D:create(self.petCfg.file, function(sprite)
			self.nodeDownload:setVisible(false)
		end)
		if not sprite then
			print("load sprite3D error", self.petCfg.file)
			return
		end
		self:setSpriteScale(sprite)
		petDesRead = sprite
		sprite.x = 0
		sprite.y = self.curYAngle
		sprite.z = 0
		self.petRootNode:setRotation3D(sprite)
		sprite:setPosition(cc.p(self.petCfg.posX or 0, -178 + self.petCfg.posY))
		sprite:addTo(self.petRootNode, 0)
		sprite:setName("3d_pet")
		self.sprite3DAnimal = sprite
		if self.petRootNode.subModels == nil then
			self.petRootNode.subModels, petDesRead = sprite, sprite
		end
		if self.petCfg.subModels and next(self.petCfg.subModels) ~= nil then
			for k, v in pairs(self.petCfg.subModels) do
				local sprite = cc.Sprite3D:create(v.file)
				self:setSpriteScale(sprite)
				sprite:setPosition(cc.p(v.posX or 0, v.posY or 0))
				sprite:addTo(self.petRootNode)
				sprite:setName("3d_pet")
				self.petRootNode.subModels[k] = sprite
			end
		end
		self.nodeDownload:setVisible(false)
		needRefreshAnim = true
		self:setIsForceOrthographic(self.isForceOrthographic)
		if sprite:getIsDownloading() then
			self.nodeDownload:setVisible(true)
			local sketchImg = petDesRead.getPetSketch(pid)
			sketchImg = sketchImg or "icon_dear_pet_shadow.png"
			if sketchImg then
				self.imgSketch:loadTexture(sketchImg, ccui.TextureResType.plistType)
				self.imgSketch:ignoreContentAdaptWithSize(true)
				self.imgSketch:setScale(pid == 1266 and 1.0 or 2.5)
				self.imgSketch:setPosition(petDesRead.getSketchPos(pid))
			end
			self.text_download_tip:setString(i18n("common_text_3853"))
			self.text_download_tip:setPositionY(pid == 1266 and -50 or 0)
			SoraDGetAutoHeightLabel(self.text_download_tip, 370)
		end
	end
	if self.sprite3DAnimal ~= nil and needRefreshAnim then
		self:loadAnimation(self.sprite3DAnimal, self.petCfg, "idle")
		if self.petCfg.subModels and next(self.petCfg.subModels) ~= nil then
			for k, v in pairs(self.petCfg.subModels) do
				if self.petRootNode.subModels[k] then
					self:loadAnimation(self.petRootNode.subModels[k], v, "idle")
				end
			end
		end
	end
	self.curPid = pid
	self.curRank = rank
end
function PetShowSingle:playUpgradeEffect(needAction, needProtected, protectTime)
	if not self.touchPanel then
		return
	end
	if needProtected then
		if self.isInProtect == true then
			return
		else
			self.isInProtect = true
			_UPVALUE1_ = nil
			;(nil)[1] = cca.delay(protectTime or 3)
			;(nil)[2] = cca.callFunc(function()
				self.isInProtect = false
			end)
			;(nil)[3] = cca.callFunc(function()
				self.isInProtect = false
			end)
			;(nil)[4] = cca.callFunc(function()
				self.isInProtect = false
			end)
			self:runAction(cca.seq(nil))
		end
	end
	SoraDPlaySound("innercontrol", 9)
	if not self.bottomNode then
		self.bottomNode = SoraDCreatAnimation("petLevelUpBottom", nil, false)
		self.bottomNode:addTo(self, -1)
		self.bottomNode:setPositionY(-70)
	else
		SoraDCreatAnimation("petLevelUpBottom", self.bottomNode, false)
	end
	if self.et_upgrade_node then
		SoraDResetEffectNode(self.et_upgrade_node)
	else
		_ENV, _ENV = self.et_upgrade_node, SoraDResetEffectNode
		self.et_upgrade_node.plist = "et_chongwusj_01.plist"
		_ENV, self.et_upgrade_node.scale = self.bottomNode, 1.51
		self.bottomNode.x = 0.0
		_ENV, SoraDResetEffectNode[1], self.et_upgrade_node.pos, self.bottomNode.y = self.et_upgrade_node, self.et_upgrade_node, self.bottomNode, -59
		_ENV, self.et_upgrade_node.plist = self.bottomNode, "et_chongwusj_02.plist"
		self.bottomNode.x = 4.236
		_ENV, self.et_upgrade_node.scale, self.bottomNode.y = self.bottomNode, self.bottomNode, 4.633
		self.bottomNode.x = 0
		_ENV, SoraDResetEffectNode[2], self.et_upgrade_node.pos, self.bottomNode.y = self.et_upgrade_node, self.et_upgrade_node, self.bottomNode, -80
		_ENV, self.et_upgrade_node.plist = self.bottomNode, "et_chongwusj_03.plist"
		self.bottomNode.x = 0.71
		_ENV, self.et_upgrade_node.scale, self.bottomNode.y = self.bottomNode, self.bottomNode, 1.73
		self.bottomNode.x = 1
		_ENV, SoraDResetEffectNode[3], self.et_upgrade_node.pos, self.bottomNode.y = self.et_upgrade_node, self.et_upgrade_node, self.bottomNode, 48
		self.et_upgrade_node.plist = "et_jzsj_06.plist"
		_ENV, self.et_upgrade_node.scale = self.bottomNode, 2.62
		self.bottomNode.x = -6
		SoraDResetEffectNode[4], self.et_upgrade_node.pos, self.bottomNode.y = self.et_upgrade_node, self.bottomNode, 23
		local param2 = SoraDResetEffectNode
		local et_node_2 = SoraDCreateEffectNode(param2)
		et_node_2:setPosition(cc.p(0, 50 - self.touchPanel:getContentSize().height / 2))
		et_node_2:addTo(self, 1)
		self.et_upgrade_node = et_node_2
	end
	if needAction then
		self:touchAction()
	end
	return
end
function PetShowSingle:showEagleAction(size)
	self.touchPanel:setVisible(false)
	math.randomseed(tostring(os.time()):reverse():sub(1, 6) * math.random())
	local scrollSize = size
	local middleX = size.width / 3
	local middleW = middleX
	local minScale = 0.25
	local maxScale = 0.5
	local speed = 30
	local starScale = minScale + (maxScale - minScale) * math.random()
	local starPos = cc.p(scrollSize.width + 100, math.random(0, scrollSize.height))
	local middleScale = minScale + (maxScale - minScale) * math.random()
	local middlePos = cc.p(middleX + math.random(0, middleW), math.random(0, scrollSize.height))
	local endScale = minScale + (maxScale - minScale) * math.random()
	local endPos = cc.p(-100, math.random(0, scrollSize.height))
	local fightTimes = math.random(1, 20)
	local flyVector = self:getTag() == 1 and -1 or 1
	if flyVector < 0 then
		local tmpPos = starPos
		starPos = endPos
		endPos = tmpPos
		self:setTag(2)
	else
		self:setTag(1)
	end
	local _ENV, actionArray = self.setTag, self.setTag
	local fightArray
	if 19 <= fightTimes then
		fightArray, _ENV = 1, 1
		fightArray[#fightArray + 1] = cca.delay(speed / 2)
		fightArray[#fightArray + 1] = cca.callFunc(function(...)
			self:touchAction()
		end)
	end
	actionArray[#actionArray + 1] = cca.callFunc(function(...)
		local angle = 90 - SoraDGetAngleByPos(middlePos, starPos)
		self:setScale(starScale)
		self:setPosition(starPos)
		_ENV = starPos
		starPos.x = middlePos.y > starPos.y and -20 or 0
		starPos.y = -flyVector * 60
		starPos.z = angle
		self.petRootNode:setRotation3D(starPos)
	end)
	function _UPVALUE1_(...)
		local angle = 90 - SoraDGetAngleByPos(middlePos, starPos)
		self:setScale(starScale)
		self:setPosition(starPos)
		_ENV = starPos
		starPos.x = middlePos.y > starPos.y and -20 or 0
		starPos.y = -flyVector * 60
		starPos.z = angle
		self.petRootNode:setRotation3D(starPos)
	end
	;(function(...)
		local angle = 90 - SoraDGetAngleByPos(middlePos, starPos)
		self:setScale(starScale)
		self:setPosition(starPos)
		_ENV = starPos
		starPos.x = middlePos.y > starPos.y and -20 or 0
		starPos.y = -flyVector * 60
		starPos.z = angle
		self.petRootNode:setRotation3D(starPos)
	end)[1] = cca.moveTo(speed / 2, middlePos.x, middlePos.y)
	;(function(...)
		local angle = 90 - SoraDGetAngleByPos(middlePos, starPos)
		self:setScale(starScale)
		self:setPosition(starPos)
		_ENV = starPos
		starPos.x = middlePos.y > starPos.y and -20 or 0
		starPos.y = -flyVector * 60
		starPos.z = angle
		self.petRootNode:setRotation3D(starPos)
	end)[2] = cca.scaleTo(speed / 2, middleScale, middleScale)
	;(function(...)
		local angle = 90 - SoraDGetAngleByPos(middlePos, starPos)
		self:setScale(starScale)
		self:setPosition(starPos)
		_ENV = starPos
		starPos.x = middlePos.y > starPos.y and -20 or 0
		starPos.y = -flyVector * 60
		starPos.z = angle
		self.petRootNode:setRotation3D(starPos)
	end)[3] = cca.scaleTo(speed / 2, middleScale, middleScale)
	;(function(...)
		local angle = 90 - SoraDGetAngleByPos(middlePos, starPos)
		self:setScale(starScale)
		self:setPosition(starPos)
		_ENV = starPos
		starPos.x = middlePos.y > starPos.y and -20 or 0
		starPos.y = -flyVector * 60
		starPos.z = angle
		self.petRootNode:setRotation3D(starPos)
	end)[4] = cca.scaleTo(speed / 2, middleScale, middleScale)
	;(function(...)
		local angle = 90 - SoraDGetAngleByPos(middlePos, starPos)
		self:setScale(starScale)
		self:setPosition(starPos)
		_ENV = starPos
		starPos.x = middlePos.y > starPos.y and -20 or 0
		starPos.y = -flyVector * 60
		starPos.z = angle
		self.petRootNode:setRotation3D(starPos)
	end)[5] = cca.scaleTo(speed / 2, middleScale, middleScale)
	actionArray[#actionArray + 1] = cca.spawn(function(...)
		local angle = 90 - SoraDGetAngleByPos(middlePos, starPos)
		self:setScale(starScale)
		self:setPosition(starPos)
		_ENV = starPos
		starPos.x = middlePos.y > starPos.y and -20 or 0
		starPos.y = -flyVector * 60
		starPos.z = angle
		self.petRootNode:setRotation3D(starPos)
	end)
	actionArray[#actionArray + 1] = cca.callFunc(function(...)
		local angle = 90 - SoraDGetAngleByPos(endPos, middlePos)
		_ENV = nil
		;(nil).x = endPos.y > middlePos.y and -20 or 0
		;(nil).y = -flyVector * 60
		;(nil).z = angle
		self.petRootNode:setRotation3D(nil)
	end)
	function _UPVALUE1_(...)
		local angle = 90 - SoraDGetAngleByPos(endPos, middlePos)
		_ENV = nil
		;(nil).x = endPos.y > middlePos.y and -20 or 0
		;(nil).y = -flyVector * 60
		;(nil).z = angle
		self.petRootNode:setRotation3D(nil)
	end
	;(function(...)
		local angle = 90 - SoraDGetAngleByPos(endPos, middlePos)
		_ENV = nil
		;(nil).x = endPos.y > middlePos.y and -20 or 0
		;(nil).y = -flyVector * 60
		;(nil).z = angle
		self.petRootNode:setRotation3D(nil)
	end)[1] = cca.moveTo(speed / 2, endPos.x, endPos.y)
	;(function(...)
		local angle = 90 - SoraDGetAngleByPos(endPos, middlePos)
		_ENV = nil
		;(nil).x = endPos.y > middlePos.y and -20 or 0
		;(nil).y = -flyVector * 60
		;(nil).z = angle
		self.petRootNode:setRotation3D(nil)
	end)[2] = cca.scaleTo(speed / 2, endScale, endScale)
	;(function(...)
		local angle = 90 - SoraDGetAngleByPos(endPos, middlePos)
		_ENV = nil
		;(nil).x = endPos.y > middlePos.y and -20 or 0
		;(nil).y = -flyVector * 60
		;(nil).z = angle
		self.petRootNode:setRotation3D(nil)
	end)[3] = cca.scaleTo(speed / 2, endScale, endScale)
	;(function(...)
		local angle = 90 - SoraDGetAngleByPos(endPos, middlePos)
		_ENV = nil
		;(nil).x = endPos.y > middlePos.y and -20 or 0
		;(nil).y = -flyVector * 60
		;(nil).z = angle
		self.petRootNode:setRotation3D(nil)
	end)[4] = cca.scaleTo(speed / 2, endScale, endScale)
	;(function(...)
		local angle = 90 - SoraDGetAngleByPos(endPos, middlePos)
		_ENV = nil
		;(nil).x = endPos.y > middlePos.y and -20 or 0
		;(nil).y = -flyVector * 60
		;(nil).z = angle
		self.petRootNode:setRotation3D(nil)
	end)[5] = cca.scaleTo(speed / 2, endScale, endScale)
	actionArray[#actionArray + 1] = cca.spawn(function(...)
		local angle = 90 - SoraDGetAngleByPos(endPos, middlePos)
		_ENV = nil
		;(nil).x = endPos.y > middlePos.y and -20 or 0
		;(nil).y = -flyVector * 60
		;(nil).z = angle
		self.petRootNode:setRotation3D(nil)
	end)
	actionArray[#actionArray + 1] = cca.callFunc(function(...)
		self:showEagleAction(size)
	end)
	self:runAction(cca.seq(actionArray))
	if fightArray then
		self:runAction(cca.seq(fightArray))
	end
end
function PetShowSingle:setSpriteRelativeScale(relativeScale, deltaH)
	print("setSpriteRelativeScale = ", relativeScale, deltaH)
	if self.sprite3DAnimal == nil then
		print("没找到---")
		return
	end
	deltaH = deltaH or 0
	local scale
	if self.inView and self.petCfg.scaleView then
		scale = self.petCfg.scaleView
	elseif self.petCfg.scale then
		scale = self.petCfg.scale
	else
		scale = ANIMAL_SCALE
	end
	print("最终比例 = ", scale * relativeScale)
	self.sprite3DAnimal:setScale(scale * relativeScale)
end
function PetShowSingle:setTouchPanelTouchEnabled(enabled)
	self.touchPanel:setTouchEnabled(enabled or false)
end
function PetShowSingle:setIsForceOrthographic(isForceOrthographic)
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
function PetShowSingle:getIsForceOrthographic()
	return self.isForceOrthographic
end
return PetShowSingle
