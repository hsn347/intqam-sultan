local _ENV, effectMainUITop
local mainUIDef = include("mainUIDef")
function effectMainUITop.luckyBlessShow(showType)
	local gametop = gModuleMgr.getObject("gametop")
	local luckyBlessCtrl = gametop.playertop_:getModule("luckyBlessCtrl")
	local node = display.newNode()
	node:setScale(0.6)
	local button = ccui.Button:create("bg_transparent.png", "bg_transparent.png", "bg_transparent.png", ccui.TextureResType.plistType)
	button:setContentSize(cc.size(110, 90))
	button:ignoreContentAdaptWithSize(false)
	button:addTouchEventListener(function(target, type)
		if type == ccui.TouchEventType.ended then
			SoraDPlaySound()
			if SoraDGetCastleLv() < CASTLE_LV6_LIMITED then
				_ENV = nil
				;(nil).num = CASTLE_LV6_LIMITED
				SoraDShowMsgTip(i18n("common_text_1795", nil))
			else
				uiManager:show("Activity_9001128_Main")
			end
		end
	end)
	button:addTo(node)
	local spriteBg = display.newSprite("#frame_recharge__sheer_time.png")
	spriteBg:setPosition(cc.p(0, -50))
	spriteBg:addTo(node, 5)
	spriteBg:setScaleX(0.6)
	local labelTime = ccui.Text:create("99:99:99", "", 20)
	labelTime:addTo(node, 5)
	labelTime:setColor(cc.c3b(196, 195, 157))
	labelTime:setPosition(cc.p(0, -50))
	_UPVALUE1_ = cc.p(0, -50)
	cc.p(0, -50)[1] = cca.callFunc(function()
		local time, actTime = luckyBlessCtrl:getRealTime()
		if 0 < showType then
			labelTime:setString(SoraDConvertSecondToString(time))
		else
			labelTime:setString(SoraDConvertSecondToString(actTime))
		end
	end)
	cc.p(0, -50)[2] = cca.delay(1)
	cc.p(0, -50)[3] = cca.delay(1)
	labelTime:runAction(cca.repeatForever(cca.seq(cc.p(0, -50))))
	local luckySpine = sp.SkeletonAnimation:create("spine/xingyunri.skel", "spine/xingyunri.atlas", 1)
	luckySpine:setPosition(cc.p(1.21, -70))
	luckySpine:addTo(node, 1)
	if luckyBlessCtrl:getCurEffectType() == gLuckyBlessActivityEffectType.BUILD_UPGRADE then
		luckySpine:setAnimation(0, "activation01", true)
	elseif luckyBlessCtrl:getCurEffectType() == gLuckyBlessActivityEffectType.TECHNOLOGY_RESEARCH then
		luckySpine:setAnimation(0, "activation02", true)
	elseif luckyBlessCtrl:getCurEffectType() == gLuckyBlessActivityEffectType.TRAIN_SOLDIERS then
		luckySpine:setAnimation(0, "activation03", true)
	elseif luckyBlessCtrl:getCurEffectType() == gLuckyBlessActivityEffectType.BUILD_STRENGTH then
		luckySpine:setAnimation(0, "activation04", true)
	else
		luckySpine:setAnimation(0, "activation01", true)
	end
	return node
end
function effectMainUITop.dispatchArmyEffect(hp)
	local hp = hp or 5
	local parent = display.getRunningScene()
	local mutiple = 0.5
	local parEffect = function()
		local beginPos = cc.p(display.cx, display.cy)
		local hpPos = cc.p(90, display.height)
		local effectNode = SoraDCreatAnimation("Node_Effect_tuiwei01", nil, false)
		effectNode:addTo(parent, 9)
		local sp_hp = SoraDGetChildByName(effectNode, "G_dh_Tex_XL_zlts02")
		sp_hp:setPosition(beginPos.x, beginPos.y)
		sp_hp:setVisible(true)
		local rotation = math.deg(math.atan((-hpPos.y + beginPos.y) / math.abs(-hpPos.x + beginPos.x))) + 180
		sp_hp:setRotation(rotation)
		parent = math.atan((-hpPos.y + beginPos.y) / math.abs(-hpPos.x + beginPos.x))
		math.atan((-hpPos.y + beginPos.y) / math.abs(-hpPos.x + beginPos.x))[1] = cca.delay(0.9)
		math.atan((-hpPos.y + beginPos.y) / math.abs(-hpPos.x + beginPos.x))[2] = cca.removeSelf()
		effectNode:runAction(cca.seq(math.atan((-hpPos.y + beginPos.y) / math.abs(-hpPos.x + beginPos.x))))
	end
	local phyNode = display.newNode()
	phyNode:setVisible(false)
	phyNode:setPosition(cc.p(display.cx, display.cy - 20))
	phyNode:addTo(parent, 9)
	local spritePhy = display.newSprite("#icon_lord_sp.png")
	spritePhy:addTo(phyNode)
	local labPhy = ccui.Text:create("-" .. hp, "", 24)
	labPhy:setAnchorPoint(cc.p(0, 0.5))
	labPhy:setColor(cc.c3b(255, 200, 100))
	labPhy:setPosition(cc.p(35, 0))
	labPhy:addTo(phyNode)
	_UPVALUE6_ = labPhy
	labPhy[1] = cca.callFunc(parEffect)
	labPhy[2] = cca.delay(1 * mutiple)
	labPhy[3] = cca.callFunc(function()
		phyNode:setVisible(true)
	end)
	labPhy[4] = cca.moveBy(1.2 * mutiple, 0, 120)
	labPhy[5] = cca.callFunc(function()
		spritePhy:runAction(cca.fadeOut(0.5 * mutiple))
		labPhy:runAction(cca.fadeOut(0.5 * mutiple))
	end)
	labPhy[6] = cca.delay(0.5 * mutiple)
	labPhy[7] = cca.callFunc(function()
		phyNode:removeFromParent()
	end)
	labPhy[8] = cca.callFunc(function()
		phyNode:removeFromParent()
	end)
	local seq = transition.sequence(labPhy)
	phyNode:runAction(seq)
end
function effectMainUITop.fullHPEffect()
	local parent = display.getRunningScene()
	local mutiple = 0.5
	local parSprite = display.newSprite("#et_green_jianti_attack_01.png")
	parSprite:setPosition(cc.p(display.cx, display.cy))
	local rotation = math.deg(math.tan((90 - display.cx) / (display.height - 145 - display.cy)))
	parSprite:setRotation(rotation - 90)
	parent:addChild(parSprite, 9)
	local frames = display.newFrames("et_green_jianti_attack_%.2d.png", 1, 9)
	local animation = display.newAnimation(frames, mutiple * 1.0 / 9)
	parSprite:playAnimationOnce(animation)
	_UPVALUE1_ = parSprite
	parSprite[1] = cca.moveTo(1 * mutiple, 90, display.height - 145)
	parSprite[2] = cca.callFunc(function()
		parSprite:removeFromParent()
	end)
	parSprite[3] = cca.callFunc(function()
		parSprite:removeFromParent()
	end)
	parSprite[4] = cca.callFunc(function()
		parSprite:removeFromParent()
	end)
	local seq = transition.sequence(parSprite)
	parSprite:runAction(seq)
end
function effectMainUITop.lordSkillTransresEffect()
	local parent = display.getRunningScene()
	local aniNode = SoraDCreatAnimationEx("Node_Effect_zyzh01", nil, false, 1, 0, 120)
	parent:addChild(aniNode, 9)
	aniNode:setPosition(cc.p(display.cx, display.cy))
	_UPVALUE1_ = aniNode
	aniNode[1] = cca.delay(2)
	aniNode[2] = cca.callFunc(function()
		aniNode:removeFromParent()
	end)
	aniNode[3] = cca.callFunc(function()
		aniNode:removeFromParent()
	end)
	aniNode[4] = cca.callFunc(function()
		aniNode:removeFromParent()
	end)
	local seq = transition.sequence(aniNode)
	aniNode:runAction(seq)
end
function effectMainUITop.combatantGift()
	local node = display.newNode()
	local btn_bg = display.newSprite("#icon_king_war_attender.png")
	btn_bg:addTo(node, 1)
	local dh = display.newSprite("#dh_cszlb_01.png")
	dh:addTo(node, 2)
	SoraDFadeINOUT(dh)
	_ENV, _ENV = dh, SoraDFadeINOUT
	_ENV, dh.plist = node, "et_cszlb_01.plist"
	node.x = -13
	dh.pos, node.y = node, -2
	SoraDFadeINOUT[1], dh.scale = dh, 3.35
	local param = SoraDFadeINOUT
	local et_node = SoraDCreateEffectNode(param)
	et_node:addTo(node, 3)
	return node
end
function effectMainUITop.warStartVSEffect(handle)
	local node = display.newNode()
	node:setPosition(cc.p(50, -35))
	node:setScale(1.5)
	local sprite_V = display.newSprite("#v.png")
	sprite_V:setAnchorPoint(cc.p(1, 0.5))
	sprite_V:setPosition(cc.p(-display.cx, 0))
	sprite_V:addTo(node)
	local sprite_S = display.newSprite("#s.png")
	sprite_S:setAnchorPoint(cc.p(0, 0.5))
	sprite_S:setPosition(cc.p(display.cx, 0))
	sprite_S:addTo(node)
	SoraDPlaySound("pyramidBattle", 1)
	local showEffect = function()
		_ENV, _ENV = nil, nil
		;(nil).plist = "et_sdVS_01.plist"
		_ENV, (nil)[1], (nil).scale = nil, nil, 2.57
		_ENV, (nil).plist = nil, "et_sdVS_02.plist"
		;(nil).x = 0.36
		;(nil).scale, (nil).y = nil, 5.12
		_ENV, (nil).rotate = nil, -90
		;(nil).x = 15
		_ENV, (nil)[2], (nil).pos, (nil).y = nil, nil, nil, -23
		_ENV, (nil).plist = nil, "et_sdVS_02.plist"
		;(nil).x = 0.45
		;(nil).scale, (nil).y = nil, 5.67
		_ENV, (nil).rotate = nil, 90
		;(nil).x = -30
		_ENV, (nil)[3], (nil).pos, (nil).y = nil, nil, nil, 12
		_ENV, (nil).plist = nil, "et_sdVS_03.plist"
		;(nil).x = 3
		_ENV, (nil)[4], (nil).pos, (nil).y = nil, nil, nil, -3
		;(nil).plist = "et_sdVS_04.plist"
		_ENV, (nil).rotate = nil, 90
		;(nil).x = 60
		_ENV, (nil)[5], (nil).pos, (nil).y = nil, nil, nil, -3
		;(nil).plist = "et_sdVS_04.plist"
		_ENV, (nil).rotate = nil, -90
		;(nil).x = -65
		_ENV, (nil)[6], (nil).pos, (nil).y = nil, nil, nil, -3
		_ENV, (nil).plist = nil, "et_sdVS_05.plist"
		;(nil).x = 2.3
		;(nil).scale, (nil).y = nil, 0.75
		_ENV, (nil).rotate = nil, -60.37
		;(nil).x = -6
		;(nil)[7], (nil).pos, (nil).y = nil, nil, -2.5
		local param
		local et_node = SoraDCreateEffectNode(param, nil, true)
		et_node:addTo(node)
	end
	local vAction = function()
		_UPVALUE4_ = nil
		;(nil)[1] = cca.moveBy(0.11666666666666667, 170, 0)
		;(nil)[2] = cca.moveBy(0.016666666666666666, 102, 0)
		;(nil)[3] = cca.moveBy(0.016666666666666666, 68, 0)
		;(nil)[4] = cca.moveBy(0.05, -5, 0)
		;(nil)[5] = cca.moveBy(0.1, 5, 0)
		;(nil)[6] = cca.moveBy(0.1, 5, 0)
		;(nil)[7] = cca.moveBy(0.1, 5, 0)
		;(nil)[8] = cca.moveBy(0.1, 5, 0)
		local seq = cca.seq(nil)
		sprite_V:runAction(seq)
	end
	local sAction = function()
		_UPVALUE4_ = nil
		;(nil)[1] = cca.moveBy(0.11666666666666667, -170, 0)
		;(nil)[2] = cca.moveBy(0.016666666666666666, -102, 0)
		;(nil)[3] = cca.moveBy(0.016666666666666666, -68, 0)
		;(nil)[4] = cca.moveBy(0.05, 5, 0)
		;(nil)[5] = cca.moveBy(0.1, -5, 0)
		;(nil)[6] = cca.moveBy(0.1, -5, 0)
		;(nil)[7] = cca.moveBy(0.1, -5, 0)
		;(nil)[8] = cca.moveBy(0.1, -5, 0)
		local seq = cca.seq(nil)
		sprite_S:runAction(seq)
	end
	_UPVALUE5_ = cc.p(display.cx, 0)
	cc.p(display.cx, 0)[1] = cca.callFunc(vAction)
	cc.p(display.cx, 0)[2] = cca.callFunc(sAction)
	cc.p(display.cx, 0)[3] = cca.delay(0.15)
	cc.p(display.cx, 0)[4] = cca.callFunc(showEffect)
	cc.p(display.cx, 0)[5] = cca.delay(1)
	cc.p(display.cx, 0)[6] = cca.callFunc(handle)
	cc.p(display.cx, 0)[7] = cca.callFunc(handle)
	local seq = cca.seq(cc.p(display.cx, 0))
	node:runAction(seq)
	return node
end
function effectMainUITop.showLordPhysicalEffect(target)
	local self = target
	local style = self.hpReduceStyle or 1
	local hp = self.hpReduceValue or 5
	local parent = display.getRunningScene().panelView
	local mutiple = 0.5
	if style == 1 then
		local parEffect = function()
			local beginPos = cc.p(display.cx, display.cy)
			local hpPos = cc.p(90, display.height)
			local effectNode = SoraDCreatAnimation("Node_Effect_tuiwei01", nil, false)
			effectNode:addTo(parent, 9)
			local sp_hp = SoraDGetChildByName(effectNode, "G_dh_Tex_XL_zlts02")
			sp_hp:setPosition(beginPos.x, beginPos.y)
			sp_hp:setVisible(true)
			local rotation = math.deg(math.atan((display.height - 145 - (display.cy - 20)) / (display.cx - 90))) + 90
			sp_hp:setRotation(rotation)
			parent = math.atan((display.height - 145 - (display.cy - 20)) / (display.cx - 90))
			math.atan((display.height - 145 - (display.cy - 20)) / (display.cx - 90))[1] = cca.delay(0.9)
			math.atan((display.height - 145 - (display.cy - 20)) / (display.cx - 90))[2] = cca.removeSelf()
			effectNode:runAction(cca.seq(math.atan((display.height - 145 - (display.cy - 20)) / (display.cx - 90))))
		end
		local phyNode = display.newNode()
		phyNode:setVisible(false)
		phyNode:setPosition(cc.p(display.cx, display.cy - 20))
		phyNode:addTo(parent, 9)
		local spritePhy = display.newSprite("#icon_lord_sp.png")
		spritePhy:addTo(phyNode)
		local labPhy = ccui.Text:create("-" .. hp, "", 24)
		labPhy:setAnchorPoint(cc.p(0, 0.5))
		labPhy:setColor(cc.c3b(255, 200, 100))
		labPhy:setPosition(cc.p(35, 0))
		labPhy:addTo(phyNode)
		_UPVALUE6_ = labPhy
		labPhy[1] = cca.callFunc(parEffect)
		labPhy[2] = cca.delay(1 * mutiple)
		labPhy[3] = cca.callFunc(function()
			phyNode:setVisible(true)
		end)
		labPhy[4] = cca.moveBy(1.2 * mutiple, 0, 120)
		labPhy[5] = cca.callFunc(function()
			spritePhy:runAction(cca.fadeOut(0.5 * mutiple))
			labPhy:runAction(cca.fadeOut(0.5 * mutiple))
		end)
		labPhy[6] = cca.delay(0.5 * mutiple)
		labPhy[7] = cca.callFunc(function()
			phyNode:removeFromParent()
			self.isUpdateHP = false
			self.isSetHPStyle = false
		end)
		labPhy[8] = cca.callFunc(function()
			phyNode:removeFromParent()
			self.isUpdateHP = false
			self.isSetHPStyle = false
		end)
		local seq = transition.sequence(labPhy)
		phyNode:runAction(seq)
	elseif style == 2 then
		local beginPos = cc.p(display.cx, display.cy + 150)
		local hpPos = cc.p(90, display.height - 110)
		local effectNode = SoraDCreatAnimation("Node_Effect_tuiwei01", nil, false)
		effectNode:addTo(parent, 9)
		local sp_hp = SoraDGetChildByName(effectNode, "G_dh_Tex_XL_zlts02")
		sp_hp:setPosition(hpPos.x, hpPos.y)
		sp_hp:setVisible(true)
		local rotation = math.deg(math.atan((hpPos.y - beginPos.y) / math.abs(hpPos.x - beginPos.x))) - 90
		sp_hp:setRotation(rotation)
		_UPVALUE1_ = math.atan((hpPos.y - beginPos.y) / math.abs(hpPos.x - beginPos.x))
		math.atan((hpPos.y - beginPos.y) / math.abs(hpPos.x - beginPos.x))[1] = cca.delay(0.9)
		math.atan((hpPos.y - beginPos.y) / math.abs(hpPos.x - beginPos.x))[2] = cca.callFunc(function()
			effectNode:removeFromParent()
			self.isUpdateHP = false
			self.isSetHPStyle = false
		end)
		math.atan((hpPos.y - beginPos.y) / math.abs(hpPos.x - beginPos.x))[3] = cca.callFunc(function()
			effectNode:removeFromParent()
			self.isUpdateHP = false
			self.isSetHPStyle = false
		end)
		math.atan((hpPos.y - beginPos.y) / math.abs(hpPos.x - beginPos.x))[4] = cca.callFunc(function()
			effectNode:removeFromParent()
			self.isUpdateHP = false
			self.isSetHPStyle = false
		end)
		math.atan((hpPos.y - beginPos.y) / math.abs(hpPos.x - beginPos.x))[5] = cca.callFunc(function()
			effectNode:removeFromParent()
			self.isUpdateHP = false
			self.isSetHPStyle = false
		end)
		effectNode:runAction(cca.seq(math.atan((hpPos.y - beginPos.y) / math.abs(hpPos.x - beginPos.x))))
	end
end
function effectMainUITop.showLordPowerEXPEffect(target, data)
	local self = target
	local addEXP = data.addEXP
	local addPower = data.addPower
	local powerShake = function()
		local mutiple = 1
		_UPVALUE9_ = nil
		;(nil)[1] = cca.scaleTo(0.3 * mutiple, 1.05)
		;(nil)[2] = cca.scaleTo(0.1 * mutiple, 1)
		;(nil)[3] = cca.scaleTo(0.2 * mutiple, 1.2)
		;(nil)[4] = cca.callFunc(function()
			SoraDCreateScoreLabel(self.labelPower, true):runScoreAnimation(self.oriPower, self.curPower, 1 * mutiple)
		end)
		;(nil)[5] = cca.scaleTo(0.1 * mutiple, 1.05)
		;(nil)[6] = cca.scaleTo(0.1 * mutiple, 1.2)
		;(nil)[7] = cca.scaleTo(0.1 * mutiple, 1.05)
		;(nil)[8] = cca.scaleTo(0.2 * mutiple, 1.2)
		;(nil)[9] = cca.scaleTo(0.5 * mutiple, 1)
		;(nil)[10] = cca.callFunc(function()
			self.oriPower = self.curPower
			self.oriEXP = self.curEXP
		end)
		;(nil)[11] = cca.callFunc(function()
			self.oriPower = self.curPower
			self.oriEXP = self.curEXP
		end)
		local seq = cca.seq(nil)
		self.imgPower:stopAllActions()
		self.imgPower:runAction(seq)
	end
	if not SoraDCurrentSceneShowView("mainCityView") then
		print("不在内城")
		powerShake()
		return
	end
	local mutiple = 0.5
	local parent = display.getRunningScene().panelView
	local show_node = parent:getChildByName("show_node")
	if show_node then
		show_node:stopAllActions()
		parent:removeChildByName("show_node", true)
	end
	local show_node = display.newNode()
	show_node:setPosition(cc.p(display.cx, display.cy + 150))
	show_node:setName("show_node")
	show_node:setScaleY(0)
	show_node:addTo(parent, 20)
	local beginPos = cc.p(show_node:getPositionX(), show_node:getPositionY())
	local bgSprite = display.newSprite("#frame_recharge__sheer_time.png")
	bgSprite:setScaleY(3.6)
	bgSprite:setScaleX(1.5)
	bgSprite:addTo(show_node)
	local node_power = display.newNode()
	node_power:setPosition(cc.p(0, -25))
	node_power:addTo(show_node, 1)
	local spritePower = display.newSprite("#icon_lord_power.png")
	spritePower:addTo(node_power, 2)
	_ENV = cc.p(0, -25)
	cc.p(0, -25).power = addPower
	local labPower = ccui.Text:create(i18n("common_text_917", cc.p(0, -25)), "", 22)
	labPower:setColor(cc.c3b(255, 255, 0))
	labPower:addTo(node_power, 2)
	SoraDToCenter(node_power, 10, SoraDFIsRA())
	local node_exp = display.newNode()
	node_exp:setPosition(cc.p(0, 25))
	node_exp:addTo(show_node, 1)
	local spriteExp = display.newSprite("#icon_lord_exp.png")
	spriteExp:setScale(1.2)
	spriteExp:addTo(node_exp, 2)
	_ENV = cc.p(0, 25)
	cc.p(0, 25).exp = addEXP
	local labExp = ccui.Text:create(i18n("common_text_918", cc.p(0, 25)), "", 22)
	labExp:setColor(cc.c3b(78, 205, 255))
	labExp:addTo(node_exp, 2)
	SoraDToCenter(node_exp, 10, SoraDFIsRA())
	local showEffect = function()
		if self.powerUp then
			self.powerUp = nil
		end
		self.powerUp = SoraDCreatAnimationEx("power_up", nil, false)
		self.powerUp:addTo(show_node, 2)
	end
	local showPowerEXPFly = function()
		local powerPos = cc.p(display.cx, display.height - 85)
		local expPos = cc.p(90, display.height - 110)
		local effectNode = SoraDCreatAnimation("Node_Effect_tuiwei01", nil, false)
		effectNode:addTo(parent, 9)
		local sp_power = SoraDGetChildByName(effectNode, "G_dh_Tex_XL_zlts01")
		sp_power:setVisible(true)
		sp_power:setPosition(powerPos.x, powerPos.y)
		local rotation = math.deg(math.atan((powerPos.y - beginPos.y) / math.abs(powerPos.x - beginPos.x))) - 90
		sp_power:setRotation(rotation)
		local sp_exp = SoraDGetChildByName(effectNode, "G_dh_Tex_XL_zlts03")
		sp_exp:setPosition(expPos.x, expPos.y)
		sp_exp:setVisible(true)
		local rotation = math.deg(math.atan((expPos.y - beginPos.y) / math.abs(expPos.x - beginPos.x))) - 90
		sp_exp:setRotation(rotation)
		parent = math.atan((expPos.y - beginPos.y) / math.abs(expPos.x - beginPos.x))
		math.atan((expPos.y - beginPos.y) / math.abs(expPos.x - beginPos.x))[1] = cca.delay(0.9)
		math.atan((expPos.y - beginPos.y) / math.abs(expPos.x - beginPos.x))[2] = cca.removeSelf()
		effectNode:runAction(cca.seq(math.atan((expPos.y - beginPos.y) / math.abs(expPos.x - beginPos.x))))
	end
	_UPVALUE8_ = SoraDFIsRA()
	SoraDFIsRA()[1] = cca.scaleTo(0.25, 1, 1)
	SoraDFIsRA()[2] = cca.delay(0.2)
	SoraDFIsRA()[3] = cca.callFunc(showEffect)
	SoraDFIsRA()[4] = cca.callFunc(showPowerEXPFly)
	SoraDFIsRA()[5] = cca.delay(0.5)
	SoraDFIsRA()[6] = cca.callFunc(powerShake)
	SoraDFIsRA()[7] = cca.scaleTo(0.25, 1, 0)
	SoraDFIsRA()[8] = cca.delay(0.5)
	SoraDFIsRA()[9] = cca.callFunc(function()
		self.isShowEXP = false
		parent:removeChildByName("show_node", true)
	end)
	SoraDFIsRA()[10] = cca.callFunc(function()
		self.isShowEXP = false
		parent:removeChildByName("show_node", true)
	end)
	local seq = cca.seq(SoraDFIsRA())
	show_node:runAction(seq)
end
function effectMainUITop.showLordEXPChange(target, data)
	local self = target
	local addEXP = data.addEXP
	local show_node = display.newNode()
	show_node:setPosition(cc.p(display.cx, display.cy + 120))
	show_node:setName("show_node_exp")
	show_node:setScaleY(0)
	local parent = display.getRunningScene().panelView
	show_node:addTo(parent, 999)
	local bgSprite = display.newSprite("#frame_recharge__sheer_time.png")
	bgSprite:setScaleY(1.8)
	bgSprite:setScaleX(1.5)
	bgSprite:addTo(show_node)
	local expNode = display.newNode()
	expNode:addTo(show_node, 1)
	local spriteEXP = display.newSprite("#icon_lord_exp.png")
	spriteEXP:addTo(expNode)
	_ENV = cc.p(display.cx, display.cy + 120)
	cc.p(display.cx, display.cy + 120).exp = addEXP
	local labEXP = ccui.Text:create(i18n("common_text_918", cc.p(display.cx, display.cy + 120)), "", 22)
	labEXP:setColor(cc.c3b(255, 255, 0))
	labEXP:addTo(expNode)
	SoraDToCenter(expNode, 10, SoraDFIsRA())
	local showEffect = function()
		if self.powerUp then
			self.powerUp = nil
		end
		self.powerUp = SoraDCreatAnimationEx("power_up", nil, false)
		self.powerUp:addTo(show_node, 2)
	end
	local showEXPFly = function()
		local beginPos = cc.p(show_node:getPositionX(), show_node:getPositionY())
		local expPos = cc.p(90, display.height - 110)
		local effectNode = SoraDCreatAnimation("Node_Effect_tuiwei01", nil, false)
		effectNode:addTo(parent, 9)
		local sp_exp = SoraDGetChildByName(effectNode, "G_dh_Tex_XL_zlts03")
		sp_exp:setPosition(expPos.x, expPos.y)
		sp_exp:setVisible(true)
		local rotation = math.deg(math.atan((expPos.y - beginPos.y) / math.abs(expPos.x - beginPos.x))) - 90
		sp_exp:setRotation(rotation)
		show_node = math.atan((expPos.y - beginPos.y) / math.abs(expPos.x - beginPos.x))
		math.atan((expPos.y - beginPos.y) / math.abs(expPos.x - beginPos.x))[1] = cca.delay(0.9)
		math.atan((expPos.y - beginPos.y) / math.abs(expPos.x - beginPos.x))[2] = cca.removeSelf()
		effectNode:runAction(cca.seq(math.atan((expPos.y - beginPos.y) / math.abs(expPos.x - beginPos.x))))
	end
	_UPVALUE7_ = SoraDFIsRA()
	SoraDFIsRA()[1] = cca.scaleTo(0.25, 1, 1)
	SoraDFIsRA()[2] = cca.delay(0.2)
	SoraDFIsRA()[3] = cca.callFunc(showEffect)
	SoraDFIsRA()[4] = cca.delay(0.5)
	SoraDFIsRA()[5] = cca.callFunc(showEXPFly)
	SoraDFIsRA()[6] = cca.delay(1.2)
	SoraDFIsRA()[7] = cca.scaleTo(0.25, 1, 0)
	SoraDFIsRA()[8] = cca.callFunc(function()
		self.oriEXP = self.curEXP
		parent:removeChildByName("show_node_exp", true)
	end)
	SoraDFIsRA()[9] = cca.callFunc(function()
		self.oriEXP = self.curEXP
		parent:removeChildByName("show_node_exp", true)
	end)
	SoraDFIsRA()[10] = cca.callFunc(function()
		self.oriEXP = self.curEXP
		parent:removeChildByName("show_node_exp", true)
	end)
	local seq = cca.seq(SoraDFIsRA())
	show_node:runAction(seq)
end
function effectMainUITop.showLordPowerChange(target, data)
	local self = target
	local oriPower = self.oriPower
	local curPower = self.curPower
	if curPower == oriPower then
		return
	end
	local powerShake = function()
		local mutiple = 1
		_UPVALUE8_ = nil
		;(nil)[1] = cca.scaleTo(0.3 * mutiple, 1.05)
		;(nil)[2] = cca.scaleTo(0.1 * mutiple, 1)
		;(nil)[3] = cca.scaleTo(0.2 * mutiple, 1.2)
		;(nil)[4] = cca.callFunc(function()
			SoraDCreateScoreLabel(self.labelPower, true):runScoreAnimation(oriPower, curPower, 1 * mutiple)
		end)
		;(nil)[5] = cca.scaleTo(0.1 * mutiple, 1.05)
		;(nil)[6] = cca.scaleTo(0.1 * mutiple, 1.2)
		;(nil)[7] = cca.scaleTo(0.1 * mutiple, 1.05)
		;(nil)[8] = cca.scaleTo(0.2 * mutiple, 1.2)
		;(nil)[9] = cca.scaleTo(0.3 * mutiple, 1)
		;(nil)[10] = cca.scaleTo(0.3 * mutiple, 1)
		;(nil)[11] = cca.scaleTo(0.3 * mutiple, 1)
		local seq = cca.seq(nil)
		self.imgPower:stopAllActions()
		self.imgPower:runAction(seq)
	end
	local centerShine = function()
		if not SoraDCurrentSceneShowView("mainCityView") and not SoraDCurrentTopPanelFromManager() then
			return
		end
		local show_node = display.newNode()
		show_node:setPosition(cc.p(display.cx, display.cy + 120))
		show_node:setName("show_node_power")
		show_node:setScaleY(0)
		local parent = display.getRunningScene().panelView
		show_node:addTo(parent, 999)
		local bgSprite = display.newSprite("#frame_recharge__sheer_time.png")
		bgSprite:setScaleY(1.8)
		bgSprite:setScaleX(1.5)
		bgSprite:addTo(show_node)
		local powerNode = display.newNode()
		powerNode:addTo(show_node, 1)
		local spritePower = display.newSprite("#icon_lord_power.png")
		spritePower:addTo(powerNode)
		local changePower = curPower - oriPower
		local str = changePower
		if 0 < changePower then
			str = "+" .. changePower
		end
		_ENV = cc.p(display.cx, display.cy + 120)
		cc.p(display.cx, display.cy + 120).power = str
		local labPower = ccui.Text:create(i18n("common_text_1418", cc.p(display.cx, display.cy + 120)), "", 22)
		labPower:setColor(cc.c3b(255, 255, 0))
		labPower:addTo(powerNode)
		SoraDToCenter(powerNode, 10, SoraDFIsRA())
		local showEffect = function()
			if self.powerUp then
				self.powerUp = nil
			end
			self.powerUp = SoraDCreatAnimationEx("power_up", nil, false)
			self.powerUp:addTo(show_node, 2)
		end
		_UPVALUE5_ = 10
		;(10)[1] = cca.scaleTo(0.25, 1, 1)
		;(10)[2] = cca.delay(0.2)
		;(10)[3] = cca.callFunc(showEffect)
		;(10)[4] = cca.delay(1.2)
		;(10)[5] = cca.scaleTo(0.25, 1, 0)
		;(10)[6] = cca.callFunc(function()
			parent:removeChildByName("show_node_power", true)
		end)
		;(10)[7] = cca.callFunc(function()
			parent:removeChildByName("show_node_power", true)
		end)
		;(10)[8] = cca.callFunc(function()
			parent:removeChildByName("show_node_power", true)
		end)
		local seq = cca.seq(10)
		show_node:runAction(seq)
	end
	_UPVALUE2_ = nil
	;(nil)[1] = cca.callFunc(centerShine)
	;(nil)[2] = cca.delay(0.5)
	;(nil)[3] = cca.callFunc(powerShake)
	;(nil)[4] = cca.callFunc(powerShake)
	local seq = cca.seq(nil)
	self:runAction(seq)
end
function effectMainUITop.luckyRecharge()
	local button = ccui.Button:create("bg_transparent.png", "bg_transparent.png", "bg_transparent.png", ccui.TextureResType.plistType)
	button:setContentSize(cc.size(60, 52))
	button:ignoreContentAdaptWithSize(false)
	local btn_bg = display.newSprite("#icon_main_luckyrecharge.png")
	btn_bg:addTo(button, 1)
	btn_bg:setPosition(cc.p(button:getContentSize().width / 2, button:getContentSize().height / 2))
	button.btn_bg = btn_bg
	local yes = display.newSprite("#icon_yes.png")
	yes:addTo(button, 30)
	yes:setPosition(cc.p(40, 10))
	button.img_yes = yes
	local black = display.newSprite("#frame_sheer_black_01.png")
	black:addTo(button, 2)
	black:setPosition(cc.p(30, 10))
	black:setScale(0.14285714285714285, 0.5882352941176471)
	button.img_black = black
	local label = ccui.Text:create("$499.99", "", 20)
	label:setScale(0.8)
	label:addTo(button, 5)
	label:setColor(cc.c3b(0, 190, 30))
	label:setPosition(cc.p(30, 10))
	button.lab_target = label
	return button
end
function effectMainUITop.goldPackage()
	local button = ccui.Button:create("bg_transparent.png", "bg_transparent.png", "bg_transparent.png", ccui.TextureResType.plistType)
	button:setContentSize(cc.size(60, 52))
	button:ignoreContentAdaptWithSize(false)
	local btn_bg = display.newSprite("#icon_activity_gold_gift2.png")
	btn_bg:addTo(button, 1)
	btn_bg:setPosition(cc.p(button:getContentSize().width / 2, button:getContentSize().height / 2))
	button.btn_bg = btn_bg
	return button
end
function effectMainUITop.communityCenter(info)
	local id = info.param.show
	_ENV = nil
	;(nil)[gActivityCenterUIEnum.COMMUNITY_CENTER_1] = "#btn_scommunity_center_facebook.png"
	;(nil)[gActivityCenterUIEnum.COMMUNITY_CENTER_2] = "#btn_scommunity_center_instagram.png"
	;(nil)[gActivityCenterUIEnum.COMMUNITY_CENTER_3] = "#btn_scommunity_center_twitter.png"
	;(nil)[gActivityCenterUIEnum.COMMUNITY_CENTER_4] = "#btn_scommunity_center_community.png"
	;(nil)[gActivityCenterUIEnum.COMMUNITY_CENTER_5] = "#btn_scommunity_center_live.png"
	local (nil)[gActivityCenterUIEnum.COMMUNITY_CENTER_6], uiEnumBg = "#btn_scommunity_center_live.png", nil
	local button = ccui.Button:create("bg_transparent.png", "bg_transparent.png", "bg_transparent.png", ccui.TextureResType.plistType)
	button:setContentSize(cc.size(60, 52))
	button:ignoreContentAdaptWithSize(false)
	local btn_bg = display.newSprite(uiEnumBg[id])
	btn_bg:addTo(button, 1)
	btn_bg:setPosition(cc.p(button:getContentSize().width / 2, button:getContentSize().height / 2))
	button.btn_bg = btn_bg
	if info.param.type == 1 then
		local labelTime = ccui.Text:create("99:99:99", "", 16)
		labelTime:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
		labelTime:setAnchorPoint(0.5, 0.5)
		labelTime:addTo(button, 5)
		labelTime:setColor(cc.c3b(255, 255, 255))
		labelTime:setPosition(cc.p(30, -15))
		SoraDSetTextWidthHeight(labelTime, cc.size(90, 60))
		_UPVALUE1_ = cc.size(90, 60)
		cc.size(90, 60)[1] = cca.callFunc(function()
			local time = info.endtime - serviceFunctions.systemTime()
			labelTime:setString(SoraDConvertSecondToString(time))
		end)
		cc.size(90, 60)[2] = cca.delay(1)
		cc.size(90, 60)[3] = cca.delay(1)
		labelTime:runAction(cca.repeatForever(cca.seq(cc.size(90, 60))))
	end
	return button
end
function effectMainUITop.questionnaire(num)
	local button = ccui.Button:create("bg_transparent.png", "bg_transparent.png", "bg_transparent.png", ccui.TextureResType.plistType)
	button:setContentSize(cc.size(60, 52))
	button:ignoreContentAdaptWithSize(false)
	local btn_bg = display.newSprite("#icon_wjdc_questionnairet.png")
	btn_bg:addTo(button)
	btn_bg:setScale(0.53)
	btn_bg:setPosition(cc.p(button:getContentSize().width / 2, button:getContentSize().height / 2))
	button.btn_bg = btn_bg
	local redIcon = display.newSprite("#icon_xiaobiao_red.png")
	redIcon:addTo(button)
	redIcon:setScale(0.5)
	redIcon:setPosition(50, 50)
	if 1 < num then
		local textNum = ccui.Text:create(num, "", 20)
		textNum:addTo(button)
		textNum:setPosition(50, 50)
	end
	return button
end
function effectMainUITop.createLostRuinsBtn(num)
	local button = effectMainUITop.createCommonBtn("#btn_common_record.png", num)
	local labelName = ccui.Text:create(i18n("lost_ruins_text_23"), "", 20)
	labelName:addTo(button)
	labelName:setPosition(cc.p(30, 0))
	labelName:setScale(0.8)
	SoraDSetTextWidthHeight(labelName, cc.size(80, 30))
	button.labelName = labelName
	button.redIcon:setVisible(0 < num)
	if button.btn_bg then
		button.btn_bg:setScale(63 / button.btn_bg:getContentSize().width)
	end
	effectMainUITop = 63 / button.btn_bg:getContentSize().width
	;(63 / button.btn_bg:getContentSize().width).byUID = true
	if not SoraDConfigGet("Game:lostRuinsMainView:firstFinger~bool", 63 / button.btn_bg:getContentSize().width) then
		button.fingerNode = SoraDFingerAction(true)
		button.fingerNode:setScale(0.7)
		button.fingerNode:addTo(button)
		button.fingerNode:setPosition(20, 10)
		effectMainUITop = 10
		;(10).byUID = true
		SoraDConfigSet("Game:lostRuinsMainView:firstFinger~bool", true, 10)
	end
	return button
end
function effectMainUITop.createWindTowerBtn(num)
	local button = effectMainUITop.createCommonBtn("#btn_common_record.png", num)
	local labelName = ccui.Text:create(i18n("lost_ruins_text_23"), "", 20)
	labelName:addTo(button)
	labelName:setPosition(cc.p(30, 0))
	labelName:setScale(0.8)
	SoraDSetTextWidthHeight(labelName, cc.size(80, 30))
	button.labelName = labelName
	button.redIcon:setVisible(0 < num)
	if button.btn_bg then
		button.btn_bg:setScale(63 / button.btn_bg:getContentSize().width)
	end
	effectMainUITop = 63 / button.btn_bg:getContentSize().width
	;(63 / button.btn_bg:getContentSize().width).byUID = true
	if not SoraDConfigGet("Game:windTowerActivity:firstFinger~bool", 63 / button.btn_bg:getContentSize().width) then
		button.fingerNode = SoraDFingerAction(true)
		button.fingerNode:setScale(0.7)
		button.fingerNode:addTo(button)
		button.fingerNode:setPosition(20, 10)
		effectMainUITop = 10
		;(10).byUID = true
		SoraDConfigSet("Game:windTowerActivity:firstFinger~bool", true, 10)
	end
	return button
end
function effectMainUITop.createSnowWolfLostBtn(num)
	local button = effectMainUITop.createCommonBtn("#btn_common_record.png", num)
	local labelName = ccui.Text:create(i18n("lost_ruins_text_23"), "", 20)
	labelName:addTo(button)
	labelName:setPosition(cc.p(30, 0))
	labelName:setScale(0.8)
	SoraDSetTextWidthHeight(labelName, cc.size(80, 30))
	button.labelName = labelName
	button.redIcon:setVisible(0 < num)
	if button.btn_bg then
		button.btn_bg:setScale(63 / button.btn_bg:getContentSize().width)
	end
	effectMainUITop = 63 / button.btn_bg:getContentSize().width
	;(63 / button.btn_bg:getContentSize().width).byUID = true
	if not SoraDConfigGet("Game:snowWolfLostActivity:firstFinger~bool", 63 / button.btn_bg:getContentSize().width) then
		button.fingerNode = SoraDFingerAction(true)
		button.fingerNode:setScale(0.7)
		button.fingerNode:addTo(button)
		button.fingerNode:setPosition(20, 10)
		effectMainUITop = 10
		;(10).byUID = true
		SoraDConfigSet("Game:snowWolfLostActivity:firstFinger~bool", true, 10)
	end
	return button
end
function effectMainUITop.createCrazyTrioBtn(num)
	local button = effectMainUITop.createCommonBtn("#btn_main_new_recharge_hero.png", math.min(1, num))
	button.redIcon:setVisible(0 < num)
	if button.btn_bg then
		button.btn_bg:setScale(63 / button.btn_bg:getContentSize().width)
	end
	effectMainUITop = 63 / button.btn_bg:getContentSize().width
	;(63 / button.btn_bg:getContentSize().width).byUID = true
	if not SoraDConfigGet("Game:eventCrazyTrioNew:firstFinger~bool", 63 / button.btn_bg:getContentSize().width) then
		button.fingerNode = SoraDFingerAction(nil, nil, nil, true)
		button.fingerNode:setScale(0.7)
		button.fingerNode:addTo(button)
		button.fingerNode:setPosition(30, 26)
		effectMainUITop = 26
		;(26).byUID = true
		SoraDConfigSet("Game:eventCrazyTrioNew:firstFinger~bool", true, 26)
	end
	return button
end
function effectMainUITop.createCommonBtn(icon, num)
	local button = ccui.Button:create("bg_transparent.png", "bg_transparent.png", "bg_transparent.png", ccui.TextureResType.plistType)
	button:setContentSize(cc.size(60, 52))
	button:ignoreContentAdaptWithSize(false)
	local btn_bg = display.newSprite(icon)
	btn_bg:addTo(button)
	btn_bg:setPosition(cc.p(button:getContentSize().width / 2, button:getContentSize().height / 2))
	button.btn_bg = btn_bg
	local redIcon = display.newSprite("#icon_xiaobiao_red.png")
	redIcon:addTo(button)
	redIcon:setScale(0.5)
	redIcon:setPosition(50, 50)
	button.redIcon = redIcon
	num = num or 0
	if 1 < num then
		local textNum = ccui.Text:create(num, "", 20)
		textNum:addTo(button)
		textNum:setPosition(50, 50)
	end
	return button
end
function effectMainUITop.iranDownloadIcon()
	local button = ccui.Button:create("bg_transparent.png", "bg_transparent.png", "bg_transparent.png", ccui.TextureResType.plistType)
	button:setContentSize(cc.size(60, 52))
	button:ignoreContentAdaptWithSize(false)
	local btn_bg = display.newSprite("#Icon_Irandownload.png")
	btn_bg:addTo(button, 2)
	btn_bg:setPosition(cc.p(30, 30))
	button.btn_bg = btn_bg
	local black = display.newSprite("#frame_main_common.png")
	black:addTo(button)
	black:setPosition(cc.p(button:getContentSize().width / 2, button:getContentSize().height / 2))
	button.img_black = black
	return button
end
function effectMainUITop.enjoyLotteryBtn()
	local button = ccui.Button:create("bg_transparent.png", "bg_transparent.png", "bg_transparent.png", ccui.TextureResType.plistType)
	button:setContentSize(cc.size(60, 52))
	button:ignoreContentAdaptWithSize(false)
	local btn_bg = display.newSprite("#icon_main_enjoylottery.png")
	btn_bg:addTo(button, 1)
	btn_bg:setPosition(cc.p(button:getContentSize().width / 2, button:getContentSize().height / 2))
	_ENV, _ENV = btn_bg, btn_bg.setPosition
	_ENV, btn_bg.plist = cc.p(button:getContentSize().width / 2, button:getContentSize().height / 2)
	cc.p(button:getContentSize().width / 2, button:getContentSize().height / 2).x = 9
	btn_bg.pos, cc.p(button:getContentSize().width / 2, button:getContentSize().height / 2).y = cc.p(button:getContentSize().width / 2, button:getContentSize().height / 2)
	_ENV, btn_bg.setPosition[1], btn_bg.scale = btn_bg, btn_bg, 1.2
	_ENV, btn_bg.plist = cc.p(button:getContentSize().width / 2, button:getContentSize().height / 2)
	cc.p(button:getContentSize().width / 2, button:getContentSize().height / 2).x = 6
	btn_bg.pos, cc.p(button:getContentSize().width / 2, button:getContentSize().height / 2).y = cc.p(button:getContentSize().width / 2, button:getContentSize().height / 2)
	btn_bg.setPosition[2], btn_bg.scale = btn_bg, 1.2
	local param = btn_bg.setPosition
	local et_node = SoraDCreateEffectNode(param)
	et_node:addTo(button, 2)
	et_node:setPosition(cc.p(20, -10))
	return button
end
function effectMainUITop.thanksGivingPartyBtn()
	local button = effectMainUITop.createCommonBtn("#icon_gnsrh_5th2.png")
	if button.redIcon then
		button.redIcon:setVisible(false)
	end
	if button.btn_bg then
		button.btn_bg:setScale(63 / button.btn_bg:getContentSize().width)
	end
	local labelTime = ccui.Text:create("99:99:99", "", 20)
	local labelTime = SoraDCreateTimerLabel(nil, labelTime)
	labelTime:addTo(button)
	labelTime:setPosition(cc.p(30, 0))
	labelTime:setScale(0.8)
	SoraDSetTextWidthHeight(labelTime, cc.size(80, 30))
	button.labelTime = labelTime
	return button
end
function effectMainUITop.togetherTeamBtn()
	local button = effectMainUITop.createCommonBtn("#icon_together_invite.png")
	if button.redIcon then
	end
	if button.btn_bg then
		button.btn_bg:setScale(63 / button.btn_bg:getContentSize().width)
	end
	local labelTime = ccui.Text:create("99:99:99", "", 20)
	local labelTime = SoraDCreateTimerLabel(nil, labelTime)
	labelTime:addTo(button)
	labelTime:setPosition(cc.p(30, 0))
	labelTime:setScale(0.8)
	SoraDSetTextWidthHeight(labelTime, cc.size(80, 30))
	button.labelTime = labelTime
	return button
end
function effectMainUITop.harvestSeason()
	local button = effectMainUITop.createCommonBtn("#icon_together_invite.png")
	if button.btn_bg then
		button.btn_bg:setScale(63 / button.btn_bg:getContentSize().width)
	end
	local labelTime = ccui.Text:create("xxd 99:99:99", "", 20)
	local labelTime = SoraDCreateTimerLabel(nil, labelTime)
	labelTime:addTo(button)
	labelTime:setPosition(cc.p(30, 0))
	labelTime:setScale(0.8)
	SoraDSetTextWidthHeight(labelTime, cc.size(80, 30))
	button.labelTime = labelTime
	return button
end
return effectMainUITop
