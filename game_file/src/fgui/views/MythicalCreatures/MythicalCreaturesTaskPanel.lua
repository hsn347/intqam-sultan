local baseFguiPanel = require("fgui.base.baseFguiPanel")
local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
local divineBeastRead = include("divineBeastRead")
local MythicalCreaturesTaskPanel = class("MythicalCreaturesTaskPanel", baseFguiPanel)
function MythicalCreaturesTaskPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("MythicalCreaturesTaskPanel:ctor", self.viewName)
end
function MythicalCreaturesTaskPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MythicalCreaturesTaskPanel:onInit()
	print("=======MythicalCreaturesTaskPanel:onInit")
	if not SoraDFIsRA() then
		self.fields.Button_refresh:fixPos()
		self.fields.txt_num:fixPos()
		self.fields.btnSwitch:fixPos()
		self.fields.txtNum:fixPos()
		self.fields.icon:fixPos()
	end
	self.txt_notask = SoraDCreateTimerLabel(self, self.fields.txt_notask)
	self.txt_notask:setTimeLast(function(showTime, ticket)
		_ENV = nil
		;(nil).time = showTime
		return i18n("Divine_beast_text_45", nil)
	end)
	self.taskLimit = divineBeastCtrl:getTaskLimit()
	self.isReduce = false
	self.fields.btnSwitch:addClickListener(handler(self, self.onClickSwitch))
	self.fields.icon:setURL(include("publicRead").getIcon(510501))
	self:updateSwitch()
	self.fields.Panel_bg:setTitle(i18n("common_text_4498"))
	self.fields.Button_refresh:setTitle(i18n("alliance_mobilize_text_10"))
	self.fields.Button_refresh:addClickEventListener(handler(self, self.onClickRefresh))
	self.fields.List_task:setVirtual()
	self.fields.List_task:setItemRenderer(handler(self, self.onItemRenderer))
	self:updateView()
end
function MythicalCreaturesTaskPanel:onShow()
	print("=======MythicalCreaturesTaskPanel:onShow")
end
function MythicalCreaturesTaskPanel:updateView()
	self.dayTaskRewardCount = divineBeastCtrl:getDayTaskRewardCount()
	if self.dayTaskRewardCount >= self.taskLimit then
		self.controllers.c1:setSelectedIndex(1)
		self.txt_notask:beginTime(serviceFunctions.getTodayRemainTime())
	else
		self.controllers.c1:setSelectedIndex(0)
	end
	self.taskList = divineBeastCtrl:getSortList()
	dump(self.taskList, "MythicalCreaturesTaskPanel:updateView")
	self.fields.List_task:setNumItems(table.nums(self.taskList))
	self.dayRefreshCount = divineBeastCtrl:getDayRefreshCount()
	divineBeastCtrl = table.nums(self.taskList)
	table.nums(self.taskList).num1 = self.dayTaskRewardCount
	table.nums(self.taskList).num2 = self.taskLimit
	self.fields.txt_num:setString(i18n("Divine_beast_text_10", table.nums(self.taskList)))
	local refreshCfg = divineBeastRead.getRefreshCfg(self.dayRefreshCount + 1)
	self.cost = refreshCfg.cost
	self:updateItem()
end
function MythicalCreaturesTaskPanel:updateItem()
	local passCount = SoraDGetCtrl("backpackCtrl"):getItemCount(510501)
	_ENV = nil
	;(nil).num = fguiHelper.getColorString("#FFD43E", string.formatnumberthousands(passCount))
	self.fields.txtNum:setString(i18n("Actpass_text_02", nil))
	if self.cost[1] == nil then
		self.fields.Button_refresh:setCost(1001, 0)
	else
		self.fields.Button_refresh:setCost(self.cost[1].id, self.cost[1].num)
	end
end
function MythicalCreaturesTaskPanel:onItemRenderer(index, object)
	object:initData(self.taskList[index + 1])
	object:setHandler(handler(self, self.onClickGetAward))
	local itemID, count = divineBeastRead.getTaskFastPassCost(self.taskList[index + 1].taskID)
	object:setFastFinish(self.isReduce, itemID, count, handler(self, self.onClickFastFinish))
	if self.dayTaskRewardCount >= self.taskLimit then
		object.controllers.c1:setSelectedIndex(1)
	else
		object.controllers.c1:setSelectedIndex(0)
	end
end
function MythicalCreaturesTaskPanel:updateSwitch()
	self.controllers.c2:setSelectedIndex(self.isReduce and 1 or 0)
	self.fields.btnSwitch:setTitle(i18n(self.isReduce and "common_text_185" or "Actpass_text_01"))
	self.fields.btnSwitch:setBtnColorIndex(self.isReduce and 1 or 0)
end
function MythicalCreaturesTaskPanel:onClickSwitch()
	SoraDPlaySound()
	self.isReduce = not self.isReduce
	self:updateSwitch()
	self.fields.List_task:setNumItems(#self.taskList)
end
function MythicalCreaturesTaskPanel:onClickFastFinish(taskID)
	if not divineBeastCtrl:checkFastFinishTask(taskID) then
		return
	end
	local itemID, count = divineBeastRead.getTaskFastPassCost(taskID)
	local passCount = SoraDGetCtrl("backpackCtrl"):getItemCount(itemID)
	local isEnough = count <= passCount
	local needCount = math.max(0, count - passCount)
	local gold = needCount * gModuleMgr.sharedMgr("shopltCtrl"):getPrice(1000214)
	divineBeastCtrl = nil
	if isEnough then
		divineBeastCtrl = nil
		;(nil).num = count
		if i18n("Actpass_text_05", nil) then
			goto lbl_53
		end
	end
	divineBeastCtrl = nil
	;(nil).num = passCount
	;(nil).count = needCount
	::lbl_53::
	;(nil).msg = i18n("Actpass_text_08", nil)
	divineBeastCtrl, (nil).isEnough = i18n("Actpass_text_08", nil), isEnough
	i18n("Actpass_text_08", nil).gold = isEnough and count or gold
	i18n("Actpass_text_08", nil).title = i18n(isEnough and "Actpass_text_04" or "common_text_4436")
	i18n("Actpass_text_08", nil).costItemID = isEnough and itemID or 1001
	;(nil).param, i18n("Actpass_text_08", nil).checkGold = i18n("Actpass_text_08", nil), not isEnough
	;(nil).onConfirm = function()
		divineBeastCtrl:finishTaskWithPass(taskID, not isEnough and needCount or nil)
	end
	uiManager:show("dailyAwardPassView", nil)
end
function MythicalCreaturesTaskPanel:onClickRefresh()
	SoraDPlaySound()
	if self.dayTaskRewardCount >= self.taskLimit then
		_ENV = nil
		;(nil).time = serviceFunctions.getTodayRemainTime()
		SoraDShowMsgTip(i18n("Divine_beast_text_45", nil))
		return
	end
	local refreshFunc = function()
		if self.cost[1] == nil or SoraDEnoughGold(self.cost[1].num) then
			divineBeastCtrl:sendRefreshTask()
		end
	end
	if divineBeastCtrl:getIsHaveTaskFinished() then
		SoraDShowMsgBoxNew(i18n("Divine_beast_text_63"), i18n("common_text_204"), i18n("common_text_185"), function(type)
			if type == MSGBOX_CALLBACK_YES then
				refreshFunc()
			end
		end)
		return
	end
	refreshFunc()
end
function MythicalCreaturesTaskPanel:onClickGetAward(taskID)
	divineBeastCtrl:sendGetTaskReward(taskID)
end
function MythicalCreaturesTaskPanel:gameGuide_getTarget(itemName, parameters)
	if itemName == "Task_1" then
		local first_task = self.fields.List_task:getChildAt(0)
		if first_task then
			return first_task
		end
	end
	return self.fields[itemName]
end
return MythicalCreaturesTaskPanel
