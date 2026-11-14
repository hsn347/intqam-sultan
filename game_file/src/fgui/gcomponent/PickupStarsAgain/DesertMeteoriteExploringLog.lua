local baseComponent = require("fgui.base.baseComponent")
local DesertMeteoriteExploringLog = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://PickupStarsAgain/DesertMeteoriteExploringLog", DesertMeteoriteExploringLog)
function DesertMeteoriteExploringLog:onInit()
	_UPVALUE5_, self.index = nil, 1
	self.strs, (nil)[1] = nil, i18n("pickup_star_014")
	self.strs, (nil)[2] = nil, i18n("pickup_star_014") .. "."
	self.strs, (nil)[3] = nil, i18n("pickup_star_014") .. ".."
	self.strs, (nil)[4] = nil, i18n("pickup_star_014") .. "..."
	self.strs, (nil)[5] = nil, i18n("pickup_star_014") .. "...."
end
function DesertMeteoriteExploringLog:onShow()
	self:updateView()
	SoradCreateTimer(self, handler(self, self.updateView), false)
end
function DesertMeteoriteExploringLog:updateView()
	self:setString(self.strs[self.index])
	self.index = self.index + 1
	if self.index > #self.strs then
		self.index = 1
	end
end
function DesertMeteoriteExploringLog:showBg(value)
	self.fields.bg:setVisible(value)
end
return DesertMeteoriteExploringLog
