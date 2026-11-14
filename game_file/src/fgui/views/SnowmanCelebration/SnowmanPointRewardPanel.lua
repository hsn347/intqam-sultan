local snowmanCelebrationCtrl = SoraDGetCtrl("snowmanCelebrationCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SnowmanPointRewardPanel = class("SnowmanPointRewardPanel", baseFguiPanel)
function SnowmanPointRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("SnowmanPointRewardPanel:ctor", self.viewName)
end
function SnowmanPointRewardPanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Activity2112"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
	end
	return self._packageList
end
function SnowmanPointRewardPanel:onInit()
	print("=======SnowmanPointRewardPanel:onInit")
	self.fields.Button_normal:addClickListener(handler(self, self.onClickHandle))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.functionCol = self:initFunc()
end
function SnowmanPointRewardPanel:initData(data)
	print("=======SnowmanPointRewardPanel:initData")
	self.fields.Text_title:setString(data.title)
	self.fields.Text_tip:setString(data.tip)
	self.fields.Button_normal:setText(data.btnText)
	self.data = data.data
	if not self.data then
		_ENV = self.data
	end
	self.fields.List_reward:setNumItems(table.nums(self.data))
	self.handle = data.handle
	self:setButtonAndTimes(data.hadReward, data.times)
end
function SnowmanPointRewardPanel:setButtonAndTimes(enable, timesStr)
	self.fields.Button_normal:setGrayed(not enable)
	snowmanCelebrationCtrl = self.fields.Button_normal.setGrayed
	self.fields.Button_normal.setGrayed.visible = snowmanCelebrationCtrl:isHaveBoxReward()
	local self.fields.Button_normal.setGrayed.num, data = snowmanCelebrationCtrl:getcanReceiveNum(), self.fields.Button_normal.setGrayed
	self.fields.Button_normal:setRedDot(data)
	self.fields.Button_normal:setEnabled(enable)
	if timesStr then
		self.fields.Text_time:setString(timesStr)
	end
end
function SnowmanPointRewardPanel:onItemRenderer(index, object)
	object:initData(self.data[index + 1].id, self.data[index + 1].count)
end
function SnowmanPointRewardPanel:initFunc()
	_ENV = nil
	;(nil).reward = function()
		self:setButtonAndTimes(self.data.enable, self.data.timesStr)
		self:showRewards()
	end
	;(nil).notOpen = function()
		SoraDShowMsgTip(i18n("devilvalley_text_08"))
	end
	local (nil).noReward, functionCol = function()
		SoraDShowMsgTip(i18n("Snowman_Activity_10"))
	end, nil
	return functionCol
end
function SnowmanPointRewardPanel:showRewards()
	if not self.rewards then
		return
	end
	local _ENV, t = self.rewards, self.rewards
	for i, v in pairs(self.rewards) do
		if v.id then
			table.insert(t, v)
		end
	end
	SoraDMailGainItems(t, true)
end
function SnowmanPointRewardPanel:refreshView(data)
	if not data then
		return
	end
	dump(data, "SnowmanPointRewardPanel:refreshView")
	self.data = data
	self.rewards = data.rewards
	local fun = self.functionCol[data.subMsg]
	if fun then
		fun()
	end
end
function SnowmanPointRewardPanel:onClickHandle()
	self.handle()
end
function SnowmanPointRewardPanel:onShow()
	print("=======SnowmanPointRewardPanel:onShow")
	self:initData(self.proxy.param)
end
function SnowmanPointRewardPanel:onHide()
	print("=======SnowmanPointRewardPanel:onHide")
end
function SnowmanPointRewardPanel:onDispose()
	print("=======SnowmanPointRewardPanel:onDispose")
end
return SnowmanPointRewardPanel
