local gametop = gModuleMgr.getObject("gametop")
local pandectRead = include("pandectRead")
local buildLogic = include("buildLogic")
local cityBuildConstDef = include("cityBuildConstDef")
local heroTrainGroundCtrl = gametop.playertop_:getModule("heroTrainGroundCtrl")
local escortCtrl = gametop.playertop_:getModule("escortCtrl")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
local worldMapDefine = include("worldMapDefine")
local baseComponent = require("fgui.base.baseComponent")
local pandectView = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/pandectView", pandectView)
function pandectView:onInit()
	self.isFirst = true
	self.openStyle = 1
	self.moveX = SoraDFIsRA() and 485 or -485
	self.singleArray, _ENV, self.currentViewType = VIEW_TYPE_CITY, VIEW_TYPE_CITY, VIEW_TYPE_CITY
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setVisible(false)
	self.fields.Lab_title:setString(i18n("common_text_3867"))
	self.fields.Button_pandect:addClickListener(handler(self, self.btnClickCallBack))
	self.fields.touch:addClickListener(handler(self, self.emptyClose))
	self.fields.Panel_black:fixPos()
	self.fields.Panel_black:fix()
	self.fields.Button_pandect:fixPos()
	self.fields.Button_pandect:setScale(SoraDFIsRA() and 1 or -1)
end
function pandectView:onShow()
	self.oriPosX = self.fields.Panel_black:getPositionX()
	self.handY = self.fields.spriteHand:getPositionY()
	self.fields.touch:setTouchEnabled(false)
	self:initPandectDef()
	self:initData()
	self:initGlobalTimer()
end
function pandectView:registerEvent()
	SoraDAddMessage(self, "MESSAGE_MAINUI_CLOSE_PANDECT", function()
		self:closeSelf(true)
	end)
	SoraDAddMessage(self, "MESSAGE_UI_PANDECT_ALLREFRESH", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_CASTLE_LEVELUP", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_ESCORT_REQ_CLOSEST_BUILD", handler(self, self.handlEscort))
	SoraDAddMessage(self, "MESSAGE_MAINSCEN_ONSHOW", handler(self, self.changeMainScene))
	SoraDAddMessage(self, "MESSAGE_SERVER_WORLDKINGDOM_LV_CHANGE", handler(self, self.kingdomLevelUp))
	SoraDAddMessage(self, "MESSAGE_SECOND_STAR_BUILDING_BTN_REFRESH", handler(self, self.initData))
end
function pandectView:addMessage()
	for k, v in pairs(self.pandectQueueDef) do
		if v.message and v.commonFunc then
			SoraDAddMessage(self, v.message, v.commonFunc)
		end
	end
end
function pandectView:removeMessage()
	for k, v in pairs(self.pandectQueueDef) do
		if v.message then
			SoraDRemoveMessageFromTargetByName(self, v.message)
		end
	end
end
function pandectView:onItemRenderer(index, obj)
	obj:initData(self.singleArray[index + 1])
end
function pandectView:kingdomLevelUp()
	local cityltCtrl = include("cityltCtrl")
	local unlockLv = cityltCtrl.buildStarLvInfo(BUILDID.CASTLE, 1, BUILD_LVINFO.KINGDOMLV)
	local kingdomLevelDataModuleAPI = include("kingdomLevelDataModuleAPI")
	local kingdomLevel = kingdomLevelDataModuleAPI:getKingdomLevel()
	if kingdomLevel == unlockLv and self.queueInfo and self.queueInfo[gPandectType.build] == 2 and SoraDCheckIsOpenBuildStar() then
		self:initData()
	end
end
function pandectView:changeMainScene(target, data)
	if data.viewType == VIEW_TYPE_NONE or self.currentViewType == data.viewType then
		return
	end
	self.currentViewType = data.viewType
	if self.currentViewType == VIEW_TYPE_CITY and self.openStyle == 2 then
		self:addMessage()
		self:initData()
	end
end
function pandectView:initGlobalTimer()
	if not self.globalTimer and self.openStyle == 2 then
		self.globalTimer = SoradCreateTimer(self, handler(self, self.updatePandect))
		self:updatePandect(0)
	end
end
function pandectView:removeGlobalTimer()
	if self.globalTimer and self.openStyle == 1 then
		SoraDManagerRemoveTimer(self, self.globalTimer)
		self.globalTimer = nil
	end
end
function pandectView:updatePandect(dt)
	self.fields.List:setNumItems(#self.singleArray)
end
function pandectView:initData()
	if self.openStyle == 1 and not self.isFirst then
		return
	end
	local typeInfo = pandectRead.getTypeViewInfo()
	local castleLv = SoraDGetCastleLv()
	local nextLv = pandectRead.getFuncNextLevel(castleLv)
	local index = 1
	for k, v in ipairs(typeInfo) do
		local pandectRead, troop
		pandectRead = nil
		;(nil).data = v
		self.singleArray[index], (nil).sType = nil, 0
		local queueInfo = self.pandectQueueDef[v.type]
		index = index + 1
		local addQueueFunc = function(data, dataIndex, lv, isLastOne)
			if pandectRead.getIsShow(v.type, dataIndex, lv, nextLv) then
				pandectRead = dataIndex
				dataIndex.data = data
				dataIndex.sType = 1
				dataIndex.index = dataIndex
				dataIndex.queueInfo = queueInfo.queueList[dataIndex] or queueInfo.queueList[1]
				self.singleArray[index], dataIndex.isShowLine = dataIndex, isLastOne
			end
		end
		if v.type == gPandectType.march then
			local totalTroop = buildLogic.getExpQueueCount().total
			local troops = self:getRealTroops()
			local maxToopNum = math.max(totalTroop, table.nums(troops))
			local info = pandectRead.getListInfoByType(v.type)
			if info then
				for i = 1, maxToopNum do
					local data = clone(pandectRead.getListViewInfoByType(v.type)[1])
					addQueueFunc(data, i, castleLv, i == maxToopNum)
				end
			end
		elseif v.type == gPandectType.heroTrain then
			local totalTroop = heroTrainGroundCtrl:getTrainUnlockSiteNum()
			local info = pandectRead.getListInfoByType(v.type)
			if info and 0 < totalTroop then
				for i = 1, totalTroop do
					local data = clone(pandectRead.getListViewInfoByType(v.type)[1])
					addQueueFunc(data, i, castleLv, i == totalTroop)
				end
			end
		else
			do
				local info = pandectRead.getListViewInfoByType(v.type)
				local infoMax = #info
				if v.type == gPandectType.college and info[2] then
					local kingdomLevelDataModuleAPI = include("kingdomLevelDataModuleAPI")
					local isOpen = kingdomLevelDataModuleAPI:isOpen() or false
					info[2] = isOpen and info[2] or nil
				end
				if v.type == gPandectType.build and info[3] then
					if not SoraDCheckIsOpenBuildStar() then
						info[3] = nil
					end
					if info[3] == nil or not _G.SoraDGetCtrl("exaltedPrivilegeCtrl"):checkPrivilege(_G.gExaltedPrivilegeType.EXTRA_STAR_UPGRADE_QUEUENUM) then
						info[4] = nil
					end
				end
				if v.type == gPandectType.newbornTree then
					local beastCanyonCtrl = SoraDGetCtrl("beastCanyonCtrl")
					local activityID = gActivityTimeActivityID.DIVINE_BEAST_CANYON_ACTIVITY
					if not beastCanyonCtrl:checkActivityShow(activityID) then
						info[2] = nil
					end
					local activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001650
					if not beastCanyonCtrl:checkActivityShow(activityID) then
						info[3] = nil
						info[4] = nil
					end
				end
				for i = 1, infoMax do
					local queue = info[i]
					if queue then
						if v.type == gPandectType.arena or v.type == gPandectType.alliance then
							addQueueFunc(queue, i, 999)
						else
							addQueueFunc(queue, i, castleLv)
						end
					end
				end
			end
		end
	end
	self:checkUnlock()
	self.fields.List:setNumItems(#self.singleArray)
	self.isFirst = false
end
function pandectView:checkUnlock()
	local _ENV, ret
	for k, v in ipairs(self.singleArray) do
		if v.sType == 0 then
			local info = pandectRead.getListViewInfoByType(v.data.type)
			if 0 < table.nums(info) then
				table.insert(ret, v)
			end
		else
			table.insert(ret, v)
		end
	end
	self.singleArray = ret
end
function pandectView:handlEscort(target, data)
	local retData = data.data
	if retData.closestBuild == nil then
		return
	end
	local x = retData.closestBuild.x
	local y = retData.closestBuild.y
	if x ~= -1 and y ~= -1 then
		SoraDGotoWorldMapPoint(cc.p(x, y), true, worldMapDefine.currentMapKindomID)
	end
end
function pandectView:fixMass(queue)
	if not queue:isMainQueueFun() and queue:getStatus() == gMapMoveLineStatusType.moveLineStatusTypeWorking then
		return kingdomMapCtrl.kingdomMapCell:optMapEvent4Mass(queue)
	end
	return queue
end
function pandectView:getRealTroops()
	local troops = kingdomMapCtrl:getMapEventList()
	local kingdomMapCtrl, realTroops = kingdomMapCtrl, kingdomMapCtrl
	for _, v in pairs(troops) do
		local queue = self:fixMass(v)
		local remainTime = queue:getStatusRemainTime()
		local totalTime = queue:getOrgStatusTotalTime()
		if 0 < remainTime and 0 < totalTime or remainTime <= 0 and totalTime <= 0 then
			table.insert(realTroops, queue)
		end
	end
	return realTroops
end
function pandectView:initPandectDef()
	_ENV = nil
	_ENV = nil
	;(nil).message = "MESSAGE_UI_PANDECT_BUILDER"
	_ENV, _ENV, (nil).commonFunc = self, handler(self, self.initData), handler(self, self.initData)
	self.updateFunc = "setFreeBuildQueue"
	_ENV, self.queueType = gQueueTypeDef.free_build_queue, gQueueTypeDef.free_build_queue
	_ENV, handler(self, self.initData)[1], self.idleConfig, gQueueTypeDef.free_build_queue.handle = self, self, gQueueTypeDef.free_build_queue, function()
		buildLogic.builderIsLeisure()
	end
	self.updateFunc = "setRechargeBuildQueue"
	_ENV, self.queueType = gQueueTypeDef.charge_build_queue, gQueueTypeDef.charge_build_queue
	gQueueTypeDef.charge_build_queue.midText = i18n("common_text_3512")
	gQueueTypeDef.charge_build_queue.midColor = cc.c3b(115, 115, 115)
	gQueueTypeDef.charge_build_queue.btnTitle = i18n("common_text_843")
	gQueueTypeDef.charge_build_queue.status = 2
	_ENV, self.actConfig, gQueueTypeDef.charge_build_queue.handle = gQueueTypeDef.charge_build_queue, gQueueTypeDef.charge_build_queue, function()
		buildLogic.buyRechargeQueue()
	end
	_ENV, handler(self, self.initData)[2], self.idleConfig, gQueueTypeDef.charge_build_queue.handle = self, self, gQueueTypeDef.charge_build_queue, function()
		buildLogic.builderIsLeisure()
	end
	self.updateFunc = "setBuildStarQueue"
	_ENV, self.queueType = gQueueTypeDef.build_star_queue, gQueueTypeDef.build_star_queue
	_ENV, handler(self, self.initData)[3], self.idleConfig, gQueueTypeDef.build_star_queue.handle = self, self, gQueueTypeDef.build_star_queue, function()
		buildLogic.starBuilderIsLeisure()
	end
	self.updateFunc = "setBuildStarQueue"
	_ENV, self.queueType = gQueueTypeDef.build_star_queue_privilege, gQueueTypeDef.build_star_queue_privilege
	;(nil)[gPandectType.build], (nil).queueList, handler(self, self.initData)[4], self.idleConfig, gQueueTypeDef.build_star_queue_privilege.handle = nil, handler(self, self.initData), self, gQueueTypeDef.build_star_queue_privilege, function()
		buildLogic.starBuilderIsLeisure()
	end
	_ENV = nil
	;(nil).message = "MESSAGE_UI_PANDECT_ARMY"
	_ENV, _ENV, (nil).commonFunc = self, handler(self, self.initData), handler(self, self.initData)
	self.updateFunc = "setSoldierCampQueue"
	self.queueType = gQueueTypeDef.chariot_plant_queue
	_ENV, self.bid = BUILDID.CHARIOT_PLANT, BUILDID.CHARIOT_PLANT
	BUILDID.CHARIOT_PLANT.btnTitle = i18n("common_text_042")
	_ENV, self.lessConfig, BUILDID.CHARIOT_PLANT.handle = BUILDID.CHARIOT_PLANT, BUILDID.CHARIOT_PLANT, function()
		mildGuideManager = nil
		;(nil).bid = BUILDID.CHARIOT_PLANT
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.TRAIN_SOLDIERS, nil)
	end
	_ENV, handler(self, self.initData)[1], self.idleConfig, BUILDID.CHARIOT_PLANT.handle = self, self, BUILDID.CHARIOT_PLANT, function()
		mildGuideManager = nil
		;(nil).bid = BUILDID.CHARIOT_PLANT
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.TRAIN_SOLDIERS, nil)
	end
	self.updateFunc = "setSoldierCampQueue"
	self.queueType = gQueueTypeDef.stables_queue
	_ENV, self.bid = BUILDID.STABLES, BUILDID.STABLES
	BUILDID.STABLES.btnTitle = i18n("common_text_042")
	_ENV, self.lessConfig, BUILDID.STABLES.handle = BUILDID.STABLES, BUILDID.STABLES, function()
		mildGuideManager = nil
		;(nil).bid = BUILDID.STABLES
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.TRAIN_SOLDIERS, nil)
	end
	_ENV, handler(self, self.initData)[2], self.idleConfig, BUILDID.STABLES.handle = self, self, BUILDID.STABLES, function()
		mildGuideManager = nil
		;(nil).bid = BUILDID.STABLES
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.TRAIN_SOLDIERS, nil)
	end
	self.updateFunc = "setSoldierCampQueue"
	self.queueType = gQueueTypeDef.range_queue
	_ENV, self.bid = BUILDID.RANGE, BUILDID.RANGE
	BUILDID.RANGE.btnTitle = i18n("common_text_042")
	_ENV, self.lessConfig, BUILDID.RANGE.handle = BUILDID.RANGE, BUILDID.RANGE, function()
		mildGuideManager = nil
		;(nil).bid = BUILDID.RANGE
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.TRAIN_SOLDIERS, nil)
	end
	self.idleConfig, BUILDID.RANGE.handle = BUILDID.RANGE, function()
		mildGuideManager = nil
		;(nil).bid = BUILDID.RANGE
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.TRAIN_SOLDIERS, nil)
	end
	_ENV, handler(self, self.initData)[3], self.unlockLv = self, self, 3
	self.updateFunc = "setSoldierCampQueue"
	self.queueType = gQueueTypeDef.barracks_queue
	_ENV, self.bid = BUILDID.BARRACKS, BUILDID.BARRACKS
	BUILDID.BARRACKS.btnTitle = i18n("common_text_042")
	_ENV, self.lessConfig, BUILDID.BARRACKS.handle = BUILDID.BARRACKS, BUILDID.BARRACKS, function()
		mildGuideManager = nil
		;(nil).bid = BUILDID.BARRACKS
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.TRAIN_SOLDIERS, nil)
	end
	self.idleConfig, BUILDID.BARRACKS.handle = BUILDID.BARRACKS, function()
		mildGuideManager = nil
		;(nil).bid = BUILDID.BARRACKS
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.TRAIN_SOLDIERS, nil)
	end
	_ENV, handler(self, self.initData)[4], self.unlockLv = self, self, 4
	self.updateFunc = "setSoldierCampQueue"
	self.queueType = gQueueTypeDef.frotress_queue
	_ENV, self.bid = BUILDID.FORTRESS, BUILDID.FORTRESS
	BUILDID.FORTRESS.btnTitle = i18n("common_text_042")
	_ENV, self.lessConfig, BUILDID.FORTRESS.handle = BUILDID.FORTRESS, BUILDID.FORTRESS, function()
		mildGuideManager = nil
		;(nil).bid = BUILDID.FORTRESS
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.TRAIN_SOLDIERS, nil)
	end
	self.idleConfig, BUILDID.FORTRESS.handle = BUILDID.FORTRESS, function()
		mildGuideManager = nil
		;(nil).bid = BUILDID.FORTRESS
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.TRAIN_SOLDIERS, nil)
	end
	;(nil)[gPandectType.army], (nil).queueList, handler(self, self.initData)[5], self.unlockLv = nil, handler(self, self.initData), self, 4
	_ENV = nil
	;(nil).message = "MESSAGE_UI_PANDECT_COLLEGE"
	_ENV, _ENV, (nil).commonFunc = self, handler(self, self.initData), handler(self, self.initData)
	self.updateFunc = "setCollegeQueue"
	self.queueType = gQueueTypeDef.technology_upgrade_queue
	_ENV, self.bid = BUILDID.COLLEGE, BUILDID.COLLEGE
	BUILDID.COLLEGE.btnTitle = i18n("common_text_042")
	_ENV, self.lessConfig, BUILDID.COLLEGE.handle = BUILDID.COLLEGE, BUILDID.COLLEGE, function()
		mildGuideManager = nil
		;(nil).bid = BUILDID.COLLEGE
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.RESEARCH_TECHNOLOGY, nil)
	end
	self.idleConfig, BUILDID.COLLEGE.handle = BUILDID.COLLEGE, function()
		mildGuideManager = nil
		;(nil).bid = BUILDID.COLLEGE
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.RESEARCH_TECHNOLOGY, nil)
	end
	_ENV, handler(self, self.initData)[1], self.unlockLv = self, self, 2
	self.updateFunc = "setCollegeQueue"
	self.queueType = gQueueTypeDef.war_tech_research
	_ENV, self.bid = BUILDID.MIRACLE, BUILDID.MIRACLE
	BUILDID.MIRACLE.btnTitle = i18n("common_text_042")
	_ENV, self.lessConfig, BUILDID.MIRACLE.handle = BUILDID.MIRACLE, BUILDID.MIRACLE, function()
		mildGuideManager = nil
		;(nil).bid = BUILDID.MIRACLE
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.WAR_TECHNOLOGY, nil)
	end
	self.idleConfig, BUILDID.MIRACLE.handle = BUILDID.MIRACLE, function()
		mildGuideManager = nil
		;(nil).bid = BUILDID.MIRACLE
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.WAR_TECHNOLOGY, nil)
	end
	;(nil)[gPandectType.college], (nil).queueList, handler(self, self.initData)[2], self.unlockLv = nil, handler(self, self.initData), self, 30
	_ENV = nil
	;(nil).message = "MESSAGE_UI_PANDECT_ALCHEMY"
	_ENV, _ENV, (nil).commonFunc = self, handler(self, self.initData), handler(self, self.initData)
	self.updateFunc = "setWorkshopQueue"
	self.queueType = gQueueTypeDef.stuff_workshop
	_ENV, self.bid = BUILDID.MATERIAL_WORKSHOP, BUILDID.MATERIAL_WORKSHOP
	self.idleConfig, BUILDID.MATERIAL_WORKSHOP.handle = BUILDID.MATERIAL_WORKSHOP, function()
		mildGuideManager = nil
		;(nil).bid = BUILDID.MATERIAL_WORKSHOP
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.STUFFWORKSHOP, nil)
	end
	;(nil)[gPandectType.alchemy], (nil).queueList, handler(self, self.initData)[1], self.unlockLv = nil, handler(self, self.initData), self, 10
	_ENV = nil
	;(nil).message = "MESSAGE_UI_PANDECT_PET"
	_ENV, _ENV, (nil).commonFunc = self, handler(self, self.initData), handler(self, self.initData)
	self.updateFunc = "setPetQueue"
	_ENV, self.bid = cityBuildConstDef.fixedBuildDef.PetCenter, cityBuildConstDef.fixedBuildDef.PetCenter
	self.idleConfig, cityBuildConstDef.fixedBuildDef.PetCenter.handle = cityBuildConstDef.fixedBuildDef.PetCenter, function()
		mildGuideManager = nil
		;(nil).tipKey = "OpPet"
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.UNLOCK_PET, nil)
	end
	_ENV, handler(self, self.initData)[1], self.unlockLv = self, self, 4
	self.updateFunc = "setPetQueue"
	_ENV, self.bid = cityBuildConstDef.fixedBuildDef.PetCenter, cityBuildConstDef.fixedBuildDef.PetCenter
	self.idleConfig, cityBuildConstDef.fixedBuildDef.PetCenter.handle = cityBuildConstDef.fixedBuildDef.PetCenter, function()
		mildGuideManager = nil
		;(nil).tipKey = "OpPet"
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.UNLOCK_PET, nil)
	end
	;(nil)[gPandectType.pet], (nil).queueList, handler(self, self.initData)[2], self.unlockLv = nil, handler(self, self.initData), self, 4
	_ENV = nil
	;(nil).message = "MESSAGE_UI_PANDECT_MARCH"
	;(nil).commonFunc = handler(self, self.initData)
	_ENV, _ENV, (nil).isAuto = self, handler(self, self.initData), true
	_ENV, self.updateFunc = self.initData, "setMarchQueue"
	;(nil)[gPandectType.march], (nil).queueList, handler(self, self.initData)[1], self.idleConfig, self.initData.handle = nil, handler(self, self.initData), self, self.initData, function()
		mildGuideManager = nil
		mildGuideManager:starToQuickToWorld(nil)
	end
	_ENV = nil
	;(nil).message = "MESSAGE_UI_PANDECT_GOODS"
	_ENV, _ENV, (nil).commonFunc = self, handler(self, self.initData), handler(self, self.initData)
	self.updateFunc = "setGoodsQueue"
	_ENV, self.queueType = gQueueTypeDef.time_reward, gQueueTypeDef.time_reward
	;(nil)[gPandectType.goods], (nil).queueList, handler(self, self.initData)[1], self.idleConfig, gQueueTypeDef.time_reward.handle = nil, handler(self, self.initData), self, gQueueTypeDef.time_reward, function()
		mildGuideManager = nil
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.TIME_REWARD, nil)
	end
	_ENV = nil
	;(nil).message = "MESSAGE_UI_PANDECT_ALLIANCE"
	_ENV, _ENV, (nil).commonFunc = self, handler(self, self.initData), handler(self, self.initData)
	_ENV, self.updateFunc = self.initData, "setDonateQueue"
	_ENV, handler(self, self.initData)[1], self.idleConfig, self.initData.handle = self, self, self.initData, function()
		if GLOBAL_GAME_ALLIANCE_MODE then
			uiManager:show("AllianceScience")
		else
			SoraDCreatePanel("allianceScienceView"):show()
		end
	end
	_ENV, self.updateFunc = self.initData, "setTreasureQueue"
	_ENV, handler(self, self.initData)[2], self.idleConfig, self.initData.handle = self, self, self.initData, function()
		if not worldMapDefine.isInWarForbid(false, true) then
			if GLOBAL_GAME_ALLIANCE_MODE then
				uiManager:show("allianceStoreHouseView")
			else
				SoraDCreatePanel("allianceStoreHouseView"):show()
			end
		end
	end
	_ENV, self.updateFunc = self.initData, "setTreasureHelpQueue"
	;(nil)[gPandectType.alliance], (nil).queueList, handler(self, self.initData)[3], self.idleConfig, self.initData.handle = nil, handler(self, self.initData), self, self.initData, function()
		if GLOBAL_GAME_ALLIANCE_MODE then
			_ENV = nil
			;(nil).tag = 3
			uiManager:show("allianceStoreHouseView", nil)
		else
			local panel = SoraDCreatePanel("allianceStoreHouseView")
			panel:gotoBtn(3)
			panel:show()
		end
	end
	_ENV = nil
	;(nil).message = "MESSAGE_UI_PANDECT_POOL"
	_ENV, _ENV, (nil).commonFunc = self, handler(self, self.initData), handler(self, self.initData)
	self.updateFunc = "setWishQueue"
	self.bid = BUILDID.WISHING_WELL
	_ENV, self.unlockLv = BUILDID.WISHING_WELL, 7
	BUILDID.WISHING_WELL.btnTitle = i18n("common_text_042")
	_ENV, self.lessConfig, BUILDID.WISHING_WELL.handle = BUILDID.WISHING_WELL, BUILDID.WISHING_WELL, function()
		mildGuideManager = nil
		;(nil).bid = BUILDID.WISHING_WELL
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.MAKE_A_WISH, nil)
	end
	_ENV, handler(self, self.initData)[1], self.idleConfig, BUILDID.WISHING_WELL.handle = self, self, BUILDID.WISHING_WELL, function()
		mildGuideManager = nil
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.MAKE_A_WISH, nil)
	end
	self.updateFunc = "setWishTreasure"
	self.bid = BUILDID.WISHING_WELL
	self.queueType = gQueueTypeDef.endless_treasure_queue
	_ENV, self.unlockLv = gQueueTypeDef.endless_treasure_queue, 7
	gQueueTypeDef.endless_treasure_queue.btnTitle = i18n("common_text_042")
	_ENV, self.lessConfig, gQueueTypeDef.endless_treasure_queue.handle = gQueueTypeDef.endless_treasure_queue, gQueueTypeDef.endless_treasure_queue, function()
		mildGuideManager = nil
		;(nil).bid = BUILDID.WISHING_WELL
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.ENDLESS_TREASURE, nil)
	end
	;(nil)[gPandectType.pool], (nil).queueList, handler(self, self.initData)[2], self.idleConfig, gQueueTypeDef.endless_treasure_queue.handle = nil, handler(self, self.initData), self, gQueueTypeDef.endless_treasure_queue, function()
		mildGuideManager = nil
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.ENDLESS_TREASURE, nil)
	end
	_ENV = nil
	;(nil).message = "MESSAGE_UI_PANDECT_CAR"
	_ENV, _ENV, (nil).commonFunc = self, handler(self, self.initData), handler(self, self.initData)
	self.updateFunc = "setEscortQueue"
	_ENV, self.unlockLv = self.initData, 12
	_ENV, handler(self, self.initData)[1], self.idleConfig, self.initData.handle = self, self, self.initData, function()
		escortCtrl:reqGetClosestBuild()
	end
	self.updateFunc = "setRobQueue"
	_ENV, self.unlockLv = self.initData, 12
	;(nil)[gPandectType.car], (nil).queueList, handler(self, self.initData)[2], self.idleConfig, self.initData.handle = nil, handler(self, self.initData), self, self.initData, function()
		escortCtrl:reqGetClosestBuild()
	end
	_ENV = nil
	;(nil).message = "MESSAGE_UI_PANDECT_PYRAMID"
	_ENV, _ENV, (nil).commonFunc = self, handler(self, self.initData), handler(self, self.initData)
	self.updateFunc = "setPyramidQueue"
	self.bid = cityBuildConstDef.fixedBuildDef.LeisureCenter
	_ENV, self.unlockLv = cityBuildConstDef.fixedBuildDef.LeisureCenter, 8
	;(nil)[gPandectType.pyramid], (nil).queueList, handler(self, self.initData)[1], self.idleConfig, cityBuildConstDef.fixedBuildDef.LeisureCenter.handle = nil, handler(self, self.initData), self, cityBuildConstDef.fixedBuildDef.LeisureCenter, function()
		mildGuideManager = nil
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.PYRAMID, nil)
	end
	_ENV = nil
	;(nil).message = "MESSAGE_UI_PANDECT_TRIAL"
	_ENV, _ENV, (nil).commonFunc = self, handler(self, self.initData), handler(self, self.initData)
	self.updateFunc = "setTrialQueue"
	self.queueType = gQueueTypeDef.trial_march
	_ENV, self.unlockLv = gQueueTypeDef.trial_march, 9
	;(nil)[gPandectType.heroTrial], (nil).queueList, handler(self, self.initData)[1], self.idleConfig, gQueueTypeDef.trial_march.handle = nil, handler(self, self.initData), self, gQueueTypeDef.trial_march, function()
		mildGuideManager = nil
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.HERO_TRIAL, nil)
	end
	_ENV, _ENV, _ENV = self, (handler(self, self.initData))
	self.updateFunc = "setEpicWarQueue"
	_ENV, self.unlockLv = gQueueTypeDef.trial_march, 8
	;(nil)[gPandectType.epicwar], (nil).queueList, handler(self, self.initData)[1], self.idleConfig, gQueueTypeDef.trial_march.handle = nil, handler(self, self.initData), self, gQueueTypeDef.trial_march, function()
		mildGuideManager = nil
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.EPIC_WAR, nil)
	end
	_ENV = nil
	;(nil).message = "MESSAGE_UI_PANDECT_ARENA"
	_ENV, _ENV, (nil).commonFunc = self, handler(self, self.initData), handler(self, self.initData)
	self.updateFunc = "setArenaQueue"
	self.bid = BUILDID.DRILL_GROUDS
	_ENV, self.unlockLv = BUILDID.DRILL_GROUDS, 16
	BUILDID.DRILL_GROUDS.btnTitle = i18n("common_text_042")
	_ENV, self.lessConfig, BUILDID.DRILL_GROUDS.handle = BUILDID.DRILL_GROUDS, BUILDID.DRILL_GROUDS, function()
		mildGuideManager = nil
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.DRILL_ARENA, nil)
	end
	;(nil)[gPandectType.arena], (nil).queueList, handler(self, self.initData)[1], self.idleConfig, BUILDID.DRILL_GROUDS.handle = nil, handler(self, self.initData), self, BUILDID.DRILL_GROUDS, function()
		mildGuideManager = nil
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.DRILL_ARENA, nil)
	end
	_ENV = nil
	;(nil).message = "MESSAGE_UI_PANDECT_HEROTRAIN"
	;(nil).commonFunc = handler(self, self.initData)
	_ENV, _ENV, (nil).isAuto = self, handler(self, self.initData), true
	_ENV, self.updateFunc = self.initData, "setHeroTrainQueue"
	;(nil)[gPandectType.heroTrain], (nil).queueList, handler(self, self.initData)[1], self.idleConfig, self.initData.handle = nil, handler(self, self.initData), self, self.initData, function()
		if worldMapDefine.isInRadiance() then
			SoraDShowMsgTip(i18n("common_text_3302"))
		else
			worldMapDefine = i18n("common_text_3302")
			mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.HERO_TRAIN, i18n("common_text_3302"))
		end
	end
	_ENV = nil
	;(nil).message = "MESSAGE_UPDATE_MASTERY_DRAWING_VIEW"
	_ENV, _ENV, (nil).commonFunc = self, handler(self, self.initData), handler(self, self.initData)
	self.updateFunc = "setMasteryQueue"
	_ENV, self.queueType = gQueueTypeDef.build_mastery, gQueueTypeDef.build_mastery
	_ENV, handler(self, self.initData)[1], self.idleConfig, gQueueTypeDef.build_mastery.handle = self, self, gQueueTypeDef.build_mastery, function()
		mildGuideManager = nil
		;(nil).bid = cityBuildConstDef.buildIndexDef.index_Mastery
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.BUILD_MASTERY, nil)
	end
	self.updateFunc = "setMasteryDrawQueue"
	_ENV, self.queueType = gQueueTypeDef.construction_drawing, gQueueTypeDef.construction_drawing
	;(nil)[gPandectType.masteryDraw], (nil).queueList, handler(self, self.initData)[2], self.idleConfig, gQueueTypeDef.construction_drawing.handle = nil, handler(self, self.initData), self, gQueueTypeDef.construction_drawing, function()
		mildGuideManager = nil
		;(nil).bid = cityBuildConstDef.buildIndexDef.index_Mastery
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.MASTERY_DRAW, nil)
	end
	_ENV = nil
	;(nil).message = "MESSAGE_UI_PANDECT_NEWBRONTREE"
	;(nil).commonFunc = handler(self, self.initData)
	_ENV, _ENV, (nil).isAuto = self, handler(self, self.initData), true
	_ENV, self.updateFunc = self.initData, "setNewbornTreeBeastQueue"
	_ENV, handler(self, self.initData)[1], self.idleConfig, self.initData.handle = self, self, self.initData, function()
		mildGuideManager = nil
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.TO_DIVINEBEAST, nil)
	end
	_ENV, self.updateFunc = self.initData, "setNewbornTree9001547Queue"
	_ENV, handler(self, self.initData)[2], self.idleConfig, self.initData.handle = self, self, self.initData, function()
		mildGuideManager = nil
		;(nil).key = BOP_NAME.BOP_NEWBORN_BEAST_CANYON
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.TO_9001547, nil)
	end
	_ENV, self.updateFunc = self.initData, "setNewbornTree9001650Queue"
	_ENV, handler(self, self.initData)[3], self.idleConfig, self.initData.handle = self, self, self.initData, function()
		mildGuideManager = nil
		;(nil).key = BOP_NAME.BOP_NEWBORN_ELITEBEAST_CANYON
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.TO_9001547, nil)
	end
	_ENV, self.updateFunc = self.initData, "setNewbornTree9001650Exchange"
	self.pandectQueueDef, (nil)[gPandectType.newbornTree], (nil).queueList, handler(self, self.initData)[4], self.idleConfig, self.initData.handle = nil, nil, handler(self, self.initData), self, self.initData, function()
		mildGuideManager = nil
		;(nil).key = BOP_NAME.BOP_EXCHANGE_9001650
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.TO_9001547, nil)
	end
end
function pandectView:btnClickCallBack(button, event)
	if self.openStyle == 1 then
		SoraDPlaySound("uicontrol", 10)
		self:openSelf()
		_ENV = "0000"
		userSDKManager.logEvent(gSDKDef.TDonEvent.click_pandect_view .. "0000", "0000")
	else
		SoraDPlaySound("uicontrol", 11)
		self:closeSelf()
		_ENV = "0001"
		userSDKManager.logEvent(gSDKDef.TDonEvent.click_pandect_view .. "0001", "0001")
	end
end
function pandectView:emptyClose()
	SoraDPlaySound("uicontrol", 11)
	self:closeSelf()
end
function pandectView:openSelf()
	if self.openStyle == 1 then
		self.fields.Button_pandect:setTouchEnabled(false)
		self.fields.Button_pandect:setFlipped(true)
		_UPVALUE1_ = self.fields.Button_pandect
		self.fields.Button_pandect[1] = ffa.exponentialOut(ffa.moveTo(0.5, self.oriPosX - self.moveX, self.fields.Panel_black:getPositionY()))
		self.fields.Button_pandect[2] = ffa.callFunc(function()
			self.openStyle = 2
			self.fields.Button_pandect:setTouchEnabled(true)
			self.fields.touch:setTouchEnabled(true)
			self.fields.List:setVisible(true)
			if self.currentViewType == VIEW_TYPE_CITY then
				self:addMessage()
				self:initData()
			end
			self:initGlobalTimer()
		end)
		self.fields.Button_pandect[3] = ffa.callFunc(function()
			self.openStyle = 2
			self.fields.Button_pandect:setTouchEnabled(true)
			self.fields.touch:setTouchEnabled(true)
			self.fields.List:setVisible(true)
			if self.currentViewType == VIEW_TYPE_CITY then
				self:addMessage()
				self:initData()
			end
			self:initGlobalTimer()
		end)
		self.fields.Button_pandect[4] = ffa.callFunc(function()
			self.openStyle = 2
			self.fields.Button_pandect:setTouchEnabled(true)
			self.fields.touch:setTouchEnabled(true)
			self.fields.List:setVisible(true)
			if self.currentViewType == VIEW_TYPE_CITY then
				self:addMessage()
				self:initData()
			end
			self:initGlobalTimer()
		end)
		self.fields.Button_pandect[5] = ffa.callFunc(function()
			self.openStyle = 2
			self.fields.Button_pandect:setTouchEnabled(true)
			self.fields.touch:setTouchEnabled(true)
			self.fields.List:setVisible(true)
			if self.currentViewType == VIEW_TYPE_CITY then
				self:addMessage()
				self:initData()
			end
			self:initGlobalTimer()
		end)
		self.fields.Button_pandect[6] = ffa.callFunc(function()
			self.openStyle = 2
			self.fields.Button_pandect:setTouchEnabled(true)
			self.fields.touch:setTouchEnabled(true)
			self.fields.List:setVisible(true)
			if self.currentViewType == VIEW_TYPE_CITY then
				self:addMessage()
				self:initData()
			end
			self:initGlobalTimer()
		end)
		local seq = ffa.spawn(self.fields.Button_pandect)
		self.fields.Panel_black:runAction(seq)
	end
end
function pandectView:closeSelf(isForce)
	if self.openStyle == 2 then
		self.openStyle = 1
		self:removeMessage()
		if isForce then
			self.fields.Panel_black:setPositionX(self.oriPosX)
			self.fields.Button_pandect:setFlipped(false)
			self.fields.Button_pandect:setTouchEnabled(true)
			self.fields.touch:setTouchEnabled(false)
			self:removeGlobalTimer()
		else
			self.fields.Button_pandect:setTouchEnabled(false)
			self.fields.Button_pandect:setFlipped(false)
			_UPVALUE1_ = self.fields.Button_pandect
			self.fields.Button_pandect[1] = ffa.exponentialOut(ffa.moveTo(0.5, self.oriPosX, self.fields.Panel_black:getPositionY()))
			self.fields.Button_pandect[2] = ffa.callFunc(function()
				self.fields.Button_pandect:setTouchEnabled(true)
				self.fields.touch:setTouchEnabled(false)
				self.fields.List:setVisible(false)
				self:removeGlobalTimer()
			end)
			self.fields.Button_pandect[3] = ffa.callFunc(function()
				self.fields.Button_pandect:setTouchEnabled(true)
				self.fields.touch:setTouchEnabled(false)
				self.fields.List:setVisible(false)
				self:removeGlobalTimer()
			end)
			self.fields.Button_pandect[4] = ffa.callFunc(function()
				self.fields.Button_pandect:setTouchEnabled(true)
				self.fields.touch:setTouchEnabled(false)
				self.fields.List:setVisible(false)
				self:removeGlobalTimer()
			end)
			self.fields.Button_pandect[5] = ffa.callFunc(function()
				self.fields.Button_pandect:setTouchEnabled(true)
				self.fields.touch:setTouchEnabled(false)
				self.fields.List:setVisible(false)
				self:removeGlobalTimer()
			end)
			self.fields.Button_pandect[6] = ffa.callFunc(function()
				self.fields.Button_pandect:setTouchEnabled(true)
				self.fields.touch:setTouchEnabled(false)
				self.fields.List:setVisible(false)
				self:removeGlobalTimer()
			end)
			local seq = ffa.spawn(self.fields.Button_pandect)
			self.fields.Panel_black:runAction(seq)
		end
	end
end
function pandectView:onHide()
	self:removeGlobalTimer()
end
function pandectView:getBtnPandect()
	return self.fields.Button_pandect
end
function pandectView:getList()
	return self.fields.List
end
function pandectView:runFingerAction()
	self.fields.spriteHand:setVisible(true)
	self.fields.spriteHand:setPositionY(self.handY)
	_UPVALUE11_ = self.fields.spriteHand
	self.fields.spriteHand[1] = ffa.scaleTo(0.1, 1.2)
	self.fields.spriteHand[2] = ffa.scaleTo(0.1, 1)
	self.fields.spriteHand[3] = ffa.delay(0.2)
	self.fields.spriteHand[4] = ffa.moveBy(0.5, 0, -100)
	self.fields.spriteHand[5] = ffa.delay(0.5)
	self.fields.spriteHand[6] = ffa.callFunc(function()
		self.fields.spriteHand:setPositionY(self.handY)
	end)
	self.fields.spriteHand[7] = ffa.scaleTo(0.1, 1.2)
	self.fields.spriteHand[8] = ffa.scaleTo(0.1, 1)
	self.fields.spriteHand[9] = ffa.delay(0.2)
	self.fields.spriteHand[10] = ffa.moveBy(0.5, 0, -100)
	self.fields.spriteHand[11] = ffa.delay(0.2)
	self.fields.spriteHand[12] = ffa.callFunc(function()
		self.fields.spriteHand:stopAllActions()
		self.fields.spriteHand:setPositionY(self.handY)
		self.fields.spriteHand:setVisible(false)
	end)
	self.fields.spriteHand[13] = ffa.callFunc(function()
		self.fields.spriteHand:stopAllActions()
		self.fields.spriteHand:setPositionY(self.handY)
		self.fields.spriteHand:setVisible(false)
	end)
	local act = ffa.seq(self.fields.spriteHand)
	self.fields.spriteHand:runAction(act)
end
return pandectView
