local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001649_BigRewardPanel = class("Activity_9001649_BigRewardPanel", baseFguiPanel)
function Activity_9001649_BigRewardPanel:ctor(...)
	Activity_9001649_BigRewardPanel.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001649_BigRewardPanel:ctor", self.viewName)
end
function Activity_9001649_BigRewardPanel:onInit()
	print("=======Activity_9001649_BigRewardPanel:onInit")
	self.fields.ani:setAllFrameName("dh_zhangjie8_%.2d.png", 0)
	self.fields.ani_light:setAllFrameName("dh_zhangjie10_%.2d.png", 0)
	self.reward, _ENV = self.fields.ani_light.setAllFrameName, self.fields.ani_light.setAllFrameName
	self.fields.spine:setLoop(false)
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Btn_ok:setString(i18n("common_text_054"))
	self.fields.Btn_ok:addClickListener(handler(self, self.onClickClose))
end
function Activity_9001649_BigRewardPanel:onShow()
	print("=======Activity_9001649_BigRewardPanel:onShow")
	self:updateView()
end
function Activity_9001649_BigRewardPanel:updateView()
	self.rewards = self.param.rewards
	self.fields.spine:start()
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.delay(1.2)
	;(nil)[2] = ffa.callFunc(function()
		self.fields.List_reward:setNumItems(#self.rewards)
	end)
	;(nil)[3] = ffa.callFunc(function()
		self.fields.List_reward:setNumItems(#self.rewards)
	end)
	self:runAction(ffa.seq(nil))
end
function Activity_9001649_BigRewardPanel:onItemRenderer(index, obj)
	obj:initData(self.rewards[index + 1].id, self.rewards[index + 1].count)
	_UPVALUE1_ = self.rewards[index + 1].count
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.scaleTo(0.16666666666666666, 1.05)
	;(nil)[2] = ffa.scaleTo(0.25, 1.0)
	;(nil)[3] = ffa.scaleTo(0.25, 1.0)
	;(nil)[4] = ffa.scaleTo(0.25, 1.0)
	self.rewards[index + 1].count[1] = ffa.fadeIn(0.16666666666666666)
	self.rewards[index + 1].count[2] = ffa.seq(nil)
	self.rewards[index + 1].count[3] = ffa.seq(nil)
	self.rewards[index + 1].count[4] = ffa.seq(nil)
	self.rewards[index + 1].count[5] = ffa.seq(nil)
	self.rewards[index + 1].count[6] = ffa.seq(nil)
	self.rewards[index + 1].count[7] = ffa.seq(nil)
	obj:runAction(ffa.spawn(self.rewards[index + 1].count))
end
return Activity_9001649_BigRewardPanel
