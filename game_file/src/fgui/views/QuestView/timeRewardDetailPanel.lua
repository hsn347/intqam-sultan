local publicRead = include("publicRead")
local timeRewardCtrl = SoraDGetCtrl("timeRewardCtrl")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local timeRewardDetailPanel = class("timeRewardDetailPanel", baseFguiPanel)
function timeRewardDetailPanel:ctor(...)
	self.super.ctor(self, ...)
	print("timeRewardDetailPanel:ctor", self.viewName)
end
function timeRewardDetailPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function timeRewardDetailPanel:onInit()
	print("=======timeRewardDetailPanel:onInit")
	self.fields.Button_getReward:addClickListener(handler(self, self.getReward))
	self.fields.Button_getReward:setTitleText(i18n("common_text_854"))
	self.fields.Text_LeftTime:setTimeLast(function(ticket)
		return i18n("common_text_698") .. "\n" .. ticket
	end)
	self.fields.Text_LeftTime:setTimeEndListener(function()
		self.fields.Text_LeftTime:setVisible(false)
		self.fields.Button_getReward:setVisible(true)
	end)
end
function timeRewardDetailPanel:onShow()
	print("=======timeRewardDetailPanel:onShow")
	self:initData(self.proxy.param)
end
function timeRewardDetailPanel:initData(param)
	_ENV = nil
	;(nil).name = publicRead.getName(param.itemID)
	;(nil).num = param.num
	self.fields.Text_name:setString(i18n("common_text_938", nil))
	self.fields.Text_detail:setString(publicRead.getDes(param.itemID))
	self.fields.Com_item:initData(param.itemID)
	if param.isCanGetReward then
		self:checkTime(param.isCanGetReward)
	end
end
function timeRewardDetailPanel:checkTime(isCanGetReward)
	if isCanGetReward == 1 then
		self.fields.Text_LeftTime:setVisible(true)
		self.fields.Button_getReward:setVisible(false)
		local mainTimer = queueCtrl:queryQueue(gQueueTypeDef.time_reward)
		if mainTimer then
			self.fields.Text_LeftTime:beginTime(mainTimer.timerNode.timer:getRemainTime())
		else
			self.fields.Text_LeftTime:setVisible(false)
			self.fields.Button_getReward:setVisible(true)
		end
	end
end
function timeRewardDetailPanel:getReward(button, type)
	SoraDPlaySound("uicontrol", 40)
	timeRewardCtrl:receiveReward()
	self:close()
end
return timeRewardDetailPanel
