local instanceCache = include("instanceCache")
local waterCache = include("waterCache")
local animateCache = include("animateCache")
local normalNodeCache = include("normalNodeCache")
local _ENV, instanceCacheMgr = "normalNodeCache", "normalNodeCache"
local _ENV, gAnimationCache, _ENV, gSoldierSpriteCache, _ENV, gBulletCache, _ENV, _ENV, cacheInstance
;(nil).WATER_BEGIN_TYPE = 200
;(nil).WAR_LV_BEGIN_TYPE = 500
local (nil).ANIMATE_BEGIN_TYPE, BEGIN_TYPE = 700, nil
instanceCacheMgr.BEGIN_TYPE = BEGIN_TYPE
function instanceCacheMgr.addInstance(node)
	local instanceType = node:getClassType()
	local instance = cacheInstance[instanceType]
	if not instance then
		instance = instanceCache:new()
		cacheInstance[instanceType] = instance
	end
	if instance then
		instance:addInstance(node)
	end
end
function instanceCacheMgr.getInstance(instanceType)
	local instance = cacheInstance[instanceType]
	if instance then
		return instance:getInstance()
	end
end
function instanceCacheMgr.addAnimateNode(node)
	local instanceType = node:getTag()
	local instance = cacheInstance[instanceType]
	if not instance then
		instance = animateCache:new()
		cacheInstance[instanceType] = instance
	end
	if instance then
		instance:addInstance(node)
	end
end
function instanceCacheMgr.addWater(node)
	local instanceType = node:getTag()
	local instance = cacheInstance[instanceType]
	if not instance then
		instance = waterCache:new()
		cacheInstance[instanceType] = instance
	end
	if instance then
		instance:addInstance(node)
	end
end
function instanceCacheMgr.addNormalNode(node)
	local instanceType = node:getTag()
	instanceCacheMgr.addNormalNodeByType(node, instanceType)
end
function instanceCacheMgr.addNormalNodeByType(node, instanceType)
	local instance = cacheInstance[instanceType]
	if not instance then
		instance = normalNodeCache:new()
		cacheInstance[instanceType] = instance
	end
	if instance then
		instance:addInstance(node)
	end
end
function instanceCacheMgr.clearCache()
	for _, instance in pairs(cacheInstance) do
		instance:clean()
	end
	_ENV = (for generator)
	if gBulletCache then
		for _, bullets in pairs(gBulletCache) do
			for i, v in ipairs(bullets) do
				v:release()
			end
		end
		gBulletCache, _ENV = pairs(gBulletCache)
	end
	if gSoldierSpriteCache then
		for i, v in ipairs(gSoldierSpriteCache) do
			v:release()
		end
		gSoldierSpriteCache, _ENV = ipairs(gSoldierSpriteCache)
	end
	if gAnimationCache then
		for cacheName, _ in pairs(gAnimationCache) do
			print("removeAnimationCache ", cacheName)
			display.removeAnimationCache(cacheName)
		end
		gAnimationCache, _ENV = pairs(gAnimationCache)
	end
end
function instanceCacheMgr.dumpCacheInstance(...)
	dump(cacheInstance, "==instanceCacheMgr.cacheInstance==")
end
return instanceCacheMgr
