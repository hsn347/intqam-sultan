local _ENV, transition
local _UPVALUE2_, _ENV, ACTION_EASING
_UPVALUE2_, ACTION_EASING.BACKIN, (nil)[1] = nil, nil, cc.EaseBackIn
_UPVALUE2_, ACTION_EASING.BACKIN, (nil)[2] = nil, nil, 1
_UPVALUE2_, ACTION_EASING.BACKINOUT, (nil)[1] = nil, nil, cc.EaseBackInOut
_UPVALUE2_, ACTION_EASING.BACKINOUT, (nil)[2] = nil, nil, 1
_UPVALUE2_, ACTION_EASING.BACKOUT, (nil)[1] = nil, nil, cc.EaseBackOut
_UPVALUE2_, ACTION_EASING.BACKOUT, (nil)[2] = nil, nil, 1
_UPVALUE2_, ACTION_EASING.BOUNCE, (nil)[1] = nil, nil, cc.EaseBounce
_UPVALUE2_, ACTION_EASING.BOUNCE, (nil)[2] = nil, nil, 1
_UPVALUE2_, ACTION_EASING.BOUNCEIN, (nil)[1] = nil, nil, cc.EaseBounceIn
_UPVALUE2_, ACTION_EASING.BOUNCEIN, (nil)[2] = nil, nil, 1
_UPVALUE2_, ACTION_EASING.BOUNCEINOUT, (nil)[1] = nil, nil, cc.EaseBounceInOut
_UPVALUE2_, ACTION_EASING.BOUNCEINOUT, (nil)[2] = nil, nil, 1
_UPVALUE3_, ACTION_EASING.BOUNCEOUT, (nil)[1] = nil, nil, cc.EaseBounceOut
_UPVALUE3_, ACTION_EASING.BOUNCEOUT, (nil)[2] = nil, nil, 1
_UPVALUE3_, ACTION_EASING.ELASTIC, (nil)[1] = nil, nil, cc.EaseElastic
_UPVALUE3_, ACTION_EASING.ELASTIC, (nil)[2] = nil, nil, 2
_UPVALUE3_, ACTION_EASING.ELASTIC, (nil)[3] = nil, nil, 0.3
_UPVALUE3_, ACTION_EASING.ELASTICIN, (nil)[1] = nil, nil, cc.EaseElasticIn
_UPVALUE3_, ACTION_EASING.ELASTICIN, (nil)[2] = nil, nil, 2
_UPVALUE3_, ACTION_EASING.ELASTICIN, (nil)[3] = nil, nil, 0.3
_UPVALUE3_, ACTION_EASING.ELASTICINOUT, (nil)[1] = nil, nil, cc.EaseElasticInOut
_UPVALUE3_, ACTION_EASING.ELASTICINOUT, (nil)[2] = nil, nil, 2
_UPVALUE3_, ACTION_EASING.ELASTICINOUT, (nil)[3] = nil, nil, 0.3
_UPVALUE2_, ACTION_EASING.ELASTICOUT, (nil)[1] = nil, nil, cc.EaseElasticOut
_UPVALUE2_, ACTION_EASING.ELASTICOUT, (nil)[2] = nil, nil, 2
_UPVALUE2_, ACTION_EASING.ELASTICOUT, (nil)[3] = nil, nil, 0.3
_UPVALUE2_, ACTION_EASING.EXPONENTIALIN, (nil)[1] = nil, nil, cc.EaseExponentialIn
_UPVALUE2_, ACTION_EASING.EXPONENTIALIN, (nil)[2] = nil, nil, 1
_UPVALUE2_, ACTION_EASING.EXPONENTIALINOUT, (nil)[1] = nil, nil, cc.EaseExponentialInOut
_UPVALUE2_, ACTION_EASING.EXPONENTIALINOUT, (nil)[2] = nil, nil, 1
_UPVALUE3_, ACTION_EASING.EXPONENTIALOUT, (nil)[1] = nil, nil, cc.EaseExponentialOut
_UPVALUE3_, ACTION_EASING.EXPONENTIALOUT, (nil)[2] = nil, nil, 1
_UPVALUE3_, ACTION_EASING.IN, (nil)[1] = nil, nil, cc.EaseIn
_UPVALUE3_, ACTION_EASING.IN, (nil)[2] = nil, nil, 2
_UPVALUE3_, ACTION_EASING.IN, (nil)[3] = nil, nil, 1
_UPVALUE3_, ACTION_EASING.INOUT, (nil)[1] = nil, nil, cc.EaseInOut
_UPVALUE3_, ACTION_EASING.INOUT, (nil)[2] = nil, nil, 2
_UPVALUE3_, ACTION_EASING.INOUT, (nil)[3] = nil, nil, 1
_UPVALUE3_, ACTION_EASING.OUT, (nil)[1] = nil, nil, cc.EaseOut
_UPVALUE3_, ACTION_EASING.OUT, (nil)[2] = nil, nil, 2
_UPVALUE3_, ACTION_EASING.OUT, (nil)[3] = nil, nil, 1
_UPVALUE2_, ACTION_EASING.RATEACTION, (nil)[1] = nil, nil, cc.EaseRateAction
_UPVALUE2_, ACTION_EASING.RATEACTION, (nil)[2] = nil, nil, 2
_UPVALUE2_, ACTION_EASING.RATEACTION, (nil)[3] = nil, nil, 1
_UPVALUE2_, ACTION_EASING.SINEIN, (nil)[1] = nil, nil, cc.EaseSineIn
_UPVALUE2_, ACTION_EASING.SINEIN, (nil)[2] = nil, nil, 1
_UPVALUE2_, ACTION_EASING.SINEINOUT, (nil)[1] = nil, nil, cc.EaseSineInOut
_UPVALUE2_, ACTION_EASING.SINEINOUT, (nil)[2] = nil, nil, 1
ACTION_EASING.SINEOUT, (nil)[1] = nil, cc.EaseSineOut
ACTION_EASING.SINEOUT, (nil)[2] = nil, 1
local actionManager = cc.Director:getInstance():getActionManager()
function transition.newEasing(action, easingName, more)
	local key = string.upper(tostring(easingName))
	if string.sub(key, 1, 6) == "CCEASE" then
		key = string.sub(key, 7)
	end
	local easing
	if ACTION_EASING[key] then
		local cls, count, default = unpack(ACTION_EASING[key])
		if count == 2 then
			easing = cls:create(action, more or default)
		else
			easing = cls:create(action)
		end
	end
	return easing or action
end
function transition.create(action, args)
	args = checktable(args)
	if args.easing then
		if type(args.easing) == "table" then
			action = transition.newEasing(action, unpack(args.easing))
		else
			action = transition.newEasing(action, args.easing)
		end
	end
	local _ENV, actions = transition.newEasing(action, args.easing), transition.newEasing(action, args.easing)
	local delay = checknumber(args.delay)
	if 0 < delay then
		actions[#actions + 1] = cc.DelayTime:create(delay)
	end
	actions[#actions + 1] = action
	local onComplete = args.onComplete
	if type(onComplete) ~= "function" then
		onComplete = nil
	end
	if onComplete then
		actions[#actions + 1] = cc.CallFunc:create(onComplete)
	end
	if 1 < #actions then
		return transition.sequence(actions)
	else
		return actions[1]
	end
end
function transition.execute(target, action, args)
	assert(not tolua.isnull(target), "transition.execute() - target is not cc.Node")
	local action = transition.create(action, args)
	target:runAction(action)
	return action
end
function transition.rotateTo(target, args)
	assert(not tolua.isnull(target), "transition.rotateTo() - target is not cc.Node")
	local action = cc.RotateTo:create(args.time, args.rotate)
	return transition.execute(target, action, args)
end
function transition.moveTo(target, args)
	assert(not tolua.isnull(target), "transition.moveTo() - target is not cc.Node")
	local tx, ty = target:getPosition()
	local x = args.x or tx
	local y = args.y or ty
	local action = cc.MoveTo:create(args.time, cc.p(x, y))
	return transition.execute(target, action, args)
end
function transition.moveBy(target, args)
	assert(not tolua.isnull(target), "transition.moveBy() - target is not cc.Node")
	local x = args.x or 0
	local y = args.y or 0
	local action = cc.MoveBy:create(args.time, cc.p(x, y))
	return transition.execute(target, action, args)
end
function transition.fadeIn(target, args)
	assert(not tolua.isnull(target), "transition.fadeIn() - target is not cc.Node")
	local action = cc.FadeIn:create(args.time)
	return transition.execute(target, action, args)
end
function transition.fadeOut(target, args)
	assert(not tolua.isnull(target), "transition.fadeOut() - target is not cc.Node")
	local action = cc.FadeOut:create(args.time)
	return transition.execute(target, action, args)
end
function transition.fadeTo(target, args)
	assert(not tolua.isnull(target), "transition.fadeTo() - target is not cc.Node")
	local opacity = checkint(args.opacity)
	if opacity < 0 then
		opacity = 0
	elseif 255 < opacity then
		opacity = 255
	end
	local action = cc.FadeTo:create(args.time, opacity)
	return transition.execute(target, action, args)
end
function transition.scaleTo(target, args)
	assert(not tolua.isnull(target), "transition.scaleTo() - target is not cc.Node")
	local action
	if args.scale then
		action = cc.ScaleTo:create(checknumber(args.time), checknumber(args.scale))
	elseif args.scaleX or args.scaleY then
		local scaleX, scaleY
		if args.scaleX then
			scaleX = checknumber(args.scaleX)
		else
			scaleX = target:getScaleX()
		end
		if args.scaleY then
			scaleY = checknumber(args.scaleY)
		else
			scaleY = target:getScaleY()
		end
		action = cc.ScaleTo:create(checknumber(args.time), scaleX, scaleY)
	end
	return transition.execute(target, action, args)
end
function transition.sequence(actions)
	if #actions < 1 then
		return
	end
	if #actions < 2 then
		return actions[1]
	end
	return cca.seq(actions)
end
function transition.playAnimationOnce(target, animation, removeWhenFinished, onComplete, delay)
	local _ENV, actions
	if type(delay) == "number" and 0 < delay then
		target:setVisible(false)
		actions[#actions + 1] = cc.DelayTime:create(delay)
		actions[#actions + 1] = cc.Show:create()
	end
	actions[#actions + 1] = cc.Animate:create(animation)
	if removeWhenFinished then
		actions[#actions + 1] = cc.RemoveSelf:create()
	end
	if onComplete then
		actions[#actions + 1] = cc.CallFunc:create(onComplete)
	end
	local action
	if 1 < #actions then
		action = transition.sequence(actions)
	else
		action = actions[1]
	end
	target:runAction(action)
	return action
end
function transition.playAnimationForever(target, animation, delay)
	local animate = cc.Animate:create(animation)
	local action
	if type(delay) == "number" and 0 < delay then
		target:setVisible(false)
		_UPVALUE3_ = target
		target[1] = cc.DelayTime:create(delay)
		target[2] = cc.Show:create()
		target[3] = animate
		local sequence = transition.sequence(target)
		action = cc.RepeatForever:create(sequence)
	else
		action = cc.RepeatForever:create(animate)
	end
	target:runAction(action)
	return action
end
function transition.removeAction(action)
	if not tolua.isnull(action) then
		actionManager:removeAction(action)
	end
end
function transition.stopTarget(target)
	if not tolua.isnull(target) then
		actionManager:removeAllActionsFromTarget(target)
	end
end
function transition.pauseTarget(target)
	if not tolua.isnull(target) then
		actionManager:pauseTarget(target)
	end
end
function transition.resumeTarget(target)
	if not tolua.isnull(target) then
		actionManager:resumeTarget(target)
	end
end
return transition
