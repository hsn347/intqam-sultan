local activity_9001703_Ctrl = SoraDGetCtrl("activity_9001703_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_bullet = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001703/Com_bullet", Com_bullet)
function Com_bullet:onInit()
end
function Com_bullet:onShow()
end
function Com_bullet:initData(parent)
	self.parent = parent
	self:resetData()
end
function Com_bullet:hit(balloonTag)
	if not self.hitBalloon[balloonTag] then
		self.count = self.count - 1
		self.hitBalloon[balloonTag] = true
		if self.count <= 0 then
			self:addToPool()
		end
	end
end
function Com_bullet:isHited(balloonTag)
	return self.hitBalloon[balloonTag] or false
end
function Com_bullet:resetData()
	self.hitBalloon, activity_9001703_Ctrl = nil, nil
	self.count = 1 + activity_9001703_Ctrl:getSkillLvEffect(6)
end
function Com_bullet:addToPool()
	if self.parent then
		self.parent:addToPool(self)
	end
end
return Com_bullet
