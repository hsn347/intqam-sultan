local activity_9001628_Read = include("activity_9001628_Read")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001628_ShowPackagePanel = class("Activity_9001628_ShowPackagePanel", baseFguiPanel)
function Activity_9001628_ShowPackagePanel:ctor(...)
	Activity_9001628_ShowPackagePanel.super.ctor(self, ...)
	print("Activity_9001628_ShowPackagePanel:ctor", self.viewName)
end
function Activity_9001628_ShowPackagePanel:onInit()
	print("=======Activity_9001628_ShowPackagePanel:onInit")
	self.Text_title = SoraDGetChildByName(self, "Text_title")
	self.Text_title:setString(i18n("common_text_4458"))
	self.list = SoraDGetChildByName(self, "list")
	self.list:setItemRenderer(handler(self, self.onItemRenderer))
	self.packageList = activity_9001628_Read:getMerchantPackageInfoList()
	self:initScroll()
end
function Activity_9001628_ShowPackagePanel:onShow()
	print("=======Activity_9001628_ShowPackagePanel:onShow")
end
function Activity_9001628_ShowPackagePanel:initScroll()
	self.packageInfos, _ENV = nil, nil
	for i, v in ipairs(self.packageList) do
		local packageInfo = activity_9001628_Read:getTreasureHuntPackageInfo(v.packageId)
		table.insert(self.packageInfos, packageInfo)
	end
	self.list:setNumItems(#self.packageInfos)
end
function Activity_9001628_ShowPackagePanel:onItemRenderer(index, obj)
	local data = self.packageInfos[index + 1]
	local price = data.price
	obj:initData(data, price)
end
return Activity_9001628_ShowPackagePanel
