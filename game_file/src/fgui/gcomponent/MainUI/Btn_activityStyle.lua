local mainUIDef = include("mainUIDef")
local activityTimeRead = include("activityTimeRead")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_activityStyle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_activityStyle", Btn_activityStyle)
function Btn_activityStyle:onInit()
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_activityStyle:onShow()
end
function Btn_activityStyle:initData(activityID)
	self.activityID = activityID
	self.cfg = mainUIDef.activityCfg[self.activityID]
	self.fields.icon:setURL(self.cfg.png or activityTimeRead.getActivityIconByID(self.activityID))
	if self.cfg.hideTime then
		self.fields.title:setVisible(false)
		self.fields.bg:setVisible(false)
	else
		self.fields.title:setVisible(true)
		self.fields.bg:setVisible(true)
		if self.cfg.title then
			self.fields.title:setString(self.cfg.title)
		elseif self.cfg.remainTime then
			if self.cfg.remainTime() > 0 then
				if self.cfg.timelast then
					local timelast = self.cfg.timelast()
					self.fields.title:setTimeLast(function(time)
						_ENV = nil
						;(nil).time = time
						return i18n(timelast, nil)
					end)
				end
				self.fields.title:beginTime(self.cfg.remainTime())
			else
				self.fields.title:setString("")
			end
			fguiHelper.setTextWidthHeight(self.fields.title, cc.size(80, 40))
		else
			local eventTime = activityShowCtrl:getTimeInfoByID(self.activityID)
			if eventTime then
				self.fields.title:beginTime(eventTime.timerNode.timer:getRemainTime())
			else
				self.fields.title:setString("")
			end
		end
	end
	if self.cfg.showRed then
		if type(self.cfg.showRed) == "function" then
			self:setReddot(self.cfg.showRed())
		else
			self:setReddot(activityShowCtrl:getReceiveStatusAndNum(self.activityID))
		end
	else
		self:setReddot(false)
	end
end
function Btn_activityStyle:getActivityID()
	return self.activityID
end
function Btn_activityStyle:onBtnClick()
	SoraDPlaySound()
	if self.cfg.onClick then
		self.cfg.onClick(self.activityID)
	else
		clientEventMgr.singleClickEvent(self.activityID)
	end
end
return Btn_activityStyle
