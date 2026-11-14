local baseFguiPanel = require("fgui.base.baseFguiPanel")
local CommonPopBox3Panel = class("CommonPopBox3Panel", baseFguiPanel)
function CommonPopBox3Panel:ctor(...)
	CommonPopBox3Panel.super.ctor(self, ...)
	print("CommonPopBox3Panel:ctor", self.viewName)
end
function CommonPopBox3Panel:onInit()
	print("=======CommonPopBox3Panel:onInit")
	if not self.param then
		local _ENV, param = self.param, self.param
	end
	self.fields.Panel_bg:setString(param.title or i18n("hero_title_02"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	if not param.rewards then
		_ENV = param.rewards
	end
	self.rewards = param.rewards
	self.fields.List_reward:setNumItems(#self.rewards)
	self.fields.Text_tip:setString(param.tip or "")
	if param.tipAlign then
		self.fields.Text_tip:setAlign(param.tipAlign)
	end
end
function CommonPopBox3Panel:onShow()
	print("=======CommonPopBox3Panel:onShow")
end
function CommonPopBox3Panel:onItemRenderer(index, obj)
	local reward = self.rewards[index + 1]
	obj:initData(reward.id, reward.count)
end
return CommonPopBox3Panel
