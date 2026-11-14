local baseFguiPanel = require("fgui.base.baseFguiPanel")
local commonRankAwardViewPanel = class("commonRankAwardViewPanel", baseFguiPanel)
function commonRankAwardViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("commonRankAwardViewPanel:ctor", self.viewName)
end
function commonRankAwardViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function commonRankAwardViewPanel:onInit()
	print("=======commonRankAwardViewPanel:onInit")
	self.awardList = self.proxy.param.awardList
	self.fields.List_Award:setItemRenderer(handler(self, self.onAwardItemRederer))
	self.fields.Panel_bg:setTitle(self.proxy.param.title or i18n("hero_title_02"))
	if self.param.tipStr then
		self.controllers.c1:setSelectedIndex(1)
		self.fields.Text_Tips:setString(self.param.tipStr)
	end
end
function commonRankAwardViewPanel:onShow()
	print("=======commonRankAwardViewPanel:onShow")
	self.fields.List_Award:setNumItems(#self.awardList)
end
function commonRankAwardViewPanel:onAwardItemRederer(index, obj)
	obj:initData(self.awardList[index + 1])
end
return commonRankAwardViewPanel
