local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_presentHistory = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://mailView/Com_presentHistory", Com_presentHistory)
function Com_presentHistory:onInit()
	self.fields.Text_player:addClickListener(handler(self, self.btnPlayerClick))
	self:fixChildrenPos()
end
function Com_presentHistory:onShow()
end
function Com_presentHistory:initData(data)
	self.data = data
	self.fields.Com_item:initData(data.itemId, data.count)
	self.fields.Text_itemName:setString(publicRead.getName(data.itemId))
	self.fields.Text_time:setString(os.date("%Y.%m.%d %H:%M:%S", data.time))
	publicRead = os.date("%Y.%m.%d %H:%M:%S", data.time)
	publicRead, publicRead, os.date("%Y.%m.%d %H:%M:%S", data.time).name = data.abbr, textParser.formatPlayerName(data.abbr, data.nickName), textParser.formatPlayerName(data.abbr, data.nickName)
	data.abbr.u = "True"
	data.abbr.c = "true"
	textParser.formatPlayerName(data.abbr, data.nickName).name, data.abbr.i = data.abbr, "true"
	self.fields.Text_player:setString(i18n_html("common_text_035", os.date("%Y.%m.%d %H:%M:%S", data.time)))
end
function Com_presentHistory:btnPlayerClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
	;(nil).playerID = self.data.uid
	SoraDSendMessage(nil)
end
return Com_presentHistory
