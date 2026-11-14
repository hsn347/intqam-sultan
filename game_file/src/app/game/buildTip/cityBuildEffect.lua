local cityBuildEffect = class("cityBuildEffect", function(cssFile)
	local view = include("ccsView")
	return view.new(cssFile)
end)
function cityBuildEffect:ctor()
end
function cityBuildEffect:showAnim()
	for i = 1, 20 do
		local animNode = SoraDGetChildByName(self, "animNode" .. i)
		if animNode ~= nil then
			local animationAction = animNode:getActionByTag(animNode:getTag())
			if animationAction ~= nil then
				animNode:resume()
				animationAction:gotoFrameAndPlay(0, true)
			end
		else
			break
		end
	end
end
function cityBuildEffect:hideAnim()
	for i = 1, 20 do
		local animNode = SoraDGetChildByName(self, "animNode" .. i)
		if animNode ~= nil then
			local animationAction = animNode:getActionByTag(animNode:getTag())
			if animationAction ~= nil then
				animNode:pause()
			else
			end
		else
			break
		end
	end
end
function cityBuildEffect:showParticle()
	for i = 1, 10 do
		local effectNode = SoraDGetChildByName(self, "effectNode" .. i)
		if effectNode ~= nil then
			effectNode:setVisible(true)
			effectNode:resetSystem()
		else
			break
		end
	end
end
function cityBuildEffect:hideParticle()
	for i = 1, 10 do
		local effectNode = SoraDGetChildByName(self, "effectNode" .. i)
		if effectNode ~= nil then
			effectNode:setVisible(false)
			effectNode:stopSystem()
		else
			break
		end
	end
end
function cityBuildEffect:showEffect()
	self:showAnim()
	self:showParticle()
end
function cityBuildEffect:hideEffect()
	self:hideAnim()
	self:hideParticle()
	self:removeFromParent()
end
function cityBuildEffect:onEnter()
	self:showEffect()
end
return cityBuildEffect
