local conquestWarReinforcementsCtrl = SoraDGetCtrl("conquestWarReinforcementsCtrl")
local gametop = gModuleMgr.getObject("gametop")
local conquestWarCtrl = SoraDGetCtrl("conquestWarCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local KingdomBattleTargetPanel = class("KingdomBattleTargetPanel", baseFguiPanel)
_ENV = "KingdomBattleTargetPanel"
;("KingdomBattleTargetPanel").person = 1
local ("KingdomBattleTargetPanel").alliance, STAGE_TYPE = 2, "KingdomBattleTargetPanel"
function KingdomBattleTargetPanel:ctor(...)
	self.super.ctor(self, ...)
	print("KingdomBattleTargetPanel:ctor", self.viewName)
end
function KingdomBattleTargetPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function KingdomBattleTargetPanel:onInit()
	print("=======KingdomBattleTargetPanel:onInit")
	self.fields.Com_title:initData(i18n("common_text_3141"), handler(self, self.onClickClose))
	self.fields.Button_go:addClickListener(handler(self, self.onClickBtnGo))
	self.agreeKindom, self.agreeMatchKindom = conquestWarReinforcementsCtrl:getAgreeKindom()
	local nowKingdom = gametop.playertop_:getKingdomID()
	if lordInfoCtrl:getSourceKid() > 0 then
		if self.agreeKindom and nowKingdom == self.agreeKindom then
			self.fields.Button_go:setTitleText(i18n("common_text_2186"))
		elseif self.agreeMatchKindom and self.agreeMatchKindom == nowKingdom then
			self.fields.Button_go:setTitleText(i18n("conquestwar_text_47"))
		else
			self.fields.Button_go:setTitleText(i18n("common_text_2718"))
		end
	else
		self.fields.Button_go:setTitleText(i18n("common_text_2186"))
	end
	self.fields.Com_person:initStageType(STAGE_TYPE.person)
	self.fields.Com_alliance:initStageType(STAGE_TYPE.alliance)
end
function KingdomBattleTargetPanel:onShow()
	print("=======KingdomBattleTargetPanel:onShow")
	self:req4Data()
end
function KingdomBattleTargetPanel:req4Data(...)
	conquestWarCtrl:reqGetConquestWarStageInfo()
	SoraDShowLoading(self:displayObject())
end
function KingdomBattleTargetPanel:initData(target, event)
	SoraDCloseLoading(self:displayObject())
	if event.data then
		local tlb = event.data
		self.fields.Com_person:updateInfo(tlb.personScore, tlb.personStageInfo)
		self.fields.Com_alliance:updateInfo(tlb.allianceScore, tlb.allianceStageInfo)
	end
end
function KingdomBattleTargetPanel:onClickBtnGo(...)
	SoraDPlaySound()
	local conquestWarState = conquestWarCtrl:getConquestWarState()
	if gConquestWarState.PREPARE == conquestWarState then
		SoraDShowMsgTip(i18n("common_text_2830"))
		return
	end
	local matchKid = conquestWarCtrl:getMatchKid()
	SoraDGotoWorldMapPoint(cc.p(600, 600), false, matchKid)
	SoraDRemoveAllPrePanelFromManager(self)
end
return KingdomBattleTargetPanel
