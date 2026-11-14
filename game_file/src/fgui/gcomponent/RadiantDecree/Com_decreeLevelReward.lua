local radiantDecreeCtrl = SoraDGetCtrl("radiantDecreeCtrl")
local radiantDecreeRead = include("radiantDecreeRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_decreeLevelReward = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RadiantDecree/Com_decreeLevelReward", Com_decreeLevelReward)
function Com_decreeLevelReward:onInit()
	self.lvRewardList = radiantDecreeRead.getLvRewardList(radiantDecreeCtrl:getLevelIndex())
	self.fields.Scroll_Award:setItemRenderer(handler(self, self.onAwardItemRederer))
end
function Com_decreeLevelReward:initData()
	self.fields.Scroll_Award:setNumItems(#self.lvRewardList)
	self.fields.Scroll_Award:resizeToFit(#self.lvRewardList, 200)
end
function Com_decreeLevelReward:onAwardItemRederer(index, obj)
	local index = self.lvRewardList[index + 1]
	obj:initData(index)
end
function Com_decreeLevelReward:onShow()
end
return Com_decreeLevelReward
