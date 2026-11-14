local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local manorCityRead = include("manorCityRead")
local baseComponent = require("fgui.base.baseComponent")
local ManorBanquetUI = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://ManorCity/ManorBanquetUI", ManorBanquetUI)
function ManorBanquetUI:onInit()
	self.fields.pb:setBarColor(2)
	self.fields.pb:hideTitle()
	self.fields.pb:showLabelTime()
	self.fields.pb:setVisible(false)
	self.fields.txtTime:setVisible(false)
	self.fields.pb:setValue(0)
end
function ManorBanquetUI:onShow()
end
function ManorBanquetUI:onHide()
	self:clearTimer()
end
function ManorBanquetUI:clearTimer()
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
end
function ManorBanquetUI:updateProgress(isTimerEnd)
