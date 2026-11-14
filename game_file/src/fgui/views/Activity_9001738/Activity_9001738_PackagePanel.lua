local activity_9001738_Read = include("activity_9001738_Read")
local activity_9001738_Ctrl = SoraDGetCtrl("activity_9001738_Ctrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001738_PackagePanel = class("Activity_9001738_PackagePanel", baseFguiPanel)
function Activity_9001738_PackagePanel:ctor(...)
	self.isLRU = true
	Activity_9001738_PackagePanel.super.ctor(self, ...)
	print("Activity_9001738_PackagePanel:ctor", self.viewName)
	self.activityID = gActivityTimeActivityID.GREEN_GRASS_FLIP_ACTIVITY
end
function Activity_9001738_PackagePanel:onInit()
	print("=======Activity_9001738_PackagePanel:onInit")
	self:fixChildrenPos()
	self.fields.listPackage:setDefaultItem("ui://Activity_9001738/Com_9001738_Package")
	self.fields.listPackage:setItemRenderer(handler(self, self.itemRenderer_listPackage))
	self.fields.Panel_bg:setString(i18n("kindofwar_btn_01"))
end
function Activity_9001738_PackagePanel:onClickHelp()
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("memory_flip_text_01")
	uiManager:show("RuleView", nil)
end
function Activity_9001738_PackagePanel:endShow()
	print("=======Activity_9001738_PackagePanel:endShow")
	self.packages = activity_9001738_Read.getDailyRechargeCfgList()
	self:refreshPackageList()
end
function Activity_9001738_PackagePanel:refreshPackageList()
	self.fields.listPackage:setNumItems(#self.packages)
	for i = 1, #self.packages do
		self.fields.listPackage:getChildAt(i - 1):initData(self.packages[i])
	end
end
function Activity_9001738_PackagePanel:itemRenderer_listPackage(index, obj)
	local data = self.packages[index + 1]
	obj:initData(data)
end
return Activity_9001738_PackagePanel
