local gamemodulec = include("GameModule")
local attributeCtrl = class("attributeCtrl", gamemodulec)
function attributeCtrl:ctor()
	attributeCtrl.super.ctor(self)
end
function attributeCtrl:init()
	local attributeSystem = include("attributeSystem")
	attributeSystem.init(gAttributeSourceEnum)
	self.attributeSystem = attributeSystem
end
function attributeCtrl:Logout()
	attributeCtrl.super.Logout(self)
	self:resetData()
end
function attributeCtrl:resetData()
end
function attributeCtrl:getAttributeSystem()
	return self.attributeSystem
end
function attributeCtrl:EnterGame()
	attributeCtrl.super.EnterGame(self)
	self:init()
end
function attributeCtrl:dump()
	dump(self.attrModule, "attributeCtrl", 10)
end
return attributeCtrl
