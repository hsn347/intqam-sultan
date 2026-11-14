local activity_9001716_Ctrl = SoraDGetCtrl("activity_9001716_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local ComBubbleGold = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001716/ComBubbleGold", ComBubbleGold)
function ComBubbleGold:onInit()
end
function ComBubbleGold:onShow()
end
function ComBubbleGold:initData(bubbleReward)
	self.bubbleReward = bubbleReward
	if activity_9001716_Ctrl:checkCurBoxOpen(self.bubbleReward.boxIndex) then
		self.controllers.ctrlStatus:setSelectedIndex(2)
	elseif activity_9001716_Ctrl:checkBubbleCanReceive(self.bubbleReward.boxIndex) then
		self.controllers.ctrlStatus:setSelectedIndex(1)
	else
		self.controllers.ctrlStatus:setSelectedIndex(0)
	end
end
return ComBubbleGold
