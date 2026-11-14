local gametop = gModuleMgr.getObject("gametop")
local newFeedbackWeekRead = include("newFeedbackWeekRead")
local newFeedbackWeekCtrl = SoraDGetCtrl("newFeedbackWeekCtrl")
_ENV = "newFeedbackWeekCtrl"
;("newFeedbackWeekCtrl").noClaim = 1
;("newFeedbackWeekCtrl").noReach = 2
local ("newFeedbackWeekCtrl").claimed, giftStatus = 3, "newFeedbackWeekCtrl"
local feedbackWeekTaskItem = class("feedbackWeekTaskItem", function(target)
	if target == nil then
		return SoraDCreateBasePanel("FeedbackWeekTaskItem")
	end
	return target
end)
function feedbackWeekTaskItem:ctor(...)
	self.award, giftStatus = nil, nil
	self.taskID = 0
	self.amount = 0
	self.status = giftStatus.noReach
	self.node = SoraDGetChildByName(self, "CCS_commonItemAward_1")
	self.node:setVisible(false)
	self.Image_state = SoraDGetChildByName(self, "Image_state")
	self.Text_dsc = SoraDGetChildByName(self, "Text_dsc")
	self.Button_btn = SoraDGetChildByName(self, "Button_btn")
	self.Button_btn:addTouchEventListener(handler(self, self.btnClick))
	self.Node_award = SoraDGetChildByName(self, "Node_award")
	self.Text_got = SoraDGetChildByName(self, "Text_got")
	self.Text_got:setString(i18n("common_text_1892"))
	self.Image_got = SoraDGetChildByName(self, "Image_got")
	self.Text_discount = SoraDGetChildByName(self, "Text_discount")
	self.Node_effect = SoraDGetChildByName(self, "Node_effect")
	SoraDChangeTextToHtml(self.Text_dsc)
	SoraDCreatAnimation("FeedbackWeekTaskItem", self, true)
end
function feedbackWeekTaskItem:onMessageListener(...)
end
function feedbackWeekTaskItem:initData(data, otherData)
	dump(data)
	local rewardData = data.Reward
	self.taskID = data.taskID
	self.amount = data.amount
	for index = 1, table.nums(rewardData) do
		local itemAward = self.award[index]
		if itemAward then
			itemAward:initData(rewardData[index].id, rewardData[index].count)
		else
			itemAward = include("commonItemAward").new()
			itemAward:setRealScale(0.75)
			itemAward:setOwnScroll(otherData.scroll)
			itemAward:setOwnView(otherData.view)
			itemAward:setPosition(0, 0)
			itemAward:addTo(self.Node_award)
			itemAward:initData(rewardData[index].id, rewardData[index].count)
			self.award[index] = itemAward
		end
	end
	SoraDToCenter(self.Node_award, 85, SoraDFIsRA())
	self.status = data.status
	self.Node_effect:setVisible(self.status == giftStatus.noClaim)
	self:initButton()
	self.Text_dsc:setColor(cc.c3b(255, 255, 255))
	self.Text_dsc:setFontSize(16)
	_ENV = cc.c3b(255, 255, 255)
	_ENV, _ENV, cc.c3b(255, 255, 255).price = tostring(self.amount), "$" .. tostring(self.amount), "$" .. tostring(self.amount)
	_ENV, ("$" .. tostring(self.amount)).price, tostring(self.amount).color = tostring(self.amount), tostring(self.amount), "#FBFD02"
	;("$" .. tostring(self.amount)).__default, tostring(self.amount).color = tostring(self.amount), "#F0DCAE"
	self.Text_dsc:setString(i18n_html("recharge_new_user_text02", cc.c3b(255, 255, 255)))
	self.Text_discount:setString(data.profit .. "%")
end
function feedbackWeekTaskItem:initButton()
	giftStatus = nil
	;(nil)[giftStatus.noReach] = function()
		self.Button_btn:setVisible(true)
		self.Button_btn:setTitleText(i18n("common_text_678"))
		self.Button_btn:loadTextures("btn_yellow_small_01.png", "btn_yellow_small_01.png", "btn_yellow_small_01.png", ccui.TextureResType.plistType)
		self.Button_btn:setTitleColor(cc.c3b(255, 255, 255))
		self.Button_btn:setContentSize(cc.size(156, 66))
	end
	;(nil)[giftStatus.noClaim] = function()
		self.Button_btn:setVisible(true)
		self.Button_btn:setTitleText(i18n("common_text_1146"))
		self.Button_btn:loadTextures("btn_green_small_01.png", "btn_green_small_01.png", "btn_green_small_01.png", ccui.TextureResType.plistType)
		self.Button_btn:setTitleColor(cc.c3b(255, 255, 255))
		self.Button_btn:setContentSize(cc.size(156, 66))
	end
	local (nil)[giftStatus.claimed], switch = function()
		self.Button_btn:setVisible(false)
		self.Text_got:setVisible(true)
		self.Image_got:setVisible(true)
	end, nil
	switch[self.status]()
end
function feedbackWeekTaskItem:btnClick(target, eventType)
	giftStatus = nil
	;(nil)[giftStatus.noReach] = function()
		print("giftStatus.noReach")
		if GLOBAL_GAME_RECHARGE_MODE then
			uiManager:show("rechargeView")
		else
			SoraDCreatePanel("rechargeView"):show()
		end
	end
	;(nil)[giftStatus.noClaim] = function()
		newFeedbackWeekCtrl:reqClaimReward(self.taskID)
	end
	local (nil)[giftStatus.claimed], switch = function()
	end, nil
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		switch[self.status]()
	end
end
return feedbackWeekTaskItem
