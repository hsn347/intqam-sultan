local gametop = gModuleMgr.getObject("gametop")
local kohMigrateCtrl = SoraDGetCtrl("kohMigrateCtrl")
local kohMigrateRead = include("kohMigrateRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local kohMigratePreViewPanel = class("kohMigratePreViewPanel", baseFguiPanel)
function kohMigratePreViewPanel:ctor(...)
	kohMigratePreViewPanel.super.ctor(self, ...)
	print("kohMigratePreViewPanel:ctor", self.viewName)
	self.debug = true
	self.activityID = gActivityTimeActivityID.KOH_MIGRATE
end
function kohMigratePreViewPanel:getPackageList()
	_UPVALUE1_ = nil
	;(nil)[1] = "Activity_9001657"
	return nil
end
function kohMigratePreViewPanel:onInit()
	print("=======kohMigratePreViewPanel:onInit")
	self.fields.Com_title:initActivityData(self.activityID, handler(self, self.onClickClose))
	self.fields.Node_tips:setString(i18n("migrant_move_text1"))
	self.fields.atlantisTimeNode:initActivityData(self.activityID)
	self.fields.Button_rank:setString(i18n("migrant_move_text2"))
	self.fields.Button_rank:addClickListener(handler(self, self.btnLegendRankClick))
	self.fields.Button_group:setString(i18n("arossDesc_text_015"))
	self.fields.Button_group:addClickListener(handler(self, self.btnGroupClick))
	self.fields.Button_detail:setString(i18n("arossDesc_text_020"))
	self.fields.Button_detail:addClickListener(handler(self, self.btnDetailClick))
	local kingdomID = gametop.playertop_:getKingdomID()
	_ENV = handler(self, self.btnDetailClick)
	_ENV, _ENV, handler(self, self.btnDetailClick).var1 = "#%d", string.format("#%d", kingdomID), string.format("#%d", kingdomID)
	_ENV, string.format("#%d", kingdomID).var1, ("#%d").color = "#%d", "#%d", "#FFD719"
	string.format("#%d", kingdomID).__default, ("#%d").color = "#%d", "#FEF9EC"
	local kingStr = i18n_html("across_move_myKingdom_name", handler(self, self.btnDetailClick))
	self.fields.Text_king:setString(kingStr)
	if not SoraDFIsRA() then
		_UPVALUE4_ = self.fields.Text_king
		self.fields.Text_king[1] = self.fields.Button_rank
		self.fields.Text_king[2] = self.fields.Button_group
		self.fields.Text_king[3] = self.fields.Text_king
		self.fields.Text_king[4] = self.fields.Com_itemNeed
		for __, v in pairs(self.fields.Text_king) do
			v:fixPos()
		end
		self.fields.Com_itemNeed:fixChildrenPos()
	end
end
function kohMigratePreViewPanel:onShow()
	print("=======kohMigratePreViewPanel:onShow")
	self:initComContent()
	kohMigrateCtrl:reqKingdomData()
	SoraDShowLoading(self)
end
function kohMigratePreViewPanel:initComContent(...)
	local _fields = fguiHelper.get_fields(self.fields.Com_content)
	local kingdomID = gametop.playertop_:getKingdomID()
	local isNewKingdom = kohMigrateRead.checkIsNewkingdom2(kingdomID)
	local c_type = self.fields.Com_content:getController("c_type")
	if isNewKingdom then
		c_type:setSelectedIndex(1)
		_fields.Panel_group:setString(i18n("migrant_move_text57"))
		_fields.Text_group:setString(i18n("migrant_move_text46"))
		_fields.Text_groupDes:setString(i18n("migrant_move_text47"))
	else
		c_type:setSelectedIndex(0)
	end
	_fields.Panel_myInfo:setString(i18n("migrant_move_text58"))
	_fields.Com_myInfo:initData()
	_fields.Panel_kingdomInfo:setString(i18n("migrant_move_text5"))
	_fields.Text_title1:setString(i18n("migrant_move_text3"))
	local kidStr = kohMigrateRead.getMinAndMaxKidStr()
	local legendNum = kohMigrateRead.getLegendLordNumber()
	_ENV = i18n("migrant_move_text3")
	i18n("migrant_move_text3").var2 = kidStr
	i18n("migrant_move_text3").var3 = legendNum
	local ruleStr7 = i18n("migrant_move_rule7", i18n("migrant_move_text3"))
	_fields.Text_des1:setString(ruleStr7)
	_fields.Text_title2:setString(i18n("common_text_090"))
	_fields.Text_des2:setString(i18n("migrant_move_rule8"))
	_fields.Text_title3:setString(i18n("arossDesc_text_001"))
	_fields.Text_des3:setString(i18n("arossDesc_text_019"))
	_fields.kohMigrateResGroup:initViewScale()
end
function kohMigratePreViewPanel:btnLegendRankClick(...)
	SoraDPlaySound()
	uiManager:show("kohMigrateRank")
end
function kohMigratePreViewPanel:btnGroupClick(...)
	SoraDPlaySound()
	uiManager:show("kohMigrateKidGroup")
end
function kohMigratePreViewPanel:btnDetailClick()
	SoraDPlaySound()
	uiManager:show("kohMigrateHelpView")
end
function kohMigratePreViewPanel:refreshKingdomData(...)
	SoraDCloseLoading(self)
	local _fields = fguiHelper.get_fields(self.fields.Com_content)
	_fields.Com_kingdomInfo:initKingdomData()
	_fields.Com_kingdomInfo:updateHeight()
end
return kohMigratePreViewPanel
