local baseFguiPanel = require("fgui.base.baseFguiPanel")
local BeastCanyonResultPanel = class("BeastCanyonResultPanel", baseFguiPanel)
function BeastCanyonResultPanel:ctor(...)
	self.super.ctor(self, ...)
	print("BeastCanyonResultPanel:ctor", self.viewName)
end
function BeastCanyonResultPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function BeastCanyonResultPanel:onInit()
	print("=======BeastCanyonResultPanel:onInit")
	self.activityID = self.proxy.param.activityID or gActivityTimeActivityID.DIVINE_BEAST_CANYON_ACTIVITY
	self.resultType = self.proxy.param.resultType
	self.bossType = self.proxy.param.bossType
	self.rewardList = self.proxy.param.reward
	self.damage = self.proxy.param.damage
	self.fields.title:setString(self.resultType == 1 and i18n("Divinebeastcanyon_text_18") or i18n("Divinebeastcanyon_text_23"))
	self.fields.Text_Reward:setString(i18n("feast_the_world_text_14"))
	self.fields.Button_Confirm:setString(i18n("common_text_204"))
	self.fields.Button_Confirm:addClickEventListener(handler(self, self.onClickConfirm))
	_ENV = handler(self, self.onClickConfirm)
	_ENV, _ENV, handler(self, self.onClickConfirm).num = self.damage, string.formatnumberthousands(self.damage), string.formatnumberthousands(self.damage)
	string.formatnumberthousands(self.damage).num, self.damage.color = self.damage, "#FFD43E"
	self.fields.Text_Damage:setString(i18n_html(self.resultType == 1 and "Divinebeastcanyon_text_19" or "Divinebeastcanyon_text_24", handler(self, self.onClickConfirm)))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
	self.fields.List:setNumItems(#self.rewardList)
	self.fields.Com_Bar:setDamage(self.activityID, self.bossType, self.damage)
end
function BeastCanyonResultPanel:onShow()
	print("=======BeastCanyonResultPanel:onShow")
end
function BeastCanyonResultPanel:onItemRederer(index, target)
	target:initData(self.rewardList[index + 1].id, self.rewardList[index + 1].count)
end
function BeastCanyonResultPanel:onClickConfirm()
	SoraDPlaySound()
	self:close()
end
function BeastCanyonResultPanel:onHide()
	SoraDMailGainItems(self.rewardList, true)
end
return BeastCanyonResultPanel
