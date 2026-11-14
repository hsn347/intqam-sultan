local constantRead = include("constantRead")
local wishingMeteorCtrl = SoraDGetCtrl("wishingMeteorCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WishMeteorPanel = class("WishMeteorPanel", baseFguiPanel)
function WishMeteorPanel:ctor(...)
	self.super.ctor(self, ...)
	print("WishMeteorPanel:ctor", self.viewName)
end
function WishMeteorPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "CommonBoxSingle"
	end
	return self._packageList
end
function WishMeteorPanel:onInit()
	print("=======WishMeteorPanel:onInit")
	self.isRewardChoosed = false
	self.itemID = constantRead.getConstValue("WISHING_METEOR_ITMES", 857701)
	self.costNum = constantRead.getConstValue("WISHING_METEOR_NUM", 1)
	self.fields.Com_title:initData(i18n("activity_name_9001459"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Label_time:initActivityTimeStyle(gActivityTimeActivityID.WISHING_METEOR)
	self.fields.Button_cost:setCost(self.itemID, self.costNum)
	self.fields.Button_cost:setString(i18n("Wishing_Meteor_12"))
	self.fields.Button_cost:addTouchEventListener(handler(self, self.onClickWish))
	self.fields.com_ItemNum:setString(i18n("common_text_3893"))
	self.fields.com_ItemNum:initData(self.itemID, handler(self, self.onClickAdd))
	self.fields.Usm_1:setPrepareCallback(function()
		print("Usm_1-触发")
		self.fields.Usm_1:play(false)
		_ENV = false
		;(false).frame = 23
		self.fields.Usm_1:getCriSprite():addFrameEventData(false)
		_ENV = false
		;(false).frame = 59
		self.fields.Usm_1:getCriSprite():addFrameEventData(false)
		self.fields.Usm_1:getCriSprite():setFrameEventCallback(handler(self, self.endPlayAnimation))
	end)
	wishingMeteorCtrl:reqWishingMeteorData()
end
function WishMeteorPanel:onShow()
	print("=======WishMeteorPanel:onShow")
	self.isRewardChoosed = false
	for i = 1, 8 do
		self.fields["star_" .. i]:fixPos()
		self.fields["star_" .. i]:initData()
		self.fields["star_" .. i]:setClickCallback(handler(self, self.onClickStar))
	end
end
function WishMeteorPanel:updateAwardNodes(isPlayAnimation)
	local wish = wishingMeteorCtrl:getWishData()
	if next(wish) then
		local index = 1
		for lv, data in ipairs(wish) do
			for _, id in ipairs(data) do
				if isPlayAnimation then
					self.fields["star_" .. index]:showEffect(lv, id)
				else
					self.fields["star_" .. index]:initData(lv, id)
				end
				index = index + 1
			end
		end
		self.isRewardChoosed = true
	end
end
function WishMeteorPanel:playAnimation(lv, idx, reward)
	self.fields.Usm_1:play(true)
	local index = (lv - 1) * 2 + idx
	self.fields["star_" .. index]:showEffect()
	self.reward = reward
end
function WishMeteorPanel:endPlayAnimation(info)
	print("showUsm4", self.fields.Usm_1:getCriSprite():getTotalFrame(), info.frame)
	if info and info.frame and 59 == self.fields.Usm_1:getCriSprite():getCurPlayFrame() then
		self.fields.Usm_1:setVisible(false)
		self.isRunAnimation = false
	elseif self.reward and info and info.frame and 23 == self.fields.Usm_1:getCriSprite():getCurPlayFrame() then
		local pos = self.fields.Usm_2:convertToWorldSpace(cc.p(0, 0))
		SoraDMailGainItems(self.reward, true)
		self.reward = nil
	end
end
function WishMeteorPanel:updateItem()
	self.fields.com_ItemNum:updateItemCount()
	self.fields.Button_cost:setCost(self.itemID, self.costNum)
end
function WishMeteorPanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("Wishing_Meteor_01")
	uiManager:show("RuleView", nil):setOwnerKey(self)
end
function WishMeteorPanel:onClickStar()
	SoraDPlaySound()
	uiManager:show("WishMeteorChoose")
end
function WishMeteorPanel:onClickWish()
	if self.isRunAnimation then
		return
	end
	SoraDPlaySound()
	if self.isRewardChoosed then
		if self.costNum <= include("publicUtil").getCount(self.itemID) then
			self.isRunAnimation = true
			wishingMeteorCtrl:reqWishingMeteorDrawLottery()
		else
			self:onClickAdd()
		end
	else
		SoraDShowMsgTip(i18n("Wishing_Meteor_02"))
	end
end
function WishMeteorPanel:onClickAdd()
	_ENV = nil
	;(nil).itemID = self.itemID
	uiManager:show("CommonSourceGuide", nil)
end
return WishMeteorPanel
