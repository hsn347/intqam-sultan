local publicRead = include("publicRead")
local baseComponent = require("fgui.base.baseComponent")
local kingsOrderStageRewardNode = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001061/kingsOrderStageRewardNode", kingsOrderStageRewardNode)
function kingsOrderStageRewardNode:onInit()
end
function kingsOrderStageRewardNode:onShow()
end
function kingsOrderStageRewardNode:initData(data, isGot)
	_ENV = nil
	;(nil).num = data.pointID
	self.fields.Text_reward:setString(i18n("common_text_694", nil))
	self.fields.Text_stageScore:setString(string.formatnumberthousands(data.needPoint))
	self.fields.Com_item:initData(data.reward[1], data.reward[2])
	self.fields.Text_name:setString(publicRead.getName(data.reward[1]))
	self.controllers.c1:setSelectedIndex(isGot and 1 or 0)
end
return kingsOrderStageRewardNode
