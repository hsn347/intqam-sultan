local queueCtrl = SoraDGetCtrl("queueCtrl")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local luckyBlessCtrl = SoraDGetCtrl("luckyBlessCtrl")
local buildRead = include("buildDescribeRead")
local buildLogic = include("buildLogic")
local collegeDesRead = include("collegeDesRead")
local resDesRead = include("resDesRead")
local itemDesRead = include("itemDesRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local collegeDetailsSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CollegeView/collegeDetailsSingle", collegeDetailsSingle)
function collegeDetailsSingle:onInit()
	self.singleType = TECHNOLOGY_SINGLE_TYPE.BUILD
	self.tabelSingelData, _ENV, self.queueType = gQueueTypeDef.technology_upgrade_queue, gQueueTypeDef.technology_upgrade_queue, gQueueTypeDef.technology_upgrade_queue
	self.needResList, _ENV, self.queue = gQueueTypeDef.technology_upgrade_queue, gQueueTypeDef.technology_upgrade_queue, nil
	self.timer = nil
	self.fields.Button_jump:addClickListener(handler(self, self.btnClickCallBack))
	local Text_time = self.fields.Text_time:getChild("title")
	Text_time:setAutoSize(fgui.AutoSizeType.SHRINK)
	Text_time:setSize(cc.size(320, 40))
	Text_time:setAlign(SoraDFLabelR())
	self:fixChildrenPos()
end
function collegeDetailsSingle:onShow()
end
function collegeDetailsSingle:initData(data, techType)
	SoraDRemoveMessageFromTargetByName(self, "MESSAGE_RESOURCE_UPDATE")
	self.techType = techType
	self.queueType = data.queueType or gQueueTypeDef.technology_upgrade_queue
	self.singleType = data.singleType
	self.tabelSingelData = data.data
	if data.resNeedList then
		self.needResList = data.resNeedList
	end
	self.luckyBlessIsOpen = data.luckyBlessIsOpen or false
	self:updateView()
end
function collegeDetailsSingle:updateView()
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
	if self.singleType == TECHNOLOGY_SINGLE_TYPE.BUILD then
		self:showBuild()
		self.fields.Button_jump:setString(i18n("common_text_477"))
	elseif self.singleType == TECHNOLOGY_SINGLE_TYPE.TECHNOLOGY then
		self:showTechnology()
		self.fields.Button_jump:setString(i18n("common_text_062"))
	elseif self.singleType == TECHNOLOGY_SINGLE_TYPE.QUEUE then
		self.queue = queueCtrl:queryQueue(self.queueType)
		self:showQueue()
		self.fields.Button_jump:setString(i18n("common_text_018"))
	elseif self.singleType == TECHNOLOGY_SINGLE_TYPE.RES then
		self:showRes()
		self.fields.Button_jump:setString(i18n("common_text_337"))
	elseif self.singleType == TECHNOLOGY_SINGLE_TYPE.WAR then
		self:showWEs()
		self.fields.Button_jump:setString(i18n("common_text_337"))
	elseif self.singleType == TECHNOLOGY_SINGLE_TYPE.STAR then
		self:showStarBuild()
		self.fields.Button_jump:setString(i18n("common_text_477"))
	end
	self:updateState(self.tabelSingelData.isContentmented or self.tabelSingelData.isLuckyContentmented)
end
function collegeDetailsSingle:showQueue()
	self.controllers.c1:setSelectedIndex(0)
	self.fields.Text_time:setTimeLast(function(strTime)
		_ENV = nil
		;(nil).name = collegeDesRead.getName(self.tabelSingelData.technologyID)
		;(nil).time = strTime
		return i18n("common_text_338", nil)
	end)
	self.fields.Text_time:beginTime(self.queue.timerNode.timer:getRemainTime())
end
function collegeDetailsSingle:showBuild()
	self.controllers.c1:setSelectedIndex(1)
	self.fields.icon:setSpriteFrame(buildRead.getIcon(self.tabelSingelData.bid))
	local minLv = 1
	if BUILDID.MIRACLE == self.tabelSingelData.bid then
		minLv = 0
	end
	local warLv = buildLogic.transformBuildLvToWarLv(self.tabelSingelData.consumeLevel)
	if minLv <= warLv then
		buildRead = buildRead.getIcon(self.tabelSingelData.bid)
		buildRead.getIcon(self.tabelSingelData.bid).build = buildRead.getName(self.tabelSingelData.bid)
		buildRead.getIcon(self.tabelSingelData.bid).lv = warLv
		self.fields.Text_build:setString(i18n("common_text_1957", buildRead.getIcon(self.tabelSingelData.bid)))
	else
		buildRead = i18n("common_text_1957", buildRead.getIcon(self.tabelSingelData.bid))
		i18n("common_text_1957", buildRead.getIcon(self.tabelSingelData.bid)).name = buildRead.getName(self.tabelSingelData.bid)
		i18n("common_text_1957", buildRead.getIcon(self.tabelSingelData.bid)).lv = self.tabelSingelData.consumeLevel
		self.fields.Text_build:setString(i18n("common_text_334", i18n("common_text_1957", buildRead.getIcon(self.tabelSingelData.bid))))
	end
end
function collegeDetailsSingle:showTechnology()
	self.controllers.c1:setSelectedIndex(2)
	if self.queueType == gQueueTypeDef.war_tech_research then
		_ENV = nil
		;(nil).name = collegeDesRead.getName(self.tabelSingelData.tid)
		;(nil).level = self.tabelSingelData.consumeLevel
		self.fields.Text_build:setString(i18n("common_text_3908", nil))
	else
		_ENV = i18n("common_text_3908", nil)
		i18n("common_text_3908", nil).science = collegeDesRead.getName(self.tabelSingelData.tid)
		i18n("common_text_3908", nil).lv = self.tabelSingelData.consumeLevel
		self.fields.Text_build:setString(i18n("common_text_336", i18n("common_text_3908", nil)))
	end
end
function collegeDetailsSingle:showWEs()
	self.controllers.c1:setSelectedIndex(3)
	self.fields.icon:setSpriteFrame(itemDesRead.getIcon(self.tabelSingelData.rid))
	self.fields.title:setString(itemDesRead.getName(self.tabelSingelData.rid) .. "   " .. tostring(self.tabelSingelData.currentResource) .. "/" .. self.tabelSingelData.consumeResource)
end
function collegeDetailsSingle:showRes()
	self.controllers.c1:setSelectedIndex(4)
	self.fields.icon:setSpriteFrame(resDesRead.getIcon(self.tabelSingelData.rid))
	local curRes = cityCtrl:getResCount(self.tabelSingelData.rid)
	if BUILD_STAR_COSTITEM[self.tabelSingelData.rid] then
		curRes = backpackCtrl:getItemCount(self.tabelSingelData.rid)
	end
	if self.luckyBlessIsOpen then
		self.fields.Text_need:setVisible(true)
		self.fields.Image_luckLine:setVisible(true)
		self.fields.Text_lucky:setVisible(true)
		self.fields.title:setString(SoraDFIsRA() and "/" .. string.formatnumberthousands(curRes) or string.formatnumberthousands(curRes) .. "/")
		self.fields.Text_need:setString(string.formatnumberthousands(self.tabelSingelData.consumeResource))
		local luckyResCount = luckyBlessCtrl:getResult(self.tabelSingelData.consumeResource)
		self.fields.Text_lucky:setString(string.formatnumberthousands(luckyResCount))
		if SoraDFIsRA() then
			self.fields.Image_luckLine:setPositionX(self.fields.Text_need:getPositionX() - self.fields.Text_need:getWidth() / 2)
		else
			self.fields.Image_luckLine:setPositionX(self.fields.Text_need:getPositionX() + self.fields.Text_need:getWidth() / 2)
		end
	else
		self.fields.Text_need:setVisible(false)
		self.fields.Image_luckLine:setVisible(false)
		self.fields.Text_lucky:setVisible(false)
		if SoraDFIsRA() then
			self.fields.title:setString(string.formatnumberthousands(self.tabelSingelData.consumeResource) .. "/" .. string.formatnumberthousands(curRes))
		else
			self.fields.title:setString(string.formatnumberthousands(curRes) .. "/" .. string.formatnumberthousands(self.tabelSingelData.consumeResource))
		end
	end
	if self.tabelSingelData.rid == gIDDef.FOOD then
		self:openResTimeUp()
		self.timer = SoradCreateTimer(self, handler(self, self.openResTimeUp))
	elseif not SorDIsMessageAddByTarget(self, "MESSAGE_RESOURCE_UPDATE") then
		SoraDAddMessage(self, "MESSAGE_RESOURCE_UPDATE", handler(self, self.openResTimeUp))
	end
end
function collegeDetailsSingle:showStarBuild()
	self.controllers.c1:setSelectedIndex(1)
	self.fields.icon:setSpriteFrame(buildRead.getIcon(self.tabelSingelData.bid))
	if self.tabelSingelData.bid == BUILDID.STAR_BRAVE_STATUE then
		local cityltCtrl = include("cityltCtrl")
		self.fields.Text_build:setString(cityltCtrl.getStarBraveStatueLvStr(self.tabelSingelData.consumeLevel))
	else
		buildRead = cityltCtrl.getStarBraveStatueLvStr(self.tabelSingelData.consumeLevel)
		cityltCtrl.getStarBraveStatueLvStr(self.tabelSingelData.consumeLevel).n = buildRead.getName(self.tabelSingelData.bid)
		buildRead = cityltCtrl.getStarBraveStatueLvStr(self.tabelSingelData.consumeLevel)
		cityltCtrl.getStarBraveStatueLvStr(self.tabelSingelData.consumeLevel).lv = self.tabelSingelData.consumeLevel
		cityltCtrl.getStarBraveStatueLvStr(self.tabelSingelData.consumeLevel).c = i18n("Glory_text_24", cityltCtrl.getStarBraveStatueLvStr(self.tabelSingelData.consumeLevel))
		self.fields.Text_build:setString(i18n("common_text_2358", cityltCtrl.getStarBraveStatueLvStr(self.tabelSingelData.consumeLevel)))
	end
end
function collegeDetailsSingle:openResTimeUp(dt)
	local curRes = cityCtrl:getResCount(self.tabelSingelData.rid)
	if BUILD_STAR_COSTITEM[self.tabelSingelData.rid] or self.tabelSingelData.rid == gNebulaPalaceItemID then
		curRes = backpackCtrl:getItemCount(self.tabelSingelData.rid)
	end
	local consumeResource = self.tabelSingelData.consumeResource
	if self.luckyBlessIsOpen then
		self.fields.title:setString(SoraDFIsRA() and "/" .. string.formatnumberthousands(curRes) or string.formatnumberthousands(curRes) .. "/")
		self.fields.Text_need:setString(string.formatnumberthousands(self.tabelSingelData.consumeResource))
		local luckyResCount = luckyBlessCtrl:getResult(self.tabelSingelData.consumeResource)
		consumeResource = luckyResCount
		self.fields.Text_lucky:setString(string.formatnumberthousands(luckyResCount))
		if SoraDFIsRA() then
			self.fields.Image_luckLine:setPositionX(self.fields.Text_need:getPositionX() - self.fields.Text_need:getWidth() / 2)
		else
			self.fields.Image_luckLine:setPositionX(self.fields.Text_need:getPositionX() + self.fields.Text_need:getWidth() / 2)
		end
	elseif SoraDFIsRA() then
		self.fields.title:setString(string.formatnumberthousands(self.tabelSingelData.consumeResource) .. "/" .. string.formatnumberthousands(curRes))
	else
		self.fields.title:setString(string.formatnumberthousands(curRes) .. "/" .. string.formatnumberthousands(self.tabelSingelData.consumeResource))
	end
	self:updateState(curRes >= consumeResource)
end
function collegeDetailsSingle:updateState(isContentmented)
	local labelColor = cc.c3b(224, 43, 43)
	if isContentmented then
		labelColor = cc.c3b(240, 230, 210)
	end
	self.fields.Button_jump:setVisible(not isContentmented)
	self.fields.nYes:setVisible(isContentmented)
	self.fields.nNo:setVisible(not isContentmented)
	self.fields.Text_need:setColor(labelColor)
	self.fields.title:setColor(labelColor)
	self.fields.Text_build:setColor(labelColor)
	if self.tabelSingelData.isContentmented ~= isContentmented then
		return false
	else
		return true
	end
end
function collegeDetailsSingle:btnClickCallBack()
	SoraDPlaySound()
	if self.singleType == TECHNOLOGY_SINGLE_TYPE.QUEUE then
		local speedUpType = gAbbrSpeedUpType.TECH
		if self.queueType == gQueueTypeDef.craft_study then
			speedUpType = gAbbrSpeedUpType.craft_study
		end
		local itemList = backpackCtrl:getSpeedUpItemList(speedUpType)
		if next(itemList) ~= nil then
			SoraDShowSpeedUpByItemBox(tonumber(self.queueType))
		else
			SoraDShowSpeedUpBox(self.queue, nil, i18n("common_text_706"))
		end
	elseif self.singleType == TECHNOLOGY_SINGLE_TYPE.RES then
		_ENV = self.queue
		self.queue.rid = self.tabelSingelData.rid
		self.queue.needResData = self.needResList
		uiManager:show("resourceBuyView", self.queue)
	elseif self.singleType == TECHNOLOGY_SINGLE_TYPE.WAR then
		if BUILD_STAR_COSTITEM[self.tabelSingelData.rid] then
			SoraDShowMsgTip(i18n("Glory_text_55"))
			return
		end
		if self.tabelSingelData.rid == gNebulaPalaceItemID then
			local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
			local curState = activityShowCtrl:getStateByID(gActivityTimeActivityID.SHIFTING_STARS_ACTIVITY)
			if curState == gActivityState.OPEN then
				uiManager:show("Shiftingstars")
				return
			end
			SoraDShowMsgTip(i18n("nebula_war_text_0178"))
			return
		end
		local isOpen, lv = SoraDGetCtrl("badgeExchangeCtrl"):isOpenBadge()
		if not isOpen then
			_ENV = i18n("nebula_war_text_0178")
			i18n("nebula_war_text_0178").blv = lv
			SoraDShowMsgTip(i18n("common_text_1151", i18n("nebula_war_text_0178")))
		else
			_ENV = i18n("common_text_1151", i18n("nebula_war_text_0178"))
			i18n("common_text_1151", i18n("nebula_war_text_0178")).targetID = self.tabelSingelData.rid
			uiManager:show("badgeBourseView", i18n("common_text_1151", i18n("nebula_war_text_0178")))
		end
	elseif self.singleType == TECHNOLOGY_SINGLE_TYPE.BUILD then
		if not SoraDCurrentSceneShowView("mainCityView") then
			local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
			_ENV = "badgeBourseView"
			;("badgeBourseView").bid = BUILDID.COLLEGE
			;("badgeBourseView").lv = self.tabelSingelData.consumeLevel
			mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.BUILD_UPGRADE, "badgeBourseView")
			SoraDRemoveAllPanelFromManager()
			return
		end
		local lv, iid = cityCtrl:getBuildMaxLv(self.tabelSingelData.bid)
		local cityBuildMgr = include("cityBuildMgr")
		local buildEntity = cityBuildMgr:getBuildByBid(tonumber(self.tabelSingelData.bid), iid)
		local mainCityFunctions = include("mainCityFunctions")
		local buildIndex = mainCityFunctions.getBuildIndexByBid(self.tabelSingelData.bid, iid)
		_ENV = self.tabelSingelData.bid
		self.tabelSingelData.bid.bid = self.tabelSingelData.bid
		self.tabelSingelData.bid.iid = iid
		self.tabelSingelData.bid.buildEntity = buildEntity
		local self.tabelSingelData.bid.index, buildInfo = buildIndex, self.tabelSingelData.bid
		SoraDRemoveAllPanelFromManager()
		_ENV = i18n("common_text_1151", i18n("nebula_war_text_0178"))
		i18n("common_text_1151", i18n("nebula_war_text_0178")).upgradeData = buildInfo
		uiManager:show("BuildCreateInfo", i18n("common_text_1151", i18n("nebula_war_text_0178")))
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
		uiManager.offsetType = MAINCITYVIEW_OFFSET_TYPE_BUILD
		uiManager.buildIndex = buildIndex
		SoraDSendMessage(uiManager)
		_ENV = uiManager
		uiManager.msg = "MESSAGE_MAINCITYVIEW_REMOVE_BUILD_TIP"
		SoraDSendMessage(uiManager)
	elseif self.singleType == TECHNOLOGY_SINGLE_TYPE.TECHNOLOGY then
		_ENV = cityBuildMgr:getBuildByBid(tonumber(self.tabelSingelData.bid), iid)
		cityBuildMgr:getBuildByBid(tonumber(self.tabelSingelData.bid), iid).techID = self.tabelSingelData.tid
		cityBuildMgr:getBuildByBid(tonumber(self.tabelSingelData.bid), iid).techType = self.techType
		uiManager:show("collegeDetailsView", (cityBuildMgr:getBuildByBid(tonumber(self.tabelSingelData.bid), iid)))
	elseif self.singleType == TECHNOLOGY_SINGLE_TYPE.STAR then
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		if BUILDID.STAR_BRAVE_STATUE == self.tabelSingelData.bid then
			local cityBuildMgr = include("cityBuildMgr")
			local cityBuildConstDef = include("cityBuildConstDef")
			local buildEntity = cityBuildMgr:getBuildByIndex(cityBuildConstDef.buildIndexDef.index_StarBraveStatue)
			local queue = buildEntity:getQueue()
			if not queue then
				_ENV = uiManager
				uiManager.key = "OpstatueBrave"
				mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.TO_BUILD_STATUE_BRAVE, uiManager)
				SoraDRemoveAllAfterPanelFromManager(self)
			else
				_ENV = SoraDRemoveAllAfterPanelFromManager
				_ENV = gNewPLayerTaskType.TO_BUILD_STATUE_BRAVE
				gNewPLayerTaskType.TO_BUILD_STATUE_BRAVE.name = "Soldiers_armor_text_58"
				SoraDRemoveAllAfterPanelFromManager[gQueueTypeDef.glorious_upgrade], gNewPLayerTaskType.TO_BUILD_STATUE_BRAVE.key = gNewPLayerTaskType.TO_BUILD_STATUE_BRAVE, "OpstatueBrave"
				_ENV = gNewPLayerTaskType.TO_BUILD_STATUE_BRAVE
				gNewPLayerTaskType.TO_BUILD_STATUE_BRAVE.name = "Soldiers_armor_text_2"
				SoraDRemoveAllAfterPanelFromManager[gQueueTypeDef.craft_study], gNewPLayerTaskType.TO_BUILD_STATUE_BRAVE.key = gNewPLayerTaskType.TO_BUILD_STATUE_BRAVE, "OpProcessStudy"
				_ENV = gNewPLayerTaskType.TO_BUILD_STATUE_BRAVE
				gNewPLayerTaskType.TO_BUILD_STATUE_BRAVE.name = "Soldiers_armor_text_3"
				SoraDRemoveAllAfterPanelFromManager[gQueueTypeDef.armor_forging], gNewPLayerTaskType.TO_BUILD_STATUE_BRAVE.key = gNewPLayerTaskType.TO_BUILD_STATUE_BRAVE, "OpWarframeForg"
				do
					local config = SoraDRemoveAllAfterPanelFromManager
					_ENV = MAINCITYVIEW_OFFSET_TYPE_BUILD
					MAINCITYVIEW_OFFSET_TYPE_BUILD.var = i18n(config[tonumber(queue.qtype)].name)
					SoraDShowMsgBox(i18n("Soldiers_armor_text_72", MAINCITYVIEW_OFFSET_TYPE_BUILD), i18n("common_text_204"), i18n("common_text_185"), function(eventType)
						if MSGBOX_CALLBACK_YES == eventType then
							_ENV = nil
							;(nil).key = config[tonumber(queue.qtype)].key
							;(nil).queuePriority = true
							;(nil).isMild = false
							mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.TO_BUILD_STATUE_BRAVE, nil)
							SoraDRemoveAllAfterPanelFromManager(self)
						end
					end)
				end
			end
		else
			_ENV = buildEntity:getQueue()
			buildEntity:getQueue().bid = self.tabelSingelData.bid
			mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.BUILDSTAR_UPGRADE, (buildEntity:getQueue()))
			SoraDRemoveAllAfterPanelFromManager(self)
		end
	end
end
return collegeDetailsSingle
