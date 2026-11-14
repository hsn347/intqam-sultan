local chatCtrl = SoraDGetCtrl("chatCtrl")
local teamDef = include("teamDef")
local activity_9001731_Ctrl = SoraDGetCtrl("activity_9001731_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_chat = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001731/Com_chat", Com_chat)
function Com_chat:onInit()
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Button_send:addClickListener(handler(self, self.onClick_Button_send))
	self.fields.Button_history:addClickListener(handler(self, self.onClick_Button_history))
	self.input = self.fields.input:getChild("input")
	self.input:setMaxLength(100)
	self.input:setPromptHolder(i18n("common_text_072"))
	if self.input.setControlType then
		self.input:setControlType(1)
	end
	self.input:setSingleLine(true)
	self.input:setNoToolBar(true)
	self.input:registerScriptEditBoxHandler(handler(self, self.editBoxTextEvent))
	self.fields.Button_send:fixPos()
	self.fields.Button_history:fixPos()
end
function Com_chat:registerEvent()
	SoraDAddMessage(self, "MESSAGE_CHAT_CLOSE_IME", handler(self, self.hideKeyPad))
end
function Com_chat:hideKeyPad(...)
	self.input:closeKeyboard()
end
function Com_chat:editBoxTextEvent(strEventName, pSender)
	local edit = pSender
	if strEventName == "began" then
		if self.parent and self.parent.showKeyboardMask then
			self.parent:showKeyboardMask()
		end
	elseif strEventName == "ended" then
	elseif strEventName == "return" then
		if self.parent and self.parent.hideKeyboardMask then
			self.parent:hideKeyboardMask()
		end
	elseif strEventName == "changed" then
	end
end
function Com_chat:onShow()
end
function Com_chat:initData(parent)
	self.ListData, _UPVALUE0_, self.parent = nil, nil, parent
	self.isShowHis = false
	self.controllers.c1:setSelectedIndex(self.isShowHis and 1 or 0)
end
function Com_chat:setMsgData(msgData)
	table.insert(self.ListData, msgData)
	self.fields.List:setNumItems(#self.ListData)
	self.fields.List:jumpToBottom()
end
function Com_chat:itemRenderer_List(index, obj)
	local data = self.ListData[index + 1]
	local name = _p(data.sender.userInfo.nickName) .. _p(": ")
	local retStr = string.htmlspecialchars(data.content.content)
	retStr = RemoveStringSpecial(retStr)
	local camp = activity_9001731_Ctrl:getCampByUid(data.sender.userInfo.uid)
	local nameStr = fguiHelper.getColorString(gFlyingChessPlayerColor[camp], name)
	obj:setTitle(nameStr .. retStr)
end
function Com_chat:onClick_Button_send(context)
	SoraDPlaySound()
	local content = RemoveStringSpecial(self.input:getText())
	if string.utf8len(content) > 0 then
		_ENV = string.utf8len(content)
		string.utf8len(content).channelId = activity_9001731_Ctrl:getChannelID()
		string.utf8len(content).formatType = gChatMsgContentFormatType.PLAIN_TEXT
		string.utf8len(content).content = content
		local string.utf8len(content).teamType, data = teamDef.teamAreaEnum.ACTIVITY_9001731, string.utf8len(content)
		chatCtrl:reqSendTeamMsg(data)
		self.input:setText("")
	end
end
function Com_chat:onClick_Button_history(context)
	SoraDPlaySound()
	self.isShowHis = not self.isShowHis
	self.controllers.c1:setSelectedIndex(self.isShowHis and 1 or 0)
	if self.controllers.c1:getSelectedIndex() == 1 then
		self.fields.List:setNumItems(#self.ListData)
		self.fields.List:jumpToBottom()
	end
end
return Com_chat
