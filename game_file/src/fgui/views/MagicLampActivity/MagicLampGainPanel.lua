local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MagicLampGainPanel = class("MagicLampGainPanel", baseFguiPanel)
function MagicLampGainPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MagicLampGainPanel:ctor", self.viewName)
end
function MagicLampGainPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Effect_baoxiang"
	end
	return self._packageList
end
function MagicLampGainPanel:onInit()
	print("=======MagicLampGainPanel:onInit")
	self.fields.Title:setString(i18n("Lucky_treasure_text_05"))
	self.fields.Text_Title:setString(i18n("Martial_arts_text_09"))
	self.fields.Button_Sure:setString(i18n("common_text_204"))
	self.fields.Button_Sure:addClickListener(handler(self, self.onClickClose))
	self.fields.List_Award:setItemRenderer(handler(self, self.onItemRederer))
	self.rewardList = self.proxy.param.reward
	self.fields.List_Award:setNumItems(#self.rewardList)
end
function MagicLampGainPanel:onItemRederer(index, target)
	target:initData(self.rewardList[index + 1].id, self.rewardList[index + 1].count)
end
function MagicLampGainPanel:onShow()
	print("=======MagicLampGainPanel:onShow")
end
return MagicLampGainPanel
