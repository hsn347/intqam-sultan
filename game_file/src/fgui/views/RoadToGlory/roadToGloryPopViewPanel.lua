local endlessTrialsCtrl = SoraDGetCtrl("endlessTrialsCtrl")
local collectMapCtrl = SoraDGetCtrl("collectMapCtrl")
local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local roadToGloryPopViewPanel = class("roadToGloryPopViewPanel", baseFguiPanel)
function roadToGloryPopViewPanel:ctor(...)
	roadToGloryPopViewPanel.super.ctor(self, ...)
	print("roadToGloryPopViewPanel:ctor", self.viewName)
end
function roadToGloryPopViewPanel:onInit()
	print("=======roadToGloryPopViewPanel:onInit")
	self.itemID = 836401
	self.fields.Panel_bg:setString(publicRead.getName(self.itemID))
	self.fields.Text_des:setString(publicRead.getDes(self.itemID))
	self.fields.Button_btn:setString(i18n("common_text_678"))
	self.fields.Button_btn:addClickListener(handler(self, self.btnClick))
	self.fields.Btn_item:addLongPressListener(handler(self, self.onLongPress))
	self.fields.Btn_item:addClickListener(handler(self, self.onClick))
end
function roadToGloryPopViewPanel:onShow()
	print("=======roadToGloryPopViewPanel:onShow")
end
function roadToGloryPopViewPanel:onLongPress(button, startPos, endPos)
	self.isLong = true
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_MAINSCEN_COMMON_ICON_TIP"
	;(nil).id = self.itemID
	;(nil).pos = startPos
	SoraDSendMessage(nil)
end
function roadToGloryPopViewPanel:onClick()
	if self.isLong then
		self.isLong = false
	end
end
function roadToGloryPopViewPanel:btnClick()
	SoraDPlaySound()
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.EXCHANGE_ROAD_TO_GLORY) then
		_ENV = nil
		;(nil).id = gActivityTimeActivityID.EXCHANGE_ROAD_TO_GLORY
		uiManager:show("ExchangeEventPage", nil)
		self:close()
	else
		SoraDShowMsgTip(i18n("common_text_2486"))
	end
end
return roadToGloryPopViewPanel
