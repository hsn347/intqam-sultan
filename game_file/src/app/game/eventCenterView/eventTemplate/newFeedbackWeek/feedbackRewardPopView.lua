local gametop = gModuleMgr.getObject("gametop")
local newFeedbackWeekRead = include("newFeedbackWeekRead")
local newFeedbackWeekCtrl = SoraDGetCtrl("newFeedbackWeekCtrl")
_ENV = "newFeedbackWeekCtrl"
;("newFeedbackWeekCtrl").noClaim = 1
;("newFeedbackWeekCtrl").noReach = 2
local ("newFeedbackWeekCtrl").claimed, giftStatus = 3, "newFeedbackWeekCtrl"
local feedbackRewardPopView = class("feedbackRewardPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("feedbackRewardPopView")
	end
	return target
end)
function feedbackRewardPopView:ctor(...)
	self.award, _ENV = nil, nil
	self.node = SoraDGetChildByName(self, "CCS_commonItemAward_1")
	self.node:setVisible(false)
	self.Node_award = SoraDGetChildByName(self, "Node_award")
	self.Button_get = SoraDGetChildByName(self, "Button_get")
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	_ENV = nil
	;(nil).var = "$" .. newFeedbackWeekRead.getBiggestQuota()
	self.Text_tip:setString(i18n("recharge_new_user_text07", nil))
	local rewardData = newFeedbackWeekRead.getBigReward()
	for index = 1, table.nums(rewardData) do
		local itemAward = self.award[index]
		if itemAward then
			itemAward:initData(rewardData[index].id, rewardData[index].count)
		else
			itemAward = include("commonItemAward").new()
			itemAward:setRealScale(0.75)
			itemAward:setOwnView(self)
			itemAward:setPosition(0, 0)
			itemAward:addTo(self.Node_award)
			itemAward:initData(rewardData[index].id, rewardData[index].count)
			self.award[index] = itemAward
		end
	end
	SoraDToCenter(self.Node_award, 100, SoraDFIsRA())
	self:initButton()
	self.Button_get:addTouchEventListener(handler(self, self.btnClick))
end
function feedbackRewardPopView:initButton()
	giftStatus = nil
	;(nil)[giftStatus.noReach] = function()
		self.Button_get:setTitleText(i18n("common_text_1146"))
		self.Button_get:loadTextures("btn_green_normal_01.png", "btn_green_normal_01.png", "btn_green_normal_01.png", ccui.TextureResType.plistType)
		self.Button_get:setTitleColor(cc.c3b(255, 255, 255))
	end
	;(nil)[giftStatus.noClaim] = function()
		self.Button_get:setTitleText(i18n("common_text_1146"))
		self.Button_get:loadTextures("btn_green_normal_01.png", "btn_green_normal_01.png", "btn_green_normal_01.png", ccui.TextureResType.plistType)
		self.Button_get:setTitleColor(cc.c3b(255, 255, 255))
	end
	local (nil)[giftStatus.claimed], switch = function()
		self.Button_get:setTitleText(i18n("common_text_1892"))
		self.Button_get:loadTextures("btn_gray_normal.png", "btn_gray_normal.png", "btn_gray_normal.png", ccui.TextureResType.plistType)
		self.Button_get:setTitleColor(cc.c3b(255, 255, 255))
	end, nil
	switch[newFeedbackWeekCtrl:getBigRewardStatus()]()
end
function feedbackRewardPopView:btnClick(target, eventType)
	giftStatus = nil
	;(nil)[giftStatus.noReach] = function()
		_ENV = nil
		;(nil).var = "$" .. newFeedbackWeekRead.getBiggestQuota()
		SoraDShowMsgTip(i18n("recharge_new_user_text07", nil))
	end
	;(nil)[giftStatus.noClaim] = function()
		newFeedbackWeekCtrl:reqClaimReward(newFeedbackWeekRead.getBigRewardId())
		SoraDRemoveAllAfterPanelFromManager(self)
	end
	local (nil)[giftStatus.claimed], switch = function()
		SoraDShowMsgTip(i18n("common_text_3182"))
	end, nil
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		switch[newFeedbackWeekCtrl:getBigRewardStatus()]()
	end
end
function feedbackRewardPopView:onMessageListener(...)
end
function feedbackRewardPopView:initData(data, otherData)
end
return feedbackRewardPopView
