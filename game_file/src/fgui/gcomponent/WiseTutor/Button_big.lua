local baseComponent = require("fgui.base.baseComponent")
local Button_big = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://WiseTutor/Button_big", Button_big)
function Button_big:onInit()
end
function Button_big:onShow()
end
function Button_big:initData(own, total)
	_ENV = nil
	;(nil).member = own
	_ENV, _ENV, (nil).total = nil, nil, total
	_ENV, (nil).member, (nil).color = nil, nil, total <= own and "#D7C39B" or "#BE2828"
	;(nil).__default, (nil).color = nil, "#D7C39B"
	self.fields.title:setString(i18n_html("common_text_155", nil, nil))
	self.controllers.c1:setSelectedIndex(total <= own and 0 or 1)
end
return Button_big
