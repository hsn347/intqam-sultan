local gametop = gModuleMgr.getObject("gametop")
local activity_9001654_Ctrl = gametop.playertop_:getModule("activity_9001654_Ctrl")
local activity_9001654_Read = include("activity_9001654_Read")
local baseComponent = require("fgui.base.baseComponent")
local Com_rewardCol = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001654/Com_rewardCol", Com_rewardCol)
function Com_rewardCol:onInit()
end
function Com_rewardCol:initData()
	self.group = activity_9001654_Ctrl:getGroup()
	self.data = activity_9001654_Read.getAward(self.group)
	self.getCol = activity_9001654_Ctrl:getTreasure()
	local i, getFlag
	for i = 1, 12 do
		getFlag = self.getCol[tostring(self.data[i].index)] and true or false
		self:getChildAt(i - 1):initData(self.data[i], getFlag)
	end
end
function Com_rewardCol:showUsm(index)
	self:getChildAt(index - 1):showUsm()
end
function Com_rewardCol:onShow()
end
return Com_rewardCol
