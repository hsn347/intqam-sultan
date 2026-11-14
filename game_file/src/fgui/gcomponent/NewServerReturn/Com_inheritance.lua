local inheritGiftCtrl = SoraDGetCtrl("inheritGiftCtrl")
local newServerReturnltCtrl = include("newServerReturnltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_inheritance = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewServerReturn/Com_inheritance", Com_inheritance)
function Com_inheritance:onInit()
	inheritGiftCtrl:reqWealthInheritInit()
	self.activityID = gActivityTimeActivityID.WEALTH_ACTIVITY
	local proxy = uiManager:getOrCreateProxy("NewServerReturn")
	proxy:initActivityTime(self.fields.Label_time, self.activityID)
	self.fields.btn_detail:addClickListener(handler(self, self.onClickDetail))
	self.fields.List_inheritWealth:setItemRenderer(handler(self, self.onItemRenderer))
	self:initData()
end
function Com_inheritance:initData()
	_ENV = nil
	;(nil).num = inheritGiftCtrl:getInheritPoint()
	self.fields.Text_own:setString(i18n("common_text_531", nil))
	self.stage = inheritGiftCtrl:getInheritStage()
	self.type = inheritGiftCtrl:getInheritGroupType()
	local rewardGross = newServerReturnltCtrl.getInheritWealthRewardGrossByStage(self.stage)
	_ENV = i18n("common_text_531", nil)
	i18n("common_text_531", nil).num = rewardGross
	self.fields.Text_tip:setString(i18n("newstart_text_17", i18n("common_text_531", nil)))
	self.taskTypeList = newServerReturnltCtrl.getInheritWealthTaskByStage(self.stage, self.type)
	self.taskList = inheritGiftCtrl:getTaskList(self.taskTypeList)
	self.fields.List_inheritWealth:setNumItems(table.nums(self.taskList))
end
function Com_inheritance:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_CLAIM_REWARD", handler(self, self.onUpdateTask))
	SoraDAddMessage(self, "MESSAGE_ACTIVITY_MODULE_UPDATE_TASK", handler(self, self.onUpdateTask))
	SoraDAddMessage(self, "MESSAGE_WEALTH_INHERIT_REFRESH", handler(self, self.onUpdateView))
end
function Com_inheritance:onUpdateTask()
	self:initData()
end
function Com_inheritance:onUpdateView(target, data)
	if data.subMsg == "initData" then
		self:initData()
	end
end
function Com_inheritance:onItemRenderer(index, object)
	object:initData(self.taskList[index + 1])
	object:setHandler(handler(self, self.onClickGetAward), nil)
end
function Com_inheritance:onClickGetAward(taskID)
	SoraDPlaySound()
	inheritGiftCtrl:reqWealthInheritReward(taskID)
end
function Com_inheritance:onClickDetail()
	SoraDPlaySound()
	uiManager:show("GiftOfSultan"):setOwnerKey(self)
end
function Com_inheritance:onShow()
end
return Com_inheritance
