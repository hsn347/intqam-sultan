local baseComponent = require("fgui.base.baseComponent")
local Com_recruitment = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Com_recruitment", Com_recruitment)
function Com_recruitment:onInit()
	self.Text_Time = SoraDCreateTimerLabel(self, self.fields.title)
	self:addClickListener(handler(self, self.onBtnClick))
end
function Com_recruitment:onShow()
end
function Com_recruitment:setTime(time)
	self.Text_Time:beginTime(time)
end
function Com_recruitment:setName(name)
	self.Text_Time:endTime()
	self.Text_Time:setString(name)
end
function Com_recruitment:onBtnClick()
	SoraDPlaySound()
	if SoraDGetCtrl("noviceGiftCtrl"):getIsEnd() then
		clientEventMgr.singleClickEvent(gActivityTimeActivityID.RECRUITMENT_MATERIALS)
	end
end
return Com_recruitment
