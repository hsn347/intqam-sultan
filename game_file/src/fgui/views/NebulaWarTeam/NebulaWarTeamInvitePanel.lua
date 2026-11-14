local gametop = gModuleMgr.getObject("gametop")
local nebulaActivityCtrl = SoraDGetCtrl("nebulaActivityCtrl")
local nebulaWarUtil = include("nebulaWarUtil")
local teamAreaEnum = include("teamDef").teamAreaEnum
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local useDownloadImagePanel = require("fgui.base.useDownloadImagePanel")
local NebulaWarTeamInvitePanel = class("NebulaWarTeamInvitePanel", useDownloadImagePanel)
_ENV = "NebulaWarTeamInvitePanel"
;("NebulaWarTeamInvitePanel").TYPE_INVITE = 1
local _ENV, ("NebulaWarTeamInvitePanel").TYPE_SEARCH, VIEW_TYPE = useDownloadImagePanel, 2, "NebulaWarTeamInvitePanel"
useDownloadImagePanel.TYPE_MEMBER = 1
local useDownloadImagePanel.TYPE_FRIEND, VIEW_SUB_TYPE = 2, useDownloadImagePanel
function NebulaWarTeamInvitePanel:ctor(...)
	self.super.ctor(self, ...)
	print("NebulaWarTeamInvitePanel:ctor", self.viewName)
	self.showViewType = nil
	self.showViewSubType = VIEW_SUB_TYPE.TYPE_MEMBER
	self.invitedUsers, _ENV, self.memberList, _ENV, self.showViewKid = gametop.playertop_:getKingdomID(), gametop.playertop_:getKingdomID(), gametop.playertop_:getKingdomID(), gametop.playertop_:getKingdomID(), gametop.playertop_:getKingdomID()
end
function NebulaWarTeamInvitePanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function NebulaWarTeamInvitePanel:onInit()
	print("=======NebulaWarTeamInvitePanel:onInit")
	self.teamType = self.proxy.param and self.proxy.param.teamType
	self.fields.Com_title:initData(i18n("common_text_189"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self:refreshTextRemain()
	self:initInviteView()
	self:initSearchView()
	self.fields.List_player:setItemRenderer(handler(self, self.onPlayerItemRederer))
	self.fields.List_player:setVirtual()
	if self.teamType == teamAreaEnum.NEBULA_ALL_STAR then
		self.fields.Com_title:setHelpCallBack(nil)
		self.showViewType = VIEW_TYPE.TYPE_SEARCH
		self:refreshMemberList()
		self.fields.Button_inviteList:setString(i18n("NebulaAllstar_84"))
		self.fields.Button_inviteList:addClickListener(handler(self, self.onClickBtnInviteList))
	else
		_ENV = self.fields.Button_inviteList.addClickListener
		_ENV, _ENV, self.fields.Button_inviteList.addClickListener.defaultClick = handler(self, self.onClickBtnInviteList)
		handler(self, self.onClickBtnInviteList).title = i18n("common_text_969")
		_ENV, VIEW_TYPE.TYPE_INVITE[1], handler(self, self.onClickBtnInviteList).tag = handler(self, self.onClickBtnInviteList)
		handler(self, self.onClickBtnInviteList).title = i18n("nebula_war_text_0034")
		self.fields.Button_inviteList.addClickListener.tabsetArray, VIEW_TYPE.TYPE_INVITE[2], handler(self, self.onClickBtnInviteList).tag = VIEW_TYPE.TYPE_INVITE, handler(self, self.onClickBtnInviteList)
		local self.fields.Button_inviteList.addClickListener.callback, param = handler(self, self.onClickTab), self.fields.Button_inviteList.addClickListener
		self.fields.com_Tab:initView(param)
	end
end
function NebulaWarTeamInvitePanel:onShow()
	print("=======NebulaWarTeamInvitePanel:onShow")
	if self.teamType == teamAreaEnum.NEBULA_ALL_STAR then
		local myTeamInfo = self:getMyTeamInfo()
		myTeamInfo:reqTeamInvitedUsersInfo()
	end
end
function NebulaWarTeamInvitePanel:onClickHelp(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("nebula_war_text_0225")
	uiManager:show("RuleView", nil)
end
function NebulaWarTeamInvitePanel:refreshTextRemain(...)
	if self.teamType == teamAreaEnum.NEBULA_ALL_STAR then
		local myTeamInfo = self:getMyTeamInfo()
		local memberNum = myTeamInfo:getTeamMemberNum()
		local nebulaAllStarRead = include("nebulaAllStarRead")
		local numMax = nebulaAllStarRead.getTeamNumMax()
		teamAreaEnum = nil
		;(nil).num = memberNum
		;(nil).num2 = numMax
		self.fields.Text_num:setString(i18n("NebulaAllstar_58", nil))
		return
	end
	local remain = 0
	if self.teamType == teamAreaEnum.NEBULA_EMPEROR then
		local nebulaEmperorUtil = include("nebulaEmperorUtil")
		remain = nebulaEmperorUtil.getTeamRemainNum()
	else
		remain = nebulaWarUtil.getTeamRemainNum()
	end
	teamAreaEnum = self.fields.Text_num
	self.fields.Text_num.num = remain
	self.fields.Text_num:setString(i18n("nebula_war_text_0035", self.fields.Text_num))
end
function NebulaWarTeamInvitePanel:initInviteView(...)
	if self.teamType == teamAreaEnum.NEBULA_ALL_STAR then
		return
	end
	self.fields.Button_refresh:setString(i18n("common_text_911"))
	self.fields.Button_refresh:addClickListener(handler(self, self.onClickBtnRefresh))
	teamAreaEnum = self.fields.Button_refresh.addClickListener
	self.fields.Button_refresh.addClickListener[VIEW_SUB_TYPE.TYPE_MEMBER] = i18n("common_text_3079")
	local self.fields.Button_refresh.addClickListener[VIEW_SUB_TYPE.TYPE_FRIEND], config = i18n("friend_name_01"), self.fields.Button_refresh.addClickListener
	teamAreaEnum = handler(self, self.onClickBtnRefresh)
	handler(self, self.onClickBtnRefresh).items = config
	handler(self, self.onClickBtnRefresh).changedCallback = handler(self, self.onComboBoxChanged)
	handler(self, self.onClickBtnRefresh).selectedIndex = self.showViewSubType - 1
	self:setComboBox(self.fields.ComboBox_invite, handler(self, self.onClickBtnRefresh))
	local dropdown = self.fields.ComboBox_invite:getDropdown()
	self.comboBoxList = dropdown:getChildByName("list")
	self.fields.ComboBox_invite:addClickListener(function()
		self.comboBoxList:setSelectedIndex(self.showViewSubType - 1)
	end)
	self.fields.ComboBox_invite:fixPos()
	self.fields.ComboBox_invite:fixChildrenPos()
	self.fields.Button_refresh:fixPos()
end
function NebulaWarTeamInvitePanel:onClickBtnRefresh(...)
	SoraDPlaySound()
	self:req4Data()
end
function NebulaWarTeamInvitePanel:onComboBoxChanged()
	local index = self.fields.ComboBox_invite:getSelectedIndex()
	self.showViewSubType = index + 1
	self:req4Data()
end
function NebulaWarTeamInvitePanel:initSearchView(...)
	self.fields.Button_search:setString(i18n("common_text_166"))
	self.fields.Button_search:addClickListener(handler(self, self.onClickBtnSearch))
	self.Text_input = self.fields.Label_input:getChild("input")
	self.Text_input:setMaxLength(MAX_NICKNAME_LEN)
	if self.teamType == teamAreaEnum.NEBULA_EMPEROR or self.teamType == teamAreaEnum.NEBULA_ALL_STAR then
		self.Text_input2 = self.fields.Label_input2:getChild("input")
		self.Text_input2:setMaxLength(MAX_NICKNAME_LEN)
		local selfKid = gametop.playertop_:getKingdomID()
		self.Text_input2:setText(tostring(selfKid))
		self.fields.Text_kid:setString(i18n("common_text_4446"))
		self.fields.Text_name:setString(i18n("common_text_264"))
		_UPVALUE5_ = self.fields.Text_name
		self.fields.Text_name[1] = self.fields.Image_name
		self.fields.Text_name[2] = self.fields.Text_name
		self.fields.Text_name[3] = self.fields.Label_input2
		self.fields.Text_name[4] = self.fields.Image_kid
		self.fields.Text_name[5] = self.fields.Text_kid
		for __, v in ipairs(self.fields.Text_name) do
			v:fixPos()
		end
	else
		self.kidList = nebulaWarUtil.getSameCampKidList()
		self.showViewKidIndex = table.indexof(self.kidList, self.showViewKid)
		_ENV = ipairs(self.fields.Text_name)
		ipairs(self.fields.Text_name).items = self.kidList
		ipairs(self.fields.Text_name).values = self.kidList
		ipairs(self.fields.Text_name).selectedValue = self.showViewKid
		ipairs(self.fields.Text_name).changedCallback = handler(self, self.onKidComboBoxChanged)
		self:setComboBox(self.fields.ComboBox_kid, ipairs(self.fields.Text_name))
		local dropdown = self.fields.ComboBox_kid:getDropdown()
		self.comboBoxKidList = dropdown:getChildByName("list")
		self.fields.ComboBox_kid:addClickListener(function()
			self.comboBoxKidList:setSelectedIndex(self.showViewKidIndex - 1)
		end)
		self.fields.ComboBox_kid:fixPos()
		self.fields.ComboBox_kid:fixChildrenPos()
	end
	self.fields.Label_input:fixPos()
	self.fields.Button_search:fixPos()
end
function NebulaWarTeamInvitePanel:onClickBtnSearch(...)
	SoraDPlaySound()
	local name = self.Text_input:getText()
	if string.utf8len(name) < 3 then
		SoraDShowMsgTip(i18n("common_text_365"))
		return
	end
	local teamDef = include("teamDef")
	if not teamDef.namkVailidCheck(name) then
		SoraDShowMsgTip(i18n("notice_0071"))
		return
	end
	local kid
	if self.teamType == teamAreaEnum.NEBULA_EMPEROR or self.teamType == teamAreaEnum.NEBULA_ALL_STAR then
		local kidStr = self.Text_input2:getText()
		if string.len(kidStr) > 0 then
			kid = tonumber(kidStr)
			local kingdomCtrl = SoraDGetCtrl("kingdomCtrl")
			if not kid or kid <= 0 or not kingdomCtrl:isFoundKingdomID(kid) then
				kid = gametop.playertop_:getKingdomID()
			end
		end
	else
		kid = tonumber(self.fields.ComboBox_kid:getValue()) or gametop.playertop_:getKingdomID()
	end
	local myTeamInfo = self:getMyTeamInfo()
	myTeamInfo:reqTeamSearchUser(kid, name)
	SoraDShowLoading(self:displayObject())
end
function NebulaWarTeamInvitePanel:onKidComboBoxChanged(...)
	local index = self.fields.ComboBox_kid:getSelectedIndex()
	self.showViewKidIndex = index + 1
end
function NebulaWarTeamInvitePanel:onClickTab(tag)
	if self.showViewType == tag then
		return
	end
	self.showViewType = tag
	self.controllers.c_viewType:setSelectedIndex(self.showViewType - 1)
	self:req4Data()
end
function NebulaWarTeamInvitePanel:req4Data()
	local myTeamInfo = self:getMyTeamInfo()
	if self.showViewType == VIEW_TYPE.TYPE_INVITE then
		if self.showViewSubType == VIEW_SUB_TYPE.TYPE_MEMBER then
			myTeamInfo:reqTeamSearchAlliance(true)
			SoraDShowLoading(self:displayObject())
		elseif self.showViewSubType == VIEW_SUB_TYPE.TYPE_FRIEND then
			myTeamInfo:reqTeamSearchFriend(true)
			SoraDShowLoading(self:displayObject())
		end
	elseif self.showViewType == VIEW_TYPE.TYPE_SEARCH then
		local kid = gametop.playertop_:getKingdomID()
		myTeamInfo:reqTeamSearchUser(kid)
		SoraDShowLoading(self:displayObject())
	end
end
function NebulaWarTeamInvitePanel:refreshMemberList(memberList)
