local baseComponent = require("fgui.base.baseComponent")
local EventCenterSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://EventCenterView/EventCenterSingle", EventCenterSingle)
function EventCenterSingle:onInit()
	self.txtSingleTitle = SoraDCreateTimerLabel(self, self.fields.Text_singleTitle)
	self:addClickListener(handler(self, self.onClickSingle))
	if not SoraDFIsRA() then
		self.fields.Com_new:setURL("img_common_new_en.png")
	end
end
function EventCenterSingle:onShow()
end
function EventCenterSingle:initSingleData(data)
	self.singleData = data
	self.fields.Text_title:setString(data.eventName)
	self.fields.Sprite_eventIcon:setURL(data.flagIcon)
	clientEventMgr.getEventTimeString(data.eventLeftTime, function(timefun)
		local timeLeft = clientEventMgr.getEventTimer(data.eventID)
		if timeLeft then
			self.txtSingleTitle:setTimeLast(timefun)
			self.txtSingleTitle:beginTime(timeLeft.timerNode.timer:getRemainTime())
		end
	end, function(timeMsg)
		self.txtSingleTitle:removeTime()
		self.txtSingleTitle:setString(timeMsg)
	end, function()
		self.txtSingleTitle:removeTime()
		self.txtSingleTitle:setString("")
	end)
	local tips = clientEventMgr.getNewAndRedPointInfo(data.eventID)
	self.fields.Com_new:setVisible(tips.isNew)
	if tips.redPoint > 0 then
		self.fields.Com_redPoint:setVisible(true)
		if tips.redPoint > 99 then
			self.fields.Com_redPoint:setString("99+")
		else
			self.fields.Com_redPoint:setString(tips.redPoint)
		end
	elseif tips.redPoint < 0 then
		self.fields.Com_redPoint:setVisible(true)
		self.fields.Com_redPoint:setString("")
	else
		self.fields.Com_redPoint:setVisible(false)
		self.fields.Com_redPoint:setString("")
	end
	if data.eventState then
		local proxy = uiManager:getProxy("EventCenterView")
		local textColor = proxy ~= nil and proxy:getTextColor(data) or nil
		if textColor then
			self.txtSingleTitle:setColor(textColor)
		end
	end
end
function EventCenterSingle:onClickSingle(EventContext)
	SoraDPlaySound()
	local pID = self:getActivityID()
	local trigger = clientEventMgr.singleClickEvent(pID, 1)
	if not trigger then
		SoraDShowMsgTip(i18n("common_text_699"))
	end
end
function EventCenterSingle:getActivityID(...)
	return self.singleData.eventID
end
function EventCenterSingle:doShowAnimation(...)
	self.transitions.t0:play()
end
return EventCenterSingle
