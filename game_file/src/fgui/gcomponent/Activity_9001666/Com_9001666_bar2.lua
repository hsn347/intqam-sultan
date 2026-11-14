local baseComponent = require("fgui.base.baseComponent")
local Com_9001666_bar2 = fgui.extension_class(fgui.GProgressBar, baseComponent)
local activity_9001666_Read = include("activity_9001666_Read")
fgui.register_extension("ui://Activity_9001666/Com_9001666_bar2", Com_9001666_bar2)
function Com_9001666_bar2:onInit()
end
function Com_9001666_bar2:onShow()
end
function Com_9001666_bar2:initData(distance)
	if distance == self.distance then
		return
	end
	self.distance = distance
	local nextMatchReward = activity_9001666_Read.getNextMatchReward(distance)
	self:setValue(distance)
	self:setMax(nextMatchReward.distance)
	activity_9001666_Read = nil
	;(nil).num = distance
	self.fields.text_target:setString(i18n("snow_competition_text_21", nil))
	self.fields.icon_get:setVisible(distance >= nextMatchReward.distance)
end
return Com_9001666_bar2
