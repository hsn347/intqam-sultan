local activity_9001476_Ctrl = SoraDGetCtrl("activity_9001476_Ctrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local itemDesRead = include("itemDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001476_RewardPanel = class("Activity_9001476_RewardPanel", baseFguiPanel)
function Activity_9001476_RewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001476_RewardPanel:ctor", self.viewName)
	self.itemID = activity_9001476_Ctrl:getItemID()
end
function Activity_9001476_RewardPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "CaveExploreActivity"
	end
	return self._packageList
end
function Activity_9001476_RewardPanel:onInit()
	print("=======Activity_9001476_RewardPanel:onInit")
	self.fields.txt_title:setString(i18n("Promise_Summit_text_29"))
	self.fields.scroll:setItemRenderer(handler(self, self.onNormalItemRenderer))
	local Button_ten = self.fields.Button_ten
	local itemIcon = itemDesRead.getIcon(self.itemID)
	local count = 10
	_ENV = handler(self, self.onNormalItemRenderer)
	handler(self, self.onNormalItemRenderer).num = count
	Button_ten:setString(i18n("onegoaltofame_01", handler(self, self.onNormalItemRenderer)))
	Button_ten:addClickListener(handlerEx(self, self.onClickBtnDraw, count))
	Button_ten:setCostNum(count)
	Button_ten:setCostIcon(itemIcon)
end
function Activity_9001476_RewardPanel:onShow()
	print("=======Activity_9001476_RewardPanel:onShow")
	SoraDPlaySound("sixYear", "ui_award")
	if not self.proxy.param or not self.proxy.param.rewards then
		_ENV = self.proxy.param.rewards
	end
	self.rewards = self.proxy.param.rewards
	self.fields.scroll:setNumItems(#self.rewards)
end
function Activity_9001476_RewardPanel:onNormalItemRenderer(index, obj)
	local round = index + 1
	local reward = self.rewards[round]
	reward.round = round
	obj:initData(reward, index)
end
function Activity_9001476_RewardPanel:onClickBtnDraw(count)
	if not self.isCanCloseSelf then
		return
	end
	self:closePanel()
	local proxy = uiManager:getProxy("Activity_9001476_Main")
	if proxy then
		proxy:clickBtnDraw(count)
	end
end
function Activity_9001476_RewardPanel:openSourceGuideView(...)
	_ENV = nil
	;(nil).itemID = self.itemID
	uiManager:show("CommonSourceGuide", nil)
end
function Activity_9001476_RewardPanel:doShowAnimation()
	self.view:setScale(0.5)
	self.isCanCloseSelf = false
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.scaleTo(0.2, 1)
	;(nil)[2] = ffa.callFunc(function()
		self.isCanCloseSelf = true
	end)
	;(nil)[3] = ffa.callFunc(function()
		self.isCanCloseSelf = true
	end)
	self.view:runAction(ffa.seq(nil))
end
return Activity_9001476_RewardPanel
