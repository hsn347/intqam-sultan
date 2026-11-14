local baseComponent = require("fgui.base.baseComponent")
local ProgressBar_war = fgui.extension_class(fgui.GProgressBar, baseComponent)
fgui.register_extension("ui://BuildViewCommon/ProgressBar_war", ProgressBar_war)
function ProgressBar_war:onInit()
end
function ProgressBar_war:onShow()
end
function ProgressBar_war:initData(data)
	local warLv = data.warLv
	local warCurPro = data.warCurPro
	local warToLv = data.warToLv
	self:setValue(warCurPro * 100)
	if 0 < warLv then
		self.fields.Com_warCur:setIcon(SoraDGetLvImg(warLv))
	else
		self.fields.Com_warCur:setIcon("")
	end
	self.fields.Com_warTo:setIcon(SoraDGetLvImg(warToLv))
	local WELevelProMin = 11
	local WELevelProMax = 89
	local totalPro = WELevelProMax - WELevelProMin
	local curP = warCurPro * totalPro + WELevelProMin
	self.fields.bar_cur:setFillAmount(curP / 100)
	local toP = (warCurPro + 0.1) * totalPro + WELevelProMin
	self.fields.bar_to:setFillAmount(toP / 100)
end
return ProgressBar_war
