local baseFguiPanel = require("fgui.base.baseFguiPanel")
local magicLampSkillLotteryRead = include("magicLampSkillLotteryRead")
local MagicLampMaigcPowerRewardPanel = class("MagicLampMaigcPowerRewardPanel", baseFguiPanel)
function MagicLampMaigcPowerRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("MagicLampMaigcPowerRewardPanel:ctor", self.viewName)
end
function MagicLampMaigcPowerRewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function MagicLampMaigcPowerRewardPanel:onInit()
	print("=======MagicLampMaigcPowerRewardPanel:onInit")
	self.magicPoolID = self.param.magicPoolID
	local showCfg = magicLampSkillLotteryRead.getShowCfgByID(self.magicPoolID)
	self.fields.Com_title:setTitle(i18n(showCfg.magicPoolType))
	self.fields.text_tip:setString(i18n("Magic_draw_text_20"))
	self.rewards = showCfg.drawReward
	self.fields.list:setItemRenderer(handler(self, self.onItemRenderer))
end
function MagicLampMaigcPowerRewardPanel:onShow()
	print("=======MagicLampMaigcPowerRewardPanel:onShow")
	self.fields.list:setNumItems(#self.rewards)
	if SoraDFIsRA() then
		self.fields.list:scrollToView(0)
	end
end
function MagicLampMaigcPowerRewardPanel:onItemRenderer(index, obj)
	local data = self.rewards[index + 1]
	obj:initData(data.id, data.count)
end
return MagicLampMaigcPowerRewardPanel
