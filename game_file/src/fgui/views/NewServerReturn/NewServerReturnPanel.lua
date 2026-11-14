local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NewServerReturnPanel = class("NewServerReturnPanel", baseFguiPanel)
function NewServerReturnPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("NewServerReturnPanel:ctor", self.viewName)
end
function NewServerReturnPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Activity2112"
		self._packageList, self._packageList[2] = self._packageList, "fonts"
	end
	return self._packageList
end
function NewServerReturnPanel:onInit()
	print("=======NewServerReturnPanel:onInit")
	self.fields.Com_title:initData(i18n("activity_name_9001404"), handler(self, self.onClickClose))
	self.comParent = self.fields.Load_view:getParent()
	self.comIndex = self.comParent:getChildIndex(self.fields.Load_view)
	self.btnHandle = handler(self, self.onClickItem)
	self.fields.List_event:setItemRenderer(handler(self, self.onItemRendererEvent))
end
function NewServerReturnPanel:initData()
	self.eventData = self.proxy:getActivityShowList()
	local showActivityId = self.proxy.param and self.proxy.param.eid or nil
	self:resetActivityList(showActivityId)
	local timeEnd = serviceFunctions.systemTime()
	for i, v in ipairs(self.eventData) do
		local temp = activityShowCtrl:getEndTimeSecond(v.activityID)
		if timeEnd < temp then
			timeEnd = temp
		end
	end
	local endtime = string.format("UTC+0  %s", os.date("!%Y-%m-%d %H:%M:%S", timeEnd))
	_ENV = os.date("!%Y-%m-%d %H:%M:%S", timeEnd)
	os.date("!%Y-%m-%d %H:%M:%S", timeEnd).endtime = endtime
	self.fields.Text_endTime:setString(i18n("newstart_text_11", os.date("!%Y-%m-%d %H:%M:%S", timeEnd)))
end
function NewServerReturnPanel:onItemRendererEvent(index, object)
	object:initData(index + 1, self.eventData[index + 1], self.btnHandle)
end
function NewServerReturnPanel:onShow()
	print("=======NewServerReturnPanel:onShow")
	self:initData()
end
function NewServerReturnPanel:onClickItem(tag)
	print("==onClickItem==", tag)
	self.curSelectIndex = tag
	for i, v in ipairs(self.eventData) do
		local component = self.fields[v.comName]
		if component then
			component:setVisible(false)
		end
	end
	local comName = self.eventData[tag].comName
	local component = self.fields[comName]
	if not component then
		component = fgui.UIPackage:createObject("NewServerReturn", comName)
		component:setSize(self.view:getWidth(), self.view:getHeight())
		self.fields[comName] = component
		self.comParent:addChildAt(component, self.comIndex)
	end
	component:setVisible(true)
end
function NewServerReturnPanel:onHide()
	print("=======NewServerReturnPanel:onHide")
	_ENV = "=======NewServerReturnPanel:onHide"
	;("=======NewServerReturnPanel:onHide").msg = "MESSAGE_NEWS_ERVER_BACK_RED_POINT"
	SoraDSendMessage("=======NewServerReturnPanel:onHide")
end
function NewServerReturnPanel:updateRedPoint(target, data)
	self.fields.List_event:setNumItems(table.nums(self.eventData))
end
function NewServerReturnPanel:removeActivityList(activityList)
	local refreshSelect = false
	local refreshList = false
	for i = #self.eventData, 1, -1 do
		local data = self.eventData[i]
		if table.indexof(activityList, data.activityID) then
			local component = self.fields[data.comName]
			if component then
				component:removeFromParent()
			end
			if self.curSelectIndex == i then
				refreshSelect = true
				self.fields.List_event:getChildAt(i - 1):setSelected(false)
			end
			table.remove(self.eventData, i)
			refreshList = true
		end
	end
	if refreshList then
		self.fields.List_event:setNumItems(table.nums(self.eventData))
	end
	if refreshSelect then
		self:resetActivityList()
	end
end
function NewServerReturnPanel:resetActivityList(showActivityId)
	self.fields.List_event:setNumItems(table.nums(self.eventData))
	local idx = 1
	if showActivityId then
		for key, value in pairs(self.eventData) do
			if value.activityID == showActivityId then
				idx = key
				break
			end
		end
	end
	self.fields.List_event:scrollToView(idx - 1)
	self.fields.List_event:getChildAt(idx - 1):setSelected(true)
	self:onClickItem(idx)
end
function NewServerReturnPanel:jumpToActivity(activityID)
	dump(activityID, "NewServerReturnPanel:jumpToActivity")
	if self.curSelectIndex then
		self.fields.List_event:getChildAt(self.curSelectIndex - 1):setSelected(false)
	end
	self:resetActivityList(activityID)
end
return NewServerReturnPanel
