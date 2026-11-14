local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activityDropRead = include("activityDropRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_harvestRamadan = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://eventSurpriseHarvest/Com_harvestRamadan", Com_harvestRamadan)
function Com_harvestRamadan:onInit()
	self.awardList, _ENV, self.activityID = gActivityTimeActivityID.RAMADAN_SURPRISED_DROP, gActivityTimeActivityID.RAMADAN_SURPRISED_DROP, gActivityTimeActivityID.RAMADAN_SURPRISED_DROP
	self.fields.Btn_go:setString(i18n("common_text_477"))
	self.fields.Btn_go:addClickListener(handler(self, self.btnClick))
	self.fields.List_arard:setItemRenderer(handler(self, self.onItemRenderer))
	self:fixChildrenPos()
	self.fields.icon:fix()
end
function Com_harvestRamadan:onItemRenderer(index, obj)
	obj:initData(self.awardList[index + 1])
end
function Com_harvestRamadan:onShow()
end
function Com_harvestRamadan:initData(cfg, activityID)
	self.activityID = activityID or self.activityID
	self.eid = cfg.eid
	self.enumType = cfg.dropType
	self.fields.icon:setSpriteFrame(cfg.bg)
	self.fields.Text_name:setString(cfg.name)
	self.fields.Text_des:setString(cfg.des)
	local param = activityShowCtrl:getParamByID(self.activityID)
	self.classtype = param.classtype or 1
	self.awardList = activityDropRead.getDropItems(self.activityID, self.classtype, self.enumType)
	self.fields.List_arard:setNumItems(#self.awardList)
	local dailyGot = cfg.dropCount or 0
	local dailyLimit = activityDropRead.getMaxDrop(self.activityID, self.enumType)
	activityShowCtrl = nil
	;(nil).var1 = fguiHelper.getColorString(dailyGot >= dailyLimit and "#BE2828" or "#FFFBD5", dailyGot)
	;(nil).var2 = dailyLimit
	self.fields.Text_got:setString(i18n("common_text_4797", nil))
end
function Com_harvestRamadan:btnClick()
	SoraDPlaySound()
	if clientEventMgr.judgeIsOpen(self.activityID, true) then
		local currentScene = display.getRunningScene()
		local currentView = currentScene:currentSceneShowView()
		if self.enumType == gActivityDropType.KILL_MONSTER or self.enumType == gActivityDropType.COLLECT_RES then
			local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
			_ENV = nil
			mildGuideManager:starToQuickToWorld(nil)
			SoraDRemoveAllPanelFromManager()
		elseif self.enumType == gActivityDropType.OUTCITY_RES then
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
		elseif self.enumType == gActivityDropType.TREVI_FOUNTAIN then
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
return Com_harvestRamadan
