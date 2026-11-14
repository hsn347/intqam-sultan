local conquestWarReinforcementsCtrl = SoraDGetCtrl("conquestWarReinforcementsCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local kingdomBattleSearchPanel = class("kingdomBattleSearchPanel", baseFguiPanel)
function kingdomBattleSearchPanel:ctor(...)
	self.super.ctor(self, ...)
	print("kingdomBattleSearchPanel:ctor", self.viewName)
end
function kingdomBattleSearchPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function kingdomBattleSearchPanel:onInit()
	print("=======kingdomBattleSearchPanel:onInit")
	self.fields.Panel_bg:setString(i18n("across_invitation_title"))
	self.searchType = 1
	self.fields.Button_Search:setString(i18n("common_text_166"))
	self.fields.Button_Search:addClickListener(handler(self, self.onClickSearch))
	_UPVALUE1_, _ENV = handler(self, self.onClickSearch)
	_UPVALUE2_, handler(self, self.onClickSearch).items, handler(self, self.onClickSearch)[1] = handler(self, self.onClickSearch)
	_UPVALUE2_, handler(self, self.onClickSearch).items, handler(self, self.onClickSearch)[2] = handler(self, self.onClickSearch)
	_UPVALUE2_, handler(self, self.onClickSearch).items, handler(self, self.onClickSearch)[3] = handler(self, self.onClickSearch)
	handler(self, self.onClickSearch).values, handler(self, self.onClickSearch)[1] = handler(self, self.onClickSearch)
	handler(self, self.onClickSearch).values, handler(self, self.onClickSearch)[2] = handler(self, self.onClickSearch)
	handler(self, self.onClickSearch).selectedValue = self.searchType
	handler(self, self.onClickSearch).changedCallback = handler(self, self.onComboBoxChanged)
	self:setComboBox(self.fields.ComboBox, handler(self, self.onClickSearch))
	self.fields.List:getScrollPane():getFooter():setString("")
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
function kingdomBattleSearchPanel:onShow()
	print("=======kingdomBattleSearchPanel:onShow")
	conquestWarReinforcementsCtrl:reqConquestWarTop10hUser()
end
function kingdomBattleSearchPanel:updateList(data)
	dump(data, "data")
	self.userList = data
	if next(self.userList) then
		self.fields.List:setNumItems(#self.userList)
		self.fields.List:setVisible(true)
		self.fields.Text_NoMore:setVisible(false)
	else
		self.fields.List:setVisible(false)
		self.fields.Text_NoMore:setVisible(true)
		self.fields.Text_NoMore:setString(i18n("common_text_927"))
	end
end
function kingdomBattleSearchPanel:onItemRederer(index, target)
	target:initData(self.userList[index + 1])
end
function kingdomBattleSearchPanel:onComboBoxChanged(value)
	print("onComboBoxChanged", self.fields.ComboBox:getValue())
	SoraDPlaySound()
	self.searchType = self.fields.ComboBox:getValue()
end
function kingdomBattleSearchPanel:onClickSearch()
	SoraDPlaySound()
	local str = self.fields.input:getText()
	local key = string.match(str, "%s*(.-)%s*$")
	local keyLen = string.utf8len(key)
	print("self.searchType", self.searchType)
	if tonumber(self.searchType) == 1 then
		SoraDGetCtrl("lordInfoCtrl"):searchLordInThisKingdomsReq(nil, nil, tonumber(key))
	elseif keyLen >= SEARCH_MIN_LEN then
		local name = self.fields.input:getText()
		_ENV = nil
		;(nil).name = key
		conquestWarReinforcementsCtrl:reqConquestWarSerrchUser(nil)
	else
		SoraDShowMsgBox(i18n("common_text_961"), i18n("common_text_054"), nil, function()
		end)
	end
end
return kingdomBattleSearchPanel
