local activity_9001611_Ctrl = SoraDGetCtrl("activity_9001611_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001611_rewardPanel = class("Activity_9001611_rewardPanel", baseFguiPanel)
function Activity_9001611_rewardPanel:ctor(...)
	Activity_9001611_rewardPanel.super.ctor(self, ...)
	print("Activity_9001611_rewardPanel:ctor", self.viewName)
end
function Activity_9001611_rewardPanel:onInit()
	print("=======Activity_9001611_rewardPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_777"))
	self.fields.Btn_go:setString(i18n("common_text_477"))
	self.fields.Btn_go:addClickListener(handler(self, self.btnGoClick))
	self.view:fixChildrenPos()
end
function Activity_9001611_rewardPanel:onShow()
	print("=======Activity_9001611_rewardPanel:onShow")
	self.data = self.param.data
	self.fields.icon:setSpriteFrame(self.data.icon)
	self.fields.Text_name:setString(i18n(self.data.name))
	local parameter = self.data.parameter
	if self.data.type == 6 then
		parameter = math.floor(parameter / 3600)
	end
	_ENV = i18n(self.data.name)
	i18n(self.data.name).num = parameter
	self.fields.Text_des:setString(i18n(self.data.des, i18n(self.data.name)))
	self.fields.Btn_go:setVisible(self.data.jump ~= 0 or self.data.type == 9)
	local times = math.min(self.data.quest, activity_9001611_Ctrl:getTimes(self.data.type))
	_ENV = activity_9001611_Ctrl:getTimes(self.data.type)
	_ENV = activity_9001611_Ctrl:getTimes(self.data.type)
	activity_9001611_Ctrl:getTimes(self.data.type).var1 = times
	activity_9001611_Ctrl:getTimes(self.data.type).var2 = self.data.quest
	activity_9001611_Ctrl:getTimes(self.data.type).times = fguiHelper.getColorString("#E02B2B", i18n("%{var1}/%{var2}", activity_9001611_Ctrl:getTimes(self.data.type)))
	self.fields.Text_done:setString(i18n("Player_Return_test10", activity_9001611_Ctrl:getTimes(self.data.type)))
	_ENV = i18n("Player_Return_test10", activity_9001611_Ctrl:getTimes(self.data.type))
	_ENV = i18n("Player_Return_test10", activity_9001611_Ctrl:getTimes(self.data.type))
	i18n("Player_Return_test10", activity_9001611_Ctrl:getTimes(self.data.type)).var1 = times * self.data.point
	i18n("Player_Return_test10", activity_9001611_Ctrl:getTimes(self.data.type)).var2 = self.data.quest * self.data.point
	i18n("Player_Return_test10", activity_9001611_Ctrl:getTimes(self.data.type)).point = fguiHelper.getColorString("#E02B2B", i18n("%{var1}/%{var2}", i18n("Player_Return_test10", activity_9001611_Ctrl:getTimes(self.data.type))))
	self.fields.Text_gain:setString(i18n("Player_Return_test11", i18n("Player_Return_test10", activity_9001611_Ctrl:getTimes(self.data.type))))
end
function Activity_9001611_rewardPanel:btnGoClick()
	SoraDPlaySound()
	if self.data.type == 9 then
	elseif self.data.jump ~= 0 then
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		_ENV = nil
		mildGuideManager:starMildByNewPlayerQuestID(self.data.jump, nil)
		SoraDRemoveAllPanelFromManager()
	end
end
return Activity_9001611_rewardPanel
