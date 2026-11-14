local buffDesRead = include("buffDesRead")
local baseComponent = require("fgui.base.baseComponent")
local DressBuffSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NewHeroView/DressBuffSingle", DressBuffSingle)
function DressBuffSingle:onInit()
	self:fixChildrenPos()
end
function DressBuffSingle:onShow()
end
function DressBuffSingle:initData(buffInfo, isLight)
	dump(buffInfo, "buffInfo====")
	self.fields.Text_des:setString(buffDesRead.getTitleBase(buffInfo.id))
	self.fields.Text_des:setColor(isLight and cc.c3b(255, 236, 191) or cc.c3b(101, 94, 85))
	self.fields.Text_val:setString(buffDesRead.getTitleValueWithValue(buffInfo.id, buffInfo.value))
	self.fields.Text_val:setColor(isLight and cc.c3b(255, 236, 191) or cc.c3b(101, 94, 85))
end
return DressBuffSingle
