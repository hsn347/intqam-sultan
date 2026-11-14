local baseComponent = require("fgui.base.baseComponent")
local intetiorMainRecord = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Intetior/intetiorMainRecord", intetiorMainRecord)
function intetiorMainRecord:onInit()
	_ENV = nil
	_ENV, _ENV, (nil).defaultClick = nil, nil, 1
	;(nil).title = i18n("parliament_btn_17")
	_ENV, (nil)[1], (nil).tag = nil, nil, 1
	;(nil).title = i18n("parliament_btn_18")
	;(nil).tabsetArray, (nil)[2], (nil).tag = nil, nil, 2
	local (nil).callback, tableData = handler(self, self.onClickTab), nil
	self.fields.com_TabW:initView(tableData)
end
function intetiorMainRecord:onShow()
end
function intetiorMainRecord:onClickTab(tag)
	self.controllers.c1:setSelectedIndex(tag - 1)
end
return intetiorMainRecord
