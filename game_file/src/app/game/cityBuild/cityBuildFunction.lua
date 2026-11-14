include("cityBuildingInfo")
cityBuildFunction, _ENV = include, include
local cityBuildViewDef = include("cityBuildViewDef")
local cityBuildConstDef = include("cityBuildConstDef")
cityBuildFunction.mainCityPos = cc.p(-1, -1)
cityBuildFunction.isFirstLogin = true
cityBuildFunction.mainCityScale = 0.9
cityBuildFunction.isNeedFirstFight = true
function cityBuildFunction:isPointInPolygon(p, l, t, r, b)
	local AB = cc.pSub(t, l)
	local AM = cc.pSub(p, l)
	local BC = cc.pSub(r, t)
	local BM = cc.pSub(p, t)
	local CD = cc.pSub(b, r)
	local CM = cc.pSub(p, r)
	local DA = cc.pSub(l, b)
	local DM = cc.pSub(p, b)
	local ret1 = cc.pCross(AM, AB)
	local ret2 = cc.pCross(BM, BC)
	local ret3 = cc.pCross(CM, CD)
	local ret4 = cc.pCross(DM, DA)
	return 0 < ret1 and 0 < ret2 and 0 < ret3 and 0 < ret4
end
function cityBuildFunction:isTouchPointInBuildTile(touchPoint, btn)
	local nodePoint = btn:convertToNodeSpace(touchPoint)
	local l = cc.p(btn:getContentSize().width / 2, 0)
	local t = cc.p(0, btn:getContentSize().height / 2)
	local r = cc.p(btn:getContentSize().width / 2, btn:getContentSize().height)
	local b = cc.p(btn:getContentSize().width, btn:getContentSize().height / 2)
	return self:isPointInPolygon(nodePoint, l, t, r, b)
end
function cityBuildFunction:removeAll()
	self.mainCityPos = cc.p(-1, -1)
	self.mainCityScale = 0.9
	self.isFirstLogin = true
end
function cityBuildFunction.GetExtendChildFromCCSByNodeName(parent, name, nodeFitOffaet)
	local splitStrs = SoraDStringSplit(name, "_")
	local nodeName = splitStrs[3]
	local child = SoraDGetChildByName(parent, nodeName)
	if child then
		local nameTabel = SoraDStringSplit(name, "_")
		for k, v in pairs(nameTabel) do
			if v == "CSS" then
				local className = nameTabel[k + 1]
				local targetClass = include(className)
				local target = targetClass.new(child)
				if target then
					if nodeFitOffaet then
						SoraDDeviceFitOffset(target)
					end
					return target
				end
				break
			end
		end
	end
	return nil
end
_ENV, cityBuildFunction.GetIconByOpTypeAndBid = cityBuildFunction, function(opType, bid)
	if conditions then
	end
end
cityBuildFunction["1051"] = 6
cityBuildFunction["1056"] = 10
cityBuildFunction["1057"] = 12
cityBuildFunction["1058"] = 14
cityBuildFunction["1059"] = 16
cityBuildFunction["1060"] = 18
cityBuildFunction["1061"] = 20
cityBuildFunction["1062"] = 22
cityBuildFunction["1063"] = 24
cityBuildFunction["1064"] = 26
cityBuildFunction["1065"] = 28
cityBuildFunction["1066"] = 30
local _UPVALUE3_, _UPVALUE16_, _ENV, cityBuildFunction["1067"], zOB = -1, -1, function(opType, bid)
	if conditions then
	end
end, 32, cityBuildFunction
_UPVALUE3_, (-1)[1] = 3400, 3400
_UPVALUE3_, (-1)[2] = 3400, 3360
_UPVALUE3_, (-1)[3] = 3400, 10
_UPVALUE3_, (3400)[1] = 3452, 3452
_UPVALUE3_, (3400)[2] = 3452, 3318
_UPVALUE3_, (3400)[3] = 3452, 1
_UPVALUE3_, (3452)[1] = 3538, 3538
_UPVALUE3_, (3452)[2] = 3538, 3275
_UPVALUE3_, (3452)[3] = 3538, 1
_UPVALUE3_, (3538)[1] = 3652, 3652
_UPVALUE3_, (3538)[2] = 3652, 3335
_UPVALUE3_, (3538)[3] = 3652, 1
_UPVALUE3_, (3652)[1] = 3777, 3777
_UPVALUE3_, (3652)[2] = 3777, 3325
_UPVALUE3_, (3652)[3] = 3777, 1
_UPVALUE3_, (3777)[1] = 3961, 3961
_UPVALUE3_, (3777)[2] = 3961, 3402
_UPVALUE3_, (3777)[3] = 3961, 1
_UPVALUE3_, (3961)[1] = 4370, 4370
_UPVALUE3_, (3961)[2] = 4370, 3193
_UPVALUE3_, (3961)[3] = 4370, 1
_UPVALUE3_, (4370)[1] = 4277, 4277
_UPVALUE3_, (4370)[2] = 4277, 3148
_UPVALUE3_, (4370)[3] = 4277, 1
_UPVALUE3_, (4277)[1] = 4601, 4601
_UPVALUE3_, (4277)[2] = 4601, 2978
_UPVALUE3_, (4277)[3] = 4601, 1
_UPVALUE3_, (4601)[1] = 4663, 4663
_UPVALUE3_, (4601)[2] = 4663, 2876
_UPVALUE3_, (4601)[3] = 4663, 1
_UPVALUE3_, (4663)[1] = 4769, 4769
_UPVALUE3_, (4663)[2] = 4769, 2809
_UPVALUE3_, (4663)[3] = 4769, 36
_UPVALUE3_, (4769)[1] = 3514, 3514
_UPVALUE3_, (4769)[2] = 3514, 2163
_UPVALUE3_, (4769)[3] = 3514, 30
_UPVALUE3_, (3514)[1] = 3390, 3390
_UPVALUE3_, (3514)[2] = 3390, 2232
_UPVALUE3_, (3514)[3] = 3390, 1
_UPVALUE3_, (3390)[1] = 2990, 2990
_UPVALUE3_, (3390)[2] = 2990, 1939
_UPVALUE3_, (3390)[3] = 2990, 1
_UPVALUE3_, (2990)[1] = 1993, 1993
_UPVALUE3_, (2990)[2] = 1993, 1592
_UPVALUE3_, (2990)[3] = 1993, 1
;(1993)[1] = 1325
;(1993)[2] = 959
;(1993)[3] = 1
_UPVALUE3_, _UPVALUE17_, (function(opType, bid)
	if conditions then
	end
end)["1051"], (-1)[1] = -1, -1, -1, -1
_UPVALUE3_, _UPVALUE17_, (function(opType, bid)
	if conditions then
	end
end)["1051"], (-1)[2] = -1, -1, -1, 3400
_UPVALUE3_, _UPVALUE17_, (function(opType, bid)
	if conditions then
	end
end)["1051"], (-1)[3] = -1, -1, -1, 3452
_UPVALUE3_, _UPVALUE17_, (function(opType, bid)
	if conditions then
	end
end)["1051"], (-1)[4] = -1, -1, -1, 3538
_UPVALUE3_, _UPVALUE17_, (function(opType, bid)
	if conditions then
	end
end)["1051"], (-1)[5] = -1, -1, -1, 3652
_UPVALUE3_, _UPVALUE17_, (function(opType, bid)
	if conditions then
	end
end)["1051"], (-1)[6] = -1, -1, -1, 3777
_UPVALUE3_, _UPVALUE17_, (function(opType, bid)
	if conditions then
	end
end)["1051"], (-1)[7] = -1, -1, -1, 3961
_UPVALUE3_, _UPVALUE17_, (function(opType, bid)
	if conditions then
	end
end)["1051"], (-1)[8] = -1, -1, -1, 4370
_UPVALUE3_, _UPVALUE17_, (function(opType, bid)
	if conditions then
	end
end)["1051"], (-1)[9] = -1, -1, -1, 4277
_UPVALUE3_, _UPVALUE17_, (function(opType, bid)
	if conditions then
	end
end)["1051"], (-1)[10] = -1, -1, -1, 4601
_UPVALUE3_, _UPVALUE17_, (function(opType, bid)
	if conditions then
	end
end)["1051"], (-1)[11] = -1, -1, -1, 4663
_UPVALUE3_, _UPVALUE17_, (function(opType, bid)
	if conditions then
	end
end)["1051"], (-1)[12] = -1, -1, -1, 4769
_UPVALUE3_, _UPVALUE17_, (function(opType, bid)
	if conditions then
	end
end)["1051"], (-1)[13] = -1, -1, -1, 3514
_UPVALUE3_, _UPVALUE17_, (function(opType, bid)
	if conditions then
	end
end)["1051"], (-1)[14] = -1, -1, -1, 3390
_UPVALUE3_, _UPVALUE17_, (function(opType, bid)
	if conditions then
	end
end)["1051"], (-1)[15] = -1, -1, -1, 2990
_UPVALUE3_, _UPVALUE17_, (function(opType, bid)
	if conditions then
	end
end)["1051"], (-1)[16] = -1, -1, -1, 1993
_UPVALUE3_, (-1)[1] = 3842, 3842
_UPVALUE3_, (-1)[2] = 3842, 3086
_UPVALUE3_, (-1)[3] = 3842, 12
_UPVALUE3_, (3842)[1] = 3718, 3718
_UPVALUE3_, (3842)[2] = 3718, 3017
_UPVALUE3_, (3842)[3] = 3718, 12
_UPVALUE3_, (3718)[1] = 3368, 3368
_UPVALUE3_, (3718)[2] = 3368, 3189
_UPVALUE3_, (3718)[3] = 3368, 1
_UPVALUE3_, (3368)[1] = 3538, 3538
_UPVALUE3_, (3368)[2] = 3538, 3275
_UPVALUE3_, (3368)[3] = 3538, 1
_UPVALUE3_, (3538)[1] = 3652, 3652
_UPVALUE3_, (3538)[2] = 3652, 3335
_UPVALUE3_, (3538)[3] = 3652, 1
_UPVALUE3_, (3652)[1] = 3777, 3777
_UPVALUE3_, (3652)[2] = 3777, 3325
_UPVALUE3_, (3652)[3] = 3777, 1
_UPVALUE3_, (3777)[1] = 3961, 3961
_UPVALUE3_, (3777)[2] = 3961, 3402
_UPVALUE3_, (3777)[3] = 3961, 1
_UPVALUE3_, (3961)[1] = 4370, 4370
_UPVALUE3_, (3961)[2] = 4370, 3193
_UPVALUE3_, (3961)[3] = 4370, 1
_UPVALUE3_, (4370)[1] = 4277, 4277
_UPVALUE3_, (4370)[2] = 4277, 3148
_UPVALUE3_, (4370)[3] = 4277, 1
_UPVALUE3_, (4277)[1] = 4601, 4601
_UPVALUE3_, (4277)[2] = 4601, 2978
_UPVALUE3_, (4277)[3] = 4601, 1
_UPVALUE3_, (4601)[1] = 4623, 4623
_UPVALUE3_, (4601)[2] = 4623, 2876
_UPVALUE3_, (4601)[3] = 4623, 1
_UPVALUE3_, (4623)[1] = 4769, 4769
_UPVALUE3_, (4623)[2] = 4769, 2809
_UPVALUE3_, (4623)[3] = 4769, 36
_UPVALUE3_, (4769)[1] = 3514, 3514
_UPVALUE3_, (4769)[2] = 3514, 2163
_UPVALUE3_, (4769)[3] = 3514, 30
_UPVALUE3_, (3514)[1] = 3390, 3390
_UPVALUE3_, (3514)[2] = 3390, 2232
_UPVALUE3_, (3514)[3] = 3390, 1
_UPVALUE3_, (3390)[1] = 2990, 2990
_UPVALUE3_, (3390)[2] = 2990, 1939
_UPVALUE3_, (3390)[3] = 2990, 1
_UPVALUE3_, (2990)[1] = 1993, 1993
_UPVALUE3_, (2990)[2] = 1993, 1592
_UPVALUE3_, (2990)[3] = 1993, 1
;(1993)[1] = 1325
;(1993)[2] = 959
;(1993)[3] = 1
_UPVALUE3_, _UPVALUE12_, (function(opType, bid)
	if conditions then
	end
end)["1057"], (-1)[1] = -1, -1, -1, -1
_UPVALUE3_, _UPVALUE12_, (function(opType, bid)
	if conditions then
	end
end)["1057"], (-1)[2] = -1, -1, -1, 3842
_UPVALUE3_, _UPVALUE12_, (function(opType, bid)
	if conditions then
	end
end)["1057"], (-1)[3] = -1, -1, -1, 3718
_UPVALUE3_, _UPVALUE12_, (function(opType, bid)
	if conditions then
	end
end)["1057"], (-1)[4] = -1, -1, -1, 3368
_UPVALUE3_, _UPVALUE12_, (function(opType, bid)
	if conditions then
	end
end)["1057"], (-1)[5] = -1, -1, -1, 3538
_UPVALUE3_, _UPVALUE12_, (function(opType, bid)
	if conditions then
	end
end)["1057"], (-1)[6] = -1, -1, -1, 3652
_UPVALUE3_, _UPVALUE12_, (function(opType, bid)
	if conditions then
	end
end)["1057"], (-1)[7] = -1, -1, -1, 3777
_UPVALUE3_, _UPVALUE12_, (function(opType, bid)
	if conditions then
	end
end)["1057"], (-1)[8] = -1, -1, -1, 3961
_UPVALUE3_, _UPVALUE12_, (function(opType, bid)
	if conditions then
	end
end)["1057"], (-1)[9] = -1, -1, -1, 4370
_UPVALUE3_, _UPVALUE12_, (function(opType, bid)
	if conditions then
	end
end)["1057"], (-1)[10] = -1, -1, -1, 4277
_UPVALUE3_, _UPVALUE12_, (function(opType, bid)
	if conditions then
	end
end)["1057"], (-1)[11] = -1, -1, -1, 4601
_UPVALUE3_, _UPVALUE12_, (function(opType, bid)
	if conditions then
	end
end)["1057"], (-1)[12] = -1, -1, -1, 4623
_UPVALUE3_, _UPVALUE12_, (function(opType, bid)
	if conditions then
	end
end)["1057"], (-1)[13] = -1, -1, -1, 4769
_UPVALUE3_, _UPVALUE12_, (function(opType, bid)
	if conditions then
	end
end)["1057"], (-1)[14] = -1, -1, -1, 3514
_UPVALUE3_, _UPVALUE12_, (function(opType, bid)
	if conditions then
	end
end)["1057"], (-1)[15] = -1, -1, -1, 3390
_UPVALUE3_, _UPVALUE12_, (function(opType, bid)
	if conditions then
	end
end)["1057"], (-1)[16] = -1, -1, -1, 2990
_UPVALUE3_, _UPVALUE12_, (function(opType, bid)
	if conditions then
	end
end)["1057"], (-1)[17] = -1, -1, -1, 1993
_UPVALUE3_, (-1)[1] = 4220, 4220
_UPVALUE3_, (-1)[2] = 4220, 3394
_UPVALUE3_, (-1)[3] = 4220, 20
_UPVALUE3_, (4220)[1] = 4105, 4105
_UPVALUE3_, (4220)[2] = 4105, 3332
_UPVALUE3_, (4220)[3] = 4105, 1
_UPVALUE3_, (4105)[1] = 4370, 4370
_UPVALUE3_, (4105)[2] = 4370, 3193
_UPVALUE3_, (4105)[3] = 4370, 1
_UPVALUE3_, (4370)[1] = 4277, 4277
_UPVALUE3_, (4370)[2] = 4277, 3148
_UPVALUE3_, (4370)[3] = 4277, 1
_UPVALUE3_, (4277)[1] = 4601, 4601
_UPVALUE3_, (4277)[2] = 4601, 2978
_UPVALUE3_, (4277)[3] = 4601, 1
_UPVALUE3_, (4601)[1] = 4663, 4663
_UPVALUE3_, (4601)[2] = 4663, 2876
_UPVALUE3_, (4601)[3] = 4663, 1
_UPVALUE3_, (4663)[1] = 4769, 4769
_UPVALUE3_, (4663)[2] = 4769, 2809
_UPVALUE3_, (4663)[3] = 4769, 36
_UPVALUE3_, (4769)[1] = 3514, 3514
_UPVALUE3_, (4769)[2] = 3514, 2163
_UPVALUE3_, (4769)[3] = 3514, 30
_UPVALUE3_, (3514)[1] = 3390, 3390
_UPVALUE3_, (3514)[2] = 3390, 2232
_UPVALUE3_, (3514)[3] = 3390, 1
_UPVALUE3_, (3390)[1] = 2990, 2990
_UPVALUE3_, (3390)[2] = 2990, 1939
_UPVALUE3_, (3390)[3] = 2990, 1
_UPVALUE3_, (2990)[1] = 1993, 1993
_UPVALUE3_, (2990)[2] = 1993, 1592
_UPVALUE3_, (2990)[3] = 1993, 1
;(1993)[1] = 1325
;(1993)[2] = 959
;(1993)[3] = 1
_UPVALUE3_, _UPVALUE13_, (function(opType, bid)
	if conditions then
	end
end)["1056"], (-1)[1] = -1, -1, -1, -1
_UPVALUE3_, _UPVALUE13_, (function(opType, bid)
	if conditions then
	end
end)["1056"], (-1)[2] = -1, -1, -1, 4220
_UPVALUE3_, _UPVALUE13_, (function(opType, bid)
	if conditions then
	end
end)["1056"], (-1)[3] = -1, -1, -1, 4105
_UPVALUE3_, _UPVALUE13_, (function(opType, bid)
	if conditions then
	end
end)["1056"], (-1)[4] = -1, -1, -1, 4370
_UPVALUE3_, _UPVALUE13_, (function(opType, bid)
	if conditions then
	end
end)["1056"], (-1)[5] = -1, -1, -1, 4277
_UPVALUE3_, _UPVALUE13_, (function(opType, bid)
	if conditions then
	end
end)["1056"], (-1)[6] = -1, -1, -1, 4601
_UPVALUE3_, _UPVALUE13_, (function(opType, bid)
	if conditions then
	end
end)["1056"], (-1)[7] = -1, -1, -1, 4663
_UPVALUE3_, _UPVALUE13_, (function(opType, bid)
	if conditions then
	end
end)["1056"], (-1)[8] = -1, -1, -1, 4769
_UPVALUE3_, _UPVALUE13_, (function(opType, bid)
	if conditions then
	end
end)["1056"], (-1)[9] = -1, -1, -1, 3514
_UPVALUE3_, _UPVALUE13_, (function(opType, bid)
	if conditions then
	end
end)["1056"], (-1)[10] = -1, -1, -1, 3390
_UPVALUE3_, _UPVALUE13_, (function(opType, bid)
	if conditions then
	end
end)["1056"], (-1)[11] = -1, -1, -1, 2990
_UPVALUE3_, _UPVALUE13_, (function(opType, bid)
	if conditions then
	end
end)["1056"], (-1)[12] = -1, -1, -1, 1993
_UPVALUE3_, (-1)[1] = 2724, 2724
_UPVALUE3_, (-1)[2] = 2724, 2880
_UPVALUE3_, (-1)[3] = 2724, 24
_UPVALUE3_, (2724)[1] = 2672, 2672
_UPVALUE3_, (2724)[2] = 2672, 2841
_UPVALUE3_, (2724)[3] = 2672, 1
_UPVALUE3_, (2672)[1] = 2511, 2511
_UPVALUE3_, (2672)[2] = 2511, 2639
_UPVALUE3_, (2672)[3] = 2511, 1
_UPVALUE3_, (2511)[1] = 2599, 2599
_UPVALUE3_, (2511)[2] = 2599, 2593
_UPVALUE3_, (2511)[3] = 2599, 28
_UPVALUE3_, (2599)[1] = 2256, 2256
_UPVALUE3_, (2599)[2] = 2256, 2409
_UPVALUE3_, (2599)[3] = 2256, 28
_UPVALUE3_, (2256)[1] = 1946, 1946
_UPVALUE3_, (2256)[2] = 1946, 2558
_UPVALUE3_, (2256)[3] = 1946, 50
_UPVALUE3_, (1946)[1] = 1667, 1667
_UPVALUE3_, (1946)[2] = 1667, 2410
_UPVALUE3_, (1946)[3] = 1667, 1
_UPVALUE3_, (1667)[1] = 1987, 1987
_UPVALUE3_, (1667)[2] = 1987, 2159
_UPVALUE3_, (1667)[3] = 1987, 1
_UPVALUE3_, (1987)[1] = 1841, 1841
_UPVALUE3_, (1987)[2] = 1841, 2062
_UPVALUE3_, (1987)[3] = 1841, 1
_UPVALUE3_, (1841)[1] = 1965, 1965
_UPVALUE3_, (1841)[2] = 1965, 1938
_UPVALUE3_, (1841)[3] = 1965, 1
_UPVALUE3_, (1965)[1] = 2298, 2298
_UPVALUE3_, (1965)[2] = 2298, 1859
_UPVALUE3_, (1965)[3] = 2298, 1
_UPVALUE3_, (2298)[1] = 1993, 1993
_UPVALUE3_, (2298)[2] = 1993, 1592
_UPVALUE3_, (2298)[3] = 1993, 1
;(1993)[1] = 1325
;(1993)[2] = 959
;(1993)[3] = 1
_UPVALUE3_, _UPVALUE15_, (function(opType, bid)
	if conditions then
	end
end)["1058"], (-1)[1] = -1, -1, -1, -1
_UPVALUE3_, _UPVALUE15_, (function(opType, bid)
	if conditions then
	end
end)["1058"], (-1)[2] = -1, -1, -1, 2724
_UPVALUE3_, _UPVALUE15_, (function(opType, bid)
	if conditions then
	end
end)["1058"], (-1)[3] = -1, -1, -1, 2672
_UPVALUE3_, _UPVALUE15_, (function(opType, bid)
	if conditions then
	end
end)["1058"], (-1)[4] = -1, -1, -1, 2511
_UPVALUE3_, _UPVALUE15_, (function(opType, bid)
	if conditions then
	end
end)["1058"], (-1)[5] = -1, -1, -1, 2599
_UPVALUE3_, _UPVALUE15_, (function(opType, bid)
	if conditions then
	end
end)["1058"], (-1)[6] = -1, -1, -1, 2256
_UPVALUE3_, _UPVALUE15_, (function(opType, bid)
	if conditions then
	end
end)["1058"], (-1)[7] = -1, -1, -1, 1946
_UPVALUE3_, _UPVALUE15_, (function(opType, bid)
	if conditions then
	end
end)["1058"], (-1)[8] = -1, -1, -1, 1667
_UPVALUE3_, _UPVALUE15_, (function(opType, bid)
	if conditions then
	end
end)["1058"], (-1)[9] = -1, -1, -1, 1987
_UPVALUE3_, _UPVALUE15_, (function(opType, bid)
	if conditions then
	end
end)["1058"], (-1)[10] = -1, -1, -1, 1841
_UPVALUE3_, _UPVALUE15_, (function(opType, bid)
	if conditions then
	end
end)["1058"], (-1)[11] = -1, -1, -1, 1965
_UPVALUE3_, _UPVALUE15_, (function(opType, bid)
	if conditions then
	end
end)["1058"], (-1)[12] = -1, -1, -1, 2298
_UPVALUE3_, _UPVALUE15_, (function(opType, bid)
	if conditions then
	end
end)["1058"], (-1)[13] = -1, -1, -1, 1993
_UPVALUE3_, (-1)[1] = 3134, 3134
_UPVALUE3_, (-1)[2] = 3134, 2733
_UPVALUE3_, (-1)[3] = 3134, 26
_UPVALUE3_, (3134)[1] = 3303, 3303
_UPVALUE3_, (3134)[2] = 3303, 2803
_UPVALUE3_, (3134)[3] = 3303, 1
_UPVALUE3_, (3303)[1] = 2939, 2939
_UPVALUE3_, (3303)[2] = 2939, 2984
_UPVALUE3_, (3303)[3] = 2939, 1
_UPVALUE3_, (2939)[1] = 2672, 2672
_UPVALUE3_, (2939)[2] = 2672, 2841
_UPVALUE3_, (2939)[3] = 2672, 1
_UPVALUE3_, (2672)[1] = 2511, 2511
_UPVALUE3_, (2672)[2] = 2511, 2639
_UPVALUE3_, (2672)[3] = 2511, 1
_UPVALUE3_, (2511)[1] = 2599, 2599
_UPVALUE3_, (2511)[2] = 2599, 2593
_UPVALUE3_, (2511)[3] = 2599, 28
_UPVALUE3_, (2599)[1] = 2256, 2256
_UPVALUE3_, (2599)[2] = 2256, 2409
_UPVALUE3_, (2599)[3] = 2256, 28
_UPVALUE3_, (2256)[1] = 1946, 1946
_UPVALUE3_, (2256)[2] = 1946, 2558
_UPVALUE3_, (2256)[3] = 1946, 50
_UPVALUE3_, (1946)[1] = 1667, 1667
_UPVALUE3_, (1946)[2] = 1667, 2410
_UPVALUE3_, (1946)[3] = 1667, 1
_UPVALUE3_, (1667)[1] = 1987, 1987
_UPVALUE3_, (1667)[2] = 1987, 2159
_UPVALUE3_, (1667)[3] = 1987, 1
_UPVALUE3_, (1987)[1] = 1841, 1841
_UPVALUE3_, (1987)[2] = 1841, 2062
_UPVALUE3_, (1987)[3] = 1841, 1
_UPVALUE3_, (1841)[1] = 1965, 1965
_UPVALUE3_, (1841)[2] = 1965, 1938
_UPVALUE3_, (1841)[3] = 1965, 1
_UPVALUE3_, (1965)[1] = 2298, 2298
_UPVALUE3_, (1965)[2] = 2298, 1859
_UPVALUE3_, (1965)[3] = 2298, 1
_UPVALUE3_, (2298)[1] = 1993, 1993
_UPVALUE3_, (2298)[2] = 1993, 1592
_UPVALUE3_, (2298)[3] = 1993, 1
;(1993)[1] = 1325
;(1993)[2] = 959
;(1993)[3] = 1
_UPVALUE3_, _UPVALUE10_, (function(opType, bid)
	if conditions then
	end
end)["1059"], (-1)[1] = -1, -1, -1, -1
_UPVALUE3_, _UPVALUE10_, (function(opType, bid)
	if conditions then
	end
end)["1059"], (-1)[2] = -1, -1, -1, 3134
_UPVALUE3_, _UPVALUE10_, (function(opType, bid)
	if conditions then
	end
end)["1059"], (-1)[3] = -1, -1, -1, 3303
_UPVALUE3_, _UPVALUE10_, (function(opType, bid)
	if conditions then
	end
end)["1059"], (-1)[4] = -1, -1, -1, 2939
_UPVALUE3_, _UPVALUE10_, (function(opType, bid)
	if conditions then
	end
end)["1059"], (-1)[5] = -1, -1, -1, 2672
_UPVALUE3_, _UPVALUE10_, (function(opType, bid)
	if conditions then
	end
end)["1059"], (-1)[6] = -1, -1, -1, 2511
_UPVALUE3_, _UPVALUE10_, (function(opType, bid)
	if conditions then
	end
end)["1059"], (-1)[7] = -1, -1, -1, 2599
_UPVALUE3_, _UPVALUE10_, (function(opType, bid)
	if conditions then
	end
end)["1059"], (-1)[8] = -1, -1, -1, 2256
_UPVALUE3_, _UPVALUE10_, (function(opType, bid)
	if conditions then
	end
end)["1059"], (-1)[9] = -1, -1, -1, 1946
_UPVALUE3_, _UPVALUE10_, (function(opType, bid)
	if conditions then
	end
end)["1059"], (-1)[10] = -1, -1, -1, 1667
_UPVALUE3_, _UPVALUE10_, (function(opType, bid)
	if conditions then
	end
end)["1059"], (-1)[11] = -1, -1, -1, 1987
_UPVALUE3_, _UPVALUE10_, (function(opType, bid)
	if conditions then
	end
end)["1059"], (-1)[12] = -1, -1, -1, 1841
_UPVALUE3_, _UPVALUE10_, (function(opType, bid)
	if conditions then
	end
end)["1059"], (-1)[13] = -1, -1, -1, 1965
_UPVALUE3_, _UPVALUE10_, (function(opType, bid)
	if conditions then
	end
end)["1059"], (-1)[14] = -1, -1, -1, 2298
_UPVALUE3_, _UPVALUE10_, (function(opType, bid)
	if conditions then
	end
end)["1059"], (-1)[15] = -1, -1, -1, 1993
_UPVALUE3_, (-1)[1] = 2329, 2329
_UPVALUE3_, (-1)[2] = 2329, 2475
_UPVALUE3_, (-1)[3] = 2329, 28
_UPVALUE3_, (2329)[1] = 2256, 2256
_UPVALUE3_, (2329)[2] = 2256, 2409
_UPVALUE3_, (2329)[3] = 2256, 28
_UPVALUE3_, (2256)[1] = 1946, 1946
_UPVALUE3_, (2256)[2] = 1946, 2558
_UPVALUE3_, (2256)[3] = 1946, 50
_UPVALUE3_, (1946)[1] = 1667, 1667
_UPVALUE3_, (1946)[2] = 1667, 2410
_UPVALUE3_, (1946)[3] = 1667, 1
_UPVALUE3_, (1667)[1] = 1987, 1987
_UPVALUE3_, (1667)[2] = 1987, 2159
_UPVALUE3_, (1667)[3] = 1987, 1
_UPVALUE3_, (1987)[1] = 1841, 1841
_UPVALUE3_, (1987)[2] = 1841, 2062
_UPVALUE3_, (1987)[3] = 1841, 1
_UPVALUE3_, (1841)[1] = 1965, 1965
_UPVALUE3_, (1841)[2] = 1965, 1938
_UPVALUE3_, (1841)[3] = 1965, 1
_UPVALUE3_, (1965)[1] = 2298, 2298
_UPVALUE3_, (1965)[2] = 2298, 1859
_UPVALUE3_, (1965)[3] = 2298, 1
_UPVALUE3_, (2298)[1] = 1993, 1993
_UPVALUE3_, (2298)[2] = 1993, 1592
_UPVALUE3_, (2298)[3] = 1993, 1
;(1993)[1] = 1325
;(1993)[2] = 959
;(1993)[3] = 1
_UPVALUE3_, _UPVALUE6_, (function(opType, bid)
	if conditions then
	end
end)["1060"], (-1)[1] = -1, -1, -1, -1
_UPVALUE3_, _UPVALUE6_, (function(opType, bid)
	if conditions then
	end
end)["1060"], (-1)[2] = -1, -1, -1, 2329
_UPVALUE3_, _UPVALUE6_, (function(opType, bid)
	if conditions then
	end
end)["1060"], (-1)[3] = -1, -1, -1, 2256
_UPVALUE3_, _UPVALUE6_, (function(opType, bid)
	if conditions then
	end
end)["1060"], (-1)[4] = -1, -1, -1, 1946
_UPVALUE3_, _UPVALUE6_, (function(opType, bid)
	if conditions then
	end
end)["1060"], (-1)[5] = -1, -1, -1, 1667
_UPVALUE3_, _UPVALUE6_, (function(opType, bid)
	if conditions then
	end
end)["1060"], (-1)[6] = -1, -1, -1, 1987
_UPVALUE3_, _UPVALUE6_, (function(opType, bid)
	if conditions then
	end
end)["1060"], (-1)[7] = -1, -1, -1, 1841
_UPVALUE3_, _UPVALUE6_, (function(opType, bid)
	if conditions then
	end
end)["1060"], (-1)[8] = -1, -1, -1, 1965
_UPVALUE3_, _UPVALUE6_, (function(opType, bid)
	if conditions then
	end
end)["1060"], (-1)[9] = -1, -1, -1, 2298
_UPVALUE3_, _UPVALUE6_, (function(opType, bid)
	if conditions then
	end
end)["1060"], (-1)[10] = -1, -1, -1, 1993
_UPVALUE3_, (-1)[1] = 3659, 3659
_UPVALUE3_, (-1)[2] = 3659, 2249
_UPVALUE3_, (-1)[3] = 3659, 30
_UPVALUE3_, (3659)[1] = 3514, 3514
_UPVALUE3_, (3659)[2] = 3514, 2163
_UPVALUE3_, (3659)[3] = 3514, 30
_UPVALUE3_, (3514)[1] = 3390, 3390
_UPVALUE3_, (3514)[2] = 3390, 2232
_UPVALUE3_, (3514)[3] = 3390, 1
_UPVALUE3_, (3390)[1] = 2990, 2990
_UPVALUE3_, (3390)[2] = 2990, 1939
_UPVALUE3_, (3390)[3] = 2990, 1
_UPVALUE3_, (2990)[1] = 1993, 1993
_UPVALUE3_, (2990)[2] = 1993, 1592
_UPVALUE3_, (2990)[3] = 1993, 1
;(1993)[1] = 1325
;(1993)[2] = 959
;(1993)[3] = 1
_UPVALUE3_, _UPVALUE5_, (function(opType, bid)
	if conditions then
	end
end)["1061"], (-1)[1] = -1, -1, -1, -1
_UPVALUE3_, _UPVALUE5_, (function(opType, bid)
	if conditions then
	end
end)["1061"], (-1)[2] = -1, -1, -1, 3659
_UPVALUE3_, _UPVALUE5_, (function(opType, bid)
	if conditions then
	end
end)["1061"], (-1)[3] = -1, -1, -1, 3514
_UPVALUE3_, _UPVALUE5_, (function(opType, bid)
	if conditions then
	end
end)["1061"], (-1)[4] = -1, -1, -1, 3390
_UPVALUE3_, _UPVALUE5_, (function(opType, bid)
	if conditions then
	end
end)["1061"], (-1)[5] = -1, -1, -1, 2990
_UPVALUE3_, _UPVALUE5_, (function(opType, bid)
	if conditions then
	end
end)["1061"], (-1)[6] = -1, -1, -1, 1993
_UPVALUE3_, (-1)[1] = 3080, 3080
_UPVALUE3_, (-1)[2] = 3080, 2204
_UPVALUE3_, (-1)[3] = 3080, 32
_UPVALUE3_, (3080)[1] = 3166, 3166
_UPVALUE3_, (3080)[2] = 3166, 2090
_UPVALUE3_, (3080)[3] = 3166, 1
_UPVALUE3_, (3166)[1] = 2990, 2990
_UPVALUE3_, (3166)[2] = 2990, 1939
_UPVALUE3_, (3166)[3] = 2990, 1
_UPVALUE3_, (2990)[1] = 1993, 1993
_UPVALUE3_, (2990)[2] = 1993, 1592
_UPVALUE3_, (2990)[3] = 1993, 1
;(1993)[1] = 1325
;(1993)[2] = 959
;(1993)[3] = 1
_UPVALUE3_, _UPVALUE9_, (function(opType, bid)
	if conditions then
	end
end)["1062"], (-1)[1] = -1, -1, -1, -1
_UPVALUE3_, _UPVALUE9_, (function(opType, bid)
	if conditions then
	end
end)["1062"], (-1)[2] = -1, -1, -1, 3080
_UPVALUE3_, _UPVALUE9_, (function(opType, bid)
	if conditions then
	end
end)["1062"], (-1)[3] = -1, -1, -1, 3166
_UPVALUE3_, _UPVALUE9_, (function(opType, bid)
	if conditions then
	end
end)["1062"], (-1)[4] = -1, -1, -1, 2990
_UPVALUE3_, _UPVALUE9_, (function(opType, bid)
	if conditions then
	end
end)["1062"], (-1)[5] = -1, -1, -1, 1993
_UPVALUE3_, (-1)[1] = 4689, 4689
_UPVALUE3_, (-1)[2] = 4689, 3048
_UPVALUE3_, (-1)[3] = 4689, 34
_UPVALUE3_, (4689)[1] = 4575, 4575
_UPVALUE3_, (4689)[2] = 4575, 2986
_UPVALUE3_, (4689)[3] = 4575, 1
_UPVALUE3_, (4575)[1] = 4663, 4663
_UPVALUE3_, (4575)[2] = 4663, 2876
_UPVALUE3_, (4575)[3] = 4663, 1
_UPVALUE3_, (4663)[1] = 4769, 4769
_UPVALUE3_, (4663)[2] = 4769, 2809
_UPVALUE3_, (4663)[3] = 4769, 36
_UPVALUE3_, (4769)[1] = 3514, 3514
_UPVALUE3_, (4769)[2] = 3514, 2163
_UPVALUE3_, (4769)[3] = 3514, 30
_UPVALUE3_, (3514)[1] = 3390, 3390
_UPVALUE3_, (3514)[2] = 3390, 2232
_UPVALUE3_, (3514)[3] = 3390, 1
_UPVALUE3_, (3390)[1] = 2990, 2990
_UPVALUE3_, (3390)[2] = 2990, 1939
_UPVALUE3_, (3390)[3] = 2990, 1
_UPVALUE3_, (2990)[1] = 1993, 1993
_UPVALUE3_, (2990)[2] = 1993, 1592
_UPVALUE3_, (2990)[3] = 1993, 1
;(1993)[1] = 1325
;(1993)[2] = 959
;(1993)[3] = 1
_UPVALUE3_, _UPVALUE6_, (function(opType, bid)
	if conditions then
	end
end)["1063"], (-1)[1] = -1, -1, -1, -1
_UPVALUE3_, _UPVALUE6_, (function(opType, bid)
	if conditions then
	end
end)["1063"], (-1)[2] = -1, -1, -1, 4689
_UPVALUE3_, _UPVALUE6_, (function(opType, bid)
	if conditions then
	end
end)["1063"], (-1)[3] = -1, -1, -1, 4575
_UPVALUE3_, _UPVALUE6_, (function(opType, bid)
	if conditions then
	end
end)["1063"], (-1)[4] = -1, -1, -1, 4663
_UPVALUE3_, _UPVALUE6_, (function(opType, bid)
	if conditions then
	end
end)["1063"], (-1)[5] = -1, -1, -1, 4769
_UPVALUE3_, _UPVALUE6_, (function(opType, bid)
	if conditions then
	end
end)["1063"], (-1)[6] = -1, -1, -1, 3514
_UPVALUE3_, _UPVALUE6_, (function(opType, bid)
	if conditions then
	end
end)["1063"], (-1)[7] = -1, -1, -1, 3390
_UPVALUE3_, _UPVALUE6_, (function(opType, bid)
	if conditions then
	end
end)["1063"], (-1)[8] = -1, -1, -1, 2990
_UPVALUE3_, _UPVALUE6_, (function(opType, bid)
	if conditions then
	end
end)["1063"], (-1)[9] = -1, -1, -1, 1993
_UPVALUE3_, (-1)[1] = 4360, 4360
_UPVALUE3_, (-1)[2] = 4360, 2582
_UPVALUE3_, (-1)[3] = 4360, 36
_UPVALUE3_, (4360)[1] = 3514, 3514
_UPVALUE3_, (4360)[2] = 3514, 2163
_UPVALUE3_, (4360)[3] = 3514, 30
_UPVALUE3_, (3514)[1] = 3390, 3390
_UPVALUE3_, (3514)[2] = 3390, 2232
_UPVALUE3_, (3514)[3] = 3390, 1
_UPVALUE3_, (3390)[1] = 2990, 2990
_UPVALUE3_, (3390)[2] = 2990, 1939
_UPVALUE3_, (3390)[3] = 2990, 1
_UPVALUE3_, (2990)[1] = 1993, 1993
_UPVALUE3_, (2990)[2] = 1993, 1592
_UPVALUE3_, (2990)[3] = 1993, 1
;(1993)[1] = 1325
;(1993)[2] = 959
;(1993)[3] = 1
_UPVALUE3_, _UPVALUE7_, (function(opType, bid)
	if conditions then
	end
end)["1064"], (-1)[1] = -1, -1, -1, -1
_UPVALUE3_, _UPVALUE7_, (function(opType, bid)
	if conditions then
	end
end)["1064"], (-1)[2] = -1, -1, -1, 4360
_UPVALUE3_, _UPVALUE7_, (function(opType, bid)
	if conditions then
	end
end)["1064"], (-1)[3] = -1, -1, -1, 3514
_UPVALUE3_, _UPVALUE7_, (function(opType, bid)
	if conditions then
	end
end)["1064"], (-1)[4] = -1, -1, -1, 3390
_UPVALUE3_, _UPVALUE7_, (function(opType, bid)
	if conditions then
	end
end)["1064"], (-1)[5] = -1, -1, -1, 2990
_UPVALUE3_, _UPVALUE7_, (function(opType, bid)
	if conditions then
	end
end)["1064"], (-1)[6] = -1, -1, -1, 1993
_UPVALUE3_, (-1)[1] = 4235, 4235
_UPVALUE3_, (-1)[2] = 4235, 1945
_UPVALUE3_, (-1)[3] = 4235, 38
_UPVALUE3_, (4235)[1] = 3700, 3700
_UPVALUE3_, (4235)[2] = 3700, 1688
_UPVALUE3_, (4235)[3] = 3700, 42
_UPVALUE3_, (3700)[1] = 3573, 3573
_UPVALUE3_, (3700)[2] = 3573, 1621
_UPVALUE3_, (3700)[3] = 3573, 42
_UPVALUE3_, (3573)[1] = 3257, 3257
_UPVALUE3_, (3573)[2] = 3257, 1786
_UPVALUE3_, (3573)[3] = 3257, 1
_UPVALUE3_, (3257)[1] = 2990, 2990
_UPVALUE3_, (3257)[2] = 2990, 1939
_UPVALUE3_, (3257)[3] = 2990, 1
_UPVALUE3_, (2990)[1] = 1993, 1993
_UPVALUE3_, (2990)[2] = 1993, 1592
_UPVALUE3_, (2990)[3] = 1993, 1
;(1993)[1] = 1325
;(1993)[2] = 959
;(1993)[3] = 1
_UPVALUE3_, _UPVALUE11_, (function(opType, bid)
	if conditions then
	end
end)["1065"], (-1)[1] = -1, -1, -1, -1
_UPVALUE3_, _UPVALUE11_, (function(opType, bid)
	if conditions then
	end
end)["1065"], (-1)[2] = -1, -1, -1, 4235
_UPVALUE3_, _UPVALUE11_, (function(opType, bid)
	if conditions then
	end
end)["1065"], (-1)[3] = -1, -1, -1, 3700
_UPVALUE3_, _UPVALUE11_, (function(opType, bid)
	if conditions then
	end
end)["1065"], (-1)[4] = -1, -1, -1, 3573
_UPVALUE3_, _UPVALUE11_, (function(opType, bid)
	if conditions then
	end
end)["1065"], (-1)[5] = -1, -1, -1, 3257
_UPVALUE3_, _UPVALUE11_, (function(opType, bid)
	if conditions then
	end
end)["1065"], (-1)[6] = -1, -1, -1, 2990
_UPVALUE3_, _UPVALUE11_, (function(opType, bid)
	if conditions then
	end
end)["1065"], (-1)[7] = -1, -1, -1, 1993
_UPVALUE3_, (-1)[1] = 3856.12, 3856.12
_UPVALUE3_, (-1)[2] = 3856.12, 1432.88
_UPVALUE3_, (-1)[3] = 3856.12, 1
_UPVALUE3_, (3856.12)[1] = 3336.43, 3336.43
_UPVALUE3_, (3856.12)[2] = 3336.43, 1177.95
_UPVALUE3_, (3856.12)[3] = 3336.43, 1
_UPVALUE3_, (3336.43)[1] = 3175.96, 3175.96
_UPVALUE3_, (3336.43)[2] = 3175.96, 1292.23
_UPVALUE3_, (3336.43)[3] = 3175.96, 1
_UPVALUE3_, (3175.96)[1] = 3083.38, 3083.38
_UPVALUE3_, (3175.96)[2] = 3083.38, 1247.58
_UPVALUE3_, (3175.96)[3] = 3083.38, 101
_UPVALUE3_, (3083.38)[1] = 2672.76, 2672.76
_UPVALUE3_, (3083.38)[2] = 2672.76, 1164.72
_UPVALUE3_, (3083.38)[3] = 2672.76, 101
_UPVALUE3_, (2672.76)[1] = 2368.68, 2368.68
_UPVALUE3_, (2672.76)[2] = 2368.68, 1024.79
_UPVALUE3_, (2672.76)[3] = 2368.68, 1
_UPVALUE3_, (2368.68)[1] = 2073.65, 2073.65
_UPVALUE3_, (2368.68)[2] = 2073.65, 1171.52
_UPVALUE3_, (2368.68)[3] = 2073.65, 1
_UPVALUE3_, (2073.65)[1] = 1762.21, 1762.21
_UPVALUE3_, (2073.65)[2] = 1762.21, 1021.55
_UPVALUE3_, (2073.65)[3] = 1762.21, 1
_UPVALUE3_, (1762.21)[1] = 1965.75, 1965.75
_UPVALUE3_, (1762.21)[2] = 1965.75, 877.12
_UPVALUE3_, (1762.21)[3] = 1965.75, 1
_UPVALUE3_, (1965.75)[1] = 1631.93, 1631.93
_UPVALUE3_, (1965.75)[2] = 1631.93, 672.75
_UPVALUE3_, (1965.75)[3] = 1631.93, 1
;(1631.93)[1] = 1325
;(1631.93)[2] = 959
;(1631.93)[3] = 1
_UPVALUE3_, _UPVALUE6_, (function(opType, bid)
	if conditions then
	end
end)["1066"], (-1)[1] = -1, -1, -1, -1
_UPVALUE3_, _UPVALUE6_, (function(opType, bid)
	if conditions then
	end
end)["1066"], (-1)[2] = -1, -1, -1, 3856.12
_UPVALUE3_, _UPVALUE6_, (function(opType, bid)
	if conditions then
	end
end)["1066"], (-1)[3] = -1, -1, -1, 3336.43
_UPVALUE3_, _UPVALUE6_, (function(opType, bid)
	if conditions then
	end
end)["1066"], (-1)[4] = -1, -1, -1, 3175.96
_UPVALUE3_, _UPVALUE6_, (function(opType, bid)
	if conditions then
	end
end)["1066"], (-1)[5] = -1, -1, -1, 3083.38
_UPVALUE3_, _UPVALUE6_, (function(opType, bid)
	if conditions then
	end
end)["1066"], (-1)[6] = -1, -1, -1, 2672.76
_UPVALUE3_, _UPVALUE6_, (function(opType, bid)
	if conditions then
	end
end)["1066"], (-1)[7] = -1, -1, -1, 2368.68
_UPVALUE3_, _UPVALUE6_, (function(opType, bid)
	if conditions then
	end
end)["1066"], (-1)[8] = -1, -1, -1, 2073.65
_UPVALUE3_, _UPVALUE6_, (function(opType, bid)
	if conditions then
	end
end)["1066"], (-1)[9] = -1, -1, -1, 1762.21
_UPVALUE3_, _UPVALUE6_, (function(opType, bid)
	if conditions then
	end
end)["1066"], (-1)[10] = -1, -1, -1, 1965.75
_UPVALUE3_, _UPVALUE6_, (function(opType, bid)
	if conditions then
	end
end)["1066"], (-1)[11] = -1, -1, -1, 1631.93
_UPVALUE3_, (-1)[1] = 3700, 3700
_UPVALUE3_, (-1)[2] = 3700, 1688
_UPVALUE3_, (-1)[3] = 3700, 42
_UPVALUE3_, (3700)[1] = 3573, 3573
_UPVALUE3_, (3700)[2] = 3573, 1621
_UPVALUE3_, (3700)[3] = 3573, 42
_UPVALUE3_, (3573)[1] = 3257, 3257
_UPVALUE3_, (3573)[2] = 3257, 1786
_UPVALUE3_, (3573)[3] = 3257, 1
_UPVALUE3_, (3257)[1] = 2990, 2990
_UPVALUE3_, (3257)[2] = 2990, 1939
_UPVALUE3_, (3257)[3] = 2990, 1
_UPVALUE3_, (2990)[1] = 1993, 1993
_UPVALUE3_, (2990)[2] = 1993, 1592
_UPVALUE3_, (2990)[3] = 1993, 1
;(1993)[1] = 1325
;(1993)[2] = 959
;(1993)[3] = 1
_UPVALUE3_, _UPVALUE5_, (function(opType, bid)
	if conditions then
	end
end)["1067"], (-1)[1] = -1, -1, -1, -1
_UPVALUE3_, _UPVALUE5_, (function(opType, bid)
	if conditions then
	end
end)["1067"], (-1)[2] = -1, -1, -1, 3700
_UPVALUE3_, _UPVALUE5_, (function(opType, bid)
	if conditions then
	end
end)["1067"], (-1)[3] = -1, -1, -1, 3573
_UPVALUE3_, _UPVALUE5_, (function(opType, bid)
	if conditions then
	end
end)["1067"], (-1)[4] = -1, -1, -1, 3257
_UPVALUE3_, _UPVALUE5_, (function(opType, bid)
	if conditions then
	end
end)["1067"], (-1)[5] = -1, -1, -1, 2990
_UPVALUE3_, _UPVALUE5_, (function(opType, bid)
	if conditions then
	end
end)["1067"], (-1)[6] = -1, -1, -1, 1993
_UPVALUE3_, (-1)[1] = 761, 761
_UPVALUE3_, (-1)[2] = 761, 1927
_UPVALUE3_, (-1)[3] = 761, 1
_UPVALUE3_, (761)[1] = 1102, 1102
_UPVALUE3_, (761)[2] = 1102, 2093
_UPVALUE3_, (761)[3] = 1102, 1
_UPVALUE3_, (1102)[1] = 1548, 1548
_UPVALUE3_, (1102)[2] = 1548, 1879
_UPVALUE3_, (1102)[3] = 1548, 1
_UPVALUE3_, (1548)[1] = 1993, 1993
_UPVALUE3_, (1548)[2] = 1993, 1592
_UPVALUE3_, (1548)[3] = 1993, 1
;(1993)[1] = 1325
;(1993)[2] = 959
;(1993)[3] = 1
;(function(opType, bid)
	if conditions then
	end
end)["1201"], (-1)[1] = -1, -1
;(function(opType, bid)
	if conditions then
	end
end)["1201"], (-1)[2] = -1, 761
;(function(opType, bid)
	if conditions then
	end
end)["1201"], (-1)[3] = -1, 1102
;(function(opType, bid)
	if conditions then
	end
end)["1201"], (-1)[4] = -1, 1548
;(function(opType, bid)
	if conditions then
	end
end)["1201"], (-1)[5] = -1, 1993
local function TroopsMatrix(opType, bid)
	if conditions then
	end
end
function cityBuildFunction.GetTroopsMatrix()
	return TroopsMatrix
end
function cityBuildFunction.GetTroopPointsByIndex(index)
	local keyIndex = tostring(index)
	if SoraDGetCtrl("factionCtrl"):getFactionId() == FACTION_TYPE.FACTION_NORMAL then
		return TroopsMatrix[keyIndex]
	end
end
function cityBuildFunction.GetTroopCCPointsByIndex(index)
	local points = cityBuildFunction.GetTroopPointsByIndex(index)
	if nil == points then
		return
	end
	local _ENV, ccpPonintsArray = index, index
	for i = 1, #points do
		ccpPonintsArray[i] = cc.p(points[i][1], points[i][2])
		ccpPonintsArray[i].z = points[i][3]
	end
	return ccpPonintsArray
end
function cityBuildFunction:getGuideBuildLegendMonument()
	if not IsArClient then
		return false
	end
	if SoraDGetCastleLv() < 6 then
		return false
	end
	_ENV = nil
	;(nil).byUID = true
	if SoraDConfigGet("Game:mainCityView:guideBuildLegendMonument~bool", nil) == false then
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:mainCityView:guideBuildLegendMonument~bool", true, nil)
		return true
	end
	return false
end
function cityBuildFunction:getHasCargo()
	local ret = false
	local gametop = gModuleMgr.getObject("gametop")
	local timeRewardCtrl = gametop.playertop_:getModule("timeRewardCtrl")
	local onlineRewardData = timeRewardCtrl:getTimeRewardData()
	if onlineRewardData and next(onlineRewardData) and onlineRewardData.isReceive == 2 then
		ret = true
	end
	return ret
end
function cityBuildFunction:getHasWuzi()
	local ret = false
	local gametop = gModuleMgr.getObject("gametop")
	local loginRewardCtrl = gametop.playertop_:getModule("loginRewardCtrl")
	if loginRewardCtrl:getCanReceive() then
		ret = true
	end
	return ret
end
function cityBuildFunction:getHasLeisureFreeTime()
	local gametop = gModuleMgr.getObject("gametop")
	local pyramidCtrl = gametop.playertop_:getModule("pyramidCtrl")
	if not pyramidCtrl then
		return false
	end
	local freeTimes = pyramidCtrl:getFreeTime()
	if not freeTimes then
		return false
	end
	if freeTimes <= 0 then
		return false
	end
	return true
end
function cityBuildFunction:setCurrentMainCityPos(pos, viewScale)
	self.mainCityPos = pos
	self.mainCityScale = viewScale
end
function cityBuildFunction:getCurrentMainCityPos(defaultPos)
	if self.mainCityPos.x == -1 and self.mainCityPos.y == -1 then
		self.mainCityPos = defaultPos
		local isFirstLogin = self.isFirstLogin
		self.isFirstLogin = false
		return self.mainCityPos, isFirstLogin, self.mainCityScale
	end
	return self.mainCityPos, cityBuildFunction.isFirstLogin, self.mainCityScale
end
function cityBuildFunction:setIsFirstLogin(value)
	self.isFirstLogin = value
end
function cityBuildFunction:removeFromRelyOnTable(tblRelyOn, node)
	for i, v in ipairs(tblRelyOn) do
		if v.node == node then
			table.remove(tblRelyOn, i)
			break
		end
	end
end
function cityBuildFunction:addToRelyOnTable(tblRelyOn, node, offset)
	for i, v in ipairs(tblRelyOn) do
		if v.node == node then
			print("已经添加了,将会更新位置~")
			v.offset = offset
			return
		end
	end
	_ENV = nil
	;(nil).node = node
	;(nil).offset = offset
	table.insert(tblRelyOn, #tblRelyOn + 1, nil)
end
function cityBuildFunction:loadNodeForParent(parent, node, nodeCfgItem)
	if node.setName ~= nil then
		node:setName(nodeCfgItem.nodeName)
	end
	local canAddToViewNode = cityBuildViewDef.isCanAddToBatchNode(nodeCfgItem.nodeType)
	if nodeCfgItem.alone == true then
		canAddToViewNode = false
	end
	if canAddToViewNode == true then
		parent[nodeCfgItem.nodeName] = node
		local offset = cc.p(node:getPositionX(), node:getPositionY())
		cityBuildFunction:addToRelyOnTable(parent.tblNodeRelyOn, node, offset)
		local batchNode = nodeCfgItem.batchKey and parent.viewNodes[nodeCfgItem.batchKey] or parent.viewNodes.default
		batchNode:addChild(node)
		node:setPosition(cc.p(parent.basePos.x + node:getPositionX(), parent.basePos.y + node:getPositionY()))
		if parent.uiType == cityBuildConstDef.uiType.UI_TYPE_ALONE and nodeCfgItem.nodeType == "animation" then
			node:setPosition(offset)
		end
	elseif nodeCfgItem.nodeType == "ownAction" then
		if nodeCfgItem.anchor then
			parent:setAnchorPoint(nodeCfgItem.anchor)
		end
		parent:runAction(node)
	else
		parent[nodeCfgItem.nodeName] = node
		parent:addChild(node)
	end
end
function cityBuildFunction:updateViewWithBasePos(parent)
	for i, v in ipairs(parent.tblNodeRelyOn) do
		if v.node then
			v.node:setPosition(parent.basePos.x + v.offset.x, parent.basePos.y + v.offset.y)
		end
	end
end
function cityBuildFunction:getTransformedPos(curPos, curScale, targetScale)
	local x = targetScale / curScale * curPos.x
	local y = targetScale / curScale * curPos.y
	return cc.p(x, y)
end
local _ENV, popDataList = cityBuildFunction, cityBuildFunction
local pop_init = function()
	popDataList = nil
	;(nil).byUID = true
	if not SoraDConfigGet("Game:MainCityView:popData~table", nil) then
		popDataList = SoraDConfigGet("Game:MainCityView:popData~table", nil)
	end
end
local pop_record = function(popName)
	popDataList[popName] = serviceFunctions.systemTime()
	popDataList = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:MainCityView:popData~table", popDataList, nil)
end
local pop_select = function(popName)
	local isShow = true
	popDataList = nil
	;(nil).byUID = true
	if not SoraDConfigGet("Game:MainCityView:popData~table", nil) then
		popDataList = SoraDConfigGet("Game:MainCityView:popData~table", nil)
	end
	for k, v in pairs(popDataList) do
		if k == popName and serviceFunctions.isSameDay(v) then
			isShow = false
			break
		end
	end
	return isShow
end
function cityBuildFunction:checkPopUpWindow()
	local bShow = false
	_ENV, _ENV = nil, nil
	;(nil).pType = uiDequeTypeTab.AGREEMENT
	;(nil).callFunc = handler(self, self.checkUserAgreement)
	_ENV, (nil).AGREEMENT, (nil).isDailyLog = nil, nil, false
	;(nil).pType = uiDequeTypeTab.ROSKOCHOICE
	;(nil).callFunc = handler(self, self.checkROSKOChoice)
	;(nil).isDailyLog = true
	_ENV, (nil).ROSKOCHOICE, (nil).logName = nil, nil, "koUserNotifyView"
	;(nil).pType = uiDequeTypeTab.KOH_MIGRATE
	;(nil).callFunc = handler(self, self.checkKOHMigrate)
	_ENV, (nil).KOH_MIGRATE, (nil).isDailyLog = nil, nil, false
	;(nil).pType = uiDequeTypeTab.ACTIVITY_9001657_1
	;(nil).callFunc = handler(self, self.checkActivity9001657_1)
	;(nil).isDailyLog = true
	_ENV, (nil).ACTIVITY_9001657_1, (nil).logName = nil, nil, "ACTIVITY_9001657_1"
	;(nil).pType = uiDequeTypeTab.ACTIVITY_9001657_2
	;(nil).callFunc = handler(self, self.checkActivity9001657_2)
	;(nil).isDailyLog = true
	_ENV, (nil).ACTIVITY_9001657_2, (nil).logName = nil, nil, "ACTIVITY_9001657_2"
	;(nil).pType = uiDequeTypeTab.PAYBACKPOP
	;(nil).callFunc = handler(self, self.checkPayBack)
	_ENV, (nil).PAYBACKPOP, (nil).isDailyLog = nil, nil, false
	;(nil).pType = uiDequeTypeTab.NEWSERVERRETURN
	;(nil).callFunc = handler(self, self.checkNewServerReturn)
	;(nil).isDailyLog = true
	_ENV, (nil).NEWSERVERRETURN, (nil).logName = nil, nil, "NewStart"
	;(nil).pType = uiDequeTypeTab.OPENCHAPTER
	;(nil).callFunc = handler(self, self.checkNewPlayerTask)
	_ENV, (nil).OPENCHAPTER, (nil).isDailyLog = nil, nil, true
	;(nil).pType = uiDequeTypeTab.NEWWEEKCARD
	;(nil).callFunc = handler(self, self.checkNewWeekcard)
	;(nil).isDailyLog = true
	_ENV, (nil).NEWWEEKCARD, (nil).logName = nil, nil, "eventNewWeekcard"
	;(nil).pType = uiDequeTypeTab.LORDLVUP
	;(nil).callFunc = handler(self, self.checkLordLevelUp)
	_ENV, (nil).LORDLVUP, (nil).isDailyLog = nil, nil, false
	;(nil).pType = uiDequeTypeTab.MAGICLAMPLVUP
	;(nil).callFunc = handler(self, self.checkGiftMagicLamp)
	_ENV, (nil).MAGICLAMPLVUP, (nil).isDailyLog = nil, nil, false
	;(nil).pType = uiDequeTypeTab.CASTLELVUP
	;(nil).callFunc = handler(self, self.checkGiftCastle)
	_ENV, (nil).CASTLELVUP, (nil).isDailyLog = nil, nil, false
	;(nil).pType = uiDequeTypeTab.WALLLVUP
	;(nil).callFunc = handler(self, self.checkGiftWall)
	_ENV, (nil).WALLLVUP, (nil).isDailyLog = nil, nil, false
	;(nil).pType = uiDequeTypeTab.RAMADANLETTER
	;(nil).callFunc = handler(self, self.checkRamadanLetter)
	;(nil).isDailyLog = false
	_ENV, (nil).RAMADANLETTER, (nil).logName = nil, nil, "RamadanLetter"
	;(nil).pType = uiDequeTypeTab.MAGICLAMPSKILLDRAW
	;(nil).callFunc = handler(self, self.checkMagicLampSkillDraw)
	;(nil).isDailyLog = false
	_ENV, (nil).MAGICLAMPSKILLDRAW, (nil).logName = nil, nil, "MagicLampSkillDraw"
	;(nil).pType = uiDequeTypeTab.ACITIVITY_9001492
	;(nil).callFunc = handler(self, self.checkActivity9001492)
	;(nil).isDailyLog = true
	_ENV, (nil).ACITIVITY_9001492, (nil).logName = nil, nil, "ACITIVITY_9001492"
	;(nil).pType = uiDequeTypeTab.ACITIVITY_9001575
	;(nil).callFunc = handler(self, self.checkActivity9001575)
	;(nil).isDailyLog = false
	_ENV, (nil).ACITIVITY_9001575, (nil).logName = nil, nil, "ACITIVITY_9001575"
	;(nil).pType = uiDequeTypeTab.ACITIVITY_9001606
	;(nil).callFunc = handler(self, self.checkActivity9001606)
	;(nil).isDailyLog = false
	_ENV, (nil).ACITIVITY_9001606, (nil).logName = nil, nil, "ACITIVITY_9001606"
	;(nil).pType = uiDequeTypeTab.ACTIVITY_9001622
	;(nil).callFunc = handler(self, self.checkActivity9001622)
	;(nil).isDailyLog = false
	_ENV, (nil).ACTIVITY_9001622, (nil).logName = nil, nil, "ACTIVITY_9001622"
	;(nil).pType = uiDequeTypeTab.ACTIVITYPOP
	;(nil).callFunc = handler(self, self.checkHomePopupShow)
	_ENV, (nil).ACTIVITYPOP, (nil).isDailyLog = nil, nil, false
	;(nil).pType = uiDequeTypeTab.RATESTAR
	;(nil).callFunc = handler(self, self.checkRateStar)
	_ENV, (nil).RATESTAR, (nil).isDailyLog = nil, nil, false
	;(nil).pType = uiDequeTypeTab.RECHARGEPOP
	;(nil).callFunc = handler(self, self.checkRechargePop)
	;(nil).isDailyLog = true
	_ENV, (nil).RECHARGEPOP, (nil).logName = nil, nil, "rechargePopFrame"
	;(nil).pType = uiDequeTypeTab.PRINCEGIFT
	;(nil).callFunc = handler(self, self.checkPopUnlockPrinceGift)
	;(nil).isDailyLog = true
	_ENV, (nil).PRINCEGIFT, (nil).logName = nil, nil, "princeGiftView"
	;(nil).pType = uiDequeTypeTab.HERO
	;(nil).callFunc = handler(self, self.checkPopUnlockHero)
	;(nil).isDailyLog = true
	_ENV, (nil).HERO, (nil).logName = nil, nil, "unlockHeroView"
	;(nil).pType = uiDequeTypeTab.PET
	;(nil).callFunc = handler(self, self.checkPopUnlockPet)
	;(nil).isDailyLog = true
	self.activityPopCheckFunc, _ENV, self.popBoxConfig, (nil).PET, (nil).logName = nil, nil, nil, nil, "unlockPetView"
	pop_init()
	local dailyLoginRead = include("dailyLoginRead")
	local popTypeCfgs = dailyLoginRead.getPopCfg()
	for i = 1, 6 do
		local popCfgs = popTypeCfgs[i - 1]
		if i - 1 == 2 then
			self:checkActivityPop(popCfgs)
		else
			for i2, v in ipairs(popCfgs) do
				self:checkPopCfg(v)
			end
		end
	end
	if userSDKManager.showNaviNotice and not GAME_NOVINOTICE_POP then
		userSDKManager.showNaviNotice(true)
		GAME_NOVINOTICE_POP = true
	end
	self:checkDeepLinking()
	return bShow
end
function cityBuildFunction:checkActivityPop(popCfgs)
	local constantRead = include("constantRead")
	local needLv = constantRead.getConstValue("LOGIN_WINDOW_NEEDLV", CASTLE_LV13_LIMITED)
	if needLv > SoraDGetCastleLv() then
		print("城堡等级不足", needLv)
		return
	end
	local logName = "LoginAcitvityPopup"
	local popSelect = pop_select(logName)
	if not popSelect then
		print("类型2通用活动弹窗 今日已经弹出过", logName)
		return
	end
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local _ENV, popGroupIds = "activityShowCtrl", "activityShowCtrl"
	local _ENV, popTodayGroupIds = logName, logName
	for i, v in ipairs(popCfgs) do
		if not popGroupIds[v.group] then
			popGroupIds[v.group], _ENV = nil, nil
			popTodayGroupIds[v.group], _ENV = nil, nil
		end
		local eid
		local reInfo = clientEventMgr.getEventInfoByeid(eid)
		local _eventState = reInfo and reInfo.eventState
		if v.switch ~= 0 and gActivityState.OPEN == _eventState then
			local isCheckFuncTrue = self.activityPopCheckFunc[v.id] and self.activityPopCheckFunc[v.id]() or true
			if isCheckFuncTrue then
				local activityData = activityShowCtrl:getActivityData(v.id)
				if serviceFunctions.isSameDay(activityData.beginTime) then
					table.insert(popTodayGroupIds[v.group], v)
				end
				table.insert(popGroupIds[v.group], v)
			end
		end
	end
	local idx = 0
	local popType2MaxValue = constantRead.getConstValue("LOGIN_WINDOW_MAXNUM", 2)
	local popFunction = function(popCfg)
		SoraDAddPopupWindow(function()
			_ENV = nil
			;(nil).popCfg = popCfg
			uiManager:show("LoginAcitvityPopup", nil)
		end, uiDequeTypeTab.ACITIVITYPOP2_1 + idx, true)
		pop_record(logName)
	end
	for i, v in ipairs(popGroupIds) do
		local popCfgs = 0 < #popTodayGroupIds[i] and popTodayGroupIds[i] or v
		if 0 < #popCfgs and 0 < popType2MaxValue then
			dump(popCfgs, "popCfgs")
			popFunction(popCfgs[math.random(#popCfgs)])
		end
	end
	if 0 < popType2MaxValue and #popGroupIds[2] == 0 and self:checkRateStar() then
		popType2MaxValue = popType2MaxValue - 1
		pop_record(logName)
	end
	if 0 < popType2MaxValue and self:checkPopUpDailyReward() then
		pop_record(logName)
	end
end
function cityBuildFunction:checkPopCfg(popCfg)
	if popCfg.switch == 0 then
		print("弹窗被配置关闭", popCfg.code)
		return
	end
	local popBoxKey = popCfg.code
	local boxCfg = self.popBoxConfig[popBoxKey]
	local pType = uiDequeTypeTab[popBoxKey]
	print("checkPopCfg=====" .. popBoxKey)
	if boxCfg and boxCfg.isDailyLog and boxCfg.logName then
		local popSelect = pop_select(boxCfg.logName)
		print("popSelect======", popSelect)
		if popSelect and SoraDCheckIsCanAdd(pType) then
			local bShow = boxCfg.callFunc(boxCfg, popCfg)
			print("弹不弹========", bShow, pType)
			if bShow then
				pop_record(boxCfg.logName)
			end
		else
			print(boxCfg.logName, "今天已经弹过=======")
		end
	elseif boxCfg and SoraDCheckIsCanAdd(pType) then
		local bShow = boxCfg.callFunc(boxCfg, popCfg)
		print("每次都弹========", bShow, pType)
	elseif not boxCfg then
		print("不存在的popBoxKey", popBoxKey)
	end
end
function cityBuildFunction:checkHomePopupShow(param)
	print("==cityBuildFunction:checkHomePopupShow==")
	_ENV = nil
	;(nil).byUID = true
	if not SoraDConfigGet("Game:MainCityView:popActivity~table", nil) then
		local _ENV, popList = SoraDConfigGet("Game:MainCityView:popActivity~table", nil), SoraDConfigGet("Game:MainCityView:popActivity~table", nil)
	end
	for k, v in pairs(popList) do
		if not serviceFunctions.isSameDay(v) then
			popList, _ENV = serviceFunctions.isSameDay(v), serviceFunctions.isSameDay(v)
			_ENV = nil
			;(nil).byUID = true
			SoraDConfigSet("Game:MainCityView:popActivity~table", popList, nil)
			break
		end
	end
	dump(popList, "popList=======")
	if table.nums(popList) < 3 then
		local proxy = uiManager:getOrCreateProxy("HomePopup")
		if proxy:checkShowView(popList) then
			SoraDAddPopupWindow(function()
				if proxy:checkShowView(popList) then
					proxy = nil
					;(nil).isAddToPopManager = true
					uiManager:show("HomePopup", nil)
				end
			end, param.pType)
			return true
		end
	end
end
function cityBuildFunction:checkRateStar()
	print("cityBuildFunction:checkRateStar ==== ")
	return SoraDShowRateStarView()
end
function cityBuildFunction:checkHeroGiftPop()
	local heroGiftCtrl = SoraDGetCtrl("heroGiftCtrl")
	local giftID = heroGiftCtrl:getPopGiftIDAndRecord()
	if giftID then
		SoraDAddPopupWindow(function()
			_ENV = nil
			;(nil).giftID = giftID
			uiManager:show("HeroGiftRecharge", nil)
		end, uiDequeTypeTab.HEROGIFT)
		return true
	end
end
function cityBuildFunction:checkUserAgreement()
	local gametop = gModuleMgr.getObject("gametop")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local isPop = lordInfoCtrl:getUserAgreementPop()
	if isPop then
		SoraDAddPopupWindow(function()
			SoraDAgreementBox()
		end, uiDequeTypeTab.AGREEMENT)
		return true
	end
end
function cityBuildFunction:checkPayBack()
	local payBackCtrl = SoraDGetCtrl("payBackCtrl")
	local price = payBackCtrl:getPrice()
	if 0 < price then
		SoraDAddPopupWindow(function()
			uiManager:show("BackMoneyPopView")
		end, uiDequeTypeTab.PAYBACKPOP)
		return true
	end
end
function cityBuildFunction:checkROSKOChoice()
	if userSDKManager.isKO() then
		_ENV = nil
		;(nil).byUID = true
		local defaultCfg = SoraDConfigGet("Game:MainCityView:ROSKOChoiceInit~integer", nil)
		if not defaultCfg then
			SoraDGetCtrl("lordInfoCtrl"):getROSKOChoiceState()
			return false
		end
		_ENV = nil
		;(nil).byUID = true
		local bPopBefore = SoraDConfigGet("Game:MainCityView:ROSKOChoice~bool", nil) or false
		if not bPopBefore then
			SoraDAddPopupWindow(function()
				SoraDCreatePanel("koUserNotifyView"):show()
			end, uiDequeTypeTab.ROSKOCHOICE)
			return true
		end
	end
end
function cityBuildFunction:checkKOHMigrate(...)
	_ENV = nil
	;(nil).byUID = true
	local popSuccess = SoraDConfigGet("Game:KOHMigrate:PopSuccess~bool", nil) or false
	if popSuccess then
		SoraDAddPopupWindow(function()
			_ENV = nil
			;(nil).byUID = true
			SoraDConfigSet("Game:KOHMigrate:PopSuccess~bool", false, nil)
			local gametop = gModuleMgr.getObject("gametop")
			local kingdomID = gametop.playertop_:getMapID()
			_ENV = nil
			;(nil).var1 = kingdomID
			local str = i18n("across_move_success_desc", nil)
			_ENV = nil
			;(nil).canNotClose = true
			;(nil).align = SoraDFLabelR()
			;(nil).valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP
			;(nil).title = i18n("across_move_success_title")
			SoraDShowMsgBoxNew(str, i18n("common_text_204"), nil, nil, nil)
		end, uiDequeTypeTab.KOH_MIGRATE)
		return true
	end
end
function cityBuildFunction:checkActivity9001657_1(param, popCfg)
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.MERGE_SERVER_ACTIVITY) then
		return
	end
	local activity_9001657_Ctrl = SoraDGetCtrl("activity_9001657_Ctrl")
	if not activity_9001657_Ctrl:getIsMoveInKingdom() then
		SoraDAddPopupWindow(function()
			_ENV = nil
			;(nil).popCfg = popCfg
			uiManager:show("LoginAcitvityPopup", nil)
		end, param.pType)
		return true
	end
end
function cityBuildFunction:checkActivity9001657_2(param, popCfg)
	local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
	if lordInfoCtrl:getNewMergeGuideFlag() then
		SoraDAddPopupWindow(function()
			lordInfoCtrl:reqCompleteNewMerge()
			local gametop = gModuleMgr.getObject("gametop")
			local kingdomID = gametop.playertop_:getMapID()
			lordInfoCtrl = nil
			;(nil).var1 = kingdomID
			local str = i18n("kingdom_merger_text31", nil)
			lordInfoCtrl = nil
			;(nil).canNotClose = true
			;(nil).align = SoraDFLabelR()
			;(nil).valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP
			;(nil).title = i18n("activity_name_9001657")
			SoraDShowMsgBoxNew(str, i18n("common_text_204"), nil, nil, nil)
		end, param.pType)
		return true
	end
end
function cityBuildFunction:checkSevenDaysGift()
	local bShow = false
	local rechargeGiftDataModuleAPI = include("rechargeGiftDataModuleAPI")
	if rechargeGiftDataModuleAPI:isSevenDaysOpen() then
		local gametop = gModuleMgr.getObject("gametop")
		local cityCtrl = gametop.playertop_:getModule("cityCtrl")
		local cLevel = cityCtrl:getBuildMaxLv(BUILDID.CASTLE)
		_UPVALUE3_ = cityCtrl
		_UPVALUE3_, cityCtrl[1] = 321, 321
		_UPVALUE3_, cityCtrl[2] = 321, 322
		local _UPVALUE3_, cityCtrl[3], giftList = 321, 323, cityCtrl
		;(321)[1] = 3
		;(321)[2] = 6
		local (321)[3], needLv = 10, 321
		local popHightPackage = function(index)
			for i = index, 1, -1 do
				local curRid = giftList[i]
				print("curRid = ", curRid)
				if not rechargeGiftDataModuleAPI:get7DGiftAlreadyBuy(curRid) and rechargeGiftDataModuleAPI:get7DGiftCanBuy(curRid) then
					do
						local data = rechargeGiftDataModuleAPI:getGiftListOf7d()
						for _, v in pairs(data) do
							if v.rid == curRid then
								SoraDAddPopupWindow(function()
									if GLOBAL_GAME_RECHARGE_MODE then
										_ENV = nil
										;(nil).id = curRid
										_ENV, (nil).fromCenter = gRechargeActiveFromEnum.ROAD01, gRechargeActiveFromEnum.ROAD01
										;(nil).otherInfo, gRechargeActiveFromEnum.ROAD01.info = gRechargeActiveFromEnum.ROAD01, clone(v)
										uiManager:show("rechargePopView", nil)
									else
										local panel = SoraDCreatePanel("rechargePopView")
										_ENV = v
										v.info = clone(v)
										panel:initData(curRid, gRechargeActiveFromEnum.ROAD01, nil, v)
										panel:show()
									end
								end, uiDequeTypeTab.SEVENGIFT)
								break
							end
						end
						break
					end
				end
			end
		end
		for i = #giftList, 1, -1 do
			local cv = needLv[i]
			if cLevel >= cv then
				popHightPackage(i)
				break
			end
		end
	end
	return bShow
end
function cityBuildFunction:iosAELoginGiftPopEvent(...)
	local bShow = false
	local giftID = 30200088
	local timeArea = 0
	local judgeCountry = function()
		_UPVALUE1_ = nil
		local (nil)[1], needCountry = "ae", nil
		if userSDKManager.isBeta() or device.platform == "mac" then
			multiClientInitialize.client_country = "cn"
			needCountry[#needCountry + 1] = "cn"
		end
		local found = false
		for _, v in pairs(needCountry) do
			if string.lower(v) == string.lower(multiClientInitialize.client_country) then
				found = true
				break
			end
		end
		return found, string.lower(multiClientInitialize.client_country)
	end
	local judgeDay = function()
		local needNewPop = false
		judgeCountry, judgeCountry = nil, nil
		;(nil).month = 11
		judgeCountry, (nil)[1], (nil).day = nil, nil, 23
		;(nil).month = 11
		judgeCountry, (nil)[2], (nil).day = nil, nil, 30
		;(nil).month = 12
		judgeCountry, (nil)[3], (nil).day = nil, nil, 5
		;(nil).month = 12
		judgeCountry, (nil)[4], (nil).day = nil, nil, 11
		;(nil).month = 12
		judgeCountry, (nil)[5], (nil).day = nil, nil, 17
		;(nil).month = 12
		;(nil)[6], (nil).day = nil, 23
		local needPopDate
		local ret = false
		local isFound, country = judgeCountry()
		if isFound then
			if country == "ae" then
			elseif country == "cn" then
			end
		end
		local tiemTab = os.date("*t", serviceFunctions.systemTime() - timeArea * 3600)
		if tiemTab.year == 2018 then
			for k, v in ipairs(needPopDate) do
				if v.month == tiemTab.month and v.day == tiemTab.day then
					ret = true
					break
				end
			end
		end
		if ret then
			judgeCountry = ipairs(needPopDate)
			ipairs(needPopDate).byUID = true
			local _rTime = SoraDConfigGet("Game:MainCityView:saveTime~integer", ipairs(needPopDate)) or 0
			print("_rTime=========", _rTime)
			judgeCountry = timeArea * 3600
			;(timeArea * 3600).byUID = true
			local isSameDay = serviceFunctions.isSameDay(_rTime, serviceFunctions.systemTime() - timeArea * 3600, timeArea * 3600)
			print("isSameDay=========", isSameDay)
			if not isSameDay then
				needNewPop = true
			end
		end
		return needNewPop
	end
	local judgeEnvi = function()
		local isEnable = false
		if device.platform == "ios" and judgeCountry() then
			isEnable = true
		end
		return isEnable
	end
	local judgeGift = function()
		local ret = SoraDCheckShow(giftID)
		return ret
	end
	if judgeEnvi() and judgeGift() and judgeDay() then
		SoraDAddPopupWindow(function()
			print("理论弹出礼包========")
			if GLOBAL_GAME_RECHARGE_MODE then
				_ENV = nil
				;(nil).id = giftID
				;(nil).fromCenter = gRechargeActiveFromEnum.ROAD26
				uiManager:show("rechargePopFrame", nil)
			else
				local panel = SoraDCreatePanel("rechargePopFrame")
				panel:initData(giftID, gRechargeActiveFromEnum.ROAD26)
				panel:show()
			end
		end, uiDequeTypeTab.IOSUAEGIFT)
		_ENV = timeArea * 3600
		;(timeArea * 3600).byUID = true
		SoraDConfigSet("Game:MainCityView:saveTime~integer", serviceFunctions.systemTime() - timeArea * 3600, timeArea * 3600)
		bShow = true
	end
	return bShow
end
function cityBuildFunction:checkNewKingRise()
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local eventState = activityShowCtrl:getStateByID(gActivityTimeActivityID.NEW_KING_RISES_ACTIVITY)
	print("eventState========", eventState)
	if eventState == gActivityState.OPEN then
		SoraDAddPopupWindow(function()
			SoraDCreatePanel("newKingRiseView"):show()
		end, uiDequeTypeTab.KINGRISE)
		return true
	end
end
function cityBuildFunction:checkCelebratePopWindow()
	local gametop = gModuleMgr.getObject("gametop")
	local ramadanRewardCtrl = gametop.playertop_:getModule("ramadanRewardCtrl")
	local isOpen = ramadanRewardCtrl:getIsOpen()
	local isReceived = ramadanRewardCtrl:getIsReceive()
	print("isOpen,isReceived====", isOpen, isReceived)
	if isOpen and not isReceived then
		SoraDAddPopupWindow(function()
			SoraDCreatePanel("celebratePopWindow"):show()
		end, uiDequeTypeTab.CELEBRATE)
		return true
	end
end
function cityBuildFunction:checkGrowupFund()
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.VALUE_REBATE_ACTIVITY) then
		local gametop = gModuleMgr.getObject("gametop")
		local growupFundCtrl = gametop.playertop_:getModule("growupFundCtrl")
		local ladderGiftCtrl = gametop.playertop_:getModule("ladderGiftCtrl")
		local isShow = growupFundCtrl:getNeedPopWindow() and ladderGiftCtrl:getGrowUpHasEnter()
		if isShow then
			SoraDAddPopupWindow(function()
				SoraDCreatePanel("eventRebateView"):show()
			end, uiDequeTypeTab.GROWUPFUND)
			return true
		end
	end
end
function cityBuildFunction:checkBubbleActivity()
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.BUBBLE_REWARD_ACTIVITY) then
		local bubbleActivityCtrl = SoraDGetCtrl("bubbleActivityCtrl")
		if bubbleActivityCtrl:isCanReceive() and SoraDGetCastleLv() >= CASTLE_LV6_LIMITED then
			SoraDAddPopupWindow(function()
				SoraDCreatePanel("bubblePopView"):show()
				print("弹出气球")
			end, uiDequeTypeTab.BUBBLEACTIVITY)
			return true
		end
	end
end
function cityBuildFunction:checkPopUpDailyReward()
	local hasWuzi = self:getHasWuzi()
	print("hasWuzi====", hasWuzi)
	if hasWuzi and include("pyramidWarltCtrl").checkPwXianXiaSai(true) then
		SoraDAddPopupWindow(function()
			uiManager:show("LuckyCard")
		end, uiDequeTypeTab.DAILYGOOD, true)
		return true
	end
end
function cityBuildFunction:checkPopUpSinbadTreasure()
	local gametop = gModuleMgr.getObject("gametop")
	local sinbadTreasureCtrl = gametop.playertop_:getModule("sinbadTreasureCtrl")
	local funcShowPanel = function()
		local panel = SoraDCreatePanel("sinbadTreasurePopVew")
		panel:show()
	end
	_ENV = nil
	;(nil).byUID = true
	local flag = SoraDConfigGet("Game:sinbadTreasurePopVew:first~bool", nil)
	local isPop = sinbadTreasureCtrl:getIsPopSinbadTreasureView()
	print("checkPopUpSinbadTreasure====", isPop, flag)
	if isPop and flag then
		print("需要弹窗 -------")
		SoraDAddPopupWindow(funcShowPanel, uiDequeTypeTab.SINBADTREASURE)
		return true
	end
end
function cityBuildFunction:checkPopUnlockPet()
	local gametop = gModuleMgr.getObject("gametop")
	local petCtrl = gametop.playertop_:getModule("petCtrl")
	if petCtrl:getHasCanUnlockPet() then
		SoraDAddPopupWindow(function()
			if petCtrl:getHasCanUnlockPet() then
				petCtrl = petCtrl
				petCtrl.msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
				petCtrl.step = 60003
				SoraDSendMessage(petCtrl)
				SoraDDeleteTopWindow()
			end
		end, uiDequeTypeTab.PET)
		return true
	end
end
function cityBuildFunction:checkPopUnlockPrinceGift()
	local gametop = gModuleMgr.getObject("gametop")
	local guideCtrl = gametop.playertop_:getModule("guideCtrl")
	local princeGiftCtrl = gametop.playertop_:getModule("princeGiftCtrl")
	local guideStep = guideCtrl:getCurForceGuideStep()
	local remainTime = princeGiftCtrl:getBuffEndTime() - serviceFunctions.systemTime()
	local isFinished = princeGiftCtrl:isGuideFinish()
	print("weoiruwoeruwoei", guideStep, isFinished, princeGiftCtrl:getBuffEndTime())
	if not guideStep and not isFinished and 0 < remainTime then
		SoraDAddPopupWindow(function()
			self.gameGuideView = include("gameGuideView").new()
			self.gameGuideView:startGuideWithStep(69003)
			self.gameGuideView:show()
			SoraDDeleteTopWindow()
		end, uiDequeTypeTab.PRINCEGIFT)
		return true
	end
end
function cityBuildFunction:checkMerchantOfSerica()
	print("检测赛里斯的商人是否开启")
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.MERCHANT_OF_SERICA, false) and SoraDGetCastleLv() >= CASTLE_LV6_LIMITED then
		SoraDAddPopupWindow(function()
			SoraDCreatePanel("merchantOfSericaView"):show()
		end, uiDequeTypeTab.RECHARGE27)
		return true
	end
	return false
end
function cityBuildFunction:checkPopUnlockHero()
	if SoraDGetCastleLv() < CASTLE_LV7_LIMITED then
		return false
	end
	local ret = false
	local gametop = gModuleMgr.getObject("gametop")
	local heroCtrl = gametop.playertop_:getModule("heroCtrl")
	local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
	local noHaveHeros = heroCtrl:getNoHaveHerosListByRule()
	local unlockHeroID
	for k, v in pairs(noHaveHeros) do
		local itemNum, needNum, itemID = heroltCtrl:judgeUpgradeItem(v)
		if needNum <= itemNum then
			unlockHeroID = v
			ret = true
			break
		end
	end
	if unlockHeroID then
		local activeTime = heroltCtrl:getUpgradeActiveTime(unlockHeroID) or 0
		if 0 < activeTime - serviceFunctions.systemTime() then
			ret = false
			return false
		end
	end
	if ret then
		SoraDAddPopupWindow(function()
			_ENV = nil
			;(nil).msg = "MESSAGE_SERVER_GUIDE_START_BY_STEP"
			;(nil).step = 60004
			SoraDSendMessage(nil)
			SoraDDeleteTopWindow()
		end, uiDequeTypeTab.HERO)
		return true
	end
end
function cityBuildFunction:checkCrazyTrio()
	local gametop = gModuleMgr.getObject("gametop")
	local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
	local cumuActiveCtrl = gametop.playertop_:getModule("cumuActiveCtrl")
	local rechargeltCtrl = include("rechargeltCtrl")
	local crazyTrioData = cumuActiveCtrl:getCrazyTrioData()
	if not crazyTrioData.receive then
		_ENV = crazyTrioData.receive
	end
	local receiveNum = table.nums(crazyTrioData.receive)
	local funUnlockRead = include("funUnlockRead")
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.FIRST_RECHARGE)
	if unlockLv <= SoraDGetCastleLv() then
		local receiveAll = receiveNum == rechargeltCtrl.getRechargeTotalConfigNum()
		local activityID = cumuActiveCtrl:getActivityID()
		if activityShowCtrl:isActivityOpen(activityID) and not receiveAll then
			SoraDAddPopupWindow(function()
				_ENV = nil
				;(nil).eventid = activityID
				;(nil).position = 1
				userSDKManager.logEvent(gSDKDef.TDonEvent.click_crazy_trio, nil)
				clientEventMgr.singleClickEvent(activityID, 3)
			end, uiDequeTypeTab.CRAZYTRIO)
			return true
		end
	end
end
function cityBuildFunction:checkGiftCastle()
	local funcQeueueCastleUp = function()
		print("弹窗咯======")
		SoraDCreatePanel("castleLevelUpView"):show()
	end
	_ENV = nil
	;(nil).byUID = true
	local castleTb = SoraDConfigGet("Game:CastleLvUpView:castleLvList~table", nil)
	dump(castleTb, "castleTb===")
	local privilegeGiftRead = include("privilegeGiftRead")
	if not castleTb then
		return false
	end
	local info = privilegeGiftRead.getRechargeGiftByID(castleTb.rid)
	if not info then
		_ENV, _ENV = nil, nil
		;(nil).byUID = true
		SoraDConfigSet("Game:CastleLvUpView:castleLvList~table", nil, nil)
		return false
	end
	local ret = false
	if castleTb.lv and castleTb.rid and (castleTb.lv > CASTLE_LV30_LIMITED or castleTb.lv <= CASTLE_LV30_LIMITED and castleTb.lv % 5 == 0) then
		SoraDAddPopupWindow(funcQeueueCastleUp, uiDequeTypeTab.CASTLELVUP)
		ret = true
	end
	return ret
end
function cityBuildFunction:checkGiftMagicLamp()
	local funcQeueueMagicLampUp = function()
		print("弹窗咯======")
		uiManager:show("MagicLampLvUpView")
	end
	_ENV = nil
	;(nil).byUID = true
	local rechargeID = SoraDConfigGet("Game:MagicLampLvUpView:magicLvUpRid~integer", nil)
	local ret = false
	if rechargeID and 0 < rechargeID then
		local constantRead = include("constantRead")
		local unlockTime = constantRead.getConstValue("ANILA_LAMP_PRIVILEGE_UNLOCK_TIME")
		local privilegeGiftRead = include("privilegeGiftRead")
		local cfg = privilegeGiftRead.getMagicLampGiftByID(rechargeID)
		if cfg.targetID == 2 and unlockTime > serviceFunctions.systemTime() then
			print("二代神灯特权礼包未到解锁时间=====")
		else
			SoraDAddPopupWindow(funcQeueueMagicLampUp, uiDequeTypeTab.MAGICLAMPLVUP)
			ret = true
		end
	end
	return ret
end
function cityBuildFunction:checkGiftWall()
	local funcQeueueCastleUp = function()
		print("弹窗咯======")
		SoraDCreatePanel("wallLevelUpView"):show()
	end
	_ENV = nil
	;(nil).byUID = true
	local wallTb = SoraDConfigGet("Game:WallLvUpView:wallLvList~table", nil)
	dump(wallTb, "wallTb===")
	local privilegeGiftRead = include("privilegeGiftRead")
	if not wallTb then
		return false
	end
	local info = privilegeGiftRead.getRechargeGiftByID(wallTb.rid)
	if not info then
		_ENV, _ENV = nil, nil
		;(nil).byUID = true
		SoraDConfigSet("Game:WallLvUpView:wallLvList~table", nil, nil)
		return false
	end
	local ret = false
	if wallTb.lv and wallTb.rid then
		SoraDAddPopupWindow(funcQeueueCastleUp, uiDequeTypeTab.WALLLVUP)
		ret = true
	end
	return ret
end
function cityBuildFunction:checkNewPlayerTask()
	local newPlayerTaskCtrl = SoraDGetCtrl("newPlayerTaskCtrl")
	local newPlayerTaskRead = include("newPlayerTaskRead")
	local curChapterID = newPlayerTaskCtrl:getCurChapterID()
	if curChapterID % 1000 <= 800 and curChapterID ~= 4103000 then
		local data = newPlayerTaskCtrl:getTaskInfo()
		local isFinish = false
		for k, v in pairs(data) do
			if v.finishStatus then
				isFinish = true
			end
		end
		if not isFinish then
			return SoraDNewChapterOpen(true)
		end
	end
end
function cityBuildFunction:checkLordLevelUp()
	local gametop = gModuleMgr.getObject("gametop")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	local isPop = lordInfoCtrl:getLordUpgradePopStatus()
	print("isPop========", isPop)
	if isPop then
		local funcQeueueLordUp = function()
			SoraDCreatePanel("lordLevelUpView"):show()
		end
		SoraDAddPopupWindow(funcQeueueLordUp, uiDequeTypeTab.LORDLVUP)
		return true
	end
end
function cityBuildFunction:checkCardReward()
	local bShow = false
	return bShow
end
function cityBuildFunction:getMonthlyCard()
	local gametop = gModuleMgr.getObject("gametop")
	local rechargeActivityCtrl = gametop.playertop_:getModule("rechargeActivityCtrl")
	local monthData = rechargeActivityCtrl:getMonthActivityList()
	local weeklyData = rechargeActivityCtrl:getWeekActivityList()
	local takeData = rechargeActivityCtrl:getTakeActivityList()
	local hasGift = false
	local hasBuy = false
	local hasGot = false
	if next(monthData) or next(weeklyData) or next(takeData) then
		hasGift = true
	end
	if takeData and next(takeData) then
		if takeData.isbuy then
			hasBuy = true
		end
		if takeData.isbuy and takeData.isdayget then
			hasGot = true
		end
	end
	if weeklyData and next(weeklyData) then
		for k, v in pairs(weeklyData) do
			if v.isbuy then
				hasBuy = true
			end
			if v.isbuy and v.isdayget then
				hasGot = true
			end
		end
	end
	if monthData and next(monthData) then
		for k, v in pairs(monthData) do
			if v.isbuy then
				hasBuy = true
			end
			if v.isbuy and v.isdayget then
				hasGot = true
			end
		end
	end
	return hasGift, hasBuy, hasGot
end
function cityBuildFunction:checkDeepLinking()
	deepLinking.req4Link(true)
end
function cityBuildFunction:checkNewWeekcard()
	if IsArClient then
		return false
	end
	local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
	if rechargeActivityCtrl:checkCanbuyNewWeekcard() then
		SoraDShowNewWeekcardView()
		return true
	else
		return false
	end
end
function cityBuildFunction:checkLuckyTreasure()
	local gametop = gModuleMgr.getObject("gametop")
	local luckyTreasureCtrl = gametop.playertop_:getModule("luckyTreasureCtrl")
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.TURNTABLE_ACTIVITY) and luckyTreasureCtrl:checkShowActivity() and luckyTreasureCtrl:getTurnId() then
		SoraDAddPopupWindow(function()
			SoraDCreatePanel("luckyTreasureView"):show()
		end, uiDequeTypeTab.RECHARGE24)
		return true
	else
		return false
	end
end
function cityBuildFunction:checkNewBoard1()
	local gametop = gModuleMgr.getObject("gametop")
	local salesRoomAgCtrl = gametop.playertop_:getModule("salesRoomAgCtrl")
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SALESROOM_ACTIVITY) and salesRoomAgCtrl:checkOpenCond(true) and SoraDGetCastleLv() >= CASTLE_LV6_LIMITED then
		SoraDAddPopupWindow(function()
			uiManager:show("tradeBoardView")
		end, uiDequeTypeTab.RECHARGE26)
		return true
	else
		return false
	end
end
function cityBuildFunction:checkNewBoard2()
	local gametop = gModuleMgr.getObject("gametop")
	local salesRoomAgCtrl = gametop.playertop_:getModule("salesRoomAgCtrl")
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEW_SALESROOM_ACTIVITY) and salesRoomAgCtrl:checkOpenCond(true) and SoraDGetCastleLv() >= CASTLE_LV6_LIMITED then
		SoraDAddPopupWindow(function()
			_ENV = nil
			;(nil).tag = 2
			uiManager:show("tradeBoardView", nil)
		end, uiDequeTypeTab.RECHARGE04)
		return true
	else
		return false
	end
end
function cityBuildFunction:checkRechargeActivity(param)
	local addPopWindow = function(param)
		SoraDAddPopupWindow(function()
			if param.isFgui then
				uiManager:show(param.logName)
				return
			end
			local panel = SoraDCreatePanel(param.logName)
			if param.initFuncName then
				panel[param.initFuncName](panel, param.args)
			end
			panel:show()
		end, param.pType)
	end
	local gametop = gModuleMgr.getObject("gametop")
	local ladderGiftCtrl = gametop.playertop_:getModule("ladderGiftCtrl")
	local manualGiftCtrl = gametop.playertop_:getModule("manualGiftCtrl")
	if param.activityID and clientEventMgr.judgeIsOpen(param.activityID) then
		if param.activityID == gActivityTimeActivityID.VALUE_REBATE_ACTIVITY then
			if ladderGiftCtrl:getGrowUpHasEnter() then
				addPopWindow(param)
				return true
			else
				return false
			end
		elseif param.activityID == gActivityTimeActivityID.MANUAL_GIFT_ACTIVITY then
			if next(manualGiftCtrl:getPackageIDList()) then
				addPopWindow(param)
				return true
			else
				return false
			end
		end
		if param.checkCastleLv and SoraDGetCastleLv() >= param.checkCastleLv then
			addPopWindow(param)
			return true
		elseif not param.checkCastleLv then
			addPopWindow(param)
			return true
		end
	else
		return false
	end
end
function cityBuildFunction:checkHonorBackGift(...)
	local honorBackCtrl = SoraDGetCtrl("honorBackCtrl")
	if honorBackCtrl:checkHonorBackGift() then
		SoraDAddPopupWindow(function()
			if honorBackCtrl:checkHonorBackGift() then
				SoraDCreatePanel("friendsCallbackMail"):show()
			end
		end, uiDequeTypeTab.HONORBACKGIFT)
		return true
	end
	return false
end
function cityBuildFunction:checkSultansWelBack(...)
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SULTAN_BACK_WELCOME_ACTIVITY, false) then
		SoraDAddPopupWindow(function()
			SoraDCreatePanel("sultansBackWelBackView"):show()
		end, uiDequeTypeTab.SULTANSWELBACK)
		return true
	end
	return false
end
function cityBuildFunction:checkNewServerReturn(param)
	local activityCenterUICtrl = SoraDGetCtrl("activityCenterUICtrl")
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEW_START_OLDMAIN_ACTIVITY) then
		if SoraDConfigGet("Game:cityBuildFunction:guideNewServerReturn~bool") then
			SoraDAddPopupWindow(function()
				uiManager:show("NewStart")
			end, param.pType)
		else
			SoraDAddPopupWindow(function()
				SoraDConfigSet("Game:cityBuildFunction:guideNewServerReturn~bool", true)
				_ENV, _UPVALUE3_ = "Game:cityBuildFunction:guideNewServerReturn~bool", SoraDConfigSet
				;("Game:cityBuildFunction:guideNewServerReturn~bool").img = "girl"
				_ENV, ("Game:cityBuildFunction:guideNewServerReturn~bool").str = i18n("newstart_text_20"), i18n("newstart_text_20")
				i18n("newstart_text_20").img = "girl"
				_ENV, i18n("newstart_text_20").str = i18n("newstart_text_21"), i18n("newstart_text_21")
				i18n("newstart_text_21").callback = function()
					_ENV = nil
					userSDKManager.logEvent(gSDKDef.TDonEvent.click_newserverback_enter, nil)
					uiManager:show("NewStart")
				end
				SoraDConfigSet[1] = "Game:cityBuildFunction:guideNewServerReturn~bool"
				SoraDConfigSet[2] = i18n("newstart_text_20")
				local SoraDConfigSet[3], noticeData = i18n("newstart_text_21"), SoraDConfigSet
				gModuleMgr.sharedMgr("mildGuideManager"):createNoticeLine(noticeData)
			end, param.pType)
		end
		return true
	elseif clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEW_START_NEWMAIN_ACTIVITY) then
		local newStartMainCtrl = SoraDGetCtrl("newStartMainCtrl")
		if newStartMainCtrl:checkIsInherit() and SoraDGetCastleLv() >= CASTLE_LV6_LIMITED then
			uiManager:show("NewServerReturn")
		end
	end
	return false
end
function cityBuildFunction:checkRechargeMonthly()
	local hasGift, hasBuy, hasGot = self:getMonthlyCard()
	if hasGift then
		SoraDAddPopupWindow(function()
			if GLOBAL_GAME_RECHARGE_MODE then
				_ENV = nil
				;(nil).toCategory = gRechargeCenterCategory.MONTH
				;(nil).toNodeTag = 0
				uiManager:show("rechargeView", nil)
			else
				SoraDCreatePanel("rechargeMonthlyFrame"):show()
			end
		end, uiDequeTypeTab.RECHARGEMONTHLY)
		return true
	end
	return false
end
function cityBuildFunction:checkHeroTrial()
	local isInPyramidWar = worldMapDefine.isInWar()
	local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
	local isInConquestWar = conquestWarCtrl:isPlayerConquestWarMigration()
	if SoraDGetCastleLv() >= CASTLE_LV9_LIMITED and not isInPyramidWar and not isInConquestWar then
		SoraDAddPopupWindow(function()
			uiManager:show("heroTrialView")
		end, uiDequeTypeTab.HEROTRIAL)
		return true
	end
	return false
end
function cityBuildFunction:checkDailyAward()
	SoraDAddPopupWindow(function()
		_ENV = nil
		;(nil).tab = 2
		uiManager:show("questView", nil)
	end, uiDequeTypeTab.DAILYAWARD)
	return true
end
function cityBuildFunction:checkRechargePop()
	local popShowActiveID = function()
		local reID = 0
		local _ENV, recommendList
		local _ENV, normalList
		local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
		if not rechargeActivityCtrl:filterBuyRankData(rechargeActivityCtrl:getNormalAndAllianceRechargeActivityList()) then
			local _ENV, copyActivityList = rechargeActivityCtrl:filterBuyRankData(rechargeActivityCtrl:getNormalAndAllianceRechargeActivityList()), rechargeActivityCtrl:filterBuyRankData(rechargeActivityCtrl:getNormalAndAllianceRechargeActivityList())
		end
		for k, v in pairs(copyActivityList) do
			if v.recommend and paymentManager.judgeGiftExclusive(tonumber(k)) then
				table.insert(recommendList, k)
			elseif not v.recommend and paymentManager.judgeGiftExclusive(tonumber(k)) then
				table.insert(normalList, k)
			end
		end
		if 0 < table.nums(recommendList) then
			reID = tonumber(recommendList[math.random(#recommendList)])
		elseif 0 < table.nums(normalList) then
			reID = tonumber(normalList[math.random(#normalList)])
		end
		return reID
	end
	local eventIndex = popShowActiveID()
	if eventIndex and 0 < eventIndex then
		SoraDAddPopupWindow(function()
			if GLOBAL_GAME_RECHARGE_MODE then
				_ENV = nil
				;(nil).id = tonumber(eventIndex)
				;(nil).fromCenter = gRechargeActiveFromEnum.ROAD01
				uiManager:show("rechargePopFrame", nil)
			else
				local panel = SoraDCreatePanel("rechargePopFrame")
				panel:initData(tonumber(eventIndex), gRechargeActiveFromEnum.ROAD01)
				panel:show()
			end
		end, uiDequeTypeTab.RECHARGEPOP)
		return true
	end
	return false
end
function cityBuildFunction:checkRamadanLetter(param)
	print("======== cityBuildFunction:checkRamadanLetter")
	return false
end
function cityBuildFunction:checkMagicLampSkillDraw(param)
	local constantRead = include("constantRead")
	local needStarLv = constantRead.getConstValue("MAGIC_DRAW_LV_LIMIT", 60)
	if needStarLv > SoraDGetBuildStarLv() then
		return false
	end
	local magicLampSkillLotteryCtrl = SoraDGetCtrl("magicLampSkillLotteryCtrl")
	local magicLampSkillLotteryRead = include("magicLampSkillLotteryRead")
	local showCfgs = magicLampSkillLotteryRead.getShowCfgList()
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local activityStartTime = activityShowCtrl:getBeginTimeSecond(self.activityID)
	for i, v in ipairs(showCfgs) do
		local poolLastTime
		local taskBeginTime = v.activeTime
		local isCurPoolUnlock = magicLampSkillLotteryCtrl:getIsPoolOpen(v.magicPoolID)
		if isCurPoolUnlock and 1 <= taskBeginTime then
			_ENV = nil
			;(nil).byUID = true
			local lastStarTime = SoraDConfigGet("Game:nebulaMileStoneCtrl:taskBeginTime~integer", nil)
			if lastStarTime ~= activityStartTime then
				_ENV = nil
				;(nil).byUID = true
				SoraDConfigSet("Game:nebulaMileStoneCtrl:taskBeginTime~integer", activityStartTime, nil)
				SoraDAddPopupWindow(function()
					_ENV = nil
					;(nil).cfg = v
					uiManager:show("MagicLampMagicPowerPop", nil)
				end, uiDequeTypeTab.MAGICLAMPSKILLDRAW)
				return true
			end
		end
	end
	return false
end
function cityBuildFunction:checkRamadanCalendar(param)
	return false
end
function cityBuildFunction:checkNewStartAskReward(param)
	local newStartMainCtrl = SoraDGetCtrl("newStartMainCtrl")
	if newStartMainCtrl:checkPopAskRewardView() then
		SoraDAddPopupWindow(function()
			if newStartMainCtrl:checkPopAskRewardView() then
			end
		end, param.pType)
		return true
	end
end
function cityBuildFunction:checkAnniv2022Calendar(param)
	return false
end
function cityBuildFunction:checkActivity9001492(param)
	local activityID = gActivityTimeActivityID.STAR_LIGHT_LAMP_ACTIVITY
	local config = clientEventMgr.getSingleClickEventConfig(activityID)
	if config and SoraDGetCastleLv() < config.checkCastleLv then
		return false
	end
	if clientEventMgr.judgeIsOpen(activityID) then
		SoraDAddPopupWindow(function()
			clientEventMgr.singleClickEvent(activityID)
		end, param.pType)
		return true
	end
end
function cityBuildFunction:checkActivity9001575(param)
	local activityID = gActivityTimeActivityID.CALENDAR_9001575_ACTIVITY
	local config = clientEventMgr.getSingleClickEventConfig(activityID)
	_UPVALUE1_ = nil
	;(nil)[1] = config
	;(nil)[2] = SoraDGetCastleLv()
	;(nil)[3] = SoraDGetCastleLv()
	;(nil)[4] = SoraDGetCastleLv()
	;(nil)[5] = SoraDGetCastleLv()
	dump(nil, "cityBuildFunction:checkActivity9001575")
	if config and SoraDGetCastleLv() < config.checkCastleLv then
		return false
	end
	local guideCtrl = SoraDGetCtrl("guideCtrl")
	_UPVALUE1_ = "cityBuildFunction:checkActivity9001575"
	;("cityBuildFunction:checkActivity9001575")[1] = clientEventMgr.judgeIsOpen(activityID)
	;("cityBuildFunction:checkActivity9001575")[2] = guideCtrl:isGuideNotCompleted(gGuideModule.ACTIVITY_GUIDE)
	;("cityBuildFunction:checkActivity9001575")[3] = guideCtrl:isGuideNotCompleted(gGuideModule.ACTIVITY_GUIDE)
	;("cityBuildFunction:checkActivity9001575")[4] = guideCtrl:isGuideNotCompleted(gGuideModule.ACTIVITY_GUIDE)
	dump("cityBuildFunction:checkActivity9001575", "cityBuildFunction:checkActivity9001575")
	if clientEventMgr.judgeIsOpen(activityID) and guideCtrl:isGuideNotCompleted(gGuideModule.ACTIVITY_GUIDE) then
		print("======== checkActivity9001575")
		SoraDAddPopupWindow(function()
			_ENV = nil
			;(nil).type = "activity"
			;(nil).dialogueID = 900157501
			;(nil).callback = function()
				uiManager:show("Activity_9001575_Guide")
			end
			uiManager:show("MainCityGuideDialog", nil)
		end, param.pType)
		return true
	end
end
function cityBuildFunction:checkActivity9001606(param)
	local gametop = gModuleMgr.getObject("gametop")
	local lordInfoCtrl = gametop.playertop_:getModule("lordInfoCtrl")
	if lordInfoCtrl:getMergeGuideFlag() then
		SoraDAddPopupWindow(function()
			_ENV, _UPVALUE2_ = nil, nil
			;(nil).img = "girl"
			_ENV, (nil).str = i18n("CombineServers_57"), i18n("CombineServers_57")
			i18n("CombineServers_57").callback = function()
				uiManager:show("Activity_9001606_Reward")
			end
			;(nil)[1] = nil
			local (nil)[2], noticeData = i18n("CombineServers_57"), nil
			gModuleMgr.sharedMgr("mildGuideManager"):createNoticeLine(noticeData)
		end, param.pType)
		return true
	end
end
function cityBuildFunction:checkActivity9001613(param, popCfg)
end
function cityBuildFunction:checkActivity9001622(param, popCfg)
	local activityID = gActivityTimeActivityID.END_OF_RAMADAN_ADVANCE
	if not clientEventMgr.getEventInfoByeid(activityID) then
		return
	end
	local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
	local activity_9001622_Ctrl = SoraDGetCtrl("activity_9001622_Ctrl")
	local doStage = activityShowCtrl:getDoStageByID(activityID)
	local bShow = false
	if doStage == 0 and pop_select(param.logName) then
		pop_record(param.logName)
		bShow = true
	elseif doStage == 1 and not activity_9001622_Ctrl:getIsGet() then
		bShow = true
	end
	if bShow then
		SoraDAddPopupWindow(function()
			if not clientEventMgr.getEventInfoByeid(activityID) then
				return
			end
			uiManager:show("Activity_9001622_Pop")
		end, param.pType)
		return true
	end
end
function cityBuildFunction:checkGuide(isWaitPop)
	local constantRead = include("constantRead")
	local func = function()
		SoraDDeletePopupWindow(uiDequeTypeTab.CHCECKGUIDE)
		local gametop = gModuleMgr.getObject("gametop")
		local guideCtrl = gametop.playertop_:getModule("guideCtrl")
		guideCtrl:updateNewGuide()
		if SoraDGetCastleLv() >= CASTLE_LV3_LIMITED and not guideCtrl:updateGuideModule(gGuideModule.OVERVIEW) and not SoraDCurrentTopPanelFromManager() then
			print("触发总览引导")
		end
		local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
		magicLampCtrl:updateGuideLottery()
		local magicLampSkillCtrl = SoraDGetCtrl("magicLampSkillCtrl")
		magicLampSkillCtrl:updateGuideExchangeMall()
		local heroCtrl = SoraDGetCtrl("heroCtrl")
		heroCtrl:updateGuideHeroUnlock()
		local newPlayerTaskCtrl = SoraDGetCtrl("newPlayerTaskCtrl")
		newPlayerTaskCtrl:updateGuideChapterReward()
		_ENV = newPlayerTaskCtrl
		newPlayerTaskCtrl.msg = "MESSAGE_FIRE_JINN_UNLOCK"
		SoraDSendMessage(newPlayerTaskCtrl)
		if userSDKManager.getIsSecondaryLockShow() then
			guideCtrl:updateGuideModule(gGuideModule.SECONDARY_LOCK)
		end
		if GAME_HERO_TEMPLE_MODE and SoraDGetBuildStarLv() >= constantRead.getConstValue("HERO_PALACE_UNLOCK_STAR_LEVEL") then
			guideCtrl:updateGuideModule(gGuideModule.HERO_TEMPLE_UNLOCK)
			guideCtrl:CompleteGuideStep(1160100)
		end
		if not GLOBAL_GAME_RECHARGE_MODE then
			guideCtrl:updateGuideModule(gGuideModule.PAYMENT_INTERFACE)
			guideCtrl:CompleteGuideStep(1190100)
		end
	end
	local guideCtrl = SoraDGetCtrl("guideCtrl")
	if guideCtrl:isGuideNotCompleted(gGuideModule.CASTLE_UPGRADE_NEW) then
		guideCtrl:updateNewGuide()
	elseif isWaitPop then
		SoraDAddPopupWindow(func, uiDequeTypeTab.CHCECKGUIDE)
	else
		func()
	end
end
function cityBuildFunction:checkNewServerCorrelation(param)
	local newStartMainCtrl = SoraDGetCtrl("newStartMainCtrl")
	if not newStartMainCtrl:checkCanCorreltion() then
		return false
	end
	SoraDAddPopupWindow(function()
		if not newStartMainCtrl:checkCanCorreltion() then
			return
		end
		newStartMainCtrl = nil
		newStartMainCtrl = nil
		;(nil).kid = SoraDGetKid()
		;(nil).content = i18n("newstart_text_69", nil)
		;(nil).confirmString = i18n("newstart_text_64")
		;(nil).confirmFunc = function()
			local canCorreltion, code = newStartMainCtrl:checkCanCorreltion()
			if canCorreltion then
				newStartMainCtrl:reqCorreltion(code)
			end
		end
		;(nil).cancelString = i18n("CombineServers_18")
		;(nil).cancelFunc = function()
			newStartMainCtrl:clearCorreltionCode()
		end
		;(nil).isCanCloseSelf = false
		uiManager:show("MessageBox", nil)
	end, param.pType)
	return true
end
return cityBuildFunction
