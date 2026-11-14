local baseComponent = require("fgui.base.baseComponent")
local Com_event = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Com_event", Com_event)
function Com_event:onInit()
	self.fields.Image_event:setSpriteFrame(RAMADAN_SWITCH and "icon_huodongzhongxin_zhaiyueicon.png" or "btn_main_new_activity.png")
	self.fields.Loader3D:setVisible(false)
	self.fields.Text_eventTime:setString(i18n("buildDes_name_106"))
	self.fields.Panel_tips:setString(i18n("activity_text_03"))
	self.fields.Panel_tips:setVisible(false)
	self:addClickListener(handler(self, self.onBtnClick))
	self.fields.Node_etNew:fixPos()
	self.fields.Sprite_numBg:fixPos()
	self.fields.Panel_tips:fixPos()
end
function Com_event:onShow()
end
function Com_event:setNewJumpVisible(ret)
	self.fields.Node_etNew:setVisible(ret)
end
function Com_event:setRedVisible(ret)
	self.fields.Sprite_numBg:setVisible(ret)
end
function Com_event:showTips()
	self.fields.Panel_tips:setVisible(true)
	_UPVALUE1_ = nil
	;(nil)[1] = ffa.delay(5.0)
	;(nil)[2] = ffa.callFunc(function()
		self.fields.Panel_tips:setVisible(false)
	end)
	;(nil)[3] = ffa.callFunc(function()
		self.fields.Panel_tips:setVisible(false)
	end)
	self.fields.Panel_tips:runAction(ffa.seq(nil))
end
function Com_event:onBtnClick()
	SoraDPlaySound("uicontrol", 12)
	self:popEventFromEventCenter()
	_ENV = self
	self.msg = "MESSAGE_MAINCITYVIEW_LEAVE_MOVE_MODE"
	SoraDSendMessage(self)
end
function Com_event:popEventFromEventCenter()
	if worldMapDefine.isInNewTrial() then
		SoraDShowMsgTip(i18n("devilvalley_tips_08"))
	else
		_ENV = i18n("devilvalley_tips_08")
		i18n("devilvalley_tips_08").logPosition = 2
		uiManager:show("EventCenterView", i18n("devilvalley_tips_08"))
		_ENV = "EventCenterView"
		;("EventCenterView").byUID = true
		local clickTime = SoraDConfigGet("Game:mainUITop:clickEventCenterView~integer", "EventCenterView")
		if clickTime == 0 or not serviceFunctions.isSameDay(clickTime) then
			_ENV = i18n("devilvalley_tips_08")
			i18n("devilvalley_tips_08").byUID = true
			SoraDConfigSet("Game:mainUITop:clickEventCenterView~integer", serviceFunctions.systemTime(), i18n("devilvalley_tips_08"))
		end
	end
end
return Com_event
