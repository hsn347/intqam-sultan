local divineProtectionRead = include("divineProtectionRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_stageReward = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://SanctuaryDivine/Com_stageReward", Com_stageReward)
function Com_stageReward:onInit()
	self.fields.list:getScrollPane():setTouchEffect(false)
	if SoraDFIsRA() then
		self.fields.list:getScrollPane():setPercX(1)
	end
end
function Com_stageReward:onShow()
end
function Com_stageReward:init()
	local cfgList = divineProtectionRead.getAccruedCfgList()
	self.fields.list:getScrollPane():setTouchEffect(5 < #cfgList)
	self:updateData()
end
function Com_stageReward:updateData()
	self.fields.list:getChildAt(0):initData()
end
return Com_stageReward
