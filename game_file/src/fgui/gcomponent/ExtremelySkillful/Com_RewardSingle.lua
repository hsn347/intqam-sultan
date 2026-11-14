local extremelySkillfulRead = include("extremelySkillfulRead")
local ExtremelySkillfulCtrl = SoraDGetCtrl("ExtremelySkillfulCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_RewardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ExtremelySkillful/Com_RewardSingle", Com_RewardSingle)
function Com_RewardSingle:onInit()
	self:fixChildrenPos()
	self.fields.Hight_List:setItemRenderer(handler(self, self.onItemHRenderer))
	self.fields.Middle_List:setItemRenderer(handler(self, self.onItemMRenderer))
	self.fields.Normal_List:setItemRenderer(handler(self, self.onItemNRenderer))
end
function Com_RewardSingle:onShow()
end
function Com_RewardSingle:initData(rewardInfo)
	self.rewardInfo = rewardInfo
	if self.rewardInfo.Lv > 20 then
		self.fields.title:setString("20+")
	else
		self.fields.title:setString(self.rewardInfo.Lv)
	end
	self.fields.title:setColor(self.rewardInfo.Lv == ExtremelySkillfulCtrl:getLevel() and cc.c3b(255, 189, 29) or cc.c3b(255, 255, 255))
	if not self.rewardInfo.LvReward1 then
		ExtremelySkillfulCtrl = self.rewardInfo.LvReward1
	end
	_UPVALUE2_ = self.rewardInfo.Lv == ExtremelySkillfulCtrl:getLevel() and cc.c3b(255, 189, 29) or cc.c3b(255, 255, 255)
	;(self.rewardInfo.Lv == ExtremelySkillfulCtrl:getLevel() and cc.c3b(255, 189, 29) or cc.c3b(255, 255, 255))[1] = "id"
	;(self.rewardInfo.Lv == ExtremelySkillfulCtrl:getLevel() and cc.c3b(255, 189, 29) or cc.c3b(255, 255, 255))[2] = "count"
	self.normalReward = serviceFunctions.tableFormat(self.rewardInfo.LvReward1, self.rewardInfo.Lv == ExtremelySkillfulCtrl:getLevel() and cc.c3b(255, 189, 29) or cc.c3b(255, 255, 255))
	if not self.rewardInfo.LvReward2 then
		ExtremelySkillfulCtrl = self.rewardInfo.LvReward2
	end
	_UPVALUE2_ = self.rewardInfo.Lv == ExtremelySkillfulCtrl:getLevel() and cc.c3b(255, 189, 29) or cc.c3b(255, 255, 255)
	;(self.rewardInfo.Lv == ExtremelySkillfulCtrl:getLevel() and cc.c3b(255, 189, 29) or cc.c3b(255, 255, 255))[1] = "id"
	;(self.rewardInfo.Lv == ExtremelySkillfulCtrl:getLevel() and cc.c3b(255, 189, 29) or cc.c3b(255, 255, 255))[2] = "count"
	self.middleReward = serviceFunctions.tableFormat(self.rewardInfo.LvReward2, self.rewardInfo.Lv == ExtremelySkillfulCtrl:getLevel() and cc.c3b(255, 189, 29) or cc.c3b(255, 255, 255))
	if not self.rewardInfo.LvReward3 then
		ExtremelySkillfulCtrl = self.rewardInfo.LvReward3
	end
	_UPVALUE2_ = self.rewardInfo.Lv == ExtremelySkillfulCtrl:getLevel() and cc.c3b(255, 189, 29) or cc.c3b(255, 255, 255)
	;(self.rewardInfo.Lv == ExtremelySkillfulCtrl:getLevel() and cc.c3b(255, 189, 29) or cc.c3b(255, 255, 255))[1] = "id"
	;(self.rewardInfo.Lv == ExtremelySkillfulCtrl:getLevel() and cc.c3b(255, 189, 29) or cc.c3b(255, 255, 255))[2] = "count"
	self.hightReward = serviceFunctions.tableFormat(self.rewardInfo.LvReward3, self.rewardInfo.Lv == ExtremelySkillfulCtrl:getLevel() and cc.c3b(255, 189, 29) or cc.c3b(255, 255, 255))
	self.fields.Hight_List:setNumItems(#self.hightReward)
	self.fields.Middle_List:setNumItems(#self.middleReward)
	self.fields.Normal_List:setNumItems(#self.normalReward)
end
function Com_RewardSingle:onItemNRenderer(index, object)
	local lv = self.rewardInfo.Lv
	local state = ExtremelySkillfulCtrl:getRewardState(1, lv)
	object:initData(self.normalReward[index + 1].id, self.normalReward[index + 1].count, state, false)
end
function Com_RewardSingle:onItemMRenderer(index, object)
	local lv = self.rewardInfo.Lv
	local state = ExtremelySkillfulCtrl:getRewardState(2, lv)
	object:initData(self.middleReward[index + 1].id, self.middleReward[index + 1].count, state, not ExtremelySkillfulCtrl:getUnlockFurther())
end
function Com_RewardSingle:onItemHRenderer(index, object)
	local lv = self.rewardInfo.Lv
	local state = ExtremelySkillfulCtrl:getRewardState(3, lv)
	object:initData(self.hightReward[index + 1].id, self.hightReward[index + 1].count, state, not ExtremelySkillfulCtrl:getUnlockFurtherEx())
end
return Com_RewardSingle
