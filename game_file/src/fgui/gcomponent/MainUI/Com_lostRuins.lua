local baseComponent = require("fgui.base.baseComponent")
local Com_lostRuins = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/Com_lostRuins", Com_lostRuins)
function Com_lostRuins:onInit()
	self.fields.Button_LostGetAward:setString(i18n("common_text_1146"))
	self.fields.Button_LostGetAward:addClickListener(handler(self, self.onBtnClick))
	self.fields.Text_LostTaskStatus:setString(i18n("common_text_2601"))
end
function Com_lostRuins:onShow()
end
function Com_lostRuins:setControlIndex(index)
	self.controllers.c1:setSelectedIndex(index)
end
function Com_lostRuins:setShowType(sType)
	self.sType = sType
	self.controllers.c2:setSelectedIndex(sType)
end
function Com_lostRuins:setProgress(progress, aim)
	local cur = fguiHelper.getColorString("#FE0101", progress)
	_ENV = nil
	;(nil).member = cur
	;(nil).total = aim
	self.fields.Text_Progress:setString(i18n_html("common_text_155", nil))
end
function Com_lostRuins:setTime(time)
	self.fields.timer:setTimeUpdateListener(function(time)
		if time <= 300 then
			self.fields.timer:setTimeColor(cc.c3b(254, 1, 1))
		else
			self.fields.timer:setTimeColor(display.COLOR_WHITE)
		end
	end)
	self.fields.timer:beginTime(time)
end
function Com_lostRuins:onBtnClick()
	SoraDPlaySound("uicontrol", 19)
	if self.sType == 0 then
		SoraDGetCtrl("lostRuinsCtrl"):reqLostRuinsRecieveReward()
	elseif self.sType == 1 then
		SoraDGetCtrl("snowWolfLostCtrl"):reqSnowWolfLostRecieveReward()
	end
end
return Com_lostRuins
