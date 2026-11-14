local baseComponent = require("fgui.base.baseComponent")
local Com_newServerBack = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Com_newServerBack", Com_newServerBack)
function Com_newServerBack:onInit()
	self.Text_Time = SoraDCreateTimerLabel(self, self.fields.title)
	self.Text_Time:setTimeLast(function(timeStr)
		return i18n("activity_name_9001404") .. "\n" .. timeStr
	end)
	self:addClickListener(handler(self, self.onBtnClick))
	self.fields.Label_reddot:fixPos()
	self.fields.Node_etNew:fixPos()
end
function Com_newServerBack:onShow()
end
function Com_newServerBack:setTime(time)
	self.Text_Time:beginTime(time)
end
function Com_newServerBack:setNewJumpVisible(ret)
	self.fields.Node_etNew:setVisible(ret)
end
function Com_newServerBack:setRedVisible(ret)
	self.fields.Label_reddot:initData(ret)
end
function Com_newServerBack:onBtnClick()
	SoraDPlaySound()
	if clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEW_START_OLDMAIN_ACTIVITY) then
		uiManager:show("NewStart")
	elseif clientEventMgr.judgeIsOpen(gActivityTimeActivityID.NEW_START_NEWMAIN_ACTIVITY) then
		clientEventMgr.singleClickEvent(gActivityTimeActivityID.NEW_START_NEWMAIN_ACTIVITY)
	end
end
return Com_newServerBack
