local worldMapMonster = include("worldMapMonster")
local worldMapMonsterSemluk = class("worldMapMonsterSemluk", worldMapMonster)
function worldMapMonsterSemluk:_initData()
	worldMapMonsterSemluk.super._initData(self)
	self.framesNumber = 24
	self.framesTimes = 0.06666666666666667
end
function worldMapMonsterSemluk:doStandingAnimation()
	worldMapMonsterSemluk.super.doStandingAnimation(self)
	self.monster:setPositionY(63)
end
return worldMapMonsterSemluk
