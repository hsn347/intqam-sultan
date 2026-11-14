local warShelterCtrl = SoraDGetCtrl("warShelterCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_searchSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://BuildWatchTower/Com_searchSingle", Com_searchSingle)
function Com_searchSingle:onInit()
	self.fields.Button_apply:setString(i18n("common_text_182"))
	self.fields.Button_apply:addClickListener(handler(self, self.btnApplyClick))
	self:fixChildrenPos()
end
function Com_searchSingle:onShow()
end
function Com_searchSingle:initData(data)
	self.data = data
	self.fields.Com_head:setHeadSprite(data.iconID, data.avatar)
	self.fields.Com_head:setPlayerID(data.uid)
	self.fields.Com_head:setKid(data.partition)
	self.fields.Text_name:setString(textParser.formatPlayerName(nil, data.nickName, data.partition))
end
function Com_searchSingle:btnApplyClick()
	SoraDPlaySound()
	warShelterCtrl:reqSendInvite(self.data.uid)
end
return Com_searchSingle
