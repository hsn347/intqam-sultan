local magicLampSkillRead = include("magicLampSkillRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MagicLampSkillRebirthBackPanel = class("MagicLampSkillRebirthBackPanel", baseFguiPanel)
function MagicLampSkillRebirthBackPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MagicLampSkillRebirthBackPanel:ctor", self.viewName)
	self.isHidePrePanel = true
end
function MagicLampSkillRebirthBackPanel:onInit()
	print("=======MagicLampSkillRebirthBackPanel:onInit")
	self.fields.Com_title:setString(i18n("jinn_skill_46"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onRewardItemRenderer))
	self.fields.Button_ok:setString(i18n("common_text_204"))
	self.fields.Button_ok:addClickListener(handler(self, self.onClickClose))
end
function MagicLampSkillRebirthBackPanel:onShow()
	print("=======MagicLampSkillRebirthBackPanel:onShow")
	if not self.param or not self.param.rewardList then
		_ENV = self.param.rewardList
	end
	self.rewardList = self.param.rewardList
	self.fields.List_reward:setNumItems(#self.rewardList)
end
function MagicLampSkillRebirthBackPanel:onRewardItemRenderer(index, obj)
	local _index = index + 1
	local data = self.rewardList[_index]
	magicLampSkillRead.initRebirthRewardSingle(obj, data)
end
return MagicLampSkillRebirthBackPanel
