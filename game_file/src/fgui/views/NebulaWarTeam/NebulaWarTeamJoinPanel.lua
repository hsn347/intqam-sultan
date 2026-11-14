local gametop = gModuleMgr.getObject("gametop")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local nebulaWarUtil = include("nebulaWarUtil")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local NebulaWarTeamJoinPanel = class("NebulaWarTeamJoinPanel", baseFguiPanel)
_ENV = "NebulaWarTeamJoinPanel"
;("NebulaWarTeamJoinPanel").TYPE_JOIN = 1
;("NebulaWarTeamJoinPanel").TYPE_SEARCH = 2
local _ENV, ("NebulaWarTeamJoinPanel").TYPE_RANK, VIEW_TYPE = baseFguiPanel, 3, "NebulaWarTeamJoinPanel"
baseFguiPanel.TYPE_CAMP = 1
local baseFguiPanel.TYPE_KINGDOM, VIEW_SUB_TYPE = 2, baseFguiPanel
function NebulaWarTeamJoinPanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaWarTeamJoinPanel:ctor", self.viewName)
	self.showViewType = nil
	self.showViewSubType = VIEW_SUB_TYPE.TYPE_KINGDOM
	self.costGold = 200
	self.teamShowList, _ENV, self.teamList, _ENV, self.myTeamInfo = nebulaActivityCtrl:getMyTeamInfo(), nebulaActivityCtrl:getMyTeamInfo(), nebulaActivityCtrl:getMyTeamInfo(), nebulaActivityCtrl:getMyTeamInfo(), nebulaActivityCtrl:getMyTeamInfo()
	local checkFull = SoraDConfigGet("Game:NebulaWarTeamJoin:checkFull~bool")
	if checkFull == nil then
		checkFull = true
	end
	self.checkFull = checkFull
end
function NebulaWarTeamJoinPanel:onInit()
	print("=======NebulaWarTeamJoinPanel:onInit")
	self.fields.Com_title:initData(i18n("remains_btn_01"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.List_team:setItemRenderer(handler(self, self.onTeamItemRederer))
	self.fields.List_team:setVirtual()
	self.fields.Button_create:setString(i18n("nebula_war_text_0221"))
	self.fields.Button_create:setCost(gIDDef.GOLD, self.costGold)
	self.fields.Button_create:addClickListener(handler(self, self.onClickBtnCallback))
	self.fields.Button_invite:setString(i18n("nebula_war_text_0051"))
	self.fields.Button_invite:addClickListener(handler(self, self.onClickBtnCallback))
	self.justLook = self.proxy.param and self.proxy.param.justLook
	if self.justLook then
		self.fields.Com_title:setTitle(i18n("nebula_war_text_0307"))
		self.controllers.c_look:setSelectedIndex(1)
	end
	self:initJoinView()
	self:initSearchView()
	local _ENV, defaultClick = self, self.param and self.param.defaultClick or VIEW_TYPE.TYPE_JOIN
	_ENV, _ENV, self.defaultClick = i18n("nebula_war_text_0307")
	_ENV, (1)[1], i18n("nebula_war_text_0307").title = i18n("nebula_war_text_0307")
	_ENV, (1)[2], i18n("nebula_war_text_0307").title = i18n("nebula_war_text_0307")
	self.tabsetArray, (1)[3], i18n("nebula_war_text_0307").title = 1, i18n("nebula_war_text_0307")
	local self.callback, param = handler(self, self.onClickTab), self
	self.fields.com_Tab:initView(param)
end
function NebulaWarTeamJoinPanel:onShow()
	print("=======NebulaWarTeamJoinPanel:onShow")
	self:refreshBeInviteBtn()
	self:refreshCreateBtn()
end
function NebulaWarTeamJoinPanel:onClickHelp(...)
	SoraDPlaySound()
	if IsArClient then
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.NEBULA_AREA)
	else
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.NEBULA_AREA_ROS)
	end
end
function NebulaWarTeamJoinPanel:onTeamItemRederer(index, obj)
	local teamData = self.teamShowList[index + 1]
	_UPVALUE0_ = nil
	;(nil).justLook = self.justLook
	obj:initData(teamData, nil)
end
function NebulaWarTeamJoinPanel:initJoinView(...)
	self.fields.Button_refresh:setString(i18n("common_text_911"))
	self.fields.Button_refresh:addClickListener(handler(self, self.onClickBtnCallback))
	self.fields.Check_hide:addClickListener(handler(self, self.onClickBtnCheck))
	self.fields.Check_hide:setSelected(self.checkFull)
	self.fields.Text_hide:setString(i18n("common_text_4787"))
	_ENV = self.fields.Text_hide.setString
	self.fields.Text_hide.setString[1] = i18n("nebula_war_text_0001")
	local self.fields.Text_hide.setString[2], config = i18n("common_text_479"), self.fields.Text_hide.setString
	_ENV = i18n("common_text_4787")
	i18n("common_text_4787").items = config
	i18n("common_text_4787").selectedIndex = self.showViewSubType - 1
	i18n("common_text_4787").changedCallback = handler(self, self.onComboBoxChanged)
	self:setComboBox(self.fields.ComboBox_invite, i18n("common_text_4787"))
	local dropdown = self.fields.ComboBox_invite:getDropdown()
	self.comboBoxList = dropdown:getChildByName("list")
	self.fields.ComboBox_invite:addClickListener(function()
		self.comboBoxList:setSelectedIndex(self.showViewSubType - 1)
	end)
	if not SoraDFIsRA() then
		self.fields.ComboBox_invite:fixPos()
		self.fields.ComboBox_invite:fixChildrenPos()
		self.fields.Button_refresh:fixPos()
		self.fields.Check_hide:fixPos()
		self.fields.Text_hide:fixPos()
	end
end
function NebulaWarTeamJoinPanel:onComboBoxChanged(...)
	local index = self.fields.ComboBox_invite:getSelectedIndex()
	self.showViewSubType = index + 1
	self:req4Data()
end
function NebulaWarTeamJoinPanel:initSearchView(...)
	self.fields.Button_search:setString(i18n("common_text_166"))
	self.fields.Button_search:addClickListener(handler(self, self.onClickBtnCallback))
	self.Text_input = self.fields.Label_input:getChild("input")
	self.Text_input:setMaxLength(ALLIANCE_NAME_MAX)
	self.Text_input:setPrompt(i18n("nebula_war_text_0021"))
	if not SoraDFIsRA() then
		self.fields.Label_input:fixPos()
		self.fields.Button_search:fixPos()
	end
end
function NebulaWarTeamJoinPanel:onClickBtnCallback(EventContext)
	SoraDPlaySound()
	local sender = EventContext:getSender()
	if sender == self.fields.Button_create then
		if not SoraDEnoughGold(self.costGold) then
			return
		end
		local ok, err = nebulaWarUtil.checkCreateTeam()
		if ok then
			uiManager:show("NebulaWarTeamCreate")
		end
	elseif sender == self.fields.Button_invite then
		uiManager:show("NebulaWarTeamBeInvite")
	elseif sender == self.fields.Button_refresh then
		self:req4Data()
	elseif sender == self.fields.Button_search then
		local name = self.Text_input:getText()
		local teamDef = include("teamDef")
		_ENV = "NebulaWarTeamCreate"
		;("NebulaWarTeamCreate").lenMax = ALLIANCE_NAME_MAX
		local ok, err = teamDef.namkVailidCheck(name, "NebulaWarTeamCreate")
		if ok then
			self.myTeamInfo:reqTeamSearch(nil, nil, name)
			SoraDShowLoading(self:displayObject())
		elseif err == gErrDef.Err_NICKNAME_MIN_SIZE then
			SoraDShowMsgTip(i18n("nebula_war_text_0226"))
		else
			SoraDShowMsgTip(i18n("notice_0071"))
		end
	end
end
function NebulaWarTeamJoinPanel:onClickTab(tag)
	if tag == VIEW_TYPE.TYPE_RANK then
		local justLook = self.justLook
		self:closePanel()
		VIEW_TYPE = nil
		;(nil).justLook = justLook
		uiManager:show("NebulaWarTeamRank", nil)
		return
	end
	if self.showViewType == tag then
		return
	end
	self.showViewType = tag
	self.controllers.c_viewType:setSelectedIndex(self.showViewType - 1)
	self:req4Data()
end
function NebulaWarTeamJoinPanel:refreshBeInviteBtn(...)
	if self.myTeamInfo:isHasInvitedInfo() then
		self.fields.Button_invite:setReddot(true)
	else
		self.fields.Button_invite:setReddot(false)
	end
end
function NebulaWarTeamJoinPanel:req4Data()
	if self.showViewType == VIEW_TYPE.TYPE_JOIN then
		if self.showViewSubType == VIEW_SUB_TYPE.TYPE_CAMP then
			self.myTeamInfo:reqTeamSearch()
			SoraDShowLoading(self:displayObject())
		elseif self.showViewSubType == VIEW_SUB_TYPE.TYPE_KINGDOM then
			local currentKid = gametop.playertop_:getKingdomID()
			self.myTeamInfo:reqTeamSearch(currentKid)
			SoraDShowLoading(self:displayObject())
		end
		self.fields.List_team:setNumItems(0)
	elseif self.showViewType == VIEW_TYPE.TYPE_SEARCH then
		self.fields.List_team:setNumItems(0)
		self.fields.Text_notice:setVisible(true)
		self.fields.Text_notice:setString(i18n("nebula_war_text_0201"))
	end
end
function NebulaWarTeamJoinPanel:refreshTeamList(teamList)
