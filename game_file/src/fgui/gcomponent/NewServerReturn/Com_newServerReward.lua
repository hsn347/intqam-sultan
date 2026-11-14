local newServerReturnltCtrl = include("newServerReturnltCtrl")
local newStartMainCtrl = SoraDGetCtrl("newStartMainCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_newServerReward = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewServerReturn/Com_newServerReward", Com_newServerReward)
function Com_newServerReward:onInit()
	self.activityID = gActivityTimeActivityID.NEW_START_REWARD_ACTIVITY
	local proxy = uiManager:getOrCreateProxy("NewServerReturn")
	proxy:initActivityTime(self.fields.Label_time, self.activityID)
	self.fields.Text_tip:setString(i18n("newstart_text_13"))
	self.fields.Text_tip2:setString(i18n("newstart_text_14"))
	self.rewardData = newServerReturnltCtrl.getNewServerReward().newStartReward
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_reward:setNumItems(table.nums(self.rewardData) / 2)
	self.fields.Button_get:addClickListener(handler(self, self.onClickGet))
	self:initData()
end
function Com_newServerReward:registerEvent(...)
	SoraDAddMessage(self, "MESSAGE_NEW_START_GETREWARD_BACK", handler(self, self.onMsgGetRewardBack))
end
function Com_newServerReward:onClickGet()
	SoraDPlaySound()
	newStartMainCtrl:reqNewStartReward()
	SoraDShowLoading()
end
function Com_newServerReward:initData()
	local data = newStartMainCtrl:getActivityData(self.activityID)
	local inheritGoldPro = newServerReturnltCtrl.getNewServerReward().inheritGoldPro
	local num = math.floor(data.gold * inheritGoldPro / 1000)
	self.fields.Text_cost:setString(string.formatnumberthousands(num))
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		self.fields.Button_get:setTitleText(i18n("common_text_1892"))
		self.fields.Button_get:setEnabled(false)
	elseif data.isReward then
		self.fields.Button_get:setTitleText(i18n("common_text_1892"))
		self.fields.Button_get:setEnabled(false)
	else
		self.fields.Button_get:setTitleText(i18n("common_text_854"))
		self.fields.Button_get:setEnabled(true)
	end
end
function Com_newServerReward:onItemRenderer(index, object)
	object:initData(self.rewardData[index * 2 + 1], self.rewardData[index * 2 + 2])
end
function Com_newServerReward:onShow()
end
function Com_newServerReward:onMsgGetRewardBack(...)
	local data = newStartMainCtrl:getActivityData(self.activityID)
	if data.isReward then
		self.fields.Button_get:setTitleText(i18n("common_text_1892"))
		self.fields.Button_get:setEnabled(false)
	end
end
return Com_newServerReward
