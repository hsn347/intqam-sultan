local baseComponent = require("fgui.base.baseComponent")
local Btn_crazyTrio = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_crazyTrio", Btn_crazyTrio)
function Btn_crazyTrio:onInit()
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_crazyTrio:onShow()
end
function Btn_crazyTrio:setRed(num)
	self.fields.lab_red:setTitle(num)
	self.fields.lab_red:setVisible(0 < num)
end
function Btn_crazyTrio:onBtnClick()
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
return Btn_crazyTrio
