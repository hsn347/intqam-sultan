local activity_9001531_Ctrl = SoraDGetCtrl("activity_9001531_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001531_Reward2Panel = class("Activity_9001531_Reward2Panel", baseFguiPanel)
function Activity_9001531_Reward2Panel:ctor(...)
	self.super.ctor(self, ...)
	print("Activity_9001531_Reward2Panel:ctor", self.viewName)
end
function Activity_9001531_Reward2Panel:onInit()
	print("=======Activity_9001531_Reward2Panel:onInit")
	self.fields.title:setString(i18n("Bright_fireworks_04"))
	self.fields.Text_reward:setString(i18n("common_text_2078"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setVirtual()
	self.fields.Button_ok:setString(i18n("common_text_204"))
	self.fields.Button_ok:addClickListener(handler(self, self.onClickClose))
	self.fields.Button_ok2:setString(i18n("common_text_204"))
	self.fields.Button_ok2:addClickListener(handler(self, self.onClickClose))
	self.fields.Button_use:addClickListener(handler(self, self.onClickBtnUse))
	self.fields.Text_close:setString(i18n("mail_2_text_12"))
end
function Activity_9001531_Reward2Panel:onShow()
	print("=======Activity_9001531_Reward2Panel:onShow")
	if not self.proxy.param then
		local _ENV, param = self.proxy.param, self.proxy.param
	end
	if not param.rewards then
		_ENV = param.rewards
	end
	self.rewards = param.rewards
	self.itemID = param.itemID or 838101
	self.fields.List:setNumItems(#self.rewards)
	local useCount = activity_9001531_Ctrl:getUseCount(self.itemID)
	if 0 < useCount then
		self.controllers.c1:setSelectedIndex(0)
		_ENV = nil
		;(nil).num = useCount
		self.fields.Button_use:setString(i18n("Bright_fireworks_06", nil))
	else
		self.controllers.c1:setSelectedIndex(1)
	end
end
function Activity_9001531_Reward2Panel:onItemRenderer(index, obj)
	local item = self.rewards[index + 1]
	obj:initData(item.id, item.count)
end
function Activity_9001531_Reward2Panel:onClickBtnUse()
	SoraDPlaySound()
	local useCount = activity_9001531_Ctrl:getUseCount(self.itemID)
	if 0 < useCount then
		activity_9001531_Ctrl:reqUseItem(self.itemID, useCount)
		self:closePanel()
		local proxy = uiManager:getProxy("Activity_9001531_Main")
		if proxy then
			proxy:showLoading()
		end
	end
end
return Activity_9001531_Reward2Panel
