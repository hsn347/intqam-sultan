local cityBuildConstDef = include("cityBuildConstDef")
local cityBuildSoldierPool = include("cityBuildSoldierPool")
local mainCityDefine = include("mainCityDefine")
local cityBuildTroopsMatrix = class("cityBuildTroopsMatrix", function()
	local view = include("baseView")
	return view.new(cc.size(0, 0), false)
end)
_ENV = "cityBuildTroopsMatrix"
;("cityBuildTroopsMatrix").A = cc.p(0, 0)
;("cityBuildTroopsMatrix").B = cc.p(100, 0)
local _ENV, ("cityBuildTroopsMatrix").D, tblCfgQibingN = cc.p(0, 100), cc.p(0, 100), "cityBuildTroopsMatrix"
cc.p(0, 100).A = cc.p(0, 0)
cc.p(0, 100).B = cc.p(100, 0)
local _ENV, cc.p(0, 100).D, tblCfgQibingW = cc.p(0, 100), cc.p(0, 100), cc.p(0, 100)
cc.p(0, 100).n = tblCfgQibingN
cc.p(0, 100).s = tblCfgQibingN
cc.p(0, 100).w = tblCfgQibingN
cc.p(0, 100).e = tblCfgQibingN
cc.p(0, 100).wn = tblCfgQibingW
cc.p(0, 100).ws = tblCfgQibingW
cc.p(0, 100).es = tblCfgQibingW
cc.p(0, 100).en = tblCfgQibingW
local _ENV, cc.p(0, 100).scale, tblCfgQibing = 0, 0.9, cc.p(0, 100)
;(0).A = cc.p(0, 0)
;(0).B = cc.p(80, 0)
local _ENV, (0).D, tblCfgBuGongbingN = cc.p(0, 80), cc.p(0, 80), 0
cc.p(0, 80).A = cc.p(0, 0)
cc.p(0, 80).B = cc.p(80, 0)
local _ENV, cc.p(0, 80).D, tblCfgBuGongbingW = cc.p(0, 80), cc.p(0, 80), cc.p(0, 80)
cc.p(0, 80).n = tblCfgBuGongbingN
cc.p(0, 80).s = tblCfgBuGongbingN
cc.p(0, 80).w = tblCfgBuGongbingN
cc.p(0, 80).e = tblCfgBuGongbingN
cc.p(0, 80).wn = tblCfgBuGongbingW
cc.p(0, 80).ws = tblCfgBuGongbingW
cc.p(0, 80).es = tblCfgBuGongbingW
cc.p(0, 80).en = tblCfgBuGongbingW
local _ENV, cc.p(0, 80).scale, tblCfgBuGongbing = 0, 1.0, cc.p(0, 80)
;(0).A = cc.p(0, 0)
;(0).B = cc.p(150, 0)
local _ENV, (0).D, tblCfgChebingN = cc.p(0, 80), cc.p(0, 80), 0
cc.p(0, 80).A = cc.p(0, 0)
cc.p(0, 80).B = cc.p(150, 0)
local _ENV, cc.p(0, 80).D, tblCfgChebingW = cc.p(0, 80), cc.p(0, 80), cc.p(0, 80)
cc.p(0, 80).n = tblCfgChebingN
cc.p(0, 80).s = tblCfgChebingN
cc.p(0, 80).w = tblCfgChebingN
cc.p(0, 80).e = tblCfgChebingN
cc.p(0, 80).wn = tblCfgChebingW
cc.p(0, 80).ws = tblCfgChebingW
cc.p(0, 80).es = tblCfgChebingW
cc.p(0, 80).en = tblCfgChebingW
local _ENV, cc.p(0, 80).scale, tblCfgChebing = 0, 0.6, cc.p(0, 80)
;(0).A = cc.p(0, 0)
;(0).B = cc.p(120, 0)
local _ENV, (0).D, tblCfgEliteN = cc.p(0, 60), cc.p(0, 60), 0
cc.p(0, 60).A = cc.p(0, 0)
cc.p(0, 60).B = cc.p(120, 0)
local _ENV, cc.p(0, 60).D, tblCfgEliteW = cc.p(0, 60), cc.p(0, 60), cc.p(0, 60)
cc.p(0, 60).n = tblCfgEliteN
cc.p(0, 60).s = tblCfgEliteN
cc.p(0, 60).w = tblCfgEliteN
cc.p(0, 60).e = tblCfgEliteN
cc.p(0, 60).wn = tblCfgEliteW
cc.p(0, 60).ws = tblCfgEliteW
cc.p(0, 60).es = tblCfgEliteW
cc.p(0, 60).en = tblCfgEliteW
local _ENV, cc.p(0, 60).scale, tblCfgElite = 0, 0.5, cc.p(0, 60)
;(0).A = cc.p(0, 0)
;(0).B = cc.p(120, 0)
local _ENV, (0).D, tblCfgDefaultN = cc.p(0, 60), cc.p(0, 60), 0
cc.p(0, 60).A = cc.p(0, 0)
cc.p(0, 60).B = cc.p(120, 0)
local _ENV, cc.p(0, 60).D, tblCfgDefaultW = cc.p(0, 60), cc.p(0, 60), cc.p(0, 60)
cc.p(0, 60).n = tblCfgDefaultN
cc.p(0, 60).s = tblCfgDefaultN
cc.p(0, 60).w = tblCfgDefaultN
cc.p(0, 60).e = tblCfgDefaultN
cc.p(0, 60).wn = tblCfgDefaultW
cc.p(0, 60).ws = tblCfgDefaultW
cc.p(0, 60).es = tblCfgDefaultW
cc.p(0, 60).en = tblCfgDefaultW
local _UPVALUE1_, _ENV, cc.p(0, 60).scale, tblCfgDefault = 60, 0, 1.0, cc.p(0, 60)
_UPVALUE2_, (0)[1], (60)[1] = 60, 60, 13
_UPVALUE3_, (0)[2], (60)[1] = 60, 60, 12
_UPVALUE3_, (0)[2], (60)[2] = 60, 60, 14
_UPVALUE4_, (0)[3], (60)[1] = 60, 60, 12
_UPVALUE4_, (0)[3], (60)[2] = 60, 60, 14
_UPVALUE4_, (0)[3], (60)[3] = 60, 60, 18
_UPVALUE5_, (0)[4], (60)[1] = 60, 60, 7
_UPVALUE5_, (0)[4], (60)[2] = 60, 60, 8
_UPVALUE5_, (0)[4], (60)[3] = 60, 60, 17
_UPVALUE5_, (0)[4], (60)[4] = 60, 60, 18
_UPVALUE6_, (0)[5], (60)[1] = 60, 60, 7
_UPVALUE6_, (0)[5], (60)[2] = 60, 60, 9
_UPVALUE6_, (0)[5], (60)[3] = 60, 60, 12
_UPVALUE6_, (0)[5], (60)[4] = 60, 60, 14
_UPVALUE6_, (0)[5], (60)[5] = 60, 60, 18
_UPVALUE7_, (0)[6], (60)[1] = 60, 60, 7
_UPVALUE7_, (0)[6], (60)[2] = 60, 60, 9
_UPVALUE7_, (0)[6], (60)[3] = 60, 60, 12
_UPVALUE7_, (0)[6], (60)[4] = 60, 60, 14
_UPVALUE7_, (0)[6], (60)[5] = 60, 60, 17
_UPVALUE7_, (0)[6], (60)[6] = 60, 60, 19
_UPVALUE1_, _ENV, (0)[7], (60)[1] = 7, 60, 60, 7
_UPVALUE1_, _ENV, (0)[7], (60)[2] = 7, 60, 60, 9
_UPVALUE1_, _ENV, (0)[7], (60)[3] = 7, 60, 60, 12
_UPVALUE1_, _ENV, (0)[7], (60)[4] = 7, 60, 60, 14
_UPVALUE1_, _ENV, (0)[7], (60)[5] = 7, 60, 60, 17
_UPVALUE1_, _ENV, (0)[7], (60)[6] = 7, 60, 60, 19
_UPVALUE1_, _ENV, (0)[7], (60)[7] = 7, 60, 60, 23
local TroopsMatrix_N = 0
_UPVALUE2_, (60)[1], (7)[1] = 7, 7, 13
_UPVALUE3_, (60)[2], (7)[1] = 7, 7, 12
_UPVALUE3_, (60)[2], (7)[2] = 7, 7, 14
_UPVALUE4_, (60)[3], (7)[1] = 7, 7, 8
_UPVALUE4_, (60)[3], (7)[2] = 7, 7, 12
_UPVALUE4_, (60)[3], (7)[3] = 7, 7, 14
_UPVALUE5_, (60)[4], (7)[1] = 7, 7, 7
_UPVALUE5_, (60)[4], (7)[2] = 7, 7, 8
_UPVALUE5_, (60)[4], (7)[3] = 7, 7, 17
_UPVALUE5_, (60)[4], (7)[4] = 7, 7, 18
_UPVALUE6_, (60)[5], (7)[1] = 7, 7, 3
_UPVALUE6_, (60)[5], (7)[2] = 7, 7, 7
_UPVALUE6_, (60)[5], (7)[3] = 7, 7, 9
_UPVALUE6_, (60)[5], (7)[4] = 7, 7, 12
_UPVALUE6_, (60)[5], (7)[5] = 7, 7, 14
_UPVALUE7_, (60)[6], (7)[1] = 7, 7, 7
_UPVALUE7_, (60)[6], (7)[2] = 7, 7, 9
_UPVALUE7_, (60)[6], (7)[3] = 7, 7, 12
_UPVALUE7_, (60)[6], (7)[4] = 7, 7, 14
_UPVALUE7_, (60)[6], (7)[5] = 7, 7, 17
_UPVALUE7_, (60)[6], (7)[6] = 7, 7, 19
_UPVALUE1_, _ENV, (60)[7], (7)[1] = 3, 7, 7, 3
_UPVALUE1_, _ENV, (60)[7], (7)[2] = 3, 7, 7, 7
_UPVALUE1_, _ENV, (60)[7], (7)[3] = 3, 7, 7, 9
_UPVALUE1_, _ENV, (60)[7], (7)[4] = 3, 7, 7, 12
_UPVALUE1_, _ENV, (60)[7], (7)[5] = 3, 7, 7, 14
_UPVALUE1_, _ENV, (60)[7], (7)[6] = 3, 7, 7, 17
_UPVALUE1_, _ENV, (60)[7], (7)[7] = 3, 7, 7, 19
local TroopsMatrix_S = 60
_UPVALUE2_, (7)[1], (3)[1] = 3, 3, 13
_UPVALUE3_, (7)[2], (3)[1] = 3, 3, 8
_UPVALUE3_, (7)[2], (3)[2] = 3, 3, 18
_UPVALUE4_, (7)[3], (3)[1] = 3, 3, 8
_UPVALUE4_, (7)[3], (3)[2] = 3, 3, 12
_UPVALUE4_, (7)[3], (3)[3] = 3, 3, 18
_UPVALUE5_, (7)[4], (3)[1] = 3, 3, 7
_UPVALUE5_, (7)[4], (3)[2] = 3, 3, 8
_UPVALUE5_, (7)[4], (3)[3] = 3, 3, 17
_UPVALUE5_, (7)[4], (3)[4] = 3, 3, 18
_UPVALUE6_, (7)[5], (3)[1] = 3, 3, 7
_UPVALUE6_, (7)[5], (3)[2] = 3, 3, 8
_UPVALUE6_, (7)[5], (3)[3] = 3, 3, 11
_UPVALUE6_, (7)[5], (3)[4] = 3, 3, 17
_UPVALUE6_, (7)[5], (3)[5] = 3, 3, 18
_UPVALUE7_, (7)[6], (3)[1] = 3, 3, 7
_UPVALUE7_, (7)[6], (3)[2] = 3, 3, 8
_UPVALUE7_, (7)[6], (3)[3] = 3, 3, 9
_UPVALUE7_, (7)[6], (3)[4] = 3, 3, 17
_UPVALUE7_, (7)[6], (3)[5] = 3, 3, 18
_UPVALUE7_, (7)[6], (3)[6] = 3, 3, 19
_UPVALUE1_, _ENV, (7)[7], (3)[1] = 7, 3, 3, 7
_UPVALUE1_, _ENV, (7)[7], (3)[2] = 7, 3, 3, 8
_UPVALUE1_, _ENV, (7)[7], (3)[3] = 7, 3, 3, 9
_UPVALUE1_, _ENV, (7)[7], (3)[4] = 7, 3, 3, 11
_UPVALUE1_, _ENV, (7)[7], (3)[5] = 7, 3, 3, 17
_UPVALUE1_, _ENV, (7)[7], (3)[6] = 7, 3, 3, 18
_UPVALUE1_, _ENV, (7)[7], (3)[7] = 7, 3, 3, 19
local TroopsMatrix_W = 7
_UPVALUE2_, (3)[1], (7)[1] = 7, 7, 13
_UPVALUE3_, (3)[2], (7)[1] = 7, 7, 8
_UPVALUE3_, (3)[2], (7)[2] = 7, 7, 18
_UPVALUE4_, (3)[3], (7)[1] = 7, 7, 8
_UPVALUE4_, (3)[3], (7)[2] = 7, 7, 14
_UPVALUE4_, (3)[3], (7)[3] = 7, 7, 18
_UPVALUE5_, (3)[4], (7)[1] = 7, 7, 7
_UPVALUE5_, (3)[4], (7)[2] = 7, 7, 8
_UPVALUE5_, (3)[4], (7)[3] = 7, 7, 17
_UPVALUE5_, (3)[4], (7)[4] = 7, 7, 18
_UPVALUE6_, (3)[5], (7)[1] = 7, 7, 7
_UPVALUE6_, (3)[5], (7)[2] = 7, 7, 8
_UPVALUE6_, (3)[5], (7)[3] = 7, 7, 14
_UPVALUE6_, (3)[5], (7)[4] = 7, 7, 17
_UPVALUE6_, (3)[5], (7)[5] = 7, 7, 18
_UPVALUE7_, (3)[6], (7)[1] = 7, 7, 7
_UPVALUE7_, (3)[6], (7)[2] = 7, 7, 8
_UPVALUE7_, (3)[6], (7)[3] = 7, 7, 9
_UPVALUE7_, (3)[6], (7)[4] = 7, 7, 17
_UPVALUE7_, (3)[6], (7)[5] = 7, 7, 18
_UPVALUE7_, (3)[6], (7)[6] = 7, 7, 19
_UPVALUE1_, _ENV, (3)[7], (7)[1] = 7, 7, 7, 7
_UPVALUE1_, _ENV, (3)[7], (7)[2] = 7, 7, 7, 8
_UPVALUE1_, _ENV, (3)[7], (7)[3] = 7, 7, 7, 9
_UPVALUE1_, _ENV, (3)[7], (7)[4] = 7, 7, 7, 15
_UPVALUE1_, _ENV, (3)[7], (7)[5] = 7, 7, 7, 17
_UPVALUE1_, _ENV, (3)[7], (7)[6] = 7, 7, 7, 18
_UPVALUE1_, _ENV, (3)[7], (7)[7] = 7, 7, 7, 19
local TroopsMatrix_E = 3
_UPVALUE2_, (7)[1], (7)[1] = 7, 7, 13
_UPVALUE3_, (7)[2], (7)[1] = 7, 7, 8
_UPVALUE3_, (7)[2], (7)[2] = 7, 7, 18
_UPVALUE4_, (7)[3], (7)[1] = 7, 7, 8
_UPVALUE4_, (7)[3], (7)[2] = 7, 7, 12
_UPVALUE4_, (7)[3], (7)[3] = 7, 7, 18
_UPVALUE5_, (7)[4], (7)[1] = 7, 7, 7
_UPVALUE5_, (7)[4], (7)[2] = 7, 7, 8
_UPVALUE5_, (7)[4], (7)[3] = 7, 7, 17
_UPVALUE5_, (7)[4], (7)[4] = 7, 7, 18
_UPVALUE6_, (7)[5], (7)[1] = 7, 7, 7
_UPVALUE6_, (7)[5], (7)[2] = 7, 7, 8
_UPVALUE6_, (7)[5], (7)[3] = 7, 7, 11
_UPVALUE6_, (7)[5], (7)[4] = 7, 7, 17
_UPVALUE6_, (7)[5], (7)[5] = 7, 7, 18
_UPVALUE7_, (7)[6], (7)[1] = 7, 7, 7
_UPVALUE7_, (7)[6], (7)[2] = 7, 7, 8
_UPVALUE7_, (7)[6], (7)[3] = 7, 7, 9
_UPVALUE7_, (7)[6], (7)[4] = 7, 7, 17
_UPVALUE7_, (7)[6], (7)[5] = 7, 7, 18
_UPVALUE7_, (7)[6], (7)[6] = 7, 7, 19
_UPVALUE1_, _ENV, (7)[7], (7)[1] = 7, 7, 7, 7
_UPVALUE1_, _ENV, (7)[7], (7)[2] = 7, 7, 7, 8
_UPVALUE1_, _ENV, (7)[7], (7)[3] = 7, 7, 7, 9
_UPVALUE1_, _ENV, (7)[7], (7)[4] = 7, 7, 7, 11
_UPVALUE1_, _ENV, (7)[7], (7)[5] = 7, 7, 7, 17
_UPVALUE1_, _ENV, (7)[7], (7)[6] = 7, 7, 7, 18
_UPVALUE1_, _ENV, (7)[7], (7)[7] = 7, 7, 7, 19
local TroopsMatrix_NW = 7
_UPVALUE2_, (7)[1], (7)[1] = 7, 7, 13
_UPVALUE3_, (7)[2], (7)[1] = 7, 7, 8
_UPVALUE3_, (7)[2], (7)[2] = 7, 7, 18
_UPVALUE4_, (7)[3], (7)[1] = 7, 7, 8
_UPVALUE4_, (7)[3], (7)[2] = 7, 7, 12
_UPVALUE4_, (7)[3], (7)[3] = 7, 7, 18
_UPVALUE5_, (7)[4], (7)[1] = 7, 7, 7
_UPVALUE5_, (7)[4], (7)[2] = 7, 7, 8
_UPVALUE5_, (7)[4], (7)[3] = 7, 7, 17
_UPVALUE5_, (7)[4], (7)[4] = 7, 7, 18
_UPVALUE6_, (7)[5], (7)[1] = 7, 7, 7
_UPVALUE6_, (7)[5], (7)[2] = 7, 7, 8
_UPVALUE6_, (7)[5], (7)[3] = 7, 7, 11
_UPVALUE6_, (7)[5], (7)[4] = 7, 7, 17
_UPVALUE6_, (7)[5], (7)[5] = 7, 7, 18
_UPVALUE7_, (7)[6], (7)[1] = 7, 7, 7
_UPVALUE7_, (7)[6], (7)[2] = 7, 7, 8
_UPVALUE7_, (7)[6], (7)[3] = 7, 7, 9
_UPVALUE7_, (7)[6], (7)[4] = 7, 7, 17
_UPVALUE7_, (7)[6], (7)[5] = 7, 7, 18
_UPVALUE7_, (7)[6], (7)[6] = 7, 7, 19
_UPVALUE1_, _ENV, (7)[7], (7)[1] = 7, 7, 7, 7
_UPVALUE1_, _ENV, (7)[7], (7)[2] = 7, 7, 7, 8
_UPVALUE1_, _ENV, (7)[7], (7)[3] = 7, 7, 7, 9
_UPVALUE1_, _ENV, (7)[7], (7)[4] = 7, 7, 7, 11
_UPVALUE1_, _ENV, (7)[7], (7)[5] = 7, 7, 7, 17
_UPVALUE1_, _ENV, (7)[7], (7)[6] = 7, 7, 7, 18
_UPVALUE1_, _ENV, (7)[7], (7)[7] = 7, 7, 7, 19
local TroopsMatrix_SW = 7
_UPVALUE2_, (7)[1], (7)[1] = 7, 7, 13
_UPVALUE3_, (7)[2], (7)[1] = 7, 7, 8
_UPVALUE3_, (7)[2], (7)[2] = 7, 7, 18
_UPVALUE4_, (7)[3], (7)[1] = 7, 7, 8
_UPVALUE4_, (7)[3], (7)[2] = 7, 7, 14
_UPVALUE4_, (7)[3], (7)[3] = 7, 7, 18
_UPVALUE5_, (7)[4], (7)[1] = 7, 7, 7
_UPVALUE5_, (7)[4], (7)[2] = 7, 7, 8
_UPVALUE5_, (7)[4], (7)[3] = 7, 7, 17
_UPVALUE5_, (7)[4], (7)[4] = 7, 7, 18
_UPVALUE6_, (7)[5], (7)[1] = 7, 7, 7
_UPVALUE6_, (7)[5], (7)[2] = 7, 7, 8
_UPVALUE6_, (7)[5], (7)[3] = 7, 7, 14
_UPVALUE6_, (7)[5], (7)[4] = 7, 7, 17
_UPVALUE6_, (7)[5], (7)[5] = 7, 7, 18
_UPVALUE7_, (7)[6], (7)[1] = 7, 7, 7
_UPVALUE7_, (7)[6], (7)[2] = 7, 7, 8
_UPVALUE7_, (7)[6], (7)[3] = 7, 7, 9
_UPVALUE7_, (7)[6], (7)[4] = 7, 7, 17
_UPVALUE7_, (7)[6], (7)[5] = 7, 7, 18
_UPVALUE7_, (7)[6], (7)[6] = 7, 7, 19
_UPVALUE1_, _ENV, (7)[7], (7)[1] = 7, 7, 7, 7
_UPVALUE1_, _ENV, (7)[7], (7)[2] = 7, 7, 7, 8
_UPVALUE1_, _ENV, (7)[7], (7)[3] = 7, 7, 7, 9
_UPVALUE1_, _ENV, (7)[7], (7)[4] = 7, 7, 7, 15
_UPVALUE1_, _ENV, (7)[7], (7)[5] = 7, 7, 7, 17
_UPVALUE1_, _ENV, (7)[7], (7)[6] = 7, 7, 7, 18
_UPVALUE1_, _ENV, (7)[7], (7)[7] = 7, 7, 7, 19
local TroopsMatrix_SE = 7
_UPVALUE2_, (7)[1], (7)[1] = 7, 7, 13
_UPVALUE3_, (7)[2], (7)[1] = 7, 7, 8
_UPVALUE3_, (7)[2], (7)[2] = 7, 7, 18
_UPVALUE4_, (7)[3], (7)[1] = 7, 7, 8
_UPVALUE4_, (7)[3], (7)[2] = 7, 7, 14
_UPVALUE4_, (7)[3], (7)[3] = 7, 7, 18
_UPVALUE5_, (7)[4], (7)[1] = 7, 7, 7
_UPVALUE5_, (7)[4], (7)[2] = 7, 7, 8
_UPVALUE5_, (7)[4], (7)[3] = 7, 7, 17
_UPVALUE5_, (7)[4], (7)[4] = 7, 7, 18
_UPVALUE6_, (7)[5], (7)[1] = 7, 7, 7
_UPVALUE6_, (7)[5], (7)[2] = 7, 7, 8
_UPVALUE6_, (7)[5], (7)[3] = 7, 7, 14
_UPVALUE6_, (7)[5], (7)[4] = 7, 7, 17
_UPVALUE6_, (7)[5], (7)[5] = 7, 7, 18
_UPVALUE7_, (7)[6], (7)[1] = 7, 7, 7
_UPVALUE7_, (7)[6], (7)[2] = 7, 7, 8
_UPVALUE7_, (7)[6], (7)[3] = 7, 7, 9
_UPVALUE7_, (7)[6], (7)[4] = 7, 7, 17
_UPVALUE7_, (7)[6], (7)[5] = 7, 7, 18
_UPVALUE7_, (7)[6], (7)[6] = 7, 7, 19
_ENV, (7)[7], (7)[1] = 7, 7, 7
_ENV, (7)[7], (7)[2] = 7, 7, 8
_ENV, (7)[7], (7)[3] = 7, 7, 9
_ENV, (7)[7], (7)[4] = 7, 7, 15
_ENV, (7)[7], (7)[5] = 7, 7, 17
_ENV, (7)[7], (7)[6] = 7, 7, 18
_ENV, (7)[7], (7)[7] = 7, 7, 19
local TroopsMatrix_NE = 7
;(7).n = TroopsMatrix_N
;(7).s = TroopsMatrix_S
;(7).w = TroopsMatrix_W
;(7).e = TroopsMatrix_E
;(7).wn = TroopsMatrix_NW
;(7).ws = TroopsMatrix_SW
;(7).es = TroopsMatrix_SE
local _UPVALUE1_, _ENV, (7).en, TroopsMatrix = 8, 7, TroopsMatrix_NE, 7
_UPVALUE2_, (7)[1], (8)[1] = 8, 8, 13
_UPVALUE3_, (7)[2], (8)[1] = 8, 8, 13
_UPVALUE3_, (7)[2], (8)[2] = 8, 8, 14
_UPVALUE4_, (7)[3], (8)[1] = 8, 8, 13
_UPVALUE4_, (7)[3], (8)[2] = 8, 8, 14
_UPVALUE4_, (7)[3], (8)[3] = 8, 8, 15
_UPVALUE5_, (7)[4], (8)[1] = 8, 8, 13
_UPVALUE5_, (7)[4], (8)[2] = 8, 8, 14
_UPVALUE5_, (7)[4], (8)[3] = 8, 8, 15
_UPVALUE5_, (7)[4], (8)[4] = 8, 8, 16
_UPVALUE6_, (7)[5], (8)[1] = 8, 8, 13
_UPVALUE6_, (7)[5], (8)[2] = 8, 8, 14
_UPVALUE6_, (7)[5], (8)[3] = 8, 8, 15
_UPVALUE6_, (7)[5], (8)[4] = 8, 8, 16
_UPVALUE6_, (7)[5], (8)[5] = 8, 8, 17
_UPVALUE7_, (7)[6], (8)[1] = 8, 8, 13
_UPVALUE7_, (7)[6], (8)[2] = 8, 8, 14
_UPVALUE7_, (7)[6], (8)[3] = 8, 8, 15
_UPVALUE7_, (7)[6], (8)[4] = 8, 8, 16
_UPVALUE7_, (7)[6], (8)[5] = 8, 8, 17
_UPVALUE7_, (7)[6], (8)[6] = 8, 8, 18
_UPVALUE8_, (7)[7], (8)[1] = 8, 8, 13
_UPVALUE8_, (7)[7], (8)[2] = 8, 8, 14
_UPVALUE8_, (7)[7], (8)[3] = 8, 8, 15
_UPVALUE8_, (7)[7], (8)[4] = 8, 8, 16
_UPVALUE8_, (7)[7], (8)[5] = 8, 8, 17
_UPVALUE8_, (7)[7], (8)[6] = 8, 8, 18
_UPVALUE8_, (7)[7], (8)[7] = 8, 8, 7
_UPVALUE9_, (7)[8], (8)[1] = 8, 8, 13
_UPVALUE9_, (7)[8], (8)[2] = 8, 8, 14
_UPVALUE9_, (7)[8], (8)[3] = 8, 8, 15
_UPVALUE9_, (7)[8], (8)[4] = 8, 8, 16
_UPVALUE9_, (7)[8], (8)[5] = 8, 8, 17
_UPVALUE9_, (7)[8], (8)[6] = 8, 8, 18
_UPVALUE9_, (7)[8], (8)[7] = 8, 8, 7
_UPVALUE9_, (7)[8], (8)[8] = 8, 8, 8
_UPVALUE10_, (7)[9], (8)[1] = 8, 8, 13
_UPVALUE10_, (7)[9], (8)[2] = 8, 8, 14
_UPVALUE10_, (7)[9], (8)[3] = 8, 8, 15
_UPVALUE10_, (7)[9], (8)[4] = 8, 8, 16
_UPVALUE10_, (7)[9], (8)[5] = 8, 8, 17
_UPVALUE10_, (7)[9], (8)[6] = 8, 8, 18
_UPVALUE10_, (7)[9], (8)[7] = 8, 8, 7
_UPVALUE10_, (7)[9], (8)[8] = 8, 8, 8
_UPVALUE10_, (7)[9], (8)[9] = 8, 8, 9
_UPVALUE11_, (7)[10], (8)[1] = 8, 8, 13
_UPVALUE11_, (7)[10], (8)[2] = 8, 8, 14
_UPVALUE11_, (7)[10], (8)[3] = 8, 8, 15
_UPVALUE11_, (7)[10], (8)[4] = 8, 8, 16
_UPVALUE11_, (7)[10], (8)[5] = 8, 8, 17
_UPVALUE11_, (7)[10], (8)[6] = 8, 8, 18
_UPVALUE11_, (7)[10], (8)[7] = 8, 8, 7
_UPVALUE11_, (7)[10], (8)[8] = 8, 8, 8
_UPVALUE11_, (7)[10], (8)[9] = 8, 8, 9
_UPVALUE11_, (7)[10], (8)[10] = 8, 8, 10
_UPVALUE12_, (7)[11], (8)[1] = 8, 8, 13
_UPVALUE12_, (7)[11], (8)[2] = 8, 8, 14
_UPVALUE12_, (7)[11], (8)[3] = 8, 8, 15
_UPVALUE12_, (7)[11], (8)[4] = 8, 8, 16
_UPVALUE12_, (7)[11], (8)[5] = 8, 8, 17
_UPVALUE12_, (7)[11], (8)[6] = 8, 8, 18
_UPVALUE12_, (7)[11], (8)[7] = 8, 8, 7
_UPVALUE12_, (7)[11], (8)[8] = 8, 8, 8
_UPVALUE12_, (7)[11], (8)[9] = 8, 8, 9
_UPVALUE12_, (7)[11], (8)[10] = 8, 8, 10
_UPVALUE12_, (7)[11], (8)[11] = 8, 8, 11
_UPVALUE13_, (7)[12], (8)[1] = 8, 8, 13
_UPVALUE13_, (7)[12], (8)[2] = 8, 8, 14
_UPVALUE13_, (7)[12], (8)[3] = 8, 8, 15
_UPVALUE13_, (7)[12], (8)[4] = 8, 8, 16
_UPVALUE13_, (7)[12], (8)[5] = 8, 8, 17
_UPVALUE13_, (7)[12], (8)[6] = 8, 8, 18
_UPVALUE13_, (7)[12], (8)[7] = 8, 8, 7
_UPVALUE13_, (7)[12], (8)[8] = 8, 8, 8
_UPVALUE13_, (7)[12], (8)[9] = 8, 8, 9
_UPVALUE13_, (7)[12], (8)[10] = 8, 8, 10
_UPVALUE13_, (7)[12], (8)[11] = 8, 8, 11
_UPVALUE13_, (7)[12], (8)[12] = 8, 8, 12
_UPVALUE14_, (7)[13], (8)[1] = 8, 8, 13
_UPVALUE14_, (7)[13], (8)[2] = 8, 8, 14
_UPVALUE14_, (7)[13], (8)[3] = 8, 8, 15
_UPVALUE14_, (7)[13], (8)[4] = 8, 8, 16
_UPVALUE14_, (7)[13], (8)[5] = 8, 8, 17
_UPVALUE14_, (7)[13], (8)[6] = 8, 8, 18
_UPVALUE14_, (7)[13], (8)[7] = 8, 8, 7
_UPVALUE14_, (7)[13], (8)[8] = 8, 8, 8
_UPVALUE14_, (7)[13], (8)[9] = 8, 8, 9
_UPVALUE14_, (7)[13], (8)[10] = 8, 8, 10
_UPVALUE14_, (7)[13], (8)[11] = 8, 8, 11
_UPVALUE14_, (7)[13], (8)[12] = 8, 8, 12
_UPVALUE14_, (7)[13], (8)[13] = 8, 8, 1
_UPVALUE15_, (7)[14], (8)[1] = 8, 8, 13
_UPVALUE15_, (7)[14], (8)[2] = 8, 8, 14
_UPVALUE15_, (7)[14], (8)[3] = 8, 8, 15
_UPVALUE15_, (7)[14], (8)[4] = 8, 8, 16
_UPVALUE15_, (7)[14], (8)[5] = 8, 8, 17
_UPVALUE15_, (7)[14], (8)[6] = 8, 8, 18
_UPVALUE15_, (7)[14], (8)[7] = 8, 8, 7
_UPVALUE15_, (7)[14], (8)[8] = 8, 8, 8
_UPVALUE15_, (7)[14], (8)[9] = 8, 8, 9
_UPVALUE15_, (7)[14], (8)[10] = 8, 8, 10
_UPVALUE15_, (7)[14], (8)[11] = 8, 8, 11
_UPVALUE15_, (7)[14], (8)[12] = 8, 8, 12
_UPVALUE15_, (7)[14], (8)[13] = 8, 8, 1
_UPVALUE15_, (7)[14], (8)[14] = 8, 8, 2
_UPVALUE16_, (7)[15], (8)[1] = 8, 8, 13
_UPVALUE16_, (7)[15], (8)[2] = 8, 8, 14
_UPVALUE16_, (7)[15], (8)[3] = 8, 8, 15
_UPVALUE16_, (7)[15], (8)[4] = 8, 8, 16
_UPVALUE16_, (7)[15], (8)[5] = 8, 8, 17
_UPVALUE16_, (7)[15], (8)[6] = 8, 8, 18
_UPVALUE16_, (7)[15], (8)[7] = 8, 8, 7
_UPVALUE16_, (7)[15], (8)[8] = 8, 8, 8
_UPVALUE16_, (7)[15], (8)[9] = 8, 8, 9
_UPVALUE16_, (7)[15], (8)[10] = 8, 8, 10
_UPVALUE16_, (7)[15], (8)[11] = 8, 8, 11
_UPVALUE16_, (7)[15], (8)[12] = 8, 8, 12
_UPVALUE16_, (7)[15], (8)[13] = 8, 8, 1
_UPVALUE16_, (7)[15], (8)[14] = 8, 8, 2
_UPVALUE16_, (7)[15], (8)[15] = 8, 8, 3
_UPVALUE17_, (7)[16], (8)[1] = 8, 8, 13
_UPVALUE17_, (7)[16], (8)[2] = 8, 8, 14
_UPVALUE17_, (7)[16], (8)[3] = 8, 8, 15
_UPVALUE17_, (7)[16], (8)[4] = 8, 8, 16
_UPVALUE17_, (7)[16], (8)[5] = 8, 8, 17
_UPVALUE17_, (7)[16], (8)[6] = 8, 8, 18
_UPVALUE17_, (7)[16], (8)[7] = 8, 8, 7
_UPVALUE17_, (7)[16], (8)[8] = 8, 8, 8
_UPVALUE17_, (7)[16], (8)[9] = 8, 8, 9
_UPVALUE17_, (7)[16], (8)[10] = 8, 8, 10
_UPVALUE17_, (7)[16], (8)[11] = 8, 8, 11
_UPVALUE17_, (7)[16], (8)[12] = 8, 8, 12
_UPVALUE17_, (7)[16], (8)[13] = 8, 8, 1
_UPVALUE17_, (7)[16], (8)[14] = 8, 8, 2
_UPVALUE17_, (7)[16], (8)[15] = 8, 8, 3
_UPVALUE17_, (7)[16], (8)[16] = 8, 8, 4
_UPVALUE17_, (7)[17], (8)[1] = 8, 8, 13
_UPVALUE17_, (7)[17], (8)[2] = 8, 8, 14
_UPVALUE17_, (7)[17], (8)[3] = 8, 8, 15
_UPVALUE17_, (7)[17], (8)[4] = 8, 8, 16
_UPVALUE17_, (7)[17], (8)[5] = 8, 8, 17
_UPVALUE17_, (7)[17], (8)[6] = 8, 8, 18
_UPVALUE17_, (7)[17], (8)[7] = 8, 8, 7
_UPVALUE17_, (7)[17], (8)[8] = 8, 8, 8
_UPVALUE17_, (7)[17], (8)[9] = 8, 8, 9
_UPVALUE17_, (7)[17], (8)[10] = 8, 8, 10
_UPVALUE17_, (7)[17], (8)[11] = 8, 8, 11
_UPVALUE17_, (7)[17], (8)[12] = 8, 8, 12
_UPVALUE17_, (7)[17], (8)[13] = 8, 8, 1
_UPVALUE17_, (7)[17], (8)[14] = 8, 8, 2
_UPVALUE17_, (7)[17], (8)[15] = 8, 8, 3
_UPVALUE17_, (7)[17], (8)[16] = 8, 8, 4
_UPVALUE17_, (7)[17], (8)[17] = 8, 8, 5
_UPVALUE1_, _ENV, (7)[18], (8)[1] = 13, 8, 8, 13
_UPVALUE1_, _ENV, (7)[18], (8)[2] = 13, 8, 8, 14
_UPVALUE1_, _ENV, (7)[18], (8)[3] = 13, 8, 8, 15
_UPVALUE1_, _ENV, (7)[18], (8)[4] = 13, 8, 8, 16
_UPVALUE1_, _ENV, (7)[18], (8)[5] = 13, 8, 8, 17
_UPVALUE1_, _ENV, (7)[18], (8)[6] = 13, 8, 8, 18
_UPVALUE1_, _ENV, (7)[18], (8)[7] = 13, 8, 8, 7
_UPVALUE1_, _ENV, (7)[18], (8)[8] = 13, 8, 8, 8
_UPVALUE1_, _ENV, (7)[18], (8)[9] = 13, 8, 8, 9
_UPVALUE1_, _ENV, (7)[18], (8)[10] = 13, 8, 8, 10
_UPVALUE1_, _ENV, (7)[18], (8)[11] = 13, 8, 8, 11
_UPVALUE1_, _ENV, (7)[18], (8)[12] = 13, 8, 8, 12
_UPVALUE1_, _ENV, (7)[18], (8)[13] = 13, 8, 8, 1
_UPVALUE1_, _ENV, (7)[18], (8)[14] = 13, 8, 8, 2
_UPVALUE1_, _ENV, (7)[18], (8)[15] = 13, 8, 8, 3
_UPVALUE1_, _ENV, (7)[18], (8)[16] = 13, 8, 8, 4
_UPVALUE1_, _ENV, (7)[18], (8)[17] = 13, 8, 8, 5
_UPVALUE1_, _ENV, (7)[18], (8)[18] = 13, 8, 8, 6
local SoldierMatrix_BuGongbing = 7
_UPVALUE2_, (8)[1], (13)[1] = 13, 13, 6
_UPVALUE3_, (8)[2], (13)[1] = 13, 13, 6
_UPVALUE3_, (8)[2], (13)[2] = 13, 13, 7
_UPVALUE4_, (8)[3], (13)[1] = 13, 13, 6
_UPVALUE4_, (8)[3], (13)[2] = 13, 13, 7
_UPVALUE4_, (8)[3], (13)[3] = 13, 13, 8
_UPVALUE5_, (8)[4], (13)[1] = 13, 13, 6
_UPVALUE5_, (8)[4], (13)[2] = 13, 13, 7
_UPVALUE5_, (8)[4], (13)[3] = 13, 13, 8
_UPVALUE5_, (8)[4], (13)[4] = 13, 13, 9
_UPVALUE6_, (8)[5], (13)[1] = 13, 13, 6
_UPVALUE6_, (8)[5], (13)[2] = 13, 13, 7
_UPVALUE6_, (8)[5], (13)[3] = 13, 13, 8
_UPVALUE6_, (8)[5], (13)[4] = 13, 13, 9
_UPVALUE6_, (8)[5], (13)[5] = 13, 13, 10
_UPVALUE7_, (8)[6], (13)[1] = 13, 13, 6
_UPVALUE7_, (8)[6], (13)[2] = 13, 13, 7
_UPVALUE7_, (8)[6], (13)[3] = 13, 13, 8
_UPVALUE7_, (8)[6], (13)[4] = 13, 13, 9
_UPVALUE7_, (8)[6], (13)[5] = 13, 13, 10
_UPVALUE7_, (8)[6], (13)[6] = 13, 13, 1
_UPVALUE8_, (8)[7], (13)[1] = 13, 13, 6
_UPVALUE8_, (8)[7], (13)[2] = 13, 13, 7
_UPVALUE8_, (8)[7], (13)[3] = 13, 13, 8
_UPVALUE8_, (8)[7], (13)[4] = 13, 13, 9
_UPVALUE8_, (8)[7], (13)[5] = 13, 13, 10
_UPVALUE8_, (8)[7], (13)[6] = 13, 13, 1
_UPVALUE8_, (8)[7], (13)[7] = 13, 13, 2
_UPVALUE9_, (8)[8], (13)[1] = 13, 13, 6
_UPVALUE9_, (8)[8], (13)[2] = 13, 13, 7
_UPVALUE9_, (8)[8], (13)[3] = 13, 13, 8
_UPVALUE9_, (8)[8], (13)[4] = 13, 13, 9
_UPVALUE9_, (8)[8], (13)[5] = 13, 13, 10
_UPVALUE9_, (8)[8], (13)[6] = 13, 13, 1
_UPVALUE9_, (8)[8], (13)[7] = 13, 13, 2
_UPVALUE9_, (8)[8], (13)[8] = 13, 13, 3
_UPVALUE10_, (8)[9], (13)[1] = 13, 13, 6
_UPVALUE10_, (8)[9], (13)[2] = 13, 13, 7
_UPVALUE10_, (8)[9], (13)[3] = 13, 13, 8
_UPVALUE10_, (8)[9], (13)[4] = 13, 13, 9
_UPVALUE10_, (8)[9], (13)[5] = 13, 13, 10
_UPVALUE10_, (8)[9], (13)[6] = 13, 13, 1
_UPVALUE10_, (8)[9], (13)[7] = 13, 13, 2
_UPVALUE10_, (8)[9], (13)[8] = 13, 13, 3
_UPVALUE10_, (8)[9], (13)[9] = 13, 13, 4
_UPVALUE1_, _ENV, (8)[10], (13)[1] = 6, 13, 13, 6
_UPVALUE1_, _ENV, (8)[10], (13)[2] = 6, 13, 13, 7
_UPVALUE1_, _ENV, (8)[10], (13)[3] = 6, 13, 13, 8
_UPVALUE1_, _ENV, (8)[10], (13)[4] = 6, 13, 13, 9
_UPVALUE1_, _ENV, (8)[10], (13)[5] = 6, 13, 13, 10
_UPVALUE1_, _ENV, (8)[10], (13)[6] = 6, 13, 13, 1
_UPVALUE1_, _ENV, (8)[10], (13)[7] = 6, 13, 13, 2
_UPVALUE1_, _ENV, (8)[10], (13)[8] = 6, 13, 13, 3
_UPVALUE1_, _ENV, (8)[10], (13)[9] = 6, 13, 13, 4
_UPVALUE1_, _ENV, (8)[10], (13)[10] = 6, 13, 13, 5
local SoldierMatrix_Qibing = 8
_UPVALUE2_, (13)[1], (6)[1] = 6, 6, 1
_UPVALUE1_, _ENV, (13)[2], (6)[1] = 1, 6, 6, 1
_UPVALUE1_, _ENV, (13)[2], (6)[2] = 1, 6, 6, 2
local SoldierMatrix_Chebing = 13
_UPVALUE2_, (6)[1], (1)[1] = 1, 1, 1
_ENV, _ENV, (6)[2], (1)[1] = 1, 1, 1, 1
_ENV, _ENV, (6)[2], (1)[2] = 1, 1, 1, 2
local SoldierMatrix_Elite = 6
;(1).x = -20
_ENV, (1)[1], (1).y = 1, 1, 10
;(1).x = -80
;(1)[2], (1).y = 1, 40
local SoldierMatrix_Elite_Offset = 1
function cityBuildTroopsMatrix:ctor()
	local layerColor = cc.Layer:create()
	layerColor:setContentSize(200, 100)
	layerColor:addTo(self, 1)
	layerColor:ignoreAnchorPointForPosition(false)
	layerColor:setAnchorPoint(cc.p(0.5, 0.5))
	layerColor:setPosition(0, 0)
	self.graphNode = layerColor
	self:setTouchEnabled(false)
	self:setTouchChildrenEnabled(false)
	self.soldierPosArray, _ENV, self.soldiersArray, _ENV = self.setTouchChildrenEnabled, self.setTouchChildrenEnabled, self.setTouchChildrenEnabled, self.setTouchChildrenEnabled
	self.soldierNumber = 1
	self.realSoldierNumber = 0
	self.soldierType = 1
	self.row = 3
	self.col = 3
	self.bid = 0
	self.buildIndex = 0
	self.isShowParallelgram = false
	self.paddingColX = 0
	self.paddingRowY = 0
	self.A = cc.p(0, 0)
	self.B = cc.p(100, 30)
	self.D = cc.p(30, 110)
	self.targetPointsArray, _ENV, self.speed = cc.p(30, 110), cc.p(30, 110), 160
	self.currentBeginPoint = cc.p(0, 0)
	self.currentEndPoint = cc.p(0, 0)
	self.currentStepIndex = 1
	self.isTroopMatrix = true
	self.isMatrixPosDirty = true
	self.cachePointsArray = nil
	self.isSoldiersPosDirty = true
	self.cacheSoldierPosArray = nil
	self.cacheType = nil
end
function cityBuildTroopsMatrix:troop(pointsArray)
	self.targetPointsArray = pointsArray
	self.currentStepIndex = 1
	self:troopStep()
end
function cityBuildTroopsMatrix:troopStep()
	if self.targetPointsArray == nil then
		return
	end
	if self.currentStepIndex < #self.targetPointsArray then
		local beginPoint = self.targetPointsArray[self.currentStepIndex]
		local endPoint = self.targetPointsArray[self.currentStepIndex + 1]
		local worldMapFunction = include("worldMapFunction")
		local worldMapDefine = include("worldMapDefine")
		local rotation, imgNameAngle, isFlipX, moveAngle = worldMapFunction.getSoliderImgAngel(beginPoint, endPoint)
		local angle = self:getAngleName(imgNameAngle, isFlipX)
		self:updateSoldierPos(angle)
		self:updateSoldierAnimation(imgNameAngle, isFlipX)
		local distance = cc.pGetDistance(beginPoint, endPoint)
		local dt = distance / self.speed
		self:setPosition(beginPoint.x, beginPoint.y)
		self:setLocalZOrder(beginPoint.z)
		local actMove = cca.moveTo(dt, endPoint.x, endPoint.y)
		local actFunc = cca.callFunc(handler(self, self.troopStep))
		_UPVALUE2_ = handler(self, self.troopStep)
		handler(self, self.troopStep)[1] = actMove
		handler(self, self.troopStep)[2] = actFunc
		local actSeq = cca.seq(handler(self, self.troopStep))
		self:runAction(actSeq)
		self.currentStepIndex = self.currentStepIndex + 1
	else
		for i = 1, #self.soldiersArray do
			local soldier = self.soldiersArray[i]
			if nil == soldier then
				break
			end
			soldier:stopAllActions()
			self:recycleSoldiers()
			self:removeFromParent()
			_ENV = self
			self.msg = "MESSAGE_MAINCITYVIEW_UPDATE_SOLDIER_MATRIXS"
			self.bid = self.bid
			SoraDSendMessage(self)
		end
	end
end
function cityBuildTroopsMatrix:updateSoldierPos(angle)
	self.soldierPosArray = self:getSoldierPointArray(angle)
	if true == self.isShowParallelgram and not self.isCustom then
		self.graphNode:removeAllChildren()
		self:drawParallelogram(self.graphNode, self.row, self.col, self.A, self.B, self.D, self.paddingColX, self.paddingRowY)
	end
	local soldierIndex = 1
	local TroopsMatrix, soldierTroopMatrix = self, self
	if self.isTroopMatrix == true then
		soldierTroopMatrix = TroopsMatrix[angle][self.soldierNumber]
	elseif self.bid == BUILDID.CHARIOT_PLANT then
		soldierTroopMatrix = SoldierMatrix_BuGongbing[self.soldierNumber]
	elseif self.bid == BUILDID.STABLES then
		soldierTroopMatrix = SoldierMatrix_Qibing[self.soldierNumber]
	elseif self.bid == BUILDID.RANGE then
		soldierTroopMatrix = SoldierMatrix_BuGongbing[self.soldierNumber]
	elseif self.bid == BUILDID.BARRACKS then
		soldierTroopMatrix = SoldierMatrix_Chebing[self.soldierNumber]
	elseif self.bid == BUILDID.ELITE_PALACE then
		soldierTroopMatrix = SoldierMatrix_Elite[self.soldierNumber]
	end
	if soldierTroopMatrix == nil then
		return
	end
	for i = 1, #soldierTroopMatrix do
		local soldier = self.soldiersArray[soldierIndex]
		if soldier ~= nil then
			local pos = soldierTroopMatrix[i]
			if pos > #self.soldierPosArray then
				print("out of range !!--------------------")
				return
			end
			if self.bid == BUILDID.ELITE_PALACE and self.isTroopMatrix == false then
				soldier:setPosition(self.soldierPosArray[pos].x + SoldierMatrix_Elite_Offset[i].x, self.soldierPosArray[pos].y + SoldierMatrix_Elite_Offset[i].y)
			else
				soldier:setPosition(self.soldierPosArray[pos].x, self.soldierPosArray[pos].y)
			end
			local yIndex = math.floor((pos - 1) / self.col)
			local xIndex = math.fmod(pos - 1, self.col)
			local zOrder = self.row * self.col + 10 - yIndex * self.col + xIndex
			soldier:setLocalZOrder(zOrder)
		end
		soldierIndex = soldierIndex + 1
	end
end
function cityBuildTroopsMatrix:updateSoldierAnimation(imgNameAngle, isFlipX)
	local worldMapFunction = include("worldMapFunction")
	local worldMapDefine = include("worldMapDefine")
	for i = 1, #self.soldiersArray do
		local soldier = self.soldiersArray[i]
		if nil == soldier then
			break
		end
		soldier:stopAllActions()
		local frames = display.newFrames(worldMapDefine.getSoliderImageNameByType(self.soldierType) .. "_yd_" .. imgNameAngle .. "_0%d.png", 1, 8)
		local animation = display.newAnimation(frames, 0.125)
		soldier:playAnimationForever(animation)
		soldier:setFlippedX(isFlipX)
	end
end
function cityBuildTroopsMatrix:initWithUIType(uiType)
	self.uiType = uiType
	if uiType == cityBuildConstDef.uiType.UI_TYPE_ALONE then
		local node = display.newNode()
		self:addChild(node, 2)
		node:setAnchorPoint(cc.p(0.5, 0.5))
		node:setPosition(cc.p(0, 0))
		self.ContentNode = node
	elseif uiType == cityBuildConstDef.uiType.UI_TYPE_RELYON then
		local node = display.newNode()
		self:addChild(node, 2)
		node:setAnchorPoint(cc.p(0.5, 0.5))
		node:setPosition(cc.p(0, 0))
		self.ContentNode = node
	end
end
function cityBuildTroopsMatrix:initWithTroopsData(data)
	self.soldierPosArray, _ENV, self.soldiersArray, _ENV = nil, nil, nil, nil
	self.soldierNumber = 6
	self.soldierType = 1
	self.row = 3
	self.col = 3
	self.isCustom = data.isCustom
	self.A = cc.p(0, 0)
	self.B = cc.p(100, 10)
	self.D = cc.p(30, 60)
	self.targetPointsArray, _ENV, self.speed = cc.p(30, 60), cc.p(30, 60), 50
	self.currentBeginPoint = cc.p(0, 0)
	self.currentEndPoint = cc.p(0, 0)
	self.currentStepIndex = 1
	local worldMapFunction = include("worldMapFunction")
	local worldMapDefine = include("worldMapDefine")
	local bid = tonumber(data.bid)
	local soldierType = worldMapDefine.soldierType_BuBing
	local tblCfg = tblCfgDefault
	if bid == BUILDID.CHARIOT_PLANT then
		soldierType = worldMapDefine.soldierType_BuBing
		tblCfg = tblCfgBuGongbing
	elseif bid == BUILDID.STABLES then
		soldierType = worldMapDefine.soldierType_QiBing
		tblCfg = tblCfgQibing
	elseif bid == BUILDID.RANGE then
		soldierType = worldMapDefine.soldierType_GongjianBing
		tblCfg = tblCfgBuGongbing
	elseif bid == BUILDID.BARRACKS then
		soldierType = worldMapDefine.soldierType_ZhanChe
		tblCfg = tblCfgChebing
	elseif bid == BUILDID.ELITE_PALACE then
		soldierType = worldMapDefine.soldierType_JingYing
		tblCfg = tblCfgElite
	end
	self.A = tblCfg.A
	self.B = tblCfg.B
	self.D = tblCfg.D
	self.scaleSoldier = tblCfg.scale
	self.bid = bid
	self.soldierType = soldierType
	self.soldierNumber = data.soldierNumber
	self.realSoldierNumber = data.realSoldierNumber
	if self.realSoldierNumber ~= nil then
		self.soldierNumber = self:getConvertedSoldierNumber(self.realSoldierNumber)
		if soldierType == worldMapDefine.soldierType_ZhanChe or soldierType == worldMapDefine.soldierType_JingYing then
			self.soldierNumber = math.min(self.soldierNumber, 6)
		end
	end
	self.targetPointsArray = data.targetPointsArray
	self.A = data.A or self.A or cc.p(0, 0)
	self.B = data.B or self.B or cc.p(100, 0)
	self.D = data.D or self.D or cc.p(30, 80)
	self.scaleSoldier = data.scale or self.scaleSoldier or 1.0
	self.speed = data.speed or self.speed or 160
	self.row = data.row or 3
	self.col = data.col or 3
	self.isShowParallelgram = data.isShowParallelgram or false
	self.isTroopMatrix = data.isTroopMatrix
	if self.isTroopMatrix == nil then
		self.isTroopMatrix = true
	end
	if self.isTroopMatrix == false then
		self.scaleSoldier = 1.0
	end
	if self.isTroopMatrix == false and bid == BUILDID.ELITE_PALACE then
		self.scaleSoldier = data.scale or 1.0
	end
	self.paddingColX = data.paddingColX or self.paddingColX or 0
	self.paddingRowY = data.paddingRowY or self.paddingRowY or 0
	self:createSodiers(self.soldierType, self.soldierNumber)
	self.C = cc.p(self.D.x + self.B.x - self.A.x, self.D.y + self.B.y - self.A.y)
	local xMax = math.max(self.A.x, self.B.x, self.C.x, self.D.x)
	local xMin = math.min(self.A.x, self.B.x, self.C.x, self.D.x)
	local yMax = math.max(self.A.y, self.B.y, self.C.y, self.D.y)
	local yMin = math.min(self.A.y, self.B.y, self.C.y, self.D.y)
	local contentNodeSize = cc.size(math.abs(xMax - xMin), math.abs(yMax - yMin))
	self.ContentNode:setContentSize(contentNodeSize.width, contentNodeSize.height)
	self.ContentNode:setAnchorPoint(cc.p(0.5, 0.5))
	self.ContentNode:setPosition(cc.p(0, 0))
	if self.ContentNodeColor then
		self.ContentNodeColor:setContentSize(contentNodeSize.width, contentNodeSize.height)
	end
	self.graphNode:setContentSize(contentNodeSize.width, contentNodeSize.height)
	self.graphNode:setAnchorPoint(cc.p(0.5, 0.5))
	self.graphNode:setPosition(cc.p(0, 0))
	if true == self.isShowParallelgram then
		self:drawParallelogram(self.graphNode, self.row, self.col, self.A, self.B, self.D, self.paddingColX, self.paddingRowY)
	end
	self:updateSoldierPos("wn")
end
function cityBuildTroopsMatrix:createSodiers(soldierType, numberOfSodiers)
	for i = 1, #self.soldiersArray do
		if self.soldiersArray[i] ~= nil then
			if nil ~= self.soldiersArray[i]:getParent() then
				self.soldiersArray[i]:removeFromParent()
			end
			self.soldiersArray[i] = nil
		end
	end
	local worldMapFunction = include("worldMapFunction")
	local worldMapDefine = include("worldMapDefine")
	for i = 1, numberOfSodiers do
		local soldier, isNeedRelease
		if soldierType == worldMapDefine.soldierType_JingYing then
			soldier, isNeedRelease = cityBuildSoldierPool:getSoldierSprite(soldierType, "n", "07")
			soldier:setFlippedX(false)
		else
			soldier, isNeedRelease = cityBuildSoldierPool:getSoldierSprite(soldierType, "wn")
			soldier:setFlippedX(true)
		end
		soldier:addTo(self.ContentNode, 2)
		if isNeedRelease then
			soldier:release()
		end
		soldier:setAnchorPoint(cc.p(0.5, 0.5))
		self.soldiersArray[i] = soldier
		if self.scaleSoldier then
			soldier:setScale(self.scaleSoldier)
		end
	end
end
function cityBuildTroopsMatrix:createTroops(data)
	self:initWithTroopsData(data)
	self:troop(self.targetPointsArray)
end
function cityBuildTroopsMatrix:getParallelgramPointArray(row, col, A, B, D, paddingColX, paddingRowY)
	local _ENV, pointsArray
	local _ENV, pointsAArray
	local _ENV, pointsBArray
	local _ENV, pointsDArray
	local _ENV, pointsCArray
	local _ENV, ABCDBaseZero
	local A = A or cc.p(0, 0)
	local B = B or cc.p(300, 0)
	local D = D or cc.p(90, 250)
	local C = cc.p(D.x + B.x - A.x, D.y + B.y - A.y)
	local O = cc.p((C.x + A.x) / 2, (C.y + A.y) / 2)
	local paddingColX = paddingColX or self.paddingColX or 0
	local paddingRowY = paddingRowY or self.paddingRowY or 0
	local paddingColY = (B.y - A.y) * (paddingColX / (B.x - A.x))
	local paddingRowX = (D.x - A.x) * (paddingRowY / (D.y - A.y))
	local row = row or 3
	local col = col or 3
	local deltaRowX = (D.x - A.x - (row - 1) * paddingRowX) / row
	local deltaRowY = (D.y - A.y - (row - 1) * paddingRowY) / row
	local deltaColX = (B.x - A.x - (col - 1) * paddingColX) / col
	local deltaColY = (B.y - A.y - (col - 1) * paddingColY) / col
	local posIndex = 1
	for y = 0, row - 1 do
		for x = 0, col - 1 do
			local Ax = A.x + x * (deltaColX + paddingColX) + y * (deltaRowX + paddingRowX)
			local Ay = A.y + x * (deltaColY + paddingColY) + y * (deltaRowY + paddingRowY)
			local Dx = Ax + deltaRowX
			local Dy = Ay + deltaRowY
			local Cx = Dx + deltaColX
			local Cy = Dy + deltaColY
			local Bx = Ax + deltaColX
			local By = Ay + deltaColY
			local Ox = (Ax + Cx) / 2
			local Oy = (Ay + Cy) / 2
			pointsArray[posIndex] = cc.p(math.round(Ox), math.round(Oy))
			pointsAArray[posIndex] = cc.p(math.round(Ax), math.round(Ay))
			pointsBArray[posIndex] = cc.p(math.round(Bx), math.round(By))
			pointsDArray[posIndex] = cc.p(math.round(Dx), math.round(Dy))
			pointsCArray[posIndex] = cc.p(math.round(Cx), math.round(Cy))
			posIndex = posIndex + 1
		end
	end
	local smallA = pointsAArray[1]
	local smallB = pointsBArray[1]
	local smallC = pointsCArray[1]
	local smallD = pointsDArray[1]
	local smallXMin = math.min(smallA.x, smallB.x, smallC.x, smallD.x)
	local smallYmin = math.min(smallA.y, smallB.y, smallC.y, smallD.y)
	_ENV = smallA.y
	smallA.y.A = cc.p(smallA.x - smallXMin, smallA.y - smallYmin)
	smallA.y.B = cc.p(smallB.x - smallXMin, smallB.y - smallYmin)
	smallA.y.C = cc.p(smallC.x - smallXMin, smallC.y - smallYmin)
	ABCDBaseZero, smallA.y.D = smallA.y, cc.p(smallD.x - smallXMin, smallD.y - smallYmin)
	return pointsArray, pointsAArray, pointsBArray, pointsCArray, pointsDArray, ABCDBaseZero
end
function cityBuildTroopsMatrix:getTransformPointArray(pointsArray)
	do return pointsArray end
	local _UPVALUE0_, transformedPointArray
	for i = 1, #pointsArray do
		local pos = self.graphNode:convertToWorldSpace(pointsArray[i])
		transformedPointArray[i] = self.ContentNode:convertToNodeSpace(pos)
	end
	return transformedPointArray
end
function cityBuildTroopsMatrix:getSoldierPointArray(angle)
	if self.isTroopMatrix == true then
		local tblCfg = self:getTblCfgBySoldierType(self.soldierType)
		local tblPolygon = tblCfg[angle]
		if self.A ~= tblPolygon.A or self.B ~= tblPolygon.B or self.D ~= tblPolygon.D then
			self.isMatrixPosDirty = true
			self.isSoldiersPosDirty = true
			self.A = tblPolygon.A
			self.B = tblPolygon.B
			self.D = tblPolygon.D
		end
	end
	local pointsArray
	if self.isMatrixPosDirty == true or self.cachePointsArray == nil then
		pointsArray = self:getParallelgramPointArray(self.row, self.col, self.A, self.B, self.D, self.paddingColX, self.paddingRowY)
		self.cachePointsArray = pointsArray
		self.isMatrixPosDirty = false
	else
		pointsArray = self.cachePointsArray
	end
	local soldiersPosArray
	if self.isSoldiersPosDirty == true or self.cacheSoldierPosArray then
		soldiersPosArray = self:getTransformPointArray(pointsArray)
		self.cacheSoldierPosArray = soldiersPosArray
	else
		soldiersPosArray = self.cacheSoldierPosArray
	end
	return soldiersPosArray
end
function cityBuildTroopsMatrix:drawParallelogram(parent, row, col, A, B, D, paddingColX, paddingRowY)
	local parentSize = parent:getContentSize()
	local A = A or cc.p(0, 0)
	local B = B or cc.p(300, 0)
	local D = D or cc.p(90, 250)
	local C = cc.p(D.x + B.x - A.x, D.y + B.y - A.y)
	local O = cc.p((C.x + A.x) / 2, (C.y + A.y) / 2)
	local paddingColX = paddingColX or 0
	local paddingRowY = paddingRowY or 0
	local paddingColY = (B.y - A.y) * (paddingColX / (B.x - A.x))
	local paddingRowX = (D.x - A.x) * (paddingRowY / (D.y - A.y))
	local glNode = gl.glNodeCreate()
	local xMax = math.max(A.x, B.x, C.x, D.x)
	local xMin = math.min(A.x, B.x, C.x, D.x)
	local yMax = math.max(A.y, B.y, C.y, D.y)
	local yMin = math.min(A.y, B.y, C.y, D.y)
	local contentNodeSize = cc.size(math.abs(xMax - xMin), math.abs(yMax - yMin))
	glNode:setContentSize(contentNodeSize.width, contentNodeSize.height)
	local primitivesDraw = function(transform, transformUpdated)
		kmGLPushMatrix()
		kmGLLoadMatrix(transform)
		cc.DrawPrimitives.drawColor4B(255, 0, 0, 255)
		gl.lineWidth(3)
		cc.DrawPrimitives.drawLine(A, B)
		cc.DrawPrimitives.drawLine(A, D)
		cc.DrawPrimitives.drawLine(B, C)
		cc.DrawPrimitives.drawLine(D, C)
		local row = row or 3
		local col = col or 3
		gl.lineWidth(3)
		cc.DrawPrimitives.drawColor4B(0, 255, 0, 255)
		local deltaRowX = (D.x - A.x - (row - 1) * paddingRowX) / row
		local deltaRowY = (D.y - A.y - (row - 1) * paddingRowY) / row
		local deltaColX = (B.x - A.x - (col - 1) * paddingColX) / col
		local deltaColY = (B.y - A.y - (col - 1) * paddingColY) / col
		for i = 0, row - 1 do
			local A1 = cc.p(A.x + i * (deltaRowX + paddingRowX), A.y + i * (deltaRowY + paddingRowY))
			local B1 = cc.p(B.x + i * (deltaRowX + paddingRowX), B.y + i * (deltaRowY + paddingRowY))
			local D1 = cc.p(A1.x + deltaRowX, A1.y + deltaRowY)
			local C1 = cc.p(D1.x + B1.x - A1.x, D1.y + B1.y - A1.y)
			if i == 0 then
				cc.DrawPrimitives.drawColor4B(0, 255, 255, 255)
				cc.DrawPrimitives.drawLine(D1, C1)
			elseif i == row - 1 then
				cc.DrawPrimitives.drawColor4B(0, 255, 0, 255)
				cc.DrawPrimitives.drawLine(A1, B1)
			else
				cc.DrawPrimitives.drawColor4B(0, 255, 0, 255)
				gl.lineWidth(3)
				cc.DrawPrimitives.drawLine(A1, B1)
				cc.DrawPrimitives.drawColor4B(0, 255, 255, 255)
				gl.lineWidth(3)
				cc.DrawPrimitives.drawLine(D1, C1)
			end
		end
		for i = 0, col - 1 do
			local A1 = cc.p(A.x + i * (deltaColX + paddingColX), A.y + i * (deltaColY + paddingColY))
			local D1 = cc.p(D.x + i * (deltaColX + paddingColX), D.y + i * (deltaColY + paddingColY))
			local B1 = cc.p(A1.x + deltaColX, A1.y + deltaColY)
			local C1 = cc.p(D1.x + B1.x - A1.x, D1.y + B1.y - A1.y)
			if i == 0 then
				cc.DrawPrimitives.drawColor4B(0, 255, 255, 255)
				cc.DrawPrimitives.drawLine(B1, C1)
			elseif i == col - 1 then
				cc.DrawPrimitives.drawColor4B(0, 255, 0, 255)
				cc.DrawPrimitives.drawLine(A1, D1)
			else
				cc.DrawPrimitives.drawColor4B(0, 255, 0, 255)
				gl.lineWidth(3)
				cc.DrawPrimitives.drawLine(A1, D1)
				cc.DrawPrimitives.drawColor4B(0, 255, 255, 255)
				gl.lineWidth(3)
				cc.DrawPrimitives.drawLine(B1, C1)
			end
		end
		cc.DrawPrimitives.setPointSize(2)
		cc.DrawPrimitives.drawColor4B(255, 0, 255, 255)
		for y = 0, row - 1 do
			for x = 0, col - 1 do
				local Ax = A.x + x * (deltaColX + paddingColX) + y * (deltaRowX + paddingRowX)
				local Ay = A.y + x * (deltaColY + paddingColY) + y * (deltaRowY + paddingRowY)
				local Dx = Ax + deltaRowX
				local Dy = Ay + deltaRowY
				local Cx = Dx + deltaColX
				local Cy = Dy + deltaColY
				local Bx = Ax + deltaColX
				local By = Ay + deltaColY
				local Ox = (Ax + Cx) / 2
				local Oy = (Ay + Cy) / 2
				gl.lineWidth(1)
				cc.DrawPrimitives.drawLine(cc.p(Ax, Ay), cc.p(Cx, Cy))
				cc.DrawPrimitives.drawLine(cc.p(Bx, By), cc.p(Dx, Dy))
				cc.DrawPrimitives.drawPoint(cc.p(Ox, Oy))
			end
		end
		cc.DrawPrimitives.setPointSize(10)
		cc.DrawPrimitives.drawColor4B(255, 255, 0, 255)
		cc.DrawPrimitives.drawPoint(O)
		kmGLPopMatrix()
	end
	glNode:registerScriptDrawHandler(primitivesDraw)
	parent:addChild(glNode, 1)
	glNode:ignoreAnchorPointForPosition(false)
	glNode:setAnchorPoint(cc.p(0.5, 0.5))
	glNode:setPosition(parentSize.width / 2, parentSize.height / 2)
end
function cityBuildTroopsMatrix:createSoldierMatrix(data)
	self:initWithTroopsData(data)
end
function cityBuildTroopsMatrix:setBid(bid)
	self.bid = bid
end
function cityBuildTroopsMatrix:getBid()
	return self.bid
end
function cityBuildTroopsMatrix:getConvertedSoldierNumber(realSoldierNumber)
	local soldierNumber = 0
	if realSoldierNumber == nil then
		return soldierNumber
	end
	if 1 <= realSoldierNumber and realSoldierNumber <= 9 then
		soldierNumber = 1
	elseif 10 <= realSoldierNumber and realSoldierNumber <= 59 then
		soldierNumber = 2
	elseif 60 <= realSoldierNumber and realSoldierNumber <= 159 then
		soldierNumber = 3
	elseif 160 <= realSoldierNumber and realSoldierNumber <= 299 then
		soldierNumber = 4
	elseif 300 <= realSoldierNumber and realSoldierNumber <= 599 then
		soldierNumber = 5
	elseif 600 <= realSoldierNumber and realSoldierNumber <= 999 then
		soldierNumber = 6
	elseif 1000 <= realSoldierNumber then
		soldierNumber = 7
	end
	return soldierNumber
end
function cityBuildTroopsMatrix:removeNodeRelyOn()
	if self.uiType ~= cityBuildConstDef.uiType.UI_TYPE_RELYON then
		return
	end
	self:recycleSoldiers()
end
function cityBuildTroopsMatrix:recycleSoldiers()
	local soldierType = self.soldierType
	for i = 1, #self.soldiersArray do
		if self.soldiersArray[i] ~= nil then
			if nil ~= self.soldiersArray[i]:getParent() then
				if self.uiType == cityBuildConstDef.uiType.UI_TYPE_RELYON then
					if soldierType ~= worldMapDefine.soldierType_JingYing then
						cityBuildSoldierPool:addToSoldierPool(soldierType, "wn", self.soldiersArray[i])
					else
						cityBuildSoldierPool:addToSoldierPool(soldierType, "n", self.soldiersArray[i])
					end
				else
					cityBuildSoldierPool:addToSoldierPool(soldierType, "NA", self.soldiersArray[i])
				end
				self.soldiersArray[i]:removeFromParent()
			end
			self.soldiersArray[i] = nil
		end
	end
end
function cityBuildTroopsMatrix:getAngleName(nameAngle, isFlipX)
	local angle = nameAngle
	if isFlipX == false then
		return angle
	end
	if isFlipX == true then
		if angle == "w" then
			angle = "e"
		elseif angle == "wn" then
			angle = "en"
		else
			if angle == "ws" then
				angle = "es"
			else
			end
		end
	end
	return angle
end
function cityBuildTroopsMatrix:getTblCfgBySoldierType(soldierType)
	local tblCfg = tblCfgDefault
	if soldierType == worldMapDefine.soldierType_BuBing then
		tblCfg = tblCfgBuGongbing
	elseif soldierType == worldMapDefine.soldierType_QiBing then
		tblCfg = tblCfgQibing
	elseif soldierType == worldMapDefine.soldierType_GongjianBing then
		tblCfg = tblCfgBuGongbing
	elseif soldierType == worldMapDefine.soldierType_ZhanChe then
		tblCfg = tblCfgChebing
	end
	return tblCfg
end
function cityBuildTroopsMatrix:setMatrixIndex(index)
	self.matrixIndex = index
end
function cityBuildTroopsMatrix:getMatrixIndex()
	return self.matrixIndex
end
function cityBuildTroopsMatrix:showEnterPoint(A, B, D, points, color)
	local layerColor = cc.Layer:create()
	layerColor:setContentSize(self.graphNode:getContentSize())
	layerColor:addTo(self, 2)
	layerColor:ignoreAnchorPointForPosition(false)
	layerColor:setAnchorPoint(cc.p(0.5, 0.5))
	layerColor:setPosition(0, 0)
	self.graphNodeEnter = layerColor
	local A = A
	local B = B
	local D = D
	local C = cc.p(D.x + B.x - A.x, D.y + B.y - A.y)
	local O = cc.p((C.x + A.x) / 2, (C.y + A.y) / 2)
	local xMax = math.max(A.x, B.x, C.x, D.x)
	local xMin = math.min(A.x, B.x, C.x, D.x)
	local yMax = math.max(A.y, B.y, C.y, D.y)
	local yMin = math.min(A.y, B.y, C.y, D.y)
	local contentNodeSize = cc.size(math.abs(xMax - xMin), math.abs(yMax - yMin))
	local glNode = gl.glNodeCreate()
	glNode:setContentSize(contentNodeSize.width, contentNodeSize.height)
	local primitivesDraw2 = function(transform, transformUpdated)
		kmGLPushMatrix()
		kmGLLoadMatrix(transform)
		cc.DrawPrimitives.setPointSize(10)
		cc.DrawPrimitives.drawColor4B(color.r, color.g, color.b, color.a)
		for k, v in pairs(points) do
			cc.DrawPrimitives.drawPoint(points[k])
		end
		kmGLPopMatrix()
	end
	glNode:registerScriptDrawHandler(primitivesDraw2)
	self.graphNodeEnter:addChild(glNode, 1)
	glNode:ignoreAnchorPointForPosition(false)
	glNode:setAnchorPoint(cc.p(0.5, 0.5))
	glNode:setPosition(cc.p(self.graphNodeEnter:getContentSize().width / 2, self.graphNodeEnter:getContentSize().height / 2))
end
function cityBuildTroopsMatrix:setSoldiersPosDirty(value)
	self.isSoldiersPosDirty = value
end
function cityBuildTroopsMatrix:setCacheType(cacheType)
	self.cacheType = cacheType
end
function cityBuildTroopsMatrix:getCacheType()
	return self.cacheType
end
function cityBuildTroopsMatrix:updateSoldierNumber(soldierNumber)
	for i = 1, #self.soldiersArray do
		local soldier = self.soldiersArray[i]
		if nil == soldier then
			break
		end
		soldier:setVisible(i <= soldierNumber)
	end
	self.soldierNumber = soldierNumber
end
return cityBuildTroopsMatrix
