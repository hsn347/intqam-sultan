local gametop = gModuleMgr.getObject("gametop")
local kingdomCtrl = gametop.playertop_:getModule("kingdomCtrl")
local nebulaWarRead = include("nebulaWarRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local LegendaryKingSearchPanel = class("LegendaryKingSearchPanel", baseFguiPanel)
function LegendaryKingSearchPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("LegendaryKingSearchPanel:ctor", self.viewName)
end
function LegendaryKingSearchPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function LegendaryKingSearchPanel:onInit()
	print("=======LegendaryKingSearchPanel:onInit")
	self.warCfg, _ENV = print, print
	self.fields.Panel_bg:setString(i18n("common_text_166"))
	self.fields.text_kingdom_tip:setString(i18n("common_text_4259"))
	self.text_war_name = self.fields.text_war_name
	self.text_war_name_1 = self.fields.text_war_name_1
	self.fields.button_go:setTitle(i18n("common_text_477"))
	self.fields.button_go:addClickEventListener(handler(self, self.onClick_button_go))
	local kingdomID = gametop.playertop_:getKingdomID()
	local kingName = ""
	if not worldMapDefine.isLegendLordKingdomID(kingdomID) then
		kingName = tostring(kingdomID)
	end
	self.fields.text_input_kingdom:setString(kingName)
	if not IsArClient then
		_ENV, _ENV = self.fields.text_input_kingdom, IsArClient
		self.fields.text_input_kingdom.kingdomID = worldMapDefine.LEGENDLORD_KINGDOM_ID
		self.warCfg, IsArClient[1], self.fields.text_input_kingdom.title = IsArClient, self.fields.text_input_kingdom, i18n("common_text_4244")
	else
		_ENV, _ENV = self.fields.text_input_kingdom, IsArClient
		self.fields.text_input_kingdom.kingdomID = worldMapDefine.KINGSTAR_KINGDOM_ID
		_ENV, IsArClient[1], self.fields.text_input_kingdom.title = self.fields.text_input_kingdom, self.fields.text_input_kingdom, i18n("kingstarbattle_text_20")
		self.fields.text_input_kingdom.kingdomID = worldMapDefine.LEGENDLORD_KINGDOM_ID
		_ENV, IsArClient[2], self.fields.text_input_kingdom.title = self.fields.text_input_kingdom, self.fields.text_input_kingdom, i18n("common_text_4244")
		self.fields.text_input_kingdom.kingdomID = worldMapDefine.KINGSTAR_KINGDOM_ID_9001646
		_ENV = handler(self, self.onClick_button_go)
		handler(self, self.onClick_button_go).ranklist = i18n("remains_name_01")
		_ENV, IsArClient[3], self.fields.text_input_kingdom.title = self.fields.text_input_kingdom, self.fields.text_input_kingdom, i18n("king_star_rank_text2", handler(self, self.onClick_button_go))
		self.fields.text_input_kingdom.kingdomID = worldMapDefine.KINGSTAR_KINGDOM_ID_9001647
		_ENV = handler(self, self.onClick_button_go)
		handler(self, self.onClick_button_go).ranklist = i18n("king_star_rank_text3")
		self.warCfg, IsArClient[4], self.fields.text_input_kingdom.title = IsArClient, self.fields.text_input_kingdom, i18n("king_star_rank_text2", handler(self, self.onClick_button_go))
	end
	self.fields.List:setItemRenderer(handler(self, self.onSingleRenderer))
end
function LegendaryKingSearchPanel:onSingleRenderer(index, obj)
	obj:initData(self.warCfg[index + 1], self)
end
function LegendaryKingSearchPanel:onShow()
	print("=======LegendaryKingSearchPanel:onShow")
	self.fields.List:setNumItems(#self.warCfg)
end
function LegendaryKingSearchPanel:onClick_button_go(sender, event)
	SoraDPlaySound()
	local kingdomID = tonumber(self.fields.text_input_kingdom:getText()) or 0
	if kingdomCtrl:getIsKingdomMerged(kingdomID) then
		SoraDShowMsgTip(i18n("CombineServers_61"))
		return
	end
	if not kingdomCtrl:isFoundKingdomID(kingdomID) then
		SoraDShowMsgTip(i18n("common_text_4260"))
		return
	end
	_ENV = i18n("common_text_4260")
	i18n("common_text_4260").msg = "MESSAGE_WORLD_MAP_KINGDOM_JUMP"
	i18n("common_text_4260").kid = kingdomID
	SoraDSendMessage(i18n("common_text_4260"))
	self:close()
end
return LegendaryKingSearchPanel
