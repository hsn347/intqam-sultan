local gamemodulec = include("GameModule")
local gametop = gModuleMgr.getObject("gametop")
local manorCityCtrl = class("manorCityCtrl", gamemodulec)
local serverproxy = gModuleMgr.getObject("serverproxy")
local msgCtrl = include("msgCtrl")
local manorCityRead = include("manorCityRead")
local manorFarmRead = include("manorFarmRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local itemDesRead = include("itemDesRead")
function manorCityCtrl:ctor(properties)
	manorCityCtrl.super.ctor(self, properties)
	self:resetData()
end
function manorCityCtrl:EnterGame()
	local queueCtrl = SoraDGetCtrl("queueCtrl")
	queueCtrl:addEventListener(tostring(gQueueTypeDef.garden_build_upgrade), handler(self, self.buildQueueCallback))
	queueCtrl:addEventListener(tostring(gQueueTypeDef.garden_technology), handler(self, self.technologyQueueCallback))
	msgCtrl.register(gCmd.CMD_GARDEN_MODULE, gCmd.REQ_GARDEN_INIT, handler(self, self.reqGardenInitRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_MODULE, gCmd.REQ_GARDEN_UNLOCK, handler(self, self.reqGardenUnlockRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_MAP_MODULE, gCmd.REQ_GARDEN_MAP_QUERY_MAP, handler(self, self.reqGardenMapQueryMapRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_MAP_MODULE, gCmd.REQ_GARDEN_MAP_PLACE, handler(self, self.reqGardenMapPlaceRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_MAP_MODULE, gCmd.REQ_GARDEN_MAP_MOVE, handler(self, self.reqGardenMapMoveRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_MAP_MODULE, gCmd.REQ_GARDEN_MAP_RECYCLE, handler(self, self.reqGardenMapRecycleRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_MAP_MODULE, gCmd.REQ_GARDEN_UPGRADE_BUILD, handler(self, self.reqGardenMapUpgradeBuildRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_MAP_MODULE, gCmd.RER_GARDEN_MAP_IN_WAR_MAP, handler(self, self.reqInWarMapRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_MAP_MODULE, gCmd.REQ_GARDEN_MAP_OUT_WAR_MAP, handler(self, self.reqOutWarMapRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_MAP_MODULE, gCmd.REQ_GARDEN_MAP_RANDOM_VISIT, handler(self, self.reqGardenMapRandomVisitRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_MAP_MODULE, gCmd.REQ_GARDEN_MAP_ATTEND_PARTY, handler(self, self.reqGardenMapAttendPartyRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_DRESS_MODULE, gCmd.REQ_GARDEN_DRESS_INIT, handler(self, self.reqDressInitRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_DRESS_MODULE, gCmd.REQ_GARDEN_DRESS_UP_LV, handler(self, self.reqDressUpLvRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_DRESS_MODULE, gCmd.REQ_GARDEN_DRESS_ACTIVE, handler(self, self.reqDressActiveRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_DRESS_MODULE, gCmd.REQ_GARDEN_DRESS_CANCEL, handler(self, self.reqDressCancelRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_DRESS_MODULE, gCmd.REQ_GARDEN_DRESS_CLEAR_NEW, handler(self, self.reqDressClearNewRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_DRESS_MODULE, gCmd.REQ_GARDEN_DRESS_EXCHANGE, handler(self, self.reqDressExchangeRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_FARMLAND_MODULE, gCmd.REQ_GARDEN_FARMLAND_DATA, handler(self, self.reqFarmlandDataRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_FARMLAND_MODULE, gCmd.REQ_GARDEN_FARMLAND_CHANGE_FARMLAND_TYPE, handler(self, self.reqFarmlandChangeTypeRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_FARMLAND_MODULE, gCmd.REQ_GARDEN_FARMLAND_PLANT, handler(self, self.reqFarmlandPlantRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_FARMLAND_MODULE, gCmd.REQ_GARDEN_FARMLAND_PICK_FRUIT, handler(self, self.reqFarmlandPickFruitRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_FARMLAND_MODULE, gCmd.REQ_GARDEN_FARMLAND_MERGE_SEED, handler(self, self.reqFarmlandMergeSeedRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_FARMLAND_MODULE, gCmd.REQ_GARDEN_FARMLAND_PICK_MERGE_SEED, handler(self, self.reqFarmlandPickMergeSeedRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_FARMLAND_MODULE, gCmd.REQ_GARDEN_FARMLAND_RECYCLE, handler(self, self.reqFarmlandRecycleRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_FARMLAND_MODULE, gCmd.REQ_GARDEN_FARMLAND_CULTIVATE_FRUIT, handler(self, self.reqFarmlandCultivateFruitRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_FARMLAND_MODULE, gCmd.REQ_GARDEN_FARMLAND_PICK_CULTIVATE, handler(self, self.reqFarmlandPickCultivateRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_FARMLAND_MODULE, gCmd.REQ_GARDEN_FARMLAND_MARKET_MY_SALE_LIST, handler(self, self.reqMarketMySaleListRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_FARMLAND_MODULE, gCmd.REQ_GARDEN_FARMLAND_MARKET_SALE_PRICE, handler(self, self.reqMarketSalePriceRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_FARMLAND_MODULE, gCmd.REQ_GARDEN_FARMLAND_MARKET_ON_SALE, handler(self, self.reqMarketOnSaleRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_FARMLAND_MODULE, gCmd.REQ_GARDEN_FARMLAND_MARKET_OFF_SALE, handler(self, self.reqMarketOffSaleRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_FARMLAND_MODULE, gCmd.REQ_GARDEN_FARMLAND_MARKET_SALE_LIST, handler(self, self.reqMarketSaleListRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_FARMLAND_MODULE, gCmd.REQ_GARDEN_FARMLAND_MARKET_BUY, handler(self, self.reqMarketBuyRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_FARMLAND_MODULE, gCmd.REQ_GARDEN_FARMLAND_USE_SEEDPACK, handler(self, self.reqFarmlandUseSeedPackRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_FARMLAND_MODULE, gCmd.REQ_GARDEN_FARMLAND_ASSIST, handler(self, self.reqFarmlandAssistRsp))
	msgCtrl.register(gCmd.CMD_GARDEN_FARMLAND_MODULE, gCmd.REQ_GARDEN_FARMLAND_CANCEL_MERGE_SEED, handler(self, self.reqFarmlandCancelMergeSeedRsp))
	self:registerNotify()
	self:reqGardenInit()
	self:reqDressInit()
	self:reqGardenMapQueryMap()
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_NEWDAY", handler(self, self.newDay))
end
function manorCityCtrl:Logout()
	manorCityCtrl.super.Logout(self)
	self:resetData()
end
function manorCityCtrl:resetData()
	_UPVALUE0_ = nil
	_UPVALUE0_, (nil).isUnLock = nil, false
	;(nil).lastResetTime = 0
	_UPVALUE0_, self.initData, (nil).party, (nil).rewardTimes = nil, nil, nil, 0
	self.mapData, _UPVALUE0_, self.dressData, (nil).activeBuild, _UPVALUE0_, (nil).build, _UPVALUE0_, (nil).backpack, _UPVALUE0_, (nil).isDefault = nil, nil, nil, nil, nil, nil, nil, nil, nil, true
	_UPVALUE0_, self.isMapDataDefault = nil, true
	;(nil).freeChangeFarmlandTypeCount = 0
	_UPVALUE0_, (nil).seedpack, (nil).bag, _UPVALUE0_, _UPVALUE0_, (nil).fruit, (nil).cultivate, (nil).ground, _UPVALUE0_, (nil).tree, _UPVALUE0_, _UPVALUE0_, (nil).book, _UPVALUE0_, (nil).bag, _UPVALUE0_, _UPVALUE0_, (nil).seed, (nil).mergeRecord, _UPVALUE0_, (nil).merge, _UPVALUE0_, (nil).bag, _UPVALUE0_, _UPVALUE0_, (nil).lastFreeChangeFarmlandTypeTime = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 0
	;(nil).lastResetTime = 0
	;(nil).record, _UPVALUE0_, (nil).assistTimes = nil, nil, 0
	;(nil).assist, (nil).assistRecord, _UPVALUE0_, (nil).lastResetAssistTime = nil, nil, nil, 0
	self.marketMySaleList, _UPVALUE0_, self.farmlandData, (nil).coin = nil, nil, nil, 0
	self.marketMySaleListLoaded = false
	self:resetBuffMap()
end
function manorCityCtrl:registerNotify()
	local notifyCtrl = gametop.playertop_:getModule("notifyCtrl")
	notifyCtrl:register(gNotifyID.GARDEN_MAP, handler(self, self.notifyMapHandler))
	notifyCtrl:register(gNotifyID.GARDEN_DRESS, handler(self, self.notifyDressHandler))
	notifyCtrl:register(gNotifyID.GARDEN_FARMLAND, handler(self, self.notifyFarmHandler))
end
function manorCityCtrl:notifyMapHandler(event)
	dump(event.data, "manorCityCtrl:notifyMapHandler", 10)
	for k, v in ipairs(event.data) do
		local notifyType = v.notifyType
		local notifyData = v.notifyData
		if notifyType == "updateMapObj" then
			local realId = notifyData.realId
			local mapObj = notifyData.mapObj
			self.mapData[realId] = mapObj
			self:updateBuildBuffMap()
			_ENV = self
			self.msg = "MESSAGE_MANOR_BUILD_UPDATE"
			self.data = mapObj
			SoraDSendMessage(self)
		elseif notifyType == "removeMapObj" then
			self.mapData[notifyData.realId] = nil
			self:updateBuildBuffMap()
			_ENV = self
			self.msg = "MESSAGE_MANOR_BUILD_REMOVE"
			self.data = notifyData.realId
			SoraDSendMessage(self)
		end
	end
end
function manorCityCtrl:notifyDressHandler(event)
