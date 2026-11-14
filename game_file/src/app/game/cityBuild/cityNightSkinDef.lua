local cityNightSkinDef.castleNightSkinDef, _ENV, _ENV, cityNightSkinDef
local _ENV, castleNightSkinDef_koh
local _ENV, castleNightSkinDef_ros
SoraDMergeDefineTable(cityNightSkinDef.castleNightSkinDef, castleNightSkinDef_koh, castleNightSkinDef_ros, true)
cityNightSkinDef.castleNightSkinDefBzt, _ENV = SoraDMergeDefineTable, SoraDMergeDefineTable
_ENV, _ENV, cityNightSkinDef.getCastleNightSkinConfig = cityNightSkinDef.castleNightSkinDef, function(model)
	if SoraDGetFactionType() == FACTION_TYPE.FACTION_BYZANTINE then
		return cityNightSkinDef.castleNightSkinDefBzt[model] or cityNightSkinDef.castleNightSkinDef[model]
	else
		return cityNightSkinDef.castleNightSkinDef[model]
	end
end, function(model)
	if SoraDGetFactionType() == FACTION_TYPE.FACTION_BYZANTINE then
		return cityNightSkinDef.castleNightSkinDefBzt[model] or cityNightSkinDef.castleNightSkinDef[model]
	else
		return cityNightSkinDef.castleNightSkinDef[model]
	end
end
cityNightSkinDef.castleNightSkinDef.gate = "LV1_chengmen.png"
cityNightSkinDef.castleNightSkinDef.gatePos = cc.p(3420.0, 968.0)
cityNightSkinDef.castleNightSkinDef.base = "LV1_jianta_base.png"
cityNightSkinDef.castleNightSkinDef.posL = cc.p(3036.8, 753.5)
_ENV, cityNightSkinDef.castleNightSkinDef.posR = cc.p(3750.0, 1108.5), cc.p(3750.0, 1108.5)
cc.p(3750.0, 1108.5).size = cc.size(120, 120)
_ENV, cityNightSkinDef.castleNightSkinDef.cutL, cc.p(3750.0, 1108.5).pos = cc.p(3750.0, 1108.5), cc.p(3750.0, 1108.5), cc.p(3212.5, 820.5)
cc.p(3750.0, 1108.5).size = cc.size(44, 120)
cityNightSkinDef.castleNightSkinDef.cutR, cc.p(3750.0, 1108.5).pos = cc.p(3750.0, 1108.5), cc.p(3569.5, 955.5)
_ENV, cityNightSkinDef.castleNightSkinDef.wall = cc.p(3750.0, 1108.5), "LV1_chengqiang.png"
cc.p(3750.0, 1108.5)[1] = cc.p(3965.0, 1212.5)
cc.p(3750.0, 1108.5)[2] = cc.p(3838.5, 1151.0)
cc.p(3750.0, 1108.5)[3] = cc.p(3656.0, 1060.5)
cc.p(3750.0, 1108.5)[4] = cc.p(44, 0)
cc.p(3750.0, 1108.5)[5] = cc.p(0, 0)
cc.p(3750.0, 1108.5)[6] = cc.p(3126.0, 801.0)
cc.p(3750.0, 1108.5)[7] = cc.p(2937.0, 709.5)
cc.p(3750.0, 1108.5)[8] = cc.p(2810.5, 646.5)
_ENV, _ENV, cityNightSkinDef.castleNightSkinDef.posArray, cc.p(3750.0, 1108.5)[9] = cc.p(2683.0, 585.0), cc.p(3750.0, 1108.5), cc.p(3750.0, 1108.5), cc.p(2683.0, 585.0)
cc.p(2683.0, 585.0).png = "LV1_jianta.png"
_ENV, cc.p(3750.0, 1108.5)[1], cc.p(2683.0, 585.0).pos = cc.p(2683.0, 585.0), cc.p(2683.0, 585.0), cc.p(3033.0, 848.0)
cc.p(2683.0, 585.0).png = "LV2_jianta.png"
_ENV, cc.p(3750.0, 1108.5)[2], cc.p(2683.0, 585.0).pos = cc.p(2683.0, 585.0), cc.p(2683.0, 585.0), cc.p(3021.0, 849.0)
cc.p(2683.0, 585.0).png = "LV3_jianta.png"
_ENV, cc.p(3750.0, 1108.5)[3], cc.p(2683.0, 585.0).pos = cc.p(2683.0, 585.0), cc.p(2683.0, 585.0), cc.p(3016.0, 845.0)
cc.p(2683.0, 585.0).png = "LV4_jianta.png"
_ENV, cc.p(3750.0, 1108.5)[4], cc.p(2683.0, 585.0).pos = cc.p(2683.0, 585.0), cc.p(2683.0, 585.0), cc.p(3019.0, 842.0)
cc.p(2683.0, 585.0).png = "LV5_jianta.png"
_ENV, cc.p(3750.0, 1108.5)[5], cc.p(2683.0, 585.0).pos = cc.p(2683.0, 585.0), cc.p(2683.0, 585.0), cc.p(3016.0, 846.0)
cc.p(2683.0, 585.0).png = "LV6_jianta.png"
_ENV, cc.p(3750.0, 1108.5)[6], cc.p(2683.0, 585.0).pos = cc.p(2683.0, 585.0), cc.p(2683.0, 585.0), cc.p(3023.0, 839.0)
cc.p(2683.0, 585.0).png = "LV7_jianta.png"
_ENV, cc.p(3750.0, 1108.5)[7], cc.p(2683.0, 585.0).pos = cc.p(2683.0, 585.0), cc.p(2683.0, 585.0), cc.p(3019.0, 847.0)
cc.p(2683.0, 585.0).png = "LV8_jianta.png"
_ENV, _ENV, cityNightSkinDef.castleNightSkinDef.turretL, cc.p(3750.0, 1108.5)[8], cc.p(2683.0, 585.0).pos = cc.p(2683.0, 585.0), cc.p(3750.0, 1108.5), cc.p(3750.0, 1108.5), cc.p(2683.0, 585.0), cc.p(3019.0, 849.0)
cc.p(2683.0, 585.0).png = "LV1_jianta.png"
_ENV, cc.p(3750.0, 1108.5)[1], cc.p(2683.0, 585.0).pos = cc.p(2683.0, 585.0), cc.p(2683.0, 585.0), cc.p(3746.0, 1203.0)
cc.p(2683.0, 585.0).png = "LV2_jianta.png"
_ENV, cc.p(3750.0, 1108.5)[2], cc.p(2683.0, 585.0).pos = cc.p(2683.0, 585.0), cc.p(2683.0, 585.0), cc.p(3734.0, 1204.0)
cc.p(2683.0, 585.0).png = "LV3_jianta.png"
_ENV, cc.p(3750.0, 1108.5)[3], cc.p(2683.0, 585.0).pos = cc.p(2683.0, 585.0), cc.p(2683.0, 585.0), cc.p(3729.0, 1200.0)
cc.p(2683.0, 585.0).png = "LV4_jianta.png"
_ENV, cc.p(3750.0, 1108.5)[4], cc.p(2683.0, 585.0).pos = cc.p(2683.0, 585.0), cc.p(2683.0, 585.0), cc.p(3732.0, 1197.0)
cc.p(2683.0, 585.0).png = "LV5_jianta.png"
_ENV, cc.p(3750.0, 1108.5)[5], cc.p(2683.0, 585.0).pos = cc.p(2683.0, 585.0), cc.p(2683.0, 585.0), cc.p(3729.0, 1201.0)
cc.p(2683.0, 585.0).png = "LV6_jianta.png"
_ENV, cc.p(3750.0, 1108.5)[6], cc.p(2683.0, 585.0).pos = cc.p(2683.0, 585.0), cc.p(2683.0, 585.0), cc.p(3736.0, 1194.0)
cc.p(2683.0, 585.0).png = "LV7_jianta.png"
_ENV, cc.p(3750.0, 1108.5)[7], cc.p(2683.0, 585.0).pos = cc.p(2683.0, 585.0), cc.p(2683.0, 585.0), cc.p(3732.0, 1202.0)
cc.p(2683.0, 585.0).png = "LV8_jianta.png"
_ENV, (function(model)
	if SoraDGetFactionType() == FACTION_TYPE.FACTION_BYZANTINE then
		return cityNightSkinDef.castleNightSkinDefBzt[model] or cityNightSkinDef.castleNightSkinDef[model]
	else
		return cityNightSkinDef.castleNightSkinDef[model]
	end
end)[1], cityNightSkinDef.castleNightSkinDef.turretR, cc.p(3750.0, 1108.5)[8], cc.p(2683.0, 585.0).pos = cityNightSkinDef.castleNightSkinDef, cityNightSkinDef.castleNightSkinDef, cc.p(3750.0, 1108.5), cc.p(2683.0, 585.0), cc.p(3732.0, 1204.0)
cityNightSkinDef.castleNightSkinDef.gate = "LV2_chengmen.png"
cityNightSkinDef.castleNightSkinDef.gatePos = cc.p(3414.5, 978.0)
cityNightSkinDef.castleNightSkinDef.base = "LV2_jianta_base.png"
cityNightSkinDef.castleNightSkinDef.posL = cc.p(3044.0, 748.8)
_ENV, cityNightSkinDef.castleNightSkinDef.posR = cc.p(3757.0, 1103.8), cc.p(3757.0, 1103.8)
cc.p(3757.0, 1103.8).size = cc.size(120, 120)
_ENV, cityNightSkinDef.castleNightSkinDef.cutL, cc.p(3757.0, 1103.8).pos = cc.p(3757.0, 1103.8), cc.p(3757.0, 1103.8), cc.p(3221.5, 861.5)
cc.p(3757.0, 1103.8).size = cc.size(44, 120)
cityNightSkinDef.castleNightSkinDef.cutR, cc.p(3757.0, 1103.8).pos = cc.p(3757.0, 1103.8), cc.p(3570.5, 996.5)
_ENV, cityNightSkinDef.castleNightSkinDef.wall = cc.p(3757.0, 1103.8), "LV2_chengqiang.png"
cc.p(3757.0, 1103.8)[1] = cc.p(3970.5, 1253.5)
cc.p(3757.0, 1103.8)[2] = cc.p(3844.0, 1191.0)
cc.p(3757.0, 1103.8)[3] = cc.p(3661.5, 1101.5)
cc.p(3757.0, 1103.8)[4] = cc.p(44, 0)
cc.p(3757.0, 1103.8)[5] = cc.p(0, 0)
cc.p(3757.0, 1103.8)[6] = cc.p(3131.5, 842.0)
cc.p(3757.0, 1103.8)[7] = cc.p(2942.5, 750.5)
cc.p(3757.0, 1103.8)[8] = cc.p(2816.0, 687.5)
_ENV, _ENV, cityNightSkinDef.castleNightSkinDef.posArray, cc.p(3757.0, 1103.8)[9] = cc.p(2688.5, 626.0), cc.p(3757.0, 1103.8), cc.p(3757.0, 1103.8), cc.p(2688.5, 626.0)
cc.p(2688.5, 626.0).png = "LV1_jianta.png"
_ENV, cc.p(3757.0, 1103.8)[1], cc.p(2688.5, 626.0).pos = cc.p(2688.5, 626.0), cc.p(2688.5, 626.0), cc.p(3031.0, 859.0)
cc.p(2688.5, 626.0).png = "LV2_jianta.png"
_ENV, cc.p(3757.0, 1103.8)[2], cc.p(2688.5, 626.0).pos = cc.p(2688.5, 626.0), cc.p(2688.5, 626.0), cc.p(3019.0, 860.0)
cc.p(2688.5, 626.0).png = "LV3_jianta.png"
_ENV, cc.p(3757.0, 1103.8)[3], cc.p(2688.5, 626.0).pos = cc.p(2688.5, 626.0), cc.p(2688.5, 626.0), cc.p(3012.0, 857.0)
cc.p(2688.5, 626.0).png = "LV4_jianta.png"
_ENV, cc.p(3757.0, 1103.8)[4], cc.p(2688.5, 626.0).pos = cc.p(2688.5, 626.0), cc.p(2688.5, 626.0), cc.p(3017.0, 855.0)
cc.p(2688.5, 626.0).png = "LV5_jianta.png"
_ENV, cc.p(3757.0, 1103.8)[5], cc.p(2688.5, 626.0).pos = cc.p(2688.5, 626.0), cc.p(2688.5, 626.0), cc.p(3014.0, 857.0)
cc.p(2688.5, 626.0).png = "LV6_jianta.png"
_ENV, cc.p(3757.0, 1103.8)[6], cc.p(2688.5, 626.0).pos = cc.p(2688.5, 626.0), cc.p(2688.5, 626.0), cc.p(3021.0, 852.0)
cc.p(2688.5, 626.0).png = "LV7_jianta.png"
_ENV, cc.p(3757.0, 1103.8)[7], cc.p(2688.5, 626.0).pos = cc.p(2688.5, 626.0), cc.p(2688.5, 626.0), cc.p(3017.0, 860.0)
cc.p(2688.5, 626.0).png = "LV8_jianta.png"
_ENV, _ENV, cityNightSkinDef.castleNightSkinDef.turretL, cc.p(3757.0, 1103.8)[8], cc.p(2688.5, 626.0).pos = cc.p(2688.5, 626.0), cc.p(3757.0, 1103.8), cc.p(3757.0, 1103.8), cc.p(2688.5, 626.0), cc.p(3017.0, 861.0)
cc.p(2688.5, 626.0).png = "LV1_jianta.png"
_ENV, cc.p(3757.0, 1103.8)[1], cc.p(2688.5, 626.0).pos = cc.p(2688.5, 626.0), cc.p(2688.5, 626.0), cc.p(3749.0, 1212.0)
cc.p(2688.5, 626.0).png = "LV2_jianta.png"
_ENV, cc.p(3757.0, 1103.8)[2], cc.p(2688.5, 626.0).pos = cc.p(2688.5, 626.0), cc.p(2688.5, 626.0), cc.p(3737.0, 1213.0)
cc.p(2688.5, 626.0).png = "LV3_jianta.png"
_ENV, cc.p(3757.0, 1103.8)[3], cc.p(2688.5, 626.0).pos = cc.p(2688.5, 626.0), cc.p(2688.5, 626.0), cc.p(3730.0, 1210.0)
cc.p(2688.5, 626.0).png = "LV4_jianta.png"
_ENV, cc.p(3757.0, 1103.8)[4], cc.p(2688.5, 626.0).pos = cc.p(2688.5, 626.0), cc.p(2688.5, 626.0), cc.p(3735.0, 1208.0)
cc.p(2688.5, 626.0).png = "LV5_jianta.png"
_ENV, cc.p(3757.0, 1103.8)[5], cc.p(2688.5, 626.0).pos = cc.p(2688.5, 626.0), cc.p(2688.5, 626.0), cc.p(3732.0, 1210.0)
cc.p(2688.5, 626.0).png = "LV6_jianta.png"
_ENV, cc.p(3757.0, 1103.8)[6], cc.p(2688.5, 626.0).pos = cc.p(2688.5, 626.0), cc.p(2688.5, 626.0), cc.p(3739.0, 1205.0)
cc.p(2688.5, 626.0).png = "LV7_jianta.png"
_ENV, cc.p(3757.0, 1103.8)[7], cc.p(2688.5, 626.0).pos = cc.p(2688.5, 626.0), cc.p(2688.5, 626.0), cc.p(3735.0, 1213.0)
cc.p(2688.5, 626.0).png = "LV8_jianta.png"
_ENV, (function(model)
	if SoraDGetFactionType() == FACTION_TYPE.FACTION_BYZANTINE then
		return cityNightSkinDef.castleNightSkinDefBzt[model] or cityNightSkinDef.castleNightSkinDef[model]
	else
		return cityNightSkinDef.castleNightSkinDef[model]
	end
end)[2], cityNightSkinDef.castleNightSkinDef.turretR, cc.p(3757.0, 1103.8)[8], cc.p(2688.5, 626.0).pos = cityNightSkinDef.castleNightSkinDef, cityNightSkinDef.castleNightSkinDef, cc.p(3757.0, 1103.8), cc.p(2688.5, 626.0), cc.p(3735.0, 1214.0)
cityNightSkinDef.castleNightSkinDef.gate = "LV3_chengmen.png"
cityNightSkinDef.castleNightSkinDef.gatePos = cc.p(3397.0, 995.0)
cityNightSkinDef.castleNightSkinDef.base = "LV3_jianta_base.png"
cityNightSkinDef.castleNightSkinDef.posL = cc.p(3044.0, 761.5)
_ENV, cityNightSkinDef.castleNightSkinDef.posR = cc.p(3757.0, 1116.5), cc.p(3757.0, 1116.5)
cc.p(3757.0, 1116.5).size = cc.size(120, 120)
_ENV, cityNightSkinDef.castleNightSkinDef.cutL, cc.p(3757.0, 1116.5).pos = cc.p(3757.0, 1116.5), cc.p(3757.0, 1116.5), cc.p(3226.5, 855.0)
cc.p(3757.0, 1116.5).size = cc.size(44, 120)
cityNightSkinDef.castleNightSkinDef.cutR, cc.p(3757.0, 1116.5).pos = cc.p(3757.0, 1116.5), cc.p(3581.5, 991.0)
_ENV, cityNightSkinDef.castleNightSkinDef.wall = cc.p(3757.0, 1116.5), "LV3_chengqiang.png"
cc.p(3757.0, 1116.5)[1] = cc.p(3978.5, 1232.0)
cc.p(3757.0, 1116.5)[2] = cc.p(3852.0, 1169.5)
cc.p(3757.0, 1116.5)[3] = cc.p(3669.5, 1080.0)
cc.p(3757.0, 1116.5)[4] = cc.p(44, 0)
cc.p(3757.0, 1116.5)[5] = cc.p(0, 0)
cc.p(3757.0, 1116.5)[6] = cc.p(3139.5, 820.5)
cc.p(3757.0, 1116.5)[7] = cc.p(2950.5, 729.0)
cc.p(3757.0, 1116.5)[8] = cc.p(2824.0, 666.0)
_ENV, _ENV, cityNightSkinDef.castleNightSkinDef.posArray, cc.p(3757.0, 1116.5)[9] = cc.p(2696.5, 604.5), cc.p(3757.0, 1116.5), cc.p(3757.0, 1116.5), cc.p(2696.5, 604.5)
cc.p(2696.5, 604.5).png = "LV1_jianta.png"
_ENV, cc.p(3757.0, 1116.5)[1], cc.p(2696.5, 604.5).pos = cc.p(2696.5, 604.5), cc.p(2696.5, 604.5), cc.p(3036.0, 846.0)
cc.p(2696.5, 604.5).png = "LV2_jianta.png"
_ENV, cc.p(3757.0, 1116.5)[2], cc.p(2696.5, 604.5).pos = cc.p(2696.5, 604.5), cc.p(2696.5, 604.5), cc.p(3024.0, 847.0)
cc.p(2696.5, 604.5).png = "LV3_jianta.png"
_ENV, cc.p(3757.0, 1116.5)[3], cc.p(2696.5, 604.5).pos = cc.p(2696.5, 604.5), cc.p(2696.5, 604.5), cc.p(3017.0, 844.0)
cc.p(2696.5, 604.5).png = "LV4_jianta.png"
_ENV, cc.p(3757.0, 1116.5)[4], cc.p(2696.5, 604.5).pos = cc.p(2696.5, 604.5), cc.p(2696.5, 604.5), cc.p(3022.0, 842.0)
cc.p(2696.5, 604.5).png = "LV5_jianta.png"
_ENV, cc.p(3757.0, 1116.5)[5], cc.p(2696.5, 604.5).pos = cc.p(2696.5, 604.5), cc.p(2696.5, 604.5), cc.p(3019.0, 844.0)
cc.p(2696.5, 604.5).png = "LV6_jianta.png"
_ENV, cc.p(3757.0, 1116.5)[6], cc.p(2696.5, 604.5).pos = cc.p(2696.5, 604.5), cc.p(2696.5, 604.5), cc.p(3026.0, 839.0)
cc.p(2696.5, 604.5).png = "LV7_jianta.png"
_ENV, cc.p(3757.0, 1116.5)[7], cc.p(2696.5, 604.5).pos = cc.p(2696.5, 604.5), cc.p(2696.5, 604.5), cc.p(3020.0, 847.0)
cc.p(2696.5, 604.5).png = "LV8_jianta.png"
_ENV, _ENV, cityNightSkinDef.castleNightSkinDef.turretL, cc.p(3757.0, 1116.5)[8], cc.p(2696.5, 604.5).pos = cc.p(2696.5, 604.5), cc.p(3757.0, 1116.5), cc.p(3757.0, 1116.5), cc.p(2696.5, 604.5), cc.p(3020.0, 848.0)
cc.p(2696.5, 604.5).png = "LV1_jianta.png"
_ENV, cc.p(3757.0, 1116.5)[1], cc.p(2696.5, 604.5).pos = cc.p(2696.5, 604.5), cc.p(2696.5, 604.5), cc.p(3749.0, 1200.0)
cc.p(2696.5, 604.5).png = "LV2_jianta.png"
_ENV, cc.p(3757.0, 1116.5)[2], cc.p(2696.5, 604.5).pos = cc.p(2696.5, 604.5), cc.p(2696.5, 604.5), cc.p(3737.0, 1201.0)
cc.p(2696.5, 604.5).png = "LV3_jianta.png"
_ENV, cc.p(3757.0, 1116.5)[3], cc.p(2696.5, 604.5).pos = cc.p(2696.5, 604.5), cc.p(2696.5, 604.5), cc.p(3730.0, 1198.0)
cc.p(2696.5, 604.5).png = "LV4_jianta.png"
_ENV, cc.p(3757.0, 1116.5)[4], cc.p(2696.5, 604.5).pos = cc.p(2696.5, 604.5), cc.p(2696.5, 604.5), cc.p(3735.0, 1196.0)
cc.p(2696.5, 604.5).png = "LV5_jianta.png"
_ENV, cc.p(3757.0, 1116.5)[5], cc.p(2696.5, 604.5).pos = cc.p(2696.5, 604.5), cc.p(2696.5, 604.5), cc.p(3732.0, 1198.0)
cc.p(2696.5, 604.5).png = "LV6_jianta.png"
_ENV, cc.p(3757.0, 1116.5)[6], cc.p(2696.5, 604.5).pos = cc.p(2696.5, 604.5), cc.p(2696.5, 604.5), cc.p(3739.0, 1193.0)
cc.p(2696.5, 604.5).png = "LV7_jianta.png"
_ENV, cc.p(3757.0, 1116.5)[7], cc.p(2696.5, 604.5).pos = cc.p(2696.5, 604.5), cc.p(2696.5, 604.5), cc.p(3735.0, 1201.0)
cc.p(2696.5, 604.5).png = "LV8_jianta.png"
_ENV, (function(model)
	if SoraDGetFactionType() == FACTION_TYPE.FACTION_BYZANTINE then
		return cityNightSkinDef.castleNightSkinDefBzt[model] or cityNightSkinDef.castleNightSkinDef[model]
	else
		return cityNightSkinDef.castleNightSkinDef[model]
	end
end)[3], cityNightSkinDef.castleNightSkinDef.turretR, cc.p(3757.0, 1116.5)[8], cc.p(2696.5, 604.5).pos = cityNightSkinDef.castleNightSkinDef, cityNightSkinDef.castleNightSkinDef, cc.p(3757.0, 1116.5), cc.p(2696.5, 604.5), cc.p(3735.0, 1202.0)
cityNightSkinDef.castleNightSkinDef.gate = "LV4_chengmen.png"
cityNightSkinDef.castleNightSkinDef.gatePos = cc.p(3397.5, 995.0)
cityNightSkinDef.castleNightSkinDef.base = "LV4_jianta_base.png"
cityNightSkinDef.castleNightSkinDef.posL = cc.p(3047.0, 751.0)
_ENV, cityNightSkinDef.castleNightSkinDef.posR = cc.p(3760.0, 1106.0), cc.p(3760.0, 1106.0)
cc.p(3760.0, 1106.0).size = cc.size(120, 120)
_ENV, cityNightSkinDef.castleNightSkinDef.cutL, cc.p(3760.0, 1106.0).pos = cc.p(3760.0, 1106.0), cc.p(3760.0, 1106.0), cc.p(3216.0, 850.0)
cc.p(3760.0, 1106.0).size = cc.size(50, 120)
cityNightSkinDef.castleNightSkinDef.cutR, cc.p(3760.0, 1106.0).pos = cc.p(3760.0, 1106.0), cc.p(3583.0, 985.0)
_ENV, cityNightSkinDef.castleNightSkinDef.wall = cc.p(3760.0, 1106.0), "LV4_chengqiang.png"
cc.p(3760.0, 1106.0)[1] = cc.p(3973.5, 1229.0)
cc.p(3760.0, 1106.0)[2] = cc.p(3847.0, 1166.5)
cc.p(3760.0, 1106.0)[3] = cc.p(3664.5, 1077.0)
cc.p(3760.0, 1106.0)[4] = cc.p(50, 0)
cc.p(3760.0, 1106.0)[5] = cc.p(0, 0)
cc.p(3760.0, 1106.0)[6] = cc.p(3134.5, 817.5)
cc.p(3760.0, 1106.0)[7] = cc.p(2945.5, 726.0)
cc.p(3760.0, 1106.0)[8] = cc.p(2819.0, 663.0)
_ENV, _ENV, cityNightSkinDef.castleNightSkinDef.posArray, cc.p(3760.0, 1106.0)[9] = cc.p(2691.5, 601.5), cc.p(3760.0, 1106.0), cc.p(3760.0, 1106.0), cc.p(2691.5, 601.5)
cc.p(2691.5, 601.5).png = "LV1_jianta.png"
_ENV, cc.p(3760.0, 1106.0)[1], cc.p(2691.5, 601.5).pos = cc.p(2691.5, 601.5), cc.p(2691.5, 601.5), cc.p(3031.0, 857.0)
cc.p(2691.5, 601.5).png = "LV2_jianta.png"
_ENV, cc.p(3760.0, 1106.0)[2], cc.p(2691.5, 601.5).pos = cc.p(2691.5, 601.5), cc.p(2691.5, 601.5), cc.p(3019.0, 858.0)
cc.p(2691.5, 601.5).png = "LV3_jianta.png"
_ENV, cc.p(3760.0, 1106.0)[3], cc.p(2691.5, 601.5).pos = cc.p(2691.5, 601.5), cc.p(2691.5, 601.5), cc.p(3012.0, 855.0)
cc.p(2691.5, 601.5).png = "LV4_jianta.png"
_ENV, cc.p(3760.0, 1106.0)[4], cc.p(2691.5, 601.5).pos = cc.p(2691.5, 601.5), cc.p(2691.5, 601.5), cc.p(3017.0, 853.0)
cc.p(2691.5, 601.5).png = "LV5_jianta.png"
_ENV, cc.p(3760.0, 1106.0)[5], cc.p(2691.5, 601.5).pos = cc.p(2691.5, 601.5), cc.p(2691.5, 601.5), cc.p(3014.0, 855.0)
cc.p(2691.5, 601.5).png = "LV6_jianta.png"
_ENV, cc.p(3760.0, 1106.0)[6], cc.p(2691.5, 601.5).pos = cc.p(2691.5, 601.5), cc.p(2691.5, 601.5), cc.p(3021.0, 850.0)
cc.p(2691.5, 601.5).png = "LV7_jianta.png"
_ENV, cc.p(3760.0, 1106.0)[7], cc.p(2691.5, 601.5).pos = cc.p(2691.5, 601.5), cc.p(2691.5, 601.5), cc.p(3015.0, 858.0)
cc.p(2691.5, 601.5).png = "LV8_jianta.png"
_ENV, _ENV, cityNightSkinDef.castleNightSkinDef.turretL, cc.p(3760.0, 1106.0)[8], cc.p(2691.5, 601.5).pos = cc.p(2691.5, 601.5), cc.p(3760.0, 1106.0), cc.p(3760.0, 1106.0), cc.p(2691.5, 601.5), cc.p(3015.0, 859.0)
cc.p(2691.5, 601.5).png = "LV1_jianta.png"
_ENV, cc.p(3760.0, 1106.0)[1], cc.p(2691.5, 601.5).pos = cc.p(2691.5, 601.5), cc.p(2691.5, 601.5), cc.p(3749.0, 1207.0)
cc.p(2691.5, 601.5).png = "LV2_jianta.png"
_ENV, cc.p(3760.0, 1106.0)[2], cc.p(2691.5, 601.5).pos = cc.p(2691.5, 601.5), cc.p(2691.5, 601.5), cc.p(3737.0, 1208.0)
cc.p(2691.5, 601.5).png = "LV3_jianta.png"
_ENV, cc.p(3760.0, 1106.0)[3], cc.p(2691.5, 601.5).pos = cc.p(2691.5, 601.5), cc.p(2691.5, 601.5), cc.p(3730.0, 1205.0)
cc.p(2691.5, 601.5).png = "LV4_jianta.png"
_ENV, cc.p(3760.0, 1106.0)[4], cc.p(2691.5, 601.5).pos = cc.p(2691.5, 601.5), cc.p(2691.5, 601.5), cc.p(3735.0, 1203.0)
cc.p(2691.5, 601.5).png = "LV5_jianta.png"
_ENV, cc.p(3760.0, 1106.0)[5], cc.p(2691.5, 601.5).pos = cc.p(2691.5, 601.5), cc.p(2691.5, 601.5), cc.p(3732.0, 1205.0)
cc.p(2691.5, 601.5).png = "LV6_jianta.png"
_ENV, cc.p(3760.0, 1106.0)[6], cc.p(2691.5, 601.5).pos = cc.p(2691.5, 601.5), cc.p(2691.5, 601.5), cc.p(3739.0, 1200.0)
cc.p(2691.5, 601.5).png = "LV7_jianta.png"
_ENV, cc.p(3760.0, 1106.0)[7], cc.p(2691.5, 601.5).pos = cc.p(2691.5, 601.5), cc.p(2691.5, 601.5), cc.p(3734.0, 1209.0)
cc.p(2691.5, 601.5).png = "LV8_jianta.png"
_ENV, (function(model)
	if SoraDGetFactionType() == FACTION_TYPE.FACTION_BYZANTINE then
		return cityNightSkinDef.castleNightSkinDefBzt[model] or cityNightSkinDef.castleNightSkinDef[model]
	else
		return cityNightSkinDef.castleNightSkinDef[model]
	end
end)[4], cityNightSkinDef.castleNightSkinDef.turretR, cc.p(3760.0, 1106.0)[8], cc.p(2691.5, 601.5).pos = cityNightSkinDef.castleNightSkinDef, cityNightSkinDef.castleNightSkinDef, cc.p(3760.0, 1106.0), cc.p(2691.5, 601.5), cc.p(3734.0, 1209.0)
cityNightSkinDef.castleNightSkinDef.gate = "LV5_chengmen.png"
cityNightSkinDef.castleNightSkinDef.gatePos = cc.p(3397.5, 995.0)
cityNightSkinDef.castleNightSkinDef.base = "LV5_jianta_base.png"
cityNightSkinDef.castleNightSkinDef.posL = cc.p(3045.3, 756.8)
_ENV, cityNightSkinDef.castleNightSkinDef.posR = cc.p(3758.3, 1111.8), cc.p(3758.3, 1111.8)
cc.p(3758.3, 1111.8).size = cc.size(120, 120)
_ENV, cityNightSkinDef.castleNightSkinDef.cutL, cc.p(3758.3, 1111.8).pos = cc.p(3758.3, 1111.8), cc.p(3758.3, 1111.8), cc.p(3214.8, 863.0)
cc.p(3758.3, 1111.8).size = cc.size(58, 120)
cityNightSkinDef.castleNightSkinDef.cutR, cc.p(3758.3, 1111.8).pos = cc.p(3758.3, 1111.8), cc.p(3586.5, 1000.5)
_ENV, cityNightSkinDef.castleNightSkinDef.wall = cc.p(3758.3, 1111.8), "LV5_chengqiang.png"
cc.p(3758.3, 1111.8)[1] = cc.p(3976.0, 1251.5)
cc.p(3758.3, 1111.8)[2] = cc.p(3849.0, 1188.0)
cc.p(3758.3, 1111.8)[3] = cc.p(3667.0, 1098.5)
cc.p(3758.3, 1111.8)[4] = cc.p(58, 0)
cc.p(3758.3, 1111.8)[5] = cc.p(0, 0)
cc.p(3758.3, 1111.8)[6] = cc.p(3137.0, 839.0)
cc.p(3758.3, 1111.8)[7] = cc.p(2948.0, 747.5)
cc.p(3758.3, 1111.8)[8] = cc.p(2821.5, 684.5)
_ENV, _ENV, cityNightSkinDef.castleNightSkinDef.posArray, cc.p(3758.3, 1111.8)[9] = cc.p(2694.0, 623.0), cc.p(3758.3, 1111.8), cc.p(3758.3, 1111.8), cc.p(2694.0, 623.0)
cc.p(2694.0, 623.0).png = "LV1_jianta.png"
_ENV, cc.p(3758.3, 1111.8)[1], cc.p(2694.0, 623.0).pos = cc.p(2694.0, 623.0), cc.p(2694.0, 623.0), cc.p(3033.0, 863.0)
cc.p(2694.0, 623.0).png = "LV2_jianta.png"
_ENV, cc.p(3758.3, 1111.8)[2], cc.p(2694.0, 623.0).pos = cc.p(2694.0, 623.0), cc.p(2694.0, 623.0), cc.p(3021.0, 864.0)
cc.p(2694.0, 623.0).png = "LV3_jianta.png"
_ENV, cc.p(3758.3, 1111.8)[3], cc.p(2694.0, 623.0).pos = cc.p(2694.0, 623.0), cc.p(2694.0, 623.0), cc.p(3014.0, 861.0)
cc.p(2694.0, 623.0).png = "LV4_jianta.png"
_ENV, cc.p(3758.3, 1111.8)[4], cc.p(2694.0, 623.0).pos = cc.p(2694.0, 623.0), cc.p(2694.0, 623.0), cc.p(3019.0, 859.0)
cc.p(2694.0, 623.0).png = "LV5_jianta.png"
_ENV, cc.p(3758.3, 1111.8)[5], cc.p(2694.0, 623.0).pos = cc.p(2694.0, 623.0), cc.p(2694.0, 623.0), cc.p(3016.0, 861.0)
cc.p(2694.0, 623.0).png = "LV6_jianta.png"
_ENV, cc.p(3758.3, 1111.8)[6], cc.p(2694.0, 623.0).pos = cc.p(2694.0, 623.0), cc.p(2694.0, 623.0), cc.p(3023.0, 856.0)
cc.p(2694.0, 623.0).png = "LV7_jianta.png"
_ENV, cc.p(3758.3, 1111.8)[7], cc.p(2694.0, 623.0).pos = cc.p(2694.0, 623.0), cc.p(2694.0, 623.0), cc.p(3017.0, 864.0)
cc.p(2694.0, 623.0).png = "LV8_jianta.png"
_ENV, _ENV, cityNightSkinDef.castleNightSkinDef.turretL, cc.p(3758.3, 1111.8)[8], cc.p(2694.0, 623.0).pos = cc.p(2694.0, 623.0), cc.p(3758.3, 1111.8), cc.p(3758.3, 1111.8), cc.p(2694.0, 623.0), cc.p(3017.0, 865.0)
cc.p(2694.0, 623.0).png = "LV1_jianta.png"
_ENV, cc.p(3758.3, 1111.8)[1], cc.p(2694.0, 623.0).pos = cc.p(2694.0, 623.0), cc.p(2694.0, 623.0), cc.p(3751.0, 1213.0)
cc.p(2694.0, 623.0).png = "LV2_jianta.png"
_ENV, cc.p(3758.3, 1111.8)[2], cc.p(2694.0, 623.0).pos = cc.p(2694.0, 623.0), cc.p(2694.0, 623.0), cc.p(3739.0, 1214.0)
cc.p(2694.0, 623.0).png = "LV3_jianta.png"
_ENV, cc.p(3758.3, 1111.8)[3], cc.p(2694.0, 623.0).pos = cc.p(2694.0, 623.0), cc.p(2694.0, 623.0), cc.p(3732.0, 1211.0)
cc.p(2694.0, 623.0).png = "LV4_jianta.png"
_ENV, cc.p(3758.3, 1111.8)[4], cc.p(2694.0, 623.0).pos = cc.p(2694.0, 623.0), cc.p(2694.0, 623.0), cc.p(3737.0, 1209.0)
cc.p(2694.0, 623.0).png = "LV5_jianta.png"
_ENV, cc.p(3758.3, 1111.8)[5], cc.p(2694.0, 623.0).pos = cc.p(2694.0, 623.0), cc.p(2694.0, 623.0), cc.p(3734.0, 1211.0)
cc.p(2694.0, 623.0).png = "LV6_jianta.png"
_ENV, cc.p(3758.3, 1111.8)[6], cc.p(2694.0, 623.0).pos = cc.p(2694.0, 623.0), cc.p(2694.0, 623.0), cc.p(3741.0, 1206.0)
cc.p(2694.0, 623.0).png = "LV7_jianta.png"
_ENV, cc.p(3758.3, 1111.8)[7], cc.p(2694.0, 623.0).pos = cc.p(2694.0, 623.0), cc.p(2694.0, 623.0), cc.p(3736.0, 1215.0)
cc.p(2694.0, 623.0).png = "LV8_jianta.png"
_ENV, (function(model)
	if SoraDGetFactionType() == FACTION_TYPE.FACTION_BYZANTINE then
		return cityNightSkinDef.castleNightSkinDefBzt[model] or cityNightSkinDef.castleNightSkinDef[model]
	else
		return cityNightSkinDef.castleNightSkinDef[model]
	end
end)[5], cityNightSkinDef.castleNightSkinDef.turretR, cc.p(3758.3, 1111.8)[8], cc.p(2694.0, 623.0).pos = cityNightSkinDef.castleNightSkinDef, cityNightSkinDef.castleNightSkinDef, cc.p(3758.3, 1111.8), cc.p(2694.0, 623.0), cc.p(3736.0, 1215.0)
cityNightSkinDef.castleNightSkinDef.gate = "LV6_chengmen.png"
cityNightSkinDef.castleNightSkinDef.gatePos = cc.p(3397.5, 995.0)
cityNightSkinDef.castleNightSkinDef.base = "LV6_jianta_base.png"
cityNightSkinDef.castleNightSkinDef.posL = cc.p(3045.3, 756.8)
_ENV, cityNightSkinDef.castleNightSkinDef.posR = cc.p(3758.3, 1111.8), cc.p(3758.3, 1111.8)
cc.p(3758.3, 1111.8).size = cc.size(120, 120)
_ENV, cityNightSkinDef.castleNightSkinDef.cutL, cc.p(3758.3, 1111.8).pos = cc.p(3758.3, 1111.8), cc.p(3758.3, 1111.8), cc.p(3223.5, 813.0)
cc.p(3758.3, 1111.8).size = cc.size(58, 120)
cityNightSkinDef.castleNightSkinDef.cutR, cc.p(3758.3, 1111.8).pos = cc.p(3758.3, 1111.8), cc.p(3573.0, 947.5)
_ENV, cityNightSkinDef.castleNightSkinDef.wall = cc.p(3758.3, 1111.8), "LV6_chengqiang.png"
cc.p(3758.3, 1111.8)[1] = cc.p(3972.5, 1220.5)
cc.p(3758.3, 1111.8)[2] = cc.p(3845.5, 1157.0)
cc.p(3758.3, 1111.8)[3] = cc.p(3663.5, 1067.5)
cc.p(3758.3, 1111.8)[4] = cc.p(58, 0)
cc.p(3758.3, 1111.8)[5] = cc.p(0, 0)
cc.p(3758.3, 1111.8)[6] = cc.p(3133.5, 808.0)
cc.p(3758.3, 1111.8)[7] = cc.p(2944.5, 716.5)
cc.p(3758.3, 1111.8)[8] = cc.p(2818.0, 653.5)
_ENV, _ENV, cityNightSkinDef.castleNightSkinDef.posArray, cc.p(3758.3, 1111.8)[9] = cc.p(2690.5, 592.0), cc.p(3758.3, 1111.8), cc.p(3758.3, 1111.8), cc.p(2690.5, 592.0)
cc.p(2690.5, 592.0).png = "LV1_jianta.png"
_ENV, cc.p(3758.3, 1111.8)[1], cc.p(2690.5, 592.0).pos = cc.p(2690.5, 592.0), cc.p(2690.5, 592.0), cc.p(3031.0, 861.0)
cc.p(2690.5, 592.0).png = "LV2_jianta.png"
_ENV, cc.p(3758.3, 1111.8)[2], cc.p(2690.5, 592.0).pos = cc.p(2690.5, 592.0), cc.p(2690.5, 592.0), cc.p(3019.0, 862.0)
cc.p(2690.5, 592.0).png = "LV3_jianta.png"
_ENV, cc.p(3758.3, 1111.8)[3], cc.p(2690.5, 592.0).pos = cc.p(2690.5, 592.0), cc.p(2690.5, 592.0), cc.p(3012.0, 859.0)
cc.p(2690.5, 592.0).png = "LV4_jianta.png"
_ENV, cc.p(3758.3, 1111.8)[4], cc.p(2690.5, 592.0).pos = cc.p(2690.5, 592.0), cc.p(2690.5, 592.0), cc.p(3017.0, 857.0)
cc.p(2690.5, 592.0).png = "LV5_jianta.png"
_ENV, cc.p(3758.3, 1111.8)[5], cc.p(2690.5, 592.0).pos = cc.p(2690.5, 592.0), cc.p(2690.5, 592.0), cc.p(3014.0, 859.0)
cc.p(2690.5, 592.0).png = "LV6_jianta.png"
_ENV, cc.p(3758.3, 1111.8)[6], cc.p(2690.5, 592.0).pos = cc.p(2690.5, 592.0), cc.p(2690.5, 592.0), cc.p(3021.0, 854.0)
cc.p(2690.5, 592.0).png = "LV7_jianta.png"
_ENV, cc.p(3758.3, 1111.8)[7], cc.p(2690.5, 592.0).pos = cc.p(2690.5, 592.0), cc.p(2690.5, 592.0), cc.p(3015.0, 861.0)
cc.p(2690.5, 592.0).png = "LV8_jianta.png"
_ENV, _ENV, cityNightSkinDef.castleNightSkinDef.turretL, cc.p(3758.3, 1111.8)[8], cc.p(2690.5, 592.0).pos = cc.p(2690.5, 592.0), cc.p(3758.3, 1111.8), cc.p(3758.3, 1111.8), cc.p(2690.5, 592.0), cc.p(3015.0, 862.0)
cc.p(2690.5, 592.0).png = "LV1_jianta.png"
_ENV, cc.p(3758.3, 1111.8)[1], cc.p(2690.5, 592.0).pos = cc.p(2690.5, 592.0), cc.p(2690.5, 592.0), cc.p(3749.0, 1211.0)
cc.p(2690.5, 592.0).png = "LV2_jianta.png"
_ENV, cc.p(3758.3, 1111.8)[2], cc.p(2690.5, 592.0).pos = cc.p(2690.5, 592.0), cc.p(2690.5, 592.0), cc.p(3737.0, 1212.0)
cc.p(2690.5, 592.0).png = "LV3_jianta.png"
_ENV, cc.p(3758.3, 1111.8)[3], cc.p(2690.5, 592.0).pos = cc.p(2690.5, 592.0), cc.p(2690.5, 592.0), cc.p(3730.0, 1209.0)
cc.p(2690.5, 592.0).png = "LV4_jianta.png"
_ENV, cc.p(3758.3, 1111.8)[4], cc.p(2690.5, 592.0).pos = cc.p(2690.5, 592.0), cc.p(2690.5, 592.0), cc.p(3735.0, 1207.0)
cc.p(2690.5, 592.0).png = "LV5_jianta.png"
_ENV, cc.p(3758.3, 1111.8)[5], cc.p(2690.5, 592.0).pos = cc.p(2690.5, 592.0), cc.p(2690.5, 592.0), cc.p(3732.0, 1209.0)
cc.p(2690.5, 592.0).png = "LV6_jianta.png"
_ENV, cc.p(3758.3, 1111.8)[6], cc.p(2690.5, 592.0).pos = cc.p(2690.5, 592.0), cc.p(2690.5, 592.0), cc.p(3739.0, 1204.0)
cc.p(2690.5, 592.0).png = "LV7_jianta.png"
_ENV, cc.p(3758.3, 1111.8)[7], cc.p(2690.5, 592.0).pos = cc.p(2690.5, 592.0), cc.p(2690.5, 592.0), cc.p(3734.0, 1212.0)
cc.p(2690.5, 592.0).png = "LV8_jianta.png"
_ENV, (function(model)
	if SoraDGetFactionType() == FACTION_TYPE.FACTION_BYZANTINE then
		return cityNightSkinDef.castleNightSkinDefBzt[model] or cityNightSkinDef.castleNightSkinDef[model]
	else
		return cityNightSkinDef.castleNightSkinDef[model]
	end
end)[6], cityNightSkinDef.castleNightSkinDef.turretR, cc.p(3758.3, 1111.8)[8], cc.p(2690.5, 592.0).pos = cityNightSkinDef.castleNightSkinDef, cityNightSkinDef.castleNightSkinDef, cc.p(3758.3, 1111.8), cc.p(2690.5, 592.0), cc.p(3734.0, 1212.0)
cityNightSkinDef.castleNightSkinDef.gate = "LV7_chengmen.png"
cityNightSkinDef.castleNightSkinDef.gatePos = cc.p(3409.5, 966.0)
cityNightSkinDef.castleNightSkinDef.base = "LV7_jianta_base.png"
cityNightSkinDef.castleNightSkinDef.posL = cc.p(3039.5, 750.0)
_ENV, cityNightSkinDef.castleNightSkinDef.posR = cc.p(3758.5, 1103.0), cc.p(3758.5, 1103.0)
cc.p(3758.5, 1103.0).size = cc.size(120, 120)
_ENV, cityNightSkinDef.castleNightSkinDef.cutL, cc.p(3758.5, 1103.0).pos = cc.p(3758.5, 1103.0), cc.p(3758.5, 1103.0), cc.p(3231.5, 793.5)
cc.p(3758.5, 1103.0).size = cc.size(0, 120)
cityNightSkinDef.castleNightSkinDef.cutR, cc.p(3758.5, 1103.0).pos = cc.p(3758.5, 1103.0), cc.p(3573.0, 947.5)
_ENV, cityNightSkinDef.castleNightSkinDef.wall = "LV7_chengqiang.png", "LV7_chengqiang.png"
;("LV7_chengqiang.png")[1] = cc.p(3972.0, 1186.5)
;("LV7_chengqiang.png")[2] = cc.p(3845.0, 1125.0)
;("LV7_chengqiang.png")[3] = cc.p(3663.0, 1035.0)
;("LV7_chengqiang.png")[4] = cc.p(0, 0)
;("LV7_chengqiang.png")[5] = cc.p(0, 0)
;("LV7_chengqiang.png")[6] = cc.p(3132.0, 775.0)
;("LV7_chengqiang.png")[7] = cc.p(2944.0, 683.0)
;("LV7_chengqiang.png")[8] = cc.p(2817.0, 621.5)
_ENV, _ENV, cityNightSkinDef.castleNightSkinDef.posArray, ("LV7_chengqiang.png")[9] = cc.p(2690.0, 559.0), "LV7_chengqiang.png", "LV7_chengqiang.png", cc.p(2690.0, 559.0)
cc.p(2690.0, 559.0).png = "LV1_jianta.png"
_ENV, ("LV7_chengqiang.png")[1], cc.p(2690.0, 559.0).pos = cc.p(2690.0, 559.0), cc.p(2690.0, 559.0), cc.p(3021.0, 850.0)
cc.p(2690.0, 559.0).png = "LV2_jianta.png"
_ENV, ("LV7_chengqiang.png")[2], cc.p(2690.0, 559.0).pos = cc.p(2690.0, 559.0), cc.p(2690.0, 559.0), cc.p(3009.0, 851.0)
cc.p(2690.0, 559.0).png = "LV3_jianta.png"
_ENV, ("LV7_chengqiang.png")[3], cc.p(2690.0, 559.0).pos = cc.p(2690.0, 559.0), cc.p(2690.0, 559.0), cc.p(3002.0, 848.0)
cc.p(2690.0, 559.0).png = "LV4_jianta.png"
_ENV, ("LV7_chengqiang.png")[4], cc.p(2690.0, 559.0).pos = cc.p(2690.0, 559.0), cc.p(2690.0, 559.0), cc.p(3007.0, 846.0)
cc.p(2690.0, 559.0).png = "LV5_jianta.png"
_ENV, ("LV7_chengqiang.png")[5], cc.p(2690.0, 559.0).pos = cc.p(2690.0, 559.0), cc.p(2690.0, 559.0), cc.p(3004.0, 848.0)
cc.p(2690.0, 559.0).png = "LV6_jianta.png"
_ENV, ("LV7_chengqiang.png")[6], cc.p(2690.0, 559.0).pos = cc.p(2690.0, 559.0), cc.p(2690.0, 559.0), cc.p(3011.0, 843.0)
cc.p(2690.0, 559.0).png = "LV7_jianta.png"
_ENV, ("LV7_chengqiang.png")[7], cc.p(2690.0, 559.0).pos = cc.p(2690.0, 559.0), cc.p(2690.0, 559.0), cc.p(3005.0, 850.0)
cc.p(2690.0, 559.0).png = "LV8_jianta.png"
_ENV, _ENV, cityNightSkinDef.castleNightSkinDef.turretL, ("LV7_chengqiang.png")[8], cc.p(2690.0, 559.0).pos = cc.p(2690.0, 559.0), "LV7_chengqiang.png", "LV7_chengqiang.png", cc.p(2690.0, 559.0), cc.p(3005.0, 851.0)
cc.p(2690.0, 559.0).png = "LV1_jianta.png"
_ENV, ("LV7_chengqiang.png")[1], cc.p(2690.0, 559.0).pos = cc.p(2690.0, 559.0), cc.p(2690.0, 559.0), cc.p(3741.0, 1198.0)
cc.p(2690.0, 559.0).png = "LV2_jianta.png"
_ENV, ("LV7_chengqiang.png")[2], cc.p(2690.0, 559.0).pos = cc.p(2690.0, 559.0), cc.p(2690.0, 559.0), cc.p(3729.0, 1199.0)
cc.p(2690.0, 559.0).png = "LV3_jianta.png"
_ENV, ("LV7_chengqiang.png")[3], cc.p(2690.0, 559.0).pos = cc.p(2690.0, 559.0), cc.p(2690.0, 559.0), cc.p(3722.0, 1196.0)
cc.p(2690.0, 559.0).png = "LV4_jianta.png"
_ENV, ("LV7_chengqiang.png")[4], cc.p(2690.0, 559.0).pos = cc.p(2690.0, 559.0), cc.p(2690.0, 559.0), cc.p(3727.0, 1194.0)
cc.p(2690.0, 559.0).png = "LV5_jianta.png"
_ENV, ("LV7_chengqiang.png")[5], cc.p(2690.0, 559.0).pos = cc.p(2690.0, 559.0), cc.p(2690.0, 559.0), cc.p(3724.0, 1196.0)
cc.p(2690.0, 559.0).png = "LV6_jianta.png"
_ENV, ("LV7_chengqiang.png")[6], cc.p(2690.0, 559.0).pos = cc.p(2690.0, 559.0), cc.p(2690.0, 559.0), cc.p(3731.0, 1191.0)
cc.p(2690.0, 559.0).png = "LV7_jianta.png"
_ENV, ("LV7_chengqiang.png")[7], cc.p(2690.0, 559.0).pos = cc.p(2690.0, 559.0), cc.p(2690.0, 559.0), cc.p(3726.0, 1199.0)
cc.p(2690.0, 559.0).png = "LV8_jianta.png"
_ENV, (function(model)
	if SoraDGetFactionType() == FACTION_TYPE.FACTION_BYZANTINE then
		return cityNightSkinDef.castleNightSkinDefBzt[model] or cityNightSkinDef.castleNightSkinDef[model]
	else
		return cityNightSkinDef.castleNightSkinDef[model]
	end
end)[7], cityNightSkinDef.castleNightSkinDef.turretR, ("LV7_chengqiang.png")[8], cc.p(2690.0, 559.0).pos = cityNightSkinDef.castleNightSkinDef, cityNightSkinDef.castleNightSkinDef, "LV7_chengqiang.png", cc.p(2690.0, 559.0), cc.p(3726.0, 1199.0)
cityNightSkinDef.castleNightSkinDef.gate = "LV8_chengmen.png"
cityNightSkinDef.castleNightSkinDef.gatePos = cc.p(3387.5, 974.0)
cityNightSkinDef.castleNightSkinDef.base = "LV8_jianta_base.png"
cityNightSkinDef.castleNightSkinDef.posL = cc.p(3019.0, 768.0)
_ENV, cityNightSkinDef.castleNightSkinDef.posR = cc.p(3735.0, 1120.8), cc.p(3735.0, 1120.8)
cc.p(3735.0, 1120.8).size = cc.size(40, 120)
_ENV, cityNightSkinDef.castleNightSkinDef.cutL, cc.p(3735.0, 1120.8).pos = cc.p(3735.0, 1120.8), cc.p(3735.0, 1120.8), cc.p(3219.6, 811.5)
cc.p(3735.0, 1120.8).size = cc.size(58, 120)
cityNightSkinDef.castleNightSkinDef.cutR, cc.p(3735.0, 1120.8).pos = cc.p(3735.0, 1120.8), cc.p(3601.5, 947.0)
_ENV, cityNightSkinDef.castleNightSkinDef.wall = "LV8_chengqiang.png", "LV8_chengqiang.png"
;("LV8_chengqiang.png")[1] = cc.p(3984.5, 1236.5)
;("LV8_chengqiang.png")[2] = cc.p(3858.0, 1175.0)
;("LV8_chengqiang.png")[3] = cc.p(3675.5, 1084.8)
;("LV8_chengqiang.png")[4] = cc.p(58, 0)
;("LV8_chengqiang.png")[5] = cc.p(0, 0)
;("LV8_chengqiang.png")[6] = cc.p(3145.0, 825.6)
;("LV8_chengqiang.png")[7] = cc.p(2957.0, 733.0)
;("LV8_chengqiang.png")[8] = cc.p(2829.8, 671.5)
_ENV, _ENV, cityNightSkinDef.castleNightSkinDef.posArray, ("LV8_chengqiang.png")[9] = cc.p(2702.6, 609.5), "LV8_chengqiang.png", "LV8_chengqiang.png", cc.p(2702.6, 609.5)
cc.p(2702.6, 609.5).png = "LV1_jianta.png"
_ENV, ("LV8_chengqiang.png")[1], cc.p(2702.6, 609.5).pos = cc.p(2702.6, 609.5), cc.p(2702.6, 609.5), cc.p(3031.0, 868.0)
cc.p(2702.6, 609.5).png = "LV2_jianta.png"
_ENV, ("LV8_chengqiang.png")[2], cc.p(2702.6, 609.5).pos = cc.p(2702.6, 609.5), cc.p(2702.6, 609.5), cc.p(3019.0, 869.0)
cc.p(2702.6, 609.5).png = "LV3_jianta.png"
_ENV, ("LV8_chengqiang.png")[3], cc.p(2702.6, 609.5).pos = cc.p(2702.6, 609.5), cc.p(2702.6, 609.5), cc.p(3012.0, 866.0)
cc.p(2702.6, 609.5).png = "LV4_jianta.png"
_ENV, ("LV8_chengqiang.png")[4], cc.p(2702.6, 609.5).pos = cc.p(2702.6, 609.5), cc.p(2702.6, 609.5), cc.p(3017.0, 864.0)
cc.p(2702.6, 609.5).png = "LV5_jianta.png"
_ENV, ("LV8_chengqiang.png")[5], cc.p(2702.6, 609.5).pos = cc.p(2702.6, 609.5), cc.p(2702.6, 609.5), cc.p(3014.0, 866.0)
cc.p(2702.6, 609.5).png = "LV6_jianta.png"
_ENV, ("LV8_chengqiang.png")[6], cc.p(2702.6, 609.5).pos = cc.p(2702.6, 609.5), cc.p(2702.6, 609.5), cc.p(3021.0, 861.0)
cc.p(2702.6, 609.5).png = "LV7_jianta.png"
_ENV, ("LV8_chengqiang.png")[7], cc.p(2702.6, 609.5).pos = cc.p(2702.6, 609.5), cc.p(2702.6, 609.5), cc.p(3015.0, 868.0)
cc.p(2702.6, 609.5).png = "LV8_jianta.png"
_ENV, _ENV, cityNightSkinDef.castleNightSkinDef.turretL, ("LV8_chengqiang.png")[8], cc.p(2702.6, 609.5).pos = cc.p(2702.6, 609.5), "LV8_chengqiang.png", "LV8_chengqiang.png", cc.p(2702.6, 609.5), cc.p(3015.0, 869.0)
cc.p(2702.6, 609.5).png = "LV1_jianta.png"
_ENV, ("LV8_chengqiang.png")[1], cc.p(2702.6, 609.5).pos = cc.p(2702.6, 609.5), cc.p(2702.6, 609.5), cc.p(3746.0, 1218.0)
cc.p(2702.6, 609.5).png = "LV2_jianta.png"
_ENV, ("LV8_chengqiang.png")[2], cc.p(2702.6, 609.5).pos = cc.p(2702.6, 609.5), cc.p(2702.6, 609.5), cc.p(3734.0, 1219.0)
cc.p(2702.6, 609.5).png = "LV3_jianta.png"
_ENV, ("LV8_chengqiang.png")[3], cc.p(2702.6, 609.5).pos = cc.p(2702.6, 609.5), cc.p(2702.6, 609.5), cc.p(3727.0, 1216.0)
cc.p(2702.6, 609.5).png = "LV4_jianta.png"
_ENV, ("LV8_chengqiang.png")[4], cc.p(2702.6, 609.5).pos = cc.p(2702.6, 609.5), cc.p(2702.6, 609.5), cc.p(3732.0, 1214.0)
cc.p(2702.6, 609.5).png = "LV5_jianta.png"
_ENV, ("LV8_chengqiang.png")[5], cc.p(2702.6, 609.5).pos = cc.p(2702.6, 609.5), cc.p(2702.6, 609.5), cc.p(3729.0, 1216.0)
cc.p(2702.6, 609.5).png = "LV6_jianta.png"
_ENV, ("LV8_chengqiang.png")[6], cc.p(2702.6, 609.5).pos = cc.p(2702.6, 609.5), cc.p(2702.6, 609.5), cc.p(3736.0, 1211.0)
cc.p(2702.6, 609.5).png = "LV7_jianta.png"
_ENV, ("LV8_chengqiang.png")[7], cc.p(2702.6, 609.5).pos = cc.p(2702.6, 609.5), cc.p(2702.6, 609.5), cc.p(3731.0, 1219.0)
cc.p(2702.6, 609.5).png = "LV8_jianta.png"
cityNightSkinDef.wallLightDef, (function(model)
	if SoraDGetFactionType() == FACTION_TYPE.FACTION_BYZANTINE then
		return cityNightSkinDef.castleNightSkinDefBzt[model] or cityNightSkinDef.castleNightSkinDef[model]
	else
		return cityNightSkinDef.castleNightSkinDef[model]
	end
end)[8], cityNightSkinDef.castleNightSkinDef.turretR, ("LV8_chengqiang.png")[8], cc.p(2702.6, 609.5).pos = function(model)
	if SoraDGetFactionType() == FACTION_TYPE.FACTION_BYZANTINE then
		return cityNightSkinDef.castleNightSkinDefBzt[model] or cityNightSkinDef.castleNightSkinDef[model]
	else
		return cityNightSkinDef.castleNightSkinDef[model]
	end
end, cityNightSkinDef.castleNightSkinDef, "LV8_chengqiang.png", cc.p(2702.6, 609.5), cc.p(3731.0, 1219.0)
_ENV, _ENV = "LV8_chengqiang.png", cityNightSkinDef.castleNightSkinDef
_ENV = cc.p(3731.0, 1219.0)
cc.p(3731.0, 1219.0).png = "light_chengmen_01.png"
;("LV8_chengqiang.png").citywall_1, cc.p(3731.0, 1219.0).offset = cc.p(3731.0, 1219.0), cc.p(-12.43, -16.94)
_ENV = cc.p(3731.0, 1219.0)
cc.p(3731.0, 1219.0).png = "light_jianta_01.png"
;("LV8_chengqiang.png").citywall_2, cc.p(3731.0, 1219.0).offset = cc.p(3731.0, 1219.0), cc.p(28.41, -51.84)
_ENV = cc.p(3731.0, 1219.0)
cc.p(3731.0, 1219.0).png = "light_jie_01.png"
_ENV, cityNightSkinDef.castleNightSkinDef[1], ("LV8_chengqiang.png").citywall_3, cc.p(3731.0, 1219.0).offset = "LV8_chengqiang.png", "LV8_chengqiang.png", cc.p(3731.0, 1219.0), cc.p(7.68, -18.98)
_ENV = cc.p(3731.0, 1219.0)
cc.p(3731.0, 1219.0).png = "light_chengmen_02.png"
;("LV8_chengqiang.png").citywall_1, cc.p(3731.0, 1219.0).offset = cc.p(3731.0, 1219.0), cc.p(3.47, -39.32)
_ENV = cc.p(3731.0, 1219.0)
cc.p(3731.0, 1219.0).png = "light_jianta_02.png"
_ENV, cityNightSkinDef.castleNightSkinDef[2], ("LV8_chengqiang.png").citywall_2, cc.p(3731.0, 1219.0).offset = "LV8_chengqiang.png", "LV8_chengqiang.png", cc.p(3731.0, 1219.0), cc.p(-5.7, 21.47)
_ENV = cc.p(3731.0, 1219.0)
cc.p(3731.0, 1219.0).png = "light_chengmen_03.png"
;("LV8_chengqiang.png").citywall_1, cc.p(3731.0, 1219.0).offset = cc.p(3731.0, 1219.0), cc.p(4.45, -34.59)
_ENV = cc.p(3731.0, 1219.0)
cc.p(3731.0, 1219.0).png = "light_jianta_03.png"
_ENV, cityNightSkinDef.castleNightSkinDef[3], ("LV8_chengqiang.png").citywall_2, cc.p(3731.0, 1219.0).offset = "LV8_chengqiang.png", "LV8_chengqiang.png", cc.p(3731.0, 1219.0), cc.p(16.62, 27.09)
_ENV = cc.p(3731.0, 1219.0)
cc.p(3731.0, 1219.0).png = "light_chengmen_04.png"
;("LV8_chengqiang.png").citywall_1, cc.p(3731.0, 1219.0).offset = cc.p(3731.0, 1219.0), cc.p(32.32, -21.46)
_ENV = cc.p(3731.0, 1219.0)
cc.p(3731.0, 1219.0).png = "light_jianta_04.png"
_ENV, cityNightSkinDef.castleNightSkinDef[4], ("LV8_chengqiang.png").citywall_2, cc.p(3731.0, 1219.0).offset = "LV8_chengqiang.png", "LV8_chengqiang.png", cc.p(3731.0, 1219.0), cc.p(10.54, 45.06)
_ENV = cc.p(3731.0, 1219.0)
cc.p(3731.0, 1219.0).png = "light_chengmen_05.png"
;("LV8_chengqiang.png").citywall_1, cc.p(3731.0, 1219.0).offset = cc.p(3731.0, 1219.0), cc.p(34.12, -20.45)
_ENV = cc.p(3731.0, 1219.0)
cc.p(3731.0, 1219.0).png = "light_jianta_05.png"
_ENV, cityNightSkinDef.castleNightSkinDef[5], ("LV8_chengqiang.png").citywall_2, cc.p(3731.0, 1219.0).offset = "LV8_chengqiang.png", "LV8_chengqiang.png", cc.p(3731.0, 1219.0), cc.p(17.42, 29.08)
_ENV = cc.p(3731.0, 1219.0)
cc.p(3731.0, 1219.0).png = "light_chengmen_06.png"
;("LV8_chengqiang.png").citywall_1, cc.p(3731.0, 1219.0).offset = cc.p(3731.0, 1219.0), cc.p(25.57, -3.4)
_ENV = cc.p(3731.0, 1219.0)
cc.p(3731.0, 1219.0).png = "light_jianta_06.png"
_ENV, cityNightSkinDef.castleNightSkinDef[6], ("LV8_chengqiang.png").citywall_2, cc.p(3731.0, 1219.0).offset = "LV8_chengqiang.png", "LV8_chengqiang.png", cc.p(3731.0, 1219.0), cc.p(11.91, 62.15)
_ENV = cc.p(3731.0, 1219.0)
cc.p(3731.0, 1219.0).png = "light_chengmen_08.png"
;("LV8_chengqiang.png").citywall_1, cc.p(3731.0, 1219.0).offset = cc.p(3731.0, 1219.0), cc.p(37.74, -71.51)
_ENV = cc.p(3731.0, 1219.0)
cc.p(3731.0, 1219.0).png = "light_jianta_08.png"
;("LV8_chengqiang.png").citywall_2, cc.p(3731.0, 1219.0).offset = cc.p(3731.0, 1219.0), cc.p(10.02, -11.17)
_ENV = cc.p(3731.0, 1219.0)
cc.p(3731.0, 1219.0).png = "light_chengqiang_08.png"
_ENV, cityNightSkinDef.castleNightSkinDef[7], ("LV8_chengqiang.png").citywall_cq, cc.p(3731.0, 1219.0).offset = "LV8_chengqiang.png", "LV8_chengqiang.png", cc.p(3731.0, 1219.0), cc.p(6.87, 13.9)
_ENV = cc.p(3731.0, 1219.0)
cc.p(3731.0, 1219.0).png = "light_chengmen_08.png"
;("LV8_chengqiang.png").citywall_1, cc.p(3731.0, 1219.0).offset = cc.p(3731.0, 1219.0), cc.p(37.74, -71.51)
_ENV = cc.p(3731.0, 1219.0)
cc.p(3731.0, 1219.0).png = "light_jianta_08.png"
;("LV8_chengqiang.png").citywall_2, cc.p(3731.0, 1219.0).offset = cc.p(3731.0, 1219.0), cc.p(10.02, -11.17)
_ENV = cc.p(3731.0, 1219.0)
cc.p(3731.0, 1219.0).png = "light_chengqiang_08.png"
cityNightSkinDef.wallLightDefBzt, cityNightSkinDef.castleNightSkinDef[8], ("LV8_chengqiang.png").citywall_cq, cc.p(3731.0, 1219.0).offset = cityNightSkinDef.castleNightSkinDef, "LV8_chengqiang.png", cc.p(3731.0, 1219.0), cc.p(6.87, 13.9)
function cityNightSkinDef.getWallLightDef(model)
	return cityNightSkinDef.wallLightDef[model]
end
function _ENV(model)
	return cityNightSkinDef.wallLightDef[model]
end
_ENV = "CHARIOT_PLANT"
_ENV = "offset"
;("offset").png = "dh_bingying.png"
;("CHARIOT_PLANT").common, ("offset").pos = "offset", cc.p(10, 63)
_ENV = "offset"
;("offset").png = "dh_bingying.png"
;(function(model)
	return cityNightSkinDef.wallLightDef[model]
end)[BUILDID.CHARIOT_PLANT], ("CHARIOT_PLANT").warlv, ("offset").pos = "CHARIOT_PLANT", "offset", cc.p(10, 63)
_ENV = "RANGE"
_ENV = "offset"
;("offset").png = "dh_bachang.png"
;("RANGE").common, ("offset").pos = "offset", cc.p(16, 118)
_ENV = "offset"
;("offset").png = "dh_bachang.png"
;(function(model)
	return cityNightSkinDef.wallLightDef[model]
end)[BUILDID.RANGE], ("RANGE").warlv, ("offset").pos = "RANGE", "offset", cc.p(16, 118)
_ENV = "STABLES"
_ENV = "offset"
;("offset").png = "dh_majiu.png"
;("STABLES").common, ("offset").pos = "offset", cc.p(20, 105)
_ENV = "offset"
;("offset").png = "dh_majiu.png"
;(function(model)
	return cityNightSkinDef.wallLightDef[model]
end)[BUILDID.STABLES], ("STABLES").warlv, ("offset").pos = "STABLES", "offset", cc.p(20, 105)
_ENV = "BARRACKS"
_ENV = "offset"
;("offset").png = "dh_zhanchegongfang.png"
;("BARRACKS").common, ("offset").pos = "offset", cc.p(21, 114)
_ENV = "offset"
;("offset").png = "dh_zhanchegongfang.png"
;(function(model)
	return cityNightSkinDef.wallLightDef[model]
end)[BUILDID.BARRACKS], ("BARRACKS").warlv, ("offset").pos = "BARRACKS", "offset", cc.p(21, 114)
_ENV = "DEPOT"
_ENV = "offset"
;("offset").png = "dh_cangku.png"
;(function(model)
	return cityNightSkinDef.wallLightDef[model]
end)[BUILDID.DEPOT], ("DEPOT").common, ("offset").pos = "DEPOT", "offset", cc.p(15, 58)
_ENV = "EMBASSY"
_ENV = "offset"
;("offset").png = "dh_dashiguan.png"
;(function(model)
	return cityNightSkinDef.wallLightDef[model]
end)[BUILDID.EMBASSY], ("EMBASSY").common, ("offset").pos = "EMBASSY", "offset", cc.p(-6, 112)
_ENV = "DRILL_GROUDS"
_ENV = "offset"
;("offset").png = "dh_jiaochang.png"
;(function(model)
	return cityNightSkinDef.wallLightDef[model]
end)[BUILDID.DRILL_GROUDS], ("DRILL_GROUDS").common, ("offset").pos = "DRILL_GROUDS", "offset", cc.p(-14, 47)
_ENV = "MARKET"
_ENV = "offset"
;("offset").png = "dh_shichang.png"
;(function(model)
	return cityNightSkinDef.wallLightDef[model]
end)[BUILDID.MARKET], ("MARKET").common, ("offset").pos = "MARKET", "offset", cc.p(32, 67)
_ENV = "BLACK_SMITH"
_ENV = "offset"
;("offset").png = "dh_tiejiangpu.png"
;(function(model)
	return cityNightSkinDef.wallLightDef[model]
end)[BUILDID.BLACK_SMITH], ("BLACK_SMITH").common, ("offset").pos = "BLACK_SMITH", "offset", cc.p(0, 103)
_ENV = "COLLEGE"
_ENV = "offset"
;("offset").png = "dh_xueyuan.png"
;(function(model)
	return cityNightSkinDef.wallLightDef[model]
end)[BUILDID.COLLEGE], ("COLLEGE").common, ("offset").pos = "COLLEGE", "offset", cc.p(29, 119)
_ENV = "WISHING_WELL"
_ENV = "offset"
;("offset").png = "dh_xuyuanchi.png"
;(function(model)
	return cityNightSkinDef.wallLightDef[model]
end)[BUILDID.WISHING_WELL], ("WISHING_WELL").common, ("offset").pos = "WISHING_WELL", "offset", cc.p(28, 95)
_ENV = "FORTRESS"
_ENV = "offset"
;("offset").png = "dh_zhanzhengbaolei.png"
;(function(model)
	return cityNightSkinDef.wallLightDef[model]
end)[BUILDID.FORTRESS], ("FORTRESS").common, ("offset").pos = "FORTRESS", "offset", cc.p(-18.5, 126.5)
_ENV = "HALL_OF_WAR"
_ENV = "offset"
;("offset").png = "dh_zhanzhengdating.png"
;(function(model)
	return cityNightSkinDef.wallLightDef[model]
end)[BUILDID.HALL_OF_WAR], ("HALL_OF_WAR").common, ("offset").pos = "HALL_OF_WAR", "offset", cc.p(2, 159)
_ENV = "HERO_PRISON"
_ENV = "offset"
;("offset").png = "dh_jianyu.png"
;(function(model)
	return cityNightSkinDef.wallLightDef[model]
end)[BUILDID.HERO_PRISON], ("HERO_PRISON").common, ("offset").pos = "HERO_PRISON", "offset", cc.p(19, 120)
_ENV = "HERO_TRAIN_GROUND"
_ENV = "offset"
;("offset").png = "dh_yingxiongxunlianying.png"
;(function(model)
	return cityNightSkinDef.wallLightDef[model]
end)[BUILDID.HERO_TRAIN_GROUND], ("HERO_TRAIN_GROUND").common, ("offset").pos = "HERO_TRAIN_GROUND", "offset", cc.p(-1.5, 138)
_ENV = "ELITE_PALACE"
_ENV = "offset"
;("offset").png = "dh_jingyingdiantang.png"
;(function(model)
	return cityNightSkinDef.wallLightDef[model]
end)[BUILDID.ELITE_PALACE], ("ELITE_PALACE").common, ("offset").pos = "ELITE_PALACE", "offset", cc.p(-26, 128)
_ENV = "PETCENTER"
_ENV = "offset"
;("offset").png = "dh_chongwuguan.png"
;(function(model)
	return cityNightSkinDef.wallLightDef[model]
end)[BUILDID.PETCENTER], ("PETCENTER").common, ("offset").pos = "PETCENTER", "offset", cc.p(-14, 73)
_ENV = "NEBULA_PALACE"
_ENV = "offset"
;("offset").png = "dh_nebulapalace.png"
;(function(model)
	return cityNightSkinDef.wallLightDef[model]
end)[BUILDID.NEBULA_PALACE], ("NEBULA_PALACE").common, ("offset").pos = "NEBULA_PALACE", "offset", cc.p(-30, 148)
_ENV = "MAGIC_LAMP"
_ENV = "offset"
;("offset").png = "dh_magiclamp.png"
;(function(model)
	return cityNightSkinDef.wallLightDef[model]
end)[BUILDID.MAGIC_LAMP], ("MAGIC_LAMP").common, ("offset").pos = "MAGIC_LAMP", "offset", cc.p(-8, 90)
_ENV = "MONUMENT"
_ENV = "offset"
;("offset").png = "dh_biannianshi.png"
;(function(model)
	return cityNightSkinDef.wallLightDef[model]
end)[BUILDID.MONUMENT], ("MONUMENT").common, ("offset").pos = "MONUMENT", "offset", cc.p(-15, 123)
_ENV = "CommandHall"
_ENV = "offset"
;("offset").png = "dh_tongshuaidating.png"
;(function(model)
	return cityNightSkinDef.wallLightDef[model]
end)[BUILDID.CommandHall], ("CommandHall").common, ("offset").pos = "CommandHall", "offset", cc.p(26, 35)
_ENV = "NEWBORN_TREE"
_ENV = "offset"
;("offset").png = "dh_newborntree.png"
;(function(model)
	return cityNightSkinDef.wallLightDef[model]
end)[BUILDID.NEWBORN_TREE], ("NEWBORN_TREE").common, ("offset").pos = "NEWBORN_TREE", "offset", cc.p(5, 82)
_ENV = "GARDEN"
_ENV = "offset"
;("offset").png = "dh_maincity_garden.png"
cityNightSkinDef.innerBuildLamplightDef, (function(model)
	return cityNightSkinDef.wallLightDef[model]
end)[BUILDID.GARDEN], ("GARDEN").common, ("offset").pos = function(model)
	return cityNightSkinDef.wallLightDef[model]
end, "GARDEN", "offset", cc.p(-14, 26)
function cityNightSkinDef.getInnerBuildLamplightDef(bid)
	return cityNightSkinDef.innerBuildLamplightDef[bid]
end
function _ENV(bid)
	return cityNightSkinDef.innerBuildLamplightDef[bid]
end
_ENV, _ENV = "common", "SAWMILL"
;("common").png = "dh_fmc_02.png"
_ENV, ("SAWMILL")[2], ("common").pos = "common", "common", cc.p(0, 19.0)
;("common").png = "dh_fmc_03.png"
_ENV, ("SAWMILL")[3], ("common").pos = "common", "common", cc.p(0, 19.0)
;("common").png = "dh_fmc_04.png"
;(function(bid)
	return cityNightSkinDef.innerBuildLamplightDef[bid]
end)[BUILDID.SAWMILL], ("SAWMILL")[4], ("common").pos = "SAWMILL", "common", cc.p(5.5, 19.5)
_ENV, _ENV = "common", "FARM"
;("common").png = "dh_decorate_04.png"
;(function(bid)
	return cityNightSkinDef.innerBuildLamplightDef[bid]
end)[BUILDID.FARM], ("FARM")[4], ("common").pos = "FARM", "common", cc.p(-2, 16.5)
_ENV, _ENV = "common", "STEEL"
;("common").png = "dh_miyinkuangchang.png"
;(function(bid)
	return cityNightSkinDef.innerBuildLamplightDef[bid]
end)[BUILDID.STEEL], ("STEEL")[1], ("common").pos = "STEEL", "common", cc.p(3.5, 8)
_ENV, _ENV = "common", "IRON_MINE"
;("common").png = "dh_tiekuangchang.png"
;(function(bid)
	return cityNightSkinDef.innerBuildLamplightDef[bid]
end)[BUILDID.IRON_MINE], ("IRON_MINE")[1], ("common").pos = "IRON_MINE", "common", cc.p(-3.5, 17.0)
_ENV, _ENV = "common", "MILITARY_TENT"
;("common").png = "dh_xingjunzhangpeng.png"
;(function(bid)
	return cityNightSkinDef.innerBuildLamplightDef[bid]
end)[BUILDID.MILITARY_TENT], ("MILITARY_TENT")[1], ("common").pos = "MILITARY_TENT", "common", cc.p(28.5, -10.5)
_ENV, _ENV = "common", "HOSTPITAL"
;("common").png = "dh_yiliaozhangpeng.png"
cityNightSkinDef.outerBuildLamplightDef, (function(bid)
	return cityNightSkinDef.innerBuildLamplightDef[bid]
end)[BUILDID.HOSTPITAL], ("HOSTPITAL")[1], ("common").pos = function(bid)
	return cityNightSkinDef.innerBuildLamplightDef[bid]
end, "HOSTPITAL", "common", cc.p(42, -4)
function _ENV(bid)
	return cityNightSkinDef.innerBuildLamplightDef[bid]
end
_ENV, _ENV = "common", "SAWMILL"
;("common").png = "dh_fmc_02.png"
_ENV, ("SAWMILL")[2], ("common").pos = "common", "common", cc.p(0, 19.0)
;("common").png = "dh_fmc_03.png"
_ENV, ("SAWMILL")[3], ("common").pos = "common", "common", cc.p(0, 19.0)
;("common").png = "dh_fmc_04.png"
;(function(bid)
	return cityNightSkinDef.innerBuildLamplightDef[bid]
end)[BUILDID.SAWMILL], ("SAWMILL")[4], ("common").pos = "SAWMILL", "common", cc.p(5.5, 19.5)
_ENV, _ENV = "common", "FARM"
;("common").png = "dh_decorate_04.png"
;(function(bid)
	return cityNightSkinDef.innerBuildLamplightDef[bid]
end)[BUILDID.FARM], ("FARM")[4], ("common").pos = "FARM", "common", cc.p(-2, 16.5)
_ENV, _ENV = "common", "STEEL"
;("common").png = "dh_roslightbztjz_08.png"
;(function(bid)
	return cityNightSkinDef.innerBuildLamplightDef[bid]
end)[BUILDID.STEEL], ("STEEL")[1], ("common").pos = "STEEL", "common", cc.p(-43.16, -10.94)
_ENV, _ENV = "common", "IRON_MINE"
;("common").png = "dh_roslightbztjz_11.png"
;(function(bid)
	return cityNightSkinDef.innerBuildLamplightDef[bid]
end)[BUILDID.IRON_MINE], ("IRON_MINE")[1], ("common").pos = "IRON_MINE", "common", cc.p(12.25, 31.2)
_ENV, _ENV = "common", "MILITARY_TENT"
;("common").png = "dh_roslightbztjz_05.png"
;(function(bid)
	return cityNightSkinDef.innerBuildLamplightDef[bid]
end)[BUILDID.MILITARY_TENT], ("MILITARY_TENT")[1], ("common").pos = "MILITARY_TENT", "common", cc.p(19.55, -6.59)
_ENV, _ENV = "common", "HOSTPITAL"
;("common").png = "dh_roslightbztjz_15.png"
cityNightSkinDef.outerBuildLamplightDefBzt, (function(bid)
	return cityNightSkinDef.innerBuildLamplightDef[bid]
end)[BUILDID.HOSTPITAL], ("HOSTPITAL")[1], ("common").pos = function(bid)
	return cityNightSkinDef.innerBuildLamplightDef[bid]
end, "HOSTPITAL", "common", cc.p(3.02, -2.62)
function cityNightSkinDef.getOuterBuildLamplightDef(bid)
	if SoraDGetCtrl("factionCtrl"):getFactionId() == FACTION_TYPE.FACTION_BYZANTINE then
		return cityNightSkinDef.outerBuildLamplightDefBzt[bid]
	else
		return cityNightSkinDef.outerBuildLamplightDef[bid]
	end
end
function cityNightSkinDef.getInnerLamplightByBid(bid)
	local innerTb = cityNightSkinDef.getInnerBuildLamplightDef(bid)
	local png
	local offset = cc.p(0, 0)
	if bid == BUILDID.NEBULA_PALACE then
		local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
		local regionType = nebulaActivityCtrl:getKingdomRegionType()
		local buildList = SoraDGetCtrl("cityCtrl"):getBuildCellList(BUILDID.NEBULA_PALACE)
		local isNebulaShow = 0 < #buildList and regionType == NEBULA_REGION_TYPE.HEGEMONY_REGION
		if not isNebulaShow then
			return png, offset
		end
	end
	if innerTb then
		if innerTb.warlv then
			local gametop = gModuleMgr.getObject("gametop")
			local cityCtrl = gametop.playertop_:getModule("cityCtrl")
			local buildCell = cityCtrl:getBuildCell(bid, 0)
			local buildLv = 1
			if buildCell then
				buildLv = buildCell.info.lv
			end
			local buildLogic = include("buildLogic")
			local isWarLv, warLv = buildLogic.isBuildWarLv(buildLv)
			local isShowWarLv = false
			if isWarLv and 0 < warLv then
				isShowWarLv = true
			end
			if isShowWarLv and next(innerTb.warlv) then
				png = display.newSprite("#" .. SoraDCheckPNG(innerTb.warlv.png))
				offset = innerTb.warlv.pos
			else
				png = display.newSprite("#" .. SoraDCheckPNG(innerTb.common.png))
				offset = innerTb.common.pos
			end
		else
			png = display.newSprite("#" .. SoraDCheckPNG(innerTb.common.png))
			offset = innerTb.common.pos
		end
		if png then
			local fadeIn = math.random(100, 150) / 100
			local fadeOut = math.random(80, 160) / 100
			local delay = math.random(50, 100) / 100
			cityNightSkinDef = buildLogic.isBuildWarLv(buildLv)
			buildLogic.isBuildWarLv(buildLv).fadeIn = fadeIn
			buildLogic.isBuildWarLv(buildLv).fadeOut = fadeOut
			buildLogic.isBuildWarLv(buildLv).delay = delay
			buildLogic.isBuildWarLv(buildLv).beginOpacity = 0.6
			buildLogic.isBuildWarLv(buildLv).endOpacity = 1
			SoraDFadeINOUT(png, buildLogic.isBuildWarLv(buildLv))
		end
	end
	return png, offset
end
function cityNightSkinDef.getOuterLamplightByBid(bid, model)
	local model = model or 1
	local outerTb = cityNightSkinDef.getOuterBuildLamplightDef(bid)
	local png
	local offset = cc.p(0, 0)
	if outerTb and outerTb[model] then
		png = display.newSprite("#" .. SoraDCheckPNG(outerTb[model].png))
		offset = outerTb[model].pos
		local fadeIn = math.random(100, 150) / 100
		local fadeOut = math.random(80, 160) / 100
		local delay = math.random(50, 100) / 100
		cityNightSkinDef = nil
		;(nil).fadeIn = fadeIn
		;(nil).fadeOut = fadeOut
		;(nil).delay = delay
		;(nil).beginOpacity = 0.6
		;(nil).endOpacity = 1
		SoraDFadeINOUT(png, nil)
	end
	return png, offset
end
return cityNightSkinDef
