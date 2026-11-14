local activityTimeRead = include("activityTimeRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CheatActivityPanel = class("CheatActivityPanel", baseFguiPanel)
function CheatActivityPanel:ctor(...)
	CheatActivityPanel.super.ctor(self, ...)
	print("CheatActivityPanel:ctor", self.viewName)
	self.debug = true
end
function CheatActivityPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "EventCenterView"
	end
	return self._packageList
end
function CheatActivityPanel:onInit()
	print("=======CheatActivityPanel:onInit")
	self.fields.Com_title:initData("查询所有活动", handler(self, self.onClickClose))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setVirtual()
	local _fields = fguiHelper.get_fields(self.fields.Label_input)
	self.fields.input = _fields.input
	_fields.input:addEventListener(fgui.UIEventType.Changed, handler(self, self.onInputChanged))
	_fields.input:setPrompt("输入活动ID或者活动名字")
end
function CheatActivityPanel:onShow()
	print("=======CheatActivityPanel:onShow")
	local _ENV, activityIDList = print, print
	for activityID, __ in pairs(clientEventMgr.eventFuncList) do
		table.insert(activityIDList, activityID)
	end
	table.sort(activityIDList, function(a, b)
		return b < a
	end)
	self.activityIDList = activityIDList
	self.activityIDShow = self.activityIDList
	self.fields.List:setNumItems(#self.activityIDShow)
	print("==#self.activityIDList==", #self.activityIDList)
end
function CheatActivityPanel:onItemRenderer(index, obj)
	local activityID = self.activityIDShow[index + 1]
	local cfg = activityTimeRead.getNormalEventConfig(activityID)
	activityTimeRead = activityID
	activityID.eventID = activityID
	activityID.eventName = cfg.name
	local activityID.flagIcon, data = cfg.icon, activityID
	local self = obj
	self.fields.Text_title:setString(data.eventName)
	self.fields.Sprite_eventIcon:setURL(data.flagIcon)
	self.fields.Com_new:setVisible(false)
	self.txtSingleTitle:setString(activityID)
	self:removeEventListeners()
	self:addClickListener(function(...)
		SoraDPlaySound()
		_ENV = nil
		;(nil).activityID = activityID
		uiManager:show("CheatActivityDetail", nil)
	end)
end
function CheatActivityPanel:onClickItem(EventContext)
	SoraDPlaySound()
	local obj = EventContext:getGObjectData()
	local childIndex = self.fields.List:getChildIndex(obj)
	local itemIndex = self.fields.List:childIndexToItemIndex(childIndex)
	local activityID = self.activityIDList[itemIndex + 1]
	local cfg = activityTimeRead.getNormalEventConfig(activityID)
	SoraDShowMsgTip(activityID .. "_" .. cfg.name)
end
function CheatActivityPanel:onInputChanged(...)
	local searchName = self.fields.input:getText()
	if searchName == "" then
		self.activityIDShow = self.activityIDList
		self.fields.List:setNumItems(#self.activityIDShow)
		return
	end
	local _ENV, ret = self.fields.List.setNumItems, self.fields.List.setNumItems
	for __, activityID in ipairs(self.activityIDList) do
		if string.find(tostring(activityID), searchName) then
			table.insert(ret, activityID)
		else
			local cfg = activityTimeRead.getNormalEventConfig(activityID)
			if string.find(cfg.name, searchName) then
				table.insert(ret, activityID)
			end
		end
	end
	self.activityIDShow = ret
	self.fields.List:setNumItems(#self.activityIDShow)
end
return CheatActivityPanel
