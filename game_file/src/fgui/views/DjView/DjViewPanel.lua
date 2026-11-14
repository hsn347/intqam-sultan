local djCtrl = SoraDGetCtrl("djCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DjViewPanel = class("DjViewPanel", baseFguiPanel)
function DjViewPanel:ctor(...)
	self.isHideCurrentSceneView = true
	DjViewPanel.super.ctor(self, ...)
	print("DjViewPanel:ctor", self.viewName)
end
function DjViewPanel:onInit()
	print("=======DjViewPanel:onInit")
	self.scrollView = self.fields.djScrollView
	self.nodeHead = self.fields.djHead
	self.bottomViewNode = self.fields.djBottomView
	self.djTopic = self.fields.djTopic
	self.fields.Com_title:initData(i18n("Anchor_btn_01"), handler(self, self.obSystemBackKeyClick))
	self.fields.maskArea:setVisible(false)
	self.fields.maskArea:addEventListener(fgui.UIEventType.Click, handler(self, self.hideKeyboardMask))
end
function DjViewPanel:endShow()
	print("=======DjViewPanel:endShow")
	self.djUid = self.djUid or self.param and self.param.djUid or SoraDGetPlayerID()
	print("self.djUid=====", self.djUid)
	self:initData()
end
function DjViewPanel:obSystemBackKeyClick()
	if djCtrl.isBroadcastDJ then
		djCtrl = nil
		djCtrl = nil
		;(nil).time = SoraDConvertSecondToString(djCtrl:getCurDJLiveBeginTime())
		;(nil).content = i18n("Anchor_text_33", nil)
		;(nil).confirmFunc = function()
			djCtrl:sendDJOpen()
			self:close()
		end
		;(nil).cancelString = i18n("common_text_185")
		uiManager:show("MessageBox", nil)
	elseif djCtrl:isInSpeak() then
		djCtrl = nil
		;(nil).content = i18n("Anchor_text_211")
		;(nil).confirmFunc = function()
			djCtrl:sendDJListen(2)
			self:close()
		end
		;(nil).cancelString = i18n("common_text_185")
		uiManager:show("MessageBox", nil)
	elseif djCtrl.isListen then
		djCtrl = nil
		;(nil).handle_ok = function()
			djCtrl:sendDJListen(2)
			self:close()
		end
		;(nil).handle_cancel = function()
			djCtrl:reqInIdle()
			self:close()
		end
		uiManager:show("DjQuitPop", nil)
	else
		self:close()
	end
end
function DjViewPanel:initData()
	self.djInfo = djCtrl:getDJInfo(self.djUid)
	djCtrl = nil
	;(nil).name = self.djInfo.nick_name
	self.fields.Com_title:updateTitle(i18n("Anchor_text_96", nil))
	self.djTopic:initData(self.djUid)
	self.bottomViewNode:initData(self.djUid, self)
	self.nodeHead:initData(self.djUid)
	self.scrollH = self.view:getHeight() - self.nodeHead:getHeight() - self.nodeHead:getPositionY() - (djCtrl:isDJAnchor() and 182 or 120) + 15
	self.scrollView:setHeight(self.scrollH)
	self.scrollView:initData()
end
function DjViewPanel:updateData(target, data)
	self.djInfo = djCtrl:getDJInfo(self.djUid)
	djCtrl = nil
	;(nil).name = self.djInfo.nick_name
	self.fields.Com_title:updateTitle(i18n("Anchor_text_96", nil))
	self.djTopic:initData(self.djUid)
	self.bottomViewNode:initData(self.djUid, self)
	self.nodeHead:updateData(self.djUid)
	local scrollH = self.view:getHeight() - self.nodeHead:getHeight() - self.nodeHead:getPositionY() - (djCtrl:isDJAnchor() and 182 or 120) + 15
	if self.scrollH and scrollH ~= self.scrollH then
		self.scrollH = scrollH
		self.scrollView:setHeight(self.scrollH)
		self.scrollView:refreshMsgScroll()
	end
end
function DjViewPanel:djRoomDismiss()
	self:close()
end
function DjViewPanel:showKeyboardMask()
	self.fields.maskArea:setVisible(true)
end
function DjViewPanel:hideKeyboardMask()
	self.fields.maskArea:runAction(ffa.seq(ffa.delay(0.1), ffa.callFunc(function()
		self.fields.maskArea:setVisible(false)
		self = self.fields.maskArea
		self.fields.maskArea.msg = "MESSAGE_CHAT_CLOSE_IME"
		self.fields.maskArea.viewType = "DjViewPanel"
		SoraDSendMessage(self.fields.maskArea)
	end)))
end
return DjViewPanel
