local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local snowWolfLostRead = include("snowWolfLostRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local IceDragonLostRewardPanel = class("IceDragonLostRewardPanel", baseFguiPanel)
function IceDragonLostRewardPanel:ctor(...)
	self.super.ctor(self, ...)
	print("IceDragonLostRewardPanel:ctor", self.viewName)
end
function IceDragonLostRewardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function IceDragonLostRewardPanel:onInit()
	print("=======IceDragonLostRewardPanel:onInit")
	self.fields.scroll1:setItemRenderer(handler(self, self.onItemRenderer1))
	self.fields.scroll2:setItemRenderer(handler(self, self.onItemRenderer2))
end
function IceDragonLostRewardPanel:onItemRenderer1(index, obj)
	obj:initData(self.rewards[index + 1], 1)
end
function IceDragonLostRewardPanel:onItemRenderer2(index, obj)
	obj:initData(self.summonRewards[index + 1].id, self.summonRewards[index + 1].count)
end
function IceDragonLostRewardPanel:onShow()
	print("=======IceDragonLostRewardPanel:onShow")
	self.fields.Panel_bg:setTitle(i18n("hero_title_02"))
	_ENV = i18n("hero_title_02")
	i18n("hero_title_02").name = i18n("icedragon_lost_21")
	self.fields.title1:setString(i18n("icedragon_lost_03", i18n("hero_title_02")))
	self.fields.title2:setString(i18n("snowWolfLost_021"))
	local param = activityShowCtrl:getParamByID(gActivityTimeActivityID.ICE_DRAGON_LOST)
	local grade = param.classtype and param.classtype or 1
	local rewards = worldMapDefine.getWorldBossReward(gBossType.iceDragonLostBoss, grade)
	self.rewards = rewards
	self.fields.scroll1:setNumItems(#rewards)
	local summonRewards = snowWolfLostRead.getWorldBossSummonReward(gBossType.iceDragonLostBoss, grade)
	if summonRewards then
		_UPVALUE3_ = i18n("snowWolfLost_021")
		i18n("snowWolfLost_021")[1] = "id"
		i18n("snowWolfLost_021")[2] = "count"
		i18n("snowWolfLost_021")[3] = "tmp"
		self.summonRewards = serviceFunctions.tableFormat(summonRewards.summonReward, i18n("snowWolfLost_021"))
		self.fields.scroll2:setNumItems(#self.summonRewards)
	end
end
return IceDragonLostRewardPanel
