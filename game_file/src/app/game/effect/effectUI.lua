local _ENV, effectUI
function effectUI.createFrameAnimation(target, param)
	if not target then
		return
	end
	local _ENV, param = nil, param or nil
	local imgFormat = param.imgFormat
	local imgBIndex = param.imgBIndex or 1
	local imgEIndex = param.imgEIndex
	local frameTime = param.frameTime or 1.2
	local isLoop = param.isLoop or true
	local delay = param.delay or 0
	local frames = display.newFrames(imgFormat, imgBIndex, imgEIndex)
	local animation = display.newAnimation(frames, frameTime / #frames)
	target:stopAllActions()
	if isLoop then
		target:playAnimationForever(animation, delay)
	else
		target:playAnimationOnce(animation)
	end
end
function effectUI.showWaggleEffect(target, isLoop, offset)
	if not target then
		return
	end
	target:stopAllActions()
	local baseScale = target:getScale()
	local isLoop = isLoop ~= false and true or false
	local offset = offset or 0.2
	_UPVALUE8_ = nil
	;(nil)[1] = cca.scaleTo(0.25, baseScale + offset)
	;(nil)[2] = cca.scaleTo(0.3333333333333333, baseScale)
	;(nil)[3] = cca.rotateTo(0.25, 10)
	;(nil)[4] = cca.rotateTo(0.21666666666666667, -10)
	;(nil)[5] = cca.rotateTo(0.2, 8)
	;(nil)[6] = cca.rotateTo(0.16666666666666666, -5)
	;(nil)[7] = cca.rotateTo(0.15, 2)
	;(nil)[8] = cca.rotateTo(0.15, 0)
	;(nil)[9] = cca.delay(1.6666666666666667)
	;(nil)[10] = cca.delay(1.6666666666666667)
	local seq = cca.seq(nil)
	if isLoop then
		target:runAction(cc.RepeatForever:create(seq))
	else
		target:runAction(seq)
	end
end
function effectUI.getCoolSuqare()
	return SoraDCreatAnimation("animationCoolSuqare")
end
function effectUI.getItemEffect()
	_ENV, _ENV = nil, nil
	_ENV, (nil).plist = nil, "et_wupinbeijing_01.plist"
	;(nil).x = -3.4
	;(nil).pos, (nil).y = nil, -6.96
	_ENV, (nil)[1], (nil).scale = nil, nil, 3.58
	_ENV, (nil).plist = nil, "et_wupinbeijing_02.plist"
	;(nil).x = -1.85
	;(nil).pos, (nil).y = nil, -10.3
	_ENV, (nil)[2], (nil).scale = nil, nil, 2.67
	_ENV, (nil).plist = nil, "et_wupinbeijing_03.plist"
	;(nil).x = -2.44
	_ENV, (nil).pos, (nil).y = nil, nil, -11.72
	;(nil).x = 1.93
	;(nil).scale, (nil).y = nil, 1.9
	_ENV, _ENV, (nil)[3], (nil).rotate = nil, nil, nil, -29.55
	local bottomParam
	_ENV, (nil).plist = nil, "et_wupinbeijing_04.plist"
	;(nil).x = -7.05
	;(nil).pos, (nil).y = nil, -6.11
	;(nil)[1], (nil).scale = nil, 2.48
	local topParam
	local bottomNode = SoraDCreateEffectNode(bottomParam)
	local topNode = SoraDCreateEffectNode(topParam)
	return bottomNode, topNode
end
function effectUI.getWorldCupEffect(widget)
	local effectNode_0 = SoraDCreatAnimation("zhuwei_0")
	widget:addChild(effectNode_0)
	effectNode_0:setPosition(cc.p(display.width / 2, display.height))
	local createEffectNode = function()
		local effectNode = SoraDCreatAnimation("zhuwei_1")
		widget:getParent():addChild(effectNode, 9)
		effectNode:setPosition(cc.p(display.width / 2, display.height))
		widget = cc.p(display.width / 2, display.height)
		cc.p(display.width / 2, display.height)[1] = cca.delay(22.733333333333334)
		cc.p(display.width / 2, display.height)[2] = cca.callFunc(function()
			effectNode:removeFromParent()
		end)
		cc.p(display.width / 2, display.height)[3] = cca.callFunc(function()
			effectNode:removeFromParent()
		end)
		effectNode:runAction(cca.seq(cc.p(display.width / 2, display.height)))
	end
	_UPVALUE1_ = cc.p(display.width / 2, display.height)
	cc.p(display.width / 2, display.height)[1] = cca.callFunc(createEffectNode)
	cc.p(display.width / 2, display.height)[2] = cca.delay(16.0)
	cc.p(display.width / 2, display.height)[3] = cca.delay(16.0)
	cc.p(display.width / 2, display.height)[4] = cca.delay(16.0)
	local seq1 = cca.seq(cc.p(display.width / 2, display.height))
	effectNode_0:runAction(cc.RepeatForever:create(seq1))
	return effectNode_0
end
function effectUI.getWorldCupViewEffect(widget)
	local effectNode = SoraDCreatAnimation("zhuwei_1")
	widget:getParent():addChild(effectNode, 9)
	effectNode:setPosition(cc.p(display.width / 2, display.height))
	_UPVALUE1_ = cc.p(display.width / 2, display.height)
	cc.p(display.width / 2, display.height)[1] = cca.delay(4.5)
	cc.p(display.width / 2, display.height)[2] = cca.callFunc(function()
		effectNode:removeFromParent()
	end)
	cc.p(display.width / 2, display.height)[3] = cca.callFunc(function()
		effectNode:removeFromParent()
	end)
	effectNode:runAction(cca.seq(cc.p(display.width / 2, display.height)))
end
function effectUI.addWorldCupTouchEffect(widget, type)
	if type == ccui.TouchEventType.began then
		widget.isMoving = false
	elseif type == ccui.TouchEventType.moved then
		widget.isMoving = true
	elseif type == ccui.TouchEventType.ended then
		if widget.isMoving then
			return
		end
		local touchEndPoint = widget:getTouchEndPosition()
		local touchPos = widget:convertToNodeSpace(touchEndPoint)
		if widget.touch_et_node then
			SoraDResetEffectNode(widget.touch_et_node)
			widget.touch_et_node:setPosition(touchPos)
			return
		end
		_ENV, _ENV = widget.touch_et_node, widget.touch_et_node.setPosition
		widget.touch_et_node.plist = "et_shijiebeidianji_02.plist"
		widget.touch_et_node.setPosition[1], widget.touch_et_node.scale = widget.touch_et_node, 1.51
		local param = widget.touch_et_node.setPosition
		if not widget.touch_et_node then
			widget.touch_et_node = SoraDCreateEffectNode(param)
			widget.touch_et_node:setPosition(touchPos)
			widget.touch_et_node:addTo(widget, 1002)
		end
	end
end
function effectUI.addAllianceScienceContributeEffect(widget)
	local et_node = widget:getChildByName("particle_node")
	if et_node then
		SoraDResetEffectNode(et_node)
	else
		_ENV, _ENV = et_node, SoraDResetEffectNode
		et_node.plist = "et_lmjx_01.plist"
		_ENV, SoraDResetEffectNode[1], et_node.name = et_node, et_node, "lmjx_1"
		_ENV, et_node.plist = nil, "et_lmjx_02.plist"
		;(nil).x = 0
		et_node.pos, (nil).y = nil, -5
		_ENV, SoraDResetEffectNode[2], et_node.name = et_node, et_node, "lmjx_2"
		_ENV, et_node.plist = nil, "et_lmjx_03.plist"
		;(nil).x = 0
		_ENV, et_node.pos, (nil).y = nil, nil, -15
		;(nil).x = 1.6219
		et_node.scale, (nil).y = nil, 1.6219
		SoraDResetEffectNode[3], et_node.name = et_node, "lmjx_3"
		local param = SoraDResetEffectNode
		local particle_node = SoraDCreateEffectNode(param)
		particle_node:setPosition(cc.p(320, 600))
		particle_node:setName("particle_node")
		particle_node:addTo(widget, 2)
	end
end
function effectUI.addAllianceScienceRunDoubleAnimation(widget, bType)
	_ENV, _ENV = nil, nil
	;(nil).spriteName = "#icon_alliance_sciencepoint.png"
	_ENV, (nil)[1], (nil).posY = nil, nil, 6
	;(nil).spriteName = "#icon_alliance_honor.png"
	_UPVALUE2_, _ENV, (nil)[2], (nil).posY = nil, nil, nil, 0
	;(nil).spriteName, (nil)[1] = nil, "#icon_alliance_sciencepoint.png"
	;(nil).spriteName, (nil)[2] = nil, "#icon_alliance_honor.png"
	_ENV, (nil)[3], (nil).posY = nil, nil, 30
	;(nil).spriteName = "#icon_lmrfd_rqz.png"
	_ENV, (nil)[4], (nil).posY = nil, nil, 6
	;(nil).spriteName = "#icon_alliance_honor.png"
	_UPVALUE2_, _ENV, (nil)[5], (nil).posY = nil, nil, nil, 0
	;(nil).spriteName, (nil)[1] = nil, "#icon_lmrfd_rqz.png"
	;(nil).spriteName, (nil)[2] = nil, "#icon_alliance_honor.png"
	;(nil)[6], (nil).posY = nil, 30
	local effectAnimation
	local pos = 1
	local text = "2 X"
	if not SoraDFIsRA() then
		pos = -1
		text = "X 2"
	end
	if widget:getChildByName("action_node") then
		widget:removeChildByName("action_node", true)
	end
	local action_node = display.newNode()
	action_node:setPosition(cc.p(320, 600))
	action_node:setName("action_node")
	action_node:setScale(0.2)
	action_node:addTo(widget, 2)
	if type(effectAnimation[bType].spriteName) == "table" then
		local spriteDouble1 = display.newSprite(effectAnimation[bType].spriteName[1])
		spriteDouble1:setPosition(cc.p(40 * pos, effectAnimation[bType].posY))
		spriteDouble1:addTo(action_node, 2)
		local scale = 60 / spriteDouble1:getContentSize().height
		spriteDouble1:setScale(scale)
		local spriteDouble2 = display.newSprite(effectAnimation[bType].spriteName[2])
		spriteDouble2:setPosition(cc.p(40 * pos, -effectAnimation[bType].posY))
		spriteDouble2:addTo(action_node, 2)
		local scale = 60 / spriteDouble2:getContentSize().height
		spriteDouble2:setScale(scale)
		_ENV = spriteDouble2
		spriteDouble2.text = text
		spriteDouble2.font = "res/fonts/pve_fnt_title.fnt"
		spriteDouble2.align = cc.TEXT_ALIGNMENT_RIGHT
		spriteDouble2.x = -40 * pos
		spriteDouble2.y = effectAnimation[bType].posY
		local bnfontLab1 = display.newBMFontLabel(spriteDouble2)
		bnfontLab1:addTo(action_node)
		_ENV = bnfontLab1
		bnfontLab1.text = text
		bnfontLab1.font = "res/fonts/pve_fnt_title.fnt"
		bnfontLab1.align = cc.TEXT_ALIGNMENT_RIGHT
		bnfontLab1.x = -40 * pos
		bnfontLab1.y = -effectAnimation[bType].posY
		local bnfontLab2 = display.newBMFontLabel(bnfontLab1)
		bnfontLab2:addTo(action_node)
	else
		local spriteDouble = display.newSprite(effectAnimation[bType].spriteName)
		spriteDouble:setPosition(cc.p(40 * pos, effectAnimation[bType].posY))
		spriteDouble:addTo(action_node, 2)
		_ENV = spriteDouble
		spriteDouble.text = text
		spriteDouble.font = "res/fonts/pve_fnt_title.fnt"
		spriteDouble.align = cc.TEXT_ALIGNMENT_RIGHT
		spriteDouble.x = -40 * pos
		spriteDouble.y = 0
		local bnfontLab = display.newBMFontLabel(spriteDouble)
		bnfontLab:addTo(action_node)
	end
	_UPVALUE2_ = bnfontLab
	_UPVALUE1_ = cc.p(40 * pos, effectAnimation[bType].posY)
	cc.p(40 * pos, effectAnimation[bType].posY)[1] = cca.scaleTo(0.5, 0.2)
	cc.p(40 * pos, effectAnimation[bType].posY)[2] = cca.fadeOut(0.5)
	cc.p(40 * pos, effectAnimation[bType].posY)[3] = cca.fadeOut(0.5)
	bnfontLab[1] = cca.scaleTo(0.2, 1.6)
	bnfontLab[2] = cca.delay(0.5)
	bnfontLab[3] = cca.spawn(cc.p(40 * pos, effectAnimation[bType].posY))
	bnfontLab[4] = cca.spawn(cc.p(40 * pos, effectAnimation[bType].posY))
	bnfontLab[5] = cca.spawn(cc.p(40 * pos, effectAnimation[bType].posY))
	bnfontLab[6] = cca.spawn(cc.p(40 * pos, effectAnimation[bType].posY))
	bnfontLab[7] = cca.spawn(cc.p(40 * pos, effectAnimation[bType].posY))
	_ENV = bnfontLab
	function bnfontLab.onComplete()
		widget:removeChildByName("action_node", true)
	end
	transition.execute(action_node, cca.seq(bnfontLab), bnfontLab)
end
return effectUI
