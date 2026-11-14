local djCtrl = SoraDGetCtrl("djCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_searchSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://DjView/Com_searchSingle", Com_searchSingle)
function Com_searchSingle:onInit()
	self.fields.Button_apply:setTitle(i18n("common_text_189"))
	self.fields.Button_apply:addClickListener(handler(self, self.onClick_Button_apply))
	self:fixChildrenPos()
end
function Com_searchSingle:onShow()
end
function Com_searchSingle:initData(data)
	self.data = data
	self.fields.Com_head:setHeadSprite(data.headid, data.avatar)
	self.fields.Com_head:setPlayerID(data.uid)
	self.fields.Com_head:setKid(data.kid)
	self.fields.Text_name:setString(textParser.formatPlayerName(nil, data.nikeName, data.kid))
end
function Com_searchSingle:onClick_Button_apply(context)
	SoraDPlaySound()
	djCtrl:reqInviteSpeak(self.data.uid)
end
return Com_searchSingle
