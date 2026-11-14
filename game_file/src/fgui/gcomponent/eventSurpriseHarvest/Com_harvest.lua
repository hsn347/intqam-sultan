local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_harvest = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://eventSurpriseHarvest/Com_harvest", Com_harvest)
function Com_harvest:onInit()
	self.awardList, _ENV = nil, nil
	self.fields.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self:addClickListener(handler(self, self.btnClick))
	self.fields.List_arard:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_arard:setAlignCenter(true)
end
function Com_harvest:onShow()
end
function Com_harvest:onItemRenderer(index, obj)
	obj:initData(self.awardList[index + 1])
end
function Com_harvest:initData(cfg)
	self.eid = cfg.eid
	self.fields.Image_event:setSpriteFrame(cfg.bg)
	self.fields.Text_name:setString(cfg.name)
	local eventState = activityShowCtrl:getStateByID(self.eid)
	if eventState == gActivityState.OPEN then
		self.fields.Text_time:setTimeLast(function(time)
			return i18n("common_text_3173") .. ":" .. fguiHelper.getColorString("#00B400", time)
		end)
	elseif eventState == gActivityState.PREPARE then
		self.fields.Text_time:setTimeLast(function(time)
			return i18n("common_text_608") .. ":" .. fguiHelper.getColorString("#FF0000", time)
		end)
	end
	self.fields.Text_time:endTime()
	local timeQueue = activityShowCtrl:getTimeInfoByID(self.eid)
	local leftTime = timeQueue.timerNode.timer:getRemainTime()
	if 0 < leftTime then
		self.fields.Text_time:beginTime(leftTime)
	else
		self.fields.Text_time:endTime()
	end
	self.awardList = activityShowCtrl:getSurprisedDropShowItems(self.eid)
	self.fields.List_arard:setNumItems(#self.awardList)
end
function Com_harvest:btnClick()
	SoraDPlaySound()
	if clientEventMgr.judgeIsOpen(self.eid, true) then
		local currentScene = display.getRunningScene()
		local currentView = currentScene:currentSceneShowView()
		if self.eid == gActivityTimeActivityID.SURPRISED_DROP_ACTIVITY_0 or self.eid == gActivityTimeActivityID.SURPRISED_DROP_2_ACTIVITY_0 or self.eid == gActivityTimeActivityID.SURPRISED_DROP_ACTIVITY_1 or self.eid == gActivityTimeActivityID.SURPRISED_DROP_2_ACTIVITY_1 then
			local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
			_ENV = nil
			mildGuideManager:starToQuickToWorld(nil)
			SoraDRemoveAllPanelFromManager()
		elseif self.eid == gActivityTimeActivityID.SURPRISED_DROP_ACTIVITY_2 or self.eid == gActivityTimeActivityID.SURPRISED_DROP_2_ACTIVITY_2 then
			if currentView.__cname == "worldMapView" then
				_ENV = currentView.__cname
				currentView.__cname.msg = "MESSAGE_MAINCITYVIEW_MOVETO_BUILDBYBID"
				local currentView.__cname.goOuterCity, data = true, currentView.__cname
				_ENV = mildGuideManager
				mildGuideManager.msg = "MESSAGE_MAINSCEN_ONSHOW"
				mildGuideManager.viewType = VIEW_TYPE_CITY
				mildGuideManager.otherData = data
				SoraDSendMessage(mildGuideManager)
				SoraDRemoveAllPanelFromManager()
			else
				_ENV = SoraDRemoveAllPanelFromManager
				SoraDRemoveAllPanelFromManager.msg = "MESSAGE_MAINCITYVIEW_MOVETO_BUILDBYBID"
				SoraDRemoveAllPanelFromManager.goOuterCity = true
				SoraDSendMessage(SoraDRemoveAllPanelFromManager)
				SoraDRemoveAllPanelFromManager()
			end
		elseif self.eid == gActivityTimeActivityID.SURPRISED_DROP_ACTIVITY_3 or self.eid == gActivityTimeActivityID.SURPRISED_DROP_2_ACTIVITY_3 then
			if currentView.__cname == "worldMapView" then
				_ENV = currentView.__cname
				currentView.__cname.msg = "MESSAGE_MAINCITYVIEW_MOVETO_BUILDBYBID"
				currentView.__cname.bid = BUILDID.WISHING_WELL
				local currentView.__cname.view, data = "TreasureHuntView", currentView.__cname
				_ENV = mildGuideManager
				mildGuideManager.msg = "MESSAGE_MAINSCEN_ONSHOW"
				mildGuideManager.viewType = VIEW_TYPE_CITY
				mildGuideManager.otherData = data
				SoraDSendMessage(mildGuideManager)
				SoraDRemoveAllPanelFromManager()
			else
				_ENV = SoraDRemoveAllPanelFromManager
				SoraDRemoveAllPanelFromManager.msg = "MESSAGE_MAINCITYVIEW_MOVETO_BUILDBYBID"
				SoraDRemoveAllPanelFromManager.bid = BUILDID.WISHING_WELL
				SoraDRemoveAllPanelFromManager.view = "TreasureHuntView"
				SoraDSendMessage(SoraDRemoveAllPanelFromManager)
				SoraDRemoveAllPanelFromManager()
			end
		end
	end
end
return Com_harvest
