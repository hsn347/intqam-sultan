local itemDesRead = include("itemDesRead")
local jumpDesRead = include("jumpDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local EventItemGuidePanel = class("EventItemGuidePanel", baseFguiPanel)
_ENV = "EventItemGuidePanel"
;("EventItemGuidePanel").ACTIVITY_NORMAL = 1
;("EventItemGuidePanel").KNIGHTS_CHARGE = 2
;("EventItemGuidePanel").ANNIHILATION = 3
;("EventItemGuidePanel").DEVELOP_ARMAMENT_ACTIVITY = 4
;("EventItemGuidePanel").BACKTASK = 5
;("EventItemGuidePanel").ADVANCEDTASK = 6
;("EventItemGuidePanel").KINGGIFT = 7
;("EventItemGuidePanel").SHOP = 8
;("EventItemGuidePanel").SPIRITUAL_GIFT = 9
;("EventItemGuidePanel").GLORY_ROAD_ACTIVITY = 13
local _ENV, ("EventItemGuidePanel").NEW_DAY_TASK, viewType = baseFguiPanel, 14, "EventItemGuidePanel"
_UPVALUE3_ = nil
baseFguiPanel[gActivityTimeActivityID.RIDES_EXCHANGE_MALL], (nil)[1] = nil, viewType.KNIGHTS_CHARGE
baseFguiPanel[gActivityTimeActivityID.RIDES_EXCHANGE_MALL], (nil)[2] = nil, viewType.ANNIHILATION
baseFguiPanel[gActivityTimeActivityID.RIDES_EXCHANGE_MALL], (nil)[3] = nil, viewType.DEVELOP_ARMAMENT_ACTIVITY
_UPVALUE1_ = nil
baseFguiPanel[gActivityTimeActivityID.EXCHANGE_MALL_RED_GEM], (nil)[1] = nil, viewType.ACTIVITY_NORMAL
_UPVALUE4_ = nil
baseFguiPanel[gActivityTimeActivityID.FRIEND_HONORBACK], (nil)[1] = nil, viewType.BACKTASK
baseFguiPanel[gActivityTimeActivityID.FRIEND_HONORBACK], (nil)[2] = nil, viewType.ADVANCEDTASK
baseFguiPanel[gActivityTimeActivityID.FRIEND_HONORBACK], (nil)[3] = nil, viewType.KINGGIFT
baseFguiPanel[gActivityTimeActivityID.FRIEND_HONORBACK], (nil)[4] = nil, viewType.SHOP
_UPVALUE1_ = nil
baseFguiPanel[gActivityTimeActivityID.EXCHANGE_MALL_SPIRITUAL_GIFT], (nil)[1] = nil, viewType.SPIRITUAL_GIFT
_UPVALUE1_ = nil
baseFguiPanel[gActivityTimeActivityID.EXCHANGE_MALL_SPIRITUAL_GIFT_NEW], (nil)[1] = nil, viewType.SPIRITUAL_GIFT
baseFguiPanel[gActivityTimeActivityID.EXCHANGE_MALL_SALARY] = itemDesRead.getOutput(826501)
_UPVALUE1_ = itemDesRead.getOutput(826501)
baseFguiPanel[gActivityTimeActivityID.EXCHANGE_ROAD_TO_GLORY], itemDesRead.getOutput(826501)[1] = itemDesRead.getOutput(826501), viewType.GLORY_ROAD_ACTIVITY
_UPVALUE1_ = itemDesRead.getOutput(826501)
baseFguiPanel[gActivityTimeActivityID.EXCHANGE_MALL_NEW_DAY_TASK], itemDesRead.getOutput(826501)[1] = itemDesRead.getOutput(826501), viewType.NEW_DAY_TASK
_UPVALUE1_ = itemDesRead.getOutput(826501)
_ENV, baseFguiPanel[gActivityTimeActivityID.EXCHANGE_MALL_RED_GEM_CROSS_SERVER], itemDesRead.getOutput(826501)[1] = gActivityTimeActivityID.EXCHANGE_MALL_RED_GEM_CROSS_SERVER, itemDesRead.getOutput(826501), viewType.ACTIVITY_NORMAL
local viewSourceConfig = baseFguiPanel
_ENV = viewType.ACTIVITY_NORMAL
viewType.ACTIVITY_NORMAL.icon = "icon_activity_show_9001126.png"
gActivityTimeActivityID.EXCHANGE_MALL_RED_GEM_CROSS_SERVER[viewType.KNIGHTS_CHARGE], viewType.ACTIVITY_NORMAL.des = viewType.ACTIVITY_NORMAL, "mail_title_40"
_ENV = viewType.ACTIVITY_NORMAL
viewType.ACTIVITY_NORMAL.icon = "icon_activity_9001131.png"
gActivityTimeActivityID.EXCHANGE_MALL_RED_GEM_CROSS_SERVER[viewType.ANNIHILATION], viewType.ACTIVITY_NORMAL.des = viewType.ACTIVITY_NORMAL, "activityname_9001131"
_ENV = viewType.ACTIVITY_NORMAL
viewType.ACTIVITY_NORMAL.icon = "icon_approach_activity.png"
gActivityTimeActivityID.EXCHANGE_MALL_RED_GEM_CROSS_SERVER[viewType.ACTIVITY_NORMAL], viewType.ACTIVITY_NORMAL.des = viewType.ACTIVITY_NORMAL, "common_text_4449"
_ENV = viewType.ACTIVITY_NORMAL
viewType.ACTIVITY_NORMAL.icon = "icon_activity_show_Development_army.png"
gActivityTimeActivityID.EXCHANGE_MALL_RED_GEM_CROSS_SERVER[viewType.DEVELOP_ARMAMENT_ACTIVITY], viewType.ACTIVITY_NORMAL.des = viewType.ACTIVITY_NORMAL, "common_text_2645"
_ENV = viewType.ACTIVITY_NORMAL
viewType.ACTIVITY_NORMAL.icon = "return_page_task.png"
gActivityTimeActivityID.EXCHANGE_MALL_RED_GEM_CROSS_SERVER[viewType.BACKTASK], viewType.ACTIVITY_NORMAL.des = viewType.ACTIVITY_NORMAL, "return_title_06"
_ENV = viewType.ACTIVITY_NORMAL
viewType.ACTIVITY_NORMAL.icon = "icon_return_page_task.png"
gActivityTimeActivityID.EXCHANGE_MALL_RED_GEM_CROSS_SERVER[viewType.ADVANCEDTASK], viewType.ACTIVITY_NORMAL.des = viewType.ACTIVITY_NORMAL, "return_title_09"
_ENV = viewType.ACTIVITY_NORMAL
viewType.ACTIVITY_NORMAL.icon = "icon_return_page_kingift.png"
gActivityTimeActivityID.EXCHANGE_MALL_RED_GEM_CROSS_SERVER[viewType.KINGGIFT], viewType.ACTIVITY_NORMAL.des = viewType.ACTIVITY_NORMAL, "return_wzzl_title_001"
_ENV = viewType.ACTIVITY_NORMAL
viewType.ACTIVITY_NORMAL.icon = "icon_source_shop.png"
gActivityTimeActivityID.EXCHANGE_MALL_RED_GEM_CROSS_SERVER[viewType.SHOP], viewType.ACTIVITY_NORMAL.des = viewType.ACTIVITY_NORMAL, "return_lcks_text_036"
_ENV = viewType.ACTIVITY_NORMAL
viewType.ACTIVITY_NORMAL.icon = "icon_activity_9001191.png"
gActivityTimeActivityID.EXCHANGE_MALL_RED_GEM_CROSS_SERVER[viewType.SPIRITUAL_GIFT], viewType.ACTIVITY_NORMAL.des = viewType.ACTIVITY_NORMAL, "godGift_text_01"
_ENV = viewType.ACTIVITY_NORMAL
viewType.ACTIVITY_NORMAL.icon = "icon_activity_9001321.png"
gActivityTimeActivityID.EXCHANGE_MALL_RED_GEM_CROSS_SERVER[viewType.GLORY_ROAD_ACTIVITY], viewType.ACTIVITY_NORMAL.des = viewType.ACTIVITY_NORMAL, "activity_name_9001321"
_ENV = viewType.ACTIVITY_NORMAL
viewType.ACTIVITY_NORMAL.icon = "icon_activity_9001320.png"
gActivityTimeActivityID.EXCHANGE_MALL_RED_GEM_CROSS_SERVER[viewType.NEW_DAY_TASK], viewType.ACTIVITY_NORMAL.des = viewType.ACTIVITY_NORMAL, "activity_name_9001320"
local itemSourceViewConfig = gActivityTimeActivityID.EXCHANGE_MALL_RED_GEM_CROSS_SERVER
function EventItemGuidePanel:ctor(...)
	self.super.ctor(self, ...)
	print("EventItemGuidePanel:ctor", self.viewName)
end
function EventItemGuidePanel:onInit()
	print("=======EventItemGuidePanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_4342"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_none:setString(i18n("common_text_4619"))
end
function EventItemGuidePanel:onShow()
	print("=======EventItemGuidePanel:onShow")
	self.handle = self.param.handle
	self:initData(self.param.activityID)
end
function EventItemGuidePanel:initData(activityID)
	self.activityID = activityID
	if not viewSourceConfig[activityID] then
		viewSourceConfig = viewSourceConfig[activityID]
	end
	self.sourcesData = viewSourceConfig[activityID]
	dump(self.sourcesData, "==EventItemGuidePanel:initData==")
	self.fields.List:setNumItems(#self.sourcesData)
	self.fields.Text_none:setVisible(#self.sourcesData == 0)
end
function EventItemGuidePanel:onItemRenderer(index, obj)
	local sourceId = self.sourcesData[index + 1]
	local _fields = fguiHelper.get_fields(obj)
	local itemCfg = itemSourceViewConfig[sourceId]
	if self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_SALARY then
		itemCfg = jumpDesRead.getCfg(sourceId)
	end
	if itemCfg then
		_fields.Text_des:setString(i18n(itemCfg.des))
		_fields.icon:setURL(itemCfg.icon)
	end
	_fields.Button_go:setString(i18n("common_text_477"))
	_fields.Button_go:setTag(sourceId)
	_fields.Button_go:addClickListener(handler(self, self.onClick_btn_template))
	if not SoraDFIsRA() then
		obj:fixChildrenPos()
	end
end
function EventItemGuidePanel:onClick_btn_template(EventContext)
	SoraDPlaySound()
	local tag = EventContext:getSender():getTag()
	if self:jumpBySourceType(tag) then
		SoraDRemoveAllPrePanelFromManager(self)
	end
end
function EventItemGuidePanel:jumpBySourceType(tag)
	if tag == viewType.ACTIVITY_NORMAL then
		uiManager:show("EventCenterView")
		return true
	elseif tag == viewType.KNIGHTS_CHARGE then
		if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.KNIGHTS_CHARGE, true) then
			SoraDCreatePanel("knightsChargeMainView"):show()
			return true
		end
	elseif tag == viewType.ANNIHILATION then
		if SoraDGetCastleLv() < CASTLE_LV6_LIMITED then
			viewType = nil
			;(nil).num = CASTLE_LV6_LIMITED
			SoraDShowMsgTip(i18n("common_text_1795", nil))
		elseif clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ANNIHILATION, true) then
			SoraDCreatePanel("totalSweepView"):show()
			return true
		end
	elseif tag == viewType.DEVELOP_ARMAMENT_ACTIVITY then
		if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.DEVELOP_ARMAMENT_ACTIVITY, true) then
			SoraDCreatePanel("eventDevelopArmyView"):show()
			return true
		end
	elseif tag == viewType.GLORY_ROAD_ACTIVITY then
		if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.GLORY_ROAD_ACTIVITY, true) then
			print("viewType.GLORY_ROAD_ACTIVITY!!!!!!!!!")
			uiManager:show("RoadToGlory"):show()
			return true
		end
	elseif tag == viewType.NEW_DAY_TASK then
		if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.CHANGE_DAY_ACTIVITY, true) then
			local panel = SoraDCreatePanel("newDayTaskView")
			panel:show()
			return true
		end
	elseif self.activityID == gActivityTimeActivityID.FRIEND_HONORBACK then
		viewType = self.activityID
		viewType = panel
		panel.honorType = gHonorBackType.BackTask
		self.activityID[viewType.BACKTASK], panel.btnType = panel, 2
		viewType = panel
		panel.honorType = gHonorBackType.AdvancedTask
		self.activityID[viewType.ADVANCEDTASK], panel.btnType = panel, 2
		viewType = panel
		self.activityID[viewType.KINGGIFT], panel.honorType = panel, gHonorBackType.KingGift
		self.activityID[viewType.SHOP], viewType = panel, panel
		local tab = self.activityID
		if self.handle then
			self.handle(tab[tag].honorType, tab[tag].btnType)
		end
		self:removeFromParent()
	elseif self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_SPIRITUAL_GIFT or self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_SPIRITUAL_GIFT_NEW then
		if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.SPIRITUAL_GIFT, true) then
			SoraDCreatePanel("spiritualGiftView"):show()
		end
		self:removeFromParent()
	elseif self.activityID == gActivityTimeActivityID.EXCHANGE_MALL_SALARY then
		local guide = jumpDesRead.getGuide(tag)
		dump(guide, "guide data", 10)
		if guide.id then
			SoraDRemoveAllPanelFromManager()
			local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
			local ret = mildGuideManager:starMildByNewPlayerQuestID(guide.id, guide)
			return ret
		else
			local itemCfg = jumpDesRead.getCfg(tag)
			SoraDShowMsgTip(i18n(itemCfg.des))
			self:closePanel()
			return false
		end
	end
	return false
end
return EventItemGuidePanel
