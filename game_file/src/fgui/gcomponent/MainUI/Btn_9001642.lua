local activity_9001642_Ctrl = SoraDGetCtrl("activity_9001642_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local Btn_9001642 = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_9001642", Btn_9001642)
function Btn_9001642:onInit()
	self.Text_Time = SoraDCreateTimerLabel(self, self.fields.title)
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_9001642:onShow()
end
function Btn_9001642:setTime(time)
	self.Text_Time:beginTime(time)
end
function Btn_9001642:onBtnClick()
	SoraDPlaySound()
	local mapObj = activity_9001642_Ctrl:getPhoenixObj()
	if mapObj and next(mapObj) then
		SoraDGotoWorldMapPoint(cc.p(mapObj.x, mapObj.y), true)
		SoraDRemoveAllPanelFromManager()
	end
end
return Btn_9001642
