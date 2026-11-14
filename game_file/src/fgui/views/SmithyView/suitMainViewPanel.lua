local equipDesRead = include("equipDesRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local suitMainViewPanel = class("suitMainViewPanel", baseFguiPanel)
function suitMainViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("suitMainViewPanel:ctor", self.viewName)
end
function suitMainViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function suitMainViewPanel:onInit()
	print("=======suitMainViewPanel:onInit")
	self.suitList, _ENV = print, print
	self.fields.Com_title:initData(i18n("suit_title_01"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
end
function suitMainViewPanel:onShow()
	print("=======suitMainViewPanel:onShow")
	self.fields.Com_bg:setGradientColor()
	if not equipDesRead.getSuitInfoList() then
		local _ENV, suitList = equipDesRead.getSuitInfoList(), equipDesRead.getSuitInfoList()
	end
	for k, v in pairs(suitList) do
		_ENV = nil
		;(nil).suitID = k
		;(nil).suitList = v
		table.insert(self.suitList, nil)
	end
	table.sort(self.suitList, function(a, b)
		return a.suitID < b.suitID
	end)
	self:initData()
end
function suitMainViewPanel:onItemRenderer(index, obj)
	obj:initData(self.suitList[index + 1])
end
function suitMainViewPanel:initData()
	self.fields.List:setNumItems(#self.suitList)
end
function suitMainViewPanel:onClickHelp()
	SoraDPlaySound()
	if IsArClient then
		userSDKManager.showFAQSection(gSDKDef.FAQSingleType.EQUIPMENT_SUIT)
	else
		userSDKManager.showFAQSection(gSDKDef.FAQSectionType.EQUIPMENT_SUIT)
	end
end
return suitMainViewPanel
