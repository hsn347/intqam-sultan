local baseComponent = require("fgui.base.baseComponent")
local Com_lvList = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SoldierRush/Com_lvList", Com_lvList)
function Com_lvList:onInit()
end
function Com_lvList:onShow()
end
function Com_lvList:initData(data, index)
	self.fields.line:setVisible(index % 2 == 1)
	local myLv = SoraDGetCastleLv() > 30 and 30 or SoraDGetCastleLv()
	for i = 1, 3 do
		local cfg = data["cfg" .. i]
		_ENV = nil
		;(nil).num1 = cfg.lv
		;(nil).num2 = cfg.bonus
		self.fields["Text_c" .. i]:setString(i18n("soldier_rush_text_124", nil))
		self.fields["Text_c" .. i]:setColor(cfg.lv == myLv and cc.c3b(112, 199, 35) or cc.c3b(180, 170, 135))
	end
end
return Com_lvList
