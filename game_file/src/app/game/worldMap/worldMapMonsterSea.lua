local worldMapMonster = include("worldMapMonster")
local worldMapMonsterSea = class("worldMapMonsterSea", worldMapMonster)
function worldMapMonsterSea:_initData()
	worldMapMonsterSea.super._initData(self)
	self.framesNumber = 24
	self.framesTimes = 0.06666666666666667
end
return worldMapMonsterSea
