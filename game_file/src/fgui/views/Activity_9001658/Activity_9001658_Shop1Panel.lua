local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local activityExchangeMallCtrl = SoraDGetCtrl("activityExchangeMallCtrl")
local itemDesRead = include("itemDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001658_Shop1Panel = class("Activity_9001658_Shop1Panel", baseFguiPanel)
function Activity_9001658_Shop1Panel:ctor(...)
	Activity_9001658_Shop1Panel.super.ctor(self, ...)
	print("Activity_9001658_Shop1Panel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.EXCHANGE_ACTIVITY_9010002
	self.itemID = 871001
	self.needNum = 20
end
function Activity_9001658_Shop1Panel:onInit()
	print("=======Activity_9001658_Shop1Panel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	local needNum = self.needNum
	local curNum = backpackCtrl:getItemCount(self.itemID)
	if clientEventMgr.judgeIsOpen(self.activityID) then
		curNum = needNum
	end
	if needNum <= curNum then
		self.fields.Text_tip1:setString(i18n("BUBBLE_LEGEND_TEXT_33"))
	else
		local num = math.max(0, needNum - curNum)
		_ENV = i18n("BUBBLE_LEGEND_TEXT_33")
		i18n("BUBBLE_LEGEND_TEXT_33").color = "#FFD43E"
		local numStr = SoraDWrapHtmlTagByStyle(num, i18n("BUBBLE_LEGEND_TEXT_33"))
		_ENV = i18n("BUBBLE_LEGEND_TEXT_33")
		i18n("BUBBLE_LEGEND_TEXT_33").num = numStr
		self.fields.Text_tip1:setString(i18n("BUBBLE_LEGEND_TEXT_32", i18n("BUBBLE_LEGEND_TEXT_33")))
	end
	self.fields.List_bar:setNumItems(needNum)
	self.fields.bar:setMax(needNum)
	self.fields.Text_tip2:setString(i18n("BUBBLE_LEGEND_TEXT_100"))
end
function Activity_9001658_Shop1Panel:onShow()
	print("=======Activity_9001658_Shop1Panel:onShow")
	self:updateActivityState()
end
function Activity_9001658_Shop1Panel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("BUBBLE_LEGEND_TEXT_31")
	uiManager:show("RuleView", nil)
end
function Activity_9001658_Shop1Panel:updateItemCount(...)
	local curNum = backpackCtrl:getItemCount(self.itemID)
	if clientEventMgr.judgeIsOpen(self.activityID) then
		curNum = self.needNum
	end
	self.fields.bar:setValue(curNum)
	self.fields.Com_have:initData(self.itemID)
end
function Activity_9001658_Shop1Panel:updateExchangeList(...)
	self.dataList = activityExchangeMallCtrl:getConfigByActivityID(self.activityID)
	self.fields.List:setNumItems(#self.dataList)
end
function Activity_9001658_Shop1Panel:onItemRenderer(index, obj)
	local data = self.dataList[index + 1]
	obj:initData(data)
end
function Activity_9001658_Shop1Panel:onMsgExchangeMallRefresh(...)
	self:updateItemCount()
	self:updateExchangeList()
end
function Activity_9001658_Shop1Panel:updateActivityState(...)
	if clientEventMgr.judgeIsOpen(self.activityID) then
		self.fields.n9:setVisible(false)
		self.fields.Text_tip1:setVisible(false)
		self.fields.Text_tip2:setVisible(false)
	else
		self.fields.n9:setVisible(true)
		self.fields.Text_tip1:setVisible(true)
		self.fields.Text_tip2:setVisible(true)
	end
	self:updateItemCount()
	self:updateExchangeList()
end
return Activity_9001658_Shop1Panel
