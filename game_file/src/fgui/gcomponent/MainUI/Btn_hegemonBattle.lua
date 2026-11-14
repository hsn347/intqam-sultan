local hegemonCtrl = SoraDGetCtrl("hegemonCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local hegemonRead = include("hegemonRead")
local baseComponent = require("fgui.base.baseComponent")
local Btn_hegemonBattle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_hegemonBattle", Btn_hegemonBattle)
function Btn_hegemonBattle:onInit()
	self.Text_Time = SoraDCreateTimerLabel(self, self.fields.title)
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_hegemonBattle:onShow()
	local joinBid = hegemonCtrl:getJoinBid()
	local activityID = hegemonRead.getActivityIdByBuildID(joinBid)
	local param = activityShowCtrl:getParamByID(activityID)
	local settleTime = param.timeConfig.settleTime
	local leftTime = settleTime - serviceFunctions.systemTime()
	if 0 < leftTime then
		self.Text_Time:setTimeEndListener(function()
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINSCEN_BOTTOM_SWITCH_UPDATE"
			;(nil).sType = 11
			SoraDSendMessage(nil)
		end)
		self.Text_Time:beginTime(leftTime)
	end
end
function Btn_hegemonBattle:onBtnClick()
	SoraDPlaySound()
	SoraDCreatePanel("hegemonActivity"):show()
end
return Btn_hegemonBattle
