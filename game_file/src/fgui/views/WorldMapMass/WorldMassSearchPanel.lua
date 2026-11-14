local baseFguiPanel = require("fgui.base.baseFguiPanel")
local massSettingWhiteListCtrl = SoraDGetCtrl("massSettingWhiteListCtrl")
local WorldMassSearchPanel = class("WorldMassSearchPanel", baseFguiPanel)
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
_ENV = "lordInfoCtrl"
;("lordInfoCtrl").name = 1
local ("lordInfoCtrl").uid, SEARCH_TYPE = 2, "lordInfoCtrl"
function WorldMassSearchPanel:ctor(...)
	self.isLRU = true
	WorldMassSearchPanel.super.ctor(self, ...)
	print("WorldMassSearchPanel:ctor", self.viewName)
end
function WorldMassSearchPanel:onInit()
	print("=======WorldMassSearchPanel:onInit")
	self.searchLis, _ENV, self.searchType = SEARCH_TYPE.name, SEARCH_TYPE.name, SEARCH_TYPE.name
	self.fields.Panel_bg:setString(i18n("common_text_4892"))
	self.fields.Button_search:setString(i18n("common_text_166"))
	self.fields.Button_search:addClickListener(handler(self, self.onClickBtnSearch))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self:initComboBoxSearch()
	if not SoraDFIsRA() then
		self.fields.ComboBox:fixPos()
		self.fields.input:fixPos()
		self.fields.Button_search:fixPos()
	end
end
function WorldMassSearchPanel:endShow()
	print("=======WorldMassSearchPanel:endShow")
	self.lastSendUid = nil
	self.fields.input:clearInput()
	self.searchList, _ENV = self.fields.input.clearInput, self.fields.input.clearInput
	self:updateSearchList()
end
function WorldMassSearchPanel:initComboBoxSearch(...)
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
function WorldMassSearchPanel:onComboBoxChanged()
	local index = self.fields.ComboBox:getSelectedIndex()
	self.searchType = index + 1
end
function WorldMassSearchPanel:onClickBtnSearch()
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
	massSettingWhiteListCtrl:sendReqSearch(name, pid)
	self.lastSendUid = nil
end
function WorldMassSearchPanel:onItemRenderer(index, obj)
	local data = self.searchList[index + 1]
	obj:initData(data)
end
function WorldMassSearchPanel:updateSearchList()
	self.fields.List:setNumItems(#self.searchList)
	self.fields.Text_noData:setString(i18n("friend_text_12"))
	self.fields.Text_noData:setVisible(#self.searchList <= 0)
end
function WorldMassSearchPanel:onMsgSearchBack(list)
	local uinfolist = list
	self.searchList = lordInfoCtrl:filterSearchList(uinfolist)
	self:updateSearchList()
	if #self.searchList <= 0 then
		SoraDShowMsgTip(i18n("common_text_4893"))
	end
end
return WorldMassSearchPanel
