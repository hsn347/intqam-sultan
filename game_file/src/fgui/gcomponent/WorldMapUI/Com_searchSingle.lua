local baseComponent = require("fgui.base.baseComponent")
local Com_searchSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WorldMapUI/Com_searchSingle", Com_searchSingle)
function Com_searchSingle:onInit()
	self.fields.btn:setString(i18n("common_text_166"))
	self.fields.btn:addClickListener(handler(self, self.btnClick))
	self:fixChildrenPos()
end
function Com_searchSingle:onShow()
end
function Com_searchSingle:initData(data, parent)
	self.data = data
	self.parent = parent
	self.fields.title:setString(self.data.title)
end
function Com_searchSingle:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_WORLD_MAP_KINGDOM_JUMP"
	;(nil).kid = self.data.kingdomID
	SoraDSendMessage(nil)
	self.parent:close()
end
return Com_searchSingle
