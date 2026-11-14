_ENV, autoFightDefine, _ENV = nil, nil, nil
;(nil).SoldierStateNone = 0
;(nil).SoldierStateRun = 1
;(nil).SoldierStateHit = 2
;(nil).SoldierStateDeath = 3
_ENV, SoldierState, (nil).SoldierStateWait = nil, nil, 4
;(nil).GroupStateNone = 0
;(nil).GroupStateRun = 1
;(nil).GroupStateHit = 2
;(nil).GroupStateDeath = 3
_ENV, GroupState, (nil).GroupStateWait = nil, nil, 4
;(nil).None = 1
;(nil).Attack = 2
GroupType, (nil).Defense = nil, 3
return autoFightDefine
