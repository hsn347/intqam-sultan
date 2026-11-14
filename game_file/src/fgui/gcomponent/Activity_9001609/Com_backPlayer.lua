local activity_9001609_Ctrl = SoraDGetCtrl("activity_9001609_Ctrl")
local activity_9001609_Read = include("activity_9001609_Read")
local baseComponent = require("fgui.base.baseComponent")
local Com_backPlayer = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001609/Com_backPlayer", Com_backPlayer)
function Com_backPlayer:onInit()
	self.rewards, _ENV = nil, nil
	self.fields.Text_des:setString(i18n("recallfriends_text_09"))
	self.fields.Text_reward:setString(i18n("welcome_back_text05"))
	self.fields.input:setPromptHolder(i18n("recallfriends_text_17"), "#322828")
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List_reward:setAlignCenter(true)
	self.fields.Btn_reward:addClickListener(handler(self, self.btnClick))
end
function Com_backPlayer:onItemRenderer(index, obj)
	obj:initData(self.rewards[index + 1].id, self.rewards[index + 1].count)
end
function Com_backPlayer:onShow()
	self.rewards = activity_9001609_Read.getBindingReward()
	self.fields.List_reward:setNumItems(#self.rewards)
end
function Com_backPlayer:initData()
	local isBind = activity_9001609_Ctrl:isBindInvitor()
	self.fields.Btn_reward:setString(isBind and i18n("recallfriends_text_06") or i18n("common_text_1146"))
	self.fields.Btn_reward:setEnabled(not isBind)
	self.controllers.c1:setSelectedIndex(isBind and 1 or 0)
end
function Com_backPlayer:btnClick()
	SoraDPlaySound()
	local input = tonumber(self.fields.input:getText())
	if input then
		activity_9001609_Ctrl:sendBindingMsg(tonumber(input))
	else
		SoraDShowMsgTip(i18n("recallfriends_text_17"))
	end
end
return Com_backPlayer
