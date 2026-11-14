local teamDef = include("teamDef")
local teamAreaEnum = teamDef.teamAreaEnum
local baseComponent = require("fgui.base.baseComponent")
local Com_searchMember = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonUI/Com_searchMember", Com_searchMember)
function Com_searchMember:onInit()
	self.fields.Button_search:setString(i18n("common_text_166"))
	self.fields.Button_search:addClickListener(handler(self, self.onClickBtnSearch))
	local inputFields = fguiHelper.get_fields(self.fields.Label_input)
	self.Button_all = inputFields.Button_all
	self.Button_all:addClickListener(handler(self, self.onClickBtnAll))
	self.Button_all:setVisible(false)
	self.Text_input = inputFields.input
	self.Text_input:setMaxLength(ALLIANCE_NAME_MAX)
	self.Text_input:setPromptHolder(i18n("nebula_war_text_0372"))
	self.Text_input:addEventListener(fgui.UIEventType.Changed, handler(self, self.onInputChanged))
	if not SoraDFIsRA() then
		self.fields.Label_input:fixPos()
		self.fields.Label_input:fixChildrenPos()
		self.fields.Button_search:fixPos()
	end
end
function Com_searchMember:onShow()
	self.memberList, _UPVALUE0_ = nil, nil
end
function Com_searchMember:onClickBtnSearch(...)
	SoraDPlaySound()
	local searchName = self.Text_input:getText()
	if string.utf8len(searchName) <= 0 then
		if self.teamType == teamAreaEnum.NEBULA_ALL_STAR then
			SoraDShowMsgTip(i18n("NebulaAllstar_59"))
		end
		return
	end
	self.searchName = searchName
	local searchData = self:getSearchData()
	if 0 < #searchData then
		self.tableMemberList = searchData
	else
		if self.teamType == teamAreaEnum.NEBULA_ALL_STAR then
			SoraDShowMsgTip(i18n("NebulaAllstar_60"))
		else
			SoraDShowMsgTip(i18n("common_text_963"))
		end
		self.searchName = nil
		self.Text_input:setString("")
		self.Button_all:setVisible(false)
		self.tableMemberList = self.memberList
	end
	if self.searchHandler then
		self.searchHandler(self.tableMemberList)
	end
end
function Com_searchMember:onClickBtnAll(...)
	SoraDPlaySound()
	self.Text_input:setString("")
	self:onInputChanged()
end
function Com_searchMember:onInputChanged(...)
	local searchName = self.Text_input:getText()
	if string.utf8len(searchName) <= 0 then
		self:resetTableMemberList()
		self.Button_all:setVisible(false)
	else
		self.Button_all:setVisible(true)
	end
end
function Com_searchMember:resetTableMemberList(...)
	if self.searchName then
		self.searchName = nil
		self.tableMemberList = self.memberList
		if self.searchHandler then
			self.searchHandler(self.tableMemberList)
		end
	end
end
function Com_searchMember:getSearchData(...)
	if not self.searchName then
		return self.memberList
	end
	local _ENV, searchData = self.memberList, self.memberList
	for i, member in ipairs(self.memberList) do
		if string.find(string.lower(member.nickName), string.lower(self.searchName), 1, true) then
			table.insert(searchData, member)
		end
	end
	return searchData
end
function Com_searchMember:setSearchHandler(handler)
	self.searchHandler = handler
end
function Com_searchMember:setMemberList(memberList)
	self.memberList = memberList
end
function Com_searchMember:getTableMemberList(...)
	local searchData = self:getSearchData()
	if 0 < #searchData then
		self.tableMemberList = searchData
	else
		self.searchName = nil
		self.Text_input:setString("")
		self.Button_all:setVisible(false)
		self.tableMemberList = self.memberList
	end
	return self.tableMemberList
end
function Com_searchMember:setTeamType(teamType)
	self.teamType = teamType
end
return Com_searchMember
