local _ENV, AnimationCache
local _ENV, dicAnimation
function AnimationCache:getInstance()
	return self
end
function AnimationCache:addAnimation(animation, name)
	animation:retain()
	dicAnimation[name] = animation
end
function AnimationCache:getAnimation(name)
	return dicAnimation[name]
end
function AnimationCache:removeAnimation(name)
	local animation = dicAnimation[name]
	if animation then
		dicAnimation[name]:release()
		dicAnimation[name] = nil
	end
end
function AnimationCache:removeAllCache()
	for k, v in pairs(dicAnimation) do
		v:release()
	end
	_ENV = (for generator)
end
return AnimationCache
