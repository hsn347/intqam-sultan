local permissionCtrl = gModuleMgr.getObject("permissionCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local allianceDesRead = include("allianceDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceManageViewPanel = class("allianceManageViewPanel", baseFguiPanel)
function allianceManageViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("allianceManageViewPanel:ctor", self.viewName)
end
function allianceManageViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceManageViewPanel:onInit()
	print("=======allianceManageViewPanel:onInit")
	self.tableManageData, _ENV = print, print
	self.fields.Com_title:initData(i18n("common_text_187"), handler(self, self.onClickClose))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function allianceManageViewPanel:onShow()
	print("=======allianceManageViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	self:initData()
end
function allianceManageViewPanel:onItemRenderer(index, obj)
	obj:initData(self.tableManageData[index + 1])
end
function allianceManageViewPanel:initData(target, data)
	self.tableManageData = permissionCtrl:getManageMenu()
	self:updateFlag()
	self.fields.List:setNumItems(#self.tableManageData)
end
function allianceManageViewPanel:updateFlag(target, data)
	local flagNode = allianceDesRead.getFlagNode(allianceMgr:getAllianceProperty("flag"))
	flagNode:setPosition(5, 5)
	self.fields.Node_flag:clearContent()
	self.fields.Node_flag:setContent(flagNode)
end
function allianceManageViewPanel:endShow()
	if allianceDesRead.getPlayerConquestWarMigration() or allianceDesRead.getPlayerBattleGroundMigration() then
		self:close()
	end
end
return allianceManageViewPanel
