local ramadanSurpriseCtrl = SoraDGetCtrl("ramadanSurpriseCtrl")
local ramadanSurpriseltCtrl = include("ramadanSurpriseltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RamadanSurprisePanel = class("RamadanSurprisePanel", baseFguiPanel)
function RamadanSurprisePanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("RamadanSurprisePanel:ctor", self.viewName)
end
function RamadanSurprisePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RamadanSurprisePanel:onInit()
	print("=======RamadanSurprisePanel:onInit")
	self.functionCol = self:initFunc()
	ramadanSurpriseCtrl:sendDataMsg()
	self.activityID = gActivityTimeActivityID.RAMADAN_SURPRISE_ACTIVITY
	self.fields.Label_time:setTimeLast(function(strTime)
		_ENV = nil
		_ENV, _ENV, (nil).time = nil, nil, strTime
		_ENV, (nil).time, (nil).color = nil, nil, "#FFFFFF"
		;(nil).__default, (nil).color = nil, "#FFC864"
		return i18n_html("Tycoon_text_25", nil, nil)
	end)
	self.fields.Label_time:initActivityTime(self.activityID)
	self.fields.Com_title:initData(i18n("activity_name_9001417"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.userSelect, _ENV = self.fields.Com_title.initData, self.fields.Com_title.initData
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRendererRewardSelect))
	self.fields.List_task:setItemRenderer(handler(self, self.onItemRendererTask))
end
function RamadanSurprisePanel:initData()
	self.selectState = ramadanSurpriseCtrl:isSelectedAlready()
	ramadanSurpriseCtrl = nil
	;(nil).num = fguiHelper.getColorString("#FFDF2D", ramadanSurpriseCtrl:getCurScore())
	self.fields.Text_score:setString(i18n("common_text_2557", nil))
	self.fields.Com_progress:setValue(ramadanSurpriseCtrl:getCurScore(), ramadanSurpriseltCtrl.getMaxTaskScore())
	self.fields.List_reward:setNumItems(ramadanSurpriseltCtrl.getSelectRewardGradeCount())
	self.taskTypeList = ramadanSurpriseCtrl:getQuestId()
	dump(self.taskTypeList, "fsdklfkldfkdlfkdlfkld")
	self.taskList = ramadanSurpriseCtrl:getTaskList(self.taskTypeList)
	dump(self.taskList, "fsdklfkldfkdlfkdlfkld")
	self.fields.List_task:setNumItems(4)
end
function RamadanSurprisePanel:onItemRendererRewardSelect(index, obj)
	dump(index, "fsjkfkdfjkdj")
	obj:initData(index + 1)
end
function RamadanSurprisePanel:refreshTask()
	self.selectState = ramadanSurpriseCtrl:isSelectedAlready()
	self.taskTypeList = ramadanSurpriseCtrl:getQuestId()
	dump(self.taskTypeList, "fsdklfkldfkdlfkdlfkld")
	self.taskList = ramadanSurpriseCtrl:getTaskList(self.taskTypeList)
	dump(self.taskList, "fsdklfkldfkdlfkdlfkld")
	self.fields.List_task:setNumItems(4)
end
function RamadanSurprisePanel:onItemRendererTask(index, obj)
	if self.selectState and ramadanSurpriseCtrl:getTaskRefrshTimeByIndex(index + 1) then
		local time = ramadanSurpriseCtrl:getTaskRefrshTimeByIndex(index + 1)
		dump(time, "RamadanSurprisePanel:onItemRendererTask")
		obj:setInWaiting(time)
	elseif self.selectState then
		obj:initData(self.taskList[index + 1])
	else
		obj:setTip()
	end
end
function RamadanSurprisePanel:refreshTime()
end
function RamadanSurprisePanel:initFunc()
	_ENV = nil
	;(nil).init = function()
		self:initData()
	end
	;(nil).reward = function()
		self:initData()
		if self.rewards and next(self.rewards) then
			SoraDMailGainItems(self.rewards, true)
		end
	end
	;(nil).update = function()
		self:refreshData()
	end
	;(nil).task = function()
		self:refreshTask()
	end
	local (nil).notOpen, functionCol = function()
		SoraDShowMsgTip(i18n("common_text_2486"))
	end, nil
	return functionCol
end
function RamadanSurprisePanel:refreshView(data)
	if not data then
		return
	end
	dump(data, "RamadanSurprisePanel:refreshView")
	self.rewards = data.reward
	local fun = self.functionCol[data.subMsg]
	if fun then
		fun()
	end
end
function RamadanSurprisePanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("ramadan_surprise_09")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function RamadanSurprisePanel:onShow()
	print("=======RamadanSurprisePanel:onShow")
end
function RamadanSurprisePanel:onHide()
	print("=======RamadanSurprisePanel:onHide")
end
function RamadanSurprisePanel:onDispose()
	print("=======RamadanSurprisePanel:onDispose")
end
return RamadanSurprisePanel
