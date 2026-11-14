local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_harvestSnow = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://eventSurpriseHarvest/Com_harvestSnow", Com_harvestSnow)
function Com_harvestSnow:onInit()
	self.awardList, _ENV = nil, nil
	self.fields.Btn_go:setString(i18n("common_text_477"))
	self.fields.Btn_go:addClickListener(handler(self, self.btnClick))
	self.fields.List_arard:setItemRenderer(handler(self, self.onItemRenderer))
	self:fixChildrenPos()
	self.fields.icon:fix()
end
function Com_harvestSnow:onItemRenderer(index, obj)
	obj:initData(self.awardList[index + 1])
end
function Com_harvestSnow:onShow()
end
function Com_harvestSnow:initData(cfg)
	self.eid = cfg.eid
	self.fields.icon:setSpriteFrame(cfg.bg)
	self.fields.Text_name:setString(cfg.name)
	self.fields.Text_des:setString(cfg.des)
	self.awardList = activityShowCtrl:getSnowDropShowItems(self.eid)
	self.fields.List_arard:setNumItems(#self.awardList)
	local dailyGot = cfg.dropCount or 0
	local dailyLimit = activityShowCtrl:getSnowDropDailyLimit(self.eid)
	activityShowCtrl = nil
	;(nil).var1 = fguiHelper.getColorString(dailyGot >= dailyLimit and "#BE2828" or "#FFFBD5", dailyGot)
	;(nil).var2 = dailyLimit
	self.fields.Text_got:setString(i18n("common_text_4797", nil))
end
function Com_harvestSnow:btnClick()
	SoraDPlaySound()
	if clientEventMgr.judgeIsOpen(self.eid, true) then
		local currentScene = display.getRunningScene()
		local currentView = currentScene:currentSceneShowView()
		if self.eid == gActivityTimeActivityID.SURPRISED_DROP_3_ACTIVITY_0 or self.eid == gActivityTimeActivityID.SURPRISED_DROP_3_ACTIVITY_1 then
			local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
			_ENV = nil
			mildGuideManager:starToQuickToWorld(nil)
			SoraDRemoveAllPanelFromManager()
		elseif self.eid == gActivityTimeActivityID.SURPRISED_DROP_3_ACTIVITY_2 then
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
		elseif self.eid == gActivityTimeActivityID.SURPRISED_DROP_3_ACTIVITY_3 then
			if currentView.__cname == "worldMapView" then
				_ENV = currentView.__cname
				currentView.__cname.msg = "MESSAGE_MAINCITYVIEW_MOVETO_BUILDBYBID"
				local currentView.__cname.bid, data = BUILDID.WISHING_WELL, currentView.__cname
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
				SoraDSendMessage(SoraDRemoveAllPanelFromManager)
				SoraDRemoveAllPanelFromManager()
			end
		end
	end
end
return Com_harvestSnow
