local worldMapAnimate = include("worldMapAnimate")
local worldMapAnimateCCS = class("worldMapAnimateCCS", worldMapAnimate)
function worldMapAnimateCCS:ctor()
	worldMapAnimateCCS.super.ctor(self)
end
function worldMapAnimateCCS:initData(configData)
	if configData.ccsPath then
		local node = SoraDCreatAnimation(configData.ccsPath, nil, true)
		node:addTo(self)
		self:setNodeGroupID(node, configData, true)
	end
end
return worldMapAnimateCCS
