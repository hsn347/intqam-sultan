local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001639_StagePopPanel = class("Activity_9001639_StagePopPanel", baseFguiPanel)
function Activity_9001639_StagePopPanel:ctor(...)
	Activity_9001639_StagePopPanel.super.ctor(self, ...)
	print("Activity_9001639_StagePopPanel:ctor", self.viewName)
end
function Activity_9001639_StagePopPanel:onInit()
	print("=======Activity_9001639_StagePopPanel:onInit")
	self.fields.ani:setAllFrameName("dh_zhangjie8_%.2d.png", 0)
	self.fields.ani_light:setAllFrameName("dh_zhangjie10_%.2d.png", 0)
	self.reward, _ENV = self.fields.ani_light.setAllFrameName, self.fields.ani_light.setAllFrameName
	self.fields.spine:setLoop(false)
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Btn_ok:setString(i18n("common_text_1146"))
	self.fields.Btn_ok:addClickListener(handler(self, self.btnClick))
end
function Activity_9001639_StagePopPanel:onItemRenderer(index, obj)
	obj:initData(self.reward[index + 1].id, self.reward[index + 1].count)
	obj:setEffectShow(true)
end
function Activity_9001639_StagePopPanel:onShow()
	print("=======Activity_9001639_StagePopPanel:onShow")
	if not self.param or not self.param.rewards then
		_ENV = self.param.rewards
	end
	self.reward = self.param.rewards
	self.fields.spine:start()
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.delay(1.2)
	;(nil)[2] = ffa.callFunc(function()
		self.fields.List_reward:setNumItems(#self.reward)
	end)
	;(nil)[3] = ffa.callFunc(function()
		self.fields.List_reward:setNumItems(#self.reward)
	end)
	self:runAction(ffa.seq(nil))
end
function Activity_9001639_StagePopPanel:btnClick()
	SoraDPlaySound()
	SoraDMailGainItems(self.reward, true)
	self:close()
end
return Activity_9001639_StagePopPanel
