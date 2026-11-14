local kingsOrderRead = include("kingsOrderRead")
local baseComponent = require("fgui.base.baseComponent")
local kingsOrderStageNode = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001061/kingsOrderStageNode", kingsOrderStageNode)
function kingsOrderStageNode:onInit()
end
function kingsOrderStageNode:onShow()
end
function kingsOrderStageNode:initData(index, stageID, curStage)
	self.fields.Text_stage:setString(index)
	if not stageID or curStage < index then
		self.fields.Text_stageName:setString("???")
		self.controllers.c1:setSelectedIndex(2)
	else
		local state = index < curStage and 1 or 0
		self.controllers.c1:setSelectedIndex(state)
		self.fields.Text_stageName:setString(i18n(kingsOrderRead.getSectionName(stageID)))
	end
end
return kingsOrderStageNode
