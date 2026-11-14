local particleManager = class("particleManager")
local PARTICLE_FACTOR_DEC = 0.02
local PARTICLE_FACTOR_DEC_LOST = 0.05
local PARTICLE_FACTOR_ADD = 0.002
local PARTICLE_FACTOR_ADD_STABLE = 0.005
local PARTICLE_MAX_COUNT = 100
local PARTICLE_FACTOR_MAX = 1.0
local PARTICLE_FACTOR_MIN = 0.12
if device.platform == "android" then
	PARTICLE_FACTOR_DEC = 0.05
	PARTICLE_FACTOR_DEC_LOST = 0.1
	PARTICLE_FACTOR_ADD = 0.002
	PARTICLE_FACTOR_ADD_STABLE = 0.005
	PARTICLE_FACTOR_MIN = 0.5
	PARTICLE_MAX_COUNT = 100
elseif device.platform == "ios" then
	PARTICLE_FACTOR_DEC = 0.04
	PARTICLE_FACTOR_DEC_LOST = 0.08
	PARTICLE_FACTOR_ADD = 0.002
	PARTICLE_FACTOR_ADD_STABLE = 0.005
	PARTICLE_MAX_COUNT = 100
	PARTICLE_FACTOR_MIN = 0.15
end
function particleManager:start()
	self.curParticleFactor = 1.0
	if ParticleManager then
		ParticleManager:init()
		ParticleManager:start()
	end
end
function particleManager:stop()
	if ParticleManager then
		ParticleManager:stop()
		self.curParticleFactor = PARTICLE_FACTOR_MAX
		ParticleManager:setTotalParticleCountFactor(self.curParticleFactor)
	end
end
function particleManager:decFactor(factor)
	local curFactor = self.curParticleFactor - factor
	curFactor = math.max(curFactor, PARTICLE_FACTOR_MIN)
	if curFactor ~= self.curParticleFactor then
		self.curParticleFactor = curFactor
		ParticleManager:setTotalParticleCountFactor(self.curParticleFactor)
	end
end
function particleManager:addFactor(factor)
	local curFactor = self.curParticleFactor + factor
	curFactor = math.min(curFactor, PARTICLE_FACTOR_MAX)
	if curFactor ~= self.curParticleFactor then
		self.curParticleFactor = curFactor
		ParticleManager:setTotalParticleCountFactor(self.curParticleFactor)
	end
end
function particleManager:notifyContinuousFrameLost(frameLostCycle, continueFrameLostThreshold, times)
	local particleCount = ParticleManager:getTotalParticleCount()
	local curCount = self.curParticleFactor * particleCount
	if curCount > PARTICLE_MAX_COUNT then
		self:decFactor(PARTICLE_FACTOR_DEC_LOST)
	end
end
function particleManager:notifyLowFps(lowFpsCycle, lowFpsThreshold, frames)
	local particleCount = ParticleManager:getTotalParticleCount()
	local curCount = self.curParticleFactor * particleCount
	if curCount > PARTICLE_MAX_COUNT then
		self:decFactor(PARTICLE_FACTOR_DEC)
	end
end
function particleManager:notifyFpsChanged(oldFps, newFps)
	if oldFps < newFps and self.curParticleFactor < PARTICLE_FACTOR_MAX then
		self:addFactor(PARTICLE_FACTOR_ADD)
	end
end
function particleManager:notifyFpsStable(fFps)
	if self.curParticleFactor < PARTICLE_FACTOR_MAX then
		self:addFactor(PARTICLE_FACTOR_ADD_STABLE)
	end
end
function notifyContinuousFrameLost(frameLostCycle, continueFrameLostThreshold, times)
	particleManager:notifyContinuousFrameLost(frameLostCycle, continueFrameLostThreshold, times)
end
function notifyLowFps(lowFpsCycle, lowFpsThreshold, frames)
	particleManager:notifyLowFps(lowFpsCycle, lowFpsThreshold, frames)
end
function notifyFpsChanged(oldFps, newFps)
	particleManager:notifyFpsChanged(oldFps, newFps)
end
function notifyFpsStable(fFps)
	particleManager:notifyFpsStable(fFps)
end
return particleManager
