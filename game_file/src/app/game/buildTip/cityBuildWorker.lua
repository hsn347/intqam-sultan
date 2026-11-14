local cityBuildWorker = class("cityBuildWorker", function(cssFile)
	local view = include("ccsView")
	return view.new(cssFile)
end)
function cityBuildWorker:ctor()
end
function cityBuildWorker:showAnimatinWorker()
	for i = 1, 20 do
		local animNode = SoraDGetChildByName(self, "animNode" .. i)
		if animNode ~= nil then
			local animationAction = animNode:getActionByTag(animNode:getTag())
			if animationAction ~= nil then
				animNode:resume()
				animationAction:gotoFrameAndPlay(0, true)
			else
				animationAction = cc.CSLoader:createTimeline()
				animationAction:setTag(animNode:getTag())
				animNode:runAction(animationAction)
				animationAction:gotoFrameAndPlay(0, true)
			end
		else
			break
		end
	end
	for i = 1, 10 do
		local particle = SoraDGetChildByName(self, "buildParticle" .. i)
		if particle ~= nil then
			particle:setVisible(false)
			local actionDelay = cca.delay(1.0)
			local callFunc = cca.callFunc(function()
				particle:setVisible(true)
				particle:resetSystem()
			end)
			local actionDelay2 = cca.delay(0.417)
			_UPVALUE3_ = true
			;(true)[1] = actionDelay
			;(true)[2] = callFunc
			;(true)[3] = actionDelay2
			local actionSeq = cca.seq(true)
			local actionRepeat = cca.repeatForever(actionSeq)
			particle:runAction(actionRepeat)
		else
			break
		end
	end
end
function cityBuildWorker:hideAnimBuildWorker()
	for i = 1, 20 do
		local animNode = SoraDGetChildByName(self, "animNode" .. i)
		if animNode ~= nil and not tolua.isnull(animNode) then
			local animationAction = animNode:getActionByTag(animNode:getTag())
			if animationAction ~= nil then
				animNode:pause()
			end
		else
			break
		end
	end
	for i = 1, 10 do
		local particle = SoraDGetChildByName(self, "buildParticle" .. i)
		if particle ~= nil and not tolua.isnull(particle) then
			particle:setVisible(false)
			particle:stopAllActions()
			particle:stopSystem()
		else
			break
		end
	end
	self:removeFromParent()
end
function cityBuildWorker:setIsHideHammer(isHideHammer)
	if isHideHammer then
		local animNode = SoraDGetChildByName(self, "animNode" .. 5)
		if animNode then
			animNode:setVisible(false)
		end
	end
end
function cityBuildWorker:onEnter()
	self:showAnimatinWorker()
end
return cityBuildWorker
