local gametop = gModuleMgr.getObject("gametop")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local WorldMapTroopsDetailsPanel = class("WorldMapTroopsDetailsPanel", baseFguiPanel)
function WorldMapTroopsDetailsPanel:ctor(...)
	self.super.ctor(self, ...)
	print("WorldMapTroopsDetailsPanel:ctor", self.viewName)
end
function WorldMapTroopsDetailsPanel:getPackageList()
	if not self._packageList then
		_UPVALUE1_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "BuildWatchTower"
	end
	return self._packageList
end
function WorldMapTroopsDetailsPanel:onInit()
	print("=======WorldMapTroopsDetailsPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_019"))
	self.fields.Text_notice:setString(i18n("common_text_3025"))
	self.fields.Button_back:setString(i18n("common_text_017"))
	self.fields.Button_back:addClickListener(handler(self, self.btnBackClick))
	self.fields.List:setItemRenderer(handler(self, self.onItemRederer))
end
function WorldMapTroopsDetailsPanel:onShow()
	print("=======WorldMapTroopsDetailsPanel:onShow")
	self:initData(self.proxy.param.troopsData, self.proxy.param.allianceName, self.proxy.param.otherData)
end
function WorldMapTroopsDetailsPanel:initData(troopsData, allianceName, otherData)
