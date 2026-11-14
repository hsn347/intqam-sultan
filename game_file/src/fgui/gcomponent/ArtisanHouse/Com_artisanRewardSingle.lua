local artisanHouseCtrl = SoraDGetCtrl("artisanHouseCtrl")
local artisanHouseltCtrl = include("artisanHouseltCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_artisanRewardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ArtisanHouse/Com_artisanRewardSingle", Com_artisanRewardSingle)
function Com_artisanRewardSingle:onInit()
	self:fixChildrenPos()
	self.fields.Special_List:setItemRenderer(handler(self, self.onSpecialItemRenderer))
	self.fields.Normal_List:setItemRenderer(handler(self, self.onNormalItemRenderer))
end
function Com_artisanRewardSingle:onShow()
end
function Com_artisanRewardSingle:initData(index)
	self.rewardInfo = artisanHouseltCtrl.getRewardInfoByIndex(index)
	self.fields.title:setString(self.rewardInfo.Lv)
	if not self.rewardInfo.LvReward1 then
		artisanHouseltCtrl = self.rewardInfo.LvReward1
	end
	artisanHouseCtrl = self.rewardInfo.Lv
	self.rewardInfo.Lv[1] = "id"
	self.rewardInfo.Lv[2] = "count"
	self.normalReward = serviceFunctions.tableFormat(self.rewardInfo.LvReward1, self.rewardInfo.Lv)
	if not self.rewardInfo.LvReward2 then
		artisanHouseltCtrl = self.rewardInfo.LvReward2
	end
	artisanHouseCtrl = self.rewardInfo.Lv
	self.rewardInfo.Lv[1] = "id"
	self.rewardInfo.Lv[2] = "count"
	self.specialReward = serviceFunctions.tableFormat(self.rewardInfo.LvReward2, self.rewardInfo.Lv)
	self.fields.Special_List:setNumItems(#self.specialReward)
	self.fields.Normal_List:setNumItems(#self.normalReward)
	self.controllers.c3:setSelectedIndex(self.rewardInfo.Lv > artisanHouseCtrl:getLevel() and 0 or 1)
end
function Com_artisanRewardSingle:onSpecialItemRenderer(index, object)
	local lv = self.rewardInfo.Lv
	local state = artisanHouseCtrl:isSpecialRewardGetEx(lv) and gBtnTargetStatusDef.GET or artisanHouseCtrl:isSpecialRewardGot(lv) and gBtnTargetStatusDef.GOT or gBtnTargetStatusDef.GO
	object:initData(self.specialReward[index + 1].id, self.specialReward[index + 1].count, state, true, artisanHouseCtrl)
end
function Com_artisanRewardSingle:onNormalItemRenderer(index, object)
	local lv = self.rewardInfo.Lv
	local state = artisanHouseCtrl:isNormalRewardGet(lv) and gBtnTargetStatusDef.GET or artisanHouseCtrl:isNormalRewardGot(lv) and gBtnTargetStatusDef.GOT or gBtnTargetStatusDef.GO
	object:initData(self.normalReward[index + 1].id, self.normalReward[index + 1].count, state, false, artisanHouseCtrl)
end
return Com_artisanRewardSingle
