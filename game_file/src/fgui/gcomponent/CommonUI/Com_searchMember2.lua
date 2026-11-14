local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_searchMember2 = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonUI/Com_searchMember2", Com_searchMember2)
_ENV = fgui.register_extension
fgui.register_extension.name = 1
local fgui.register_extension.uid, SEARCH_TYPE = 2, fgui.register_extension
function Com_searchMember2:onInit()
	self.searchType = SEARCH_TYPE.name
	self.fields.Button_search:setString(i18n("common_text_166"))
	self.fields.Button_search:addClickListener(handler(self, self.onClickBtnSearch))
	self:initComboBoxSearch()
	if not SoraDFIsRA() then
		self.fields.ComboBox:fixPos()
		self.fields.input:fixPos()
		self.fields.Button_search:fixPos()
	end
end
function Com_searchMember2:onShow()
end
function Com_searchMember2:initComboBoxSearch(...)
	_ENV = nil
	;(nil)[1] = i18n("common_text_3155")
	local (nil)[2], config = i18n("UID"), nil
	_ENV = nil
	;(nil).items = config
	;(nil).changedCallback = handler(self, self.onComboBoxChanged)
	;(nil).selectedIndex = self.searchType - 1
	;(nil).showCurSelect = true
	self:setComboBox(self.fields.ComboBox, nil)
end
function Com_searchMember2:onComboBoxChanged()
	local index = self.fields.ComboBox:getSelectedIndex()
	self.searchType = index + 1
end
function Com_searchMember2:onClickBtnSearch()
	SoraDPlaySound()
	local keyname = self.fields.input:getSearchInput()
	if not keyname then
		return
	end
	local name, pid
	if self.searchType == SEARCH_TYPE.uid then
		pid = keyname
	else
		name = keyname
	end
	local kid = gametop.playertop_:getMapID()
	lordInfoCtrl:searchLordInThisKingdomReq(name, 1, kid, pid, lordSearchType.PIGEON)
end
function Com_searchMember2:setSearchHandler(handler)
	self.searchHandler = handler
end
function Com_searchMember2:setMemberList(memberList)
	self.memberList = memberList
end
return Com_searchMember2
