local baseComponent = require("fgui.base.baseComponent")
local Com_crazy = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Com_crazy", Com_crazy)
function Com_crazy:onInit()
	self.fields.Text_crazyTime:setString(i18n("journey_text_1027"))
	self:addClickListener(handler(self, self.onBtnClick))
	self.fields.Sprite_crazyRedPoint:fixPos()
end
function Com_crazy:onShow()
end
function Com_crazy:setRedVisible(ret)
	self.fields.Sprite_crazyRedPoint:setVisible(ret)
end
function Com_crazy:onBtnClick()
	SoraDPlaySound()
	local cumuActiveCtrl = SoraDGetCtrl("cumuActiveCtrl")
	local activityID = cumuActiveCtrl:getActivityID()
	if clientEventMgr.judgeIsOpen(activityID, false) then
		_ENV = false
		;(false).eventid = activityID
		;(false).position = 2
		userSDKManager.logEvent(gSDKDef.TDonEvent.click_crazy_trio, false)
		clientEventMgr.singleClickEvent(activityID, 3)
	end
end
return Com_crazy
