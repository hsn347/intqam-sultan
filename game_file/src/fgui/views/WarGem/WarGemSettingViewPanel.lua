local warGemCtrl = SoraDGetCtrl("warGemCtrl")
local wargemResRead = include("wargemResRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WarGemSettingViewPanel = class("WarGemSettingViewPanel", baseFguiPanel)
_ENV = "WarGemSettingViewPanel"
;("WarGemSettingViewPanel").WarGem = 1
local ("WarGemSettingViewPanel").EquipSet, SETTING_TYPE = 2, "WarGemSettingViewPanel"
WarGemSettingViewPanel.SETTING_TYPE = SETTING_TYPE
function WarGemSettingViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("WarGemSettingViewPanel:ctor", self.viewName)
end
function WarGemSettingViewPanel:onInit()
	print("=======WarGemSettingViewPanel:onInit")
	self.tableCheckBox, _ENV = print, print
	self.selectAll = false
	self.changeState = false
	self.scroll = self.fields.ScrollView_select
	self.scroll:setItemRenderer(handler(self, self.onItemRenderer))
	self.btnSelect = self.fields.Button_select
	self.btnSelect:addClickListener(handler(self, self.btnSettingClick))
	self.btnOk = self.fields.Button_ok
	self.btnOk:addClickListener(handler(self, self.btnOkClick))
	self.btnOk:setTitleText(i18n("common_text_204"))
	if not SoraDFIsRA() then
		self.btnSelect:fixPos()
		self.btnOk:fixPos()
	end
end
function WarGemSettingViewPanel:onShow()
	print("=======WarGemSettingViewPanel:onShow")
	local settingType = self.proxy.param and self.proxy.param.settingType or SETTING_TYPE.WarGem
	local settingCfg = self.proxy.param and self.proxy.param.settingCfg
	self:initSetting(settingType, settingCfg)
	self:initData()
	self:updateSetting()
	self:updateBtn()
end
function WarGemSettingViewPanel:initSetting(settingType, settingCfg)
	self.settingCfg, SETTING_TYPE, self.settingType = nil, nil, settingType
	if settingType == SETTING_TYPE.WarGem then
		local wargemResRead = include("wargemResRead")
		self.settingCfg.filerList = wargemResRead.getGemBgFiler()
		self.settingCfg.titlekey = "gem_title_01"
		function self.settingCfg.filerDataFunc()
			local warGemCtrl = SoraDGetCtrl("warGemCtrl")
			return warGemCtrl:getGemFilerData()
		end
		function self.settingCfg.syncSetting(filerList)
			warGemCtrl:setGemFilerData(filerList)
			warGemCtrl = warGemCtrl
			warGemCtrl.msg = "MESSAGE_UI_WARGEM_FILER_SETTING"
			SoraDSendMessage(warGemCtrl)
		end
	elseif settingType == SETTING_TYPE.EquipSet then
		local equipmentMgr = include("equipmentMgr")
		self.settingCfg.titlekey = "suit_text_08"
		self.settingCfg.filerList = equipmentMgr.getEquipFilerList()
		function self.settingCfg.filerDataFunc()
			return equipmentMgr.getEquipFilerData()
		end
		function self.settingCfg.syncSetting(filerList)
			equipmentMgr.setEquipFilerData(filerList)
			equipmentMgr = filerList
			filerList.msg = "MESSAGE_UI_COMMON_FILER_SETTING_SYNC"
			filerList.settingType = self.settingType
			filerList.filerList = filerList
			SoraDSendMessage(filerList)
		end
	else
		self.settingCfg = settingCfg
	end
end
function WarGemSettingViewPanel:getFilerList(...)
	local _ENV, ret
	for k, v in pairs(self.settingCfg.filerList) do
		_ENV = nil
		;(nil).key = k
		;(nil).value = v
		table.insert(ret, nil)
	end
	table.sort(ret, function(a, b)
		return a.key < b.key
	end)
	return ret
end
function WarGemSettingViewPanel:initData(...)
	self.filerList = self:getFilerList()
	self.scroll:setNumItems(math.ceil(#self.filerList / 2))
end
function WarGemSettingViewPanel:getFilerData()
	return self.settingCfg.filerDataFunc()
end
function WarGemSettingViewPanel:updateSetting()
	local setting = self:getFilerData()
	for i, v in pairs(setting) do
		local checkbox = self.tableCheckBox[i]
		if checkbox then
			checkbox:setSelected(v or false)
		end
	end
	self.fields.Panel_bg:setString(i18n(self.settingCfg.titlekey))
end
function WarGemSettingViewPanel:updateBtn()
	if self.selectAll then
		self.btnSelect:setBtnColorIndex(0)
		self.btnSelect:setTitleText(i18n("gem_btn_02"))
	else
		self.btnSelect:setBtnColorIndex(2)
		self.btnSelect:setTitleText(i18n("common_text_404"))
	end
end
function WarGemSettingViewPanel:setAllCheckBox(bselect)
	for _, v in pairs(self.tableCheckBox) do
		v:setSelected(bselect)
	end
end
function WarGemSettingViewPanel:onCBSelectCallBack(...)
	SoraDPlaySound()
	self.changeState = true
end
function WarGemSettingViewPanel:btnSettingClick(button, type)
	SoraDPlaySound()
	self.changeState = true
	self.selectAll = not self.selectAll
	self:updateBtn()
	self:setAllCheckBox(self.selectAll)
end
function WarGemSettingViewPanel:btnOkClick(button, type)
	SoraDPlaySound()
	self:closePanel()
end
function WarGemSettingViewPanel:syncSetting()
	local _ENV, filerGemType
	for k, v in pairs(self.tableCheckBox) do
		if v:isSelected() then
			filerGemType[k] = v:isSelected()
		end
	end
	if self.settingCfg.syncSetting then
		self.settingCfg.syncSetting(filerGemType)
	end
end
function WarGemSettingViewPanel:onHide(...)
	if self.changeState then
		self:syncSetting()
	end
end
function WarGemSettingViewPanel:onItemRenderer(index, obj)
	if not obj.fields then
		obj.fields = fguiHelper.get_fields(obj)
		if not SoraDFIsRA() then
			obj:fixChildrenPos()
			obj.fields.Com_select1:fixChildrenPos()
			obj.fields.Com_select2:fixChildrenPos()
		end
		for i = 1, 2 do
			local Com_select = obj.fields["Com_select" .. i]
			local checkbox = Com_select:getChild("Check_tick")
			checkbox:addClickListener(handler(self, self.onCBSelectCallBack))
			local data = self.filerList[index * 2 + i]
			local key = data and data.key
			if key then
				self.tableCheckBox[key] = checkbox
			end
		end
	end
	for i = 1, 2 do
		local Com_select = obj.fields["Com_select" .. i]
		local data = self.filerList[index * 2 + i]
		if not data then
			Com_select:setVisible(false)
		else
			Com_select:setVisible(true)
			Com_select:setString(i18n(data.value.name))
		end
	end
end
return WarGemSettingViewPanel
