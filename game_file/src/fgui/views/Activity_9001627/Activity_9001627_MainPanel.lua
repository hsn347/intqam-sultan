local activityDropRead = include("activityDropRead")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local activityExchangeMallRead = include("activityExchangeMallRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001627_MainPanel = class("Activity_9001627_MainPanel", baseFguiPanel)
function Activity_9001627_MainPanel:ctor(...)
	Activity_9001627_MainPanel.super.ctor(self, ...)
	print("Activity_9001627_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.NEBULA_SURPRISED_DROP
	self.storeActivityID = gActivityTimeActivityID.NEBULA_SURPRISED_DROP_STORE
	self.itemID = activityExchangeMallRead:getExchangeitemByID(self.storeActivityID)
	self.itemGetCount, Activity_9001627_MainPanel, self.eventList = activityDropRead.getEventList(self.activityID), activityDropRead.getEventList(self.activityID), activityDropRead.getEventList(self.activityID)
	self.activitytp = DROP_ACTIVITY_ISNEW.NEBULA_SURPRISED_DROP
end
function Activity_9001627_MainPanel:onInit()
	print("=======Activity_9001627_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Button_shop:setString(i18n("allianceWar_shop_title"))
	self.fields.Button_shop:addClickListener(handler(self, self.onClickBtnShop))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setNumItems(#self.eventList)
	self.fields.Text_tip:setString(i18n("emission_nebulae_text_6"))
	self.fields.Text_tip2:setString(i18n("emission_nebulae_text_11"))
	local _fields = fguiHelper.get_fields(self.fields.Com_have)
	_ENV = i18n("emission_nebulae_text_11")
	i18n("emission_nebulae_text_11").num = ""
	_fields.Text_have:setString(i18n("common_text_531", i18n("emission_nebulae_text_11")))
	local itemDesRead = include("itemDesRead")
	_fields.Load_icon:setURL(itemDesRead.getIcon(self.itemID))
	self.fields.Text_count = _fields.Text_count
	if not SoraDFIsRA() then
		self.fields.Com_have:fixPos()
		self.fields.Com_have:fixChildrenPos()
	end
end
function Activity_9001627_MainPanel:onShow()
	print("=======Activity_9001627_MainPanel:onShow")
	self:updateItemCount()
	self:updateTextTime()
	self:updateActivityState()
	self:updateShopRed()
	activityShowCtrl:sendCurDayDrop(self.activitytp)
end
function Activity_9001627_MainPanel:onIntoPanel(...)
	self:updateShopRed()
end
function Activity_9001627_MainPanel:onClickHelp()
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("emission_nebulae_text_4"))
end
function Activity_9001627_MainPanel:onClickBtnShop()
	SoraDPlaySound()
	_ENV = nil
	;(nil).activityID = self.storeActivityID
	uiManager:show("ActExchangePageNew", nil)
end
function Activity_9001627_MainPanel:updateItemCount(...)
	local itemCount = backpackCtrl:getItemCount(self.itemID)
	self.fields.Text_count:setString(string.formatnumberthousands(itemCount))
end
function Activity_9001627_MainPanel:updateTextTime(...)
	local str1 = ""
	if clientEventMgr.judgeIsOpen(self.activityID) then
		local begintime = activityShowCtrl:getBeginTimeSecond(self.activityID)
		local endtime = activityShowCtrl:getEndTimeSecond(self.activityID)
		_ENV = nil
		;(nil).time1 = os.date("!%Y.%m.%d", begintime)
		;(nil).time2 = os.date("!%Y.%m.%d", endtime)
		str1 = i18n("emission_nebulae_text_1", nil)
	else
		str1 = i18n("emission_nebulae_text_10")
	end
	local begintime = activityShowCtrl:getBeginTimeSecond(self.storeActivityID)
	local endtime = activityShowCtrl:getEndTimeSecond(self.storeActivityID)
	_ENV = nil
	;(nil).time1 = os.date("!%Y.%m.%d", begintime)
	;(nil).time2 = os.date("!%Y.%m.%d", endtime)
	local str2 = i18n("emission_nebulae_text_2", nil)
	self.fields.Text_time:setString(str1 .. "\n" .. str2)
end
function Activity_9001627_MainPanel:updateActivityState(...)
	if clientEventMgr.judgeIsOpen(self.activityID) then
		self.controllers.c1:setSelectedIndex(0)
	else
		self.controllers.c1:setSelectedIndex(1)
	end
end
function Activity_9001627_MainPanel:updateShopRed(...)
	local classType = activityShowCtrl:getParamClassType(self.storeActivityID)
	local ret, num = activityExchangeMallCtrl:getReceiveStatusAndNum(self.storeActivityID, classType)
	self.fields.Button_shop:setReddot(ret or false)
end
function Activity_9001627_MainPanel:onItemRenderer(index, obj)
	local cfg = self.eventList[index + 1]
	local _fields = obj._fields
	if not _fields then
		_fields = fguiHelper.get_fields(obj)
		obj._fields = _fields
		if not SoraDFIsRA() then
			obj:fixChildrenPos()
		end
	end
	_fields.Text_name:setString(cfg.name)
	_fields.Text_des:setString(cfg.des)
	local dropCount = self.itemGetCount[tostring(cfg.dropType)] or 0
	local dropMax = activityDropRead.getMaxDrop(self.activityID, cfg.dropType)
	_ENV = nil
	;(nil).num1 = dropCount
	;(nil).num2 = dropMax
	_fields.Text_count:setString(i18n("emission_nebulae_text_5", nil))
end
function Activity_9001627_MainPanel:judgeClose(...)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		if not clientEventMgr.judgeIsOpen(self.storeActivityID) then
			SoraDRemoveAllAfterPanelFromManager(self)
		else
			self:updateTextTime()
			self:updateActivityState()
		end
	end
end
function Activity_9001627_MainPanel:onMsgUpdateData(target, event)
	if event.activitytp ~= self.activitytp then
		return
	end
	if not event.itemGetCount then
		_UPVALUE0_ = event.itemGetCount
	end
	self.itemGetCount = event.itemGetCount
	self.fields.List:setNumItems(#self.eventList)
end
function Activity_9001627_MainPanel:onMsgNewDay(...)
	self.itemGetCount, _UPVALUE0_ = nil, nil
	self.fields.List:setNumItems(#self.eventList)
end
function Activity_9001627_MainPanel:onMsgUpdateItemCount(target, event)
	if not event.itemMap then
		local _UPVALUE0_, itemMap = event.itemMap, event.itemMap
	end
	if itemMap[self.itemID] then
		self:updateItemCount()
	end
end
return Activity_9001627_MainPanel
