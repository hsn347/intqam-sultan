local roaringFlameWarRead = include("roaringFlameWarRead")
local roaringFlameWarCtrl = SoraDGetCtrl("roaringFlameWarCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RoaringFlame_TechRewardPanel = class("RoaringFlame_TechRewardPanel", baseFguiPanel)
function RoaringFlame_TechRewardPanel:ctor(...)
	RoaringFlame_TechRewardPanel.super.ctor(self, ...)
	print("RoaringFlame_TechRewardPanel:ctor", self.viewName)
end
function RoaringFlame_TechRewardPanel:onInit()
	print("=======RoaringFlame_TechRewardPanel:onInit")
	self.condition, _ENV, self.reward, _ENV = print, print, print, print
	self.fields.Panel_bg:setString(i18n("flames_dunes_text84"))
	self.fields.Lab_reward:setString(i18n("atlantiswar_text_0019"))
	self.fields.Lab_condition:setString(i18n("common_text_726"))
	self.fields.List_reward:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setItemRenderer(handler(self, self.onConditionRenderer))
	self.fields.Button_claim:setString(i18n("common_text_1146"))
	self.fields.Button_claim:addClickListener(handler(self, self.btnClaimClick))
end
function RoaringFlame_TechRewardPanel:onItemRenderer(index, obj)
	obj:initData(self.reward[index + 1].id, self.reward[index + 1].count)
end
function RoaringFlame_TechRewardPanel:onConditionRenderer(index, obj)
	obj:initData(self.condition[index + 1], self)
end
function RoaringFlame_TechRewardPanel:onShow()
	print("=======RoaringFlame_TechRewardPanel:onShow")
	self.tid = self.param.tid
	self.lv = roaringFlameWarCtrl:getTechnologyLv(self.tid)
	self.cfg = roaringFlameWarRead.getTechnologyCfg(self.tid, 1)
	roaringFlameWarRead = 1
	;(1)[1] = "id"
	;(1)[2] = "count"
	self.reward = serviceFunctions.tableFormat(self.cfg.rewrad_box, 1)
	self.fields.List_reward:setNumItems(#self.reward)
	_ENV = #self.reward
	_ENV, (#self.reward).type = "id", 1
	;("id").id = self.tid
	;(#self.reward).data, ("id").lv = "id", 1
	table.insert(self.condition, #self.reward)
	self.fields.List:setNumItems(#self.condition)
	self:initData()
end
function RoaringFlame_TechRewardPanel:initData()
	self.isClaimed = roaringFlameWarCtrl:isTechnologyBoxClaimed(self.tid, 1)
	self.fields.Button_claim:setString(self.isClaimed and i18n("common_text_1892") or i18n("common_text_1146"))
	self.fields.Button_claim:setBright(not self.isClaimed and 1 <= self.lv)
end
function RoaringFlame_TechRewardPanel:btnClaimClick()
	SoraDPlaySound()
	if self.isClaimed then
		SoraDShowMsgTip(i18n("Stellar_Odyssey_text_03"))
		return
	end
	if self.lv < 1 then
		_ENV = i18n("Stellar_Odyssey_text_03")
		i18n("Stellar_Odyssey_text_03").name = i18n(self.cfg.name)
		SoraDShowMsgTip(i18n("hero_mastery_02", i18n("Stellar_Odyssey_text_03")))
		return
	end
	roaringFlameWarCtrl:reqTechnologyReward(self.tid)
	self:close()
end
return RoaringFlame_TechRewardPanel
