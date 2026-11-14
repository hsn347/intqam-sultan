local baseFguiPanel = require("fgui.base.baseFguiPanel")
local dessertThiefRead = include("dessertThiefRead")
local dessertThiefCtrl = SoraDGetCtrl("dessertThiefCtrl")
local gametop = gModuleMgr.getObject("gametop")
local memberMgr = gametop.playertop_:getModule("memberMgr")
local DessertThieFummonPanel = class("DessertThieFummonPanel", baseFguiPanel)
function DessertThieFummonPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("DessertThieFummonPanel:ctor", self.viewName)
end
function DessertThieFummonPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function DessertThieFummonPanel:onInit()
	print("=======DessertThieFummonPanel:onInit")
	if not SoraDFIsRA() then
		self.view:fixChildrenPos(false, true)
		self.fields.n13:fix()
		self.fields.progress1:fixChildrenPos(false, true)
		self.fields.progress2:fixChildrenPos(false, true)
	end
	self.fields.txt_title:setString(i18n("activity_name_9001540"))
	self.fields.txt_desc:setString(i18n("Dessert_Thief_20"))
	self.fields.progress1:setTitleType(0)
	self.fields.btn_min:addClickEventListener(handler(self, self.onPageClick), -1)
	self.fields.btn_add:addClickEventListener(handler(self, self.onPageClick), 1)
	self.fields.btn_call:setTitle(i18n("Dessert_Thief_05"))
	self.fields.btn_call:addClickEventListener(handler(self, self.onCallClick))
	self.fields.btn_skip:setTitle(i18n("common_text_477"))
	self.fields.btn_skip:addClickEventListener(handler(self, self.onSkipClick))
	dessertThiefCtrl:sendInitMsg()
end
function DessertThieFummonPanel:onShow()
	print("=======DessertThieFummonPanel:onShow")
end
function DessertThieFummonPanel:updateView()
	self.maxLv = dessertThiefRead.getWorldBossMaxLv(gBossType.sweetMeatRobber)
	self.bossData = dessertThiefCtrl:getBossData()
	self.curLv = dessertThiefCtrl:getBossLv()
	if self.selectedLv == nil then
		self.selectedLv = self.curLv > self.maxLv and self.maxLv or self.curLv
	end
	self:updateLv()
end
function DessertThieFummonPanel:updateLv()
	self.bossCfg = dessertThiefRead.getWorldBossCfg(gBossType.sweetMeatRobber, self.selectedLv)
	if self.bossCfg == nil then
		return
	end
	local maxShield = self.bossCfg.shield
	self.fields.progress2:setMax(maxShield)
	if self.bossData ~= nil and self.selectedLv == self.curLv then
		self.fields.progress1:setValue(self.bossData.leftLife)
		self.fields.progress2:setValue(self.bossData.shield)
		self.controllers.c1:setSelectedIndex(3)
	elseif self.selectedLv >= self.curLv then
		self.fields.progress1:setValue(100)
		self.fields.progress2:setValue(maxShield)
		if self.bossData == nil and self.selectedLv == self.curLv then
			self.controllers.c1:setSelectedIndex(0)
		else
			self.controllers.c1:setSelectedIndex(2)
			self.fields.txt_tips:setString(i18n("Dessert_Thief_24"))
		end
	else
		self.fields.progress1:setValue(0)
		self.fields.progress2:setValue(0)
		self.controllers.c1:setSelectedIndex(1)
		self.fields.txt_tips:setString(i18n("Dessert_Thief_23"))
	end
	dessertThiefRead = i18n("Dessert_Thief_23")
	i18n("Dessert_Thief_23").lv1 = self.selectedLv
	i18n("Dessert_Thief_23").lv2 = self.maxLv
	self.fields.txt_lv:setString(i18n("Dessert_Thief_21", i18n("Dessert_Thief_23")))
	dessertThiefRead = i18n("Dessert_Thief_21", i18n("Dessert_Thief_23"))
	i18n("Dessert_Thief_21", i18n("Dessert_Thief_23")).level = self.selectedLv
	self.fields.txt_curSelcted:setString(i18n("common_text_1229", i18n("Dessert_Thief_21", i18n("Dessert_Thief_23"))))
end
function DessertThieFummonPanel:onPageClick(sender, params)
	SoraDPlaySound()
	local curIndex = self.selectedLv + params
	if curIndex > self.maxLv then
		curIndex = self.maxLv
	elseif curIndex <= 0 then
		curIndex = 1
	end
	if self.selectedLv == curIndex then
		return
	end
	self.selectedLv = curIndex
	self:updateLv()
end
function DessertThieFummonPanel:onCallClick()
	SoraDPlaySound()
	local ownmember = memberMgr:getOwnMember()
	local ownRank = ownmember:getProperty("rank")
	if ownRank < gAllianceRank.R4 then
		SoraDShowMsgTip(i18n("alliance_stronghold_text_082"))
		return
	end
	dessertThiefCtrl:reqSweetMeatSumon()
	self:close()
end
function DessertThieFummonPanel:onSkipClick()
	SoraDPlaySound()
	local x, y = dessertThiefCtrl:getBossPosition()
	SoraDRemoveAllPanelFromManager()
	SoraDGotoWorldMapPoint(cc.p(x, y), true)
end
return DessertThieFummonPanel
