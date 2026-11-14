local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local allianceSetting = SoraDGetCtrl("allianceSetting")
local baseComponent = require("fgui.base.baseComponent")
local changeAllianceLanguageNode = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceManageView/changeAllianceLanguageNode", changeAllianceLanguageNode)
function changeAllianceLanguageNode:onInit()
	self.tableLanguageList, _ENV = nil, nil
	self.ownLanguage = gLanguage.ALL
	self.fields.Text_notice:setString(i18n("common_text_250"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function changeAllianceLanguageNode:onShow()
end
function changeAllianceLanguageNode:registerEvent()
	SoraDAddMessage(self, "MESSAGE_ALLIANCE_UI_MANAGER_SETTING_LANGUAGE_SELECT", handler(self, self.languageSelect))
end
function changeAllianceLanguageNode:languageSelect(target, data)
	self.ownLanguage = data.languageID
	self.fields.List:setNumItems(#self.tableLanguageList)
	allianceSetting:reqModifyLanguage(self.ownLanguage)
end
function changeAllianceLanguageNode:onItemRenderer(index, obj)
	obj:initData(self.tableLanguageList[index + 1], self.ownLanguage)
end
function changeAllianceLanguageNode:initData()
	self.tableLanguageList = permissionCtrl:getLanguageMenu()
	self.ownLanguage = allianceMgr:getAllianceProperty("language")
	self.fields.List:setNumItems(#self.tableLanguageList)
	self.fields.List:setHeight(math.ceil(#self.tableLanguageList / 2) * 60 + 18)
end
return changeAllianceLanguageNode
