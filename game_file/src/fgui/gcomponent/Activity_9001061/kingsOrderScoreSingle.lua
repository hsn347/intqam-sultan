local baseComponent = require("fgui.base.baseComponent")
local kingsOrderScoreSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001061/kingsOrderScoreSingle", kingsOrderScoreSingle)
function kingsOrderScoreSingle:onInit()
	self:fixChildrenPos()
end
function kingsOrderScoreSingle:onShow()
end
function kingsOrderScoreSingle:initData(data)
	self.fields.Text_score:setString(data.point)
	self.fields.Text_des:setString(data.txt)
end
return kingsOrderScoreSingle
