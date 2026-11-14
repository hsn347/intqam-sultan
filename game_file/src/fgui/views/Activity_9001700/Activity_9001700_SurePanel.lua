local activity_9001700_Read = include("activity_9001700_Read")
local activity_9001700_Ctrl = SoraDGetCtrl("activity_9001700_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001700_SurePanel = class("Activity_9001700_SurePanel", baseFguiPanel)
function Activity_9001700_SurePanel:ctor(...)
	self.isLRU = true
	Activity_9001700_SurePanel.super.ctor(self, ...)
	print("Activity_9001700_SurePanel:ctor", self.viewName)
end
function Activity_9001700_SurePanel:onInit()
	print("=======Activity_9001700_SurePanel:onInit")
	self.fields.Text_remind:setString(i18n("coffeeCraftsman_text_27"))
	self.fields.Button_send:setString(i18n("common_text_204"))
	self.fields.Button_send:addClickListener(handler(self, self.onClickBtnSend))
	self.fields.Button_cancel:setString(i18n("common_text_185"))
	self.fields.Button_cancel:addClickListener(handler(self, self.onClickClose))
	self.fields.Text_reward:setString(i18n("eid_fireworks_025"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRewardRenderer))
end
function Activity_9001700_SurePanel:endShow()
	print("=======Activity_9001700_SurePanel:endShow")
	self.fields.Check_tick:setSelected(false)
	self.isMake = self.param.isMake
	if self.isMake then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Panel_bg2:setString(i18n("eid_fireworks_008"))
		self.fields.Text_send:setString(i18n("eid_fireworks_026"))
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Panel_bg:setString(i18n("eid_fireworks_014"))
		local data = self.param.data
		self.data = data
		if data then
			local playerName = textParser.formatPlayerName(nil, data.nickName, data.kid)
			_ENV = data.kid
			data.kid.color = "#70C723"
			playerName = SoraDWrapHtmlTagByStyle(playerName, data.kid)
			local nameStr = i18n("eid_fireworks_018") .. playerName
			self.fields.Text_send:setString(nameStr)
		end
	end
	local idx = self.param.idx
	self.idx = idx
	if idx then
		local fireWorksID = activity_9001700_Ctrl:getMakedSaluteIdByIdx(idx)
		self.fields.Com_firework:initFireWorksID(fireWorksID)
	end
	local fireWorksID = self.param.fireWorksID
	if fireWorksID then
		self.fields.Com_firework:initFireWorksID(fireWorksID)
		if self.isMake then
			self.fireWorksID = fireWorksID
			self.rewardList = activity_9001700_Read.getFireWorksReward(fireWorksID)
			self.fields.List_reward:setNumItems(#self.rewardList)
		end
	end
end
function Activity_9001700_SurePanel:onClickBtnSend(...)
	SoraDPlaySound()
	if self.fields.Check_tick:isSelected() then
		local dailyRemindManager = include("dailyRemindManager")
		local rType
		if self.isMake then
			rType = dailyRemindManager.REMIND_TYPE.activity_9001770_1
		else
			rType = dailyRemindManager.REMIND_TYPE.activity_9001770_2
		end
		dailyRemindManager.addRemindToManager(rType)
	end
	if self.isMake then
		activity_9001700_Ctrl:reqMake(self.fireWorksID)
	else
		activity_9001700_Ctrl:reqGive(self.idx, self.data.uid)
	end
	local parentPanel = self.param.parentPanel
	if parentPanel then
		SoraDShowLoading(parentPanel)
	end
	self:closePanel()
end
function Activity_9001700_SurePanel:onItemRewardRenderer(index, obj)
	local reward = self.rewardList[index + 1]
	obj:initData(reward.id, reward.count)
end
return Activity_9001700_SurePanel
