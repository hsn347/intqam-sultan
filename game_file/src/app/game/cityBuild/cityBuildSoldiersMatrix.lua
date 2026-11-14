local cityBuildConstDef = include("cityBuildConstDef")
local armyLogic = include("armyLogic")
local isShowParallelgram = false
local key_static = "static"
local key_dynamic = "dynamic"
_UPVALUE4_ = nil
_UPVALUE3_, (nil)[1] = "bid", "bid"
_UPVALUE3_, (nil)[2] = "bid", "soldierNumber"
_UPVALUE3_, (nil)[3] = "bid", "row"
local _UPVALUE3_, (nil)[4], attribCompare = "bid", "col", nil
_UPVALUE1_, _ENV, ("bid")[1] = "B", "A", "A"
_UPVALUE1_, _ENV, ("bid")[2] = "B", "A", "B"
local _UPVALUE1_, _ENV, ("bid")[3], posCompare = "B", "A", "D", "bid"
_UPVALUE2_, ("A")[1], ("B")[1] = "B", "B", 26
_UPVALUE3_, ("A")[2], ("B")[1] = "B", "B", 26
_UPVALUE3_, ("A")[2], ("B")[2] = "B", "B", 27
_UPVALUE4_, ("A")[3], ("B")[1] = "B", "B", 26
_UPVALUE4_, ("A")[3], ("B")[2] = "B", "B", 27
_UPVALUE4_, ("A")[3], ("B")[3] = "B", "B", 28
_UPVALUE5_, ("A")[4], ("B")[1] = "B", "B", 26
_UPVALUE5_, ("A")[4], ("B")[2] = "B", "B", 27
_UPVALUE5_, ("A")[4], ("B")[3] = "B", "B", 28
_UPVALUE5_, ("A")[4], ("B")[4] = "B", "B", 29
_UPVALUE6_, ("A")[5], ("B")[1] = "B", "B", 26
_UPVALUE6_, ("A")[5], ("B")[2] = "B", "B", 27
_UPVALUE6_, ("A")[5], ("B")[3] = "B", "B", 28
_UPVALUE6_, ("A")[5], ("B")[4] = "B", "B", 29
_UPVALUE6_, ("A")[5], ("B")[5] = "B", "B", 30
_UPVALUE7_, ("A")[6], ("B")[1] = "B", "B", 26
_UPVALUE7_, ("A")[6], ("B")[2] = "B", "B", 27
_UPVALUE7_, ("A")[6], ("B")[3] = "B", "B", 28
_UPVALUE7_, ("A")[6], ("B")[4] = "B", "B", 29
_UPVALUE7_, ("A")[6], ("B")[5] = "B", "B", 30
_UPVALUE7_, ("A")[6], ("B")[6] = "B", "B", 21
_UPVALUE8_, ("A")[7], ("B")[1] = "B", "B", 26
_UPVALUE8_, ("A")[7], ("B")[2] = "B", "B", 27
_UPVALUE8_, ("A")[7], ("B")[3] = "B", "B", 28
_UPVALUE8_, ("A")[7], ("B")[4] = "B", "B", 29
_UPVALUE8_, ("A")[7], ("B")[5] = "B", "B", 30
_UPVALUE8_, ("A")[7], ("B")[6] = "B", "B", 21
_UPVALUE8_, ("A")[7], ("B")[7] = "B", "B", 22
_UPVALUE9_, ("A")[8], ("B")[1] = "B", "B", 26
_UPVALUE9_, ("A")[8], ("B")[2] = "B", "B", 27
_UPVALUE9_, ("A")[8], ("B")[3] = "B", "B", 28
_UPVALUE9_, ("A")[8], ("B")[4] = "B", "B", 29
_UPVALUE9_, ("A")[8], ("B")[5] = "B", "B", 30
_UPVALUE9_, ("A")[8], ("B")[6] = "B", "B", 21
_UPVALUE9_, ("A")[8], ("B")[7] = "B", "B", 22
_UPVALUE9_, ("A")[8], ("B")[8] = "B", "B", 23
_UPVALUE10_, ("A")[9], ("B")[1] = "B", "B", 26
_UPVALUE10_, ("A")[9], ("B")[2] = "B", "B", 27
_UPVALUE10_, ("A")[9], ("B")[3] = "B", "B", 28
_UPVALUE10_, ("A")[9], ("B")[4] = "B", "B", 29
_UPVALUE10_, ("A")[9], ("B")[5] = "B", "B", 30
_UPVALUE10_, ("A")[9], ("B")[6] = "B", "B", 21
_UPVALUE10_, ("A")[9], ("B")[7] = "B", "B", 22
_UPVALUE10_, ("A")[9], ("B")[8] = "B", "B", 23
_UPVALUE10_, ("A")[9], ("B")[9] = "B", "B", 24
_UPVALUE11_, ("A")[10], ("B")[1] = "B", "B", 26
_UPVALUE11_, ("A")[10], ("B")[2] = "B", "B", 27
_UPVALUE11_, ("A")[10], ("B")[3] = "B", "B", 28
_UPVALUE11_, ("A")[10], ("B")[4] = "B", "B", 29
_UPVALUE11_, ("A")[10], ("B")[5] = "B", "B", 30
_UPVALUE11_, ("A")[10], ("B")[6] = "B", "B", 21
_UPVALUE11_, ("A")[10], ("B")[7] = "B", "B", 22
_UPVALUE11_, ("A")[10], ("B")[8] = "B", "B", 23
_UPVALUE11_, ("A")[10], ("B")[9] = "B", "B", 24
_UPVALUE11_, ("A")[10], ("B")[10] = "B", "B", 25
_UPVALUE12_, ("A")[11], ("B")[1] = "B", "B", 26
_UPVALUE12_, ("A")[11], ("B")[2] = "B", "B", 27
_UPVALUE12_, ("A")[11], ("B")[3] = "B", "B", 28
_UPVALUE12_, ("A")[11], ("B")[4] = "B", "B", 29
_UPVALUE12_, ("A")[11], ("B")[5] = "B", "B", 30
_UPVALUE12_, ("A")[11], ("B")[6] = "B", "B", 21
_UPVALUE12_, ("A")[11], ("B")[7] = "B", "B", 22
_UPVALUE12_, ("A")[11], ("B")[8] = "B", "B", 23
_UPVALUE12_, ("A")[11], ("B")[9] = "B", "B", 24
_UPVALUE12_, ("A")[11], ("B")[10] = "B", "B", 25
_UPVALUE12_, ("A")[11], ("B")[11] = "B", "B", 16
_UPVALUE13_, ("A")[12], ("B")[1] = "B", "B", 26
_UPVALUE13_, ("A")[12], ("B")[2] = "B", "B", 27
_UPVALUE13_, ("A")[12], ("B")[3] = "B", "B", 28
_UPVALUE13_, ("A")[12], ("B")[4] = "B", "B", 29
_UPVALUE13_, ("A")[12], ("B")[5] = "B", "B", 30
_UPVALUE13_, ("A")[12], ("B")[6] = "B", "B", 21
_UPVALUE13_, ("A")[12], ("B")[7] = "B", "B", 22
_UPVALUE13_, ("A")[12], ("B")[8] = "B", "B", 23
_UPVALUE13_, ("A")[12], ("B")[9] = "B", "B", 24
_UPVALUE13_, ("A")[12], ("B")[10] = "B", "B", 25
_UPVALUE13_, ("A")[12], ("B")[11] = "B", "B", 16
_UPVALUE13_, ("A")[12], ("B")[12] = "B", "B", 17
_UPVALUE14_, ("A")[13], ("B")[1] = "B", "B", 26
_UPVALUE14_, ("A")[13], ("B")[2] = "B", "B", 27
_UPVALUE14_, ("A")[13], ("B")[3] = "B", "B", 28
_UPVALUE14_, ("A")[13], ("B")[4] = "B", "B", 29
_UPVALUE14_, ("A")[13], ("B")[5] = "B", "B", 30
_UPVALUE14_, ("A")[13], ("B")[6] = "B", "B", 21
_UPVALUE14_, ("A")[13], ("B")[7] = "B", "B", 22
_UPVALUE14_, ("A")[13], ("B")[8] = "B", "B", 23
_UPVALUE14_, ("A")[13], ("B")[9] = "B", "B", 24
_UPVALUE14_, ("A")[13], ("B")[10] = "B", "B", 25
_UPVALUE14_, ("A")[13], ("B")[11] = "B", "B", 16
_UPVALUE14_, ("A")[13], ("B")[12] = "B", "B", 17
_UPVALUE14_, ("A")[13], ("B")[13] = "B", "B", 18
_UPVALUE15_, ("A")[14], ("B")[1] = "B", "B", 26
_UPVALUE15_, ("A")[14], ("B")[2] = "B", "B", 27
_UPVALUE15_, ("A")[14], ("B")[3] = "B", "B", 28
_UPVALUE15_, ("A")[14], ("B")[4] = "B", "B", 29
_UPVALUE15_, ("A")[14], ("B")[5] = "B", "B", 30
_UPVALUE15_, ("A")[14], ("B")[6] = "B", "B", 21
_UPVALUE15_, ("A")[14], ("B")[7] = "B", "B", 22
_UPVALUE15_, ("A")[14], ("B")[8] = "B", "B", 23
_UPVALUE15_, ("A")[14], ("B")[9] = "B", "B", 24
_UPVALUE15_, ("A")[14], ("B")[10] = "B", "B", 25
_UPVALUE15_, ("A")[14], ("B")[11] = "B", "B", 16
_UPVALUE15_, ("A")[14], ("B")[12] = "B", "B", 17
_UPVALUE15_, ("A")[14], ("B")[13] = "B", "B", 18
_UPVALUE15_, ("A")[14], ("B")[14] = "B", "B", 19
_UPVALUE16_, ("A")[15], ("B")[1] = "B", "B", 26
_UPVALUE16_, ("A")[15], ("B")[2] = "B", "B", 27
_UPVALUE16_, ("A")[15], ("B")[3] = "B", "B", 28
_UPVALUE16_, ("A")[15], ("B")[4] = "B", "B", 29
_UPVALUE16_, ("A")[15], ("B")[5] = "B", "B", 30
_UPVALUE16_, ("A")[15], ("B")[6] = "B", "B", 21
_UPVALUE16_, ("A")[15], ("B")[7] = "B", "B", 22
_UPVALUE16_, ("A")[15], ("B")[8] = "B", "B", 23
_UPVALUE16_, ("A")[15], ("B")[9] = "B", "B", 24
_UPVALUE16_, ("A")[15], ("B")[10] = "B", "B", 25
_UPVALUE16_, ("A")[15], ("B")[11] = "B", "B", 16
_UPVALUE16_, ("A")[15], ("B")[12] = "B", "B", 17
_UPVALUE16_, ("A")[15], ("B")[13] = "B", "B", 18
_UPVALUE16_, ("A")[15], ("B")[14] = "B", "B", 19
_UPVALUE16_, ("A")[15], ("B")[15] = "B", "B", 20
_UPVALUE17_, ("A")[16], ("B")[1] = "B", "B", 26
_UPVALUE17_, ("A")[16], ("B")[2] = "B", "B", 27
_UPVALUE17_, ("A")[16], ("B")[3] = "B", "B", 28
_UPVALUE17_, ("A")[16], ("B")[4] = "B", "B", 29
_UPVALUE17_, ("A")[16], ("B")[5] = "B", "B", 30
_UPVALUE17_, ("A")[16], ("B")[6] = "B", "B", 21
_UPVALUE17_, ("A")[16], ("B")[7] = "B", "B", 22
_UPVALUE17_, ("A")[16], ("B")[8] = "B", "B", 23
_UPVALUE17_, ("A")[16], ("B")[9] = "B", "B", 24
_UPVALUE17_, ("A")[16], ("B")[10] = "B", "B", 25
_UPVALUE17_, ("A")[16], ("B")[11] = "B", "B", 16
_UPVALUE17_, ("A")[16], ("B")[12] = "B", "B", 17
_UPVALUE17_, ("A")[16], ("B")[13] = "B", "B", 18
_UPVALUE17_, ("A")[16], ("B")[14] = "B", "B", 19
_UPVALUE17_, ("A")[16], ("B")[15] = "B", "B", 20
_UPVALUE17_, ("A")[16], ("B")[16] = "B", "B", 11
_UPVALUE17_, ("A")[17], ("B")[1] = "B", "B", 26
_UPVALUE17_, ("A")[17], ("B")[2] = "B", "B", 27
_UPVALUE17_, ("A")[17], ("B")[3] = "B", "B", 28
_UPVALUE17_, ("A")[17], ("B")[4] = "B", "B", 29
_UPVALUE17_, ("A")[17], ("B")[5] = "B", "B", 30
_UPVALUE17_, ("A")[17], ("B")[6] = "B", "B", 21
_UPVALUE17_, ("A")[17], ("B")[7] = "B", "B", 22
_UPVALUE17_, ("A")[17], ("B")[8] = "B", "B", 23
_UPVALUE17_, ("A")[17], ("B")[9] = "B", "B", 24
_UPVALUE17_, ("A")[17], ("B")[10] = "B", "B", 25
_UPVALUE17_, ("A")[17], ("B")[11] = "B", "B", 16
_UPVALUE17_, ("A")[17], ("B")[12] = "B", "B", 17
_UPVALUE17_, ("A")[17], ("B")[13] = "B", "B", 18
_UPVALUE17_, ("A")[17], ("B")[14] = "B", "B", 19
_UPVALUE17_, ("A")[17], ("B")[15] = "B", "B", 20
_UPVALUE17_, ("A")[17], ("B")[16] = "B", "B", 11
_UPVALUE17_, ("A")[17], ("B")[17] = "B", "B", 12
_UPVALUE18_, ("A")[18], ("B")[1] = "B", "B", 26
_UPVALUE18_, ("A")[18], ("B")[2] = "B", "B", 27
_UPVALUE18_, ("A")[18], ("B")[3] = "B", "B", 28
_UPVALUE18_, ("A")[18], ("B")[4] = "B", "B", 29
_UPVALUE18_, ("A")[18], ("B")[5] = "B", "B", 30
_UPVALUE18_, ("A")[18], ("B")[6] = "B", "B", 21
_UPVALUE18_, ("A")[18], ("B")[7] = "B", "B", 22
_UPVALUE18_, ("A")[18], ("B")[8] = "B", "B", 23
_UPVALUE18_, ("A")[18], ("B")[9] = "B", "B", 24
_UPVALUE18_, ("A")[18], ("B")[10] = "B", "B", 25
_UPVALUE18_, ("A")[18], ("B")[11] = "B", "B", 16
_UPVALUE18_, ("A")[18], ("B")[12] = "B", "B", 17
_UPVALUE18_, ("A")[18], ("B")[13] = "B", "B", 18
_UPVALUE18_, ("A")[18], ("B")[14] = "B", "B", 19
_UPVALUE18_, ("A")[18], ("B")[15] = "B", "B", 20
_UPVALUE18_, ("A")[18], ("B")[16] = "B", "B", 11
_UPVALUE18_, ("A")[18], ("B")[17] = "B", "B", 12
_UPVALUE18_, ("A")[18], ("B")[18] = "B", "B", 13
_UPVALUE18_, ("A")[19], ("B")[1] = "B", "B", 26
_UPVALUE18_, ("A")[19], ("B")[2] = "B", "B", 27
_UPVALUE18_, ("A")[19], ("B")[3] = "B", "B", 28
_UPVALUE18_, ("A")[19], ("B")[4] = "B", "B", 29
_UPVALUE18_, ("A")[19], ("B")[5] = "B", "B", 30
_UPVALUE18_, ("A")[19], ("B")[6] = "B", "B", 21
_UPVALUE18_, ("A")[19], ("B")[7] = "B", "B", 22
_UPVALUE18_, ("A")[19], ("B")[8] = "B", "B", 23
_UPVALUE18_, ("A")[19], ("B")[9] = "B", "B", 24
_UPVALUE18_, ("A")[19], ("B")[10] = "B", "B", 25
_UPVALUE18_, ("A")[19], ("B")[11] = "B", "B", 16
_UPVALUE18_, ("A")[19], ("B")[12] = "B", "B", 17
_UPVALUE18_, ("A")[19], ("B")[13] = "B", "B", 18
_UPVALUE18_, ("A")[19], ("B")[14] = "B", "B", 19
_UPVALUE18_, ("A")[19], ("B")[15] = "B", "B", 20
_UPVALUE18_, ("A")[19], ("B")[16] = "B", "B", 11
_UPVALUE18_, ("A")[19], ("B")[17] = "B", "B", 12
_UPVALUE18_, ("A")[19], ("B")[18] = "B", "B", 13
_UPVALUE18_, ("A")[19], ("B")[19] = "B", "B", 14
_UPVALUE19_, ("A")[20], ("B")[1] = "B", "B", 26
_UPVALUE19_, ("A")[20], ("B")[2] = "B", "B", 27
_UPVALUE19_, ("A")[20], ("B")[3] = "B", "B", 28
_UPVALUE19_, ("A")[20], ("B")[4] = "B", "B", 29
_UPVALUE19_, ("A")[20], ("B")[5] = "B", "B", 30
_UPVALUE19_, ("A")[20], ("B")[6] = "B", "B", 21
_UPVALUE19_, ("A")[20], ("B")[7] = "B", "B", 22
_UPVALUE19_, ("A")[20], ("B")[8] = "B", "B", 23
_UPVALUE19_, ("A")[20], ("B")[9] = "B", "B", 24
_UPVALUE19_, ("A")[20], ("B")[10] = "B", "B", 25
_UPVALUE19_, ("A")[20], ("B")[11] = "B", "B", 16
_UPVALUE19_, ("A")[20], ("B")[12] = "B", "B", 17
_UPVALUE19_, ("A")[20], ("B")[13] = "B", "B", 18
_UPVALUE19_, ("A")[20], ("B")[14] = "B", "B", 19
_UPVALUE19_, ("A")[20], ("B")[15] = "B", "B", 20
_UPVALUE19_, ("A")[20], ("B")[16] = "B", "B", 11
_UPVALUE19_, ("A")[20], ("B")[17] = "B", "B", 12
_UPVALUE19_, ("A")[20], ("B")[18] = "B", "B", 13
_UPVALUE19_, ("A")[20], ("B")[19] = "B", "B", 14
_UPVALUE19_, ("A")[20], ("B")[20] = "B", "B", 15
_UPVALUE19_, ("A")[21], ("B")[1] = "B", "B", 26
_UPVALUE19_, ("A")[21], ("B")[2] = "B", "B", 27
_UPVALUE19_, ("A")[21], ("B")[3] = "B", "B", 28
_UPVALUE19_, ("A")[21], ("B")[4] = "B", "B", 29
_UPVALUE19_, ("A")[21], ("B")[5] = "B", "B", 30
_UPVALUE19_, ("A")[21], ("B")[6] = "B", "B", 21
_UPVALUE19_, ("A")[21], ("B")[7] = "B", "B", 22
_UPVALUE19_, ("A")[21], ("B")[8] = "B", "B", 23
_UPVALUE19_, ("A")[21], ("B")[9] = "B", "B", 24
_UPVALUE19_, ("A")[21], ("B")[10] = "B", "B", 25
_UPVALUE19_, ("A")[21], ("B")[11] = "B", "B", 16
_UPVALUE19_, ("A")[21], ("B")[12] = "B", "B", 17
_UPVALUE19_, ("A")[21], ("B")[13] = "B", "B", 18
_UPVALUE19_, ("A")[21], ("B")[14] = "B", "B", 19
_UPVALUE19_, ("A")[21], ("B")[15] = "B", "B", 20
_UPVALUE19_, ("A")[21], ("B")[16] = "B", "B", 11
_UPVALUE19_, ("A")[21], ("B")[17] = "B", "B", 12
_UPVALUE19_, ("A")[21], ("B")[18] = "B", "B", 13
_UPVALUE19_, ("A")[21], ("B")[19] = "B", "B", 14
_UPVALUE19_, ("A")[21], ("B")[20] = "B", "B", 15
_UPVALUE19_, ("A")[21], ("B")[21] = "B", "B", 6
_UPVALUE20_, ("A")[22], ("B")[1] = "B", "B", 26
_UPVALUE20_, ("A")[22], ("B")[2] = "B", "B", 27
_UPVALUE20_, ("A")[22], ("B")[3] = "B", "B", 28
_UPVALUE20_, ("A")[22], ("B")[4] = "B", "B", 29
_UPVALUE20_, ("A")[22], ("B")[5] = "B", "B", 30
_UPVALUE20_, ("A")[22], ("B")[6] = "B", "B", 21
_UPVALUE20_, ("A")[22], ("B")[7] = "B", "B", 22
_UPVALUE20_, ("A")[22], ("B")[8] = "B", "B", 23
_UPVALUE20_, ("A")[22], ("B")[9] = "B", "B", 24
_UPVALUE20_, ("A")[22], ("B")[10] = "B", "B", 25
_UPVALUE20_, ("A")[22], ("B")[11] = "B", "B", 16
_UPVALUE20_, ("A")[22], ("B")[12] = "B", "B", 17
_UPVALUE20_, ("A")[22], ("B")[13] = "B", "B", 18
_UPVALUE20_, ("A")[22], ("B")[14] = "B", "B", 19
_UPVALUE20_, ("A")[22], ("B")[15] = "B", "B", 20
_UPVALUE20_, ("A")[22], ("B")[16] = "B", "B", 11
_UPVALUE20_, ("A")[22], ("B")[17] = "B", "B", 12
_UPVALUE20_, ("A")[22], ("B")[18] = "B", "B", 13
_UPVALUE20_, ("A")[22], ("B")[19] = "B", "B", 14
_UPVALUE20_, ("A")[22], ("B")[20] = "B", "B", 15
_UPVALUE20_, ("A")[22], ("B")[21] = "B", "B", 6
_UPVALUE20_, ("A")[22], ("B")[22] = "B", "B", 7
_UPVALUE20_, ("A")[23], ("B")[1] = "B", "B", 26
_UPVALUE20_, ("A")[23], ("B")[2] = "B", "B", 27
_UPVALUE20_, ("A")[23], ("B")[3] = "B", "B", 28
_UPVALUE20_, ("A")[23], ("B")[4] = "B", "B", 29
_UPVALUE20_, ("A")[23], ("B")[5] = "B", "B", 30
_UPVALUE20_, ("A")[23], ("B")[6] = "B", "B", 21
_UPVALUE20_, ("A")[23], ("B")[7] = "B", "B", 22
_UPVALUE20_, ("A")[23], ("B")[8] = "B", "B", 23
_UPVALUE20_, ("A")[23], ("B")[9] = "B", "B", 24
_UPVALUE20_, ("A")[23], ("B")[10] = "B", "B", 25
_UPVALUE20_, ("A")[23], ("B")[11] = "B", "B", 16
_UPVALUE20_, ("A")[23], ("B")[12] = "B", "B", 17
_UPVALUE20_, ("A")[23], ("B")[13] = "B", "B", 18
_UPVALUE20_, ("A")[23], ("B")[14] = "B", "B", 19
_UPVALUE20_, ("A")[23], ("B")[15] = "B", "B", 20
_UPVALUE20_, ("A")[23], ("B")[16] = "B", "B", 11
_UPVALUE20_, ("A")[23], ("B")[17] = "B", "B", 12
_UPVALUE20_, ("A")[23], ("B")[18] = "B", "B", 13
_UPVALUE20_, ("A")[23], ("B")[19] = "B", "B", 14
_UPVALUE20_, ("A")[23], ("B")[20] = "B", "B", 15
_UPVALUE20_, ("A")[23], ("B")[21] = "B", "B", 6
_UPVALUE20_, ("A")[23], ("B")[22] = "B", "B", 7
_UPVALUE20_, ("A")[23], ("B")[23] = "B", "B", 8
_UPVALUE21_, ("A")[24], ("B")[1] = "B", "B", 26
_UPVALUE21_, ("A")[24], ("B")[2] = "B", "B", 27
_UPVALUE21_, ("A")[24], ("B")[3] = "B", "B", 28
_UPVALUE21_, ("A")[24], ("B")[4] = "B", "B", 29
_UPVALUE21_, ("A")[24], ("B")[5] = "B", "B", 30
_UPVALUE21_, ("A")[24], ("B")[6] = "B", "B", 21
_UPVALUE21_, ("A")[24], ("B")[7] = "B", "B", 22
_UPVALUE21_, ("A")[24], ("B")[8] = "B", "B", 23
_UPVALUE21_, ("A")[24], ("B")[9] = "B", "B", 24
_UPVALUE21_, ("A")[24], ("B")[10] = "B", "B", 25
_UPVALUE21_, ("A")[24], ("B")[11] = "B", "B", 16
_UPVALUE21_, ("A")[24], ("B")[12] = "B", "B", 17
_UPVALUE21_, ("A")[24], ("B")[13] = "B", "B", 18
_UPVALUE21_, ("A")[24], ("B")[14] = "B", "B", 19
_UPVALUE21_, ("A")[24], ("B")[15] = "B", "B", 20
_UPVALUE21_, ("A")[24], ("B")[16] = "B", "B", 11
_UPVALUE21_, ("A")[24], ("B")[17] = "B", "B", 12
_UPVALUE21_, ("A")[24], ("B")[18] = "B", "B", 13
_UPVALUE21_, ("A")[24], ("B")[19] = "B", "B", 14
_UPVALUE21_, ("A")[24], ("B")[20] = "B", "B", 15
_UPVALUE21_, ("A")[24], ("B")[21] = "B", "B", 6
_UPVALUE21_, ("A")[24], ("B")[22] = "B", "B", 7
_UPVALUE21_, ("A")[24], ("B")[23] = "B", "B", 8
_UPVALUE21_, ("A")[24], ("B")[24] = "B", "B", 9
_UPVALUE21_, ("A")[25], ("B")[1] = "B", "B", 26
_UPVALUE21_, ("A")[25], ("B")[2] = "B", "B", 27
_UPVALUE21_, ("A")[25], ("B")[3] = "B", "B", 28
_UPVALUE21_, ("A")[25], ("B")[4] = "B", "B", 29
_UPVALUE21_, ("A")[25], ("B")[5] = "B", "B", 30
_UPVALUE21_, ("A")[25], ("B")[6] = "B", "B", 21
_UPVALUE21_, ("A")[25], ("B")[7] = "B", "B", 22
_UPVALUE21_, ("A")[25], ("B")[8] = "B", "B", 23
_UPVALUE21_, ("A")[25], ("B")[9] = "B", "B", 24
_UPVALUE21_, ("A")[25], ("B")[10] = "B", "B", 25
_UPVALUE21_, ("A")[25], ("B")[11] = "B", "B", 16
_UPVALUE21_, ("A")[25], ("B")[12] = "B", "B", 17
_UPVALUE21_, ("A")[25], ("B")[13] = "B", "B", 18
_UPVALUE21_, ("A")[25], ("B")[14] = "B", "B", 19
_UPVALUE21_, ("A")[25], ("B")[15] = "B", "B", 20
_UPVALUE21_, ("A")[25], ("B")[16] = "B", "B", 11
_UPVALUE21_, ("A")[25], ("B")[17] = "B", "B", 12
_UPVALUE21_, ("A")[25], ("B")[18] = "B", "B", 13
_UPVALUE21_, ("A")[25], ("B")[19] = "B", "B", 14
_UPVALUE21_, ("A")[25], ("B")[20] = "B", "B", 15
_UPVALUE21_, ("A")[25], ("B")[21] = "B", "B", 6
_UPVALUE21_, ("A")[25], ("B")[22] = "B", "B", 7
_UPVALUE21_, ("A")[25], ("B")[23] = "B", "B", 8
_UPVALUE21_, ("A")[25], ("B")[24] = "B", "B", 9
_UPVALUE21_, ("A")[25], ("B")[25] = "B", "B", 10
_UPVALUE22_, ("A")[26], ("B")[1] = "B", "B", 26
_UPVALUE22_, ("A")[26], ("B")[2] = "B", "B", 27
_UPVALUE22_, ("A")[26], ("B")[3] = "B", "B", 28
_UPVALUE22_, ("A")[26], ("B")[4] = "B", "B", 29
_UPVALUE22_, ("A")[26], ("B")[5] = "B", "B", 30
_UPVALUE22_, ("A")[26], ("B")[6] = "B", "B", 21
_UPVALUE22_, ("A")[26], ("B")[7] = "B", "B", 22
_UPVALUE22_, ("A")[26], ("B")[8] = "B", "B", 23
_UPVALUE22_, ("A")[26], ("B")[9] = "B", "B", 24
_UPVALUE22_, ("A")[26], ("B")[10] = "B", "B", 25
_UPVALUE22_, ("A")[26], ("B")[11] = "B", "B", 16
_UPVALUE22_, ("A")[26], ("B")[12] = "B", "B", 17
_UPVALUE22_, ("A")[26], ("B")[13] = "B", "B", 18
_UPVALUE22_, ("A")[26], ("B")[14] = "B", "B", 19
_UPVALUE22_, ("A")[26], ("B")[15] = "B", "B", 20
_UPVALUE22_, ("A")[26], ("B")[16] = "B", "B", 11
_UPVALUE22_, ("A")[26], ("B")[17] = "B", "B", 12
_UPVALUE22_, ("A")[26], ("B")[18] = "B", "B", 13
_UPVALUE22_, ("A")[26], ("B")[19] = "B", "B", 14
_UPVALUE22_, ("A")[26], ("B")[20] = "B", "B", 15
_UPVALUE22_, ("A")[26], ("B")[21] = "B", "B", 6
_UPVALUE22_, ("A")[26], ("B")[22] = "B", "B", 7
_UPVALUE22_, ("A")[26], ("B")[23] = "B", "B", 8
_UPVALUE22_, ("A")[26], ("B")[24] = "B", "B", 9
_UPVALUE22_, ("A")[26], ("B")[25] = "B", "B", 10
_UPVALUE22_, ("A")[26], ("B")[26] = "B", "B", 1
_UPVALUE22_, ("A")[27], ("B")[1] = "B", "B", 26
_UPVALUE22_, ("A")[27], ("B")[2] = "B", "B", 27
_UPVALUE22_, ("A")[27], ("B")[3] = "B", "B", 28
_UPVALUE22_, ("A")[27], ("B")[4] = "B", "B", 29
_UPVALUE22_, ("A")[27], ("B")[5] = "B", "B", 30
_UPVALUE22_, ("A")[27], ("B")[6] = "B", "B", 21
_UPVALUE22_, ("A")[27], ("B")[7] = "B", "B", 22
_UPVALUE22_, ("A")[27], ("B")[8] = "B", "B", 23
_UPVALUE22_, ("A")[27], ("B")[9] = "B", "B", 24
_UPVALUE22_, ("A")[27], ("B")[10] = "B", "B", 25
_UPVALUE22_, ("A")[27], ("B")[11] = "B", "B", 16
_UPVALUE22_, ("A")[27], ("B")[12] = "B", "B", 17
_UPVALUE22_, ("A")[27], ("B")[13] = "B", "B", 18
_UPVALUE22_, ("A")[27], ("B")[14] = "B", "B", 19
_UPVALUE22_, ("A")[27], ("B")[15] = "B", "B", 20
_UPVALUE22_, ("A")[27], ("B")[16] = "B", "B", 11
_UPVALUE22_, ("A")[27], ("B")[17] = "B", "B", 12
_UPVALUE22_, ("A")[27], ("B")[18] = "B", "B", 13
_UPVALUE22_, ("A")[27], ("B")[19] = "B", "B", 14
_UPVALUE22_, ("A")[27], ("B")[20] = "B", "B", 15
_UPVALUE22_, ("A")[27], ("B")[21] = "B", "B", 6
_UPVALUE22_, ("A")[27], ("B")[22] = "B", "B", 7
_UPVALUE22_, ("A")[27], ("B")[23] = "B", "B", 8
_UPVALUE22_, ("A")[27], ("B")[24] = "B", "B", 9
_UPVALUE22_, ("A")[27], ("B")[25] = "B", "B", 10
_UPVALUE22_, ("A")[27], ("B")[26] = "B", "B", 1
_UPVALUE22_, ("A")[27], ("B")[27] = "B", "B", 2
_UPVALUE23_, ("A")[28], ("B")[1] = "B", "B", 26
_UPVALUE23_, ("A")[28], ("B")[2] = "B", "B", 27
_UPVALUE23_, ("A")[28], ("B")[3] = "B", "B", 28
_UPVALUE23_, ("A")[28], ("B")[4] = "B", "B", 29
_UPVALUE23_, ("A")[28], ("B")[5] = "B", "B", 30
_UPVALUE23_, ("A")[28], ("B")[6] = "B", "B", 21
_UPVALUE23_, ("A")[28], ("B")[7] = "B", "B", 22
_UPVALUE23_, ("A")[28], ("B")[8] = "B", "B", 23
_UPVALUE23_, ("A")[28], ("B")[9] = "B", "B", 24
_UPVALUE23_, ("A")[28], ("B")[10] = "B", "B", 25
_UPVALUE23_, ("A")[28], ("B")[11] = "B", "B", 16
_UPVALUE23_, ("A")[28], ("B")[12] = "B", "B", 17
_UPVALUE23_, ("A")[28], ("B")[13] = "B", "B", 18
_UPVALUE23_, ("A")[28], ("B")[14] = "B", "B", 19
_UPVALUE23_, ("A")[28], ("B")[15] = "B", "B", 20
_UPVALUE23_, ("A")[28], ("B")[16] = "B", "B", 11
_UPVALUE23_, ("A")[28], ("B")[17] = "B", "B", 12
_UPVALUE23_, ("A")[28], ("B")[18] = "B", "B", 13
_UPVALUE23_, ("A")[28], ("B")[19] = "B", "B", 14
_UPVALUE23_, ("A")[28], ("B")[20] = "B", "B", 15
_UPVALUE23_, ("A")[28], ("B")[21] = "B", "B", 6
_UPVALUE23_, ("A")[28], ("B")[22] = "B", "B", 7
_UPVALUE23_, ("A")[28], ("B")[23] = "B", "B", 8
_UPVALUE23_, ("A")[28], ("B")[24] = "B", "B", 9
_UPVALUE23_, ("A")[28], ("B")[25] = "B", "B", 10
_UPVALUE23_, ("A")[28], ("B")[26] = "B", "B", 1
_UPVALUE23_, ("A")[28], ("B")[27] = "B", "B", 2
_UPVALUE23_, ("A")[28], ("B")[28] = "B", "B", 3
_UPVALUE23_, ("A")[29], ("B")[1] = "B", "B", 26
_UPVALUE23_, ("A")[29], ("B")[2] = "B", "B", 27
_UPVALUE23_, ("A")[29], ("B")[3] = "B", "B", 28
_UPVALUE23_, ("A")[29], ("B")[4] = "B", "B", 29
_UPVALUE23_, ("A")[29], ("B")[5] = "B", "B", 30
_UPVALUE23_, ("A")[29], ("B")[6] = "B", "B", 21
_UPVALUE23_, ("A")[29], ("B")[7] = "B", "B", 22
_UPVALUE23_, ("A")[29], ("B")[8] = "B", "B", 23
_UPVALUE23_, ("A")[29], ("B")[9] = "B", "B", 24
_UPVALUE23_, ("A")[29], ("B")[10] = "B", "B", 25
_UPVALUE23_, ("A")[29], ("B")[11] = "B", "B", 16
_UPVALUE23_, ("A")[29], ("B")[12] = "B", "B", 17
_UPVALUE23_, ("A")[29], ("B")[13] = "B", "B", 18
_UPVALUE23_, ("A")[29], ("B")[14] = "B", "B", 19
_UPVALUE23_, ("A")[29], ("B")[15] = "B", "B", 20
_UPVALUE23_, ("A")[29], ("B")[16] = "B", "B", 11
_UPVALUE23_, ("A")[29], ("B")[17] = "B", "B", 12
_UPVALUE23_, ("A")[29], ("B")[18] = "B", "B", 13
_UPVALUE23_, ("A")[29], ("B")[19] = "B", "B", 14
_UPVALUE23_, ("A")[29], ("B")[20] = "B", "B", 15
_UPVALUE23_, ("A")[29], ("B")[21] = "B", "B", 6
_UPVALUE23_, ("A")[29], ("B")[22] = "B", "B", 7
_UPVALUE23_, ("A")[29], ("B")[23] = "B", "B", 8
_UPVALUE23_, ("A")[29], ("B")[24] = "B", "B", 9
_UPVALUE23_, ("A")[29], ("B")[25] = "B", "B", 10
_UPVALUE23_, ("A")[29], ("B")[26] = "B", "B", 1
_UPVALUE23_, ("A")[29], ("B")[27] = "B", "B", 2
_UPVALUE23_, ("A")[29], ("B")[28] = "B", "B", 3
_UPVALUE23_, ("A")[29], ("B")[29] = "B", "B", 4
_UPVALUE1_, _ENV, ("A")[30], ("B")[1] = 26, "B", "B", 26
_UPVALUE1_, _ENV, ("A")[30], ("B")[2] = 26, "B", "B", 27
_UPVALUE1_, _ENV, ("A")[30], ("B")[3] = 26, "B", "B", 28
_UPVALUE1_, _ENV, ("A")[30], ("B")[4] = 26, "B", "B", 29
_UPVALUE1_, _ENV, ("A")[30], ("B")[5] = 26, "B", "B", 30
_UPVALUE1_, _ENV, ("A")[30], ("B")[6] = 26, "B", "B", 21
_UPVALUE1_, _ENV, ("A")[30], ("B")[7] = 26, "B", "B", 22
_UPVALUE1_, _ENV, ("A")[30], ("B")[8] = 26, "B", "B", 23
_UPVALUE1_, _ENV, ("A")[30], ("B")[9] = 26, "B", "B", 24
_UPVALUE1_, _ENV, ("A")[30], ("B")[10] = 26, "B", "B", 25
_UPVALUE1_, _ENV, ("A")[30], ("B")[11] = 26, "B", "B", 16
_UPVALUE1_, _ENV, ("A")[30], ("B")[12] = 26, "B", "B", 17
_UPVALUE1_, _ENV, ("A")[30], ("B")[13] = 26, "B", "B", 18
_UPVALUE1_, _ENV, ("A")[30], ("B")[14] = 26, "B", "B", 19
_UPVALUE1_, _ENV, ("A")[30], ("B")[15] = 26, "B", "B", 20
_UPVALUE1_, _ENV, ("A")[30], ("B")[16] = 26, "B", "B", 11
_UPVALUE1_, _ENV, ("A")[30], ("B")[17] = 26, "B", "B", 12
_UPVALUE1_, _ENV, ("A")[30], ("B")[18] = 26, "B", "B", 13
_UPVALUE1_, _ENV, ("A")[30], ("B")[19] = 26, "B", "B", 14
_UPVALUE1_, _ENV, ("A")[30], ("B")[20] = 26, "B", "B", 15
_UPVALUE1_, _ENV, ("A")[30], ("B")[21] = 26, "B", "B", 6
_UPVALUE1_, _ENV, ("A")[30], ("B")[22] = 26, "B", "B", 7
_UPVALUE1_, _ENV, ("A")[30], ("B")[23] = 26, "B", "B", 8
_UPVALUE1_, _ENV, ("A")[30], ("B")[24] = 26, "B", "B", 9
_UPVALUE1_, _ENV, ("A")[30], ("B")[25] = 26, "B", "B", 10
_UPVALUE1_, _ENV, ("A")[30], ("B")[26] = 26, "B", "B", 1
_UPVALUE1_, _ENV, ("A")[30], ("B")[27] = 26, "B", "B", 2
_UPVALUE1_, _ENV, ("A")[30], ("B")[28] = 26, "B", "B", 3
_UPVALUE1_, _ENV, ("A")[30], ("B")[29] = 26, "B", "B", 4
_UPVALUE1_, _ENV, ("A")[30], ("B")[30] = 26, "B", "B", 5
local SoldierMatrix = "A"
_UPVALUE2_, ("B")[1], (26)[1] = 26, 26, 1
;("B")[2], (26)[1] = 26, 1
;("B")[2], (26)[2] = 26, 2
local SoldierEliteMatrix = "B"
local scaleEliteMatrix = 0.65
_ENV = 1
_ENV = 29
;(29).row = 2
;(1)[BUILDID.STABLES], (29).col = 29, 5
_ENV = 29
;(29).row = 3
;(1)[BUILDID.CHARIOT_PLANT], (29).col = 29, 6
_ENV = 29
;(29).row = 3
;(1)[BUILDID.RANGE], (29).col = 29, 6
_ENV = 29
;(29).row = 1
;(1)[BUILDID.BARRACKS], (29).col = 29, 2
_ENV = 29
;(29).row = 1
_ENV, (1)[BUILDID.ELITE_PALACE], (29).col = BUILDID.ELITE_PALACE, 29, 2
local MatrixRowAndCol = 1
BUILDID.ELITE_PALACE[BUILDID.ELITE_PALACE] = 0
BUILDID.ELITE_PALACE[BUILDID.STABLES] = 1
BUILDID.ELITE_PALACE[BUILDID.CHARIOT_PLANT] = 2
BUILDID.ELITE_PALACE[BUILDID.RANGE] = 3
local _ENV, BUILDID.ELITE_PALACE[BUILDID.BARRACKS], SoldierSortIndex = BUILDID.BARRACKS, 4, BUILDID.ELITE_PALACE
BUILDID.BARRACKS[BUILDID.STABLES] = 10
BUILDID.BARRACKS[BUILDID.CHARIOT_PLANT] = 18
BUILDID.BARRACKS[BUILDID.RANGE] = 18
BUILDID.BARRACKS[BUILDID.BARRACKS] = 2
local BUILDID.BARRACKS[BUILDID.ELITE_PALACE], MaxMatrixSoldierNumber = 2, BUILDID.BARRACKS
local SingleMatrixRealSoldierNumber = 360
_ENV = 21
;(21)[BUILDID.ELITE_PALACE] = SingleMatrixRealSoldierNumber / MaxMatrixSoldierNumber[BUILDID.ELITE_PALACE]
;(21)[BUILDID.STABLES] = SingleMatrixRealSoldierNumber / MaxMatrixSoldierNumber[BUILDID.STABLES]
;(21)[BUILDID.CHARIOT_PLANT] = SingleMatrixRealSoldierNumber / MaxMatrixSoldierNumber[BUILDID.CHARIOT_PLANT]
;(21)[BUILDID.RANGE] = SingleMatrixRealSoldierNumber / MaxMatrixSoldierNumber[BUILDID.RANGE]
local (21)[BUILDID.BARRACKS], MatrixSoldierNumberMap = SingleMatrixRealSoldierNumber / MaxMatrixSoldierNumber[BUILDID.BARRACKS], 21
local cityBuildSoldiersMatrix = class("cityBuildSoldiersMatrix", function()
	local view = include("baseView")
	return view.new(cc.size(0, 0), false)
end)
function cityBuildSoldiersMatrix:ctor()
	_ENV, self.soldierMatrixsArray, _ENV = nil, nil, nil
	;(nil)[BUILDID.ELITE_PALACE], (nil).dynamic, _ENV, (nil).static, _ENV, _ENV = nil, nil, nil, nil, nil, nil
	;(nil)[BUILDID.STABLES], (nil).dynamic, _ENV, (nil).static, _ENV, _ENV = nil, nil, nil, nil, nil, nil
	;(nil)[BUILDID.CHARIOT_PLANT], (nil).dynamic, _ENV, (nil).static, _ENV, _ENV = nil, nil, nil, nil, nil, nil
	;(nil)[BUILDID.RANGE], (nil).dynamic, _ENV, (nil).static, _ENV, _ENV = nil, nil, nil, nil, nil, nil
	self.cacheMatrixs, (nil)[BUILDID.BARRACKS], (nil).dynamic, _ENV, (nil).static, _ENV, _ENV = nil, nil, nil, nil, nil, nil, nil
end
function cityBuildSoldiersMatrix:initWithData(data)
	self.matrixType = data.matrixType
	local imgName = "FrameAnimation/worldMapSolider"
	local paddingColX = 30
	local paddingRowY = 18
	if self.matrixType == cityBuildConstDef.matrixType.normal then
		self.row = 6
		self.col = 5
		self.A = cc.p(0, 315)
		self.B = cc.p(520, 40)
		self.D = cc.p(420, 480)
		local layerColor = cc.Layer:create()
		layerColor:setContentSize(cc.size(600, 800))
		layerColor:addTo(self, 1)
		layerColor:ignoreAnchorPointForPosition(false)
		layerColor:setAnchorPoint(cc.p(0.0, 0.0))
		layerColor:setPosition(0, 0)
		_ENV, self.graphNode = layerColor.setPosition, layerColor
		self.enterIndex, layerColor.setPosition[1] = layerColor.setPosition, 1
		self.maxMatrix = #SoldierMatrix
	elseif self.matrixType == cityBuildConstDef.matrixType.elite then
		self.row = 1
		self.col = 2
		self.A = cc.p(0, 300)
		self.B = cc.p(550, 10)
		self.D = cc.p(110, 360)
		local layerColor = cc.Layer:create()
		layerColor:setContentSize(cc.size(600, 400))
		layerColor:addTo(self, 1)
		layerColor:ignoreAnchorPointForPosition(false)
		layerColor:setAnchorPoint(cc.p(0.0, 0.0))
		layerColor:setPosition(0, 0)
		_ENV, self.graphNode = layerColor.setPosition, layerColor
		self.enterIndex, layerColor.setPosition[1] = layerColor.setPosition, 1
		self.maxMatrix = #SoldierEliteMatrix
		paddingColX = 120
	end
	local cityBuildTroopsMatrix = include("cityBuildTroopsMatrix")
	local cityBuildTroopsMatrixNode = cityBuildTroopsMatrix.new()
	cityBuildTroopsMatrixNode:initWithUIType(cityBuildConstDef.uiType.UI_TYPE_ALONE, nil, imgName)
	cityBuildTroopsMatrixNode:setPosition(0, 0)
	cityBuildTroopsMatrixNode:addTo(self.graphNode, 1)
	local bid
	cityBuildConstDef = 1
	;(1).bid = bid
	;(1).A = self.A
	;(1).B = self.B
	;(1).D = self.D
	;(1).soldierNumber = 0
	;(1).row = self.row
	;(1).col = self.col
	;(1).isShowParallelgram = isShowParallelgram
	;(1).paddingColX = paddingColX
	;(1).paddingRowY = paddingRowY
	;(1).isCustom = true
	cityBuildTroopsMatrixNode:initWithTroopsData(1)
	local pointsArray, pointsAArray, pointsBArray, pointsCArray, pointsDArray, ABCDBaseZero = cityBuildTroopsMatrixNode:getParallelgramPointArray(self.row, self.col, self.A, self.B, self.D)
	self.smallA = ABCDBaseZero.A
	self.smallB = ABCDBaseZero.B
	self.smallC = ABCDBaseZero.C
	self.smallD = ABCDBaseZero.D
	self.enterPrePosArray, cityBuildConstDef, self.enterPosArray, cityBuildConstDef, self.matrixPointsArray = ABCDBaseZero.D, ABCDBaseZero.D, ABCDBaseZero.D, ABCDBaseZero.D, pointsArray
	for i, v in ipairs(self.enterIndex) do
		local posX = (pointsAArray[v].x + pointsDArray[v].x) / 2
		local posY = (pointsAArray[v].y + pointsDArray[v].y) / 2
		local prePosX = 2 * pointsDArray[v].x - (pointsCArray[v].x + pointsDArray[v].x) / 2
		local prePosY = 2 * pointsDArray[v].y - (pointsCArray[v].y + pointsDArray[v].y) / 2
		self.enterPosArray[v] = cc.p(posX, posY)
		self.enterPrePosArray[v] = cc.p(prePosX, prePosY)
	end
	self.matrixNumber = 0
	self.cityBuildTroopsMatrixNode = cityBuildTroopsMatrixNode
	self:updateMatrixs()
end
function cityBuildSoldiersMatrix:updateMatrixPos(needRefreshTb)
	local matrixIndex = 1
	local cityBuildConstDef, soldierMatrixs
	if self.matrixType == cityBuildConstDef.matrixType.normal then
		soldierMatrixs = SoldierMatrix[self.matrixNumber]
	else
		soldierMatrixs = SoldierEliteMatrix[self.matrixNumber]
	end
	if soldierMatrixs == nil then
		return
	end
	needRefreshTb = needRefreshTb or soldierMatrixs
	for i, matrixIndex in ipairs(needRefreshTb) do
		local soldierMatrixItem = self.soldierMatrixsArray[matrixIndex]
		if soldierMatrixItem ~= nil then
			local pos = soldierMatrixs[matrixIndex]
			if pos > #self.matrixPointsArray then
				return
			end
			soldierMatrixItem:setPosition(self.matrixPointsArray[pos].x, self.matrixPointsArray[pos].y)
			soldierMatrixItem:updateSoldierPos()
			local yIndex = math.floor((pos - 1) / self.col)
			local xIndex = math.fmod(pos - 1, self.col)
			local zOrder = self.row * self.col + 10 - yIndex * self.col + xIndex
			soldierMatrixItem:setLocalZOrder(zOrder)
		end
	end
end
function cityBuildSoldiersMatrix:updateMatrixs(data)
	local cityBuildConstDef, matrixsData
	if self.matrixType == cityBuildConstDef.matrixType.normal then
		matrixsData = armyLogic.getArmyCateCount()
	elseif self.matrixType == cityBuildConstDef.matrixType.elite then
		matrixsData = armyLogic.getEliteArmyCateCount()
	end
	local numberOfSoldierTypes = #matrixsData
	if numberOfSoldierTypes == 0 then
		return
	end
	local totalNumber = 0
	for i = 1, numberOfSoldierTypes do
		totalNumber = totalNumber + matrixsData[i].number
	end
	local cityBuildConstDef, arrayMatrix = (for index), 1
	if numberOfSoldierTypes == 1 then
		if totalNumber <= 10800 then
			arrayMatrix = self:getConvertedMatrixData(1, matrixsData, totalNumber)
		else
			arrayMatrix = self:getConvertedMatrixData(2, matrixsData, totalNumber)
		end
	elseif totalNumber <= 10800 then
		arrayMatrix = self:getConvertedMatrixData(3, matrixsData, totalNumber)
	else
		arrayMatrix = self:getConvertedMatrixData(4, matrixsData, totalNumber)
	end
	local oldMatrixNumber = #self.soldierMatrixsArray
	local newMatrixNumber = #arrayMatrix
	local cityBuildConstDef, needRefreshTb = 4, 4
	local bigNumber = math.max(oldMatrixNumber, newMatrixNumber)
	for i = 1, bigNumber do
		if self.soldierMatrixsArray[i] then
			if not arrayMatrix[i] then
				local matrix = self.soldierMatrixsArray[i]
				self:addToCache(matrix)
				self.soldierMatrixsArray[i] = nil
			elseif not self:judgeSame(self.soldierMatrixsArray[i], arrayMatrix[i]) then
				table.insert(needRefreshTb, i)
				local matrix = self.soldierMatrixsArray[i]
				self:addToCache(matrix)
				self.soldierMatrixsArray[i] = nil
			end
		else
			if arrayMatrix[i] then
				table.insert(needRefreshTb, i)
			else
			end
		end
	end
	for i, index in ipairs(needRefreshTb) do
		local matrixData = arrayMatrix[index]
		local matrix = self:getMatrix(matrixData)
		self.soldierMatrixsArray[index] = matrix
	end
	local matrixNumber = #arrayMatrix
	self.matrixNumber = matrixNumber
	self:updateMatrixPos(needRefreshTb)
end
function cityBuildSoldiersMatrix:judgeSame(oldMatrix, matrixData)
	for i, v in ipairs(attribCompare) do
		if oldMatrix[v] ~= matrixData[v] then
			return false
		end
	end
	for i, v in ipairs(posCompare) do
		if oldMatrix[v].x ~= matrixData[v].x or oldMatrix[v].y ~= matrixData[v].y then
			return false
		end
	end
	return true
end
function cityBuildSoldiersMatrix:getAdjustedSoldierNumber(bid, number)
	local soldierNumber = 0
	if bid == BUILDID.STABLES then
		if number <= 120 then
			soldierNumber = MaxMatrixSoldierNumber[bid] * 1 / 2
		elseif number <= 359 then
			soldierNumber = MaxMatrixSoldierNumber[bid] * 3 / 4
		else
			soldierNumber = MaxMatrixSoldierNumber[bid]
		end
	elseif number <= 120 then
		soldierNumber = MaxMatrixSoldierNumber[bid] * 1 / 3
	elseif number <= 359 then
		soldierNumber = MaxMatrixSoldierNumber[bid] * 2 / 3
	else
		soldierNumber = MaxMatrixSoldierNumber[bid]
	end
	return soldierNumber
end
function cityBuildSoldiersMatrix:getSoliderNumber(bid, number, unitNumber)
	local unitNumber = unitNumber or MatrixSoldierNumberMap[bid]
	local fmod = math.fmod(number, unitNumber)
	local soldierNumber = math.floor(number / unitNumber)
	if 0 < fmod then
		soldierNumber = soldierNumber + 1
	end
	soldierNumber = math.min(soldierNumber, MaxMatrixSoldierNumber[bid])
	return soldierNumber
end
function cityBuildSoldiersMatrix:getUnitSoldierNumber(bid, singleMatrixRealSoldierNumber)
	local unitNumber = singleMatrixRealSoldierNumber / MaxMatrixSoldierNumber[bid]
	return unitNumber
end
function cityBuildSoldiersMatrix:getConvertedMatrixData(opType, matrixsData, totalNumber)
	if opType == 1 then
		return self:getConvertedMatrixDataByOpType1(matrixsData, totalNumber)
	elseif opType == 2 then
		return self:getConvertedMatrixDataByOpType2(matrixsData, totalNumber)
	elseif opType == 3 then
		return self:getConvertedMatrixDataByOpType3(matrixsData, totalNumber)
	elseif opType == 4 then
		return self:getConvertedMatrixDataByOpType4(matrixsData, totalNumber)
	end
end
function cityBuildSoldiersMatrix:getConvertedMatrixDataByOpType1(matrixsData, totalNumber)
	local bid = matrixsData[1].bid
	local number = totalNumber
	local MatrixSoldierNumberMap, arrayMatrix
	local numberOfMatrix = 1
	if number < MatrixSoldierNumberMap[bid] then
		number = MatrixSoldierNumberMap[bid]
	end
	local numFloor = math.floor(number / SingleMatrixRealSoldierNumber)
	local numFmod = math.fmod(number, SingleMatrixRealSoldierNumber)
	if numFloor >= self.maxMatrix then
		numFloor = math.min(self.maxMatrix, numFloor)
		for i = numberOfMatrix, numFloor do
			MatrixSoldierNumberMap = nil
			;(nil).bid = bid
			;(nil).A = self.smallA
			;(nil).B = self.smallB
			;(nil).D = self.smallD
			;(nil).soldierNumber = MaxMatrixSoldierNumber[bid]
			;(nil).row = MatrixRowAndCol[bid].row
			;(nil).col = MatrixRowAndCol[bid].col
			;(nil).isShowParallelgram = isShowParallelgram
			arrayMatrix[i], (nil).isTroopMatrix = nil, false
		end
	else
		for i = numberOfMatrix, numFloor do
			MatrixSoldierNumberMap = nil
			;(nil).bid = bid
			;(nil).A = self.smallA
			;(nil).B = self.smallB
			;(nil).D = self.smallD
			;(nil).soldierNumber = MaxMatrixSoldierNumber[bid]
			;(nil).row = MatrixRowAndCol[bid].row
			;(nil).col = MatrixRowAndCol[bid].col
			;(nil).isShowParallelgram = isShowParallelgram
			arrayMatrix[i], (nil).isTroopMatrix = nil, false
		end
		if 0 < numFmod then
			numberOfMatrix = #arrayMatrix + 1
			if numFmod < MatrixSoldierNumberMap[bid] then
				numFmod = MatrixSoldierNumberMap[bid]
			end
			local soldierNumber = math.floor(numFmod / MatrixSoldierNumberMap[bid])
			local fmodeOfFmode = math.fmod(numFmod, MatrixSoldierNumberMap[bid])
			if 0 < fmodeOfFmode then
				soldierNumber = soldierNumber + 1
			end
			MatrixSoldierNumberMap, soldierNumber = math.min(soldierNumber, MaxMatrixSoldierNumber[bid]), math.min(soldierNumber, MaxMatrixSoldierNumber[bid])
			math.min(soldierNumber, MaxMatrixSoldierNumber[bid]).bid = bid
			math.min(soldierNumber, MaxMatrixSoldierNumber[bid]).A = self.smallA
			math.min(soldierNumber, MaxMatrixSoldierNumber[bid]).B = self.smallB
			math.min(soldierNumber, MaxMatrixSoldierNumber[bid]).D = self.smallD
			math.min(soldierNumber, MaxMatrixSoldierNumber[bid]).soldierNumber = soldierNumber
			math.min(soldierNumber, MaxMatrixSoldierNumber[bid]).row = MatrixRowAndCol[bid].row
			math.min(soldierNumber, MaxMatrixSoldierNumber[bid]).col = MatrixRowAndCol[bid].col
			math.min(soldierNumber, MaxMatrixSoldierNumber[bid]).isShowParallelgram = isShowParallelgram
			arrayMatrix[numberOfMatrix], math.min(soldierNumber, MaxMatrixSoldierNumber[bid]).isTroopMatrix = math.min(soldierNumber, MaxMatrixSoldierNumber[bid]), false
		end
	end
	return arrayMatrix
end
function cityBuildSoldiersMatrix:getConvertedMatrixDataByOpType2(matrixsData, totalNumber)
	local bid = matrixsData[1].bid
	local number = totalNumber
	local numberOfMatrix = 1
	local MaxMatrixSoldierNumber, arrayMatrix
	for i = numberOfMatrix, self.maxMatrix do
		MaxMatrixSoldierNumber = nil
		;(nil).bid = bid
		;(nil).A = self.smallA
		;(nil).B = self.smallB
		;(nil).D = self.smallD
		;(nil).soldierNumber = MaxMatrixSoldierNumber[bid]
		;(nil).row = MatrixRowAndCol[bid].row
		;(nil).col = MatrixRowAndCol[bid].col
		;(nil).isShowParallelgram = isShowParallelgram
		arrayMatrix[i], (nil).isTroopMatrix = nil, false
	end
	return arrayMatrix
end
function cityBuildSoldiersMatrix:getConvertedMatrixDataByOpType3(matrixsData, totalNumber, singleMatrixRealSoldierNumber)
	local SingleMatrixRealSoldierNumber = singleMatrixRealSoldierNumber or SingleMatrixRealSoldierNumber
	local numberOfSoldierTypes = #matrixsData
	local SingleMatrixRealSoldierNumber, arrayFmods
	local SingleMatrixRealSoldierNumber, arrayMatrix
	local SingleMatrixRealSoldierNumber, arrayNum
	local SingleMatrixRealSoldierNumber, arrayFmodNum
	local numOfMatrix = 0
	for i = 1, numberOfSoldierTypes do
		local bid = matrixsData[i].bid
		local number = matrixsData[i].number
		if number < MatrixSoldierNumberMap[bid] then
			number = MatrixSoldierNumberMap[bid]
		end
		local numFloor = math.floor(number / SingleMatrixRealSoldierNumber)
		local numFmod = math.fmod(number, SingleMatrixRealSoldierNumber)
		SingleMatrixRealSoldierNumber = number
		number.bid = bid
		SingleMatrixRealSoldierNumber, arrayNum[i], number.number = number, number, numFloor
		number.bid = bid
		arrayFmods[i], number.fmod = number, numFmod
	end
	local SingleMatrixRealSoldierNumber, indexMap = (for index), 1
	for it, v in ipairs(arrayFmods) do
		for i = 1, #matrixsData do
			if matrixsData[i].bid == v.bid then
				indexMap[v.bid] = i
				break
			end
		end
	end
	table.sort(arrayFmods, function(a, b)
		local aIndex = indexMap[a.bid]
		local bIndex = indexMap[b.bid]
		if matrixsData[aIndex].number == matrixsData[bIndex].number then
			return SoldierSortIndex[a.bid] < SoldierSortIndex[b.bid]
		else
			return matrixsData[aIndex].number > matrixsData[bIndex].number
		end
	end)
	local numOfFmodNum = 1
	for i = 1, numberOfSoldierTypes do
		if 0 < arrayFmods[i].fmod then
			local bid = arrayFmods[i].bid
			local fmod = arrayFmods[i].fmod
			if fmod < MatrixSoldierNumberMap[bid] then
				fmod = MatrixSoldierNumberMap[bid]
			end
			local soldierNum = self:getSoliderNumber(bid, fmod, self:getUnitSoldierNumber(bid, SingleMatrixRealSoldierNumber))
			SingleMatrixRealSoldierNumber = self
			self.bid = bid
			arrayFmodNum[numOfFmodNum], self.number = self, soldierNum
			numOfFmodNum = numOfFmodNum + 1
		end
	end
	local iIndexOfMatrix = 1
	local SingleMatrixRealSoldierNumber, matrixInfo = numberOfSoldierTypes, numberOfSoldierTypes
	for i = 1, numberOfSoldierTypes do
		local bid = arrayNum[i].bid
		local numberOfMatrix = arrayNum[i].number
		local soldierNumber = 0
		local numBegin = iIndexOfMatrix
		for j = 1, numberOfMatrix do
			SingleMatrixRealSoldierNumber = self:getUnitSoldierNumber(bid, SingleMatrixRealSoldierNumber)
			self:getUnitSoldierNumber(bid, SingleMatrixRealSoldierNumber).bid = bid
			self:getUnitSoldierNumber(bid, SingleMatrixRealSoldierNumber).A = self.smallA
			self:getUnitSoldierNumber(bid, SingleMatrixRealSoldierNumber).B = self.smallB
			self:getUnitSoldierNumber(bid, SingleMatrixRealSoldierNumber).D = self.smallD
			self:getUnitSoldierNumber(bid, SingleMatrixRealSoldierNumber).soldierNumber = MaxMatrixSoldierNumber[bid]
			self:getUnitSoldierNumber(bid, SingleMatrixRealSoldierNumber).row = MatrixRowAndCol[bid].row
			self:getUnitSoldierNumber(bid, SingleMatrixRealSoldierNumber).col = MatrixRowAndCol[bid].col
			self:getUnitSoldierNumber(bid, SingleMatrixRealSoldierNumber).isShowParallelgram = isShowParallelgram
			arrayMatrix[iIndexOfMatrix], self:getUnitSoldierNumber(bid, SingleMatrixRealSoldierNumber).isTroopMatrix = self:getUnitSoldierNumber(bid, SingleMatrixRealSoldierNumber)
			iIndexOfMatrix = iIndexOfMatrix + 1
		end
		for k = 1, #arrayFmodNum do
			if arrayFmodNum[k].bid == bid then
				SingleMatrixRealSoldierNumber = arrayFmodNum[k].bid
				arrayFmodNum[k].bid.bid = bid
				arrayFmodNum[k].bid.A = self.smallA
				arrayFmodNum[k].bid.B = self.smallB
				arrayFmodNum[k].bid.D = self.smallD
				arrayFmodNum[k].bid.soldierNumber = arrayFmodNum[k].number
				arrayFmodNum[k].bid.row = MatrixRowAndCol[bid].row
				arrayFmodNum[k].bid.col = MatrixRowAndCol[bid].col
				arrayFmodNum[k].bid.isShowParallelgram = isShowParallelgram
				arrayMatrix[iIndexOfMatrix], arrayFmodNum[k].bid.isTroopMatrix = arrayFmodNum[k].bid, false
				iIndexOfMatrix = iIndexOfMatrix + 1
			end
		end
		local numEnd = iIndexOfMatrix
		SingleMatrixRealSoldierNumber = arrayFmodNum[k].bid
		arrayFmodNum[k].bid.bid = bid
		arrayFmodNum[k].bid.num = numEnd - numBegin
		arrayFmodNum[k].bid.lastIndex = iIndexOfMatrix - 1
		table.insert(matrixInfo, #matrixInfo + 1, arrayFmodNum[k].bid)
	end
	self:trimArrayMatrix(arrayMatrix, matrixInfo)
	return arrayMatrix
end
function cityBuildSoldiersMatrix:getConvertedMatrixDataByOpType4(matrixsData, totalNumber)
	local SingleMatrixRealSoldierNumber = math.floor(totalNumber / self.maxMatrix)
	return self:getConvertedMatrixDataByOpType3(matrixsData, totalNumber, SingleMatrixRealSoldierNumber)
end
function cityBuildSoldiersMatrix:getLastSoldierMatrixPosArrayByBid(bid)
	local found = false
	local foundIndex = 1
	local retPos = cc.p(400, 500)
	local _ENV, soldierMatrixs = 400, 400
	if bid == BUILDID.ELITE_PALACE then
		soldierMatrixs = SoldierEliteMatrix[self.maxMatrix]
	else
		soldierMatrixs = SoldierMatrix[self.maxMatrix]
	end
	if soldierMatrixs == nil then
		return
	end
	if self.matrixNumber == 0 or self.matrixNumber == nil then
		retPos = soldierMatrixs[1]
		local matrixPosition = self:getEnterPosArrayByMatrixIndex(retPos)
		retPos = matrixPosition
		return retPos
	end
	for i = 1, self.matrixNumber do
		local soldierMatrixItem = self.soldierMatrixsArray[i]
		if soldierMatrixItem ~= nil then
			local pos = soldierMatrixs[i]
			if pos == nil then
			end
			if pos > #self.matrixPointsArray then
				return
			end
			local soldierBid = soldierMatrixItem:getBid()
			if bid == soldierBid then
				found = true
				foundIndex = i
				retPos = pos
			end
		end
	end
	if found == false then
		foundIndex = self.matrixNumber + 1
		if foundIndex > self.maxMatrix then
			foundIndex = self.maxMatrix
		end
		retPos = soldierMatrixs[foundIndex]
	end
	print("foundIndex = " .. foundIndex .. " ret pos = " .. retPos)
	local matrixPosition = self:getEnterPosArrayByMatrixIndex(retPos)
	retPos = matrixPosition
	return retPos
end
function cityBuildSoldiersMatrix:trimArrayMatrix(arrayMatrix, matrixInfo)
	if #arrayMatrix > self.maxMatrix then
		while #arrayMatrix > self.maxMatrix do
			local bidIndex = 0
			local numMax = 0
			local deleteIndex = 1
			local arrayIndex = 1
			for i, v in ipairs(matrixInfo) do
				local bid = v.bid
				local num = v.num
				local lastIndex = v.lastIndex
				if numMax < num then
					bidIndex = bid
					deleteIndex = lastIndex
					numMax = num
					arrayIndex = i
				end
			end
			matrixInfo[arrayIndex].num = numMax - 1
			matrixInfo[arrayIndex].lastIndex = deleteIndex - 1
			for i, v in ipairs(matrixInfo) do
				if i > arrayIndex then
					matrixInfo[i].lastIndex = matrixInfo[i].lastIndex - 1
				end
			end
			table.remove(arrayMatrix, deleteIndex)
		end
	end
end
function cityBuildSoldiersMatrix:getEnterPosIndexByMatrixIndex(index)
	local retIndex = 1
	if 1 <= index and index < 6 then
		retIndex = 1
	elseif 6 <= index and index < 11 then
		retIndex = 6
	elseif 11 <= index and index < 16 then
		retIndex = 11
	elseif 16 <= index and index < 21 then
		retIndex = 16
	elseif 21 <= index and index < 26 then
		retIndex = 21
	elseif 26 <= index and index <= 30 then
		retIndex = 26
	end
	return retIndex
end
function cityBuildSoldiersMatrix:getEnterPosArrayByMatrixIndex(index)
	local retIndex = self:getEnterPosIndexByMatrixIndex(index)
	_UPVALUE2_ = self
	self[1] = self.enterPrePosArray[retIndex]
	self[2] = self.enterPosArray[retIndex]
	return self
end
function cityBuildSoldiersMatrix:createSoldierMatrix(data)
	local bid = tonumber(data.bid)
	local soldierNumber = MaxMatrixSoldierNumber[bid]
	local cityBuildTroopsMatrix = include("cityBuildTroopsMatrix")
	local singleMatrix = cityBuildTroopsMatrix.new()
	singleMatrix:initWithUIType(cityBuildConstDef.uiType.UI_TYPE_RELYON, self.cityBuildTroopsMatrixNode.ContentNode)
	_ENV = singleMatrix.initWithUIType
	singleMatrix.initWithUIType.bid = bid
	singleMatrix.initWithUIType.A = self.smallA
	singleMatrix.initWithUIType.B = self.smallB
	singleMatrix.initWithUIType.D = self.smallD
	singleMatrix.initWithUIType.row = MatrixRowAndCol[bid].row
	singleMatrix.initWithUIType.col = MatrixRowAndCol[bid].col
	singleMatrix.initWithUIType.soldierNumber = soldierNumber
	singleMatrix.initWithUIType.isShowParallelgram = isShowParallelgram
	local singleMatrix.initWithUIType.isTroopMatrix, matrixData = false, singleMatrix.initWithUIType
	if self.matrixType == cityBuildConstDef.matrixType.elite then
		matrixData.scale = scaleEliteMatrix
	end
	singleMatrix:initWithTroopsData(matrixData)
	singleMatrix:setAnchorPoint(cc.p(0.5, 0.5))
	singleMatrix:setCacheType(key_static)
	singleMatrix:addTo(self.cityBuildTroopsMatrixNode.graphNode, 1)
	return singleMatrix
end
function cityBuildSoldiersMatrix:addToCache(troopMatrix)
	local bid = troopMatrix.bid
	local cacheType = troopMatrix:getCacheType()
	local cache = self.cacheMatrixs[bid][cacheType]
	assert(cache, "cache not found " .. ": bid = " .. bid .. ", cacheType = " .. cacheType)
	troopMatrix:setVisible(false)
	table.insert(cache, troopMatrix)
end
function cityBuildSoldiersMatrix:getMatrixFromCache(bid, cacheType)
	local tb = self.cacheMatrixs[bid][cacheType]
	if not tb or #tb <= 0 then
		return nil
	end
	local matrix = table.remove(tb)
	matrix:setVisible(true)
	return matrix
end
function cityBuildSoldiersMatrix:getMatrix(data)
	local bid = tonumber(data.bid)
	local soldierNumber = data.soldierNumber
	local cacheType = key_static
	if soldierNumber < MaxMatrixSoldierNumber[bid] then
		cacheType = key_dynamic
	end
	local matrix = self:getMatrixFromCache(bid, cacheType)
	matrix = matrix or self:createSoldierMatrix(data)
	if cacheType == key_dynamic then
		matrix:updateSoldierNumber(soldierNumber)
		matrix:setCacheType(key_dynamic)
	end
	return matrix
end
return cityBuildSoldiersMatrix
