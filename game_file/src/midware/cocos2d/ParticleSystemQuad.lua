local ParticleSystemQuad = fgui.ParticleEx
function ParticleSystemQuad:create(plist)
	local node = ParticleSystemQuad()
	node:setPosition(0, 0)
	node:autoRelease()
	node:ignoreContentAdaptWithSize(false)
	node:setParticlePlistPath(plist)
	return node
end
function ParticleSystemQuad:getTotalParticles()
	return 100
end
function ParticleSystemQuad:setTotalParticles()
end
return ParticleSystemQuad
