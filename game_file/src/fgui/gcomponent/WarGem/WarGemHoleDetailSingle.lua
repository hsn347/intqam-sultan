local warGemHoleEnchantSingle = require("fgui.gcomponent.WarGem.WarGemHoleEnchantSingle")
local WarGemHoleDetailSingle = fgui.extension_class(fgui.GComponent, warGemHoleEnchantSingle)
fgui.register_extension("ui://WarGem/WarGemHoleDetailSingle", WarGemHoleDetailSingle)
function WarGemHoleDetailSingle:onInit()
	print("WarGemHoleDetailSingle:onInit")
	self:fixChildrenPos()
	self.super.onInit(self)
end
function WarGemHoleDetailSingle:onShow()
end
function WarGemHoleDetailSingle:initData(lv, idx, position)
	self.super.initData(self, lv, idx, position)
	self.fields.Image_white:setVisible(position % 2 == 0)
end
function WarGemHoleDetailSingle:updateView()
	self.super.updateView(self)
	self.fields.Text_condition:getGroup():ensureBoundsCorrect()
end
return WarGemHoleDetailSingle
