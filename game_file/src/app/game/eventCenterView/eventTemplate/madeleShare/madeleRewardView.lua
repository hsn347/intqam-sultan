local gametop = gModuleMgr.getObject("gametop")
local publicRead = include("publicRead")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local madeleRewardView = class("madeleRewardView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("madeleRewardView")
	end
	return target
end)
function madeleRewardView:ctor()
	self.btnUse = SoraDGetChildByName(self, "Button_use")
	self.btnUse:addTouchEventListener(handler(self, self.btnClickUse))
	self.textTitle = SoraDGetChildByName(self, "Text_notice")
	self.textTitle:setString(i18n("hero_title_02"))
	self.rewardNode = SoraDGetChildByName(self, "Node_Reward")
	self.singleItem = SoraDGetChildByName(self.rewardNode, "RewardItem")
end
function madeleRewardView:initData(pointType, info)
	self.pointType = pointType
	self.amount = info.score
	self.reward = info.reward
	self.status = info.statu
	for i, v in ipairs(self.reward) do
		local single = include("commonItemAward").new()
		single:setPosition(0, 0)
		single:addTo(self.rewardNode)
		single:setVisible(true)
		single:setOwnView(self)
		single:initData(v.id, v.count)
	end
	SoraDToCenter(self.rewardNode, 110, SoraDFIsRA())
	if self.status == 1 then
		self.btnUse:setTitleText(i18n("common_text_4120"))
		self.btnUse:setBright(false)
		self.btnUse:setTouchEnabled(false)
	elseif self.status == 2 then
		self.btnUse:setTitleText(i18n("common_text_1146"))
		self.btnUse:setBright(true)
		self.btnUse:setTouchEnabled(true)
	elseif self.status == 3 then
		self.btnUse:setTitleText(i18n("common_text_1892"))
		self.btnUse:setBright(false)
		self.btnUse:setTouchEnabled(false)
	end
end
function madeleRewardView:setCallBack(handle)
	self.clickBack = handle
end
function madeleRewardView:hideStar()
	for i, v in ipairs(SoraDGetChildsArrayByName(self, "star_", 4, 1)) do
		v:setVisible(false)
	end
end
function madeleRewardView:btnClickUse(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		if self.clickBack then
			_ENV = nil
			;(nil).nType = self.pointType
			;(nil).amount = self.amount
			self.clickBack(nil)
		end
		self:removeFromParent()
	end
end
return madeleRewardView
