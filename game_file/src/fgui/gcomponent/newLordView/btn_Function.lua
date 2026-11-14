local baseComponent = require("fgui.base.baseComponent")
local btn_Function = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://newLordView/btn_Function", btn_Function)
function btn_Function:onInit()
	self.fields.time = SoraDCreateTimerLabel(self, self.fields.time)
	self.fields.time:setVisible(false)
	self.fields.time:setTimeLast(function(ticket, second)
		if second <= 0 then
			self:setEnabled(true)
		end
		return 0 < second and string.format("%ds", second) or ""
	end)
end
function btn_Function:onShow()
end
function btn_Function:setRed(ret, num)
	self.fields.Label_reddot:initData(ret, num)
end
function btn_Function:setTime(ret)
	self.fields.time:setVisible(ret)
	if ret then
		self.fields.time:beginTime(CONTACT_CANCEL_INVITE_FRIEND_INTERVAL)
		self:setEnabled(false)
	end
end
return btn_Function
