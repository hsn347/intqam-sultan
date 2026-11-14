local crossDecryptionCtrl = SoraDGetCtrl("anniversaryCrossDecryptionCtrl")
local crossDecryptionRead = include("crossDecryptionRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DecryptionLineRewardPopPanel = class("DecryptionLineRewardPopPanel", baseFguiPanel)
function DecryptionLineRewardPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("DecryptionLineRewardPopPanel:ctor", self.viewName)
end
function DecryptionLineRewardPopPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "DecryptionNew"
	end
	return self._packageList
end
function DecryptionLineRewardPopPanel:onInit()
	print("=======DecryptionLineRewardPopPanel:onInit")
	dump(self.param, "self.param=======")
	if self.param.activityID and self.param.activityID == gActivityTimeActivityID.CROSS_MISSION_2022_ACTIVITY then
	end
	self.idx = self.param.idx
	self.controllers.c1:setSelectedIndex(self.idx == 9 and 1 or 0)
	self.fields.bg:setTitle(i18n("decrypt_text_03"))
	self.fields.Text_des:setString(i18n("anniversary_cross_text_05"))
	self.fields.List_award:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Btn_reward:setString(i18n("common_text_854"))
	self.fields.Btn_reward:addClickListener(handler(self, self.onClickReward))
end
function DecryptionLineRewardPopPanel:onShow()
	print("=======DecryptionLineRewardPopPanel:onShow")
	if not crossDecryptionCtrl:getRewardData() then
		_ENV = crossDecryptionCtrl:getRewardData()
	end
	self.rewardData = crossDecryptionCtrl:getRewardData()
	if self.idx == 9 then
		self.canReceive = crossDecryptionCtrl:checkBigAward()
	else
		self.canReceive = crossDecryptionCtrl:checkCurBoxStatus(self.idx)
	end
	self.activityID = crossDecryptionCtrl:getActivityType()
	if not crossDecryptionRead.getRewardByLine(self.idx, self.activityID).Reward then
		_ENV = crossDecryptionRead.getRewardByLine(self.idx, self.activityID).Reward
	end
	self.rewards = crossDecryptionRead.getRewardByLine(self.idx, self.activityID).Reward
	dump(self.canReceive, "self.canReceive====")
	dump(self.rewardData, "self.rewardData====")
	self.fields.List_award:setNumItems(#self.rewards)
	self.fields.Btn_reward:setBright(self.canReceive)
	if self.canReceive then
		self.fields.Btn_reward:setTitleColor(cc.c3b(255, 255, 255))
		self.fields.Btn_reward:setTitleText(i18n("common_text_854"))
	else
		self.fields.Btn_reward:setTitleColor(cc.c3b(110, 110, 110))
		if self.rewardData[tostring(self.idx)] then
			self.fields.Btn_reward:setTitleText(i18n("common_text_1892"))
		else
			self.fields.Btn_reward:setTitleText(i18n("common_text_854"))
		end
	end
end
function DecryptionLineRewardPopPanel:onHide()
	print("=======DecryptionLineRewardPopPanel:onHide")
end
function DecryptionLineRewardPopPanel:onDispose()
	print("=======DecryptionLineRewardPopPanel:onDispose")
end
function DecryptionLineRewardPopPanel:onItemRenderer(index, obj)
	local item = self.rewards[index + 1]
	obj:initData(item.id, item.count)
end
function DecryptionLineRewardPopPanel:onClickReward()
	SoraDPlaySound()
	print("领取奖励=======")
	if self.canReceive then
		_ENV = nil
		;(nil).index = self.idx
		crossDecryptionCtrl:reqGetReward(nil)
		self:close()
	elseif not self.rewardData[tostring(self.idx)] then
		local isrow = self.idx % 2 == 1
		local row = isrow and (self.idx + 1) / 2 or 0
		local line = not isrow and self.idx / 2 or 0
		if self.idx == 9 then
			SoraDShowMsgTip(i18n("anniversary_cross_text_05"))
		else
			SoraDShowMsgTip(i18n(isrow and "anniversary_cross_text_02" or "anniversary_cross_text_06"))
		end
	end
end
return DecryptionLineRewardPopPanel
