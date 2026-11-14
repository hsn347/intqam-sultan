local _ENV, animateFactory
local createAnimateByLua = function(configData)
	local animateNode = include("worldMapAnimateLua").new()
	if animateNode then
		animateNode:initData(configData)
	end
	return animateNode
end
local createAnimateByParticle = function(configData)
	local animateNode = include("worldMapAnimateParticle").new()
	if animateNode then
		animateNode:initData(configData)
	end
	return animateNode
end
local createAnimateByCCS = function(configData)
	local animateNode = include("worldMapAnimateCCS").new()
	if animateNode then
		animateNode:initData(configData)
	end
	return animateNode
end
_ENV = nil
;(nil).animateFactoryType_Lua = 1
;(nil).animateFactoryType_Particle = 2
local _ENV, (nil).animateFactoryType_CCS, animateFactoryType = nil, 3, nil
_ENV = nil
;(nil)[animateFactoryType.animateFactoryType_Lua], (nil).createFun = nil, createAnimateByLua
_ENV = nil
;(nil)[animateFactoryType.animateFactoryType_Particle], (nil).createFun = nil, createAnimateByParticle
_ENV = nil
;(nil)[animateFactoryType.animateFactoryType_CCS], (nil).createFun = nil, createAnimateByCCS
local animateCreateConfig
function animateFactory.createAnimateInstanace(configData)
	local configType = configData.class
	if configType then
		local config = animateCreateConfig[configType]
		if config then
			local createFun = config.createFun
			if createFun then
				local animate = createFun(configData)
				if animate then
					return animate
				else
					print("createFun cann't create animate ", configType)
				end
			else
				print("createFun is nil", configType)
			end
		else
			print("animateCreateConfig is nil", configType)
		end
	else
		print("configType.class is nil", configType)
	end
end
return animateFactory
