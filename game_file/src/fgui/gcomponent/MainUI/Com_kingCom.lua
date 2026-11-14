local baseComponent = require("fgui.base.baseComponent")
local Com_kingCom = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Com_kingCom", Com_kingCom)
function Com_kingCom:onInit()
	self.Text_Time = SoraDCreateTimerLabel(self, self.fields.Text_Time)
	self:addClickListener(handler(self, self.onBtnClick))
	self.fields.Label_reddot:fixPos()
end
function Com_kingCom:onShow()
end
function Com_kingCom:setTime()
	self.Text_Time:setTimeLast(function(ticket)
		return i18n(ticket)
	end)
	self.Text_Time:setTimeEndListener(function()
		self:setVisible(false)
		self = self
		self.msg = "MESSAGE_MAINUI_TOP_LEFTNODE_2_REFRESH"
		SoraDSendMessage(self)
	end)
	local activityTime = SoraDGetCtrl("activityShowCtrl"):getTimeInfoByID(gActivityTimeActivityID.NEW_SERVER_RANK_MATCH)
	if activityTime then
		self.Text_Time:beginTime(activityTime.timerNode.timer:getRemainTime())
	end
end
function Com_kingCom:setRed(ret)
	self.fields.Label_reddot:initData(ret, 0)
end
function Com_kingCom:onBtnClick()
	SoraDPlaySound("uicontrol", 18)
	if SoraDGetCastleLv() >= CASTLE_LV5_LIMITED then
		SoraDCreatePanel("kingCompetitionView"):show()
	else
		_ENV = nil
		;(nil).num = CASTLE_LV5_LIMITED
		SoraDShowMsgTip(i18n("common_text_1795", nil))
	end
	_ENV = i18n("common_text_1795", nil)
	i18n("common_text_1795", nil).msg = "MESSAGE_MAINCITYVIEW_LEAVE_MOVE_MODE"
	SoraDSendMessage(i18n("common_text_1795", nil))
end
return Com_kingCom
