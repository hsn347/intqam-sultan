local baseComponent = require("fgui.base.baseComponent")
local Btn_common = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://MainUI/Btn_common", Btn_common)
function Btn_common:onInit()
	self.fields.lab_red:fixPos()
	self:addClickListener(handler(self, self.onBtnClick))
end
function Btn_common:onShow()
end
function Btn_common:setModel(model)
	self.model = model
end
function Btn_common:setRed(num)
	self.fields.lab_red:setVisible(0 < num)
	self.fields.lab_red:setTitle(num)
end
function Btn_common:onBtnClick()
	SoraDPlaySound()
	if self.model == 20 then
		SoraDCreatePanel("lostRuinsRecordView"):show()
	elseif self.model == 21 then
		SoraDCreatePanel("windTowerHistoryView"):show()
	elseif self.model == 22 then
		uiManager:show("SnowWolfRecord")
	elseif self.model == 39 then
		uiManager:show("IceDragonRecord")
	elseif self.model == 42 then
		uiManager:show("LegendOfPegasusRecord")
	elseif self.model == 46 then
		_ENV = nil
		;(nil).activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001602
		uiManager:show("Activity_9001602_Record", nil)
	elseif self.model == 53 then
		_ENV = nil
		;(nil).activityID = gActivityTimeActivityID.NORMAL_ACTIVITY_9001696
		uiManager:show("Activity_9001602_Record", nil)
	end
end
return Btn_common
