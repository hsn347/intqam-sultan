local radiantDecreeCtrl = SoraDGetCtrl("radiantDecreeCtrl")
local radiantDecreeRead = include("radiantDecreeRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_decreeRewardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RadiantDecree/Com_decreeRewardSingle", Com_decreeRewardSingle)
function Com_decreeRewardSingle:onInit()
	self:fixChildrenPos()
	self.fields.Special_List:setItemRenderer(handler(self, self.onSpecialItemRenderer))
	self.fields.Normal_List:setItemRenderer(handler(self, self.onNormalItemRenderer))
end
function Com_decreeRewardSingle:initData(index)
	self.rewardInfo = radiantDecreeRead.getRewardInfoByIndex(index)
	self.fields.title:setString(self.rewardInfo.Lv)
	self.fields.title:setColor(index == radiantDecreeCtrl:getLevel() and cc.c3b(255, 189, 29) or cc.c3b(255, 255, 255))
	if not self.rewardInfo.LvReward1 then
		radiantDecreeRead = self.rewardInfo.LvReward1
	end
	_ENV = index == radiantDecreeCtrl:getLevel() and cc.c3b(255, 189, 29) or cc.c3b(255, 255, 255)
	;(index == radiantDecreeCtrl:getLevel() and cc.c3b(255, 189, 29) or cc.c3b(255, 255, 255))[1] = "id"
	;(index == radiantDecreeCtrl:getLevel() and cc.c3b(255, 189, 29) or cc.c3b(255, 255, 255))[2] = "count"
	self.normalReward = serviceFunctions.tableFormat(self.rewardInfo.LvReward1, index == radiantDecreeCtrl:getLevel() and cc.c3b(255, 189, 29) or cc.c3b(255, 255, 255))
	if not self.rewardInfo.LvReward2 then
		radiantDecreeRead = self.rewardInfo.LvReward2
	end
	_ENV = index == radiantDecreeCtrl:getLevel() and cc.c3b(255, 189, 29) or cc.c3b(255, 255, 255)
	;(index == radiantDecreeCtrl:getLevel() and cc.c3b(255, 189, 29) or cc.c3b(255, 255, 255))[1] = "id"
	;(index == radiantDecreeCtrl:getLevel() and cc.c3b(255, 189, 29) or cc.c3b(255, 255, 255))[2] = "count"
	self.specialReward = serviceFunctions.tableFormat(self.rewardInfo.LvReward2, index == radiantDecreeCtrl:getLevel() and cc.c3b(255, 189, 29) or cc.c3b(255, 255, 255))
	self.fields.Special_List:setNumItems(#self.specialReward)
	self.fields.Normal_List:setNumItems(#self.normalReward)
	self.controllers.c3:setSelectedIndex(self.rewardInfo.Lv > radiantDecreeCtrl:getLevel() and 0 or 1)
end
function Com_decreeRewardSingle:onSpecialItemRenderer(index, object)
	local lv = self.rewardInfo.Lv
	local state = radiantDecreeCtrl:isSpecialRewardGetEx(lv) and gBtnTargetStatusDef.GET or radiantDecreeCtrl:isSpecialRewardGot(lv) and gBtnTargetStatusDef.GOT or gBtnTargetStatusDef.GO
	object:initData(self.specialReward[index + 1].id, self.specialReward[index + 1].count, state, true, radiantDecreeCtrl)
end
function Com_decreeRewardSingle:onNormalItemRenderer(index, object)
	local lv = self.rewardInfo.Lv
	local state = radiantDecreeCtrl:isNormalRewardGet(lv) and gBtnTargetStatusDef.GET or radiantDecreeCtrl:isNormalRewardGot(lv) and gBtnTargetStatusDef.GOT or gBtnTargetStatusDef.GO
	object:initData(self.normalReward[index + 1].id, self.normalReward[index + 1].count, state, false, radiantDecreeCtrl)
end
function Com_decreeRewardSingle:onShow()
end
return Com_decreeRewardSingle
