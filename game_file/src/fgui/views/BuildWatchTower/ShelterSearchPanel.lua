local gametop = gModuleMgr.getObject("gametop")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ShelterSearchPanel = class("ShelterSearchPanel", baseFguiPanel)
function ShelterSearchPanel:ctor(...)
	self.isLRU = true
	ShelterSearchPanel.super.ctor(self, ...)
	print("ShelterSearchPanel:ctor", self.viewName)
end
function ShelterSearchPanel:onInit()
	print("=======ShelterSearchPanel:onInit")
	self.fields.Panel_bg:setString(i18n("war_shelter_026"))
	self.input = self.fields.input:getChild("input")
	self.fields.Button_search:setString(i18n("common_text_166"))
	self.fields.Button_search:addClickListener(handler(self, self.btnSearchClick))
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.view:fixChildrenPos()
end
function ShelterSearchPanel:onItemRenderer(index, obj)
	obj:initData(self.searchList[index + 1])
end
function ShelterSearchPanel:btnSearchClick()
	SoraDPlaySound()
	local name = self.input:getText()
	local pid = self.input:getText()
	if name == "" and self.comboBoxType == 1 then
		SoraDShowMsgTip(i18n("friend_text_20"))
		return
	end
	if string.utf8len(name) < 3 then
		SoraDShowMsgTip(i18n("friend_text_12"))
		return
	end
	if self.comboBoxType == 1 then
		pid = nil
	else
		name = nil
	end
	lordInfoCtrl:searchLordInThisKingdomsReq(name, nil, pid)
	SoraDShowLoading(self)
end
function ShelterSearchPanel:updateSearchList(target, data)
	SoraDCloseLoading(self)
	self.searchList, _ENV = SoraDCloseLoading, SoraDCloseLoading
	if not data.data or not data.data.uinfolist then
		local _ENV, uinfolist = data.data.uinfolist, data.data.uinfolist
	end
	for k, v in ipairs(uinfolist) do
		if v.uid ~= SoraDGetPlayerID() then
			table.insert(self.searchList, v)
		end
	end
	self.fields.List:setNumItems(#self.searchList)
	self.fields.Text_none:setVisible(#self.searchList == 0)
end
function ShelterSearchPanel:endShow()
	print("=======ShelterSearchPanel:endShow")
	self.input:setText("")
	self.fields.Text_none:setString(i18n("friend_text_12"))
	_UPVALUE1_, self.comboBoxType = self.fields.Text_none.setString, 1
	_UPVALUE2_, self.fields.Text_none.setString[1] = i18n("common_text_3155"), i18n("common_text_3155")
	_UPVALUE2_, self.fields.Text_none.setString[2] = i18n("common_text_3155"), i18n("UID")
	_UPVALUE2_, self.fields.Text_none.setString[3] = i18n("common_text_3155"), i18n("UID")
	_UPVALUE2_, self.fields.Text_none.setString[4] = i18n("common_text_3155"), i18n("UID")
	_UPVALUE2_, self.fields.Text_none.setString[5] = i18n("common_text_3155"), i18n("UID")
	_UPVALUE2_, self.fields.Text_none.setString[6] = i18n("common_text_3155"), i18n("UID")
	_UPVALUE2_, self.fields.Text_none.setString[7] = i18n("common_text_3155"), i18n("UID")
	local _UPVALUE2_, self.fields.Text_none.setString[8], items = i18n("common_text_3155"), i18n("UID")
	i18n("common_text_3155")[1] = 1
	local i18n("common_text_3155")[2], values = 2, i18n("common_text_3155")
	_ENV = i18n("UID")
	i18n("UID").items = items
	i18n("UID").values = values
	i18n("UID").changedCallback = handler(self, self.onComboBoxClick)
	self:setComboBox(self.fields.ComboBox, i18n("UID"))
	local dropdown = self.fields.ComboBox:getDropdown()
	self.comboBoxList = dropdown:getChildByName("list")
	self.fields.ComboBox:addClickListener(function()
		SoraDPlaySound()
		self.comboBoxList:setSelectedIndex(self.comboBoxType - 1)
	end)
	self.fields.ComboBox:fixChildrenPos()
end
function ShelterSearchPanel:onComboBoxClick()
	SoraDPlaySound()
	self.comboBoxType = tonumber(self.fields.ComboBox:getValue())
end
return ShelterSearchPanel
