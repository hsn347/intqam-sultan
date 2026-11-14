local worldMapMonster = include("worldMapMonster")
local worldMapMonsterSnowMan = class("worldMapMonsterSnowMan", worldMapMonster)
function worldMapMonsterSnowMan:_initData()
	worldMapMonsterSnowMan.super._initData(self)
	self.framesNumber = 24
	self.framesTimes = 0.05
end
function worldMapMonsterSnowMan:doStandingAnimation()
	worldMapMonsterSnowMan.super.doStandingAnimation(self)
end
return worldMapMonsterSnowMan
