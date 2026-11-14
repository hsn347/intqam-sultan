local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001602_RewardPanel = class("Activity_9001602_RewardPanel", baseFguiPanel)
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local snowWolfLostRead = include("snowWolfLostRead")
function Activity_9001602_RewardPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001602_RewardPanel:ctor", self.viewName)
end
function Activity_9001602_RewardPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "LegendOfPegasus"
	end
	return self._packageList
end
_ENV, Activity_9001602_RewardPanel.onInit = function(self)
	self.fields.scroll1:setItemRenderer(handler(self, self.onItemRenderer1))
	self.fields.scroll2:setItemRenderer(handler(self, self.onItemRenderer2))
	print("=======Activity_9001602_RewardPanel:onInit")
end, function(self)
	self.fields.scroll1:setItemRenderer(handler(self, self.onItemRenderer1))
	self.fields.scroll2:setItemRenderer(handler(self, self.onItemRenderer2))
	print("=======Activity_9001602_RewardPanel:onInit")
end
;(function(self)
	self.fields.scroll1:setItemRenderer(handler(self, self.onItemRenderer1))
	self.fields.scroll2:setItemRenderer(handler(self, self.onItemRenderer2))
	print("=======Activity_9001602_RewardPanel:onInit")
end)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001602] = gBossType.firedragonOfAngerBoss
local (function(self)
	self.fields.scroll1:setItemRenderer(handler(self, self.onItemRenderer1))
	self.fields.scroll2:setItemRenderer(handler(self, self.onItemRenderer2))
	print("=======Activity_9001602_RewardPanel:onInit")
end)[gActivityTimeActivityID.NORMAL_ACTIVITY_9001696], bossType = gBossType.firedragonOfAngerBoss2025, function(self)
	self.fields.scroll1:setItemRenderer(handler(self, self.onItemRenderer1))
	self.fields.scroll2:setItemRenderer(handler(self, self.onItemRenderer2))
	print("=======Activity_9001602_RewardPanel:onInit")
end
function Activity_9001602_RewardPanel:onShow()
	print("=======Activity_9001602_RewardPanel:onShow")
	self.fields.Panel_bg:setTitle(i18n("common_text_059"))
	_ENV = i18n("common_text_059")
	i18n("common_text_059").name = i18n("npc_name_041")
	self.fields.title1:setString(i18n("snowWolfLost_003", i18n("common_text_059")))
	self.fields.title2:setString(i18n("snowWolfLost_021"))
	self.activityID = self.param.activityID
	local param = activityShowCtrl:getParamByID(self.activityID)
	local grade = param.classtype and param.classtype or 1
	local rewards = worldMapDefine.getWorldBossReward(bossType[self.activityID], grade)
	self.rewards = rewards
	self.fields.scroll1:setNumItems(#rewards)
	local summonRewards = snowWolfLostRead.getWorldBossSummonReward(bossType[self.activityID], grade)
	bossType = grade
	grade[1] = bossType[self.activityID]
	grade[2] = grade
	dump(grade, "bossType[self.activityID], grade")
	if summonRewards then
		snowWolfLostRead = "bossType[self.activityID], grade"
		;("bossType[self.activityID], grade")[1] = "id"
		;("bossType[self.activityID], grade")[2] = "count"
		;("bossType[self.activityID], grade")[3] = "tmp"
		self.summonRewards = serviceFunctions.tableFormat(summonRewards.summonReward, "bossType[self.activityID], grade")
		self.fields.scroll2:setNumItems(#self.summonRewards)
	end
end
function Activity_9001602_RewardPanel:onHide()
	print("=======Activity_9001602_RewardPanel:onHide")
end
function Activity_9001602_RewardPanel:onDispose()
	print("=======Activity_9001602_RewardPanel:onDispose")
end
function Activity_9001602_RewardPanel:onItemRenderer1(index, obj)
	fguiHelper.get_fields(obj).item:initData(self.rewards[index + 1], 1)
end
function Activity_9001602_RewardPanel:onItemRenderer2(index, obj)
	fguiHelper.get_fields(obj).item:initData(self.summonRewards[index + 1].id, self.summonRewards[index + 1].count)
end
return Activity_9001602_RewardPanel
