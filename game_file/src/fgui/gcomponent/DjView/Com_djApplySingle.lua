local djCtrl = SoraDGetCtrl("djCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_djApplySingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://DjView/Com_djApplySingle", Com_djApplySingle)
function Com_djApplySingle:onInit()
	self.fields.Button_ok:setTitle(i18n("common_text_140"))
	self.fields.Button_ok:addClickListener(handler(self, self.onClick_Button_ok))
end
function Com_djApplySingle:onShow()
end
function Com_djApplySingle:initData(data)
	self.data = data
	self.fields.Com_head:setHeadSprite(self.data.headid, self.data.avatar)
	self.fields.Com_head:setPlayerID(self.data.uid)
	self.fields.Com_head:setKid(self.data.kid)
	self.fields.Text_name:setString(textParser.formatPlayerName(nil, self.data.nikeName, self.data.kid))
end
function Com_djApplySingle:onClick_Button_ok(context)
	SoraDPlaySound()
	djCtrl:reqAgreeApply(self.data.uid)
end
return Com_djApplySingle
