local worldMapMonster = include("worldMapMonster")
local worldMapMonsterNebula = class("worldMapMonsterNebula", worldMapMonster)
function worldMapMonsterNebula:_initData()
	worldMapMonsterNebula.super._initData(self)
	self.framesNumber = 24
	self.framesTimes = 0.049999999999999996
end
return worldMapMonsterNebula
