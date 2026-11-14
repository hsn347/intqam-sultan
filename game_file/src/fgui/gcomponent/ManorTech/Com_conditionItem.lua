local queueCtrl = SoraDGetCtrl("queueCtrl")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local buildRead = include("buildDescribeRead")
local buildLogic = include("buildLogic")
local collegeDesRead = include("collegeDesRead")
local resDesRead = include("resDesRead")
local itemDesRead = include("itemDesRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local manorCityRead = include("manorCityRead")
local manorTechRead = include("manorTechRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_conditionItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ManorTech/Com_conditionItem", Com_conditionItem)
function Com_conditionItem:onInit()
	self.queueType = gQueueTypeDef.garden_technology
	self.fields.Button_jump:setTitle(i18n("common_text_477"))
	self.fields.Button_jump:addClickListener(handler(self, self.onClick_Button_jump))
	self.title = SoraDCreateTimerLabel(self, self.fields.title)
	self:fixChildrenPos()
end
function Com_conditionItem:onShow()
end
function Com_conditionItem:initData(data)
	self.tabelSingelData = data.data
	self.singleType = data.singleType
	self.title:endTime()
	self:updateState(self.tabelSingelData.isContentmented)
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
		self.needResList = data.resNeedList
		self:showRes()
		self.fields.Button_jump:setString(i18n("common_text_337"))
	elseif self.singleType == TECHNOLOGY_SINGLE_TYPE.WAR then
		self:showWEs()
		self.fields.Button_jump:setString(i18n("common_text_337"))
	elseif self.singleType == TECHNOLOGY_SINGLE_TYPE.STAR then
		self:showStarBuild()
		self.fields.Button_jump:setString(i18n("common_text_477"))
	end
end
function Com_conditionItem:updateState(isContentmented)
	local labelColor = isContentmented and "#F0E6D2" or "#E02B2B"
	self.fields.Button_jump:setVisible(not isContentmented)
	self.fields.nYes:setVisible(isContentmented)
	self.fields.nNo:setVisible(not isContentmented)
	self.fields.title:setColor(labelColor)
end
function Com_conditionItem:showBuild()
	local cfg = manorCityRead.getBuildInfoConfig(self.tabelSingelData.bid)
	self.fields.icon:setSpriteFrame(cfg.buidIcon)
	manorCityRead = nil
	;(nil).name = i18n(cfg.buildName)
	;(nil).lv = self.tabelSingelData.consumeLevel
	self.title:setString(i18n("common_text_334", nil))
end
function Com_conditionItem:showTechnology()
	self.fields.icon:setSpriteFrame("icon_building_research.png")
	local cfg = manorTechRead.getTechShowCfg(self.tabelSingelData.tid)
	manorTechRead = nil
	;(nil).science = i18n(cfg.techName)
	;(nil).lv = self.tabelSingelData.consumeLevel
	self.title:setString(i18n("common_text_336", nil))
end
function Com_conditionItem:showQueue()
	self.fields.icon:setSpriteFrame("icon_hourglass.png")
	local cfg = manorTechRead.getTechShowCfg(self.tabelSingelData.technologyID)
	self.title:setTimeLast(function(strTime)
		_ENV = nil
		;(nil).name = i18n(cfg.techName)
		;(nil).time = strTime
		return i18n("common_text_338", nil)
	end)
	self.title:beginTime(self.queue.timerNode.timer:getRemainTime())
end
function Com_conditionItem:showRes()
	self.fields.icon:setSpriteFrame(resDesRead.getIcon(self.tabelSingelData.rid))
	local curRes = cityCtrl:getResCount(self.tabelSingelData.rid)
	self.fields.title:setString(string.formatnumberthousands(curRes) .. "/" .. string.formatnumberthousands(self.tabelSingelData.consumeResourceOri))
	self.fields.title:setColor(self.tabelSingelData.isContentmented and "#F0E6D2" or "#E02B2B")
end
function Com_conditionItem:showWEs()
	self.fields.icon:setSpriteFrame(itemDesRead.getIcon(self.tabelSingelData.rid))
	local curRes = cityCtrl:getResCount(self.tabelSingelData.rid)
	if BUILD_STAR_COSTITEM[self.tabelSingelData.rid] then
		curRes = backpackCtrl:getItemCount(self.tabelSingelData.rid)
	end
	self.fields.title:setString(itemDesRead.getName(self.tabelSingelData.rid) .. "   " .. tostring(self.tabelSingelData.currentResource) .. "/" .. self.tabelSingelData.consumeResource)
end
function Com_conditionItem:showStarBuild()
	self.fields.icon:setSpriteFrame(buildRead.getIcon(self.tabelSingelData.bid))
	if self.tabelSingelData.bid == BUILDID.STAR_BRAVE_STATUE then
		local cityltCtrl = include("cityltCtrl")
		self.title:setString(cityltCtrl.getStarBraveStatueLvStr(self.tabelSingelData.consumeLevel))
	else
		buildRead = cityltCtrl.getStarBraveStatueLvStr(self.tabelSingelData.consumeLevel)
		cityltCtrl.getStarBraveStatueLvStr(self.tabelSingelData.consumeLevel).n = buildRead.getName(self.tabelSingelData.bid)
		buildRead = cityltCtrl.getStarBraveStatueLvStr(self.tabelSingelData.consumeLevel)
		cityltCtrl.getStarBraveStatueLvStr(self.tabelSingelData.consumeLevel).lv = self.tabelSingelData.consumeLevel
		cityltCtrl.getStarBraveStatueLvStr(self.tabelSingelData.consumeLevel).c = i18n("Glory_text_24", cityltCtrl.getStarBraveStatueLvStr(self.tabelSingelData.consumeLevel))
		self.title:setString(i18n("common_text_2358", cityltCtrl.getStarBraveStatueLvStr(self.tabelSingelData.consumeLevel)))
	end
end
function Com_conditionItem:onClick_Button_jump(context)
	SoraDPlaySound()
	if self.singleType == TECHNOLOGY_SINGLE_TYPE.QUEUE then
		local speedUpType = gAbbrSpeedUpType.TECH
		local itemList = backpackCtrl:getSpeedUpItemList(speedUpType)
		if next(itemList) ~= nil then
			SoraDShowSpeedUpByItemBox(tonumber(self.queueType))
		else
			SoraDShowSpeedUpBox(self.queue, nil, i18n("common_text_706"))
		end
	elseif self.singleType == TECHNOLOGY_SINGLE_TYPE.RES then
		_ENV = self.queue
		self.queue.rid = self.tabelSingelData.rid
		if not self.needResList then
			_ENV = self.needResList
		end
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
		_ENV = i18n("nebula_war_text_0178")
		i18n("nebula_war_text_0178").itemID = self.tabelSingelData.rid
		uiManager:show("CommonSourceGuide", i18n("nebula_war_text_0178"))
	elseif self.singleType == TECHNOLOGY_SINGLE_TYPE.BUILD then
		SoraDShowMsgTip(i18n("garden_text_04"))
		SoraDRemoveAllAfterPanelFromManager(uiManager:getOrCreateProxy("ManorTechView").view)
		_ENV = uiManager:getOrCreateProxy("ManorTechView").view
		uiManager:getOrCreateProxy("ManorTechView").view.msg = "MESSAGE_MANOR_BUILD_JUMP"
		uiManager:getOrCreateProxy("ManorTechView").view.buildID = self.tabelSingelData.bid
		uiManager:getOrCreateProxy("ManorTechView").view.showFinger = true
		SoraDSendMessage(uiManager:getOrCreateProxy("ManorTechView").view)
	elseif self.singleType == TECHNOLOGY_SINGLE_TYPE.TECHNOLOGY then
		_ENV = "ManorTechView"
		;("ManorTechView").techID = self.tabelSingelData.tid
		uiManager:show("ManorTechDetail", "ManorTechView")
	elseif self.singleType == TECHNOLOGY_SINGLE_TYPE.STAR then
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		_ENV = self.tabelSingelData.tid
		self.tabelSingelData.tid.bid = self.tabelSingelData.bid
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.BUILDSTAR_UPGRADE, self.tabelSingelData.tid)
		SoraDRemoveAllAfterPanelFromManager(self)
	end
end
return Com_conditionItem
