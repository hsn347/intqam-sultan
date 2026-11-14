local baseFguiPanel = require("fgui.base.baseFguiPanel")
local intetiorDonateRankPanel = class("intetiorDonateRankPanel", baseFguiPanel)
function intetiorDonateRankPanel:ctor(...)
	self.super.ctor(self, ...)
	print("intetiorDonateRankPanel:ctor", self.viewName)
end
function intetiorDonateRankPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function intetiorDonateRankPanel:onInit()
	print("=======intetiorDonateRankPanel:onInit")
	self.fields.Panel_bg:setString(i18n("parliament_title_01"))
	_ENV = self.fields.Panel_bg.setString
	_ENV, _ENV, self.fields.Panel_bg.setString.defaultClick = i18n("parliament_title_01")
	i18n("parliament_title_01").title = i18n("parliament_title_04")
	_ENV, self.fields.Panel_bg[1], i18n("parliament_title_01").tag = i18n("parliament_title_01")
	i18n("parliament_title_01").title = i18n("parliament_title_05")
	self.fields.Panel_bg.setString.tabsetArray, self.fields.Panel_bg[2], i18n("parliament_title_01").tag = self.fields.Panel_bg, i18n("parliament_title_01")
	local self.fields.Panel_bg.setString.callback, tableData = handler(self, self.onClickTab), self.fields.Panel_bg.setString
	self.fields.com_TabW:initView(tableData)
end
function intetiorDonateRankPanel:onShow()
	print("=======intetiorDonateRankPanel:onShow")
end
function intetiorDonateRankPanel:onClickTab(tag)
	self.controllers.c1:setSelectedIndex(tag - 1)
end
return intetiorDonateRankPanel
