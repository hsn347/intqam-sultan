local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001629_ChoosePanel = class("Activity_9001629_ChoosePanel", baseFguiPanel)
local contactCtrl = SoraDGetCtrl("contactCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local gametop = gModuleMgr.getObject("gametop")
local allianceQuery = gametop.playertop_:getModule("allianceQuery")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local activity_9001629_Ctrl = SoraDGetCtrl("activity_9001629_Ctrl")
local chatFunctions = include("chatFunctions")
function Activity_9001629_ChoosePanel:ctor(...)
	Activity_9001629_ChoosePanel.super.ctor(self, ...)
	self.debug = true
	print("Activity_9001629_ChoosePanel:ctor", self.viewName)
end
function Activity_9001629_ChoosePanel:onInit()
	print("=======Activity_9001629_ChoosePanel:onInit")
	self.fields.Com_title:initData(i18n("nebula_stars_wishing_text16"), handler(self, self.onClickClose))
	self.fields.Text_notice:setString(i18n("nebula_stars_wishing_text18"))
	self.tabIndex = 0
	_ENV = i18n("nebula_stars_wishing_text18")
	_ENV, _ENV, i18n("nebula_stars_wishing_text18").defaultClick = i18n("nebula_stars_wishing_text18")
	i18n("nebula_stars_wishing_text18").title = i18n("common_text_180")
	_ENV, self.tabIndex[1], i18n("nebula_stars_wishing_text18").tag = i18n("nebula_stars_wishing_text18")
	i18n("nebula_stars_wishing_text18").title = i18n("friend_name_01")
	i18n("nebula_stars_wishing_text18").tabsetArray, self.tabIndex[2], i18n("nebula_stars_wishing_text18").tag = self.tabIndex, i18n("nebula_stars_wishing_text18")
	i18n("nebula_stars_wishing_text18").callback = handler(self, self.onClickTab)
	self.fields.Com_tab:initView(i18n("nebula_stars_wishing_text18"))
	self.fields.List_player:setVirtual()
	self.fields.List_player:setItemRenderer(handler(self, self.onItemRenderer))
	self.Text_input = self.fields.TextField_search
	self.Text_input:setMaxLength(MAX_NICKNAME_LEN)
	self.fields.Button_search:setString(i18n("common_text_166"))
	self.fields.Button_search:addClickListener(handler(self, self.onClickBtnSearch))
	self.friendList, _ENV, self.allianceMemberList, _ENV = self.fields.Button_search.addClickListener, self.fields.Button_search.addClickListener, self.fields.Button_search.addClickListener, self.fields.Button_search.addClickListener
	if not self.param or not self.param.texts then
		_ENV = self.param.texts
	end
	self.texts = self.param.texts
	self.selectedUid = nil
	self:updateBtnStatus()
	self.Text_input:fixPos()
	self.fields.textbg:fixPos()
	self.fields.Button_search:fixPos()
end
function Activity_9001629_ChoosePanel:onShow()
	print("=======Activity_9001629_ChoosePanel:onShow")
	self:req4Data()
end
function Activity_9001629_ChoosePanel:req4Data()
	contactCtrl:reqGetData(true, false, false)
	local aid = allianceMgr.ownaid
	if aid == nil or aid == 0 then
		self:updateView()
		return
	end
	SoraDShowLoading(self)
	allianceQuery:reqMemberList(aid)
	self.aid = aid
end
function Activity_9001629_ChoosePanel:onItemRenderer(index, obj)
	local memberData = self.memberList[index + 1]
	obj:initData(memberData, self.selectedUid)
	obj:setClickHandler(handler(self, self.onBlessClick))
end
function Activity_9001629_ChoosePanel:updateBtnStatus()
	dump(self.selectedUid, "self.selectedUid")
end
function Activity_9001629_ChoosePanel:refreshMemberList()
	SoraDCloseLoading(self)
	if self.aid == nil then
		_ENV = self.aid
		if self.aid then
			goto lbl_14
		end
	end
	::lbl_14::
	self.allianceMemberList = allianceMgr:getMemberList(self.aid)
	if self.tabIndex == 0 then
		self:updateView()
	end
end
function Activity_9001629_ChoosePanel:refreshFriendList()
	SoraDCloseLoading(self)
	self.friendList = contactCtrl:getContactList()
	if self.tabIndex == 1 then
		self:updateView()
	end
end
function Activity_9001629_ChoosePanel:updateView()
	self.memberList, _ENV = nil, nil
	if self.tabIndex == 1 then
		dump(self.friendList, "self.friendList")
		for k, v in pairs(self.friendList) do
			if self.searchName == nil or string.find(v.name, self.searchName) then
				_ENV = self.searchName
				self.searchName.nickName = v.remarkName or v.name or v.name
				self.searchName.allianceAbb = v.allianceAbbr or v.abbr
				self.searchName.fromKid = v.kid or v.sourceKid
				local nameStr = lordInfoCtrl:getSplitName(self.searchName)
				_ENV = v.kid or v.sourceKid
				;(v.kid or v.sourceKid).uid = tonumber(k)
				;(v.kid or v.sourceKid).name = nameStr
				;(v.kid or v.sourceKid).online = v.online
				;(v.kid or v.sourceKid).headid = v.headid or v.iconID
				;(v.kid or v.sourceKid).avatar = v.avatar
				;(v.kid or v.sourceKid).totalFc = v.totalFc
				;(v.kid or v.sourceKid).order = v.online > 0 and 1 or 0
				table.insert(self.memberList, v.kid or v.sourceKid)
			end
		end
	else
		for _, v in pairs(self.allianceMemberList) do
			for i, v2 in ipairs(v) do
				local data = v2.uinfo
				local uid = v2.minfo.uid
				dump(v2, "Activity_9001629_ChoosePanel:updateView")
				if data ~= nil and not chatFunctions.getIsPlayerSelf(uid) and (self.searchName == nil or string.find(data.nickName, self.searchName)) then
					_ENV = self.searchName
					self.searchName.nickName = data.remarkName or data.nickName or data.name
					self.searchName.allianceAbb = data.allianceAbbr or data.abbr
					local nameStr = lordInfoCtrl:getSplitName(self.searchName)
					_ENV = data.allianceAbbr or data.abbr
					;(data.allianceAbbr or data.abbr).uid = uid
					;(data.allianceAbbr or data.abbr).name = nameStr
					;(data.allianceAbbr or data.abbr).online = data.online
					;(data.allianceAbbr or data.abbr).headid = data.headid or data.iconID
					;(data.allianceAbbr or data.abbr).avatar = data.avatar
					;(data.allianceAbbr or data.abbr).totalFc = data.totalFc
					;(data.allianceAbbr or data.abbr).order = data.online > 0 and 1 or 0
					table.insert(self.memberList, data.allianceAbbr or data.abbr)
				end
			end
		end
	end
	table.sort(self.memberList, function(a, b)
		if a.order == b.order then
			return a.totalFc > b.totalFc
		else
			return a.order < b.order
		end
	end)
	self.controllers.c1:setSelectedIndex(#self.memberList > 0 and 1 or 0)
	self.fields.List_player:setNumItems(#self.memberList)
end
function Activity_9001629_ChoosePanel:onClickTab(index)
	print("index====", index)
	if self.tabIndex == index then
		return
	end
	self.tabIndex = index
	self:updateView()
end
function Activity_9001629_ChoosePanel:onBlessClick(uid)
	SoraDPlaySound()
	self.selectedUid = uid
	if self.selectedUid ~= nil and next(self.texts) ~= nil then
		activity_9001629_Ctrl:reqWish(self.selectedUid, self.texts)
	end
	self:close()
end
function Activity_9001629_ChoosePanel:onClickBtnSearch(...)
	SoraDPlaySound()
	local name = self.Text_input:getText()
	local teamDef = include("teamDef")
	if teamDef.namkVailidCheck(name) or name == "" then
		self.searchName = name
		self:updateView()
	else
		self.searchName = nil
		SoraDShowMsgTip(i18n("notice_0071"))
		self:updateView()
	end
end
return Activity_9001629_ChoosePanel
