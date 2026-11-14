local baseComponent = require("fgui.base.baseComponent")
local Com_Score = fgui.extension_class(fgui.GLabel, baseComponent)
fgui.register_extension("ui://pyramidView/Com_Score", Com_Score)
function Com_Score:onInit()
end
function Com_Score:onShow()
end
function Com_Score:setScore(num)
	self.fields.text_score_num:setString(num)
end
return Com_Score
