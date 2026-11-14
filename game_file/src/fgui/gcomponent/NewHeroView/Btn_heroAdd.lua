local heroltCtrl = gModuleMgr.sharedMgr("heroltCtrl")
local heroCtrl = SoraDGetCtrl("heroCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_heroAdd = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NewHeroView/Btn_heroAdd", Btn_heroAdd)
function Btn_heroAdd:onInit()
	self:addClickListener(handler(self, self.btnClick))
end
function Btn_heroAdd:onShow()
end
function Btn_heroAdd:initData(heroID, index, heros)
