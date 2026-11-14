local artisanHouseCtrl = SoraDGetCtrl("artisanHouseCtrl")
local artisanHouseltCtrl = include("artisanHouseltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_aritisanLevelReward = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ArtisanHouse/Com_aritisanLevelReward", Com_aritisanLevelReward)
function Com_aritisanLevelReward:onInit()
	self.lvRewardList = artisanHouseltCtrl.getLvRewardList(artisanHouseCtrl:getLevelIndex())
	self.fields.Scroll_Award:setItemRenderer(handler(self, self.onAwardItemRederer))
end
function Com_aritisanLevelReward:initData()
	self.fields.Scroll_Award:setNumItems(#self.lvRewardList)
	self.fields.Scroll_Award:resizeToFit(#self.lvRewardList, 200)
end
function Com_aritisanLevelReward:onAwardItemRederer(index, obj)
	local index = self.lvRewardList[index + 1]
	obj:initData(index)
end
function Com_aritisanLevelReward:onShow()
end
return Com_aritisanLevelReward
