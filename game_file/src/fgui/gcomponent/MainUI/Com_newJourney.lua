local baseComponent = require("fgui.base.baseComponent")
local Com_newJourney = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Com_newJourney", Com_newJourney)
function Com_newJourney:onInit()
	self.fields.title:setString(i18n("journey_art_1001"))
	self:addClickListener(handler(self, self.onBtnClick))
	self.fields.Node_etNew:fixPos()
end
function Com_newJourney:onShow()
end
function Com_newJourney:setNewJumpVisible(ret)
	self.fields.Node_etNew:setVisible(ret)
end
function Com_newJourney:onBtnClick()
	SoraDPlaySound()
	if _G.clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEW_SERVER_JOURNEY_ACTIVITY, false) then
		_ENV = false
		userSDKManager.logEvent(gSDKDef.TDonEvent.newJourney_mainUI_enter_click, false)
		uiManager:show("NewJourney")
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:journey:readTime~integer", serviceFunctions.systemTime(), nil)
		self:setNewJumpVisible(false)
	else
		SoraDShowMsgTip(i18n("journey_text_1010"))
	end
end
return Com_newJourney
