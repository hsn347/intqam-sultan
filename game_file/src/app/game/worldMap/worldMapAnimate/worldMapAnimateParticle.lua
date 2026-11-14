local worldMapAnimate = include("worldMapAnimate")
local worldMapAnimateParticle = class("worldMapAnimateParticle", worldMapAnimate)
_ENV, _ENV, _ENV, worldMapAnimateParticle.ctor = nil, worldMapAnimate, function(self)
	worldMapAnimateParticle.super.ctor(self)
end, function(self)
	worldMapAnimateParticle.super.ctor(self)
end
_ENV, (nil).plist = nil, "et_cwliusha_01.plist"
;(nil).x = 0.55
;(nil).scale, (nil).y = nil, 0.21
_ENV, _ENV, (function(self)
	worldMapAnimateParticle.super.ctor(self)
end)[1], worldMapAnimate[1], (nil).autocull = nil, worldMapAnimate, worldMapAnimate, nil, false
_ENV, (nil).plist = nil, "et_cwliusha_02.plist"
;(nil).x = 1.61
;(nil).scale, (nil).y = nil, 0.68
_ENV, _ENV, (function(self)
	worldMapAnimateParticle.super.ctor(self)
end)[2], worldMapAnimate[1], (nil).autocull = nil, worldMapAnimate, worldMapAnimate, nil, false
_ENV, (nil).plist = nil, "et_cwliusha_01.plist"
;(nil).x = 0.55
;(nil).scale, (nil).y = nil, 0.21
_ENV, worldMapAnimate[1], (nil).autocull = nil, nil, false
_ENV, (nil).plist = nil, "et_cwliusha_02.plist"
;(nil).x = 1.61
;(nil).scale, (nil).y = nil, 0.68
;(function(self)
	worldMapAnimateParticle.super.ctor(self)
end)[3], worldMapAnimate[2], (nil).autocull = worldMapAnimate, nil, false
local function animateEffectConfig(self)
	worldMapAnimateParticle.super.ctor(self)
end
local createParticleEffect = function(effectId)
	local param = animateEffectConfig[effectId]
	if not param then
		print("error effectId", effectId)
		return
	end
	local et_node = SoraDCreateEffectNode(param)
	return et_node
end
function worldMapAnimateParticle:initData(configData)
	local id = configData.id
	local et_node = createParticleEffect(id)
	if et_node then
		et_node:addTo(self)
	end
end
return worldMapAnimateParticle
