local baseComponent = require("fgui.base.baseComponent")
local EventCenterPage = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://EventCenterView/EventCenterPage", EventCenterPage)
function EventCenterPage:onInit()
	self.Text_time = SoraDCreateTimerLabel(self, self.fields.Text_time)
	self:addClickListener(handler(self, self.onClickPage))
	if not SoraDFIsRA() then
		self.fields.Image_time:fixPos()
		self.fields.Image_time:fix()
		self.fields.Icon_hourglass:fixPos()
		self.fields.Text_time:fixPos()
	end
end
function EventCenterPage:onShow()
end
function EventCenterPage:initPageData(data)
	self.singleData = data
	self.fields.Text_name:setString(data.eventName)
	self.fields.Image_bg:setURL(data.pageBg)
	clientEventMgr.getEventTimeString(data.eventLeftTime, function(timefun)
		self.controllers.c_time:setSelectedIndex(0)
		local timeLeft = clientEventMgr.getEventTimer(data.eventID)
		if timeLeft then
			self.Text_time:setTimeLast(timefun)
			self.Text_time:beginTime(timeLeft.timerNode.timer:getRemainTime())
		end
	end, function(timeMsg)
		self.controllers.c_time:setSelectedIndex(1)
		self.Text_time:removeTime()
		self.Text_time:setString(timeMsg)
	end, function()
		self.controllers.c_time:setSelectedIndex(2)
		self.Text_time:removeTime()
	end)
	if data.eventState then
		local proxy = uiManager:getOrCreateProxy("EventCenterView")
		local textColor = proxy:getTextColor(data)
		if textColor then
			self.Text_time:setColor(textColor)
		end
	end
end
function EventCenterPage:onClickPage(EventContext)
	SoraDPlaySound()
	local pID = self.singleData.eventID
	local trigger = clientEventMgr.singleClickEvent(pID, 1)
	if not trigger then
		SoraDShowMsgTip(i18n("common_text_699"))
	end
end
return EventCenterPage
