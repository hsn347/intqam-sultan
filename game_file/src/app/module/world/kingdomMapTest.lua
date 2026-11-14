local _ENV, kingdomMapTest
local gametop = gModuleMgr.getObject("gametop")
function kingdomMapTest:testReqMarch()
	_ENV, gametop = nil, nil
	;(nil).id = 501
	;(nil).num = 1
	local (nil)[1], moveLineType, toX, toY, toId, army = nil, gMapMoveLineType.moveLineTypeRelicsExplore, 754, 973, "755-974-7-3701-0", nil
	local matrixType = gMapMoveLineMatrixType.moveLineMatrixTypeTroop
	local co = coroutine.create(function()
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		gametop = nil
		;(nil).moveLineType = moveLineType
		gametop, gametop, (nil).matrixType = nil, matrixType, matrixType
		;(nil).x = toX
		;(nil).y = toY
		gametop, matrixType.to, (nil).id = nil, nil, toId
		matrixType.data, (nil).exploreTime = nil, 10
		;(nil).data, matrixType.army = matrixType, army
		local mapData = kingdomMapCtrl:reqMarch(nil)
	end)
	coroutine.resume(co)
end
function kingdomMapTest:testReqRelicsEvent()
	local co = coroutine.create(function()
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		local mapData = kingdomMapCtrl:reqRelicsEvent(576, 1055, "577-1056-7-3701-0", 0)
	end)
	coroutine.resume(co)
end
function kingdomMapTest:testReqMoveCity()
	local co = coroutine.create(function()
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		local mapData = kingdomMapCtrl:reqMoveCity(5, 11)
	end)
	coroutine.resume(co)
end
function kingdomMapTest:testReqAllianceMember()
	local co = coroutine.create(function()
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		local mapData = kingdomMapCtrl:reqAllianceMember()
	end)
	coroutine.resume(co)
end
function kingdomMapTest:testReqBackQueue()
	local co = coroutine.create(function()
		local x = 4
		local y = 11
		local id = "11-47"
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		kingdomMapCtrl:reqBackQueue(x, y, id)
	end)
	coroutine.resume(co)
end
function kingdomMapTest:testReqSpeedQueue()
	local co = coroutine.create(function()
		local itemId = 300301
		local queueId = "11-63"
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		kingdomMapCtrl:reqSpeedQueue(itemId, queueId)
	end)
	coroutine.resume(co)
end
function kingdomMapTest:testReqRecallQueue()
	local co = coroutine.create(function()
		local itemId = 300201
		local queueId = "11-5"
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		kingdomMapCtrl:reqRecallQueue(itemId, queueId)
	end)
	coroutine.resume(co)
end
function kingdomMapTest:testReqGetCollectingInfo()
	local co = coroutine.create(function()
		local x = 6
		local y = 10
		local id = "7-11-5-3303-0"
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		gametop = nil
		;(nil).test = 1234
		kingdomMapCtrl:reqGetCollectingInfo(x, y, id, nil)
	end)
	coroutine.resume(co)
end
function kingdomMapTest:testReqMapObjInfo(retMapInfo)
	local co = coroutine.create(function()
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		for _, v in pairs(retMapInfo) do
			kingdomMapCtrl:reqMapObjInfo(v.x, v.y, v.id)
		end
	end)
	coroutine.resume(co)
end
function kingdomMapTest:testReqMarthMassSlave()
	gametop, _UPVALUE1_, gametop, gametop = nil, nil, nil, nil
	;(nil).id = 501
	;(nil).num = 1
	gametop, (nil).army, (nil)[1] = nil, nil, nil
	;(nil).data, (nil).data, (nil).massId = nil, nil, 300
	;(nil).matrixType = 1
	local (nil).moveLineType, testQueueData = 7, nil
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	local mapData = kingdomMapCtrl:reqMarch(testQueueData)
end
function kingdomMapTest:testReqArmyHelpList()
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	kingdomMapCtrl:reqArmyHelpList()
end
function kingdomMapTest:testReqArmyHelpNum()
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	kingdomMapCtrl:reqArmyHelpNum(11)
end
function kingdomMapTest:testReqGetCastleMapInfo()
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	kingdomMapCtrl:reqGetCastleMapInfo(11)
end
function kingdomMapTest:testQueryQueue()
	local queueCtrl = gametop.playertop_:getModule("queueCtrl")
	local ret = queueCtrl:queryQueue(gQueueTypeDef.moveline_map)
end
function kingdomMapTest:testGetMapEventList()
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	kingdomMapCtrl:getMapEventList()
end
function kingdomMapTest:testIsLockByOtherPlayer()
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	local x = 104
	local y = 197
	local mapObjType = gMapObjTypeDef.mapObjTypeResource
	local ret = kingdomMapCtrl:isLockByOtherPlayer(x, y, mapObjType)
end
function kingdomMapTest:testGetPlayerAllQueueArmyList()
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	local ret = kingdomMapCtrl:getPlayerAllQueueArmyList()
end
function kingdomMapTest:testGetMapQueueTimerNode()
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
end
function kingdomMapTest:testGetArmyMoveTime()
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	local mapObjType = gMapObjTypeDef.mapObjTypeNpc
	local worldMapTipButtonType = worldMapDefine.worldMapTipButtonType_gongJi
	gametop, _ENV = nil, nil
	;(nil).id = 401
	;(nil).num = 1
	local gametop, (nil)[1], lstArmy
	;(nil).x = 1000
	local (nil).y, toPoint = 1000, nil
	local ret = kingdomMapCtrl:getArmyMoveTime(mapObjType, worldMapTipButtonType, lstArmy, toPoint)
end
function kingdomMapTest:testGetArmyWeightPlus()
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	local ret = kingdomMapCtrl:getArmyWeightPlus()
end
function kingdomMapTest:testReqGetScoutFood()
	local co = coroutine.create(function()
		local x = 93
		local y = 189
		local id = "2-243"
		local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
		kingdomMapCtrl:reqGetScoutFood(x, y, id)
	end)
	coroutine.resume(co)
end
function kingdomMapTest:testIsHasMassQueue4Uid()
	local uid = 11
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	local ret = kingdomMapCtrl:isHasMassQueue4Uid(uid)
	local uid = 9
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	local ret = kingdomMapCtrl:isHasMassQueue4Uid(uid)
end
function kingdomMapTest:testReqIsSafe()
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	local ret = kingdomMapCtrl:reqIsSafe()
end
function kingdomMapTest:testHasArmyHelpQueue2Player()
	local uid = 14
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	local ret = kingdomMapCtrl:hasArmyHelpQueue2Player(uid)
end
function kingdomMapTest:testReqAddGuideQueue()
	local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
	kingdomMapCtrl:reqAddGuideQueue()
end
function kingdomMapTest:test()
end
return kingdomMapTest
