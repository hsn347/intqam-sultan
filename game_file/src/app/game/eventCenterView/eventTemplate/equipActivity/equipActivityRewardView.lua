local weaponSprctrumRead = include("weaponSprctrumRead")
local equipActivityRewardView = class("equipActivityRewardView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("equipActivityRewardView")
	end
	return target
end)
function equipActivityRewardView:ctor()
	self.activityID = gActivityTimeActivityID.EQUIP_ACTIVITY
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Node_items = SoraDGetChildByName(self, "Node_items")
end
function equipActivityRewardView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function equipActivityRewardView:judgeClose()
	if self.activityID and not clientEventMgr.judgeIsOpen(self.activityID) then
		self:removeFromParent()
	end
end
function equipActivityRewardView:initData(rewardType, taskType)
	self.rewardType = rewardType
	self.taskType = taskType
	local weaponSprctrumRead, reward
	if self.rewardType == 2 then
		reward = weaponSprctrumRead.getFinalReward()
		self.ccs_bg:setTitleName(i18n("spectrum_text_05"))
		self.Text_tip:setString(i18n("spectrum_text_06"))
	else
		reward = weaponSprctrumRead.getTypeReward(self.taskType)
		self.ccs_bg:setTitleName(i18n("spectrum_text_03"))
		self.Text_tip:setString(i18n("spectrum_text_04"))
	end
	_UPVALUE2_ = i18n("spectrum_text_04")
	i18n("spectrum_text_04")[1] = "id"
	i18n("spectrum_text_04")[2] = "count"
	local rewardList = serviceFunctions.tableFormat(reward, i18n("spectrum_text_04"))
	for k, v in ipairs(rewardList) do
		local item = include("commonItemAward").new()
		item:setOwnView(self)
		item:initData(v.id, v.count)
		item:setBaseScale(1.0)
		item:setPosition(0, 0)
		item:addTo(self.Node_items)
	end
	SoraDToCenter(self.Node_items, 120)
end
return equipActivityRewardView
