local roaringFlameWarRead = include("roaringFlameWarRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlameBattlefieldUnlockPanel = class("RoaringFlameBattlefieldUnlockPanel", baseFguiPanel)
function RoaringFlameBattlefieldUnlockPanel:ctor(...)
	self.isLRU = true
	RoaringFlameBattlefieldUnlockPanel.super.ctor(self, ...)
	print("RoaringFlameBattlefieldUnlockPanel:ctor", self.viewName)
	self.subType = gWorldTypeServerDef.subTypeRoaringFlameWarPalace
end
function RoaringFlameBattlefieldUnlockPanel:onInit()
	print("=======RoaringFlameBattlefieldUnlockPanel:onInit")
	local imageName = roaringFlameWarRead.getBuildImage2(self.subType)
	self.fields.Load_build:setURL(imageName)
end
function RoaringFlameBattlefieldUnlockPanel:endShow()
	print("=======RoaringFlameBattlefieldUnlockPanel:endShow")
	self.fields.Text_tips:setString(i18n("flames_dunes_text186"))
	self.fields.Button_go:setString(i18n("common_text_477"))
	self.fields.Button_go:addClickListener(handler(self, self.onClickBtnGo))
end
function RoaringFlameBattlefieldUnlockPanel:onClickBtnGo(...)
	SoraDPlaySound()
	local jumpPos = roaringFlameWarRead.getBuildCoordBySubType(self.subType)
	SoraDGotoWorldMapPoint(jumpPos, true)
	self:removeFromParent()
end
return RoaringFlameBattlefieldUnlockPanel
