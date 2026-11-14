local baseComponent = require("fgui.base.baseComponent")
local PetClaimButton = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://PetFguiView/PetClaimButton", PetClaimButton)
function PetClaimButton:onInit()
	self.fields.title:setString(i18n("common_text_1146"))
	self.text_time = SoraDCreateTimerLabel(self, self.fields.text_time)
	self.text_time:setTimeLast(function(strTime)
		return strTime
	end)
end
function PetClaimButton:onShow()
end
function PetClaimButton:initData(leftTime)
	local isInCd = leftTime and 0 < leftTime
	self.fields.icon:setGrayed(isInCd)
	self:setTouchable(not isInCd)
	self.fields.title:setVisible(not isInCd)
	self.fields.icon_time:setVisible(isInCd)
	self.fields.text_time:setVisible(isInCd)
	if isInCd then
		self.text_time:setString(SoraDConvertSecondToString(leftTime))
		self.text_time:beginTime(leftTime)
	end
end
return PetClaimButton
