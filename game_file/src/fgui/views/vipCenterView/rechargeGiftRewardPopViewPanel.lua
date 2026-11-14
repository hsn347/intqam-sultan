local publicRead = include("publicRead")
local rechargeRead = include("rechargeRead")
local rechargeGiftRead = gModuleMgr.sharedMgr("rechargeGiftRead")
local rechargeActivityCtrl = SoraDGetCtrl("rechargeActivityCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local rechargeGiftRewardPopViewPanel = class("rechargeGiftRewardPopViewPanel", baseFguiPanel)
function rechargeGiftRewardPopViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("rechargeGiftRewardPopViewPanel:ctor", self.viewName)
end
function rechargeGiftRewardPopViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function rechargeGiftRewardPopViewPanel:onInit()
	print("=======rechargeGiftRewardPopViewPanel:onInit")
	self.activityID = gActivityTimeActivityID.RECHARGE_ACTIVITY_GIFT_ACTIVITY
	self.fields.Text_ActivityName:setString(i18n("activity_name_9001266"))
	self.fields.Text_ActivityName:enableGradient(cc.c3b(254, 253, 242), cc.c3b(247, 210, 63))
	self.fields.Text_ActivityName:enableShadow(cc.c3b(15, 6, 2), cc.size(2, -2))
	self.fields.Text_Tips:setString(i18n("rechargeGift_text_02"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.timer:getChildByName("icon_hourglass"):setScale(0.8)
	self.fields.Text_num:setAlign(0)
end
function rechargeGiftRewardPopViewPanel:onItemRenderer(index, obj)
	obj:initData(self.rechargeIDList[index + 1])
end
function rechargeGiftRewardPopViewPanel:onShow()
	print("=======rechargeGiftRewardPopViewPanel:onShow")
	self.rechargeIDList = self.param.rechargeIDList
	self:initActivityTime()
	self:initData()
end
function rechargeGiftRewardPopViewPanel:initData()
	if not self.rechargeIDList then
		_ENV = self.rechargeIDList
	end
	local nums = math.min(table.nums(self.rechargeIDList), 3)
	if 1 < nums then
		self.controllers.c1:setSelectedIndex(1)
		self:showMoreReward()
	else
		self.controllers.c1:setSelectedIndex(0)
		self:showOneReward()
	end
	self.fields.n1:fixPos()
	self.fields.n1:fix()
	self.fields.timer:fixPos()
end
function rechargeGiftRewardPopViewPanel:showOneReward()
	local rewardList = rechargeActivityCtrl:getRechargeGift(self.rechargeIDList[1].rechargeID)
	if next(rewardList) then
		self.fields.item:setVisible(true)
		self.fields.item:initData(rewardList[1].id)
		self.fields.Text_num:setString("x" .. string.formatnumberthousands(rewardList[1].count))
	else
		self.fields.item:setVisible(false)
	end
end
function rechargeGiftRewardPopViewPanel:showMoreReward()
	self.fields.List:setNumItems(#self.rechargeIDList)
end
function rechargeGiftRewardPopViewPanel:initActivityTime()
	self.eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
	if self.eventTime then
		self.fields.timer:beginTime(self.eventTime.timerNode.timer:getRemainTime())
	end
end
function rechargeGiftRewardPopViewPanel:msgCallBack(target, data)
	if not clientEventMgr.judgeIsOpen(self.activityID) then
		self:close()
	end
end
return rechargeGiftRewardPopViewPanel
