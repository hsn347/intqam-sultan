local roaringFlameWarRead = include("roaringFlameWarRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlame_MileStoneUnlockPanel = class("RoaringFlame_MileStoneUnlockPanel", baseFguiPanel)
function RoaringFlame_MileStoneUnlockPanel:ctor(...)
	self.isLRU = true
	RoaringFlame_MileStoneUnlockPanel.super.ctor(self, ...)
	print("RoaringFlame_MileStoneUnlockPanel:ctor", self.viewName)
end
function RoaringFlame_MileStoneUnlockPanel:onInit()
	print("=======RoaringFlame_MileStoneUnlockPanel:onInit")
	self.fields.Panel_bg:setString(i18n("flames_dunes_text60"))
	self.fields.Text_tip:setString(i18n("flames_dunes_text61"))
	self.fields.Text_none:setString(i18n("flames_dunes_text62"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_ok:setString(i18n("common_text_204"))
	self.fields.Button_ok:addClickListener(handler(self, self.btnOkClick))
end
function RoaringFlame_MileStoneUnlockPanel:onItemRenderer(index, obj)
	local subType = self.list[index + 1].res_type
	local lv = self.list[index + 1].lv
	obj:setIcon(roaringFlameWarRead.getBuildBattleIcon(subType))
	roaringFlameWarRead = roaringFlameWarRead.getBuildBattleIcon(subType)
	roaringFlameWarRead.getBuildBattleIcon(subType).lv = lv
	roaringFlameWarRead.getBuildBattleIcon(subType).name = roaringFlameWarRead.getBuildName(subType)
	obj:setTitle(i18n("common_text_134", roaringFlameWarRead.getBuildBattleIcon(subType)))
end
function RoaringFlame_MileStoneUnlockPanel:endShow()
	print("=======RoaringFlame_MileStoneUnlockPanel:endShow")
	if not self.param.list then
		_ENV = self.param.list
	end
	self.list = self.param.list
	self.fields.Text_tip:setVisible(#self.list > 0)
	self.fields.Text_none:setVisible(#self.list == 0)
	self.fields.List:setNumItems(#self.list)
end
function RoaringFlame_MileStoneUnlockPanel:btnOkClick()
	SoraDPlaySound()
	self:close()
end
return RoaringFlame_MileStoneUnlockPanel
