local manorCityCtrl = SoraDGetCtrl("manorCityCtrl")
local manorLayoutCtrl = SoraDGetCtrl("manorLayoutCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ManorLayoutSpacePanel = class("ManorLayoutSpacePanel", baseFguiPanel)
function ManorLayoutSpacePanel:ctor(...)
	self.isLRU = true
	ManorLayoutSpacePanel.super.ctor(self, ...)
	print("ManorLayoutSpacePanel:ctor", self.viewName)
end
function ManorLayoutSpacePanel:onInit()
	print("=======ManorLayoutSpacePanel:onInit")
	self.fields.Com_title:initData(i18n("Socialize_text_11"), handler(self, self.onClickClose))
	self.fields.List:setItemRenderer(handler(self, self.itemRenderer_List))
	self.fields.Text_noData:setString(i18n("Socialize_text_18"))
	self.fields.Button_layout:setString(i18n("Socialize_text_17"))
	self.fields.Button_layout:addClickListener(handler(self, self.onClickBtnLayout))
	self.fields.btnSearch:addClickListener(handler(self, self.onClickBtnSearch))
	self:initInputData()
end
function ManorLayoutSpacePanel:endShow()
	print("=======ManorLayoutSpacePanel:endShow")
	manorLayoutCtrl:reqRandom()
	manorLayoutCtrl:reqInit()
	self.fields.Image_noData:setVisible(false)
	self.fields.Text_noData:setVisible(false)
end
function ManorLayoutSpacePanel:onMsgManorLayoutRandom(target, event)
	dump(event, "ManorLayoutSpacePanel:onMsgManorLayoutRandom", 10)
	if not event.otherLayout then
		local _ENV, otherLayout = event.otherLayout, event.otherLayout
	end
	if not otherLayout.usersInfo then
		_ENV = otherLayout.usersInfo
	end
	self.usersInfo = otherLayout.usersInfo
	if not otherLayout.list then
		local _ENV, layoutList = otherLayout.list, otherLayout.list
	end
	self.layoutList = layoutList
	self.fields.List:setNumItems(#self.layoutList)
	self.fields.Image_noData:setVisible(#self.layoutList == 0)
	self.fields.Text_noData:setVisible(#self.layoutList == 0)
	if #self.layoutList > 0 then
		self.fields.List:scrollToView(0)
	end
	local searchName = event.searchName
	if searchName then
		self:updateSeachHistory(searchName)
	end
end
function ManorLayoutSpacePanel:itemRenderer_List(index, obj)
	local layoutData = self.layoutList[index + 1]
	local uid = layoutData.uid or 0
	if not self.usersInfo[tostring(uid)] then
		local _ENV, player = self.usersInfo[tostring(uid)], self.usersInfo[tostring(uid)]
	end
	obj:initData(layoutData, player)
end
function ManorLayoutSpacePanel:onMsgManorLayoutLike(target, event)
	dump(event, "ManorLayoutSpacePanel:onMsgManorLayoutLike", 10)
	local uid = event.uid or 0
	local iid = event.iid or 0
	for index, layoutData in ipairs(self.layoutList) do
		if layoutData.uid == uid and layoutData.id == iid then
			local _data = manorLayoutCtrl:getOtherLayout(iid)
			self.layoutList[index] = _data
			local obj = self.fields.List:getChildAt(index - 1)
			obj:updateButtonLike(_data)
			break
		end
	end
end
function ManorLayoutSpacePanel:onClickBtnLayout()
	SoraDPlaySound()
	uiManager:show("ManorMyLayout")
end
function ManorLayoutSpacePanel:onClickBtnSearch()
	SoraDPlaySound()
	local inputStr = self.fields.input:getInputText()
	print("==ManorLayoutSpacePanel:onClickBtnSearch==", inputStr)
	if inputStr == "" then
		manorLayoutCtrl:reqRandom()
	else
		inputStr = self.fields.input:getSearchInput()
		if inputStr then
			manorLayoutCtrl:reqGet(inputStr)
		end
	end
end
function ManorLayoutSpacePanel:initInputData()
	self.fields.input:setPrompt(i18n("Socialize_text_15"))
	_ENV = i18n("Socialize_text_15")
	i18n("Socialize_text_15").byUID = true
	if not SoraDConfigGet("Game:ManorLayout:searchList~table", i18n("Socialize_text_15")) then
		_ENV = SoraDConfigGet("Game:ManorLayout:searchList~table", i18n("Socialize_text_15"))
	end
	self.searchList = SoraDConfigGet("Game:ManorLayout:searchList~table", i18n("Socialize_text_15"))
	_ENV = i18n("Socialize_text_15")
	i18n("Socialize_text_15").items = self.searchList
	i18n("Socialize_text_15").changedCallback = handler(self, self.onComboBoxChanged)
	self:setComboBox(self.fields.ComboBox_history, i18n("Socialize_text_15"))
end
function ManorLayoutSpacePanel:onComboBoxChanged(...)
	local index = self.fields.ComboBox_history:getSelectedIndex()
	local inputStr = self.searchList[index + 1]
	if inputStr then
		self.fields.input:setInputText(inputStr)
		inputStr = self.fields.input:getSearchInput()
		if inputStr then
			manorLayoutCtrl:reqGet(inputStr)
		end
	end
end
function ManorLayoutSpacePanel:updateSeachHistory(searchName)
	local index = table.indexof(self.searchList, searchName)
	if index then
		table.remove(self.searchList, index)
	end
	table.insert(self.searchList, 1, searchName)
	local max = 10
	for i = #self.searchList, max + 1, -1 do
		table.remove(self.searchList, i)
	end
	self.fields.ComboBox_history:setItems(self.searchList)
	self.fields.ComboBox_history:refresh()
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:ManorLayout:searchList~table", self.searchList, nil)
end
return ManorLayoutSpacePanel
