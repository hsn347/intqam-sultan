local heroPaeanCtrl = SoraDGetCtrl("heroPaeanCtrl")
local heroPaeanRead = include("heroPaeanRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local HeroPaeanRewardPanel = class("HeroPaeanRewardPanel", baseFguiPanel)
function HeroPaeanRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("HeroPaeanRewardPanel:ctor", self.viewName)
end
function HeroPaeanRewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function HeroPaeanRewardPanel:onInit()
	print("=======HeroPaeanRewardPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("hero_title_02"))
	self.fields.Button_get:addClickListener(handler(self, self.onClickGet))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
end
function HeroPaeanRewardPanel:initData(index, data)
	print("=======HeroPaeanRewardPanel:onInit")
	self.index = index or self.index
	self.score = data.score or self.score
	self.rewards = data.rewards
	if data.state == 1 then
		self.fields.Button_get:setTitleText(i18n("common_text_2139"))
		self.fields.Button_get:setGrayed(true)
		self.fields.Button_get:setTouchable(false)
	elseif data.state == 2 then
		self.fields.Button_get:setTitleText(i18n("common_text_1146"))
		self.fields.Button_get:setGrayed(false)
		self.fields.Button_get:setTouchable(true)
	else
		self.fields.Button_get:setTitleText(i18n("common_text_1892"))
		self.fields.Button_get:setGrayed(true)
		self.fields.Button_get:setTouchable(false)
	end
	self.fields.Text_progress:setString(i18n("common_text_3780") .. heroPaeanCtrl:getScore() .. "/" .. self.score)
	self.fields.List_reward:setNumItems(table.nums(self.rewards) / 2)
end
function HeroPaeanRewardPanel:onClickGet()
	SoraDPlaySound()
	self.backHandle(self.index)
	self:close()
end
function HeroPaeanRewardPanel:onItemRenderer(index, object)
	object:initData(self.rewards[index * 2 + 1], self.rewards[index * 2 + 2])
end
function HeroPaeanRewardPanel:onShow()
	print("=======HeroPaeanRewardPanel:onShow")
	self.backHandle = self.proxy.param.backHandle
	self:initData(self.proxy.param.index, self.proxy.param)
end
return HeroPaeanRewardPanel
