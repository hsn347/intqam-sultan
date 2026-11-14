local allianceQuery = SoraDGetCtrl("allianceQuery")
local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
local allianceDesRead = include("allianceDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceOptionsViewPanel = class("allianceOptionsViewPanel", baseFguiPanel)
function allianceOptionsViewPanel:ctor(...)
	allianceOptionsViewPanel.super.ctor(self, ...)
	print("allianceOptionsViewPanel:ctor", self.viewName)
end
function allianceOptionsViewPanel:onInit()
	print("=======allianceOptionsViewPanel:onInit")
	self.tableLanguageList, _ENV = print, print
	self.tempTable, _ENV, self.ownLanguage = gLanguage.ALL, gLanguage.ALL, gLanguage.ALL
	self.isFullMember = false
	self.listArray, _ENV, self.isAllianceClaim = gLanguage.ALL, gLanguage.ALL, true
	self.fields.Com_title:initData(i18n("common_text_718"), handler(self, self.onClickClose))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Button_yes:setString(i18n("common_text_204"))
	self.fields.Button_yes:addClickListener(handler(self, self.btnYesClick))
	self.fields.Button_no:setString(i18n("common_text_4152"))
	self.fields.Button_no:addClickListener(handler(self, self.btnNoClick))
end
function allianceOptionsViewPanel:onItemRenderer(index, obj)
	obj:initData(self.listArray[index + 1], index + 1)
end
function allianceOptionsViewPanel:onShow()
	print("=======allianceOptionsViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self:initData()
end
function allianceOptionsViewPanel:initData()
	self.tableLanguageList = permissionCtrl:getLanguageMenu()
	self.tempTable[self.ownLanguage] = true
	local permissionCtrl, langList = self.tempTable, self.tempTable
	for k, v in ipairs(self.tableLanguageList) do
		permissionCtrl = nil
		;(nil).val = v
		;(nil).title = allianceDesRead.getLanguageName(v)
		;(nil).isSel = self.ownLanguage == v
		table.insert(langList, nil)
	end
	permissionCtrl = ipairs(self.tableLanguageList)
	ipairs(self.tableLanguageList).title = i18n("common_text_715")
	permissionCtrl, permissionCtrl, self.listArray[1], ipairs(self.tableLanguageList).list = ipairs(self.tableLanguageList)
	ipairs(self.tableLanguageList).val = false
	ipairs(self.tableLanguageList).title = i18n("common_text_4118")
	permissionCtrl, self.listArray[1], ipairs(self.tableLanguageList).isSel = ipairs(self.tableLanguageList)
	ipairs(self.tableLanguageList).val = true
	ipairs(self.tableLanguageList).title = i18n("common_text_4117")
	self.listArray[2], ipairs(self.tableLanguageList).isSel = ipairs(self.tableLanguageList)
	local isFullList = self.listArray
	permissionCtrl = self.isFullMember ~= false
	;(self.isFullMember ~= false).title = i18n("common_text_4115")
	permissionCtrl, permissionCtrl, self.listArray[2], (self.isFullMember ~= false).list = self.isFullMember ~= false, self.listArray, self.isFullMember ~= false, isFullList
	;(self.isFullMember ~= false).val = true
	;(self.isFullMember ~= false).title = i18n("common_text_4119")
	permissionCtrl, self.listArray[1], (self.isFullMember ~= false).isSel = self.isFullMember ~= false, self.isFullMember ~= false, self.isAllianceClaim
	;(self.isFullMember ~= false).val = false
	;(self.isFullMember ~= false).title = i18n("common_text_4120")
	self.listArray[2], (self.isFullMember ~= false).isSel = self.isFullMember ~= false, not self.isAllianceClaim
	local isReachList = self.listArray
	permissionCtrl = not self.isAllianceClaim
	;(not self.isAllianceClaim).title = i18n("common_text_4116")
	self.listArray[3], (not self.isAllianceClaim).list = not self.isAllianceClaim, isReachList
	self.fields.List:setNumItems(#self.listArray)
end
function allianceOptionsViewPanel:uiOptionsBack(target, data)
	dump(data, "uiOptionsBack====")
	if data.index == 1 then
		self.tempTable[data.val] = data.isSel
		for k, v in ipairs(self.listArray[1].list) do
			if v.val == data.val then
				v.isSel = data.isSel
			end
		end
	elseif data.index == 2 then
		self.isFullMember = data.val
		if not data.isSel then
			self.isFullMember = nil
		end
		for k, v in ipairs(self.listArray[2].list) do
			v.isSel = v.val == self.isFullMember
		end
	elseif data.index == 3 then
		self.isAllianceClaim = data.val
		if not data.isSel then
			self.isAllianceClaim = nil
		end
		for k, v in ipairs(self.listArray[3].list) do
			v.isSel = v.val == self.isAllianceClaim
		end
	end
	self.fields.List:setNumItems(#self.listArray)
end
function allianceOptionsViewPanel:cancelAllButton()
	for lang, isSel in pairs(self.tempTable) do
		self.tempTable[lang] = false
	end
	for k, v in ipairs(self.listArray) do
		for ki, vi in ipairs(v.list) do
			vi.isSel = false
		end
	end
	self.fields.List:setNumItems(#self.listArray)
	self.isFullMember = nil
	self.isAllianceClaim = nil
end
function allianceOptionsViewPanel:btnYesClick()
	SoraDPlaySound()
	local _ENV, tempTable = SoraDPlaySound, SoraDPlaySound
	for lang, isSel in pairs(self.tempTable) do
		if isSel then
			table.insert(tempTable, lang)
		end
	end
	allianceQuery:reqAllianceListByCondition(self.tempTable, nil, self.isFullMember, self.isAllianceClaim)
end
function allianceOptionsViewPanel:btnNoClick()
	SoraDPlaySound()
	self:cancelAllButton()
end
return allianceOptionsViewPanel
