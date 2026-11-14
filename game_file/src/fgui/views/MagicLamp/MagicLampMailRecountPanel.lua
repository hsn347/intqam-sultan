local baseFguiPanel = require("fgui.base.baseFguiPanel")
local magicLampSkillCtrl = SoraDGetCtrl("magicLampSkillCtrl")
local magicLampSkillRead = include("magicLampSkillRead")
local buffDesRead = include("buffDesRead")
local equipDesRead = include("equipDesRead")
local artifactRuneRead = include("artifactRuneRead")
local attrltCtrl = include("attrltCtrl")
local MagicLampMailRecountPanel = class("MagicLampMailRecountPanel", baseFguiPanel)
local magicLampCtrl = SoraDGetCtrl("magicLampCtrl")
local magicLampRead = include("magicLampRead")
function MagicLampMailRecountPanel:ctor(...)
	self.super.ctor(self, ...)
	print("MagicLampMailRecountPanel:ctor", self.viewName)
end
function MagicLampMailRecountPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "MagicLampSkill"
	end
	return self._packageList
end
function MagicLampMailRecountPanel:onInit()
	print("=======MagicLampMailRecountPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("magic_lamp_title_09"))
	self.fields.list_att:setItemRenderer(handler(self, self.onAttsRender))
	self.fields.list_att:setItemProvider(handler(self, self.onAttsProvider))
end
function MagicLampMailRecountPanel:onShow()
	print("=======MagicLampMailRecountPanel:onShow")
end
function MagicLampMailRecountPanel:updateJinnDetail(jinnData)
