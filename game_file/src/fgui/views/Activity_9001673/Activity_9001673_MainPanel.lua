local activity_9001673_Ctrl = SoraDGetCtrl("activity_9001673_Ctrl")
local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001673_MainPanel = class("Activity_9001673_MainPanel", baseFguiPanel)
function Activity_9001673_MainPanel:ctor(...)
	Activity_9001673_MainPanel.super.ctor(self, ...)
	print("Activity_9001673_MainPanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.RECHARGE_INTERFACE_ACTIVITY
end
function Activity_9001673_MainPanel:onInit()
	print("=======Activity_9001673_MainPanel:onInit")
	self.fields.Com_title:initData(i18n("activity_name_9001673"), handler(self, self.onClickClose))
	self.fields.Com_title:initSpecialActivityTime(activity_9001673_Ctrl:getReaminTime())
	self.fields.Text_talk:setString(i18n("new_recharge_ui_text_01"))
	self.fields.Text_switchCD:setString(i18n("new_recharge_ui_text_02"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Label_time:setTimeEndListener(function()
		self:stageTwo()
	end)
	self.fields.Button_reward:addClickListener(handler(self, self.btnRewardClick))
	self.fields.Button_switch:setString(i18n("new_recharge_ui_text_03"))
	self.fields.Button_switch:addClickListener(handler(self, self.btnSwitchClick))
end
function Activity_9001673_MainPanel:onShow()
	print("=======Activity_9001673_MainPanel:onShow")
	_UPVALUE2_ = "RECHARGE_PUSH_REWARD"
	;("RECHARGE_PUSH_REWARD")[1] = "id"
	;("RECHARGE_PUSH_REWARD")[2] = "count"
	self.reward = serviceFunctions.tableFormat(constantRead.getConstValueArray("RECHARGE_PUSH_REWARD"), "RECHARGE_PUSH_REWARD")
	self.fields.List:setNumItems(#self.reward)
	self:initData()
end
function Activity_9001673_MainPanel:onItemRenderer(index, obj)
	obj:getChild("Com_item"):initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
function Activity_9001673_MainPanel:initData()
	local ret, doStage, stageTime = activity_9001673_Ctrl:checkStage()
	if ret then
		if doStage == 0 then
			self:stageOne(stageTime)
		elseif doStage == 1 then
			self:stageTwo()
		end
	else
		self:close()
	end
end
function Activity_9001673_MainPanel:stageOne(stageTime)
	self.controllers.c1:setSelectedIndex(0)
	self.fields.Label_time:beginTime(stageTime)
	self.fields.Label_timeClaim:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n("commandhall_text_78", nil)
	end)
	self.fields.Label_timeClaim:beginTime(stageTime)
end
function Activity_9001673_MainPanel:stageTwo()
	self.controllers.c1:setSelectedIndex(1)
	self.isGetAward = activity_9001673_Ctrl:isGetReward()
	self.fields.Button_reward:setString(self.isGetAward and i18n("common_text_1892") or i18n("cavalryrise_text_06"))
	self.fields.Button_reward:setBright(not self.isGetAward)
	self.fields.Button_reward:setReddot(not self.isGetAward)
end
function Activity_9001673_MainPanel:onMsgUpdateData(target, data)
	SoraDCloseLoading(self)
	self:initData()
end
function Activity_9001673_MainPanel:btnRewardClick()
	SoraDPlaySound()
	if self.isGetAward then
		SoraDShowMsgTip(i18n("Stellar_Odyssey_text_03"))
		return
	end
	SoraDShowLoading(self)
	activity_9001673_Ctrl:reqRewardMsg()
end
function Activity_9001673_MainPanel:btnSwitchClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).jumpName = "recharge"
	;(nil).showRechargeFinger = true
	uiManager:show("gameOptions", nil)
end
return Activity_9001673_MainPanel
