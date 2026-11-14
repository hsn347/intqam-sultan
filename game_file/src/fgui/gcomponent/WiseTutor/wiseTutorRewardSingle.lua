local wiseTutorCtrl = SoraDGetCtrl("wiseTutorCtrl")
local wiseTutorRead = include("wiseTutorRead")
local baseComponent = require("fgui.base.baseComponent")
local wiseTutorRewardSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WiseTutor/wiseTutorRewardSingle", wiseTutorRewardSingle)
function wiseTutorRewardSingle:onInit()
	self:fixChildrenPos()
	self.fields.Special_List:setItemRenderer(handler(self, self.onSpecialItemRenderer))
	self.fields.Normal_List:setItemRenderer(handler(self, self.onNormalItemRenderer))
end
function wiseTutorRewardSingle:onShow()
end
function wiseTutorRewardSingle:initData(index)
	self.rewardInfo = wiseTutorRead.getRewardInfoByIndex(index)
	self.fields.title:setString(self.rewardInfo.Lv)
	if not self.rewardInfo.LvReward1 then
		wiseTutorRead = self.rewardInfo.LvReward1
	end
	wiseTutorCtrl = self.rewardInfo.Lv
	self.rewardInfo.Lv[1] = "id"
	self.rewardInfo.Lv[2] = "count"
	self.normalReward = serviceFunctions.tableFormat(self.rewardInfo.LvReward1, self.rewardInfo.Lv)
	if not self.rewardInfo.LvReward2 then
		wiseTutorRead = self.rewardInfo.LvReward2
	end
	wiseTutorCtrl = self.rewardInfo.Lv
	self.rewardInfo.Lv[1] = "id"
	self.rewardInfo.Lv[2] = "count"
	self.specialReward = serviceFunctions.tableFormat(self.rewardInfo.LvReward2, self.rewardInfo.Lv)
	self.fields.Special_List:setNumItems(#self.specialReward)
	self.fields.Normal_List:setNumItems(#self.normalReward)
	self.controllers.c3:setSelectedIndex(self.rewardInfo.Lv > wiseTutorCtrl:getLevel() and 0 or 1)
end
function wiseTutorRewardSingle:onSpecialItemRenderer(index, object)
	local lv = self.rewardInfo.Lv
	local state = wiseTutorCtrl:isSpecialRewardGetEx(lv) and gBtnTargetStatusDef.GET or wiseTutorCtrl:isSpecialRewardGot(lv) and gBtnTargetStatusDef.GOT or gBtnTargetStatusDef.GO
	object:initData(self.specialReward[index + 1].id, self.specialReward[index + 1].count, state, true)
end
function wiseTutorRewardSingle:onNormalItemRenderer(index, object)
	local lv = self.rewardInfo.Lv
	local state = wiseTutorCtrl:isNormalRewardGet(lv) and gBtnTargetStatusDef.GET or wiseTutorCtrl:isNormalRewardGot(lv) and gBtnTargetStatusDef.GOT or gBtnTargetStatusDef.GO
	object:initData(self.normalReward[index + 1].id, self.normalReward[index + 1].count, state, false)
end
return wiseTutorRewardSingle
