local djCtrl = SoraDGetCtrl("djCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_joinHead = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://DjView/Com_joinHead", Com_joinHead)
function Com_joinHead:onInit()
	self:addClickListener(handler(self, self.onClick_Button_add))
	self:fixChildrenPos()
end
function Com_joinHead:onShow()
end
function Com_joinHead:initData(data)
	self.data = data
	if self.data then
		self.controllers.c1:setSelectedIndex(1)
		SoraDGetHeadFromManager(self.fields.icon, self.data.headid, self.data.avatar)
		self:setReddot(false)
	else
		self.controllers.c1:setSelectedIndex(0)
		self:setReddot(djCtrl:isDJAnchor() and djCtrl:isHaveApplyInfo())
	end
end
function Com_joinHead:onClick_Button_add(context)
	if djCtrl:isDJAnchor() then
		SoraDPlaySound()
		djCtrl = nil
		;(nil).data = self.data
		uiManager:show("DjToMember", nil)
	elseif self.data then
		if self.data.uid == SoraDGetPlayerID() then
			djCtrl = nil
			;(nil).content = i18n("Anchor_text_107")
			;(nil).confirmFunc = function()
				djCtrl:reqExitSpeak()
			end
			;(nil).cancelString = i18n("common_text_185")
			uiManager:show("MessageBox", nil)
		else
			djCtrl = uiManager
			uiManager.msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
			uiManager.playerID = self.data.uid
			uiManager.kid = self.data.kid
			SoraDSendMessage(uiManager)
		end
	else
		djCtrl = nil
		;(nil).content = i18n("Anchor_text_105")
		;(nil).confirmFunc = function()
			djCtrl:reqApplySpeak()
		end
		;(nil).cancelString = i18n("common_text_185")
		uiManager:show("MessageBox", nil)
	end
end
return Com_joinHead
