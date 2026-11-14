local cityBuildWorkDoneEffect = class("cityBuildWorkDoneEffect", function(cssFile)
	local view = include("ccsView")
	return view.new(cssFile)
end)
function cityBuildWorkDoneEffect:ctor()
end
function cityBuildWorkDoneEffect:showAnimation()
	for i = 1, 10 do
		local buildParticleWorkDoneItem = SoraDGetChildByName(self, "buildParticleWorkDone" .. i)
		if buildParticleWorkDoneItem then
			buildParticleWorkDoneItem:setVisible(true)
			buildParticleWorkDoneItem:resetSystem()
		else
			break
		end
	end
end
function cityBuildWorkDoneEffect:hideAnimation()
	for i = 1, 10 do
		local buildParticleWorkDoneItem = SoraDGetChildByName(self, "buildParticleWorkDone" .. i)
		if buildParticleWorkDoneItem then
			buildParticleWorkDoneItem:setVisible(false)
			buildParticleWorkDoneItem:stopSystem()
		else
			break
		end
	end
	self:removeFromParent()
end
function cityBuildWorkDoneEffect:onEnter()
	self:showAnimation()
end
return cityBuildWorkDoneEffect
