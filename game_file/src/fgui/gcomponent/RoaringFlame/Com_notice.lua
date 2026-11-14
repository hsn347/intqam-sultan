local baseComponent = require("fgui.base.baseComponent")
local Com_notice = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RoaringFlame/Com_notice", Com_notice)
function Com_notice:onInit()
	self.fields.title:setString(i18n("flames_dunes_text79"))
end
function Com_notice:onShow()
end
function Com_notice:initData(data)
	self.fields.Label_content:setString(data.content)
	_ENV = nil
	;(nil).time = os.date("%Y-%m-%d %H:%M:%S", data.time)
	;(nil).name = data.nickName
	self.fields.Text_tip:setString(i18n("%{time}  %{name}", nil))
end
return Com_notice
