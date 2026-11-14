local baseComponent = require("fgui.base.baseComponent")
local Button_sort = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://resourceBuy/Button_sort", Button_sort)
function Button_sort:onInit()
	self.fields.frame_arrow:fixPos()
	self.fields.Text_sort:fixPos()
end
function Button_sort:onShow()
end
function Button_sort:setCurStr(str)
	self.fields.Text_curTotal:setString(str)
end
function Button_sort:updateSort()
	self.fields.frame_arrow:setFlippedY(gIsResourceBuySort)
	self.fields.Text_sort:setString(gIsResourceBuySort and i18n("common_btn_03") or i18n("common_btn_04"))
end
return Button_sort
