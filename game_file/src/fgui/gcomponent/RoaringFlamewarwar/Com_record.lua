local baseComponent = require("fgui.base.baseComponent")
local Com_record = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlamewarwar/Com_record", Com_record)
function Com_record:onInit()
	self:fixChildrenPos()
end
function Com_record:onShow()
end
function Com_record:initData(data)
	_ENV = nil
	;(nil).num = fguiHelper.getColorString("#FFFBD5", data.curVal)
	self.fields.Text_des:setString(i18n(data.key, nil))
	_ENV = i18n(data.key, nil)
	i18n(data.key, nil).num = data.historyVal
	self.fields.Text_history:setString(i18n("flames_dunes_text211", i18n(data.key, nil)))
	self.fields.new:setVisible(data.curVal > data.historyVal)
	self.fields.Text_history:setVisible(data.curVal <= data.historyVal)
end
return Com_record
