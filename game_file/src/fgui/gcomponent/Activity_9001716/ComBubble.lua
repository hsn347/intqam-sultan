local activity_9001716_Ctrl = SoraDGetCtrl("activity_9001716_Ctrl")
local baseComponent = require("fgui.base.baseComponent")
local ComBubble = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Activity_9001716/ComBubble", ComBubble)
function ComBubble:onInit()
end
function ComBubble:onShow()
end
function ComBubble:initData(bubbleReward, isReceived)
	self.isReceived = isReceived
	self.bubbleReward = bubbleReward
	if bubbleReward and activity_9001716_Ctrl:checkCurBoxOpen(self.bubbleReward.boxIndex) then
		self.controllers.ctrlStatus:setSelectedIndex(2)
	elseif bubbleReward and activity_9001716_Ctrl:checkBubbleCanReceive(self.bubbleReward.boxIndex) then
		self.controllers.ctrlStatus:setSelectedIndex(1)
	else
		self.controllers.ctrlStatus:setSelectedIndex(0)
	end
end
return ComBubble
