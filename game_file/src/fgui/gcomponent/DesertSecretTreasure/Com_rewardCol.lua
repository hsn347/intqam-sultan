local gametop = gModuleMgr.getObject("gametop")
local desertTreasureCtrl = gametop.playertop_:getModule("desertTreasureCtrl")
local desertTreasureltCtrl = include("desertTreasureltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_rewardCol = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://DesertSecretTreasure/Com_rewardCol", Com_rewardCol)
function Com_rewardCol:onInit()
end
function Com_rewardCol:initData()
	self.group = desertTreasureCtrl:getGroup()
	self.data = desertTreasureltCtrl.getAward(self.group)
	self.getCol = desertTreasureCtrl:getTreasure()
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
