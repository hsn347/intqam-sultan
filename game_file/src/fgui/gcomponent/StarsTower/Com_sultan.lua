local rechargePresentRead = include("rechargePresentRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_sultan = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://StarsTower/Com_sultan", Com_sultan)
function Com_sultan:onInit()
	self.fields.Text_get:setString(i18n("common_text_4458"))
	self:fixChildrenPos()
	self.fields.n0:fix()
end
function Com_sultan:onShow()
end
function Com_sultan:initData(rid)
	local val = rechargePresentRead.getRecargeGiftNum(rid, gActivityTimeActivityID.SULTAN_EX_RECAHRGE_PRESENT)
	self.fields.Text_num:setString("x" .. val)
end
return Com_sultan
