local gametop = gModuleMgr.getObject("gametop")
local allianceScience = gametop.playertop_:getModule("allianceScience")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AllianceSciencePanel = class("AllianceSciencePanel", baseFguiPanel)
function AllianceSciencePanel:ctor(...)
	self.super.ctor(self, ...)
	print("AllianceSciencePanel:ctor", self.viewName)
end
function AllianceSciencePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function AllianceSciencePanel:onInit()
	print("=======AllianceSciencePanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_191"), handler(self, self.onClickClose))
	_ENV = i18n("common_text_191")
	_ENV, _ENV, i18n("common_text_191").defaultClick = handler(self, self.onClickClose)
	handler(self, self.onClickClose).title = i18n("alliance_prosperity_text_23")
	_ENV, handler(self, self.onClickClose)[1], handler(self, self.onClickClose).tag = handler(self, self.onClickClose)
	handler(self, self.onClickClose).title = i18n("alliance_prosperity_text_12")
	i18n("common_text_191").tabsetArray, handler(self, self.onClickClose)[2], handler(self, self.onClickClose).tag = handler(self, self.onClickClose)
	i18n("common_text_191").callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView((i18n("common_text_191")))
	self:greenPointUpdate()
end
function AllianceSciencePanel:onShow()
	print("=======AllianceSciencePanel:onShow")
end
function AllianceSciencePanel:onClickTab(tag)
	print("tag", tag)
	if tag == 2 and not allianceScience:isProsperityUnlock() then
		SoraDShowMsgTip(i18n("alliance_prosperity_text_21"))
		self.fields.Com_tab:setTabIndex(1)
		return
	end
	self.curViewType = tag
	self.controllers.c1:setSelectedIndex(tag - 1)
end
function AllianceSciencePanel:jumpToSicence(sid)
	self.fields.Com_science:jumpToSicence(sid)
end
function AllianceSciencePanel:endShow()
	local allianceDesRead = include("allianceDesRead")
	if allianceDesRead.getPlayerConquestWarMigration() or allianceDesRead.getPlayerBattleGroundMigration() then
		self:removeFromParent()
	elseif self.proxy.param and self.proxy.param.sid then
		self:jumpToSicence(self.proxy.param.sid)
	end
end
function AllianceSciencePanel:greenPointUpdate(...)
	local rewardsCount = allianceScience:getProsperityRewardsCount()
	self.fields.Com_tab:setBtnRedDot(2, 0 < rewardsCount, -1)
end
return AllianceSciencePanel
