local baseFguiPanel = require("fgui.base.baseFguiPanel")
local LegendOfPegasusRewardPanel = class("LegendOfPegasusRewardPanel", baseFguiPanel)
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local snowWolfLostRead = include("snowWolfLostRead")
function LegendOfPegasusRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("LegendOfPegasusRewardPanel:ctor", self.viewName)
end
function LegendOfPegasusRewardPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "LegendOfPegasus"
	end
	return self._packageList
end
function LegendOfPegasusRewardPanel:onInit()
	self.fields.scroll1:setItemRenderer(handler(self, self.onItemRenderer1))
	self.fields.scroll2:setItemRenderer(handler(self, self.onItemRenderer2))
	print("=======LegendOfPegasusRewardPanel:onInit")
end
function LegendOfPegasusRewardPanel:onShow()
	print("=======LegendOfPegasusRewardPanel:onShow")
	self.fields.Panel_bg:setTitle(i18n("common_text_059"))
	_ENV = i18n("common_text_059")
	i18n("common_text_059").name = i18n("npc_name_041")
	self.fields.title1:setString(i18n("snowWolfLost_003", i18n("common_text_059")))
	self.fields.title2:setString(i18n("snowWolfLost_021"))
	local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.LEGEND_OF_PEGASUS_ACTIVITY)
	local grade = param.classtype and param.classtype or 1
	local rewards = worldMapDefine.getWorldBossReward(gBossType.snowWolfLostBoss, grade)
	self.rewards = rewards
	self.fields.scroll1:setNumItems(#rewards)
	local summonRewards = snowWolfLostRead.getWorldBossSummonReward(gBossType.snowWolfLostBoss, grade)
	snowWolfLostRead = grade
	grade[1] = gBossType.snowWolfLostBoss
	grade[2] = grade
	dump(grade, "gBossType.snowWolfLostBoss, grade")
	if summonRewards then
		_UPVALUE3_ = "gBossType.snowWolfLostBoss, grade"
		;("gBossType.snowWolfLostBoss, grade")[1] = "id"
		;("gBossType.snowWolfLostBoss, grade")[2] = "count"
		;("gBossType.snowWolfLostBoss, grade")[3] = "tmp"
		self.summonRewards = serviceFunctions.tableFormat(summonRewards.summonReward, "gBossType.snowWolfLostBoss, grade")
		self.fields.scroll2:setNumItems(#self.summonRewards)
	end
end
function LegendOfPegasusRewardPanel:onHide()
	print("=======LegendOfPegasusRewardPanel:onHide")
end
function LegendOfPegasusRewardPanel:onDispose()
	print("=======LegendOfPegasusRewardPanel:onDispose")
end
function LegendOfPegasusRewardPanel:onItemRenderer1(index, obj)
	fguiHelper.get_fields(obj).item:initData(self.rewards[index + 1], 1)
end
function LegendOfPegasusRewardPanel:onItemRenderer2(index, obj)
	fguiHelper.get_fields(obj).item:initData(self.summonRewards[index + 1].id, self.summonRewards[index + 1].count)
end
return LegendOfPegasusRewardPanel
