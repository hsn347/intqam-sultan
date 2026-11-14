local nebulaAllStarUtil = include("nebulaAllStarUtil")
local baseComponent = require("fgui.base.baseComponent")
local Com_own = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaAllStarWar/Com_own", Com_own)
function Com_own:onInit()
	self.fields.Btn_get:addClickListener(handler(self, self.btnClick))
	self:fixChildrenPos()
end
function Com_own:onShow()
end
function Com_own:initData(id, count, isPayItem)
	self.id = id
	self.isPayItem = isPayItem
	_ENV = nil
	;(nil).count = fguiHelper.getColorString("#F0E6D2", count)
	self.fields.title:setString(i18n("common_text_1377", nil))
end
function Com_own:btnClick()
	SoraDPlaySound()
	if self.isPayItem and nebulaAllStarUtil.isWarTest() then
		SoraDShowMsgTip(i18n("NebulaAllstar_288"))
		return
	end
	_ENV = i18n("NebulaAllstar_288")
	i18n("NebulaAllstar_288").itemID = self.id
	uiManager:show("CommonSourceGuide", i18n("NebulaAllstar_288"))
end
return Com_own
