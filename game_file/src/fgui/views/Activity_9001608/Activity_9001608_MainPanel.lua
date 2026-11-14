local activity_9001608_Ctrl = SoraDGetCtrl("activity_9001608_Ctrl")
local activityCenterUICtrl = SoraDGetCtrl("activityCenterUICtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local activityTimeRead = include("activityTimeRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001608_MainPanel = class("Activity_9001608_MainPanel", baseFguiPanel)
function Activity_9001608_MainPanel:ctor(...)
	Activity_9001608_MainPanel.super.ctor(self, ...)
	print("Activity_9001608_MainPanel:ctor", self.viewName)
	self.isHideCurrentSceneView = true
	self.eventMap, Activity_9001608_MainPanel, self.eventList, Activity_9001608_MainPanel, self.objMap, Activity_9001608_MainPanel, self.activityID = gActivityTimeActivityID.HONOR_BACK_ACTIVITY, gActivityTimeActivityID.HONOR_BACK_ACTIVITY, gActivityTimeActivityID.HONOR_BACK_ACTIVITY, gActivityTimeActivityID.HONOR_BACK_ACTIVITY, gActivityTimeActivityID.HONOR_BACK_ACTIVITY, gActivityTimeActivityID.HONOR_BACK_ACTIVITY, gActivityTimeActivityID.HONOR_BACK_ACTIVITY
end
function Activity_9001608_MainPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "soldiersCampView"
	end
	return self._packageList
end
function Activity_9001608_MainPanel:onInit()
	print("=======Activity_9001608_MainPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose))
	self.fields.List_event:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_event:addEventListener(fgui.UIEventType.ClickItem, handler(self, self.onClickItem))
end
function Activity_9001608_MainPanel:onShow()
	print("=======Activity_9001608_MainPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self.eventConfig, _ENV = self.fields.Com_bg.setGradientColor, self.fields.Com_bg.setGradientColor
	self.activityGroup = activityShowCtrl:getActivityGroup(self.activityID)
	local _ENV, eventList = activityShowCtrl:getActivityGroup(self.activityID), activityShowCtrl:getActivityGroup(self.activityID)
	for activityID, __ in pairs(self.activityGroup) do
		if clientEventMgr.judgeIsOpen(activityID) then
			local ret, retNum = activity_9001608_Ctrl:getReceiveStatusAndNum(activityID)
			local isNew = activityCenterUICtrl:isHaveNewFlag(activityID)
			local order = activityShowCtrl:getActivityBeginOrder(activityID)
			_ENV = nil
			;(nil).activityID = activityID
			;(nil).isRed = ret
			;(nil).retNum = retNum
			;(nil).isNew = isNew
			;(nil).order = order
			table.insert(eventList, nil)
		end
	end
	table.sort(eventList, function(a, b)
		if a.isRed ~= b.isRed then
			return a.isRed
		end
		if a.isNew ~= b.isNew then
			return a.isNew
		end
		if a.order ~= b.order then
			return a.order > b.order
		end
		return a.activityID < b.activityID
	end)
	self.eventList = eventList
	self:updateEventList()
	local activityID = self.param and self.param.activityID
	if activityID and self.eventMap[activityID] then
		local selectIndex = self.eventMap[activityID].index
		self:updateSelectIndex(selectIndex)
	else
		self:updateSelectIndex()
	end
end
function Activity_9001608_MainPanel:updateEventList()
	self.eventMap, _UPVALUE0_ = nil, nil
	self.fields.List_event:setNumItems(#self.eventList)
end
function Activity_9001608_MainPanel:updateSelectIndex(selectIndex)
	if #self.eventList > 0 then
		local childIndex = selectIndex and selectIndex - 1 or 0
		self.fields.List_event:scrollToView(childIndex)
		self.fields.List_event:setSelectedIndex(childIndex)
		local cfg = self.eventList[childIndex + 1]
		local activityID = cfg.activityID
		self:switchView(activityID)
		self:sendClearNewMsg(activityID)
	end
end
function Activity_9001608_MainPanel:onItemRenderer(index, obj)
	if not obj._fields then
		obj._fields = fguiHelper.get_fields(obj)
		local _fields = obj._fields
		if SoraDFIsRA() then
			_fields.Image_new:setURL("img_common_new_ar.png")
		end
	end
	local cfg = self.eventList[index + 1]
	local activityID = cfg.activityID
	_ENV = "img_common_new_ar.png"
	;("img_common_new_ar.png").index = index + 1
	self.eventMap[activityID], ("img_common_new_ar.png").obj = "img_common_new_ar.png", obj
	local _fields = obj._fields
	obj:setIcon(activityTimeRead.getActivityIconByID(activityID))
	obj:setString(activityTimeRead.getActivityShowName(activityID))
	obj:setReddot(cfg.isRed, cfg.retNum)
	_fields.Image_new:setVisible(cfg.isNew or false)
end
function Activity_9001608_MainPanel:onClickItem(EventContext)
	SoraDPlaySound()
	local obj = EventContext:getGObjectData()
	local childIndex = self.fields.List_event:getChildIndex(obj)
	local activityID = self.eventList[childIndex + 1].activityID
	self:switchView(activityID)
	self:sendClearNewMsg(activityID)
end
function Activity_9001608_MainPanel:switchView(activityID)
	print("==Activity_9001608_MainPanel:switchView==", self.curActivityID, activityID)
	if self.curActivityID == activityID then
		return
	end
	local obj = self.objMap[self.curActivityID]
	if obj then
		obj:setVisible(false)
	end
	self.curActivityID = activityID
	if not self.eventConfig[activityID] then
		local _ENV, cfg = self.eventConfig[activityID], self.eventConfig[activityID]
	end
	local obj = self.objMap[activityID]
	if not obj then
		local pkgName = cfg.pkgName or "Activity_" .. activityID
		local objName = cfg.objName or "Com_Activity_" .. activityID
		fguiHelper.addPackage(self, pkgName)
		obj = fgui.UIPackage:createObject(pkgName, objName)
		if not obj then
			return
		end
		obj:setContentSize(self.fields.Com_content:getContentSize())
		obj:addTo(self.fields.Com_content)
		self.objMap[activityID] = obj
	else
		obj:setVisible(true)
	end
end
function Activity_9001608_MainPanel:sendClearNewMsg(activityID)
	local event = self.eventMap[activityID]
	if not event then
		return
	end
	local cfg = self.eventList[event.index]
	if not cfg.isNew then
		return
	end
	cfg.isNew = false
	activityCenterUICtrl:sendClearNewMsg(activityID)
	local _fields = event.obj._fields
	_fields.Image_new:setVisible(false)
end
function Activity_9001608_MainPanel:updateActivityState(activityID)
	if activityID == gActivityTimeActivityID.HONOR_BACK_ACTIVITY then
		if not clientEventMgr.judgeIsOpen(activityID) then
			SoraDRemoveAllAfterPanelFromManager(self)
		end
		return
	end
	if not self.activityGroup[activityID] then
		return
	end
	local cfg = self.eventMap[activityID]
	if cfg and not clientEventMgr.judgeIsOpen(activityID) then
		table.remove(self.eventList, cfg.index)
		local setSelect = self.curActivityID == activityID
		self:updateEventList()
		if setSelect then
			self:updateSelectIndex()
			local obj = self.objMap[activityID]
			if obj then
				obj:removeFromParent()
				self.objMap[activityID] = nil
			end
			SoraDRemoveAllAfterPanelFromManager(self, true)
		end
	end
end
function Activity_9001608_MainPanel:onMsgUpdateRed(target, event)
	local activityID = event.activityID
	local cfg = self.eventMap[activityID]
	if not cfg then
		return
	end
	local ret, retNum = activity_9001608_Ctrl:getReceiveStatusAndNum(activityID)
	cfg.obj:setReddot(ret, retNum)
end
function Activity_9001608_MainPanel:onMsgJumpActivity(target, event)
	local activityID = event.activityID
	if activityID and self.eventMap[activityID] then
		local selectIndex = self.eventMap[activityID].index
		self:updateSelectIndex(selectIndex)
		SoraDRemoveAllAfterPanelFromManager(self, true)
	else
		SoraDShowMsgTip(i18n("common_text_2486"))
	end
end
return Activity_9001608_MainPanel
