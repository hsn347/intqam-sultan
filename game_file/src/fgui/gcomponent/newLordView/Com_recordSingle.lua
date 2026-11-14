local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_recordSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_recordSingle", Com_recordSingle)
function Com_recordSingle:onInit()
	self.fields.Text_name:addClickListener(handler(self, self.btnClick))
	self:fixChildrenPos()
end
function Com_recordSingle:onShow()
end
function Com_recordSingle:initData(data, msgType)
	self.data = data
	self.msgType = msgType
	self.fields.Com_item:initData(data.flowerID, data.flowerNum)
	local name = self.msgType == 1 and data.sndName or data.revName or data.name
	if gModuleMgr.sharedMgr("shieldedWordsltCtrl"):isNameShieldWord(name) then
		name = "******"
	end
	local goodType = backpackltCtrl:getItemType(data.flowerID)
	local kid
	if goodType == gItemType.ROSE then
		kid = self.msgType == 1 and data.sndKID or data.revKID
	end
	_ENV = nil
	;(nil).u = true
	self.fields.Text_name:setString(SoraDWrapHtmlTagByStyle(textParser.formatPlayerName(nil, name, kid), nil))
	self.fields.Text_time:setString(os.date("!%H:%M:%S", data.date))
end
function Com_recordSingle:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
	;(nil).playerID = self.msgType == 1 and self.data.sndUID or self.data.revUID
	;(nil).kid = self.msgType == 1 and self.data.sndKID or self.data.revKID
	SoraDSendMessage(nil)
end
return Com_recordSingle
