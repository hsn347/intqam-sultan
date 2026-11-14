local publicRead = include("publicRead")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local kingdomCtrl = SoraDGetCtrl("kingdomCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ItemSendViewPanel = class("ItemSendViewPanel", baseFguiPanel)
function ItemSendViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ItemSendViewPanel:ctor", self.viewName)
end
function ItemSendViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function ItemSendViewPanel:onInit()
	print("=======ItemSendViewPanel:onInit")
	self.curIndex = 0
	self.fields.Com_title:initData(i18n(publicRead.getName(self.param.itemID)), handler(self, self.onClickClose))
	self.fields.Text_tip:setString(i18n("friend_text_12"))
	self.fields.Btn_search:setString(i18n("common_text_166"))
	self.fields.Btn_search:addClickListener(handler(self, self.onSearchClick))
	self.fields.Input:setPrompt(i18n("lordequip_text_05"))
	self.fields.Input:addEventListener(fgui.UIEventType.Changed, handler(self, self.onChanged))
	self.fields.Input:addEventListener(fgui.UIEventType.Submit, handler(self, self.onSubmit))
	self.textField = self.fields.Input
	self.textField:setPlaceholderFontColor(cc.c3b(88, 85, 84))
	publicRead = self.textField.setPlaceholderFontColor
	self.config, self.textField.setPlaceholderFontColor[1] = self.textField.setPlaceholderFontColor, i18n("common_text_3155")
	self.config, self.textField.setPlaceholderFontColor[2] = self.textField.setPlaceholderFontColor, i18n("UID")
	self.config, self.textField.setPlaceholderFontColor[3] = self.textField.setPlaceholderFontColor, i18n("UID")
	self.config, self.textField.setPlaceholderFontColor[4] = self.textField.setPlaceholderFontColor, i18n("UID")
	self.config, self.textField.setPlaceholderFontColor[5] = self.textField.setPlaceholderFontColor, i18n("UID")
	self.config, self.textField.setPlaceholderFontColor[6] = self.textField.setPlaceholderFontColor, i18n("UID")
	_ENV = i18n("UID")
	i18n("UID").items = self.config
	i18n("UID").changedCallback = handler(self, self.onComboBoxChanged)
	i18n("UID").selectedIndex = self.curIndex
	self:setComboBox(self.fields.Com_box, i18n("UID"))
	local dropdownMin = self.fields.Com_box:getDropdown()
	self.comboBoxList = dropdownMin:getChildByName("list")
	self.fields.Com_box:addClickListener(function()
		self.comboBoxList:setSelectedIndex(self.curIndex)
	end)
	self.fields.Com_box:setString(self.config[self.curIndex + 1])
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Btn_record:setString(i18n("common_text_4694"))
	self.fields.Btn_record:addClickListener(handler(self, self.onRecordClick))
	self.fields.Com_box:fixPos()
	self.fields.Btn_search:fixPos()
	self.fields.n3:fixPos()
	self.fields.Input:fixPos()
end
function ItemSendViewPanel:onItemRenderer(index, obj)
	obj:initData(self.searchList[index + 1], self.param.itemID)
end
function ItemSendViewPanel:onShow()
	print("=======ItemSendViewPanel:onShow")
end
function ItemSendViewPanel:onChanged(Context)
	print("onChanged=====", self.fields.Input:getText())
end
function ItemSendViewPanel:onSubmit(Context)
	print("onSubmit=====", self.fields.Input:getText())
end
function ItemSendViewPanel:onComboBoxChanged()
	self.curIndex = self.fields.Com_box:getSelectedIndex()
	print("self.curIndex====", self.curIndex)
	self.fields.Input:setPrompt(self.curIndex == 0 and i18n("lordequip_text_05") or i18n("common_text_4804"))
	self.fields.Com_box:setString(self.config[self.curIndex + 1])
end
function ItemSendViewPanel:updateSearchList(target, data)
	SoraDCloseLoading(self)
	dump(data, "updateSearchList data=====", 10)
	if not data.data.uinfolist then
		local _ENV, uinfolist = data.data.uinfolist, data.data.uinfolist
	end
	self.searchList, _ENV = data, data
	for k, v in ipairs(uinfolist) do
		if v.uid ~= gModuleMgr.getObject("gametop").playertop_:getPlayerID() then
			table.insert(self.searchList, v)
		end
	end
	self.fields.List:setNumItems(#self.searchList)
	self.fields.Text_tip:setVisible(#self.searchList == 0)
end
function ItemSendViewPanel:onSearchClick()
	SoraDPlaySound()
	local kid = lordInfoCtrl:getMapSourceKid()
	local name = self.fields.Input:getText()
	local pid = self.fields.Input:getText()
	if name == "" then
		SoraDShowMsgTip(i18n("friend_text_20"))
		return
	end
	if self.curIndex == 0 and string.utf8len(name) < 3 then
		SoraDShowMsgTip(i18n("friend_text_12"))
		return
	end
	if self.curIndex == 0 then
		pid = nil
	else
		name = nil
	end
	SoraDShowLoading(self)
	lordInfoCtrl:searchLordInThisKingdomReq(name, 1, kid, pid, lordSearchType.PIGEON)
end
function ItemSendViewPanel:onRecordClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).itemID = self.param.itemID
	uiManager:show("ItemSendRecord", nil)
end
return ItemSendViewPanel
