local activityTimeRead = include("activityTimeRead")
local activity_9001566_Read = include("activity_9001566_Read")
local activity_9001566_Ctrl = SoraDGetCtrl("activity_9001566_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001566_mainPanel = class("Activity_9001566_mainPanel", baseFguiPanel)
function Activity_9001566_mainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001566_mainPanel:ctor", self.viewName)
	self.objList, _ENV, self.isHideCurrentSceneView = print, print, true
end
function Activity_9001566_mainPanel:onInit()
	print("=======Activity_9001566_mainPanel:onInit")
	self.activityID = self.param and self.param.activityID or gActivityTimeActivityID.ITEM_REBATE_ACTIVITY1
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.List_task:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_tip:setString(i18n("battleground_rebate_19"))
	local worldMapWarDef = include("worldMapWarDef")
	local warActivityID = worldMapWarDef.getItemRebateWarActivityID(self.activityID)
	local activity_bg = activityTimeRead.getActivityBgByID(warActivityID)
	self.fields.Label_banner:setIcon(activity_bg)
end
function Activity_9001566_mainPanel:onShow()
	print("=======Activity_9001566_mainPanel:onShow")
	self.eventTypeList = activity_9001566_Read.getEventTypeList()
	self.fields.List_task:setNumItems(#self.eventTypeList)
end
function Activity_9001566_mainPanel:onClickHelp(...)
	SoraDPlaySound()
	local content = i18n("battleground_rebate_10")
	if self.activityID == gActivityTimeActivityID.ITEM_REBATE_ACTIVITY8 then
		local itemDesRead = include("itemDesRead")
		local itemName1 = i18n("item_name_300302")
		local itemID2 = ITEM_ROARING_FLAME_SPEEDUP
		local itemName2 = itemDesRead.getName(itemID2)
		_ENV = nil
		;(nil).item1 = itemName1
		;(nil).item2 = itemName2
		local str = i18n("battleground_rebate_10_8", nil)
		content = content .. "\n" .. str
	end
	_ENV = itemDesRead.getName(itemID2)
	itemDesRead.getName(itemID2).content = content
	uiManager:show("RuleView", (itemDesRead.getName(itemID2)))
end
function Activity_9001566_mainPanel:onItemRenderer(index, obj)
	local eventType = self.eventTypeList[index + 1]
	self.objList[eventType] = obj
	local cfg = activity_9001566_Read.getEventTypeConfig(eventType)
	local _fields = fguiHelper.get_fields(obj)
	obj._fields = _fields
	if not SoraDFIsRA() then
		_fields.Load_icon:fix()
		_fields.Text_name:fixPos()
		_fields.Text_score:fixPos()
	end
	_fields.Load_icon:setURL(cfg.icon)
	_fields.Text_name:setString(i18n(cfg.name))
	local progress = activity_9001566_Ctrl:getEventProgress(self.activityID, eventType)
	local progress2 = activity_9001566_Read.changeTaskValue(progress, eventType)
	activity_9001566_Read = i18n(cfg.name)
	activity_9001566_Read, activity_9001566_Read, i18n(cfg.name).var = progress2, string.formatnumberthousands(progress2), string.formatnumberthousands(progress2)
	progress2.color = "#FFDF2D"
	string.formatnumberthousands(progress2).var, progress2.size = progress2, "24"
	_fields.Text_score:setString(i18n_html("magic_herb_text_005", i18n(cfg.name)))
	local curStage, isMax = activity_9001566_Ctrl:getCurEventStage(self.activityID, eventType)
	if isMax then
		_fields.Text_des:setString(i18n("battleground_rebate_4"))
	else
		local nextStage = curStage + 1
		activity_9001566_Read = i18n("battleground_rebate_4")
		i18n("battleground_rebate_4").activityId = self.activityID
		i18n("battleground_rebate_4").eventType = eventType
		i18n("battleground_rebate_4").idx = nextStage
		local taskTarget = activity_9001566_Read.getTaskTarget2(i18n("battleground_rebate_4"))
		local remain = taskTarget - progress2
		local itemName = activity_9001566_Read.getEventTypeNameWithIdx(eventType, nextStage)
		activity_9001566_Read = i18n("battleground_rebate_4")
		i18n("battleground_rebate_4").time = string.formatnumberthousands(remain)
		i18n("battleground_rebate_4").item = itemName
		_fields.Text_des:setString(i18n(cfg.des, i18n("battleground_rebate_4")))
	end
	_fields.Com_Stage:initData(self.activityID, eventType)
	_fields.Com_Stage:setBarValue(progress)
end
function Activity_9001566_mainPanel:onMsgUpdateReward(target, event)
	local eventType = event.eventType
	if eventType then
		local obj = self.objList[eventType]
		obj._fields.Com_Stage:initData(self.activityID, eventType)
	else
		for eventType, obj in pairs(self.objList) do
			obj._fields.Com_Stage:initData(self.activityID, eventType)
		end
	end
end
return Activity_9001566_mainPanel
