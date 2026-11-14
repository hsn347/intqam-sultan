local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SunnyLanePopupPanel = class("SunnyLanePopupPanel", baseFguiPanel)
function SunnyLanePopupPanel:ctor(...)
	self.super.ctor(self, ...)
	print("SunnyLanePopupPanel:ctor", self.viewName)
end
function SunnyLanePopupPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function SunnyLanePopupPanel:onInit()
	print("=======SunnyLanePopupPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("decrypt_text_03"))
	self.fields.Text_tips:setString(i18n("MonsterInvade_06"))
	self.rewards = worldMapDefine.getWorldBossReward(gBossType.monsterInvasionBoss, 1)
	self.fields.List_award:setItemRenderer(handler(self, self.onAwardItemRederer))
	self.fields.List_award:setNumItems(#self.rewards)
end
function SunnyLanePopupPanel:onShow()
	print("=======SunnyLanePopupPanel:onShow")
end
function SunnyLanePopupPanel:onAwardItemRederer(index, obj)
	obj:initData(self.rewards[index + 1])
end
return SunnyLanePopupPanel
